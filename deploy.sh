#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

echo "Stopping existing container(s) if any..."
docker-compose down

echo "Starting container(s)..."
docker-compose up -d

echo "Deployment complete. The app should now be running on port 80."

