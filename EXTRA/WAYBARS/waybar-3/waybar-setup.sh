#!/bin/bash

# Define paths
SOURCE_DIR="$HOME/.config/omarchy/current/theme/EXTRA/WAYBARS/waybar-3"
TARGET_DIR="$HOME/.config/waybar"
BACKUP_DIR="$HOME/.config/waybar-backup-$(date +%Y-%m-%d-%H%M%S)"
SCRIPT_DIR="$TARGET_DIR/scripts"

# 1. Create backup of the existing config if it exists
if [ -d "$TARGET_DIR" ]; then
    echo "Creating backup at $BACKUP_DIR..."
    cp -r "$TARGET_DIR" "$BACKUP_DIR"
fi

# 2. Ensure target directory exists
mkdir -p "$TARGET_DIR"

# 3. Copy the new files
echo "Installing new Waybar config..."
cp -r "$SOURCE_DIR/." "$TARGET_DIR/"

# 4. Ensure script permissions and trigger background scripts
if [ -d "$SCRIPT_DIR" ]; then
    echo "Setting execution permissions for helper scripts..."
    chmod +x "$SCRIPT_DIR"/*.sh
    
    # Optional: Pre-fetch or trigger scripts like weather so Waybar loads it instantly
    if [ -f "$SCRIPT_DIR/weather.sh" ]; then
        echo "Initializing weather service cache..."
        "$SCRIPT_DIR/weather.sh" > /dev/null 2>&1 &
    fi
fi

echo "Restarting Waybar..."
killall waybar 2>/dev/null
(waybar > /dev/null 2>&1 &)

echo "Done! Your old config is safe in $BACKUP_DIR."