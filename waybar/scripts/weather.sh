#!/bin/bash

# --- CONFIGURATION ---
CITY="Tokyo"
UNITS="m" # "m" for Metric, "u" for US/Imperial
# ---------------------

WEATHER_CODES='{"113":"☀️","116":"⛅","119":"☁️","122":"☁️","143":"🌫","176":"🌦","179":"🌧","182":"🌧","185":"🌧","200":"⛈","227":"🌨","230":"❄️","248":"🌫","260":"🌫","263":"🌦","266":"🌦","281":"🌧","284":"🌧","293":"🌦","296":"🌦","299":"🌧","302":"🌧","305":"🌧","308":"🌧","311":"🌧","314":"🌧","317":"🌧","320":"🌨","323":"🌨","326":"🌨","329":"❄️","332":"❄️","335":"❄️","338":"❄️","350":"🌧","353":"🌦","356":"🌧","359":"🌧","362":"🌧","365":"🌧","368":"🌨","371":"❄️","374":"🌧","377":"🌧","386":"⛈","389":"🌩","392":"⛈","395":"❄️"}'

get_progress_bar() {
    local percent=$1
    local length=10
    local filled=$(( percent * length / 100 ))
    local bar=""
    for ((i=0; i<filled; i++)); do bar+="■"; done
    for ((i=filled; i<length; i++)); do bar+="□"; done
    echo "$bar"
}

get_uv_desc() {
    local uv=$1
    if [ "$uv" -le 2 ]; then echo "Low"; elif [ "$uv" -le 5 ]; then echo "Mod"; elif [ "$uv" -le 7 ]; then echo "High"; else echo "V.High"; fi
}

get_aqi_label() {
    local aqi=$1
    if [ "$aqi" = "N/A" ]; then echo "Unknown";
    elif [ "$aqi" -le 50 ]; then echo "<span color='#a6e3a1'>Good</span>";
    elif [ "$aqi" -le 100 ]; then echo "<span color='#f9e2af'>Moderate</span>";
    elif [ "$aqi" -le 150 ]; then echo "<span color='#fab387'>Unhealthy (S)</span>";
    elif [ "$aqi" -le 200 ]; then echo "<span color='#eba0ac'>Unhealthy</span>";
    elif [ "$aqi" -le 300 ]; then echo "<span color='#cba6f7'>Very Unhealthy</span>";
    else echo "<span color='#f38ba8'>Hazardous</span>"; fi
}

# Fetch Weather Data
RESPONSE=$(curl -s "https://wttr.in/${CITY}?format=j1&${UNITS}")

# Fetch AQI Data
AQI_DATA=$(curl -s "https://api.waqi.info/feed/${CITY}/?token=demo")
AQI_VAL=$(echo "$AQI_DATA" | jq -r '.data.aqi // "N/A"')

if [ -z "$RESPONSE" ] || [ "$(echo "$RESPONSE" | jq -r 'type')" != "object" ]; then
    echo '{"text": " ", "tooltip": "Error: Weather Data Unavailable"}'
    exit 1
fi

# Extract Current Data
TEMP=$(echo "$RESPONSE" | jq -r '.current_condition[0].temp_C')
FEELS=$(echo "$RESPONSE" | jq -r '.current_condition[0].FeelsLikeC')
DESC=$(echo "$RESPONSE" | jq -r '.current_condition[0].weatherDesc[0].value')
CODE=$(echo "$RESPONSE" | jq -r '.current_condition[0].weatherCode')
HUMIDITY=$(echo "$RESPONSE" | jq -r '.current_condition[0].humidity')
UV=$(echo "$RESPONSE" | jq -r '.current_condition[0].uvIndex')
CITY_NAME=$(echo "$RESPONSE" | jq -r '.nearest_area[0].areaName[0].value | ascii_upcase')
COUNTRY=$(echo "$RESPONSE" | jq -r '.nearest_area[0].country[0].value | ascii_upcase')
ICON=$(echo "$WEATHER_CODES" | jq -r --arg code "$CODE" '.[$code] // "✨"')

# Build Tooltip
TT="<b><span color='#cba6f7'>╔════════ METEOROLOGICAL DATA ════════╗</span></b>\n"
TT+="<b><span color='#89b4fa'>║ LOCATION</span></b>   <span color='#dcd6d6'>$CITY_NAME, $COUNTRY</span>\n"
TT+="<b><span color='#a6e3a1'>║ STATUS</span></b>     <span color='#dcd6d6'>$DESC</span>\n"
TT+="<b><span color='#fab387'>║ TEMP</span></b>       <span color='#dcd6d6'>${TEMP}°C</span> <span color='#dcd6d6'>(Feels: ${FEELS}°C)</span>\n"
TT+="<b><span color='#89b4fa'>║ HUMIDITY</span></b>   <span color='#dcd6d6'>[$(get_progress_bar $HUMIDITY)]</span> <span color='#dcd6d6'>$HUMIDITY%</span>\n"
TT+="<b><span color='#f38ba8'>║ UV INDEX</span></b>   <span color='#dcd6d6'>$UV ($(get_uv_desc $UV))</span>\n"
TT+="<b><span color='#94e2d5'>║ AIR QLTY</span></b>   <span color='#dcd6d6'>$AQI_VAL ($(get_aqi_label $AQI_VAL))</span>\n"
TT+="<b><span color='#cba6f7'>╠═════════════════════════════════════╣</span></b>\n"

# 12-Hour Trajectory
TT+="<b><span color='#f9e2af'>║ 12-HOUR TRAJECTORY                  ║</span></b>\n"
HOURLY=$(echo "$RESPONSE" | jq -c '.weather[0].hourly[0,2,4,6]')
while read -r hour; do
    TIME_RAW=$(echo "$hour" | jq -r '.time')
    H_TEMP=$(echo "$hour" | jq -r '.tempC')
    H_CODE=$(echo "$hour" | jq -r '.weatherCode')
    H_RAIN=$(echo "$hour" | jq -r '.chanceofrain')
    H_ICON=$(echo "$WEATHER_CODES" | jq -r --arg code "$H_CODE" '.[$code] // "✨"')
    
    H_INT=$(( TIME_RAW / 100 ))
    [ $H_INT -eq 0 ] && H_TIME="12 AM" || { [ $H_INT -lt 12 ] && H_TIME="${H_INT} AM" || { [ $H_INT -eq 12 ] && H_TIME="12 PM" || H_TIME="$((H_INT-12)) PM"; }; }

    TT+="<b><span color='#cba6f7'>║</span></b> <span color='#dcd6d6'>$(printf "%-6s" "$H_TIME")</span> $H_ICON <span color='#f5c2e7'>$(printf "%-4s" "${H_TEMP}°C")</span> <span color='#f5c2e7'>󰖗 $(printf "%3s" "$H_RAIN")%</span>\n"
done <<< "$HOURLY"

# 3-Day Projection (Skipping Today)
TT+="<b><span color='#cba6f7'>╠═════════════════════════════════════╣</span></b>\n"
TT+="<b><span color='#94e2d5'>║ 3-DAY PROJECTION                    ║</span></b>\n"
FORECAST=$(echo "$RESPONSE" | jq -c '.weather[1,2,3]')
while read -r day; do
    [ -z "$day" ] && continue
    DATE=$(echo "$day" | jq -r '.date')
    MAX=$(echo "$day" | jq -r '.maxtempC')
    MIN=$(echo "$day" | jq -r '.mintempC')
    F_CODE=$(echo "$day" | jq -r '.hourly[4].weatherCode')
    F_ICON=$(echo "$WEATHER_CODES" | jq -r --arg code "$F_CODE" '.[$code] // "✨"')
    
    DAY_NAME=$(date -d "$DATE" '+%a' 2>/dev/null || date -j -f "%Y-%m-%d" "$DATE" "+%a" 2>/dev/null || echo "$DATE")
    
    TT+="<b><span color='#cba6f7'>║</span></b> <span color='#dcd6d6'>$(printf "%-4s" "$DAY_NAME")</span> $F_ICON  <span color='#fab387'>$MAX°C</span> <span color='#45475a'>/</span> <span color='#89b4fa'>$MIN°C</span>\n"
done <<< "$FORECAST"

TT+="<b><span color='#cba6f7'>╚═════════════════════════════════════╝</span></b>"

echo "{\"text\": \"$ICON ${TEMP}°C\", \"tooltip\": \"$TT\"}"