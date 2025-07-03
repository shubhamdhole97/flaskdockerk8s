#!/bin/bash

VERSION_NUMBER=$(cat version.txt 2>/dev/null)
VERSION_NUMBER="${VERSION_NUMBER:-1}"

cd /root/flaskdockerk8s
git pull

# Build, tag, push image
docker build -t custom-img-pyapp:$VERSION_NUMBER .
docker tag custom-img-pyapp:$VERSION_NUMBER shubhamdhole97/custom-img-pyapp:$VERSION_NUMBER
docker push shubhamdhole97/custom-img-pyapp:$VERSION_NUMBER

# OPTIONAL: Run container locally for testing
docker run --rm -p 8000:8000 custom-img-pyapp:$VERSION_NUMBER

# Update image tag in deployment.yaml
sed -i "s|\(image: shubhamdhole97/custom-img-pyapp:\).*|\1$VERSION_NUMBER|" deployment.yaml

# Apply updated deployment to Kubernetes
kubectl apply -f deployment.yaml

echo "✅ Image pushed and Kubernetes deployment updated to version $VERSION_NUMBER"
