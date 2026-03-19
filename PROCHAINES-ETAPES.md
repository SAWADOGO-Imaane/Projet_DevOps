# 🚀 Prochaines Étapes - Après Initialisation

## Phase 1: Validation Locale (1-2 jours)

### 1. Tester Application Streamlit
```bash
cd "Documents/S8/Projet DevOps"

# Créer venv
python -m venv venv
.\venv\Scripts\activate

# Installer dépendances
pip install -r app/requirements.txt

# Lancer
streamlit run app/streamlit_app.py

# Vérifier: http://localhost:8501
```
✅ **Checkpoint**: Application responsive et fonctionnelle

---

### 2. Tester Docker Build
```bash
# Build image
docker build -t prediction-app:latest -f docker/Dockerfile .

# Vérifier success
docker images | grep prediction-app

# Run container
docker run -p 8501:8501 prediction-app:latest

# Tester: http://localhost:8501
```
✅ **Checkpoint**: Image Docker optimisée crée

---

### 3. Tests Unitaires
```bash
# Depuis venv
cd app
pytest tests/ -v --cov=. --cov-report=html

# Rapport de couverture
open htmlcov/index.html
```
✅ **Checkpoint**: Tests passent, couverture >80%

---

## Phase 2: Kubernetes Local (2-3 jours)

### 1. Vérifier K8s
```bash
# Vérifier Docker Desktop K8s
kubectl cluster-info
kubectl get nodes
```

### 2. Créer Namespace & Secrets
```bash
# Namespace
kubectl create namespace prediction-app

# Secrets
kubectl create secret generic app-secrets \
  --from-literal=DB_USER=appuser \
  --from-literal=DB_PASS=secure_password123 \
  -n prediction-app
```

### 3. Déployer Manifests
```bash
# Tous les manifests
kubectl apply -f kubernetes/

# Vérifier
kubectl get all -n prediction-app

# Port-forward
kubectl port-forward svc/prediction-app 8501:8501 -n prediction-app
```

### 4. Tester HPA
```bash
# Générer load
kubectl run -i --tty load-generator --rm \
  --image=busybox:1.28 \
  --restart=Never \
  -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://prediction-app:8501; done"

# Observer scaling
kubectl get hpa -n prediction-app -w

# Vérifier replicas augmentent
kubectl get pods -n prediction-app -w
```
✅ **Checkpoint**: HPA fonctionne, scaling de 2 à 5 pods

---

## Phase 3: Pipeline Jenkins (2-3 jours)

### 1. Démarrer Jenkins
```bash
cd jenkins
docker-compose up -d

# Accéder
# http://localhost:8080

# Admin password
docker-compose logs jenkins | grep "Admin password"
```

### 2. Configuration Initiale
1. Installer plugins suggérés
2. Créer admin user
3. Configurer credentials (GitHub, Docker)

### 3. Créer Pipeline
1. New Item → Pipeline
2. Configure:
   - Definition: Pipeline script from SCM
   - SCM: Git
   - Repository URL: `<votre-repo>`
   - Script path: `jenkins/Jenkinsfile`
3. Build & observer stages

### 4. Tester Complet
```bash
# Faire un commit
git add . && git commit -m "test pipeline"
git push

# Observer Jenkins
# - Webhook trigger
# - Pipeline stages exécutent
# - Artefacts archivés
```
✅ **Checkpoint**: Pipeline complète sans erreurs

---

## Phase 4: SonarQube (1-2 jours)

### 1. Démarrer SonarQube
```bash
docker run -d -p 9000:9000 sonarqube:latest

# Accéder: http://localhost:9000
# Login: admin/admin
```

### 2. Créer Projet
```bash
sonar-scanner \
  -Dsonar.projectKey=prediction-app \
  -Dsonar.sources=app \
  -Dsonar.host.url=http://localhost:9000
```

### 3. Analyse Pipeline
```bash
# Jenkins stage exécute sonar-scanner automatiquement
# Observer quality gate dans Jenkins
```
✅ **Checkpoint**: SonarQube intégré et quality gates passent

---

## Phase 5: Sécurité (1-2 jours)

### 1. Appliquer RBAC
```bash
kubectl apply -f security/rbac/rbac-policies.yaml

# Test permissions
kubectl auth can-i get pods --as=system:serviceaccount:prediction-app:developer-sa
```

### 2. Appliquer NetworkPolicy
```bash
kubectl apply -f security/network-policies/network-policies.yaml

# Vérifier
kubectl get networkpolicy -n prediction-app
```

### 3. Appliquer PSP
```bash
kubectl apply -f security/policies/pod-security-policy.yaml
```

### 4. Scan Sécurité
```bash
# Docker image
trivy image prediction-app:latest

# Dépendances
pip install snyk
snyk test

# Code SAST
pip install bandit
bandit -r app/
```
✅ **Checkpoint**: 0 vulnerabilities critiques

---

## Phase 6: Terraform (1 jour)

### 1. Initialiser
```bash
cd terraform
terraform init
```

### 2. Planifier & Appliquer
```bash
# Voir changes
terraform plan -var-file=terraform.tfvars

# Appliquer
terraform apply -var-file=terraform.tfvars

# Vérifier
terraform output
```
✅ **Checkpoint**: Infrastructure gérée via code

---

## Phase 7: Ansible (1 jour)

### 1. Test Syntaxe
```bash
cd ansible
ansible-playbook site.yml --syntax-check -i inventory/hosts
```

### 2. Test Exécution
```bash
# Dry-run (test mode)
ansible-playbook site.yml -i inventory/hosts --check

# Exécuter (si serveurs disponibles)
ansible-playbook site.yml -i inventory/hosts -v
```
✅ **Checkpoint**: Automation playbooks fonctionnels

---

## Phase 8: Documentation (1-2 jours)

### 1. Compléter le Rapport
- [x] Architecture overview
- [x] Components détaillés
- [x] Pipeline CI/CD détaillé
- [x] Sécurité design
- [ ] Ajouter cas d'usage spécifiques
- [ ] Diagrammes ADR (Architecture Decision Records)
- [ ] Lessons learned

### 2. Créer README de Déploiement
- Instructions step-by-step
- Troubleshooting
- FAQ

### 3. Créer Runbooks
- Incident response
- Rollback procedures
- Scaling guidelines

---

## ✅ Checklist Avant Livraison

### Code Source
- [ ] Git history clean et bien structuré
- [ ] .gitignore complet
- [ ] Secrets non commités
- [ ] README.md clair

### Application
- [ ] Tests unitaires passent (>80% coverage)
- [ ] Linting pas d'erreurs (flake8)
- [ ] Documentation code présente

### Docker
- [ ] Image < 200MB (optimisée)
- [ ] Utilisateur non-root
- [ ] Health checks définis
- [ ] Trivy scan: 0 criticals

### Kubernetes
- [ ] Tous les manifests validés
- [ ] RBAC complet (5 roles)
- [ ] NetworkPolicy appliquée
- [ ] Resource quotas définis
- [ ] HPA testé

### Jenkins
- [ ] Pipeline s'exécute de A à Z
- [ ] Tous les stages passent
- [ ] Notifications configurées
- [ ] Artifacts archivés

### Sécurité
- [ ] SonarQube quality gates pass
- [ ] Snyk dépendances scan pass
- [ ] Bandit SAST pas de criticals
- [ ] Secrets chiffrés en place
- [ ] RBAC en place

### Terraform
- [ ] Configuration valide (`terraform validate`)
- [ ] Plan affiche les ressources
- [ ] Apply crée les ressources
- [ ] État versionné

### Ansible
- [ ] Syntaxe valide
- [ ] Playbooks exécutables
- [ ] Idempotence testée

### Documentation
- [ ] SETUP.md complet
- [ ] ARCHITECTURE.md détaillée
- [ ] SECURITY.md clairement expliquée
- [ ] Rapport technique 10-15 pages

---

## 📊 Timeline Estimée

```
Semaine 1:
  - Jours 1-2: Local setup + Docker
  - Jours 3-4: Kubernetes
  - Jour 5: Tests

Semaine 2:
  - Jours 1-2: Jenkins pipeline
  - Jours 3-4: Sécurité + Terraform
  - Jour 5: Ansible + Doc finale

Total: ~10 jours de travail
```

---

## 💡 Tips & Best Practices

### Git
```bash
# Commits atomiques
git commit -m "feature: add RBAC policies"

# Branches claires
git checkout -b feature/rbac-policies

# Tags pour versions
git tag -a v1.0.0 -m "Release v1.0.0"
```

### Docker
```bash
# Scan images toujours
docker scan prediction-app:latest

# Push avec tags multiples
docker tag prediction-app:latest prediction-app:v1.0.0
docker push prediction-app:latest prediction-app:v1.0.0
```

### Kubernetes
```bash
# Vérifier avant d'appliquer
kubectl apply -f manifest.yaml --dry-run=client

# Logs en temps réel
kubectl logs -f deployment/prediction-app -n prediction-app

# Describe pour debugging
kubectl describe deployment prediction-app -n prediction-app
```

### Jenkins
```bash
# Logs pipeline
docker-compose logs -f jenkins

# Console output
# → Jenkins UI → Pipeline → Build number → Console Output
```

### Terraform
```bash
# Always plan before apply
terraform plan | tee plan.out

# Destroy pour cleanup
terraform destroy -auto-approve
```

---

## 🔗 Ressources Utiles

- [Kubernetes Best Practices](https://kubernetes.io/docs/concepts/configuration/overview/)
- [Docker Security](https://docs.docker.com/develop/security-best-practices/)
- [OWASP DevSecOps](https://owasp.org/www-project-devsecops/)
- [Terraform AWS Best Practices](https://registry.terraform.io/modules/terraform-aws-modules)

---

## ❓ Aide & Support

Si vous rencontrez des problèmes:

1. **Vérifier les logs**:
   ```bash
   kubectl logs <pod-name> -n prediction-app
   docker logs <container-name>
   ```

2. **Vérifier la configuration**:
   ```bash
   kubectl describe pod <pod-name> -n prediction-app
   ```

3. **Consulter la documentation**:
   - [SETUP.md](docs/SETUP.md)
   - [ARCHITECTURE.md](docs/ARCHITECTURE.md)
   - [SECURITY.md](security/SECURITY.md)

4. **Community**:
   - Stack Overflow
   - Kubernetes Slack
   - GitLab/GitHub issues

---

**Bon luck! 🚀 Vous avez tous les outils pour réussir ce projet!**

Pour question: `support@prediction-app.local`
