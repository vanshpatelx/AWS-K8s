#!/bin/bash

# Function to print colored messages
print_message() {
    echo -e "\e[1;32m$1\e[0m"
}

# Delete all deployments and services in Kubernetes
print_message "Deleting all Kubernetes deployments and services..."
kubectl delete deployments --all --all-namespaces
kubectl delete services --all --all-namespaces
kubectl delete pods --all --all-namespaces
kubectl delete namespaces --all

# Stop and remove Docker containers, images, and volumes
print_message "Stopping and removing all Docker containers, images, and volumes..."
docker stop $(docker ps -aq) || true
docker rm $(docker ps -aq) || true
docker rmi $(docker images -q) || true
docker volume rm $(docker volume ls -q) || true

# Disable and remove Docker
print_message "Disabling and removing Docker services..."
sudo systemctl stop docker
sudo systemctl disable docker
sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd

# Remove cri-dockerd service and socket files
print_message "Removing cri-dockerd service files..."
sudo systemctl stop cri-docker.service cri-docker.socket || true
sudo systemctl disable cri-docker.service cri-docker.socket || true
sudo rm -f /etc/systemd/system/cri-docker.service /etc/systemd/system/cri-docker.socket
sudo rm -rf /usr/local/bin/cri-dockerd
sudo rm -rf ~/bin/cri-dockerd*

# Reload systemd
print_message "Reloading systemd daemon..."
sudo systemctl daemon-reload

# Uninstall Kubernetes components
print_message "Removing Kubernetes components..."
sudo kubeadm reset -f
sudo apt-get purge -y kubelet kubeadm kubectl
sudo apt-get autoremove -y
sudo rm -rf ~/.kube /etc/kubernetes /var/lib/etcd /var/lib/kubelet /var/lib/dockershim

# Clean package cache
print_message "Cleaning package cache..."
sudo apt-get clean
sudo rm -rf /etc/apt/sources.list.d/docker.list
sudo rm -rf /etc/apt/sources.list.d/kubernetes.list

print_message "System cleanup complete!"