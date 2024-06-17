#!/bin/bash
set -e

# Pull the Docker image from Docker Hub
docker pull manojvaddi497/sample-java-app

# Run the Docker image as a container
docker run -d -p 5000:5000 manojvaddi497/sample-java-app