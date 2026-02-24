#!/bin/bash

# --- THEME COLORS (Catppuccin Macchiato) ---
C_BLUE='#89b4fa'
C_PEACH='#fab387'
C_YELLOW='#f9e2af'
C_GREEN='#a6e3a1'
C_RED='#f38ba8'
C_LAVENDER='#b4befe'
C_MAUVE='#cba6f7'
C_GRAY='#6c7086'
C_TEAL='#94e2d5'
C_ROSEWATER='#f5e0dc'

# --- CONNECTIVITY CHECK ---
if ! ping -c 1 -W 1 1.1.1.1 >/dev/null 2>&1; then
    echo "{\"text\": \"Disconnected ⚠\", \"tooltip\": \"<span color='$C_RED'>⚠ Disconnected</span>\", \"class\": \"disconnected\"}"
    exit 0
fi

# --- DATA GATHERING ---
# Get Active Interface & IPs
INTERFACE=$(ip route get 1.1.1.1 2>/dev/null | grep -Po 'dev \K\w+')
LOCAL_IP=$(ip addr show "$INTERFACE" | grep -Po 'inet \K[\d.]+' | head -n 1)
# Fetch Public IP with a shorter timeout for snappier UI
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
    ICON="󰈀"
    SSID="Wired Ethernet"
    SIGNAL="100"
    SECURITY="Hardware"
    WIFI_PASS="N/A"
else
    # Improved data gathering: Get the signal of the ACTIVE connection directly
    SIGNAL=$(nmcli -t -f IN-USE,SIGNAL dev wifi | grep '^\*' | cut -d: -f2)
    SSID=$(nmcli -t -f IN-USE,SSID dev wifi | grep '^\*' | cut -d: -f2)
    SEC_TYPE=$(nmcli -t -f IN-USE,SECURITY dev wifi | grep '^\*' | cut -d: -f2)

    # Fallback: if NMCLI IN-USE fails, try getting it via the interface directly
    if [ -z "$SIGNAL" ]; then
        SIGNAL=$(nmcli -g ALL-SETTINGS device show "$INTERFACE" | grep 'GENERAL.SIGNAL' | awk '{print $2}')
    fi

    # Final safeguard: If we have internet but signal is still empty, set to 100 to avoid icon bugs
    [ -z "$SIGNAL" ] && SIGNAL="100"
    [ -z "$SSID" ] && SSID="Connected"

    # Password Retrieval
    WIFI_PASS=$(nmcli -s -g 802-11-wireless-security.psk connection show "$SSID" 2>/dev/null || echo "🔒 Restricted")

    # Security Status
    if [[ "$SEC_TYPE" == "--" || -z "$SEC_TYPE" ]]; then
        SECURITY="Open (Unsecured)"
        SEC_COLOR=$C_RED
    else
        SECURITY="Secure ($SEC_TYPE)"
        SEC_COLOR=$C_GREEN
    fi

    # Proper WiFi Icons
    if [ "$SIGNAL" -gt 80 ]; then ICON=" ";   
    elif [ "$SIGNAL" -gt 60 ]; then ICON=" "; 
    elif [ "$SIGNAL" -gt 40 ]; then ICON=" "; 
    elif [ "$SIGNAL" -gt 20 ]; then ICON=" "; 
    else ICON=" "; fi
fi

# --- TRAFFIC STATS (Optimized) ---
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

# --- TOOLTIP DESIGN (Aligned & Elegant) ---
TOOLTIP="<b><span color='$C_BLUE'>󰀻  NETWORK INFRASTRUCTURE</span></b>\n"
TOOLTIP+="<span color='$C_GRAY'>━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━</span>\n"
TOOLTIP+="<span color='$C_PEACH'>󱚽  Access Point :</span>  $SSID\n"
TOOLTIP+="<span color='$C_YELLOW'>󰔶  Signal Power :</span>  $SIGNAL%\n"
TOOLTIP+="<span color='$SEC_COLOR'>󰒘  Security     :</span>  $SECURITY\n"
TOOLTIP+="<span color='$C_ROSEWATER'>󰷖  Credentials  :</span>  $WIFI_PASS\n"
TOOLTIP+="<span color='$C_GRAY'>────────────────────────────────</span>\n"
TOOLTIP+="<span color='$C_LAVENDER'>󰖂  WireGuard    :</span>  ${WG_IFACE:-Inactive}\n"
TOOLTIP+="<span color='$C_MAUVE'>󰖟  VPN Tunnel   :</span>  ${TUN_IFACE:-Inactive}\n"
TOOLTIP+="<span color='$C_TEAL'>󰃖  DNS Resolver :</span>  $DNS_STATUS\n"
TOOLTIP+="   <span color='$C_GRAY'><i>$DNS_SERVERS</i></span>\n"
TOOLTIP+="<span color='$C_GRAY'>────────────────────────────────</span>\n"
TOOLTIP+="<span color='$C_BLUE'>󰩟  Internal IP  :</span>  $LOCAL_IP\n"
TOOLTIP+="<span color='$C_RED'>󱇶  External IP  :</span>  $PUBLIC_IP\n"
TOOLTIP+="<span color='$C_GRAY'>────────────────────────────────</span>\n"
TOOLTIP+="<span color='$C_GREEN'>󰶮  Receive:</span> $DOWNSPEED  <span color='$C_RED'>󰶻  Transmit:</span> $UPSPEED"

# --- OUTPUT ---
# Added a "Glow Dot" next to the icon if VPN/WG is active
VPN_DOT=""
if [[ "$VPN_ACTIVE" == "Active" ]]; then
    VPN_DOT=" <span color='$C_GREEN' font='9'>󰐊</span>"
fi

echo "{\"text\": \"$ICON$VPN_DOT\", \"tooltip\": \"$TOOLTIP\"}"