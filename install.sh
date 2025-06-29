#!/bin/bash

echo "" echo "===========================================" echo " 🚀 Script By Nanda (N4 VPN)                " echo "===========================================" echo ""

=== USER SET UUID ===

UUID="d4ebe6db-364b-4618-94cf-af93d177041d"  # ← Change this to your own UUID if needed

Auto-generate UUID if not set

if [ -z "$UUID" ]; then UUID=$(cat /proc/sys/kernel/random/uuid) fi

WebSocket path (can customize)

WS_PATH="/TG-@n4vpn"

Display config

echo "Using UUID: $UUID" echo "WS Path: $WS_PATH" echo "Port: 8080"

Install Docker if not found

if ! command -v docker &> /dev/null; then echo "Installing Docker..." apt update apt install -y docker.io systemctl start docker systemctl enable docker fi

Prepare v2ray config directory

mkdir -p ~/v2ray

Write V2Ray config.json

cat > ~/v2ray/config.json <<EOF { "inbounds": [{ "port": 8080, "protocol": "vless", "settings": { "clients": [{ "id": "$UUID", "flow": "xtls-rprx-vision" }], "decryption": "none" }, "streamSettings": { "network": "ws", "wsSettings": { "path": "$WS_PATH" } } }], "outbounds": [{ "protocol": "freedom", "settings": {} }] } EOF

echo "Starting V2Ray docker container..."

Remove existing container if exists

docker rm -f v2ray 2>/dev/null

Run V2Ray container

docker run -d --name v2ray 
-p 8080:8080 
-v ~/v2ray/config.json:/etc/v2ray/config.json 
v2fly/v2fly-core 
v2ray -config /etc/v2ray/config.json

echo "===========================================" echo " ✅ V2Ray deployed with Docker successfully." echo " UUID: $UUID" echo " WS Path: $WS_PATH" echo " Port: 8080" echo "==========================================="

Optional: Generate client config URL

echo "" echo "Client VLESS URL:" echo "vless://$UUID@your-domain.com:443?encryption=none&security=tls&type=ws&host=your-domain.com&path=%2F$(echo $WS_PATH | sed 's/^///')#N4VPN"

