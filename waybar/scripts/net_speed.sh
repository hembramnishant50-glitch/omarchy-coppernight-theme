#!/bin/bash

# ==============================================================================
# CONFIGURATION & THEME (Matching weather.py)
# ==============================================================================
INTERFACE=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $5; exit}')
STATH="/proc/net/dev"
C_BORDER="#cba6f7"
C_LABEL="#89b4fa"
C_VAL="#dcd6d6"
C_DOWN="#a6e3a1"
C_UP="#fab387"
C_PING="#f9e2af"

# Get initial stats
read -r UP1 DOWN1 < <(grep "$INTERFACE" "$STATH" | awk '{print $10, $2}')
sleep 1
read -r UP2 DOWN2 < <(grep "$INTERFACE" "$STATH" | awk '{print $10, $2}')

# Calculations
DOWNS=$(( (DOWN2 - DOWN1) / 1024 ))
UPS=$(( (UP2 - UP1) / 1024 ))

# Get Ping (Matching your weather logic)
PING=$(ping -c 1 -W 1 1.1.1.1 | grep 'time=' | awk -F'time=' '{print $2}' | cut -d' ' -f1 | cut -d. -f1)
[ -z "$PING" ] && PING="--"

# Format function
fmt() {
    if [ "$1" -ge 1024 ]; then
        printf "%.1fM" "$(echo "scale=1; $1 / 1024" | bc)"
    else
        printf "%dK" "$1"
    fi
}

D_STR=$(fmt $DOWNS)
U_STR=$(fmt $UPS)

# Equalizer logic (Color matched to your weather icons)
if [ "$DOWNS" -eq 0 ]; then 
    BAR="<span color='#45475a'>󰇚 </span>"
elif [ "$DOWNS" -lt 500 ]; then 
    BAR="<span color='$C_DOWN'>󰇚 ▂</span>"
else 
    BAR="<span color='#f38ba8'>󰇚 ▇</span>"
fi

# ==============================================================================
# UI CONSTRUCTION (Matching the ╔═════╗ box style)
# ==============================================================================

# Main Bar Text
TEXT="$BAR <span color='#cdd6f4' font_weight='bold'>$D_STR</span> <span color='$C_UP' size='x-small'>󰕒$U_STR</span>"

# Detailed Tooltip
TT="<b><span color='$C_BORDER'>╔════════ NETWORK TRAFFIC DATA ════════╗</span></b>\n"
TT+="<b><span color='$C_LABEL'>║ INTERFACE</span></b>  <span color='$C_VAL'>${INTERFACE^^}</span>\n"
TT+="<b><span color='$C_DOWN'>║ DOWNLOAD</span></b>   <span color='$C_VAL'>$D_STR/s</span>\n"
TT+="<b><span color='$C_UP'>║ UPLOAD</span></b>     <span color='$C_VAL'>$U_STR/s</span>\n"
TT+="<b><span color='$C_PING'>║ LATENCY</span></b>    <span color='$C_VAL'>${PING}ms</span>\n"
TT+="<b><span color='$C_BORDER'>╠═════════════════════════════════════╣</span></b>\n"
TT+="<b><span color='$C_LABEL'>║ STATUS</span></b>      <span color='$C_DOWN'>CONNECTED 󰄬</span>\n"
TT+="<b><span color='$C_BORDER'>╚═════════════════════════════════════╝</span></b>"

echo "{\"text\":\"$TEXT\", \"tooltip\":\"$TT\"}"