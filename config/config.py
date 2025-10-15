"""Configuration settings for the HereSphere Stash Bridge application."""

import os
from pathlib import Path

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent


class Config:
    """Base configuration class."""
    
    # Basic Flask settings
    SECRET_KEY = os.environ.get('SECRET_KEY', 'dev-secret-key-change-in-production')
    
    # HereSphere settings
    HERESPHERE_HOST = os.environ.get('HERESPHERE_HOST', 'localhost')
    HERESPHERE_PORT = int(os.environ.get('HERESPHERE_PORT', '8080'))
    
    # Stash settings
    STASH_HOST = os.environ.get('STASH_HOST', 'localhost')
    STASH_PORT = int(os.environ.get('STASH_PORT', '9999'))
    STASH_API_KEY = os.environ.get('STASH_API_KEY', '')
    
    # Bridge settings
    BRIDGE_HOST = os.environ.get('BRIDGE_HOST', '0.0.0.0')
    BRIDGE_PORT = int(os.environ.get('BRIDGE_PORT', '5000'))


class DevelopmentConfig(Config):
    """Development configuration."""
    
    DEBUG = True
    DEVELOPMENT = True


class ProductionConfig(Config):
    """Production configuration."""
    
    DEBUG = False
    DEVELOPMENT = False


class TestingConfig(Config):
    """Testing configuration."""
    
    TESTING = True
    DEBUG = True