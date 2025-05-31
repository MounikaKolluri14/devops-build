#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Building Docker image..."

# Build Docker image using docker-compose
docker-compose build

echo "Docker image built successfully."
