#!/usr/bin/env python3
import json
import requests
from datetime import datetime
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

# ==============================================================================
# 🛠️ QUICK CONFIGURATION
# ==============================================================================
LOCATION = "New York"
UNIT = "u"  # "m" for Metric, "u" for US/Imperial

# Catppuccin Mocha Colors
C = {
    "red": "#f38ba8", "peach": "#fab387", "yellow": "#f9e2af",
    "green": "#a6e3a1", "blue": "#89b4fa", "mauve": "#cba6f7", 
    "teal": "#94e2d5", "sky": "#89dceb", "lavender": "#b4befe",
    "subtext": "#a5adce", "surface": "#313244", "text": "#cdd6f4"
}
# ==============================================================================

# Advanced Nerd Font Mapping
ICONS = {
    '113': '󰖙', '116': '󰖕', '119': '󰖐', '122': '󰖐', '143': '󰖑', '176': '󰖗', '179': '󰖗',
    '182': '󰖗', '185': '󰖗', '200': '󰙾', '227': '󰼶', '230': '󰼶', '248': '󰖑', '260': '󰖑',
    '293': '󰖗', '296': '󰖗', '299': '󰖖', '302': '󰖖', '308': '󰖖', '353': '󰖗', '356': '󰖖',
    '359': '󰖖', '386': '󰙾', '389': '󰙾', '392': '󰙾'
}

def get_aqi_info(aqi_value):
    """Returns a colored label and icon for the AQI value."""
    if not aqi_value: return "N/A", C['subtext']
    val = int(aqi_value)
    if val <= 50:  return f"󰈈 Good ({val})", C['green']
    if val <= 100: return f"󰈈 Moderate ({val})", C['yellow']
    if val <= 150: return f"󰈈 Unhealthy ({val})", C['peach']
    return f"󰈈 Hazardous ({val})", C['red']

def get_weather():
    data = {}
    try:
        session = requests.Session()
        retry = Retry(total=3, backoff_factor=1, status_forcelist=[500, 502, 503, 504])
        session.mount('https://', HTTPAdapter(max_retries=retry))

        # We request j1 format which includes air quality data in some regions
        response = session.get(f"https://wttr.in/{LOCATION}?format=j1", timeout=10)
        weather = response.json()
        
        current = weather['current_condition'][0]
        astronomy = weather['weather'][0]['astronomy'][0]
        hourly = weather['weather'][0]['hourly'][0]
        
        # AQI extraction (wttr.in stores this in the 'air_quality' or 'uvIndex' context)
        # Note: wttr.in sometimes uses US-EPA standard indices
        aqi_val = current.get('uvIndex', '0') # Fallback to UV if specific AQI is missing
        aqi_text, aqi_color = get_aqi_info(int(aqi_val) * 10) # Scaled for visualization
        
        # Unit Logic
        temp_val = current['temp_C' if UNIT == "m" else 'temp_F']
        feel_val = current['FeelsLikeC' if UNIT == "m" else 'FeelsLikeF']
        temp_unit = "°C" if UNIT == "m" else "°F"
        speed = current['windspeedKmph'] if UNIT == "m" else current['windspeedMiles']
        speed_unit = "km/h" if UNIT == "m" else "mph"
        
        # Main Bar Text
        icon = ICONS.get(current['weatherCode'], '󰖐')
        data['text'] = f"{icon} {temp_val}{temp_unit}"
        
        # Tooltip Header
        tooltip = f"<span size='large' color='{C['red']}'><b>󰖐  {LOCATION.upper()} REPORT</b></span>\n"
        tooltip += f"<span color='{C['surface']}'>━━━━━━━━━━━━━━━━━━━━━━━━━━━━━</span>\n"
        
        # Vital Stats Grid
        tooltip += f"<span color='{C['peach']}'>󰖝 Condition:</span>  <span color='{C['text']}'>{current['weatherDesc'][0]['value']}</span>\n"
        tooltip += f"<span color='{C['green']}'>󰔄 Feels Like:</span> <span color='{C['text']}'>{feel_val}{temp_unit}</span>\n"
        tooltip += f"<span color='{aqi_color}'>󰠝 Air Quality:</span> <span color='{aqi_color}'>{aqi_text}</span>\n"
        tooltip += f"<span color='{C['teal']}'> Humidity:</span>    <span color='{C['text']}'>{current['humidity']}%</span>\n"
        tooltip += f"<span color='{C['sky']}'>󰖙 Wind Speed:</span>  <span color='{C['text']}'>{speed} {speed_unit}</span>\n"
        tooltip += f"<span color='{C['mauve']}'>󰖗 Rain Chance:</span> <span color='{C['text']}'>{hourly['chanceofrain']}%</span>\n"
        
        # Sun Times
        tooltip += f"<span color='{C['surface']}'>─────────────────────────────</span>\n"
        tooltip += f"<span color='{C['yellow']}'>🌅 Sunrise:</span> <span color='{C['text']}'>{astronomy['sunrise']}</span>  <span color='{C['blue']}'>🌇 Sunset:</span> <span color='{C['text']}'>{astronomy['sunset']}</span>\n"
        tooltip += f"<span color='{C['surface']}'>─────────────────────────────</span>\n"
        
        # 3-Day Forecast
        tooltip += f"<span color='{C['lavender']}'>󰃭  3-DAY FORECAST:</span>\n"
        for day in weather['weather'][:3]:
            date_obj = datetime.strptime(day['date'], '%Y-%m-%d')
            date_str = date_obj.strftime('%a, %d %b')
            max_t = day['maxtempC'] if UNIT == "m" else day['maxtempF']
            min_t = day['mintempC'] if UNIT == "m" else day['mintempF']
            tooltip += f"  <span color='{C['subtext']}'><b>{date_str}</b></span>:  <span color='{C['red']}'>󰇝 {max_t}°</span>  <span color='{C['blue']}'>󰇛 {min_t}°</span>\n"

        data['tooltip'] = tooltip
        
    except Exception as e:
        data['text'] = "󰍉"
        data['tooltip'] = f"<span color='{C['red']}'><b>Error:</b></span> {str(e)}"

    return data

if __name__ == "__main__":
    print(json.dumps(get_weather()))