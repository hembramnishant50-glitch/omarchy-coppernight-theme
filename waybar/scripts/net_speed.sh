#!/bin/bash

INTERFACE=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $5; exit}')
STATH="/proc/net/dev"

UP1=$(grep "$INTERFACE" "$STATH" | awk '{print $10}')
DOWN1=$(grep "$INTERFACE" "$STATH" | awk '{print $2}')
sleep 1
UP2=$(grep "$INTERFACE" "$STATH" | awk '{print $10}')
DOWN2=$(grep "$INTERFACE" "$STATH" | awk '{print $2}')

DOWNS=$(( (DOWN2 - DOWN1) / 1024 ))
UPS=$(( (UP2 - UP1) / 1024 ))

# DIFFERENT STYLE: Vertical "Equalizer" blocks
# Changes color and height based on speed
if [ "$DOWNS" -eq 0 ]; then 
    BAR="<span color='#45475a'>󰇚 </span>"
elif [ "$DOWNS" -lt 100 ]; then 
    BAR="<span color='#a6e3a1'>󰇚 ▂</span>"
elif [ "$DOWNS" -lt 500 ]; then 
    BAR="<span color='#a6e3a1'>󰇚 ▃</span>"
elif [ "$DOWNS" -lt 2000 ]; then 
    BAR="<span color='#f9e2af'>󰇚 ▅</span>"
else 
    BAR="<span color='#f38ba8'>󰇚 ▇</span>"
fi

fmt() {
    if [ "$1" -gt 1024 ]; then
        echo "$(echo "scale=1; $1 / 1024" | bc)M"
    else
        echo "${1}K"
    fi
}

D_STR=$(fmt $DOWNS)
U_STR=$(fmt $UPS)

# TEXT FORMAT: Smaller Upload speed placed ABOVE/NEXT to download
TEXT="$BAR <span color='#cdd6f4' font_weight='bold'>$D_STR</span> <span color='#fab387' size='x-small'>󰕒$U_STR</span>"

echo "{\"text\":\"$TEXT\", \"tooltip\":\"󰛳 $INTERFACE\nDown: $D_STR\nUp: $U_STR\"}"