import os
import sys
import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


def validate_environment():
    """Valider que l'environnement est correctement configuré"""
    required_env_vars = [
        'ENVIRONMENT',
        'API_PORT',
    ]
    
    missing = []
    for var in required_env_vars:
        if not os.getenv(var):
            missing.append(var)
    
    if missing:
        logger.error(f"Variables d'environnement manquantes: {', '.join(missing)}")
        return False
    
    logger.info("✅ Environnement validé")
    return True


def initialize_app():
    """Initialiser l'application"""
    logger.info("🚀 Initialisation de l'application...")
    
    if not validate_environment():
        sys.exit(1)
    
    logger.info("✅ Application initialisée")


if __name__ == "__main__":
    initialize_app()
