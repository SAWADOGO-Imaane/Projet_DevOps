# 🚀 Architecture DevSecOps Complète - Application IA Prédictive

## 📋 Vue d'ensemble du Projet

Architecture DevSecOps professionnelle pour une application Streamlit d'analyse prédictive, incluant:
- **CI/CD Pipeline** avec Jenkins
- **Containerisation** avec Docker
- **Orchestration** avec Kubernetes
- **Infrastructure as Code** avec Terraform
- **Automatisation** avec Ansible
- **Sécurité** : SonarQube, RBAC, secrets management

---

## 📂 Structure du Projet

```
Projet DevOps/
├── app/                          # Code source de l'application
│   ├── streamlit_app.py         # Application principale
│   ├── requirements.txt          # Dépendances Python
│   ├── tests/                    # Tests unitaires
│   ├── models/                   # Modèles ML
│   └── utils/                    # Utilitaires
│
├── docker/                        # Configuration Docker
│   ├── Dockerfile                # Image Docker multistage
│   ├── .dockerignore             # Fichiers exclus
│   └── docker-compose.yml        # Composition locale
│
├── kubernetes/                    # Configuration Kubernetes
│   ├── deployment.yaml           # Deployment
│   ├── service.yaml              # Service
│   ├── hpa.yaml                  # Horizontal Pod Autoscaler
│   ├── configmap.yaml            # Configuration
│   ├── secrets.yaml              # Secrets chiffrés
│   └── ingress.yaml              # Ingress pour acces
│
├── terraform/                     # Infrastructure as Code
│   ├── main.tf                   # Configuration principale
│   ├── variables.tf              # Variables
│   ├── outputs.tf                # Outputs
│   └── local/                    # Config pour environnement local
│
├── ansible/                       # Automatisation
│   ├── site.yml                  # Playbook principal
│   ├── roles/                    # Rôles Ansible
│   │   ├── docker/
│   │   ├── kubernetes/
│   │   ├── jenkins/
│   │   └── monitoring/
│   ├── inventory/                # Fichiers d'inventaire
│   └── vars/                     # Variables globales
│
├── jenkins/                       # Configuration Jenkins
│   ├── Jenkinsfile               # Pipeline déclaratif
│   ├── docker-compose.yml        # Jenkins dans Docker
│   └── groovy/                   # Scripts Groovy partages
│
├── security/                      # Sécurité DevSecOps
│   ├── rbac/                     # Rôles RBAC Kubernetes
│   │   ├── admin-role.yaml
│   │   ├── developer-role.yaml
│   │   └── readonly-role.yaml
│   ├── policies/                 # Politiques PodSecurityPolicy
│   ├── network-policies/         # NetworkPolicy
│   └── secrets-config.md         # Gestion des secrets
│
├── docs/                          # Documentation
│   ├── GUIDE.md                  # Guide complet
│   ├── ARCHITECTURE.md           # Architecture détaillée
│   ├── SETUP.md                  # Instructions d'installation
│   ├── SECURITY.md               # Politique de sécurité
│   └── TROUBLESHOOTING.md        # Dépannage
│
├── .gitignore                     # Fichiers Git ignorés
├── docker-compose.yml            # Stack complète local
└── Makefile                       # Commandes utiles
```

---

## 🎯 Objectifs DevSecOps

### 1. ✅ Gestion de Version
- [x] Repository Git structuré avec branches
- [x] Versioning sémantique (MAJOR.MINOR.PATCH)

### 2. ✅ CI/CD Jenkins
- [x] Build automatisé
- [x] Tests unitaires/intégration
- [x] Analyse SonarQube
- [x] Build Docker
- [x] Scan de sécurité (Trivy)
- [x] Déploiement staging

### 3. ✅ Docker
- [x] Image optimisée (multistage)
- [x] Gestion variables d'environnement
- [x] Pas de secrets en clair
- [x] Scanning vulnérabilités

### 4. ✅ Kubernetes
- [x] Deployment
- [x] Service et Ingress
- [x] HPA (Horizontal Pod Autoscaler)
- [x] Rolling Updates
- [x] Rollback automatisé

### 5. ✅ Terraform (IaC)
- [x] Provisionning infrastructure
- [x] Versioning dans Git
- [x] Environnements multiples

### 6. ✅ Ansible
- [x] Déploiement automatisé
- [x] Structuration en rôles
- [x] Idempotence

### 7. ✅ Sécurité DevSecOps
- [x] SonarQube dans le pipeline
- [x] Scanner de dépendances (Snyk)
- [x] RBAC Kubernetes (Admin/Dev/ReadOnly)
- [x] Gestion des secrets (K8s Secrets + Vault)
- [x] PodSecurityPolicy
- [x] NetworkPolicy
- [x] Resource Quotas & Limits

---

## 🚀 Quick Start

### Prérequis
```bash
# Requis
- Docker Desktop (avec Kubernetes)
- Docker Compose
- kubectl
- Terraform >= 1.0
- Ansible >= 2.10
- Python 3.9+
- Git

# Optionnel
- Jenkins CLI
- SonarQube (Docker)
- Vault (pour secrets)
```

### Installation locale

```bash
# 1. Cloner et initialiser
git clone <repo>
cd "Projet DevOps"

# 2. Créer l'environnement Python
python -m venv venv
source venv/bin/activate  # Linux/Mac
# ou
.\venv\Scripts\activate   # Windows

# 3. Installer dépendances
pip install -r app/requirements.txt

# 4. Lancer avec Docker Compose (stack complète)
docker-compose up -d

# 5. Déployer sur Kubernetes
kubectl apply -f kubernetes/

# 6. Vérifier le statut
kubectl get pods -l app=prediction-app
```

---

## 📊 Pipeline CI/CD

```
Git Commit
    ↓
Jenkins Trigger
    ├─→ Code Quality (SonarQube)
    ├─→ Build & Test
    ├─→ Dependency Scan (Snyk)
    ├─→ Docker Build
    ├─→ Docker Scan (Trivy)
    ├─→ Push Registry
    └─→ Deploy Staging/Prod
```

---

## 🔐 Sécurité

### Checkliste de Sécurité
- [ ] Secrets gérés via Kubernetes Secrets ou Vault
- [ ] RBAC appliqué (Admin/Dev/ReadOnly)
- [ ] NetworkPolicy restrictive
- [ ] PodSecurityPolicy activée
- [ ] Resource Quotas configurés
- [ ] Logging & Monitoring activés
- [ ] HTTPS/TLS pour les serveurs
- [ ] Vulnerability Scanning dans le pipeline

Voir [security/](security/) pour les détails.

---

## 📈 Architecture Kubernetes

```
┌─────────────────────────────────┐
│   Kubernetes Cluster (K8s)      │
├─────────────────────────────────┤
│                                  │
│  ┌──────────────────────────┐   │
│  │  Deployment              │   │
│  │  - Replicas: 2-5         │   │
│  │  - Image: app:latest     │   │
│  │  - Resource Limits       │   │
│  └──────────────────────────┘   │
│           ↓                      │
│  ┌──────────────────────────┐   │
│  │  Service (ClusterIP)     │   │
│  │  - Port: 8501            │   │
│  │  - Selector: app=pred    │   │
│  └──────────────────────────┘   │
│           ↓                      │
│  ┌──────────────────────────┐   │
│  │  Ingress                 │   │
│  │  - Host: app.local       │   │
│  │  - TLS: enabled          │   │
│  └──────────────────────────┘   │
│           ↓                      │
│  ┌──────────────────────────┐   │
│  │  HPA                     │   │
│  │  - Min: 2, Max: 5 pods   │   │
│  │  - CPU Threshold: 70%    │   │
│  └──────────────────────────┘   │
│                                  │
└─────────────────────────────────┘
```

---

## 📚 Documentation

- **[SETUP.md](docs/SETUP.md)** - Installation détaillée
- **[ARCHITECTURE.md](docs/ARCHITECTURE.md)** - Design système
- **[SECURITY.md](docs/SECURITY.md)** - Politiques de sécurité
- **[GUIDE.md](docs/GUIDE.md)** - Guide de déploiement

---

## 🛠️ Commandes Utiles

```bash
# Kubernetes
kubectl apply -f kubernetes/               # Déployer
kubectl get pods                           # Lister pods
kubectl logs -f <pod>                      # Logs en direct
kubectl port-forward svc/app 8501:8501    # Port forward

# Terraform
terraform init                             # Initialiser
terraform plan                             # Planifier
terraform apply                            # Appliquer

# Ansible
ansible-playbook ansible/site.yml          # Exécuter
ansible-playbook -i inventory --syntax-check  # Vérifier syntaxe

# Docker
docker build -t app:latest .               # Builder
docker-compose up                          # Démarrer stack
docker scan app:latest                     # Scanner vulnérabilités
```

---

## Autorit

**Étudiant**: [SAWADOGO Imaane, PITROIPA Soraya et RABESIAKA Heri]
**Date**: 2026-03-17
**Université**: 2iE

---

## Licence

MIT License - Voir LICENSE.md

---

**Status**: En Développement
