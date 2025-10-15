#!/bin/bash
# Install Git pre-commit hook

echo "🪝 Installing Git pre-commit hook..."

# Make scripts executable
chmod +x scripts/*.sh

# Copy pre-commit hook
cp scripts/pre-commit-hook.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

echo "✅ Pre-commit hook installed!"
echo ""
echo "Now all commits will automatically run:"
echo "  - Code quality checks"
echo "  - Security scans"
echo "  - Tests"
echo ""
echo "To skip the hook (not recommended):"
echo "  git commit --no-verify"