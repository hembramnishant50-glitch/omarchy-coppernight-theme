#!/bin/bash

# --- THEME COLORS (Synced with your Waybar CSS) ---
C_BORDER='#cba6f7'   # Waybar @border
C_WIFI='#f9e2af'     # Waybar @selected-text
C_IP='#cba6f7'       
C_TRAFFIC='#f9e2af'  # Waybar @text
C_TEXT='#cdd6f4'     
C_SUB='#dcd6d6'      # Waybar @accent
C_SEP='#a6e3a1'      
C_VAL='#f5c2e7'      

# --- DATA GATHERING ---
INTERFACE=$(ip route | grep default | awk '{print $5}' | head -n 1)

if [[ -z "$INTERFACE" ]]; then
    echo "{\"text\": \"󰖪 \", \"tooltip\": \"<span color='#f38ba8'><b>SYSTEM OFFLINE</b></span>\"}"
    exit 0
fi

# WiFi & Signal
WIFI_RAW=$(nmcli -t -f IN-USE,SSID,SIGNAL device wifi list | grep '^\*' | head -1)
SSID=$(echo "$WIFI_RAW" | cut -d':' -f2)
SIGNAL=$(echo "$WIFI_RAW" | cut -d':' -f3)
[[ -z "$SSID" ]] && SSID="ETHERNET" && SIGNAL="100"

# Networking & DNS
LOCAL_IP=$(ip addr show "$INTERFACE" | grep -Po 'inet \K[\d.]+' | head -n 1)
PUBLIC_IP=$(curl -s --connect-timeout 2 https://ifconfig.me || echo "N/A")
DNS_SERVERS=$(grep "nameserver" /etc/resolv.conf | awk '{print $2}' | xargs | sed 's/ /, /g')

# VPN & WireGuard Detection
WG_STATUS=$(ip link show | grep -q "wg" && echo "ACTIVE" || echo "INACTIVE")
VPN_STATUS=$(ip link show | grep -qE "tun|tap" && echo "ACTIVE" || echo "INACTIVE")

# Traffic
read -r d1 u1 < <(awk -v dev="$INTERFACE" '$1 ~ dev {print $2, $10}' /proc/net/dev)
sleep 1
read -r d2 u2 < <(awk -v dev="$INTERFACE" '$1 ~ dev {print $2, $10}' /proc/net/dev)
calc_speed() {
    local bytes=$(( $1 ))
    if [ "$bytes" -gt 1048576 ]; then
        echo "$(bc <<< "scale=1; $bytes/1048576")MB/s"
    else
        echo "$((bytes/1024))KB/s"
    fi
}
RX=$(calc_speed $((d2 - d1)))
TX=$(calc_speed $((u2 - u1)))

# --- VISUAL BAR ---
get_progress_bar() {
    local percent=$1
    local filled=$(( percent / 10 ))
    local bar=""
    for ((i=0; i<filled; i++)); do bar+="■"; done
    for ((i=filled; i<10; i++)); do bar+="□"; done
    echo "$bar"
}
BAR=$(get_progress_bar "$SIGNAL")

# --- TOOLTIP DESIGN ---
TT="<b><span color='$C_BORDER'>╔══════════ NETWORK DIAGNOSTICS ══════════╗</span></b>\n"
TT+="<b><span color='$C_WIFI'>║ WIFI   </span></b> <span color='$C_SUB'>[$BAR]</span> <span color='$C_TEXT'>$SIGNAL%</span>\n"
TT+="<b><span color='$C_WIFI'>║</span></b> <span color='$C_TEXT'>SSID: ${SSID:0:15}</span> <span color='$C_SEP'>│</span> <span color='$C_TEXT'>Iface: $INTERFACE</span>\n"
TT+="<b><span color='$C_BORDER'>╠═════════════════════════════════════════╣</span></b>\n"
TT+="<b><span color='$C_WIFI'>║ TUNNEL &amp; SECURITY                       ║</span></b>\n"
TT+="<b><span color='$C_BORDER'>║</span></b> <span color='#dcd6d6'>WIREGUARD</span> <span color='$C_SUB'>............</span> <span color='$C_VAL'>$WG_STATUS</span>\n"
TT+="<b><span color='$C_BORDER'>║</span></b> <span color='#dcd6d6'>VPN TUNNEL</span> <span color='$C_SUB'>...........</span> <span color='$C_VAL'>$VPN_STATUS</span>\n"
TT+="<b><span color='$C_BORDER'>╠═════════════════════════════════════════╣</span></b>\n"
TT+="<b><span color='$C_TRAFFIC'>║ ACTIVE TRAFFIC                          ║</span></b>\n"
TT+="<b><span color='$C_BORDER'>║</span></b> <span color='#dcd6d6'>RECEIVING</span> <span color='$C_SUB'>............</span> <span color='$C_VAL'>$RX</span>\n"
TT+="<b><span color='$C_BORDER'>║</span></b> <span color='#dcd6d6'>SENDING</span>   <span color='$C_SUB'>............</span> <span color='$C_VAL'>$TX</span>\n"
TT+="<b><span color='$C_BORDER'>╠═════════════════════════════════════════╣</span></b>\n"
TT+="<b><span color='$C_IP'>║ IPV4   </span></b> <span color='$C_TEXT'>Loc: $LOCAL_IP</span>\n"
TT+="<b><span color='$C_IP'>║</span></b> <span color='$C_TEXT'>Pub: $PUBLIC_IP</span>\n"
TT+="<b><span color='$C_BORDER'>╚═════════════════════════════════════════╝</span></b>"

ICON=""
[[ "$WG_STATUS" == "ACTIVE" ]] && ICON="󰖂"
[[ "$VPN_STATUS" == "ACTIVE" ]] && ICON="󰖟"

echo "{\"text\": \"<span color='$C_IP'>$ICON</span> <span color='$C_TEXT'>$SIGNAL%</span>\", \"tooltip\": \"$TT\"}"
