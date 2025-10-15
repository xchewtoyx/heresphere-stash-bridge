"""HereSphere Stash Bridge Flask Application."""

import os

from flask import Flask
from flask_cors import CORS


def create_app(config_name=None):
    """Create and configure the Flask application."""
    app = Flask(__name__)

    # Enable CORS for all routes
    CORS(app)

    # Load configuration
    if config_name is None:
        config_name = os.environ.get("FLASK_ENV", "development")

    app.config.from_object(f"config.{config_name.title()}Config")

    # Load environment variables if .env file exists
    if os.path.exists(".env"):
        from dotenv import load_dotenv

        load_dotenv()

    # Register blueprints
    from .routes import bp as main_bp

    app.register_blueprint(main_bp)

    return app
