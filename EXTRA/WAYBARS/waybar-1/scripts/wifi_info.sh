#!/bin/bash

# --- THEME COLORS (Matched to Screenshots) ---
C_TITLE='#f38ba8'    # Pinkish-red for headers (matches "METEOROLOGICAL DATA")
C_TEXT='#dcd6d6'     # Off-white for values
C_DIM='#585b70'      # Dark gray for separators
C_BLUE='#89b4fa'     # CPU/Location blue
C_GREEN='#a6e3a1'    # Root/Condition green
C_PEACH='#fab387'    # RAM/Temp orange-peach
C_YELLOW='#f9e2af'   # UV Index yellow
C_PURPLE='#cba6f7'   # Air Qlty purple
C_TEAL='#94e2d5'     # Humidity teal
C_RED='#f38ba8'      # Error red

# --- CONNECTIVITY CHECK ---
if ! ping -c 1 -W 1 1.1.1.1 >/dev/null 2>&1; then
    echo "{\"text\": \"󰖪 \", \"tooltip\": \"<span color='$C_RED'>󰖪  Disconnected</span>\", \"class\": \"disconnected\"}"
    exit 0
fi

# --- DATA GATHERING ---
# Get Active Interface & IPs
INTERFACE=$(ip route get 1.1.1.1 2>/dev/null | grep -Po 'dev \K\w+')
LOCAL_IP=$(ip addr show "$INTERFACE" | grep -Po 'inet \K[\d.]+' | head -n 1)
PUBLIC_IP=$(curl -s --connect-timeout 1.5 https://ifconfig.me || echo "Hidden/Private")

# DNS & VPN Detection
DNS_SERVERS=$(grep "nameserver" /etc/resolv.conf | awk '{print $2}' | xargs | sed 's/ /, /g')
DNS_STATUS=$([[ -n "$DNS_SERVERS" ]] && echo "Active" || echo "Inactive")

# Check for WireGuard or standard VPN
WG_IFACE=$(ip link show | grep -oE "wg[0-9]+")
TUN_IFACE=$(ip link show | grep -oE "tun[0-9]+")
VPN_ACTIVE=$([[ -z "$WG_IFACE" && -z "$TUN_IFACE" ]] && echo "Inactive" || echo "Active")

# --- WIFI & SIGNAL ENHANCEMENT ---
if [[ "$INTERFACE" == e* ]]; then
    ICON="󰈀 "
    SSID="Wired Ethernet"
    SIGNAL="100"
    SECURITY="Hardware"
    WIFI_PASS="N/A"
else
    # Improved data gathering
    SIGNAL=$(nmcli -t -f IN-USE,SIGNAL dev wifi | grep '^\*' | cut -d: -f2)
    SSID=$(nmcli -t -f IN-USE,SSID dev wifi | grep '^\*' | cut -d: -f2)
    SEC_TYPE=$(nmcli -t -f IN-USE,SECURITY dev wifi | grep '^\*' | cut -d: -f2)

    # Fallback
    if [ -z "$SIGNAL" ]; then
        SIGNAL=$(nmcli -g GENERAL device show "$INTERFACE" | grep 'GENERAL.SIGNAL' | awk '{print $2}')
    fi

    # Final safeguard
    [ -z "$SIGNAL" ] && SIGNAL="100"
    [ -z "$SSID" ] && SSID="Connected"

    # Password Retrieval
    WIFI_PASS=$(nmcli -s -g 802-11-wireless-security.psk connection show "$SSID" 2>/dev/null || echo "🔒 Restricted")

    # Security Status
    if [[ "$SEC_TYPE" == "--" || -z "$SEC_TYPE" ]]; then
        SECURITY="Open (Unsecured)"
    else
        SECURITY="Secure ($SEC_TYPE)"
    fi

    # Alternative WiFi Icons
    if [ "$SIGNAL" -gt 80 ]; then ICON=" ";   
    elif [ "$SIGNAL" -gt 60 ]; then ICON=" "; 
    elif [ "$SIGNAL" -gt 40 ]; then ICON=" "; 
    elif [ "$SIGNAL" -gt 20 ]; then ICON=" "; 
    else ICON="⚠ "; fi
fi

# --- TRAFFIC STATS ---
read -r d1 u1 < <(awk -v dev="$INTERFACE" '$1 ~ dev {print $2, $10}' /proc/net/dev)
sleep 1
read -r d2 u2 < <(awk -v dev="$INTERFACE" '$1 ~ dev {print $2, $10}' /proc/net/dev)

calc_speed() {
    local bytes=$1
    if [ "$bytes" -gt 1048576 ]; then
        echo "$(bc <<< "scale=1; $bytes/1048576") MB/s"
    else
        echo "$((bytes/1024)) KB/s"
    fi
}
DOWNSPEED=$(calc_speed $((d2 - d1)))
UPSPEED=$(calc_speed $((u2 - u1)))

# --- TOOLTIP DESIGN (Matched to Screenshots) ---
TOOLTIP="<b><span color='$C_TITLE'>󰀻  NETWORK INFRASTRUCTURE</span></b>\n"
TOOLTIP+="<span color='$C_DIM'>━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━</span>\n"
TOOLTIP+="<span color='$C_BLUE'>󱚽  Access Point :</span>  <span color='$C_TEXT'>$SSID</span>\n"
TOOLTIP+="<span color='$C_GREEN'>󰔶  Signal Power :</span>  <span color='$C_TEXT'>$SIGNAL%</span>\n"
TOOLTIP+="<span color='$C_YELLOW'>󰒘  Security     :</span>  <span color='$C_TEXT'>$SECURITY</span>\n"
TOOLTIP+="<span color='$C_PEACH'>󰷖  Credentials  :</span>  <span color='$C_TEXT'>$WIFI_PASS</span>\n"
TOOLTIP+="<span color='$C_DIM'>────────────────────────────────</span>\n"
TOOLTIP+="<span color='$C_TEAL'>󰖂  WireGuard    :</span>  <span color='$C_TEXT'>${WG_IFACE:-Inactive}</span>\n"
TOOLTIP+="<span color='$C_PURPLE'>󰖟  VPN Tunnel   :</span>  <span color='$C_TEXT'>${TUN_IFACE:-Inactive}</span>\n"
TOOLTIP+="<span color='$C_BLUE'>󰃖  DNS Resolver :</span>  <span color='$C_TEXT'>$DNS_STATUS</span>\n"
TOOLTIP+="   <span color='$C_DIM'><i>$DNS_SERVERS</i></span>\n"
TOOLTIP+="<span color='$C_DIM'>────────────────────────────────</span>\n"
TOOLTIP+="<span color='$C_GREEN'>󰩟  Internal IP  :</span>  <span color='$C_TEXT'>$LOCAL_IP</span>\n"
TOOLTIP+="<span color='$C_PEACH'>󱇶  External IP  :</span>  <span color='$C_TEXT'>$PUBLIC_IP</span>\n"
TOOLTIP+="<span color='$C_DIM'>────────────────────────────────</span>\n"
TOOLTIP+="<span color='$C_GREEN'>󰶮  Receive:</span> <span color='$C_TEXT'>$DOWNSPEED</span>  <span color='$C_PEACH'>󰶻  Transmit:</span> <span color='$C_TEXT'>$UPSPEED</span>"

# --- OUTPUT ---
VPN_DOT=""
if [[ "$VPN_ACTIVE" == "Active" ]]; then
    VPN_DOT=" <span color='$C_GREEN' font='9'>󰐊</span>"
fi

echo "{\"text\": \"$ICON$VPN_DOT\", \"tooltip\": \"$TOOLTIP\"}"