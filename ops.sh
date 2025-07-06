#!/bin/bash

set -e  # Exit immediately if any command fails

cd /root/flaskdockerk8s || exit 1

# Pull latest code
echo "🔄 Pulling latest code from Git..."
git pull

# Read current version or set to 0 if file doesn't exist
VERSION_NUMBER=$(cat version.txt 2>/dev/null)
VERSION_NUMBER="${VERSION_NUMBER:-0}"

# Increment version
VERSION_NUMBER=$((VERSION_NUMBER + 1))
echo "$VERSION_NUMBER" > version.txt

echo "🚀 Building Docker image version: $VERSION_NUMBER"

# Build and push image
docker build --no-cache -t custom-img-pyapp:$VERSION_NUMBER .
docker tag custom-img-pyapp:$VERSION_NUMBER shubhamdhole97/custom-img-pyapp:$VERSION_NUMBER
docker push shubhamdhole97/custom-img-pyapp:$VERSION_NUMBER

echo "✅ Image pushed to Docker Hub: shubhamdhole97/custom-img-pyapp:$VERSION_NUMBER"

# Update deployment.yaml with new version
sed -i "s|image: shubhamdhole97/custom-img-pyapp:.*|image: shubhamdhole97/custom-img-pyapp:$VERSION_NUMBER|g" deployment.yaml

echo "🛠️ Updated deployment.yaml with version: $VERSION_NUMBER"

# Apply deployment and service
kubectl apply -f deployment.yaml
kubectl apply -f services.yaml

echo "🎉 Deployment and service applied successfully!"
echo "📦 Current Version: $VERSION_NUMBER"
