#!/bin/bash

# === USER SET UUID ===
UUID="d4ebe6db-364b-4618-94cf-af93d177041d"  # ← here add in your own uuid

# Auto-generate UUID if not set
if [ -z "$UUID" ]; then
  UUID=$(cat /proc/sys/kernel/random/uuid)
fi

echo "Using UUID: $UUID"

# Docker install check
if ! command -v docker &> /dev/null; then
  echo "Installing Docker..."
  apt update
  apt install -y docker.io
  systemctl start docker
  systemctl enable docker
fi

mkdir -p ~/v2ray

# Create config.json
cat > ~/v2ray/config.json <<EOF
{
  "inbounds": [{
    "port": 8080,
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
        "path": "/TG-@n4vpn"
      }
    }
  }],
  "outbounds": [{
    "protocol": "freedom"
  }]
}
EOF

docker run -d --name v2ray \
  -v ~/v2ray/config.json:/etc/v2ray/config.json \
  -p 8080:8080 \
  v2fly/v2fly-core

if command -v ufw &> /dev/null; then
  ufw allow 8080/tcp
  ufw reload
fi

echo "✅ V2Ray Installed Successfully"
echo "UUID: $UUID"
echo "WebSocket path: /TG-@n4vpn"
echo "Port: 8080"
echo "Use this config with your GCP Cloud Run proxy."
