# 🌐 Do-V2ray (V2Ray + WebSocket + Cloud Run Proxy)

🚀 One-click V2Ray Server installation on DigitalOcean VPS with WebSocket (WS) support, optimized to work with **Google Cloud Run** as a reverse proxy.

> ✅ Script By: **Nanda (N4 VPN)**  
> 📌 Language: Bash + Docker  
> 🌍 Supports: Ubuntu 20.04 / 22.04 / 24.04 VPS (Tested on DigitalOcean)

---

## 🔧 Features

- Installs latest **V2Fly-core** via Docker
- Sets up **VLESS + WebSocket** on port `8080`
- Easy to customize UUID and WebSocket path
- Auto-generates UUID if none provided
- Works perfectly with **Cloud Run Reverse Proxy**
- Fast deployment with:  
  ```bash
  bash <(curl -Ls https://raw.githubusercontent.com/N4vpn/Do-V2ray/main/install.sh)
