#!/bin/bash

# --- THEME COLORS ---
C_BORDER='#cba6f7'
C_WIFI='#a6e3a1'
C_IP='#89b4fa'
C_TRAFFIC='#f9e2af'
C_SEC='#f5e0dc'
C_TEXT='#cdd6f4'
C_SUB='#45475a'
C_SEP='#6c7086'
C_VAL='#f5c2e7'

# --- DATA GATHERING ---
INTERFACE=$(ip route | grep default | awk '{print $5}' | head -n 1)

if [[ -z "$INTERFACE" ]]; then
    echo "{\"text\": \"󰖪  Offline\", \"tooltip\": \"<span color='#f38ba8'><b>SYSTEM OFFLINE</b></span>\"}"
    exit 0
fi

# FIX: Use `iw` instead of `nmcli` — works without NetworkManager
IW_LINK=$(iw dev "$INTERFACE" link 2>/dev/null)

if echo "$IW_LINK" | grep -q "Not connected"; then
    SSID="ETHERNET"
    SIGNAL="100"
else
    SSID=$(echo "$IW_LINK" | grep -i "SSID" | awk '{print $2}')
    SIGNAL_DBM=$(echo "$IW_LINK" | grep -i "signal" | awk '{print $2}')
    # Convert dBm to percentage: (dBm + 110) clamped to 0-100
    SIGNAL=$(awk "BEGIN {v=int($SIGNAL_DBM + 110); if(v>100)v=100; if(v<0)v=0; print v}" 2>/dev/null)
    [[ -z "$SSID" ]]   && SSID="ETHERNET"
    [[ -z "$SIGNAL" ]] && SIGNAL="0"
fi

# Networking & DNS
LOCAL_IP=$(ip addr show "$INTERFACE" | grep -Po 'inet \K[\d.]+' | head -n 1)
PUBLIC_IP=$(curl -s --connect-timeout 1.5 https://ifconfig.me || echo "Unavailable")
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
        echo "$(awk "BEGIN {printf \"%.1f\", $bytes/1048576}")MB/s"
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

TT+="<b><span color='$C_SEC'>║ TUNNEL &amp; SECURITY                       ║</span></b>\n"
TT+="<b><span color='$C_BORDER'>║</span></b> <span color='$C_TEXT'>WIREGUARD</span> <span color='$C_SUB'>............</span> <span color='$C_VAL'>$WG_STATUS</span>\n"
TT+="<b><span color='$C_BORDER'>║</span></b> <span color='$C_TEXT'>VPN TUNNEL</span> <span color='$C_SUB'>...........</span> <span color='$C_VAL'>$VPN_STATUS</span>\n"
TT+="<b><span color='$C_BORDER'>║</span></b> <span color='$C_TEXT'>DNS SRV</span>   <span color='$C_SUB'>............</span> <span color='$C_VAL'>${DNS_SERVERS:0:12}</span>\n"

TT+="<b><span color='$C_BORDER'>╠═════════════════════════════════════════╣</span></b>\n"

TT+="<b><span color='$C_TRAFFIC'>║ ACTIVE TRAFFIC                          ║</span></b>\n"
TT+="<b><span color='$C_BORDER'>║</span></b> <span color='$C_TEXT'>RECEIVING</span> <span color='$C_SUB'>............</span> <span color='$C_VAL'>$RX</span>\n"
TT+="<b><span color='$C_BORDER'>║</span></b> <span color='$C_TEXT'>SENDING</span>   <span color='$C_SUB'>............</span> <span color='$C_VAL'>$TX</span>\n"

TT+="<b><span color='$C_BORDER'>╠═════════════════════════════════════════╣</span></b>\n"

TT+="<b><span color='$C_IP'>║ IPV4   </span></b> <span color='$C_TEXT'>Loc: $LOCAL_IP</span>\n"
TT+="<b><span color='$C_IP'>║</span></b> <span color='$C_TEXT'>Pub: $PUBLIC_IP</span>\n"

TT+="<b><span color='$C_BORDER'>╚═════════════════════════════════════════╝</span></b>\n"

TT+="<span color='$C_SEC'><b>STATUS:</b> PROTECTED &amp; ACTIVE</span>"

# --- BAR OUTPUT ---
ICON="󰤨"
[[ "$WG_STATUS"  == "ACTIVE" ]] && ICON="󰖂"
[[ "$VPN_STATUS" == "ACTIVE" ]] && ICON="󰖟"

echo "{\"text\": \"<span color='$C_IP'>$ICON</span> <span color='$C_TEXT'>$SIGNAL%</span>\", \"tooltip\": \"$TT\"}"