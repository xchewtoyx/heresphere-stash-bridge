#!/bin/bash
# Comprehensive security scan script

set -e

echo "🔒 Running comprehensive security scans..."
echo "========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

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
    if [ -f "venv/bin/activate" ]; then
        source venv/bin/activate
    fi
fi

# Install security tools if not present
echo "📦 Installing security tools..."
pip install safety bandit semgrep > /dev/null 2>&1

# Create reports directory
mkdir -p security-reports

echo ""
echo "🔍 Dependency vulnerability scan..."
echo "-----------------------------------"

# Safety - Check dependencies for known vulnerabilities
if safety check --json --output security-reports/safety-report.json; then
    print_status "No known vulnerabilities in dependencies"
else
    print_warning "Potential vulnerabilities found - check security-reports/safety-report.json"
    safety check || true
fi

echo ""
echo "🔒 Static security analysis..."
echo "------------------------------"

# Bandit - Static security analysis for Python code
if bandit -r src/ -f json -o security-reports/bandit-report.json; then
    print_status "No security issues found in code"
else
    print_warning "Potential security issues found - check security-reports/bandit-report.json"
    bandit -r src/ || true
fi

echo ""
echo "🎯 Advanced security patterns..."
echo "-------------------------------"

# Semgrep - Advanced security pattern matching
if semgrep --config=auto src/ --json --output=security-reports/semgrep-report.json; then
    print_status "No security patterns detected"
else
    print_warning "Security patterns detected - check security-reports/semgrep-report.json"
    semgrep --config=auto src/ || true
fi

echo ""
echo "🐳 Docker image security scan..."
echo "-------------------------------"

# Build image for scanning
if docker build -t heresphere-stash-bridge:security-scan . > /dev/null 2>&1; then
    print_status "Docker image built for security scanning"
    
    # Try to run Trivy if available
    if command -v trivy &> /dev/null; then
        echo "Running Trivy vulnerability scan..."
        if trivy image --format json --output security-reports/trivy-report.json heresphere-stash-bridge:security-scan; then
            print_status "Trivy scan completed"
        else
            print_warning "Trivy scan found issues - check security-reports/trivy-report.json"
        fi
    else
        print_warning "Trivy not installed. Install with: brew install trivy (macOS) or apt install trivy (Linux)"
    fi
    
    # Clean up
    docker rmi heresphere-stash-bridge:security-scan > /dev/null 2>&1
else
    print_error "Failed to build Docker image for scanning"
fi

echo ""
echo "📊 Security scan summary..."
echo "============================="

echo "Reports generated in security-reports/:"
ls -la security-reports/ 2>/dev/null || echo "No reports directory found"

echo ""
echo "🎯 Recommendations:"
echo "- Review any warnings in the reports"
echo "- Update dependencies if vulnerabilities found"
echo "- Fix any security issues in code"
echo "- Run 'pip-audit' for additional dependency checking"
echo ""

print_status "Security scan completed!"