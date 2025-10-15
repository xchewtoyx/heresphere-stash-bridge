# Local Development and Testing Guide

This guide shows how to run the same code quality, security, and testing checks locally that run in GitHub Actions.

## Quick Start

```bash
# Make scripts executable
chmod +x scripts/*.sh

# Run all checks (same as GitHub Actions)
./scripts/check-code.sh
```

## Available Scripts

### 🎨 Code Quality

```bash
# Run all quality checks (linting, formatting, type checking, tests)
./scripts/check-code.sh

# Auto-fix formatting issues
./scripts/format-code.sh

# Install pre-commit hooks (runs checks on every commit)
./scripts/install-hooks.sh
```

### 🔒 Security Scanning

```bash
# Run comprehensive security scans
./scripts/security-scan.sh

# View security reports
ls -la security-reports/
```

### 🐍 Multi-Python Testing

```bash
# Test against Python 3.9, 3.10, 3.11, 3.12 (like GitHub Actions)
./scripts/test-python-versions.sh
```

## Individual Tool Usage

### Code Formatting
```bash
# Check formatting
black --check --diff src/ tests/

# Auto-fix formatting
black src/ tests/

# Check import sorting
isort --check-only --diff src/ tests/

# Auto-fix imports
isort src/ tests/
```

### Linting
```bash
# Critical errors only
flake8 src/ tests/ --select=E9,F63,F7,F82

# All style checks
flake8 src/ tests/

# Type checking
mypy src/
```

### Testing
```bash
# Basic test run
pytest

# With coverage
pytest --cov=heresphere_stash_bridge

# With HTML coverage report
pytest --cov=heresphere_stash_bridge --cov-report=html
open htmlcov/index.html
```

### Security Tools
```bash
# Check for vulnerable dependencies
safety check

# Static security analysis
bandit -r src/

# Advanced security patterns
semgrep --config=auto src/

# Docker image security (requires trivy)
brew install trivy  # macOS
trivy image heresphere-stash-bridge:latest
```

## Docker Testing

### Build and Test
```bash
# Build production image
docker build -t heresphere-stash-bridge .

# Test with docker-compose
docker-compose up --build

# Development environment
docker-compose -f docker-compose.dev.yml up --build
```

### Security Scanning
```bash
# Scan built image
docker build -t heresphere-stash-bridge:scan .
trivy image heresphere-stash-bridge:scan
```

## Pre-commit Workflow

### Install Pre-commit Hooks
```bash
./scripts/install-hooks.sh
```

This will automatically run checks before every commit. To skip (not recommended):
```bash
git commit --no-verify
```

### Manual Pre-commit Check
```bash
# Run the same checks as the pre-commit hook
./scripts/pre-commit-hook.sh
```

## Continuous Integration Simulation

To simulate the exact GitHub Actions workflow locally:

```bash
# 1. Code quality and tests (like GitHub Actions "test" job)
./scripts/check-code.sh

# 2. Security scanning (like GitHub Actions "security" job)  
./scripts/security-scan.sh

# 3. Multi-Python testing (like GitHub Actions matrix)
./scripts/test-python-versions.sh

# 4. Docker build test
docker build -t heresphere-stash-bridge:test .
```

## Troubleshooting

### Common Issues

**Virtual Environment Not Activated:**
```bash
source venv/bin/activate
# or
./setup-dev.sh  # Re-run initial setup
```

**Missing Dependencies:**
```bash
pip install -r requirements-dev.txt
pip install -e .
```

**Docker Build Fails:**
```bash
# Check Docker daemon is running
docker info

# Clean up Docker cache
docker system prune -f
```

**Permission Denied on Scripts:**
```bash
chmod +x scripts/*.sh
```

### Tool Installation

**macOS:**
```bash
# Install additional security tools
brew install trivy semgrep

# Install development tools
brew install pre-commit
```

**Ubuntu/Debian:**
```bash
# Install additional security tools
sudo apt install trivy

# Install development tools
pip install pre-commit
```

## Configuration Files

The following files control local tool behavior:

- `.flake8` - Flake8 linting configuration
- `pyproject.toml` - Python project settings (pytest, mypy, black, isort)
- `requirements-dev.txt` - Development dependencies
- `.dockerignore` - Docker build exclusions

## IDE Integration

### VS Code
Install these extensions for automatic formatting and linting:
- Python (ms-python.python)
- Pylance (ms-python.vscode-pylance)
- Black Formatter (ms-python.black-formatter)
- Flake8 (ms-python.flake8)

### PyCharm
Configure external tools for Black, isort, and Flake8 in Settings → Tools → External Tools.

## Environment Variables

For local testing, copy and modify:
```bash
cp .env.example .env
# Edit .env with your local settings
```

## Next Steps

1. Run `./scripts/check-code.sh` before every commit
2. Install pre-commit hooks with `./scripts/install-hooks.sh`
3. Use `./scripts/format-code.sh` to auto-fix formatting issues
4. Run security scans periodically with `./scripts/security-scan.sh`
5. Test against multiple Python versions before releases with `./scripts/test-python-versions.sh`