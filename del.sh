#!/bin/bash
clear

green="\e[38;5;82m"
red="\e[38;5;196m"
yellow="\e[38;5;226m"
neutral="\e[0m"

echo -e "${yellow}⚠️ Menghapus API & Service...${neutral}"

# Stop & disable service
systemctl stop apisellvpn.service >/dev/null 2>&1
systemctl disable apisellvpn.service >/dev/null 2>&1

# Hapus file service
rm -f /etc/systemd/system/apisellvpn.service
systemctl daemon-reload

# Hapus script runner
rm -f /usr/bin/apisellvpn

# Hapus folder API
rm -rf /usr/bin/komtol

# Hapus config bot
rm -f /etc/botapi.conf

# Hapus AUTH_KEY dari profile
sed -i '/export AUTH_KEY=/d' /etc/profile

# Kill port 5889 jika masih jalan
CEK_PORT=$(lsof -i:5889 | awk 'NR>1 {print $2}' | sort -u)
if [[ -n "$CEK_PORT" ]]; then
    echo -e "${yellow}🔪 Kill proses port 5889...${neutral}"
    echo "$CEK_PORT" | xargs kill -9
fi

echo -e "${green}✅ Berhasil dihapus semua!${neutral}"
