# 📚 Guide: Architecture DevSecOps - Application IA

## 📖 Vue d'Ensemble du Projet

Ce guide couvre l'implémentation complète d'une **architecture DevSecOps** pour une application web d'analyse prédictive avec:

- ✅ **Git**: Versioning structuré
- ✅ **CI/CD**: Jenkins pipeline complet  
- ✅ **Docker**: Images optimisées et sécurisées
- ✅ **Kubernetes**: Orchestration et scaling
- ✅ **Terraform**: Infrastructure as Code
- ✅ **Ansible**: Automatisation
- ✅ **SonarQube**: Analyse de qualité
- ✅ **RBAC, Secrets, NetworkPolicy**: Sécurité DevSecOps

---

## 🚀 Quick Start (5 minutes)

### 1️⃣ Démarrer Localement
```bash
# Cloner et naviguer
cd "Documents/S8/Projet DevOps"

# Créer environnement Python
python -m venv venv
.\venv\Scripts\activate  # Windows

# Installer dépendances
pip install -r app/requirements.txt

# Lancer application
streamlit run app/streamlit_app.py
# Accéder: http://localhost:8501
```

### 2️⃣ Avec Docker
```bash
# Builder image
docker build -t prediction-app:latest -f docker/Dockerfile .

# Lancer
docker run -p 8501:8501 prediction-app:latest

# Ou avec docker-compose (stack complète)
docker-compose up -d
```

### 3️⃣ Sur Kubernetes
```bash
# Appliquer manifests
kubectl apply -f kubernetes/

# Vérifier
kubectl get pods -n prediction-app

# Accéder (port-forward)
kubectl port-forward svc/prediction-app 8501:8501 -n prediction-app
```

### 4️⃣ Avec Terraform
```bash
cd terraform
terraform init
terraform apply -auto-approve
```

---

## 📁 Structure du Projet Expliquée

```
Projet DevOps/
│
├── app/                      ← 🎯 Application source
│   ├── streamlit_app.py      (Application principale)
│   ├── config.py             (Configuration)
│   ├── __init__.py           (Initialisation)
│   ├── requirements.txt       (Dépendances Python)
│   ├── tests/                (Tests unitaires)
│   └── .env.example          (Template variables)
│
├── docker/                   ← 🐳 Containerisation
│   ├── Dockerfile            (Multi-stage build)
│   ├── .dockerignore         (Fichiers exclus)
│   └── nginx.conf            (Reverse proxy)
│
├── kubernetes/               ← ☸️ Orchestration
│   ├── 00-namespace.yaml     (Namespace & ConfigMap)
│   ├── 01-configmap.yaml     (Configuration)
│   ├── 02-secrets.yaml       (Secrets chiffrés)
│   ├── 03-deployment.yaml    (Deployment avec probes)
│   ├── 04-service.yaml       (Services)
│   ├── 05-hpa.yaml           (Autoscaling)
│   ├── 06-network-policy.yaml (Sécurité réseau)
│   ├── 07-resource-quota.yaml (Quotas & Limits)
│   ├── 08-ingress.yaml       (Ingress)
│   └── 09-rbac.yaml          (RBAC)
│
├── terraform/                ← 🏗️ Infrastructure as Code
│   ├── main.tf               (Configuration Kubernetes)
│   ├── variables.tf          (Variables)
│   ├── outputs.tf            (Outputs)
│   └── terraform.tfvars      (Valeurs)
│
├── ansible/                  ← 🤖 Automatisation
│   ├── site.yml              (Playbook principal)
│   ├── ansible.cfg           (Configuration)
│   ├── inventory/
│   │   └── hosts             (Inventaire)
│   ├── vars/
│   │   ├── main.yml          (Variables)
│   │   └── secrets.yml       (Secrets)
│   └── roles/
│       ├── docker/           (Rôle Docker installation)
│       ├── kubernetes/       (Rôle K8s installation)
│       ├── jenkins/          (Rôle Jenkins installation)
│       └── monitoring/       (Rôle Monitoring)
│
├── jenkins/                  ← 🔄 CI/CD Pipeline
│   ├── Jenkinsfile           (Pipeline déclaratif)
│   ├── docker-compose.yml    (Jenkins dans Docker)
│   ├── casc.yaml             (Configuration Jenkins)
│   └── plugins.txt           (Liste des plugins)
│
├── security/                 ← 🔐 Sécurité DevSecOps
│   ├── rbac/
│   │   └── rbac-policies.yaml (Admin/Dev/ReadOnly roles)
│   ├── policies/
│   │   └── pod-security-policy.yaml (PSP restrictive)
│   ├── network-policies/
│   │   └── network-policies.yaml (Deny All par défaut)
│   └── SECURITY.md           (Guide sécurité)
│
├── docs/                     ← 📚 Documentation
│   ├── SETUP.md              (Guide installation)
│   ├── ARCHITECTURE.md       (Design système)
│   ├── SECURITY.md           (Politique sécurité)
│   └── GUIDE.md              (Ce fichier)
│
├── docker-compose.yml        ← 🐳 Stack locale complète
├── Makefile                  ← 🛠️ Commandes utiles
├── .gitignore               ← Git configuration
└── README.md                ← Présentation du projet
```

---

## 🎯 Parcours Déploiement

### Phase 1: Développement Local
**Objectif**: Tester l'application localement avant containerisation

```bash
# 1. Setup Python
python -m venv venv && venv\Scripts\activate

# 2. Installer deps
pip install -r app/requirements.txt

# 3. Lancer app
streamlit run app/streamlit_app.py

# 4. Tester application
# → http://localhost:8501
```

**Checkpoint**: ✅ Application fonctionne

---

### Phase 2: Docker & Containerisation
**Objectif**: Packager l'app dans une image Docker optimisée

```bash
# 1. Build image
docker build -t prediction-app:latest -f docker/Dockerfile .

# 2. Scanner vulnérabilités
trivy image prediction-app:latest

# 3. Lancer container
docker run -p 8501:8501 prediction-app:latest

# 4. Tester
# → http://localhost:8501 (via container)
```

**Checkpoint**: ✅ Image optimisée et sécurisée

---

### Phase 3: Kubernetes Local
**Objectif**: Déployer sur Kubernetes local (Docker Desktop/Minikube)

```bash
# 1. Vérifier K8s
kubectl cluster-info

# 2. Créer namespace
kubectl create namespace prediction-app

# 3. Déployer manifests
kubectl apply -f kubernetes/

# 4. Vérifier pods
kubectl get pods -n prediction-app

# 5. Port-forward
kubectl port-forward svc/prediction-app 8501:8501 -n prediction-app

# 6. Tester
# → http://localhost:8501 (via K8s)
```

**Checkpoint**: ✅ Déploiement K8s fonctionnel

---

### Phase 4: Jenkins CI/CD
**Objectif**: Automatiser build, test, deploy

```bash
# 1. Démarrer Jenkins
cd jenkins && docker-compose up -d

# 2. Accéder Jenkins
# → http://localhost:8080

# 3. Récupérer admin password
docker-compose logs jenkins | grep "Admin password"

# 4. Créer pipeline
# - New Item → Pipeline
# - Pointer vers jenkins/Jenkinsfile
# - Build now

# 5. Observer pipeline
# - Checkout → Build → Test → Scan → Deploy
```

**Checkpoint**: ✅ Pipeline CI/CD automatisé

---

### Phase 5: Infrastructure as Code (Terraform)
**Objectif**: Provisionner infra via Terraform

```bash
# 1. Naviguer Terraform
cd terraform

# 2. Initialiser
terraform init

# 3. Planifier
terraform plan

# 4. Appliquer
terraform apply -auto-approve

# 5. Vérifier
kubectl get all -n prediction-app
```

**Checkpoint**: ✅ Infrastructure gérée via code

---

### Phase 6: Sécurité DevSecOps
**Objectif**: Appliquer RBAC, NetworkPolicy, PSP

```bash
# 1. RBAC
kubectl apply -f security/rbac/rbac-policies.yaml

# 2. NetworkPolicy
kubectl apply -f security/network-policies/network-policies.yaml

# 3. PSP (optionnel)
kubectl apply -f security/policies/pod-security-policy.yaml

# 4. Vérifier
kubectl get role,rolebinding,networkpolicy -n prediction-app
```

**Checkpoint**: ✅ Sécurité en place

---

## 🔑 Concepts Clés

### 1. GitOps
```
Git repo (source of truth)
    ↓ Webhook
Jenkins Pipeline
    ↓
Deploy → K8s
    ↓ (declarative)
Desired state
```

### 2. Infrastructure as Code
```
Terraform Code
    ↓ (version en Git)
Infrastructure Resources
    ↓ (reproducible)
Any environment
```

### 3. Sécurité en Couches
```
Network (TLS, Firewall)
    ↓
Authentication (Tokens)
    ↓
Authorization (RBAC)
    ↓
Pod Security (PSP)
    ↓
Secrets (encrypted)
    ↓
Audit Logging
```

### 4. Deployment Strategy
```
Rolling Update:
Old pod → New pod (one by one)
Zero downtime ✅

Blue/Green (optional):
Blue (old) → Green (new)
Instant rollback possible

Canary (optional):
5% → 20% → 50% → 100%
Risk mitigation
```

---

## 📊 Comparaison: Avant vs Après

### AVANT (Sans DevSecOps)
```
❌ Deployment manuel
❌ Pas de tests automatisés  
❌ Secrets en clair dans code
❌ Pas de monitoring
❌ Downtime pendant deployments
❌ Pas d'audit/logs
❌ Scaling manuel
❌ Pas de rollback
```

### APRÈS (Avec DevSecOps)
```
✅ Deployment automatisé (Jenkins)
✅ Tests en chaque commit
✅ Secrets chiffrés (Kubernetes Secrets)
✅ Monitoring natif (Prometheus optional)
✅ Zero-downtime (rolling updates)
✅ Audit logs complètes
✅ Scaling automatique (HPA)
✅ Rollback en 1 clic
✅ Sécurité multi-couches
✅ Infrastructure reproductible
```

---

## 🛠️ Outils par Fonction

| Fonction | Outil | Config | Fichier |
|----------|------|--------|---------|
| **Versioning** | Git | GitHub/GitLab | - |
| **CI/CD** | Jenkins | Pipeline déclaratif | `jenkins/Jenkinsfile` |
| **Build/Test** | Docker + pytest | Multi-stage | `docker/Dockerfile` |
| **Code Quality** | SonarQube | Intégré pipeline | `jenkins/Jenkinsfile` |
| **Security Scan** | Trivy, Snyk | Pipeline stages | `jenkins/Jenkinsfile` |
| **Orchestration** | Kubernetes | YAML manifests | `kubernetes/*.yaml` |
| **IaC** | Terraform | HCL code | `terraform/main.tf` |
| **Automation** | Ansible | Playbooks YAML | `ansible/site.yml` |
| **Access Control** | RBAC K8s | ServiceAccount, Role | `security/rbac/*.yaml` |
| **Networking** | NetworkPolicy | K8s resource | `security/network-policies/` |
| **Monitoring** | K8s native | Logs/Events | `kubectl logs` |

---

## 📈 Métriques Clés

Après implémentation, vous devriez avoir:

- **Deployment Frequency**: 1-5x/jour (vs manual 1x/week)
- **Lead Time for Changes**: <1h (vs 1-2 days)
- **MTTR (Mean Time To Recovery)**: <15min (auto-rollback)
- **Change Failure Rate**: <15% (tests + scans)
- **Test Coverage**: >80%
- **Vulnerability Scan**: 0 criticals
- **RBAC Compliance**: 100%
- **Uptime**: 99.9%+

---

## 🎓 Ressources d'Apprentissage

- [Kubernetes Official Docs](https://kubernetes.io/docs)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Ansible User Guide](https://docs.ansible.com/)
- [Jenkins User Handbook](https://www.jenkins.io/doc/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [OWASP DevSecOps Guide](https://owasp.org/)

---

## ❓ Questions Fréquentes

### Q: Puis-je utiliser ce projet en production?
**A**: Partiellement. Il faut configurer:
- Vraie base de données (RDS, Cloud SQL)
- Persistence volumes
- SSL certificates réels (Let's Encrypt)
- Secrets management (HashiCorp Vault)
- Monitoring/Logging (ELK, Datadog)

### Q: Comment scaler au-delà de 5 replicas?
**A**: Augmenter les limites HPA:
```yaml
maxReplicas: 10  # ou plus
```

### Q: Comment gérer les secrets en production?
**A**: Utiliser Vault ou cloud provider secrets:
```bash
# AWS Secrets Manager
# Azure Key Vault
# Google Secret Manager
# HashiCorp Vault
```

### Q: Comment monitorer l'application?
**A**: Options:
1. Kubernetes native (logs, events)
2. Prometheus + Grafana
3. Datadog, New Relic, etc.

---

## ✅ Checklist Déploiement

- [ ] Application fonctionne localement
- [ ] Docker image buildée et scannée
- [ ] Kubernetes manifests appliqués
- [ ] Services accessible via Ingress
- [ ] RBAC configuré
- [ ] Secrets créés (non en clair)
- [ ] NetworkPolicy appliquée
- [ ] HPA testée
- [ ] Pipeline Jenkins fonction
- [ ] SonarQube scan passé
- [ ] Rollback testé
- [ ] Documentation à jour

---

**Vous êtes maintenant prêt pour un déploiement professionnel! 🚀**

Pour des questions: `support@prediction-app.local`
