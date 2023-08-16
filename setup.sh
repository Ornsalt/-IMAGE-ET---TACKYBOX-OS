#!/bin/bash

# Distro update.
sh -c "apt-get update && apt-get upgrade -y"

#install dependencies.
sh -c "apt-get install -y  ssh git make curl gnupg net-tools lsb-release ca-certificates"

# Distro spring cleaning.
sh -c "apt-get autoremove -y && apt-get clean -y"

# Docker's setup.
mkdir -p /etc/apt/keyrings && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
chmod a+r /etc/apt/keyrings/docker.gpg

# Docker's install
sh -c "apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io"

# Docker is a pesky bird so the script will use a trick to not force you to be a sudoer.
groupadd docker
usermod -aG docker $USER
reboot