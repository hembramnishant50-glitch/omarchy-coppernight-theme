#!/bin/bash

for cmd in curl jq notify-send xdg-open; do
    command -v "$cmd" >/dev/null 2>&1 || {
        jq -n -c '{"text": "⚠️", "tooltip": "Missing dependency: '"$cmd"'"}'
        exit 1
    }
done

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/weather_module"
CACHE_FILE_LOC="$CACHE_DIR/location.json"
CACHE_FILE_WTTR="$CACHE_DIR/wttr.json"
CACHE_FILE_AQI="$CACHE_DIR/aqi.json"
FILE_UNIT="$CACHE_DIR/unit"
FILE_OVERRIDE="$CACHE_DIR/loc_override"
CACHE_AGE=900
mkdir -p "$CACHE_DIR"
CURRENT_TIME=$(date +%s)

WEATHER_CODES='{"113":"☀️","116":"⛅","119":"☁️","122":"☁️","143":"🌫","176":"🌦","179":"🌧","182":"🌧","185":"🌧","200":"🌩","227":"🌨","230":"❄️","248":"🌫","260":"🌫","263":"🌦","266":"🌦","281":"🌧","284":"🌧","293":"🌦","296":"🌧","299":"🌦","302":"🌧","305":"🌧","308":"🌧","311":"🌧","314":"🌧","317":"🌧","320":"🌨","323":"🌨","326":"🌨","329":"❄️","332":"❄️","335":"❄️","338":"❄️","350":"🌧","353":"🌦","356":"🌧","359":"🌧","362":"🌧","365":"🌧","368":"🌨","371":"❄️","374":"🌧","377":"🌧","386":"🌩","389":"🌩","392":"🌩","395":"❄️"}'

if [ "$1" == "--toggle-unit" ]; then
    CURRENT_UNIT=$(cat "$FILE_UNIT" 2>/dev/null || echo "C")
    if [ "$CURRENT_UNIT" == "C" ]; then
        echo "F" > "$FILE_UNIT"
        notify-send -a "Weather" -i "weather-clear" "Weather" "Switched to Fahrenheit (°F)"
    else
        echo "C" > "$FILE_UNIT"
        notify-send -a "Weather" -i "weather-clear" "Weather" "Switched to Celsius (°C)"
    fi
    pkill -RTMIN+8 waybar
    exit 0

elif [ "$1" == "--menu" ]; then
    CURRENT_UNIT=$(cat "$FILE_UNIT" 2>/dev/null || echo "C")
    MENU_OPTIONS="📍 Change Location\n🔄 Toggle Unit (°${CURRENT_UNIT})\n🛰️ Reset to Auto IP\n⚡ Force Refresh\n🌐 Open wttr.in\n🌍 Open Google Weather"

    if command -v walker >/dev/null 2>&1; then
        CHOICE=$(echo -e "$MENU_OPTIONS" | walker --dmenu)
    elif command -v zenity >/dev/null 2>&1; then
        CHOICE=$(echo -e "$MENU_OPTIONS" | zenity --list --column="Weather Menu" --title="Weather" --width=300 --height=250)
    fi

    case "$CHOICE" in
        *"Change Location"*)
            if command -v walker >/dev/null 2>&1; then
                SEARCH_TERM=$(echo | walker --dmenu --inputonly --placeholder "Type a city name...")
            else
                SEARCH_TERM=$(zenity --entry --title="Weather Location" --text="Type any city name:")
            fi

            if [ -n "$SEARCH_TERM" ]; then
                if command -v walker >/dev/null 2>&1; then
                    SUGGESTIONS=$(curl --max-time 5 -s -A "waybar-weather/1.0" \
                        "https://nominatim.openstreetmap.org/search?q=$(echo "$SEARCH_TERM" | sed 's/ /%20/g;s/&/%26/g')&format=json&limit=10&addressdetails=1")
                    CITIES=$(echo "$SUGGESTIONS" | jq -r '.[] | [
                        (.address.city // .address.town // .address.village // .address.municipality // .address.county // ""),
                        (.address.state // .address.region // ""),
                        .address.country
                    ] | map(select(. != "")) | join(", ")' 2>/dev/null)
                    if [ -n "$CITIES" ]; then
                        SELECTED=$(echo "$CITIES" | walker --dmenu --placeholder "Select a city...")
                        [ -n "$SELECTED" ] && NEW_LOC=$(echo "$SELECTED" | awk -F', ' '{print $1}')
                    fi
                fi
                [ -z "$NEW_LOC" ] && NEW_LOC="$SEARCH_TERM"
                echo "$NEW_LOC" > "$FILE_OVERRIDE"
                notify-send -a "Weather" -i "mark-location" "Location Updated" "Now tracking: $NEW_LOC"
                rm -f "$CACHE_FILE_WTTR" "$CACHE_FILE_AQI"
                pkill -RTMIN+8 waybar
            fi
            ;;
        *"Toggle Unit"*)
            "$0" --toggle-unit
            ;;
        *"Reset to Auto"*)
            rm -f "$FILE_OVERRIDE"
            notify-send -a "Weather" -i "mark-location" "Location Reset" "Switched to Automatic IP Tracking."
            rm -f "$CACHE_FILE_WTTR" "$CACHE_FILE_AQI"
            pkill -RTMIN+8 waybar
            ;;
        *"Force Refresh"*)
            rm -f "$CACHE_FILE_WTTR" "$CACHE_FILE_AQI"
            notify-send -a "Weather" -i "view-refresh" "Weather" "Cache cleared."
            pkill -RTMIN+8 waybar
            ;;
        *"Open wttr.in"*)
            if [ -f "$FILE_OVERRIDE" ]; then
                SEARCH_LOC=$(cat "$FILE_OVERRIDE" | sed 's/ /%20/g')
            else
                SEARCH_LOC=$(jq -r '.city // ""' "$CACHE_FILE_LOC" | sed 's/ /%20/g')
            fi
            notify-send -a "Weather" -i "web-browser" "Weather" "Opening wttr.in..."
            xdg-open "https://wttr.in/${SEARCH_LOC}" &
            ;;
        *"Open Google Weather"*)
            if [ -f "$FILE_OVERRIDE" ]; then
                SEARCH_LOC=$(cat "$FILE_OVERRIDE")
            else
                SEARCH_LOC=$(jq -r '.city // ""' "$CACHE_FILE_LOC")
            fi
            ENCODED=$(echo "$SEARCH_LOC" | sed 's/ /+/g')
            notify-send -a "Weather" -i "web-browser" "Weather" "Opening Google Weather..."
            xdg-open "https://www.google.com/search?q=weather+${ENCODED}" &
            ;;
    esac
    exit 0
fi

COLOR_ACCENT="#c4a0f0"
COLOR_MUTED="#8c92a3"
COLOR_TEXT="#dcd6d6"
COLOR_HI="#f9e2af"

UNIT_SYM=$(cat "$FILE_UNIT" 2>/dev/null || echo "C")
MANUAL_LOC=$(cat "$FILE_OVERRIDE" 2>/dev/null)

if [ -n "$MANUAL_LOC" ]; then
    CITY="$MANUAL_LOC"
    LOC_STR="${CITY}"
    LOC=""
    CITY_ENCODED=$(echo "$CITY" | sed 's/ /%20/g')
else
    if [ -f "$CACHE_FILE_LOC" ] && [ $((CURRENT_TIME - $(stat -c %Y "$CACHE_FILE_LOC" 2>/dev/null || echo 0))) -lt 86400 ]; then
        LOC_DATA=$(cat "$CACHE_FILE_LOC")
    else
        LOC_DATA=$(curl --max-time 5 -s "https://ipinfo.io/json")
        [ -n "$LOC_DATA" ] && echo "$LOC_DATA" > "$CACHE_FILE_LOC"
    fi
    CITY=$(echo "$LOC_DATA" | jq -r '.city // "Unknown"')
    REGION=$(echo "$LOC_DATA" | jq -r '.region // ""')
    LOC=$(echo "$LOC_DATA" | jq -r '.loc // ""')
    CITY_ENCODED=$(echo "$CITY" | sed 's/ /%20/g')
    LOC_STR="${CITY}"
    [ -n "$REGION" ] && LOC_STR="${CITY}, ${REGION}"
fi

if [ -f "$CACHE_FILE_WTTR" ] && [ $((CURRENT_TIME - $(stat -c %Y "$CACHE_FILE_WTTR" 2>/dev/null || echo 0))) -lt $CACHE_AGE ]; then
    RESPONSE=$(cat "$CACHE_FILE_WTTR")
else
    if [ -n "$LOC" ]; then
        RESPONSE=$(curl --max-time 15 -s "https://wttr.in/@${LOC}?format=j1&m")
    else
        RESPONSE=$(curl --max-time 15 -s "https://wttr.in/${CITY_ENCODED}?format=j1&m")
    fi
    [ -n "$RESPONSE" ] && echo "$RESPONSE" > "$CACHE_FILE_WTTR"
fi

[ -z "$RESPONSE" ] && jq -n -c '{"text": "🌫️", "tooltip": "Weather Unavailable"}' && exit 1

if [ -f "$CACHE_FILE_AQI" ] && [ $((CURRENT_TIME - $(stat -c %Y "$CACHE_FILE_AQI" 2>/dev/null || echo 0))) -lt $CACHE_AGE ]; then
    AQI_DATA=$(cat "$CACHE_FILE_AQI")
else
    AQI_CITY=$(echo "$CITY" | sed 's/ /%20/g')
    AQI_DATA=$(curl --max-time 5 -s "https://api.waqi.info/feed/${AQI_CITY}/?token=demo")
    [ -n "$AQI_DATA" ] && echo "$AQI_DATA" > "$CACHE_FILE_AQI"
fi
AQI_VAL=$(echo "$AQI_DATA" | jq -r '.data.aqi // "N/A"' 2>/dev/null || echo "N/A")

DESC=$(echo "$RESPONSE" | jq -r '.current_condition[0].weatherDesc[0].value')
CODE=$(echo "$RESPONSE" | jq -r '.current_condition[0].weatherCode')
HUM=$(echo "$RESPONSE" | jq -r '.current_condition[0].humidity')
UV=$(echo "$RESPONSE" | jq -r '.current_condition[0].uvIndex // "0"')
WIND=$(echo "$RESPONSE" | jq -r '.current_condition[0].windspeedKmph // "0"')
PRESS=$(echo "$RESPONSE" | jq -r '.current_condition[0].pressure // "0"')
VIS=$(echo "$RESPONSE" | jq -r '.current_condition[0].visibility // "0"')
SUNRISE=$(echo "$RESPONSE" | jq -r '.weather[0].astronomy[0].sunrise')
SUNSET=$(echo "$RESPONSE" | jq -r '.weather[0].astronomy[0].sunset')

if [ "$UNIT_SYM" == "F" ]; then
    TEMP=$(echo "$RESPONSE" | jq -r '.current_condition[0].temp_F')
    FEELS=$(echo "$RESPONSE" | jq -r '.current_condition[0].FeelsLikeF')
    TMAX=$(echo "$RESPONSE" | jq -r '.weather[0].maxtempF')
    TMIN=$(echo "$RESPONSE" | jq -r '.weather[0].mintempF')
else
    TEMP=$(echo "$RESPONSE" | jq -r '.current_condition[0].temp_C')
    FEELS=$(echo "$RESPONSE" | jq -r '.current_condition[0].FeelsLikeC')
    TMAX=$(echo "$RESPONSE" | jq -r '.weather[0].maxtempC')
    TMIN=$(echo "$RESPONSE" | jq -r '.weather[0].mintempC')
fi

ICON=$(echo "$WEATHER_CODES" | jq -r --arg code "$CODE" '.[$code] // "☀️"')

get_uv() {
    local u=$(echo "${1%.*}" | tr -d '[:space:]')
    [[ -z "$u" || ! "$u" =~ ^[0-9]+$ ]] && u=0
    if [ "$u" -le 2 ]; then echo "Low"
    elif [ "$u" -le 5 ]; then echo "Mod"
    elif [ "$u" -le 7 ]; then echo "High"
    else echo "Ext"; fi
}

get_aqi() {
    local a=$(echo "$1" | tr -d '[:space:]')
    [[ -z "$a" || ! "$a" =~ ^[0-9]+$ ]] && a=0
    if [ "$a" -le 50 ]; then echo "Good"
    elif [ "$a" -le 100 ]; then echo "Mod"
    elif [ "$a" -le 150 ]; then echo "Unhealth"
    elif [ "$a" -le 200 ]; then echo "Poor"
    else echo "Bad"; fi
}
AQI_LABEL=$(get_aqi "$AQI_VAL")
UV_LABEL=$(get_uv "$UV")

NOW_HHMM=$(( $(date +%-H) * 100 ))
HOURS=$(echo "$RESPONSE" | jq -c --argjson now "$NOW_HHMM" '
  ([.weather[0].hourly[] | select((.time | tonumber) >= $now)]) + .weather[1].hourly | .[:8]
')

FCAST=""
while read -r h; do
    [ "$h" = "null" ] || [ -z "$h" ] && continue
    HT=$(echo "$h" | jq -r '.time | tonumber | . / 100 | floor')

    if [ "$HT" -eq 0 ]; then HTFMT="12 AM"
    elif [ "$HT" -eq 12 ]; then HTFMT="12 PM"
    elif [ "$HT" -gt 12 ]; then HTFMT=$(printf "%02d PM" $((HT - 12)))
    else HTFMT=$(printf "%02d AM" $HT); fi

    HCODE=$(echo "$h" | jq -r '.weatherCode')
    HRAIN=$(echo "$h" | jq -r '.chanceofrain')
    HICON=$(echo "$WEATHER_CODES" | jq -r --arg code "$HCODE" '.[$code] // "☀️"')

    [ "$UNIT_SYM" == "F" ] && HTEMP=$(echo "$h" | jq -r '.tempF') || HTEMP=$(echo "$h" | jq -r '.tempC')
    HTEMP_PAD=$(printf "%2s" "${HTEMP}")
    HRAIN_PAD=$(printf "%3s" "${HRAIN}")

    FCAST+="  ${HTFMT}    ${HICON}   ${HTEMP_PAD}°${UNIT_SYM}   🌧️ ${HRAIN_PAD}%"$'\n'
done <<< "$(echo "$HOURS" | jq -c '.[]')"
FCAST="${FCAST%$'\n'}"

DAY1_DATE=$(echo "$RESPONSE" | jq -r '.weather[1].date')
DAY2_DATE=$(echo "$RESPONSE" | jq -r '.weather[2].date')
DAY1_NAME=$(date -d "$DAY1_DATE" "+%A" 2>/dev/null || echo "Tomorrow")
DAY2_NAME=$(date -d "$DAY2_DATE" "+%A" 2>/dev/null || echo "Next Day")

DAY1_CODE=$(echo "$RESPONSE" | jq -r '.weather[1].hourly[4].weatherCode // .weather[1].hourly[0].weatherCode')
DAY2_CODE=$(echo "$RESPONSE" | jq -r '.weather[2].hourly[4].weatherCode // .weather[2].hourly[0].weatherCode')
DAY1_ICON=$(echo "$WEATHER_CODES" | jq -r --arg code "$DAY1_CODE" '.[$code] // "☀️"')
DAY2_ICON=$(echo "$WEATHER_CODES" | jq -r --arg code "$DAY2_CODE" '.[$code] // "☀️"')

if [ "$UNIT_SYM" == "F" ]; then
    D1_MAX=$(echo "$RESPONSE" | jq -r '.weather[1].maxtempF'); D1_MIN=$(echo "$RESPONSE" | jq -r '.weather[1].mintempF')
    D2_MAX=$(echo "$RESPONSE" | jq -r '.weather[2].maxtempF'); D2_MIN=$(echo "$RESPONSE" | jq -r '.weather[2].mintempF')
else
    D1_MAX=$(echo "$RESPONSE" | jq -r '.weather[1].maxtempC'); D1_MIN=$(echo "$RESPONSE" | jq -r '.weather[1].mintempC')
    D2_MAX=$(echo "$RESPONSE" | jq -r '.weather[2].maxtempC'); D2_MIN=$(echo "$RESPONSE" | jq -r '.weather[2].mintempC')
fi

D1_MAX_PAD=$(printf "%2s" "${D1_MAX}"); D1_MIN_PAD=$(printf "%2s" "${D1_MIN}")
D2_MAX_PAD=$(printf "%2s" "${D2_MAX}"); D2_MIN_PAD=$(printf "%2s" "${D2_MIN}")

DAILY_FCAST="  $(printf "%-12s" "${DAY1_NAME}")  ${DAY1_ICON}    ${D1_MAX_PAD}°${UNIT_SYM} / ${D1_MIN_PAD}°${UNIT_SYM}"$'\n'
DAILY_FCAST+="  $(printf "%-12s" "${DAY2_NAME}")  ${DAY2_ICON}    ${D2_MAX_PAD}°${UNIT_SYM} / ${D2_MIN_PAD}°${UNIT_SYM}"

read -r -d '' TT <<EOF
<span size='xx-large' color='${COLOR_ACCENT}'>${ICON} <b>${TEMP}°${UNIT_SYM}</b></span>  <span size='large' color='${COLOR_TEXT}'><b>${DESC}</b></span>
<span color='${COLOR_MUTED}'>${LOC_STR}  •  Feels ${FEELS}°${UNIT_SYM}  •  H/L ${TMAX}°${UNIT_SYM} / ${TMIN}°${UNIT_SYM}</span>

<span color='${COLOR_ACCENT}'><b>METRICS</b></span>
<span color='${COLOR_TEXT}' font_family='monospace'>  💧 Humidity : $(printf "%-9s" "${HUM}%")   🌬️ Wind : ${WIND} km/h
  👁️ Vis     : $(printf "%-9s" "${VIS} km")   🏭 AQI  : ${AQI_VAL} (${AQI_LABEL})
  ☀️ UV Index: $(printf "%-9s" "${UV} (${UV_LABEL})")   🌡️ Pres : ${PRESS} hPa
  🌅 Sunrise  : $(printf "%-9s" "${SUNRISE}")   🌇 Sunset: ${SUNSET}</span>

<span color='${COLOR_ACCENT}'><b>HOURLY</b></span>
<span color='${COLOR_TEXT}' font_family='monospace'>${FCAST}</span>

<span color='${COLOR_ACCENT}'><b>OUTLOOK</b></span>
<span color='${COLOR_TEXT}' font_family='monospace'>${DAILY_FCAST}</span>
EOF

jq -n -c --arg text "$ICON ${TEMP}°${UNIT_SYM}" --arg tooltip "$TT" '{text: $text, tooltip: $tooltip}'
