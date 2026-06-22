#!/bin/bash
CONFIG="$HOME/.config/waybar/scripts/weather.conf"
CACHE="$HOME/.cache/weather_module/wttr.json"

invalidate-cache() {
  rm -f "$CACHE"
}

set-by-ip() {
  info=$(curl -s "http://ip-api.com/json/" 2>/dev/null)
  status=$(echo "$info" | jq -r '.status')
  if [[ $status != "success" ]]; then
    notify-send "Weather" "Failed to detect location by IP"
    exit 1
  fi
  lat=$(echo "$info" | jq -r '.lat')
  lon=$(echo "$info" | jq -r '.lon')
  city=$(echo "$info" | jq -r '.city')
  coords="$lat,$lon"
  sed -i "s/^LOCATION=.*/LOCATION=\"$coords\"/" "$CONFIG"
  invalidate-cache
  notify-send "Weather" "Location set by IP: $city"
}

set-location() {
  city=$(walker --dmenu --placeholder "Enter city or location..." 2>/dev/null)
  [[ -z "$city" ]] && exit 0

  results=$(curl -s "https://nominatim.openstreetmap.org/search?q=${city// /+}&format=json&limit=10&addressdetails=1" 2>/dev/null)
  count=$(echo "$results" | jq 'length' 2>/dev/null)
  [[ $count -eq 0 || -z "$count" ]] && notify-send "Weather" "No locations found" && exit 0

  entries=""
  rm -f /tmp/weather-locations.txt
  for i in $(seq 0 $((count - 1))); do
    name=$(echo "$results" | jq -r ".[$i].address.city // .[$i].address.town // .[$i].address.village // .[$i].address.municipality // .[$i].address.county // .[$i].address.state // .[$i].address.country // .[$i].display_name // \"?\"" | head -1)
    state=$(echo "$results" | jq -r ".[$i].address.state // \"\"" )
    country=$(echo "$results" | jq -r ".[$i].address.country // \"\"" )
    display="$name"
    [[ -n "$state" && "$state" != "$name" ]] && display="$display, $state"
    [[ -n "$country" ]] && display="$display, $country"
    coords=$(echo "$results" | jq -r ".[$i] | (.lat) + \",\" + (.lon)")
    echo "$display|$coords" >> /tmp/weather-locations.txt
    entries+="$display"$'\n'
  done

  chosen=$(echo -e "$entries" | walker --dmenu --placeholder "Select location..." 2>/dev/null)
  [[ -z "$chosen" ]] && exit 0

  coords=$(awk -F'|' -v chosen="$chosen" 'index($0, chosen "|") == 1 {print $2; exit}' /tmp/weather-locations.txt)
  [[ -z "$coords" ]] && notify-send "Weather" "Failed to get coordinates" && exit 1

  sed -i "s/^LOCATION=.*/LOCATION=\"$coords\"/" "$CONFIG"
  invalidate-cache
  notify-send "Weather" "Location set to: $chosen ($coords)"
}

toggle-unit() {
  source "$CONFIG"
  if [[ $UNIT == "C" ]]; then
    sed -i 's/^UNIT=.*/UNIT="F"/' "$CONFIG"
    notify-send "Weather" "Switched to Fahrenheit"
  else
    sed -i 's/^UNIT=.*/UNIT="C"/' "$CONFIG"
    notify-send "Weather" "Switched to Celsius"
  fi
}

open-weather() {
  xdg-open "https://www.google.com/search?q=google+weather" 2>/dev/null
}

forecast() {
  xdg-open "https://wttr.in" 2>/dev/null
}

case "${1:-menu}" in
  set-by-ip) set-by-ip ;;
  set-location) set-location ;;
  toggle-unit) toggle-unit ;;
  open-weather) open-weather ;;
  forecast) forecast ;;
  menu)
    choice=$(printf " Change Location\n Set by IP\n Toggle °C/°F\n Open in Google Weather\n Full Forecast" | walker --dmenu --placeholder "Weather options..." 2>/dev/null)
    case "$choice" in
      *"Change Location"*) set-location ;;
      *"Set by IP"*) set-by-ip ;;
      *"Toggle"*) toggle-unit ;;
      *"Google Weather"*) open-weather ;;
      *"Full Forecast"*) forecast ;;
    esac
    ;;
esac
