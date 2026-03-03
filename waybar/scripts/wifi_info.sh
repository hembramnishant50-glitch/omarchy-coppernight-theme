#!/bin/bash

# --- THEME COLORS (Synced with system_info.py) ---
C_BORDER='#cba6f7'   # Mauve
C_WIFI='#a6e3a1'     # Green
C_IP='#89b4fa'       # Blue
C_TRAFFIC='#f9e2af'  # Yellow
C_SEC='#f5e0dc'      # Rosewater (VPN/DNS)
C_TEXT='#cdd6f4'     # Main Text
C_SUB='#45475a'      # Dimmed / Bars
C_SEP='#6c7086'      # Separators
C_VAL='#f5c2e7'      # Pink values

# --- DATA GATHERING ---
INTERFACE=$(ip route | grep default | awk '{print $5}' | head -n 1)

if [[ -z "$INTERFACE" ]]; then
    echo "{\"text\": \"󰖪  Offline\", \"tooltip\": \"<span color='#f38ba8'><b>SYSTEM OFFLINE</b></span>\"}"
    exit 0
fi

# WiFi & Signal
WIFI_RAW=$(nmcli -t -f IN-USE,SSID,SIGNAL device wifi list | grep '^\*' | head -1)
SSID=$(echo "$WIFI_RAW" | cut -d':' -f2)
SIGNAL=$(echo "$WIFI_RAW" | cut -d':' -f3)
[[ -z "$SSID" ]] && SSID="ETHERNET" && SIGNAL="100"

# Networking & DNS
LOCAL_IP=$(ip addr show "$INTERFACE" | grep -Po 'inet \K[\d.]+' | head -n 1)
PUBLIC_IP=$(curl -s --connect-timeout 1.5 https://ifconfig.me || echo "Terminated")
DNS_SERVERS=$(grep "nameserver" /etc/resolv.conf | awk '{print $2}' | xargs | sed 's/ /, /g')

# VPN & WireGuard Detection
WG_STATUS=$(ip link show | grep -q "wg" && echo "ACTIVE" || echo "INACTIVE")
VPN_STATUS=$(ip link show | grep -qE "tun|tap" && echo "ACTIVE" || echo "INACTIVE")

# Traffic (1s sample)
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

# Row 1: Connection Strength
TT+="<b><span color='$C_WIFI'>║ WIFI   </span></b> <span color='$C_SUB'>[$BAR]</span> <span color='$C_TEXT'>$SIGNAL%</span>\n"
TT+="<b><span color='$C_WIFI'>║</span></b> <span color='$C_TEXT'>SSID: ${SSID:0:15}</span> <span color='$C_SEP'>│</span> <span color='$C_TEXT'>Iface: $INTERFACE</span>\n"

TT+="<b><span color='$C_BORDER'>╠═════════════════════════════════════════╣</span></b>\n"

# Row 2: Security & DNS (Matches "Active Tasks" layout)
TT+="<b><span color='$C_SEC'>║ TUNNEL &amp; SECURITY                       ║</span></b>\n"
TT+="<b><span color='$C_BORDER'>║</span></b> <span color='$C_TEXT'>WIREGUARD</span> <span color='$C_SUB'>............</span> <span color='$C_VAL'>$WG_STATUS</span>\n"
TT+="<b><span color='$C_BORDER'>║</span></b> <span color='$C_TEXT'>VPN TUNNEL</span> <span color='$C_SUB'>...........</span> <span color='$C_VAL'>$VPN_STATUS</span>\n"
TT+="<b><span color='$C_BORDER'>║</span></b> <span color='$C_TEXT'>DNS SRV</span>   <span color='$C_SUB'>............</span> <span color='$C_VAL'>${DNS_SERVERS:0:12}</span>\n"

TT+="<b><span color='$C_BORDER'>╠═════════════════════════════════════════╣</span></b>\n"

# Row 3: Traffic
TT+="<b><span color='$C_TRAFFIC'>║ ACTIVE TRAFFIC                          ║</span></b>\n"
TT+="<b><span color='$C_BORDER'>║</span></b> <span color='$C_TEXT'>RECEIVING</span> <span color='$C_SUB'>............</span> <span color='$C_VAL'>$RX</span>\n"
TT+="<b><span color='$C_BORDER'>║</span></b> <span color='$C_TEXT'>SENDING</span>   <span color='$C_SUB'>............</span> <span color='$C_VAL'>$TX</span>\n"

TT+="<b><span color='$C_BORDER'>╠═════════════════════════════════════════╣</span></b>\n"

# Row 4: IP Info
TT+="<b><span color='$C_IP'>║ IPV4   </span></b> <span color='$C_TEXT'>Loc: $LOCAL_IP</span>\n"
TT+="<b><span color='$C_IP'>║</span></b> <span color='$C_TEXT'>Pub: $PUBLIC_IP</span>\n"

TT+="<b><span color='$C_BORDER'>╚═════════════════════════════════════════╝</span></b>\n"

# Footer
TT+="<span color='$C_SEC'><b>STATUS:</b> PROTECTED &amp; ACTIVE</span>"

# --- BAR OUTPUT ---
# Dynamic icon: Shows WireGuard icon if active
ICON=""
[[ "$WG_STATUS" == "ACTIVE" ]] && ICON="󰖂"
[[ "$VPN_STATUS" == "ACTIVE" ]] && ICON="󰖟"

echo "{\"text\": \"<span color='$C_IP'>$ICON</span> <span color='$C_TEXT'>$SIGNAL%</span>\", \"tooltip\": \"$TT\"}"