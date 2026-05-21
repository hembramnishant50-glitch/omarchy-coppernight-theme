#!/bin/bash

# --- CONFIGURATION ---
CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/waybar/scripts/weather_config.txt"

# Read settings if the file exists, otherwise use safe defaults
if [ -f "$CONFIG_FILE" ]; then
    LOCATION=$(sed -n '1p' "$CONFIG_FILE")
    UNIT_PREF=$(sed -n '2p' "$CONFIG_FILE")
else
    LOCATION="Tokyo"
    UNIT_PREF="C"
fi

# Set API flags and Display Symbols based on preference
if [ "$UNIT_PREF" = "F" ]; then
    WTTR_UNIT="u" # Imperial
    DEG_SYM="°F"
else
    WTTR_UNIT="m" # Metric
    DEG_SYM="°C"
fi

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/weather_module"
CACHE_FILE_WTTR="$CACHE_DIR/wttr.json"
CACHE_FILE_AQI="$CACHE_DIR/aqi.json"
CACHE_AGE=900 # 15 minutes

# --- THEME COLORS (Catppuccin Mocha) ---
C_RED='#f38ba8'
C_PEACH='#fab387'
C_YELLOW='#f9e2af'
C_GREEN='#a6e3a1'
C_BLUE='#89b4fa'
C_MAUVE='#cba6f7'
C_TEAL='#94e2d5'
C_SKY='#89dceb'
C_LAVENDER='#b4befe'
C_SUBTEXT='#a5adce'
C_SURFACE='#313244'
C_TEXT='#cdd6f4'
# ---------------------

mkdir -p "$CACHE_DIR"
CITY_ENCODED=$(echo "$LOCATION" | sed 's/ /%20/g')

WEATHER_CODES='{"113":"☀️","116":"⛅","119":"☁️","122":"☁️","143":"🌫","176":"🌦","179":"🌧","182":"🌧","185":"🌧","200":"⛈","227":"🌨","230":"❄️","248":"🌫","260":"🌫","263":"🌦","266":"🌦","281":"🌧","284":"🌧","293":"🌦","296":"🌦","299":"🌧","302":"🌧","305":"🌧","308":"🌧","311":"🌧","314":"🌧","317":"🌧","320":"🌨","323":"🌨","326":"🌨","329":"❄️","332":"❄️","335":"❄️","338":"❄️","350":"🌧","353":"🌦","356":"🌧","359":"🌧","362":"🌧","365":"🌧","368":"🌨","371":"❄️","374":"🌧","377":"🌧","386":"⛈","389":"🌩","392":"⛈","395":"❄️"}'

# --- HELPER FUNCTIONS ---
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
    local uv=${1%.*} 
    if ! [[ "$uv" =~ ^[0-9]+$ ]]; then echo "Unknown";
    elif [ "$uv" -le 2 ]; then echo "Low"; 
    elif [ "$uv" -le 5 ]; then echo "Mod"; 
    elif [ "$uv" -le 7 ]; then echo "High"; 
    else echo "V.High"; fi
}

get_aqi_label() {
    local aqi=$1
    if ! [[ "$aqi" =~ ^[0-9]+$ ]]; then echo "Unknown";
    elif [ "$aqi" -le 50 ]; then echo "<span color='$C_GREEN'>Good</span>";
    elif [ "$aqi" -le 100 ]; then echo "<span color='$C_YELLOW'>Moderate</span>";
    elif [ "$aqi" -le 150 ]; then echo "<span color='$C_PEACH'>Unhealthy (S)</span>";
    elif [ "$aqi" -le 200 ]; then echo "<span color='#eba0ac'>Unhealthy</span>";
    elif [ "$aqi" -le 300 ]; then echo "<span color='$C_MAUVE'>Very Unhealthy</span>";
    else echo "<span color='$C_RED'>Hazardous</span>"; fi
}

get_css_class() {
    local code=$1
    if [[ "$code" =~ ^(113)$ ]]; then echo "clear";
    elif [[ "$code" =~ ^(116|119|122)$ ]]; then echo "cloudy";
    elif [[ "$code" =~ ^(143|248|260)$ ]]; then echo "fog";
    elif [[ "$code" =~ ^(176|263|266|293|296|299|302|305|308|311|314|317|350|353|356|359|362|365)$ ]]; then echo "rain";
    elif [[ "$code" =~ ^(179|182|185|227|230|320|323|326|329|332|335|338|368|371|374|377|395)$ ]]; then echo "snow";
    elif [[ "$code" =~ ^(200|386|389|392)$ ]]; then echo "storm";
    else echo "default"; fi
}

# --- DATA FETCHING ---
CURRENT_TIME=$(date +%s)

if [ -f "$CACHE_FILE_WTTR" ] && [ $((CURRENT_TIME - $(stat -c %Y "$CACHE_FILE_WTTR" 2>/dev/null || echo 0))) -lt $CACHE_AGE ]; then
    RESPONSE=$(cat "$CACHE_FILE_WTTR")
else
    RESPONSE=$(curl --max-time 5 -s "https://wttr.in/${CITY_ENCODED}?format=j1&${WTTR_UNIT}")
    [ -n "$RESPONSE" ] && echo "$RESPONSE" > "$CACHE_FILE_WTTR"
fi

if [ -f "$CACHE_FILE_AQI" ] && [ $((CURRENT_TIME - $(stat -c %Y "$CACHE_FILE_AQI" 2>/dev/null || echo 0))) -lt $CACHE_AGE ]; then
    AQI_DATA=$(cat "$CACHE_FILE_AQI")
else
    AQI_CITY_CLEAN=$(echo "$LOCATION" | awk -F',' '{print $1}' | sed 's/ /%20/g')
    AQI_DATA=$(curl --max-time 5 -s "https://api.waqi.info/feed/${AQI_CITY_CLEAN}/?token=demo")
    [ -n "$AQI_DATA" ] && echo "$AQI_DATA" > "$CACHE_FILE_AQI"
fi

AQI_VAL=$(echo "$AQI_DATA" | jq -r '.data.aqi // "N/A"')

if [ -z "$RESPONSE" ] || [ "$(echo "$RESPONSE" | jq -r 'type')" != "object" ]; then
    jq -n -c '{"text": "󰖐 ", "tooltip": "Error: Weather Data Unavailable", "class": "error"}'
    exit 1
fi

# --- DATA PARSING ---
if [ "$UNIT_PREF" = "F" ]; then
    TEMP=$(echo "$RESPONSE" | jq -r '.current_condition[0].temp_F')
    FEELS=$(echo "$RESPONSE" | jq -r '.current_condition[0].FeelsLikeF')
else
    TEMP=$(echo "$RESPONSE" | jq -r '.current_condition[0].temp_C')
    FEELS=$(echo "$RESPONSE" | jq -r '.current_condition[0].FeelsLikeC')
fi

DESC=$(echo "$RESPONSE" | jq -r '.current_condition[0].weatherDesc[0].value')
CODE=$(echo "$RESPONSE" | jq -r '.current_condition[0].weatherCode')
HUMIDITY=$(echo "$RESPONSE" | jq -r '.current_condition[0].humidity')
UV=$(echo "$RESPONSE" | jq -r '.current_condition[0].uvIndex')
CITY_NAME=$(echo "$RESPONSE" | jq -r '.nearest_area[0].areaName[0].value')
COUNTRY=$(echo "$RESPONSE" | jq -r '.nearest_area[0].country[0].value')

ICON=$(echo "$WEATHER_CODES" | jq -r --arg code "$CODE" '.[$code] // "✨"')
CSS_CLASS=$(get_css_class "$CODE")

# --- TOOLTIP ASSEMBLY (Sleek Theme) ---
TT="<b><span color='$C_RED'>󰖐  METEOROLOGICAL DATA</span></b>
<span color='$C_SURFACE'>━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━</span>
<span color='$C_BLUE'>󰤨  Location:</span>   <span color='$C_TEXT'>$CITY_NAME, $COUNTRY</span>
<span color='$C_GREEN'>󰖝  Condition:</span>  <span color='$C_TEXT'>$DESC</span>
<span color='$C_PEACH'>󰔄  Temp:</span>       <span color='$C_TEXT'>${TEMP}${DEG_SYM} (Feels: ${FEELS}${DEG_SYM})</span>
<span color='$C_TEAL'>  Humidity:</span>   <span color='$C_SURFACE'>[</span><span color='$C_TEXT'>$(get_progress_bar "$HUMIDITY")</span><span color='$C_SURFACE'>]</span> <span color='$C_TEXT'>$HUMIDITY%</span>
<span color='$C_YELLOW'>󰖙  UV Index:</span>   <span color='$C_TEXT'>$UV ($(get_uv_desc "$UV"))</span>
<span color='$C_MAUVE'>󰠝  Air Qlty:</span>   <span color='$C_TEXT'>$AQI_VAL ($(get_aqi_label "$AQI_VAL"))</span>
<span color='$C_SURFACE'>─────────────────────────────────────</span>
<span color='$C_YELLOW'>󱎫  12-HOUR TRAJECTORY</span>
"

# --- DYNAMIC HOURLY CALCULATION ---
CURRENT_HOUR=$(date +%H)
CURRENT_IDX=$(( 10#$CURRENT_HOUR / 3 ))

HOURLY=""
for i in {1..4}; do
    G=$(( CURRENT_IDX + i ))
    DAY_IDX=$(( G / 8 ))
    HOUR_IDX=$(( G % 8 ))
    BLOCK=$(echo "$RESPONSE" | jq -c ".weather[$DAY_IDX].hourly[$HOUR_IDX]")
    HOURLY+="$BLOCK"$'\n'
done

while read -r hour; do
    [ "$hour" = "null" ] || [ -z "$hour" ] && continue
    
    TIME_RAW=$(echo "$hour" | jq -r '.time // "0"')
    
    if [ "$UNIT_PREF" = "F" ]; then
        H_TEMP=$(echo "$hour" | jq -r '.tempF')
    else
        H_TEMP=$(echo "$hour" | jq -r '.tempC')
    fi
    
    H_CODE=$(echo "$hour" | jq -r '.weatherCode')
    H_RAIN=$(echo "$hour" | jq -r '.chanceofrain')
    H_ICON=$(echo "$WEATHER_CODES" | jq -r --arg code "$H_CODE" '.[$code] // "✨"')
    
    TIME_RAW=$((10#$TIME_RAW))
    H_INT=$(( TIME_RAW / 100 ))
    
    if [ "$H_INT" -eq 0 ]; then H_TIME="12 AM"
    elif [ "$H_INT" -lt 12 ]; then H_TIME="${H_INT} AM"
    elif [ "$H_INT" -eq 12 ]; then H_TIME="12 PM"
    else H_TIME="$((H_INT-12)) PM"; fi

    TT+="
<span face='monospace'>  $(printf "%-7s" "$H_TIME") $H_ICON   <span color='$C_PEACH'>$(printf "%-4s" "${H_TEMP}${DEG_SYM}")</span> <span color='$C_SKY'>󰖗 $(printf "%2s" "$H_RAIN")%</span></span>"
done <<< "$HOURLY"

TT+="
<span color='$C_SURFACE'>─────────────────────────────────────</span>
<span color='$C_LAVENDER'>󰃭  NEXT 2-DAY PROJECTION</span>
"

FORECAST=$(echo "$RESPONSE" | jq -c '.weather[1,2]')
while read -r day; do
    [ "$day" = "null" ] || [ -z "$day" ] && continue
    
    DATE=$(echo "$day" | jq -r '.date')
    
    if [ "$UNIT_PREF" = "F" ]; then
        MAX=$(echo "$day" | jq -r '.maxtempF')
        MIN=$(echo "$day" | jq -r '.mintempF')
    else
        MAX=$(echo "$day" | jq -r '.maxtempC')
        MIN=$(echo "$day" | jq -r '.mintempC')
    fi
    
    F_CODE=$(echo "$day" | jq -r '.hourly[4].weatherCode')
    F_ICON=$(echo "$WEATHER_CODES" | jq -r --arg code "$F_CODE" '.[$code] // "✨"')
    
    DAY_NAME=$(date -d "$DATE" '+%a' 2>/dev/null || date -j -f "%Y-%m-%d" "$DATE" "+%a" 2>/dev/null || echo "$DATE")
    
    TT+="
<span face='monospace'>  $(printf "%-7s" "$DAY_NAME") $F_ICON   <span color='$C_PEACH'>${MAX}${DEG_SYM}</span> <span color='$C_SURFACE'>/</span> <span color='$C_BLUE'>${MIN}${DEG_SYM}</span></span>"
done <<< "$FORECAST"

TT+="
<span color='$C_SURFACE'>━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━</span>
<b><span color='$C_GREEN'>󰰠 LMB:</span></b> Change Loc  |  <b><span color='$C_RED'>󰰠 RMB:</span></b> Refresh"

jq -n -c --arg text "$ICON ${TEMP}${DEG_SYM}" --arg tooltip "$TT" --arg class "$CSS_CLASS" '{text: $text, tooltip: $tooltip, class: $class}'