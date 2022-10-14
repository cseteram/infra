#!/bin/sh

# Configure SSH key
curl -sSL https://github.com/cseteram.keys >> /home/ubuntu/.ssh/authorized_keys

# Install haproxy
sudo apt update
sudo apt install -y haproxy
cat > /etc/haproxy/haproxy.cfg << EOT
global
    log /dev/log local0
    log /dev/log local1 notice
    chroot /var/lib/haproxy
    stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
    stats timeout 30s
    user haproxy
    group haproxy
    daemon

defaults
    log     global
    mode    tcp
    option  httplog
    option  dontlognull
    timeout connect 5000
    timeout client  50000
    timeout server  50000

listen k0s-http
    bind *:80
    server k0s 127.0.0.1:30080

listen k0s-https
    bind *:443
    server k0s 127.0.0.1:30443
EOT
sudo systemctl reload haproxy
