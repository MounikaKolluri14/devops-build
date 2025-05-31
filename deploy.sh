#!/bin/bash
set -e

echo "Stopping existing container(s) if any..."
docker rm -f react-production-app || true

docker-compose down

echo "Starting container(s)..."
docker-compose up -d

echo "Deployment complete. The app should now be running on port 80."


