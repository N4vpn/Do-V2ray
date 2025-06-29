#!/bin/bash

echo ""
echo "==========================================="
echo " 🚀 Script By Nanda (N4 VPN)                "
echo "==========================================="
echo ""

# === USER SET UUID ===
UUID="d4ebe6db-364b-4618-94cf-af93d177041d"  # ← မိမိ UUID ဖြည့်ပါ၊ မဖြည့်ရင် auto generate ဖြစ်မယ်

if [ -z "$UUID" ]; then
  UUID=$(cat /proc/sys/kernel/random/uuid)
fi

echo "Using UUID: $UUID"

# WebSocket Path ကိုပြင်နိုင်မယ်
WS_PATH="/TG-@n4vpn"

# Docker install လုပ်မရှိရင် install လုပ်မယ်
if ! command -v docker &> /dev/null; then
  echo "Installing Docker..."
  apt update
  apt install -y docker.io
  systemctl start docker
  systemctl enable docker
fi

mkdir -p ~/v2ray

# V2Ray Config ဖိုင်ရေးထုတ်မယ်
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
    "protocol": "freedom",
    "settings": {}
  }]
}
EOF

# Docker container ရှိရင်ရပ်ပြီး ဖျက်မယ်
docker stop v2ray 2>/dev/null
docker rm v2ray 2>/dev/null

# Docker container run command ကို config file နဲ့ တိကျစွာ သတ်မှတ်မယ်
docker run -d --name v2ray \
  -p 8080:8080 \
  -v ~/v2ray/config.json:/etc/v2ray/config.json \
  v2fly/v2fly-core \
  v2ray run -config /etc/v2ray/config.json

echo ""
echo "✅ V2Ray Docker container started successfully!"
echo ""
echo "UUID: $UUID"
echo "WebSocket Path: $WS_PATH"
echo "Port: 8080"
echo ""
echo "Script By Nanda (N4 VPN) 🚀"
echo ""
