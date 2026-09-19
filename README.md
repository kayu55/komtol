# 🚀 API Komtol

API sederhana berbasis **Node.js + Express** untuk auto create, trial, dan renew akun VPN (SSH, VMESS, VLESS, TROJAN, SHADOWSOCKS).

---

## ⚡ QUICK INSTALL

### 📥 Install API

```bash id="installapi"
wget -q https://raw.githubusercontent.com/kayu55/komtol/main/api.sh && chmod +x api.sh && ./api.sh && rm -rf api.sh
```

### 🗑️ Delete / Uninstall API

```bash id="deleteapi"
wget -q https://raw.githubusercontent.com/kayu55/komtol/main/del.sh && chmod +x del.sh && ./del.sh && rm -rf del.sh
```

---

## 🤖 AUTO ORDER BOT (READY)

Sudah tersedia bot auto order siap pakai:

👉 [https://github.com/kayu55/BotVPN2](https://github.com/kayu55/BotVPN2)

Bot ini sudah **support langsung API ini**, tinggal setting:

* IP Server
* AUTH_KEY
* PORT (default 5889)

### 🔥 Kelebihan BotVPN2

* Auto create akun (SSH, VMESS, VLESS, dll)
* Auto kirim ke user (Telegram)
* Support payment / manual / auto
* Cocok untuk jualan VPN

---

## 📂 Struktur Repository

```id="struktur"
.
├── api.sh
├── del.sh
├── api-ari.zip
└── README.md
```

---

## ⚙️ Fitur Utama

### ✅ CREATE AKUN

* `/createssh`
* `/createvmess`
* `/createvless`
* `/createtrojan`
* `/createshadowsocks`

### 🎁 TRIAL AKUN

* `/trialssh`
* `/trialvmess`
* `/trialvless`
* `/trialtrojan`
* `/trialshadowsocks`

### 🔄 RENEW AKUN

* `/renewssh`
* `/renewvmess`
* `/renewvless`
* `/renewtrojan`
* `/renewshadowsocks`

---

## 🔐 Security

Gunakan AUTH_KEY:

```id="auth"
auth=ISI_AUTH_KEY
```

---

## 📡 Port Default

```id="port"
5889
```

---

## 📌 Contoh Request

### 🔹 CREATE SSH

```id="req1"
http://IP:5889/createssh?user=test&password=123&exp=1&iplimit=1&auth=KEY
```

### 🔹 CREATE VMESS

```id="req2"
http://IP:5889/createvmess?user=test&exp=1&iplimit=1&quota=10&auth=KEY
```

### 🔹 TRIAL SSH

```id="req3"
http://IP:5889/trialssh?auth=KEY
```

### 🔹 RENEW SSH

```id="req4"
http://IP:5889/renewssh?user=test&exp=1&iplimit=1&auth=KEY
```

---

## 📦 Response JSON

```json id="json"
{
  "status": "success",
  "message": "Akun berhasil dibuat",
  "data": {
    "username": "test",
    "domain": "example.com",
    "expired": "7 Days",
    "uuid": "xxxx",
    "vmess_tls_link": "...",
    "vless_tls_link": "...",
    "trojan_tls_link": "..."
  }
}
```

---

## ⚠️ Requirement

* Ubuntu / Debian / Kali Linux
* Node.js v20+
* Script backend (create, trial, renew)

---

## 👨‍💻 Author

**komtol**

---

## ⭐ Notes

Pastikan semua script seperti:

```id="notes"
create_ssh.sh
trial_vmess.sh
renew_vless.sh
```

sudah tersedia di server.

---
