#!/bin/bash
echo "---------------------------------------------------------------------------------------------------------"
echo ""
echo "               ATTENTION:  Vous etes dans l'Installation de Docker"
echo ""
echo "----------------------------------------------------------------------------------------------------------"
yum remove docker docker-common docker-selinux docker-engine-selinux docker-engine docker-ce podman
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager     --add-repo     https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io
systemctl enable docker.service 
systemctl start docker.service 
systemctl restart docker.service 
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version
docker swarm init
mkdir -p /app/service
useradd -m -d /app/ app
chown app:app /app/service/
usermod -a -G docker app
docker run hello-world
systemctl start docker.service  ## <-- Démarrer docker ##
systemctl stop docker.service  ## <-- Stopper docker ##
systemctl restart docker.service  ## <-- Redémarrer docker ##
systemctl status docker.service  ## <-- Obtenir le statut du docker ##
docker service ls
