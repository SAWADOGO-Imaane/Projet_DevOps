# Guide de Sécurité DevSecOps

## 🔐 Politique de Sécurité

### 1. Gestion des Secrets

**Localisation**: `security/secrets-config.md`

#### Secrets Kubernetes
```bash
# Créer un secret
kubectl create secret generic app-secrets \
  --from-literal=DB_USER=appuser \
  --from-literal=DB_PASS=secure_password \
  -n prediction-app

# Voir les secrets (encodés)
kubectl get secrets -n prediction-app

# Décrire un secret
kubectl describe secret app-secrets -n prediction-app
```

#### Secrets avec Vault (Production)
```bash
# Installer Vault

# Stocker secrets
vault kv put secret/prediction-app DB_USER=appuser DB_PASS=secret

# Récupérer
vault kv get secret/prediction-app
```

#### ❌ NE JAMAIS
- Commiter les secrets en clair dans Git
- Exposer les secrets dans les logs
- Partager les secrets par email
- Utiliser secrets par défaut en production

---

### 2. RBAC (Role-Based Access Control)

**Localisation**: `security/rbac/rbac-policies.yaml`

#### Rôles définis:

1. **Admin** (`admin-sa`)
   - Accès complet au cluster
   - Utilisé par: DevOps engineers
   - Audit: Loggé complètement

2. **Developer** (`developer-sa`)
   - Déboguer les pods
   - Voir les logs
   - Créer/modifier ConfigMaps
   - INTERDITS: Déletes, modifications Deployments

3. **ReadOnly** (`readonly-sa`)
   - Lecture seule
   - Utilisé par: Observateurs, auditeurs

4. **Monitoring** (`monitoring-sa`)
   - Accès limité pour Prometheus

5. **CI/CD** (`cicd-sa`)
   - Déploiements
   - Utilisé par: Jenkins, GitLab CI

#### Utilisation
```bash
# Ajouter user au rôle Developer
kubectl create rolebinding dev-binding \
  --clusterrole=developer-role \
  --serviceaccount=prediction-app:developer-sa

# Tester: Changer de context
kubectl --user=developer

# Vérifier permissions
kubectl auth can-i get pods --as=system:serviceaccount:prediction-app:developer-sa
```

---

### 3. Pod Security Policies (PSP)

**Localisation**: `security/policies/pod-security-policy.yaml`

#### Restrictions:
- ❌ Pas de privileged containers
- ❌ Pas d'escalade de privilèges
- ✅ Utilisateur non-root (UID > 1000)
- ✅ Filesystem en lecture seule (où possible)
- ✅ Pas d'accès root

#### Application
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
    fsGroup: 1000
  containers:
  - name: app
    securityContext:
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
      capabilities:
        drop:
        - ALL
```

---

### 4. NetworkPolicy

**Localisation**: `security/network-policies/network-policies.yaml`

#### Principes:
- **Deny All par défaut**: Sauf si explicitement permis
- **Whitelist**: Permettre que le nécessaire
- **Minimal**: Accès au strict minimum requis

#### Exemple:
```yaml
# Permettre uniquement depuis nginx
ingress:
- from:
  - podSelector:
      matchLabels:
        app: nginx
  ports:
  - port: 8501
```

---

### 5. Analyse de Code (SonarQube)

**Pipeline Jenkins**:
```groovy
stage('🔍 Code Quality') {
    steps {
        sh '''
            sonar-scanner \
              -Dsonar.projectKey=prediction-app \
              -Dsonar.sources=app \
              -Dsonar.host.url=${SONAR_HOST}
        '''
    }
}
```

#### Scan des vulnérabilités:
```bash
# Dépendances
snyk test

# Docker image
trivy image prediction-app:latest

# Code SAST
bandit -r app/
```

---

### 6. Scanning des Images Docker

#### Outils:
- **Trivy**: Scan vulnérabilités images
- **Docker Scan**: Natif Docker
- **Snyk**: Dépendances + images

```bash
# Trivy
trivy image prediction-app:latest

# Snyk
docker scan prediction-app:latest
```

---

### 7. Secrets Sensibles en .env

**Fichier**: `.env` (Ignorer dans Git)

```bash
# Template
cp app/.env.example app/.env

# Éditer avec tes valeurs
nano app/.env
```

**Nunca commiter**: `DB_PASS`, `SECRET_KEY`, `API_KEY`

---

### 8. TLS/HTTPS

#### Certificate Management:
```bash
# Générer certificat auto-signé (DEV)
openssl req -x509 -newkey rsa:4096 \
  -keyout key.pem -out cert.pem -days 365

# Créer secret K8s
kubectl create secret tls tls-certs \
  --cert=cert.pem --key=key.pem \
  -n prediction-app

# Ingress avec TLS
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
spec:
  tls:
  - hosts:
    - app.local
    secretName: tls-certs
```

---

### 9. Audit Logging

**Kubernetes Audit**:
```yaml
# /etc/kubernetes/audit-policy.yaml
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
- level: RequestResponse
  resources: ["secrets", "configmaps"]
```

---

### 10. Checkliste Sécurité

- [ ] Secrets chiffrés (K8s Secrets, Vault)
- [ ] RBAC appliqué à tous les rôles
- [ ] NetworkPolicy restrictive
- [ ] PSP or Pod Security Standards
- [ ] Scanning images Docker (Trivy)
- [ ] SonarQube dans pipeline
- [ ] HTTPS/TLS configuré
- [ ] Audit logging activé
- [ ] Secret rotation en place
- [ ] Monitoring de sécurité (Falco, etc.)
- [ ] Backup & DR testés
- [ ] Documenté pour l'équipe

---

## 📞 Support

Pour questions sécurité: security@prediction-app.local
