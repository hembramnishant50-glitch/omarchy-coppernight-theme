#!/bin/bash

IFACE=$(ip -o link show | awk -F': ' '{print $2}' | grep -v lo | grep -v docker | head -1)

# Connection state
state=$(cat /sys/class/net/$IFACE/operstate 2>/dev/null)
wifi_info=$(iw dev "$IFACE" link 2>/dev/null)
ssid=$(echo "$wifi_info" | awk '/SSID/ {print $2}')
signal=$(echo "$wifi_info" | awk '/signal/ {print $2}' | sed 's/-//')
freq=$(echo "$wifi_info" | awk '/freq/ {print $2}')
speed=$(cat /sys/class/net/$IFACE/speed 2>/dev/null)
[[ -z "$speed" || "$speed" == "-1" ]] && speed="N/A"
mode=$(cat /sys/class/net/$IFACE/type 2>/dev/null)

# Local IPs
ip4=$(ip -4 addr show "$IFACE" 2>/dev/null | awk '/inet / {print $2}' | head -1)
ip6=$(ip -6 addr show "$IFACE" 2>/dev/null | awk '/inet6 .*global/ {print $2}' | head -1)
mac=$(cat /sys/class/net/$IFACE/address 2>/dev/null)
gateway=$(ip route | awk '/default/ {print $3}' | head -1)
dns=$(awk '/^nameserver/ {printf "%s ", $2}' /etc/resolv.conf 2>/dev/null | xargs || echo "?")

# VPN detection
vpn="no"
vpn_name=""
wg_peers=0
wg_endpoint=""
wg_handshake=""
wg_transfer=""

# Check tun/tap
ip link show tun0 &>/dev/null && { vpn="yes"; vpn_name="tun0"; }
ip link show tap0 &>/dev/null && { vpn="yes"; vpn_name="tap0"; }

# Check WireGuard (any wg* interface)
wg_iface=""
for iface in /sys/class/net/wg* /sys/class/net/mullvad* /sys/class/net/proton*; do
  [[ -d "$iface" ]] && { wg_iface=$(basename "$iface"); vpn="yes"; vpn_name="$wg_iface"; break; }
done

# Detailed WireGuard info
if command -v wg &>/dev/null && [[ -n "$wg_iface" ]]; then
  wg_data=$(wg show "$wg_iface" 2>/dev/null)
  wg_name=$(echo "$wg_data" | head -1 | awk '{print $2}')
  [[ -n "$wg_name" ]] && vpn_name="$wg_name"
  wg_peers=$(echo "$wg_data" | grep -c "peer:" 2>/dev/null)
  wg_endpoint=$(echo "$wg_data" | awk '/endpoint:/ {print $2; exit}')
  wg_handshake=$(echo "$wg_data" | awk '/latest handshake:/ {print $3, $4, $5; exit}')
  wg_transfer=$(echo "$wg_data" | awk '/transfer:/ {print $2, $3, $4, $5; exit}')
fi

# Public IP info (cached)
pub_cache="/tmp/network-public.json"
if [[ -f "$pub_cache" ]] && (( $(date +%s) - $(stat -c %Y "$pub_cache") < 300 )); then
  pub_info=$(cat "$pub_cache")
else
  pub_info=$(curl -s "http://ip-api.com/json/" 2>/dev/null)
  [[ -n "$pub_info" ]] && echo "$pub_info" > "$pub_cache"
fi
pub_ip=$(echo "$pub_info" | jq -r '.query // "?"')
pub_city=$(echo "$pub_info" | jq -r '.city // "?"')
pub_region=$(echo "$pub_info" | jq -r '.regionName // "?"')
pub_country=$(echo "$pub_info" | jq -r '.country // "?"')
pub_isp=$(echo "$pub_info" | jq -r '.isp // "?"')
pub_org=$(echo "$pub_info" | jq -r '.org // "?"')

# Current transfer speed
rx1=$(cat /sys/class/net/$IFACE/statistics/rx_bytes 2>/dev/null || echo 0)
tx1=$(cat /sys/class/net/$IFACE/statistics/tx_bytes 2>/dev/null || echo 0)
sleep 1
rx2=$(cat /sys/class/net/$IFACE/statistics/rx_bytes 2>/dev/null || echo 0)
tx2=$(cat /sys/class/net/$IFACE/statistics/tx_bytes 2>/dev/null || echo 0)
rx_rate=$(( rx2 - rx1 ))
tx_rate=$(( tx2 - tx1 ))

format_speed() {
  local bytes=$1
  if (( bytes >= 1073741824 )); then
    echo "$(echo "scale=1; $bytes / 1073741824" | bc)G"
  elif (( bytes >= 1048576 )); then
    echo "$(echo "scale=1; $bytes / 1048576" | bc)M"
  elif (( bytes >= 1024 )); then
    echo "$(echo "scale=0; $bytes / 1024" | bc)K"
  else
    echo "${bytes}B"
  fi
}
cur_down=$(format_speed $rx_rate)
cur_up=$(format_speed $tx_rate)

DIV="<span color='#585b70'>━━━━━━━━━━━━━━━━━━━━━</span>"

tooltip="<span color='#89b4fa'></span> <span color='#cdd6f4'>${IFACE}</span>  <span color='#a6e3a1'>${state^^}</span>"
[[ -n "$ssid" ]] && tooltip+="  <span color='#cba6f7'> $ssid</span>"
tooltip+="
$DIV
<span color='#94e2d5'> Local Network</span>
<span color='#585b70'>IPv4:</span> <span color='#cdd6f4'>${ip4:-none}</span>
<span color='#585b70'>IPv6:</span> <span color='#cdd6f4'>${ip6:-none}</span>
<span color='#585b70'>MAC:</span> <span color='#cdd6f4'>${mac:-?}</span>
<span color='#585b70'>Gateway:</span> <span color='#cdd6f4'>${gateway:-?}</span>
<span color='#585b70'>DNS:</span> <span color='#cdd6f4'>${dns:-?}</span>"

if [[ -n "$ssid" ]]; then
  tooltip+="
$DIV
<span color='#fab387'>󰖩 Wireless</span>
<span color='#585b70'>Signal:</span> <span color='#a6e3a1'>${signal} dBm</span>
<span color='#585b70'>Frequency:</span> <span color='#cba6f7'>${freq} MHz</span>
<span color='#585b70'>Link Speed:</span> <span color='#f9e2af'>${speed} Mbps</span>"
fi
tooltip+="
$DIV
<span color='#89b4fa'> Transfer Rate</span>
<span color='#585b70'> DL:</span> <span color='#89b4fa'>${cur_down}/s</span>
<span color='#585b70'> UL:</span> <span color='#cba6f7'>${cur_up}/s</span>"

tooltip+="
$DIV
<span color='#f9e2af'> Internet</span>
<span color='#585b70'>Public IP:</span> <span color='#cdd6f4'>${pub_ip}</span>
<span color='#585b70'>Location:</span> <span color='#cdd6f4'>${pub_city}, ${pub_region}, ${pub_country}</span>
<span color='#585b70'>ISP:</span> <span color='#cdd6f4'>${pub_isp:-?}</span>"

if [[ "$vpn" == "yes" ]]; then
  tooltip+="
$DIV
<span color='#a6e3a1'> VPN</span>
<span color='#585b70'>Status:</span> <span color='#a6e3a1'>Connected</span>
<span color='#585b70'>Interface:</span> <span color='#cdd6f4'>${vpn_name}</span>"
  if [[ -n "$wg_peers" && "$wg_peers" -gt 0 ]]; then
    tooltip+="
<span color='#585b70'>Peers:</span> <span color='#cdd6f4'>${wg_peers}</span>"
    [[ -n "$wg_endpoint" ]] && tooltip+="
<span color='#585b70'>Endpoint:</span> <span color='#cdd6f4'>${wg_endpoint}</span>"
    [[ -n "$wg_handshake" ]] && tooltip+="
<span color='#585b70'>Handshake:</span> <span color='#cdd6f4'>${wg_handshake}</span>"
    [[ -n "$wg_transfer" ]] && tooltip+="
<span color='#585b70'>Transfer:</span> <span color='#cdd6f4'>${wg_transfer}</span>"
  fi
else
  tooltip+="
$DIV
<span color='#585b70'> VPN</span>
<span color='#585b70'>Status:</span> <span color='#585b70'>Not Connected</span>"
fi

# Bar icon
if [[ "$state" == "up" ]]; then
  [[ -n "$ssid" ]] && text="" || text="󰈀"
else
  text="󰤮"
fi

jq -nc --arg text "$text" --arg tooltip "${tooltip}" '{text: $text, tooltip: $tooltip}'
