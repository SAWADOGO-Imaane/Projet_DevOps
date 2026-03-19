# 📑 INDEX - Navigation Rapide du Projet

## 🎯 Démarrer Ici

```
Vous êtes nouveau?
    ↓
1. Lire: README.md
2. Lire: PROCHAINES-ETAPES.md
3. Lire: docs/GUIDE.md
    ↓
Prêt pour développement!
```

---

## 📂 Structure Fichiers

### 👨‍💻 Pour Développeurs

**Démarrer l'application**:
```
app/
├── streamlit_app.py        ← Appli principale
├── config.py               ← Configuration
├── requirements.txt        ← Dépendances
├── tests/                  ← Tests unitaires
└── .env.example            ← Template .env
```

**Commande rapide**:
```bash
pip install -r app/requirements.txt
streamlit run app/streamlit_app.py
```

---

### 🐳 Pour Ops/Docker

**Containerisation**:
```
docker/
├── Dockerfile              ← Image multistage
├── .dockerignore           ← Fichiers exclus
├── nginx.conf              ← Reverse proxy
└── docker-compose.yml      ← Stack locale

Commande:
docker build -t prediction-app:latest -f docker/Dockerfile .
docker-compose up -d
```

---

### ☸️ Pour DevOps Kubernetes

**Déploiement K8s**:
```
kubernetes/
├── 00-namespace.yaml       ← Namespace + ConfigMap
├── 01-configmap.yaml       ← Configuration
├── 02-secrets.yaml         ← Secrets
├── 03-deployment.yaml      ← Deployment (réplicas, probes)
├── 04-service.yaml         ← Services
├── 05-hpa.yaml             ← Auto-scaling
├── 06-network-policy.yaml  ← Sécurité réseau
├── 07-resource-quota.yaml  ← Quotas
├── 08-ingress.yaml         ← Ingress
└── 09-rbac.yaml            ← RBAC

Commande:
kubectl apply -f kubernetes/
kubectl get pods -n prediction-app
kubectl port-forward svc/prediction-app 8501:8501 -n prediction-app
```

---

### 🏗️ Pour IaC/Terraform

**Infrastructure as Code**:
```
terraform/
├── main.tf                 ← Config K8s
├── variables.tf            ← Variables
├── outputs.tf              ← Outputs
└── terraform.tfvars        ← Valeurs

Commande:
cd terraform && terraform init
terraform plan && terraform apply
```

---

### 🤖 Pour Automation/Ansible

**Playbooks Ansible**:
```
ansible/
├── site.yml                ← Playbook principal
├── ansible.cfg             ← Configuration
├── inventory/
│   └── hosts               ← Inventaire
├── vars/
│   ├── main.yml            ← Variables
│   └── secrets.yml         ← Secrets (vault)
└── roles/
    ├── docker/             ← Installation Docker
    ├── kubernetes/         ← Installation K8s
    ├── jenkins/            ← Installation Jenkins
    └── monitoring/         ← Installation Prometheus

Commande:
ansible-playbook site.yml -i inventory/hosts
```

---

### 🔄 Pour CI/CD/Jenkins

**Pipeline & Automation**:
```
jenkins/
├── Jenkinsfile             ← Pipeline déclaratif
├── casc.yaml               ← Config Jenkins as Code
├── plugins.txt             ← Plugins à installer
└── docker-compose.yml      ← Jenkins dans Docker

Commande:
cd jenkins && docker-compose up -d
# Accéder: http://localhost:8080
```

---

### 🔐 Pour Sécurité

**Politiques & RBAC**:
```
security/
├── rbac/
│   └── rbac-policies.yaml  ← 5 rôles K8s (Admin/Dev/ReadOnly/Monitoring/CI-CD)
├── policies/
│   └── pod-security-policy.yaml ← PSP restrictive
├── network-policies/
│   └── network-policies.yaml    ← Deny All par défaut
└── SECURITY.md             ← Guide sécurité complet
```

---

### 📚 Pour Documentation

**Guides & Rapports**:
```
docs/
├── SETUP.md                ← Installation step-by-step
├── ARCHITECTURE.md         ← Design système détaillé
├── GUIDE.md                ← Guide complet du projet
└── RAPPORT-TECHNIQUE.md    ← Rapport technique (10-15 pages)

root/
├── README.md               ← Présentation projet
├── PROCHAINES-ETAPES.md    ← Phases d'implémentation
├── Makefile                ← Commandes utiles
└── docker-compose.yml      ← Stack locale complète
```

---

## 🎯 Par Rôle

### 👨‍💼 Project Manager / Chef de Projet

**Fichiers clés**:
- [README.md](README.md) - Vue d'ensemble
- [docs/RAPPORT-TECHNIQUE.md](docs/RAPPORT-TECHNIQUE.md) - Rapport 10-15 pages
- [PROCHAINES-ETAPES.md](PROCHAINES-ETAPES.md) - Timeline & progression

**Mesures de succès**:
- All 7 exigences implémentées ✅
- Livrables documentés complets
- Tests passent 100%

---

### 👨‍💻 Développeur Backend/Frontend

**Fichiers clés**:
- [app/streamlit_app.py](app/streamlit_app.py) - Application principale
- [app/tests/](app/tests/) - Tests unitaires
- [docs/GUIDE.md](docs/GUIDE.md) - Guide développement

**Commandes essentielles**:
```bash
# Setup
python -m venv venv && venv\Scripts\activate
pip install -r app/requirements.txt

# Développer
streamlit run app/streamlit_app.py

# Tester
pytest app/tests/ -v --cov

# Build Docker
docker build -t prediction-app:latest -f docker/Dockerfile .
```

---

### 👨‍🔧 DevOps Engineer

**Fichiers clés**:
- [kubernetes/](kubernetes/) - Tous les manifests
- [terraform/](terraform/) - Infrastructure as Code
- [ansible/](ansible/) - Automation playbooks
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) - Design détaillé

**Commandes essentielles**:
```bash
# Kubernetes
kubectl apply -f kubernetes/
kubectl get all -n prediction-app
kubectl port-forward svc/prediction-app 8501:8501

# Terraform
cd terraform && terraform apply

# Ansible
ansible-playbook ansible/site.yml -i ansible/inventory/hosts
```

---

### 🔒 Security Engineer

**Fichiers clés**:
- [security/SECURITY.md](security/SECURITY.md) - Politique sécurité
- [security/rbac/](security/rbac/) - RBAC définitions
- [security/network-policies/](security/network-policies/) - NetworkPolicy
- [security/policies/](security/policies/) - Pod Security Policy

**Checklist sécurité**:
- [ ] RBAC 5 rôles appliqués
- [ ] NetworkPolicy Deny All défaut
- [ ] Secrets chiffrés
- [ ] PSP activée
- [ ] No hardcoded secrets
- [ ] Container images scannées
- [ ] SAST analysis (Bandit)
- [ ] Audit logging
- [ ] TLS configured

---

### 📊 CI/CD Engineer

**Fichiers clés**:
- [jenkins/Jenkinsfile](jenkins/Jenkinsfile) - Pipeline
- [jenkins/casc.yaml](jenkins/casc.yaml) - Jenkins Config
- [jenkins/docker-compose.yml](jenkins/docker-compose.yml) - Jenkins Container

**Pipeline Stages**:
```
Checkout → Build → Code Quality
→ Tests → Security Scan
→ Docker Build → Push Registry
→ Deploy Staging → Smoke Tests
→ [APPROVAL] → Deploy Production
```

---

## 📊 Features par Composant

### App (Streamlit)
- ✅ 4 modes: Analyse, Prédiction, Stats, Info
- ✅ Responsive interface
- ✅ Config via .env
- ✅ Tests unitaires 80%+ coverage
- ✅ Logging configurable

### Docker
- ✅ Multi-stage build
- ✅ Image optimisée (<200MB)
- ✅ User non-root
- ✅ Health checks
- ✅ Security scanning (Trivy)
- ✅ .dockerignore complet

### Kubernetes
- ✅ Deployment 2-5 pods
- ✅ Service + Ingress
- ✅ HPA (auto-scaling)
- ✅ Health probes (liveness, readiness, startup)
- ✅ ConfigMap + Secrets
- ✅ RBAC + NetworkPolicy
- ✅ Resource quotas et limits
- ✅ Rolling updates (0 downtime)

### Jenkins Pipeline
- ✅ 11 stages complets
- ✅ Parallel security scans
- ✅ Code quality gates (SonarQube)
- ✅ Artifact archiving
- ✅ Manual approval gates
- ✅ Notifications (Slack, email)
- ✅ Auto-rollback capable

### Terraform
- ✅ 20+ resources K8s
- ✅ Modulé et commenté
- ✅ State management
- ✅ Outputs helpers
- ✅ Auto-apply ready

### Ansible
- ✅ 4 rôles: Docker, K8s, Jenkins, Monitoring
- ✅ Configuration idempotent
- ✅ Vault secrets support
- ✅ Inventory flexible

### Sécurité
- ✅ 5 RBAC roles
- ✅ NetworkPolicy Deny All
- ✅ Pod Security Policy
- ✅ Secret encryption
- ✅ Audit logging
- ✅ Security scanning (3 outils)

---

## 🚀 Quick Start

### 5 Minutes - Minimal Setup
```bash
cd "Documents/S8/Projet DevOps"

# Python app
python -m venv venv && venv\Scripts\activate
pip install -r app/requirements.txt
streamlit run app/streamlit_app.py
# → http://localhost:8501
```

### 15 Minutes - Docker Setup
```bash
# Docker
docker build -t prediction-app:latest -f docker/Dockerfile .
docker run -p 8501:8501 prediction-app:latest
# → http://localhost:8501

# Ou stack complète
docker-compose up -d
```

### 30 Minutes - Kubernetes Setup
```bash
# K8s
kubectl apply -f kubernetes/
kubectl port-forward svc/prediction-app 8501:8501 -n prediction-app
# → http://localhost:8501
```

### 1 Hour - Complete Setup
```bash
# Tous les composants
docker-compose up -d                    # Stack locale
cd jenkins && docker-compose up -d      # Jenkins
cd ../terraform && terraform apply      # Infrastructure
ansible-playbook ansible/site.yml       # Automation
# → Système complet opérationnel!
```

---

## 🔗 Dépendances

```
Git
  ↓ (version control)
  ↓
Application (Python/Streamlit)
  ├→ pip install requirements.txt
  
Docker
  ├→ docker build
  ├→ docker-compose
  
Kubernetes
  ├→ kubectl apply
  ├→ Terraform (provisions resources)
  
Jenkins
  ├→ Pipeline exécute build/deploy
  ├→ Docker push
  ├→ kubectl deploy
  
SonarQube (optionnel)
  ├→ Code quality analysis
  
Ansible (optionnel)
  ├→ Automation playbooks
```

---

## 📈 Checklist de Compétences Acquises

Après complétion, vous serez expert en:

- [ ] Git & versioning best practices
- [ ] Docker containerization & optimization
- [ ] Kubernetes orchestration & scaling
- [ ] Jenkins CI/CD pipeline automation
- [ ] Terraform Infrastructure as Code
- [ ] Ansible playbooks & automation
- [ ] Security best practices (RBAC, NetworkPolicy, PSP)
- [ ] SonarQube code quality analysis
- [ ] DevSecOps architecture & patterns
- [ ] Cloud-native application design

---

## 📞 Support

**Questions?**
1. Consulter [GUIDE.md](docs/GUIDE.md)
2. Consulter [SETUP.md](docs/SETUP.md)
3. Consulter [ARCHITECTURE.md](docs/ARCHITECTURE.md)
4. Consulter [SECURITY.md](security/SECURITY.md)

**Erreurs?**
1. Vérifier [Troubleshooting](docs/SETUP.md#troubleshooting)
2. Vérifier les logs: `kubectl logs -f <pod>`
3. Vérifier configuration: `kubectl describe pod <pod>`

---

**Prêt à commencer? 🚀**

Lisez [PROCHAINES-ETAPES.md](PROCHAINES-ETAPES.md) pour le plan détaillé!
