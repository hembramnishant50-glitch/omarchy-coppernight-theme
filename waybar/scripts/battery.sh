#!/bin/bash
BAT="/sys/class/power_supply/BAT0"
[ -d "$BAT" ] && CAP=$(cat "$BAT/capacity") || CAP="N/A"
[ -d "$BAT" ] && STAT=$(cat "$BAT/status") || STAT="Unknown"
case "$STAT" in
    Charging) ICON="󱐋"; MSG="Charging $CAP%" ;;
    Full)     ICON="󱐋"; MSG="Fully charged $CAP%" ;;
    Discharging)
        if [ "$CAP" -ge 80 ]; then ICON=""; elif [ "$CAP" -ge 60 ]; then ICON=""; elif [ "$CAP" -ge 40 ]; then ICON=""; elif [ "$CAP" -ge 20 ]; then ICON=""; else ICON=""; fi
        MSG="Discharging $CAP%" ;;
    *) ICON="󰂑"; MSG="No battery" ;;
esac
echo "{\"text\":\"$ICON $CAP%\",\"tooltip\":\"$MSG\"}"
