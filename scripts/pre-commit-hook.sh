#!/bin/bash
# Pre-commit hook script - runs all checks before commit

set -e

echo "🚀 Running pre-commit checks..."
echo "==============================="

# Run the main check script
./scripts/check-code.sh

# If we get here, all checks passed
echo ""
echo "✅ All pre-commit checks passed!"
echo "Proceeding with commit..."