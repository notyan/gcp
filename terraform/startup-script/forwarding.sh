#!/bin/bash
# Enable IP forwarding
touch /home/test.sh
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# # Install iptables
# sudo apt-get update
# sudo apt-get install -y iptables-persistent

# Configure iptables for forwarding
sudo iptables -F
sudo iptables -t nat -A POSTROUTING -o $(/sbin/ifconfig | head -1 | awk -F: '{print $1}') -j MASQUERADE

# # Save iptables rules
# sudo netfilter-persistent save