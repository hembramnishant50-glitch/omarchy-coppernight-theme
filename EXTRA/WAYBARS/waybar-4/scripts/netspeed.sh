#!/bin/bash
INTERVAL=1
IFACE=$(ip -o link show | awk -F': ' '{print $2}' | grep -v lo | grep -v docker | head -1)
STATE_FILE="/tmp/netspeed-today-$IFACE"

today=$(date +%Y%m%d)
rx_now=$(cat /sys/class/net/$IFACE/statistics/rx_bytes 2>/dev/null || echo 0)
tx_now=$(cat /sys/class/net/$IFACE/statistics/tx_bytes 2>/dev/null || echo 0)

if [[ -f "$STATE_FILE" ]]; then
  read -r saved_date saved_rx saved_tx < "$STATE_FILE"
  if [[ $saved_date != "$today" ]]; then
    saved_rx=$rx_now
    saved_tx=$tx_now
    echo "$today $saved_rx $saved_tx" > "$STATE_FILE"
  fi
else
  saved_rx=$rx_now
  saved_tx=$tx_now
  echo "$today $saved_rx $saved_tx" > "$STATE_FILE"
fi

today_rx=$(( rx_now - saved_rx ))
today_tx=$(( tx_now - saved_tx ))
(( today_rx < 0 )) && today_rx=0
(( today_tx < 0 )) && today_tx=0

rx1=$(cat /sys/class/net/$IFACE/statistics/rx_bytes 2>/dev/null)
tx1=$(cat /sys/class/net/$IFACE/statistics/tx_bytes 2>/dev/null)
sleep $INTERVAL
rx2=$(cat /sys/class/net/$IFACE/statistics/rx_bytes 2>/dev/null)
tx2=$(cat /sys/class/net/$IFACE/statistics/tx_bytes 2>/dev/null)

[ -z "$rx1" ] || [ -z "$rx2" ] && echo "󰇚 ↓? ↑?" && exit 0

rx_diff=$(( rx2 - rx1 ))
tx_diff=$(( tx2 - tx1 ))

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

down=$(format_speed $rx_diff)
up=$(format_speed $tx_diff)

rx_total=$(format_speed $rx2)
tx_total=$(format_speed $tx2)
today_dl=$(format_speed $today_rx)
today_ul=$(format_speed $today_tx)

tooltip="<span color='#89b4fa'> $down</span>/s  <span color='#cba6f7'> $up</span>/s on ${IFACE}
<span color='#585b70'>━━━ Usage ━━━</span>
<span color='#cdd6f4'>Today:  $today_dl   $today_ul</span>
<span color='#585b70'>Total:  $rx_total   $tx_total</span>"

jq -nc --arg text " ${down}   ${up}" --arg tooltip "${tooltip}" '{text: $text, tooltip: $tooltip}'
