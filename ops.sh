#!/bin/bash

set -e  # Exit immediately if any command fails

VERSION_NUMBER=$(cat version.txt 2>/dev/null)
VERSION_NUMBER="${VERSION_NUMBER:-1}"

cd /root/flaskdockerk8s || exit 1
git pull

echo "📦 Building Docker image version: $VERSION_NUMBER"

docker build --no-cache -t custom-img-pyapp:$VERSION_NUMBER .
docker tag custom-img-pyapp:$VERSION_NUMBER shubhamdhole97/custom-img-pyapp:$VERSION_NUMBER
docker push shubhamdhole97/custom-img-pyapp:$VERSION_NUMBER

echo "✅ Image pushed to Docker Hub"

# Update deployment.yaml with correct version (only in image line)
sed -i "s|image: shubhamdhole97/custom-img-pyapp:.*|image: shubhamdhole97/custom-img-pyapp:$VERSION_NUMBER|g" deployment.yaml

echo "🛠️ Updated deployment.yaml with version: $VERSION_NUMBER"

# Apply deployment and service
kubectl apply -f deployment.yaml
kubectl apply -f services.yaml
kubectl rollout restart deployment pyflaskdockerapp-deployment

echo "🚀 Deployment and service applied successfully"
