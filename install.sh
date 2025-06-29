#!/bin/bash

echo ""
echo "==========================================="
echo " 🚀 Script By Nanda (N4 VPN) - Fixed Version"
echo "==========================================="
echo ""

# Get user input
read -p "Enter your VPS domain or IP address: " DOMAIN
if [[ -z "$DOMAIN" ]]; then
  echo "❌ Domain or IP cannot be empty. Exiting."
  exit 1
fi

read -p "Enter your UUID (leave empty for auto generate): " UUID
if [[ -z "$UUID" ]]; then
  UUID=$(cat /proc/sys/kernel/random/uuid)
  echo "🆔 No UUID provided, auto generated: $UUID"
else
  echo "🆔 Using provided UUID: $UUID"
fi

WS_PATH="/TG-@n4vpn"
PORT=8080

# Install Docker if not exists
if ! command -v docker &> /dev/null; then
  echo "📦 Installing Docker..."
  apt update -y
  apt install -y docker.io
  systemctl start docker
  systemctl enable docker
else
  echo "✅ Docker already installed."
fi

# Create config directory
mkdir -p ~/v2ray

# Generate config file
cat > ~/v2ray/config.json <<EOF
{
  "inbounds": [{
    "port": $PORT,
    "protocol": "vless",
    "settings": {
      "clients": [{
        "id": "$UUID",
        "flow": "xtls-rprx-vision"
      }],
      "decryption": "none"
    },
    "streamSettings": {
      "network": "ws",
      "wsSettings": {
        "path": "$WS_PATH"
      }
    }
  }],
  "outbounds": [{
    "protocol": "freedom",
    "settings": {}
  }]
}
EOF

# Remove old container if exists
docker rm -f v2ray 2>/dev/null

# Start new container with corrected command
echo "🚀 Starting V2Ray docker container..."
docker run -d \
  --name v2ray \
  --restart unless-stopped \
  -p $PORT:$PORT \
  -v ~/v2ray/config.json:/etc/v2ray/config.json \
  v2fly/v2fly-core:latest \
  /usr/bin/v2ray -config /etc/v2ray/config.json

sleep 3

# Check status
if docker ps | grep -q v2ray; then
  echo ""
  echo "✅ V2Ray started successfully!"
  echo "UUID: $UUID"
  echo "WebSocket Path: $WS_PATH"
  echo "Port: $PORT"

  VLESS_URL="vless://${UUID}@${DOMAIN}:${PORT}?type=ws&security=none&path=${WS_PATH}#N4VPN"
  echo ""
  echo "📢 Your VLESS URL:"
  echo "$VLESS_URL"
  
  # Generate QR code if qrencode installed
  if command -v qrencode &> /dev/null; then
    echo ""
    echo "📲 QR Code:"
    qrencode -t UTF8 <<< "$VLESS_URL"
  fi
else
  echo "❌ V2Ray container failed to start."
  echo "Check logs with: docker logs v2ray"
fi
