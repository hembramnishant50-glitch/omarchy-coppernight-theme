#!/bin/bash
STATE_FILE="/tmp/waybar-caffeine.pid"

if [ -f "$STATE_FILE" ]; then
    pid=$(cat "$STATE_FILE")
    kill "$pid" 2>/dev/null
    rm -f "$STATE_FILE"
    # Re-enable hypridle
    if ! pgrep -x hypridle >/dev/null; then
        uwsm-app -- hypridle >/dev/null 2>&1 &
    fi
    echo '{"text": "󰅶", "tooltip": "Caffeine: Off  |  Idle lock: On", "class": "off"}'
else
    systemd-inhibit --what=idle:sleep --who=waybar-caffeine --why="Manual caffeine" sleep infinity &
    echo $! > "$STATE_FILE"
    # Disable hypridle
    if pgrep -x hypridle >/dev/null; then
        pkill -x hypridle
    fi
    echo '{"text": "󰅵", "tooltip": "Caffeine: On  |  Idle lock: Off", "class": "on"}'
fi

# Signal indicators to refresh
pkill -RTMIN+9 waybar 2>/dev/null
pkill -RTMIN+8 waybar 2>/dev/null
