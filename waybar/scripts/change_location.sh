#!/bin/bash

# Define paths
CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/waybar/scripts/weather_config.txt"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/weather_module"

# Launch a Zenity Form dialog with distinct fields for City, Country, and Unit
OUTPUT=$(zenity --forms \
    --title="Weather Configuration" \
    --text="Configure your weather tracking:" \
    --add-entry="City (e.g., Tokyo)" \
    --add-entry="Country (Optional, e.g., japan)" \
    --add-combo="Temperature Unit" \
    --combo-values="Celsius (°C)|Fahrenheit (°F)" \
    --separator="|" \
    --width=350)

# If the user clicked OK and the output is not empty
if [ $? -eq 0 ] && [ -n "$OUTPUT" ]; then
    # Parse the output into three distinct variables
    NEW_CITY=$(echo "$OUTPUT" | awk -F'|' '{print $1}')
    NEW_COUNTRY=$(echo "$OUTPUT" | awk -F'|' '{print $2}')
    NEW_UNIT_FULL=$(echo "$OUTPUT" | awk -F'|' '{print $3}')
    
    # Combine City and Country cleanly
    if [ -n "$NEW_COUNTRY" ]; then
        FINAL_LOCATION="$NEW_CITY, $NEW_COUNTRY"
    else
        FINAL_LOCATION="$NEW_CITY"
    fi

    # Figure out if they picked C or F
    FINAL_UNIT="C"
    if [[ "$NEW_UNIT_FULL" == *"Fahrenheit"* ]]; then
        FINAL_UNIT="F"
    fi
    
    # Save the exact location on line 1, and the unit on line 2
    echo "$FINAL_LOCATION" > "$CONFIG_FILE"
    echo "$FINAL_UNIT" >> "$CONFIG_FILE"
    
    # Delete the old cached data to force an immediate refresh
    rm -f "$CACHE_DIR/wttr.json" "$CACHE_DIR/aqi.json"
    
    # Instantly refresh Waybar's weather module
    pkill -RTMIN+8 waybar
    
    # Send a desktop notification confirming the new settings
    notify-send "Weather Configured" "Location: $FINAL_LOCATION\nUnits: °$FINAL_UNIT" -i weather-few-clouds
fi