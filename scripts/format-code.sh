#!/bin/bash
# Auto-format code to fix common issues

set -e

echo "🎨 Fixing code formatting issues..."
echo "=================================="

# Colors for output
GREEN='\033[0;32m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

# Check if virtual environment is activated
if [[ "$VIRTUAL_ENV" == "" ]]; then
    if [ -f "venv/bin/activate" ]; then
        source venv/bin/activate
    fi
fi

# Black - Auto-format code
echo "Running Black code formatter..."
black src/ tests/
print_status "Black formatting applied"

# isort - Auto-sort imports
echo "Running isort import sorter..."
isort src/ tests/
print_status "Import sorting applied"

echo ""
print_status "Code formatting completed!"
echo "Run './scripts/check-code.sh' to verify all checks pass"