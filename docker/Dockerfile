# Stage 1: Builder - Construire l'image avec toutes les dépendances
FROM python:3.11-slim as builder

WORKDIR /app

# Installer les build tools nécessaires
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copier requirements
COPY app/requirements.txt .

# Installer dépendances Python en mode optimisé
RUN pip install --user --no-cache-dir -r requirements.txt

# ============================================================================
# Stage 2: Runtime - Image optimisée finale
# ============================================================================
FROM python:3.11-slim

# Labels pour les métadonnées
LABEL version="1.0.0"
LABEL description="Application de prédiction IA - DevSecOps"
LABEL maintainer="DevOps Team"

WORKDIR /app

# Variables d'environnement
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    ENVIRONMENT=production \
    DEBUG=False \
    API_PORT=8501 \
    API_HOST=0.0.0.0

# Créer utilisateur non-root pour sécurité
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Installer dépendances runtime minimales
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copier les dépendances installées depuis le stage builder
COPY --from=builder /root/.local /home/appuser/.local

# Copier le code source
COPY app/ .

# Donner les permissions adéquates
RUN chown -R appuser:appuser /app && chmod 755 /app

# Utiliser l'utilisateur non-root
USER appuser

# Ajouter local bin au PATH
ENV PATH=/home/appuser/.local/bin:$PATH

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8501/healthz || exit 1

# Exposer le port
EXPOSE 8501

# Commande de démarrage - utiliser shell pour remplacer les variables
ENTRYPOINT ["sh", "-c", "streamlit run streamlit_app.py --server.address=0.0.0.0 --server.port=8501 --logger.level=info --client.showErrorDetails=false"]
