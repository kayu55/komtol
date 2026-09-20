#!/bin/bash
clear

# === WARNA ===
green="\e[38;5;82m"
red="\e[38;5;196m"
neutral="\e[0m"
orange="\e[38;5;130m"
blue="\e[38;5;39m"
yellow="\e[38;5;226m"
purple="\e[38;5;141m"
bold_white="\e[1;37m"
reset="\e[0m"

# === HEADER ===
print_header() {
    echo -e "${green}⚡ API :: [API SYSTEM]${neutral}"
    echo -e "${blue}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${neutral}"
    echo -e "   ⚙️ ${bold_white}Secure${neutral} | ${green}Fast${neutral} | ${purple}Stable${neutral}"
    echo -e "${blue}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${neutral}\n"
}

# === RAINBOW TEXT ===
print_rainbow() {
    local text="$1"
    for ((i=0;i<${#text};i++)); do
        printf "\e[38;5;$((RANDOM%200+20))m${text:$i:1}"
    done
    echo -e "$reset"
}

# === STATUS SERVICE ===
cek_status() {
    if systemctl is-active --quiet "$1"; then
        echo -e "${green}ONLINE${neutral}"
    else
        echo -e "${red}OFFLINE${neutral}"
    fi
}

# === SETUP BOT ===
setup_bot() {
    print_header
    print_rainbow "🚀 Initializing Setup..."

    # Cleanup lama
    rm -rf /usr/bin/api-kontol >/dev/null 2>&1
    rm -f /usr/bin/komtol.zip

    NODE_VERSION=$(node -v 2>/dev/null | grep -oP '(?<=v)\d+' || echo "0")
    rm -f /var/lib/dpkg/stato* /var/lib/dpkg/lock*

    if [ "$NODE_VERSION" -lt 22 ]; then
        echo -e "${yellow}Install Node.js v22...${neutral}"
        curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
        apt-get install -y nodejs
        npm install -g npm@latest
    else
        echo -e "${green}Node.js v$NODE_VERSION OK${neutral}"
    fi

    # === DOWNLOAD API KONTOL ===
    if [ ! -f /usr/bin/api-ari/api.js ]; then
        echo -e "${blue}Download API...${neutral}"
        wget https://raw.githubusercontent.com/kayu55/komtol/main/komtol.zip
        mv komtol/* /usr/usr/sbin
        cd /usr/bin
        unzip komtol.zip
        rm komtol.zip*
        chmod +x komtol/*
        cd
    fi

        # === Install Dependencies ===
    npm list --prefix /usr/bin/api-kontol express child_process >/dev/null 2>&1 || {
        echo -e "${yellow}📦 Installing dependencies...${neutral}"
        npm install --prefix /usr/bin/api-kontol express child_process
    }

    # === Generate AUTH_KEY ===
    NEW_AUTH_KEY=$(openssl rand -hex 3)
    sed -i '/export AUTH_KEY=/d' /etc/profile
    echo "export AUTH_KEY=\"$NEW_AUTH_KEY\"" >> /etc/profile
    source /etc/profile

    SERVER_IP=$(curl -sS ipv4.icanhazip.com)
    DOMAIN=$(cat /etc/xray/domain 2>/dev/null || echo "(Domain not set)")

    echo -e "${purple}🤖 Enter Telegram Bot Token:${neutral}"
    read -rp "Token: " BOT_TOKEN
    echo -e "${purple}💬 Enter Telegram Chat ID:${neutral}"
    read -rp "Chat ID: " CHAT_ID

    echo "export KEYAPI=\"$BOT_TOKEN\"" >/etc/botapi.conf
    echo "export CHATID=\"$CHAT_ID\"" >>/etc/botapi.conf
    grep -q "botapi.conf" /etc/profile || echo "source /etc/botapi.conf" >> /etc/profile
    source /etc/botapi.conf

    MESSAGE="🚀 *api-kontol Installed Successfully* 🚀
🔑 *Auth Key:* \`$AUTH_KEY\`
🌐 *Server IP:* \`$SERVER_IP\`
🌍 *Domain:* \`$DOMAIN\`"

    curl -s -X POST "https://api.telegram.org/bot$KEYAPI/sendMessage" \
        -d "chat_id=$CHATID" \
        -d "text=$MESSAGE" \
        -d "parse_mode=Markdown"

    echo -e "\n${green}✅ Setup Complete! Auth Key sent to your Telegram.${neutral}"
    echo -e "${blue}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${neutral}\n"
}

# === Server App Config ===
server_app() {
    print_rainbow "⚙️ Configuring System Service..."

    cat >/etc/systemd/system/apisellvpn.service <<EOF
[Unit]
Description=App Bot sellvpn Service
After=network.target

[Service]
ExecStart=/bin/bash /usr/bin/apisellvpn
Restart=always
User=root
Environment=PATH=/usr/bin:/usr/local/bin
Environment=NODE_ENV=production
WorkingDirectory=/usr/bin

[Install]
WantedBy=multi-user.target
EOF

    cat >/usr/bin/apisellvpn <<EOF
#!/bin/bash
source /etc/profile
cd /usr/bin/api-kontol
node api.js
EOF

    chmod +x /usr/bin/apisellvpn

    # Cek dan hentikan port 5888 jika aktif
    CEK_PORT=$(lsof -i:5888 | awk 'NR>1 {print $2}' | sort -u)
    if [[ -n "$CEK_PORT" ]]; then
        echo -e "${orange}🔧 Closing port 5888...${neutral}"
        echo "$CEK_PORT" | xargs kill -9
    fi

    systemctl daemon-reload >/dev/null 2>&1
    systemctl enable apisellvpn.service >/dev/null 2>&1
    systemctl restart apisellvpn.service >/dev/null 2>&1

    echo -e "\n${blue}🔍 Server Status: $(cek_status apisellvpn.service)${neutral}"
    echo -e "${green}✨ All systems operational!${neutral}\n"
}

# === Main ===
setup_bot
server_app
