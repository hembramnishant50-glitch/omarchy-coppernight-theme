#!/bin/bash
STATE_FILE="/tmp/gaming-mode"
if [ -f "$STATE_FILE" ]; then
  echo '{"text":"  🎮  ","alt":"gaming","tooltip":"Gaming Mode: ON\nClick to disable","class":"gaming"}'
else
  echo '{"text":"  🎮  ","alt":"default","tooltip":"Gaming Mode: OFF\nClick to enable","class":"default"}'
fi
