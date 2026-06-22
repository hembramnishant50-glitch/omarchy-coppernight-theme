#!/bin/bash
CONFIG="$HOME/.config/waybar/scripts/weather.conf"
CACHE_DIR="$HOME/.cache/weather_module"
CACHE_FILE="$CACHE_DIR/wttr.json"
CACHE_AGE=1800

mkdir -p "$CACHE_DIR"

[[ -f "$CONFIG" ]] && source "$CONFIG"
LOCATION="${LOCATION:-}"
UNIT="${UNIT:-C}"

if [[ $UNIT == "F" ]]; then
  WTTR_UNIT="u"
else
  WTTR_UNIT="m"
fi

CURRENT_TIME=$(date +%s)
if [[ -f "$CACHE_FILE" ]] && (( CURRENT_TIME - $(stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0) < CACHE_AGE )); then
  RESPONSE=$(cat "$CACHE_FILE")
else
  RESPONSE=$(curl -s "wttr.in/${LOCATION}?format=j1&${WTTR_UNIT}")
  [[ -n "$RESPONSE" ]] && echo "$RESPONSE" > "$CACHE_FILE"
fi

[ -z "$RESPONSE" ] && jq -c -n '{text: " --", tooltip: "Weather unavailable", class: "error"}' && exit 0

TEMP=$(echo "$RESPONSE" | jq -r '.current_condition[0].temp_C // "?"')
FEELS=$(echo "$RESPONSE" | jq -r '.current_condition[0].FeelsLikeC // "?"')
HUMIDITY=$(echo "$RESPONSE" | jq -r '.current_condition[0].humidity // "?"')
WIND=$(echo "$RESPONSE" | jq -r '.current_condition[0].windspeedKmph // "?"')
WIND_DIR=$(echo "$RESPONSE" | jq -r '.current_condition[0].winddir16Point // "?"')
DESC=$(echo "$RESPONSE" | jq -r '.current_condition[0].weatherDesc[0].value // "?"')
UV=$(echo "$RESPONSE" | jq -r '.current_condition[0].uvIndex // "?"')
PRESSURE=$(echo "$RESPONSE" | jq -r '.current_condition[0].pressure // "?"')
CITY=$(echo "$RESPONSE" | jq -r '.nearest_area[0].areaName[0].value // "?"')
COUNTRY=$(echo "$RESPONSE" | jq -r '.nearest_area[0].country[0].value // "?"')
HIGH=$(echo "$RESPONSE" | jq -r '.weather[0].maxtempC // "?"')
LOW=$(echo "$RESPONSE" | jq -r '.weather[0].mintempC // "?"')

if [[ $UNIT == "F" && $TEMP != "?" ]]; then
  TEMP=$(( TEMP * 9 / 5 + 32 ))
  FEELS=$(( FEELS * 9 / 5 + 32 ))
  HIGH=$(( HIGH * 9 / 5 + 32 ))
  LOW=$(( LOW * 9 / 5 + 32 ))
  DEG_SYM="°F"
else
  DEG_SYM="°C"
fi

uv_desc() {
  local u=$1
  if [[ $u =~ ^[0-9]+$ ]]; then
    (( u <= 2 )) && echo "Low"
    (( u > 2 && u <= 5 )) && echo "Mod"
    (( u > 5 && u <= 7 )) && echo "High"
    (( u > 7 )) && echo "V.High"
  else echo "?"; fi
}

prog_bar() {
  local p=$1 len=10
  (( p < 0 || p > 100 )) && echo "????" && return
  local filled=$(( p * len / 100 ))
  local bar=""
  for ((i=0; i<filled; i++)); do bar+="■"; done
  for ((i=filled; i<len; i++)); do bar+="□"; done
  echo "$bar"
}

case "$DESC" in
  *[Ss]unny*|*[Cc]lear*)             ICON=""; CLASS="clear" ;;
  *[Pp]artly*[Cc]loudy*|*[Oo]vercast*) ICON="⛅"; CLASS="cloudy" ;;
  *[Cc]loudy*)                        ICON="☁️"; CLASS="cloudy" ;;
  *[Rr]ain*|*[Dd]rizzle*|*[Ss]hower*) ICON="🌦"; CLASS="rain" ;;
  *[Tt]hunder*|*[Ss]torm*)            ICON="⛈"; CLASS="storm" ;;
  *[Ss]now*|*[Hh]ail*|*[Ii]ce*)       ICON="❄️"; CLASS="snow" ;;
  *[Ff]og*|*[Mm]ist*|*[Hh]aze*)       ICON="🌫"; CLASS="fog" ;;
  *)                                  ICON=""; CLASS="" ;;
esac

DIV="<span color='#585b70'>━━━━━━━━━━━━━━━━━━━━━</span>"

TT="<span color='#89b4fa'></span> <b><span color='#cdd6f4'>$CITY, $COUNTRY</span></b>  <span color='#585b70'>—</span>  <span color='#94e2d5'>$DESC</span>
<span color='#f9e2af'></span> <span color='#cdd6f4'>${TEMP}${DEG_SYM}</span> <span color='#585b70'>(Feels: ${FEELS}${DEG_SYM})</span>
<span color='#94e2d5'></span> <span color='#cdd6f4'>$HUMIDITY%</span>
<span color='#fab387'></span> <span color='#cdd6f4'>UV $UV ($(uv_desc "$UV"))</span>
<span color='#cba6f7'></span> <span color='#cdd6f4'>$WIND km/h $WIND_DIR</span>  <span color='#585b70'>│</span>  <span color='#89b4fa'></span> <span color='#cdd6f4'>$PRESSURE hPa</span>
$DIV
<span color='#585b70'> 12-Hour Trajectory</span>"

TEXT="$ICON ${TEMP}${DEG_SYM}"

CURRENT_HOUR=$(date +%H)
CURRENT_IDX=$(( 10#$CURRENT_HOUR / 3 ))

HOURLY_DATA=""
for i in {1..4}; do
  G=$(( CURRENT_IDX + i ))
  DAY_IDX=$(( G / 8 ))
  HOUR_IDX=$(( G % 8 ))
  BLOCK=$(echo "$RESPONSE" | jq -c ".weather[$DAY_IDX].hourly[$HOUR_IDX]")
  HOURLY_DATA+="$BLOCK"$'\n'
done

while IFS= read -r hour; do
  [[ "$hour" == "null" || -z "$hour" ]] && continue
  TIME_RAW=$(echo "$hour" | jq -r '.time // "0"')
  H_TEMP=$(echo "$hour" | jq -r '.tempC // "?"')
  H_CODE=$(echo "$hour" | jq -r '.weatherCode // ""')
  H_RAIN=$(echo "$hour" | jq -r '.chanceofrain // "0"')

  if [[ $UNIT == "F" && $H_TEMP != "?" ]]; then
    H_TEMP=$(( H_TEMP * 9 / 5 + 32 ))
  fi

  TIME_INT=$(( 10#$TIME_RAW / 100 ))
  if (( TIME_INT == 0 )); then H_TIME="12am"
  elif (( TIME_INT < 12 )); then H_TIME="${TIME_INT}am"
  elif (( TIME_INT == 12 )); then H_TIME="12pm"
  else H_TIME="$((TIME_INT - 12))pm"; fi

  case "$H_CODE" in
    113) H_ICON="" ;; 116) H_ICON="⛅" ;; 119|122) H_ICON="☁️" ;;
    143|248|260) H_ICON="🌫" ;;
    176|263|266|293|296|299|302|305|308|311|314|317|350|353|356|359|362|365) H_ICON="🌦" ;;
    179|182|185|227|230|320|323|326|329|332|335|338|368|371|374|377|395) H_ICON="❄️" ;;
    200|386|389|392) H_ICON="⛈" ;;
    *) H_ICON="" ;;
  esac

  TT+="
<span color='#cdd6f4'>$(printf "%-6s" "$H_TIME")</span> $H_ICON <span color='#fab387'>$(printf "%-5s" "${H_TEMP}${DEG_SYM}")</span> <span color='#89b4fa'>󰖗</span> <span color='#cdd6f4'>$(printf "%3s" "$H_RAIN")%</span>"
done <<< "$HOURLY_DATA"

TT+="
$DIV
<span color='#585b70'>󰒎 Next 2-Day Projection</span>"

FORECAST=$(echo "$RESPONSE" | jq -c '.weather[1,2]')
while IFS= read -r day; do
  [[ "$day" == "null" || -z "$day" ]] && continue
  FDATE=$(echo "$day" | jq -r '.date')
  FMAX=$(echo "$day" | jq -r '.maxtempC // "?"')
  FMIN=$(echo "$day" | jq -r '.mintempC // "?"')
  FCODE=$(echo "$day" | jq -r '.hourly[4].weatherCode // ""')

  if [[ $UNIT == "F" && $FMAX != "?" ]]; then
    FMAX=$(( FMAX * 9 / 5 + 32 ))
    FMIN=$(( FMIN * 9 / 5 + 32 ))
  fi

  case "$FCODE" in
    113) F_ICON="" ;; 116) F_ICON="⛅" ;; 119|122) F_ICON="☁️" ;;
    143|248|260) F_ICON="🌫" ;;
    176|263|266|293|296|299|302|305|308|311|314|317|350|353|356|359|362|365) F_ICON="🌦" ;;
    179|182|185|227|230|320|323|326|329|332|335|338|368|371|374|377|395) F_ICON="❄️" ;;
    200|386|389|392) F_ICON="⛈" ;;
    *) F_ICON="" ;;
  esac

  FDAY=$(date -d "$FDATE" +%a 2>/dev/null || echo "$FDATE")

  TT+="
<span color='#cdd6f4'>$(printf "%-4s" "$FDAY")</span> $F_ICON  <span color='#fab387'>${FMAX}${DEG_SYM}</span> <span color='#585b70'>/</span> <span color='#89b4fa'>${FMIN}${DEG_SYM}</span>"
done <<< "$FORECAST"

jq -c -n --arg text "$TEXT" --arg tooltip "$TT" --arg class "$CLASS" '{text: $text, tooltip: $tooltip, class: $class}'
