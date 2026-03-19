# Configuration de l'application

import os
from dotenv import load_dotenv

load_dotenv()

# Application Settings
APP_NAME = os.getenv("APP_NAME", "Prediction Analytics")
APP_VERSION = "1.0.0"
ENVIRONMENT = os.getenv("ENVIRONMENT", "development")
DEBUG = os.getenv("DEBUG", "False") == "True"

# Database
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = int(os.getenv("DB_PORT", "5432"))
DB_USER = os.getenv("DB_USER", "app_user")
DB_PASS = os.getenv("DB_PASS", "secure_password")
DB_NAME = os.getenv("DB_NAME", "prediction_db")

# API Configuration
API_HOST = os.getenv("API_HOST", "0.0.0.0")
API_PORT = int(os.getenv("API_PORT", "8501"))
API_WORKERS = int(os.getenv("API_WORKERS", "4"))

# Logging
LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO")
LOG_FILE = os.getenv("LOG_FILE", "app.log")

# Security
SECRET_KEY = os.getenv("SECRET_KEY", "change-me-in-production")
ALLOW_ORIGINS = os.getenv("ALLOW_ORIGINS", "localhost").split(",")

# ML Model
MODEL_PATH = os.getenv("MODEL_PATH", "/models/model.pkl")

def get_config():
    """Retourner la configuration actuelle"""
    return {
        "app_name": APP_NAME,
        "version": APP_VERSION,
        "environment": ENVIRONMENT,
        "debug": DEBUG,
        "api_host": API_HOST,
        "api_port": API_PORT,
    }
