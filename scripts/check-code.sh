#!/bin/bash
# Local code quality and security check script
# Runs the same checks as GitHub Actions locally

set -e

echo "🔍 Running local code quality and security checks..."
echo "===================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[⚠]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Check if virtual environment is activated
if [[ "$VIRTUAL_ENV" == "" ]]; then
    print_warning "Virtual environment not detected. Activating..."
    if [ -f "venv/bin/activate" ]; then
        source venv/bin/activate
        print_status "Virtual environment activated"
    else
        print_error "No virtual environment found. Run setup-dev.sh first."
        exit 1
    fi
fi

# Install/update development dependencies
echo ""
echo "📦 Installing/updating dependencies..."
pip install -r requirements-dev.txt > /dev/null 2>&1
pip install -e . > /dev/null 2>&1
print_status "Dependencies updated"

# Code Quality Checks
echo ""
echo "🎨 Running code quality checks..."
echo "--------------------------------"

# Flake8 - Syntax errors and undefined names (critical)
echo "Running Flake8 (critical errors)..."
if flake8 src/ tests/ --count --select=E9,F63,F7,F82 --show-source --statistics; then
    print_status "Flake8 critical checks passed"
else
    print_error "Flake8 found critical errors"
    exit 1
fi

# Flake8 - All other checks (warnings)
echo "Running Flake8 (all checks)..."
if flake8 src/ tests/ --count --exit-zero --max-complexity=10 --max-line-length=88 --statistics; then
    print_status "Flake8 full check completed"
else
    print_warning "Flake8 found style issues (non-critical)"
fi

# Black - Code formatting
echo "Running Black formatter check..."
if black --check --diff src/ tests/; then
    print_status "Black formatting check passed"
else
    print_error "Black formatting issues found. Run 'black src/ tests/' to fix"
    echo "Or run: ./scripts/format-code.sh"
    exit 1
fi

# isort - Import sorting
echo "Running isort import check..."
if isort --check-only --diff src/ tests/; then
    print_status "isort import check passed"
else
    print_error "Import sorting issues found. Run 'isort src/ tests/' to fix"
    echo "Or run: ./scripts/format-code.sh"
    exit 1
fi

# MyPy - Type checking
echo "Running MyPy type checking..."
if mypy src/ --show-error-codes --pretty; then
    print_status "MyPy type checking passed"
else
    print_warning "MyPy found type issues (non-critical for now)"
fi

# Security Checks
echo ""
echo "🔒 Running security checks..."
echo "-----------------------------"

# Safety - Check for known vulnerabilities
echo "Running Safety vulnerability check..."
if safety check; then
    print_status "Safety check passed - no known vulnerabilities"
else
    print_warning "Safety found potential vulnerabilities in dependencies"
fi

# Bandit - Static security analysis
echo "Running Bandit security analysis..."
if bandit -r src/; then
    print_status "Bandit security check passed"
else
    print_warning "Bandit found potential security issues"
fi

# Tests
echo ""
echo "🧪 Running tests..."
echo "------------------"

# Run pytest with coverage
if pytest --cov=heresphere_stash_bridge --cov-report=term-missing --cov-report=html; then
    print_status "All tests passed!"
    echo "Coverage report generated in htmlcov/"
else
    print_error "Tests failed"
    exit 1
fi

# Docker build test (optional)
echo ""
echo "🐳 Testing Docker build..."
echo "--------------------------"

if docker build -t heresphere-stash-bridge:test . > /dev/null 2>&1; then
    print_status "Docker build successful"
    # Clean up test image
    docker rmi heresphere-stash-bridge:test > /dev/null 2>&1
else
    print_warning "Docker build failed (check Dockerfile)"
fi

echo ""
echo "🎉 All checks completed!"
echo "========================"
print_status "Code is ready for commit and push"
echo ""
echo "Next steps:"
echo "  git add ."
echo "  git commit -m 'your commit message'"
echo "  git push"