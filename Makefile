.PHONY: help build test docker-build k8s-deploy clean

help:
	@echo "🚀 Commandes disponibles:"
	@echo "  make setup              - Initialiser l'environnement"
	@echo "  make build              - Builder l'application"
	@echo "  make test               - Exécuter les tests"
	@echo "  make docker-build       - Builder l'image Docker"
	@echo "  make docker-run         - Lancer application en Docker"
	@echo "  make k8s-deploy         - Déployer sur Kubernetes"
	@echo "  make k8s-clean          - Nettoyer les ressources K8s"
	@echo "  make logs               - Voir les logs de l'application"
	@echo "  make clean              - Nettoyer fichiers temporaires"

setup:
	@echo "📦 Initialisation..."
	python -m venv venv
	. venv/Scripts/activate && pip install --upgrade pip
	. venv/Scripts/activate && pip install -r app/requirements.txt
	@echo "✅ Environnement prêt!"

build: setup
	@echo "🔨 Compilation..."
	. venv/Scripts/activate && python -m pytest app/tests/ -v

test:
	@echo "🧪 Tests unitaires..."
	. venv/Scripts/activate && python -m pytest app/tests/ -v --cov=app

docker-build:
	@echo "🐳 Construction image Docker..."
	docker build -t prediction-app:latest -f docker/Dockerfile .
	@echo "✅ Image construite!"

docker-run: docker-build
	@echo "▶️ Lancement en Docker..."
	docker run -p 8501:8501 --env-file .env prediction-app:latest

docker-scan:
	@echo "🔍 Scan sécurité Docker..."
	docker scan prediction-app:latest

k8s-deploy:
	@echo "☸️ Déploiement Kubernetes..."
	kubectl apply -f kubernetes/configmap.yaml
	kubectl apply -f kubernetes/secrets.yaml
	kubectl apply -f kubernetes/deployment.yaml
	kubectl apply -f kubernetes/service.yaml
	kubectl apply -f kubernetes/hpa.yaml
	@echo "✅ Application déployée!"
	@echo "Vérification: kubectl get pods -l app=prediction-app"

k8s-status:
	@echo "📊 Statut Kubernetes..."
	kubectl get all -l app=prediction-app

k8s-logs:
	@echo "📋 Logs de l'application..."
	kubectl logs -f -l app=prediction-app --all-containers=true

k8s-clean:
	@echo "🗑️ Suppression ressources K8s..."
	kubectl delete -f kubernetes/
	@echo "✅ Nettoyage terminer!"

k8s-portforward:
	@echo "🔗 Port forwarding... (http://localhost:8501)"
	kubectl port-forward svc/prediction-app 8501:8501

terraform-init:
	@echo "🏗️ Initialisation Terraform..."
	cd terraform && terraform init

terraform-plan:
	@echo "📋 Plan Terraform..."
	cd terraform && terraform plan

terraform-apply:
	@echo "✅ Application Terraform..."
	cd terraform && terraform apply -auto-approve

terraform-validate:
	@echo "🔍 Validation Terraform..."
	cd terraform && terraform validate && terraform fmt

ansible-check:
	@echo "🔍 Vérification syntaxe Ansible..."
	ansible-playbook ansible/site.yml --syntax-check

ansible-run:
	@echo "⚙️ Exécution Ansible..."
	ansible-playbook ansible/site.yml -i ansible/inventory/hosts

jenkins-docker-start:
	@echo "🔧 Démarrage Jenkins en Docker..."
	cd jenkins && docker-compose up -d
	@echo "Jenkins disponible sur http://localhost:8080"

sonarqube-start:
	@echo "📊 Démarrage SonarQube..."
	docker run -d --name sonarqube -p 9000:9000 sonarqube:latest
	@echo "SonarQube disponible sur http://localhost:9000"

logs:
	@echo "📋 Logs application..."
	docker-compose logs -f app

clean:
	@echo "🗑️ Nettoyage..."
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	rm -rf .pytest_cache
	rm -rf .coverage
	rm -rf htmlcov
	rm -rf dist build *.egg-info
	@echo "✅ Nettoyage terminé!"

all: clean setup test docker-build docker-scan
	@echo "🎉 Build complet terminé!"
