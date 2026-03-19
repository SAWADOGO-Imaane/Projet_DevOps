# 🚀 Guide Complet Setup et Déploiement

## 📋 Table des Matières

1. [Prérequis](#prérequis)
2. [Installation Locale](#installation-locale)
3. [Déploiement Docker](#déploiement-docker)
4. [Déploiement Kubernetes](#déploiement-kubernetes)
5. [Pipeline Jenkins](#pipeline-jenkins)
6. [Troubleshooting](#troubleshooting)

---

## 🔧 Prérequis

### Logiciels Requis
```bash
# Vérifier les versions
docker --version          # >= 24.0
docker-compose --version  # >= 2.20
kubectl version --client  # >= 1.27
terraform version         # >= 1.0
ansible --version         # >= 2.10
git --version             # >= 2.30
python --version          # >= 3.9
```

### Installation Windows

#### Option 1: Docker Desktop (RECOMMANDÉ)
1. Télécharger: https://www.docker.com/products/docker-desktop
2. Installer (Inclut Docker, Kubernetes, Docker Compose)
3. Activer Kubernetes: Settings → Kubernetes → Enable Kubernetes
4. Vérifier: `kubectl cluster-info`

#### Option 2: Chocolatey
```powershell
# Installer Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Installer outils
choco install docker-desktop kubernetes-cli terraform ansible git python
```

### Installation Linux

```bash
# Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Kubernetes (Minikube)
curl https://github.com/kubernetes/minikube/releases/download/latest/minikube-linux-amd64
chmod +x minikube*
sudo mv minikube* /usr/local/bin/minikube
minikube start

# Terraform
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_*
sudo mv terraform /usr/local/bin/

# Ansible
sudo apt install ansible

# Python
sudo apt install python3 python3-pip python3-venv
```

---

## 💻 Installation Locale

### 1. Cloner le Projet
```bash
cd "Documents/S8/Projet DevOps"
git init
git add .
git commit -m "Initial commit"
```

### 2. Créer Environnement Python
```bash
# Windows
python -m venv venv
.\venv\Scripts\activate

# Linux/Mac
python3 -m venv venv
source venv/bin/activate
```

### 3. Installer Dépendances
```bash
pip install --upgrade pip
pip install -r app/requirements.txt
```

### 4. Configurer Variables d'Environnement
```bash
# Copier le template
cp app/.env.example app/.env

# Éditer les valeurs
nano app/.env

# Contenu minimum
ENVIRONMENT=development
API_PORT=8501
SECRET_KEY=your-secret-key
DB_PASS=your-db-password
```

### 5. Exécuter l'Application
```bash
# Python venv
streamlit run app/streamlit_app.py

# Ou avec Docker
make docker-run
```

---

## 🐳 Déploiement Docker

### 1. Build Image
```bash
# Build
docker build -t prediction-app:latest -f docker/Dockerfile .

# Vérifier
docker images | grep prediction-app
```

### 2. Run Container
```bash
# Mode interactif
docker run -p 8501:8501 \
  --env ENVIRONMENT=development \
  prediction-app:latest

# Mode détaché
docker run -d -p 8501:8501 \
  --name app-container \
  prediction-app:latest

# Vérifier
docker ps | grep prediction-app
```

### 3. Docker Compose (Stack Complète)
```bash
# Démarrer tout (app + postgres + nginx)
docker-compose up -d

# Arrêter
docker-compose down

# Voir logs
docker-compose logs -f app

# Status
docker-compose ps
```

### 4. Scanner les Vulnérabilités
```bash
# Trivy
trivy image prediction-app:latest

# Snyk
docker scan prediction-app:latest
```

---

## ☸️ Déploiement Kubernetes

### 1. Préparation
```bash
# Vérifier le cluster
kubectl cluster-info
kubectl get nodes

# Créer namespace
kubectl create namespace prediction-app

# Vérifier
kubectl get namespaces
```

### 2. Déployer avec Manifests YAML
```bash
# Déployer tous les manifests
kubectl apply -f kubernetes/

# Vérifier déploiement
kubectl get all -n prediction-app

# Status détaillé
kubectl describe deployment prediction-app -n prediction-app
```

### 3. Déployer avec Terraform
```bash
cd terraform

# Initialiser
terraform init

# Voir le plan
terraform plan -var-file=terraform.tfvars

# Appliquer
terraform apply -var-file=terraform.tfvars

# Vérifier
terraform output
```

### 4. Accès à l'Application
```bash
# Port Forward
kubectl port-forward -n prediction-app svc/prediction-app 8501:8501

# Accéder: http://localhost:8501

# Ou NodePort (Docker Desktop)
# http://localhost:30501
```

### 5. Vérification
```bash
# Pods
kubectl get pods -n prediction-app
kubectl logs -f -l app=prediction-app -n prediction-app

# Services
kubectl get svc -n prediction-app

# HPA (autoscaling)
kubectl get hpa -n prediction-app

# Ressources
kubectl top nodes
kubectl top pods -n prediction-app
```

---

## 🔄 Pipeline Jenkins

### 1. Démarrer Jenkins
```bash
cd jenkins

# Avec Docker Compose
docker-compose up -d

# Accès: http://localhost:8080

# Récupérer admin password
docker-compose logs jenkins | grep "Admin password"
```

### 2. Configuration Jenkins
1. Accéder http://localhost:8080
2. Entrer le password initial
3. Installer plugins suggérés
4. Créer admin user
5. Charger configuration JCasC depuis `jenkins/casc.yaml`

### 3. Créer Pipeline
1. New Item → Pipeline
2. Configure → Pipeline script from SCM
3. Pointer vers `jenkins/Jenkinsfile`
4. Build now

### 4. Stages Pipeline
```
✅ Checkout
  ↓
🔨 Build
  ↓
🔍 Code Quality (SonarQube)
  ↓
🧪 Tests
  ↓
🐳 Docker Build
  ↓
🔐 Security Scan (Trivy, Snyk)
  ↓
📤 Push Registry
  ↓
🚀 Deploy Staging
  ↓
✅ Smoke Tests
  ↓
🎉 Deploy Production (Manual)
```

---

## 📊 SonarQube

### 1. Démarrer SonarQube
```bash
# Avec Docker
docker run -d -p 9000:9000 sonarqube:latest

# Accès: http://localhost:9000
# Login: admin/admin (par défaut)
```

### 2. Analyser le Code
```bash
# Option 1: Depuis Jenkins (voir Jenkinsfile)

# Option 2: En ligne de commande
docker run --rm \
  -v $(pwd):/usr/src sonarsource/sonar-scanner-cli \
  -Dsonar.projectKey=prediction-app \
  -Dsonar.host.url=http://host.docker.internal:9000 \
  -Dsonar.login=admin:admin
```

---

## 🔐 Sécurité & RBAC

### 1. Appliquer RBAC
```bash
# Admin
kubectl apply -f security/rbac/rbac-policies.yaml

# Vérifier
kubectl get role -n prediction-app
kubectl get rolebinding -n prediction-app
```

### 2. NetworkPolicy
```bash
# Appliquer
kubectl apply -f security/network-policies/network-policies.yaml

# Vérifier
kubectl get networkpolicy -n prediction-app
```

### 3. Pod Security Policy
```bash
# Appliquer
kubectl apply -f security/policies/pod-security-policy.yaml

# Vérifier
kubectl get podsecuritypolicy
```

### 4. Secrets Management
```bash
# Créer secret
kubectl create secret generic app-secrets \
  --from-literal=DB_PASS=mysecure_password \
  -n prediction-app

# Vérifier (encodé base64)
kubectl get secret app-secrets -n prediction-app -o json

# Décoder
kubectl get secret app-secrets -o jsonpath={.data.DB_PASS} \
  -n prediction-app | base64 -d
```

---

## 🤖 Ansible

### 1. Installation
```bash
pip install ansible

# Vérifier
ansible --version
```

### 2. Configuration Inventaire
```bash
# Éditer inventory
nano ansible/inventory/hosts

# Tester connexion
ansible all -i inventory/hosts -m ping
```

### 3. Exécuter Playbooks
```bash
cd ansible

# Vérifier syntaxe
ansible-playbook site.yml --syntax-check -i inventory/hosts

# Test mode (dry-run)
ansible-playbook site.yml -i inventory/hosts --check

# Exécuter
ansible-playbook site.yml -i inventory/hosts -v
```

### 4. Chiffrer Secrets  
```bash
# Créer vault password
echo "my-vault-password" > .vault_password

# Chiffrer secrets.yml
ansible-vault encrypt ansible/vars/secrets.yml

# Exécuter avec vault
ansible-playbook site.yml -i inventory/hosts \
  --vault-id @.vault_password
```

---

## 🧪 Tests

### 1. Tests Unitaires
```bash
# Avec pytest
cd app
pytest tests/ -v --cov=. --cov-report=html

# Voir rapport
open htmlcov/index.html
```

### 2. Tests d'Intégration
```bash
# Avec docker-compose
docker-compose up -d
sleep 5
curl http://localhost:8501
```

### 3. Tests de Charge
```bash
# Avec Apache Bench
ab -n 1000 -c 10 http://localhost:8501/

# Avec locust
pip install locust
locust -f locustfile.py --host=http://localhost:8501
```

---

## 📈 Monitoring

### 1. Prometheus & Grafana
```bash
# Non inclus par défaut, optionnel

# Déployer Prometheus
kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/main/bundle.yaml

# Port forward
kubectl port-forward -n prometheus svc/prometheus 9090:9090
```

### 2. Logs (ELK ou Loki)
```bash
# Logs depuis Kubernetes
kubectl logs -l app=prediction-app -f -n prediction-app

# Ou via ELK
# Voir documentation monitoring
```

---

## ⚠️ Troubleshooting

### Problème: Pod en CrashLoopBackOff
```bash
# Voir logs
kubectl logs <pod-name> -n prediction-app

# Décrire pod
kubectl describe pod <pod-name> -n prediction-app

# Possibles causes:
# - Image non trouvée → vérifier image registry
# - Mauvais environnement → vérifier ConfigMap/Secrets
# - Port utilisé → kubectl get svc
```

### Problème: ImagePullBackOff
```bash
# Vérifier image existe
docker images | grep prediction-app

# Builder l'image si manquante
docker build -t prediction-app:latest -f docker/Dockerfile .

# Ou charger image (si offline)
docker load < prediction-app.tar
```

### Problème: Service non accessible
```bash
# Vérifier service
kubectl get svc -n prediction-app

# Vérifier endpoints
kubectl get endpoints -n prediction-app

# Vérifier pod is running
kubectl get pods -n prediction-app

# Test connectivité
kubectl exec -it <pod-name> -n prediction-app \
  -- wget http://localhost:8501
```

### Problème: Terraform apply échoue
```bash
# Vérifier kubeconfig
export KUBECONFIG=~/.kube/config

# Récréer state si problèmes
rm .terraform/tfstate.* 2>/dev/null
terraform init

# Valider config
terraform validate
```

### Problème: Jenkins ne démarre pas
```bash
# Volume permissions
docker-compose logs jenkins

# Reset Jenkins
docker-compose down
docker volume rm jenkins_jenkins_home
docker-compose up -d
```

---

## 🧹 Cleanup

### Nettoyer Tout
```bash
# Kubernetes
kubectl delete -f kubernetes/ -n prediction-app
kubectl delete namespace prediction-app

# Docker
docker-compose down -v
docker rmi prediction-app:latest

# Terraform
cd terraform && terraform destroy -auto-approve

# Python venv
rm -rf venv
```

---

## 📞 Support & Documentation

- **Architecture**: [ARCHITECTURE.md](ARCHITECTURE.md)
- **Sécurité**: [security/SECURITY.md](security/SECURITY.md)
- **Dev Guide**: [DEVELOPMENT.md](DEVELOPMENT.md)

Pour plus d'aide: `support@prediction-app.local`
