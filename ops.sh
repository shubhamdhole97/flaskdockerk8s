#!/bin/bash
VERSION_NUMBER=$(cat version.txt 2>/dev/null)
VERSION_NUMBER="${VERSION_NUMBER:-1}"
cd /home/dhole/flaskdockerk8s
git pull
docker build -t custom-img-pyapp:$VERSION_NUMBER .
docker tag custom-img-pyapp:$VERSION_NUMBER shubhamdhole97/custom-img-pyapp:$VERSION_NUMBER
docker push shubhamdhole97/custom-img-pyapp:$VERSION_NUMBER
docker run --rm -p 8000:8000 custom-img-pyapp:$VERSION_NUMBER
