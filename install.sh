#!/bin/bash
echo ""
echo "==========================================="
echo " 🚀 Script By Nanda (N4 VPN)                "
echo "==========================================="
echo ""
# === USER SET UUID ===
UUID="d4ebe6db-364b-4618-94cf-af93d177041d"  # Change to your UUID if needed
WS_PATH="/TG-@n4vpn"

# Enter your Cloud Run Hostname here (ex: my-app-abc123.run.app)
CLOUD_RUN_HOST="nanda-xxxx.us-east4.run.app"

# Auto-generate UUID if not set
if [ -z "$UUID" ]; then
  UUID=$(cat /proc/sys/kernel/random/uuid)
fi

echo "Using UUID: $UUID"

# Install Docker if not present
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
        "id": "$UUID"
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

# Run V2Ray container
docker run -d --name v2ray --restart unless-stopped -v ~/v2ray/config.json:/etc/v2ray/config.json -p 8080:8080 v2fly/v2fly-core

# Generate VLESS URL
echo
echo "✅ V2Ray (WebSocket) installed successfully!"
echo "🌐 Cloud Run Proxy Host: $CLOUD_RUN_HOST"
echo
echo "👉 VLESS Config URL:"
echo "vless://$UUID@$CLOUD_RUN_HOST:443?encryption=none&security=tls&type=ws&host=$CLOUD_RUN_HOST&path=$(echo $WS_PATH | sed 's/\//%2F/g')#GCP-Proxy"
echo "ဒီ Url ကို Copy ယူပြီး Note ထဲ ခဏသိမ်းထားပါ။ CloudRun Host ရလာရင် Host ပြောင်းပီး တန်းသုံးရုံပါပဲ"
echo ""
echo "==========================================="
echo " Join Telegram Channel  https://t.me/n4vpn "
echo "==========================================="
