#!/bin/bash

# Define 4 frames of a frequency wave
wave_frames=(
    "  ▂ ▃ ▄ ▆"
    "▃ ▅ ▇ ▆ ▄"
    "▆ ▄ ▂    "
    "█ ▆ ▅ ▃ ▂"
)

# Pick a frame based on the current second
idx=$(($(date +%S) % 4))
rev_idx=$((3 - idx)) # Reverse wave for the other side
wave_left="${wave_frames[$idx]}"
wave_right="${wave_frames[$rev_idx]}"

if playerctl -p spotify status > /dev/null 2>&1; then
    artist=$(playerctl -p spotify metadata artist)
    title=$(playerctl -p spotify metadata title)
    
    # Assembly: [Wave] Title - Artist [Wave]
    # Extra spaces at the end fix the "clipping" issue
    echo "$wave_left  $title - $artist  $wave_right   " | cut -c1-60
else
    echo "󰓄 Silence is Focus   "
fi