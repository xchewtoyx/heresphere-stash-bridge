#!/bin/bash
# Development setup script for HereSphere Stash Bridge

set -e

echo "Setting up HereSphere Stash Bridge development environment..."

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

# Upgrade pip
echo "Upgrading pip..."
pip install --upgrade pip

# Install development dependencies
echo "Installing development dependencies..."
pip install -r requirements-dev.txt

# Install package in development mode
echo "Installing package in development mode..."
pip install -e .

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    echo "Creating .env file from template..."
    cp .env.example .env
fi

echo "Development environment setup complete!"
echo ""
echo "📚 Available commands:"
echo "  source venv/bin/activate     - Activate virtual environment"
echo "  python run.py                - Start development server"
echo "  pytest                       - Run tests"
echo ""
echo "🛠️  Code quality tools:"
echo "  ./scripts/check-code.sh      - Run all checks (lint, format, test, security)"
echo "  ./scripts/format-code.sh     - Auto-fix formatting issues"
echo "  ./scripts/security-scan.sh   - Run security scans"
echo "  ./scripts/install-hooks.sh   - Install pre-commit hooks"
echo ""
echo "📖 See LOCAL_DEVELOPMENT.md for detailed usage guide"