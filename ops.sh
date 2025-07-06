#!/bin/bash

VERSION_NUMBER=$(cat version.txt 2>/dev/null)
VERSION_NUMBER="${VERSION_NUMBER:-1}"

cd /root/flaskdockerk8s || exit 1
git pull

echo "📦 Building Docker image version: $VERSION_NUMBER"

docker build --no-cache -t custom-img-pyapp:$VERSION_NUMBER .
docker tag custom-img-pyapp:$VERSION_NUMBER shubhamdhole97/custom-img-pyapp:$VERSION_NUMBER
docker push shubhamdhole97/custom-img-pyapp:$VERSION_NUMBER

echo "✅ Image pushed to Docker Hub"

# Update deployment.yaml with correct version
sed -i "s|shubhamdhole97/custom-img-pyapp:.*|shubhamdhole97/custom-img-pyapp:$VERSION_NUMBER|g" deployment.yaml

echo "🛠️ Updated deployment.yaml with version: $VERSION_NUMBER"

# Apply deployment
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
