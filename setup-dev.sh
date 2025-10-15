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
echo "To activate the environment, run: source venv/bin/activate"
echo "To start the development server, run: python run.py"
echo "To run tests, run: pytest"