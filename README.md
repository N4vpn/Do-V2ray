# 🌐 Do-V2ray (V2Ray + WebSocket + Cloud Run Proxy)

🚀 One-click V2Ray server installation script for **DigitalOcean VPS** using **VLESS over WebSocket**, reverse proxied through **Google Cloud Run**.

> ✨ Script by: **Nanda (N4 VPN)**  
> 🐧 OS Supported: Ubuntu 20.04 / 22.04 / 24.04  
> ⚙️ Setup Method: Docker + Bash  
> 🌐 Project: https://github.com/N4vpn/Do-V2ray

---

## 📥 Installation

Run the following one-liner command on your fresh VPS:

```bash
bash <(curl -Ls https://raw.githubusercontent.com/N4vpn/Do-V2ray/main/install.sh)
```

## ⚙️ Customization

- UUID: You can manually set your UUID inside `install.sh`. If left blank, it will auto-generate one.
- WebSocket Path: Default is `/TG-@n4vpn`. Changeable in `install.sh`.

## ✅ Script Features

- Installs Docker if not present
- Auto-generates V2Ray config file (VLESS over WebSocket)
- Starts V2Ray container with persistent config
- Displays connection info at the end

## 📄 Generated Config

Example config:
```json
{
  "inbounds": [{
    "port": 8080,
    "protocol": "vless",
    "settings": {
      "clients": [{
        "id": "your-uuid-here",
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
    "protocol": "freedom",
    "settings": {}
  }]
}
```

---

## 🌍 Connect From Client

Example VLESS URL:

```
vless://your-uuid@cloud-run-host:443?encryption=none&security=tls&type=ws&host=cloud-run-host&path=/TG-@n4vpn#N4VPN
```

Replace:
- `your-uuid` with your UUID
- `cloud-run-host` with your Cloud Run domain

---

## 🔧 Manual Docker Restart

```bash
docker restart v2ray
```

---

## 📜 License

MIT License

© 2025 Nanda (N4 VPN)
