#!/bin/bash

echo ""
echo "==========================================="
echo " 🚀 Script By Nanda (N4 VPN)"
echo "==========================================="
echo ""

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

if ! command -v docker &> /dev/null; then
  echo "📦 Installing Docker..."
  apt update -y
  apt install -y docker.io
  systemctl start docker
  systemctl enable docker
else
  echo "✅ Docker already installed."
fi

mkdir -p ~/v2ray

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

docker rm -f v2ray 2>/dev/null

echo "🚀 Starting V2Ray docker container..."
docker run -d --name v2ray \
  -p $PORT:$PORT \
  -v ~/v2ray/config.json:/etc/v2ray/config.json \
  v2fly/v2fly-core \
  run -config /etc/v2ray/config.json

sleep 3

docker ps -a --filter name=v2ray | grep v2ray > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo ""
  echo "✅ V2Ray started successfully!"
  echo "UUID: $UUID"
  echo "WebSocket Path: $WS_PATH"
  echo "Port: $PORT"

  VLESS_URL="vless://${UUID}@${DOMAIN}:${PORT}?type=ws&security=none&path=${WS_PATH}#N4VPN"
  echo ""
  echo "📢 Your VLESS URL:"
  echo "$VLESS_URL"
else
  echo "❌ V2Ray container failed to start."
fi
