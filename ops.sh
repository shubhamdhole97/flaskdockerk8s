#!/bin/bash

set -e  # Exit on error

VERSION_NUMBER=$(cat version.txt 2>/dev/null)
VERSION_NUMBER="${VERSION_NUMBER:-1}"

cd /root/flaskdockerk8s
git pull

echo "📦 Building Docker image version: $VERSION_NUMBER"

docker build -t custom-img-pyapp:$VERSION_NUMBER .
docker tag custom-img-pyapp:$VERSION_NUMBER shubhamdhole97/custom-img-pyapp:$VERSION_NUMBER
docker push shubhamdhole97/custom-img-pyapp:$VERSION_NUMBER

echo "✅ Image pushed to Docker Hub"

# Run container locally (Optional, for testing)
# docker run --rm -p 8000:8000 custom-img-pyapp:$VERSION_NUMBER

# Update image tag in deployment.yaml
sed -i "s|\(image: shubhamdhole97/custom-img-pyapp:\).*|\1$VERSION_NUMBER|" deployment.yaml

echo "📦 Updated deployment.yaml with image version: $VERSION_NUMBER"

kubectl apply -f deployment.yaml

echo "🚀 Kubernetes deployment updated to version $VERSION_NUMBER"
