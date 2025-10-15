#!/bin/bash
# Test different Python versions locally using Docker

set -e

echo "🐍 Testing multiple Python versions..."
echo "======================================"

# Python versions to test (matching GitHub Actions)
PYTHON_VERSIONS=("3.9" "3.10" "3.11" "3.12")

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_info() {
    echo -e "${YELLOW}[ℹ]${NC} $1"
}

# Function to test a specific Python version
test_python_version() {
    local version=$1
    echo ""
    print_info "Testing Python $version..."
    echo "----------------------------------------"
    
    # Create a temporary Dockerfile for this version
    cat > Dockerfile.test <<EOF
FROM python:${version}-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \\
    curl \\
    && rm -rf /var/lib/apt/lists/*

# Copy requirements
COPY requirements-dev.txt .

# Install Python dependencies
RUN pip install --upgrade pip && \\
    pip install -r requirements-dev.txt

# Copy source code
COPY src/ ./src/
COPY tests/ ./tests/
COPY config/ ./config/
COPY pyproject.toml .

# Install the application
RUN pip install -e .

# Run tests
CMD ["pytest", "--cov=heresphere_stash_bridge", "--cov-report=term-missing"]
EOF

    # Build and run tests
    local image_name="heresphere-test-py${version}"
    
    if docker build -f Dockerfile.test -t $image_name . > /dev/null 2>&1; then
        if docker run --rm $image_name; then
            print_status "Python $version tests passed"
        else
            print_error "Python $version tests failed"
            return 1
        fi
    else
        print_error "Failed to build Python $version test image"
        return 1
    fi
    
    # Clean up
    docker rmi $image_name > /dev/null 2>&1
    rm -f Dockerfile.test
}

# Test each Python version
FAILED_VERSIONS=()

for version in "${PYTHON_VERSIONS[@]}"; do
    if ! test_python_version $version; then
        FAILED_VERSIONS+=($version)
    fi
done

# Summary
echo ""
echo "📊 Test Summary"
echo "==============="

if [ ${#FAILED_VERSIONS[@]} -eq 0 ]; then
    print_status "All Python versions passed tests!"
    echo "✅ Python 3.9, 3.10, 3.11, 3.12 - All tests passed"
else
    print_error "Some Python versions failed:"
    for version in "${FAILED_VERSIONS[@]}"; do
        echo "❌ Python $version - Tests failed"
    done
    exit 1
fi

echo ""
print_status "Multi-version testing completed successfully!"