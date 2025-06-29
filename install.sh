#!/bin/bash
echo ""
echo "==========================================="
echo " 🚀 Script By Nanda (N4 VPN)                "
echo "==========================================="
echo ""

# === USER SET ===
UUID="d4ebe6db-364b-4618-94cf-af93d177041d"
WS_PATH="/TG-@n4vpn"
CLOUD_RUN_HOST="nanda-xxxx.us-east4.run.app"

# Auto-generate UUID if empty
if [ -z "$UUID" ]; then
  UUID=$(cat /proc/sys/kernel/random/uuid)
fi

echo "Using UUID: $UUID"

# Install Docker if needed
if ! command -v docker &> /dev/null; then
  echo "Installing Docker..."
  apt update
  apt install -y docker.io
  systemctl start docker
  systemctl enable docker
fi

# Create directory and config
mkdir -p ~/v2ray

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
        "path": "$WS_PATH"
      }
    }
  }],
  "outbounds": [{
    "protocol": "freedom"
  }]
}
EOF

# Start V2Ray container
docker rm -f v2ray > /dev/null 2>&1
docker run -d --name v2ray \
  --restart unless-stopped \
  -v ~/v2ray/config.json:/etc/v2ray/config.json \
  -p 8080:8080 \
  v2fly/v2fly-core

# Generate VLESS URL
echo ""
echo "🎉 V2Ray setup completed!"
echo "==========================================="
echo "✅ VLESS URL (import into v2ray clients):"
echo ""
echo "vless://$UUID@$CLOUD_RUN_HOST:443?encryption=none&security=tls&type=ws&host=$CLOUD_RUN_HOST&path=$WS_PATH#N4VPN"
echo "==========================================="
