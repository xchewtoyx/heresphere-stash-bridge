#!/bin/bash
# Docker build and push script

set -e

# Configuration
IMAGE_NAME="heresphere-stash-bridge"
REGISTRY="docker.io"  # Change to your registry
USERNAME="your-dockerhub-username"  # Change to your Docker Hub username

# Parse command line arguments
VERSION=${1:-latest}
PUSH=${2:-false}

# Build the image
echo "Building Docker image: ${REGISTRY}/${USERNAME}/${IMAGE_NAME}:${VERSION}"
docker build -t ${REGISTRY}/${USERNAME}/${IMAGE_NAME}:${VERSION} .

# Also tag as latest if not already
if [ "$VERSION" != "latest" ]; then
    docker tag ${REGISTRY}/${USERNAME}/${IMAGE_NAME}:${VERSION} ${REGISTRY}/${USERNAME}/${IMAGE_NAME}:latest
fi

# Push if requested
if [ "$PUSH" = "true" ]; then
    echo "Pushing to registry..."
    docker push ${REGISTRY}/${USERNAME}/${IMAGE_NAME}:${VERSION}
    if [ "$VERSION" != "latest" ]; then
        docker push ${REGISTRY}/${USERNAME}/${IMAGE_NAME}:latest
    fi
    echo "Push completed!"
else
    echo "Build completed! To push to registry, run:"
    echo "docker push ${REGISTRY}/${USERNAME}/${IMAGE_NAME}:${VERSION}"
fi