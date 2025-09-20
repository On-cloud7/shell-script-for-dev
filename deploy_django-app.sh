#!/bin/bash

<<task
Deploy a Django app
and handle the code for errors
task

# Clone or update the repo
code_clone() {
    if [ -d "django-notes-app" ]; then
        echo "Repo already exists, pulling latest changes..."
        cd django-notes-app || { echo "Failed to enter repo"; exit 1; }
        git pull
        cd ..
    else
        echo "Cloning the code..."
        git clone https://github.com/On-cloud7/django-notes-app.git || { echo "Git clone failed"; exit 1; }
    fi
}

# Install required packages
install_requirements() {
    echo "Installing dependencies..."
    sudo apt-get update
    sudo apt-get install -y docker.io nginx || { echo "Installation failed"; exit 1; }
}

# Restart services and fix permissions
required_restart() {
    sudo chown $USER /var/run/docker.sock
    sudo systemctl enable docker
    sudo systemctl enable nginx
    sudo systemctl restart docker || { echo "Failed to restart Docker"; exit 1; }
    sudo systemctl restart nginx || { echo "Failed to restart Nginx"; exit 1; }
}

# Build and run Docker container
deploy() {
    cd django-notes-app || { echo "Repo not found"; exit 1; }

    # Remove old container if exists
    docker rm -f notes-app-container 2>/dev/null || true

    echo "Building Docker image..."
    docker build -t notes-app . || { echo "Docker build failed"; exit 1; }

    echo "Running Docker container..."
    docker run -d --name notes-app-container -p 8000:8000 notes-app:latest || { echo "Docker run failed"; exit 1; }
}

echo "*********************** DEPLOYMENT START ***********************"

code_clone
install_requirements
required_restart
deploy

echo "*********************** DEPLOYMENT DONE ***********************"
