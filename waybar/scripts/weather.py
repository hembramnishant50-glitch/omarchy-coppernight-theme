#!/usr/bin/env python
import json
import requests
from datetime import datetime
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

# ==============================================================================
#  CONFIGURATION
# ==============================================================================
# Specify city as "New+York" or "New York" for a manual query
# Use units="u" for USCS (Fahrenheit/Miles) or units="m" for Metric (Celsius)
CITY = "New York" 
UNITS = "m" 
# ==============================================================================

# Weather icons mapping
WEATHER_CODES = {
    '113': '☀️', '116': '⛅', '119': '☁️', '122': '☁️', '143': '🌫', '176': '🌦', '179': '🌧', '182': '🌧', 
    '185': '🌧', '200': '⛈', '227': '🌨', '230': '❄️', '248': '🌫', '260': '🌫', '263': '🌦', '266': '🌦', 
    '281': '🌧', '284': '🌧', '293': '🌦', '296': '🌦', '299': '🌧', '302': '🌧', '305': '🌧', '308': '🌧', 
    '311': '🌧', '314': '🌧', '317': '🌧', '320': '🌨', '323': '🌨', '326': '🌨', '329': '❄️', '332': '❄️', 
    '335': '❄️', '338': '❄️', '350': '🌧', '353': '🌦', '356': '🌧', '359': '🌧', '362': '🌧', '365': '🌧', 
    '368': '🌨', '371': '❄️', '374': '🌧', '377': '🌧', '386': '⛈', '389': '🌩', '392': '⛈', '395': '❄️'
}

def get_progress_bar(percent, length=10):
    try:
        p = int(percent)
        filled = int(length * p / 100)
        bar = "■" * filled + "□" * (length - filled)
        return bar
    except:
        return "□" * length

def format_time(time_str):
    try:
        hour = int(time_str) // 100
        suffix = "AM" if hour < 12 else "PM"
        display_hour = hour % 12
        if display_hour == 0: display_hour = 12
        return f"{display_hour:02d}:00 {suffix}"
    except:
        return time_str

def get_weather():
    data = {}
    try:
        session = requests.Session()
        retry = Retry(total=3, backoff_factor=1, status_forcelist=[500, 502, 503, 504])
        session.mount('https://', HTTPAdapter(max_retries=retry))

        # Build request with location and unit override
        query_city = CITY.replace(" ", "+")
        response = session.get(f"https://wttr.in/{query_city}?format=j1&{UNITS}", timeout=10)
        weather = response.json()
        
        # Pull area and country directly from nearest_area data
        nearest_area = weather['nearest_area'][0]
        city_name = nearest_area['areaName'][0]['value']
        country_name = nearest_area['country'][0]['value']
        
        current = weather['current_condition'][0]
        temp_key = 'temp_F' if UNITS == 'u' else 'temp_C'
        feels_key = 'FeelsLikeF' if UNITS == 'u' else 'FeelsLikeC'
        
        temp = current[temp_key]
        desc = current['weatherDesc'][0]['value']
        code = current['weatherCode']
        humidity = current['humidity']
        unit_label = "°F" if UNITS == 'u' else "°C"
        
        # --- HUD HEADER ---
        tt = "<b><span color='#89dceb'>╔════════ METEOROLOGICAL DATA ════════╗</span></b>\n"
        
        # --- CURRENT CONDITIONS ---
        tt += f"<b><span color='#89dceb'>║ LOCATION</span></b>   <span color='#cdd6f4'>{city_name.upper()}, {country_name.upper()}</span>\n"
        tt += f"<b><span color='#89dceb'>║ STATUS</span></b>     <span color='#cdd6f4'>{desc}</span>\n"
        tt += f"<b><span color='#89dceb'>║ TEMP</span></b>       <span color='#fab387'>{temp}{unit_label}</span> <span color='#6c7086'>(Feels: {current[feels_key]}{unit_label})</span>\n"
        tt += f"<b><span color='#89dceb'>║ HUMIDITY</span></b>   <span color='#45475a'>[{get_progress_bar(humidity)}]</span> <span color='#cdd6f4'>{humidity}%</span>\n"
        tt += "<b><span color='#89dceb'>╠═════════════════════════════════════╣</span></b>\n"
        
        # --- 24-HOUR HOURLY TRAJECTORY ---
        tt += "<b><span color='#f9e2af'>║ 24-HOUR TRAJECTORY                  ║</span></b>\n"
        hourly_data = []
        for day in weather['weather'][:2]: 
            for hour in day['hourly']:
                hourly_data.append(hour)
        
        for hour in hourly_data[:4]:
            h_time = format_time(hour['time'])
            h_icon = WEATHER_CODES.get(hour['weatherCode'], '✨')
            h_temp = f"{hour['temp' + ('F' if UNITS == 'u' else 'C')]}{unit_label}"
            h_rain = f"{hour['chanceofrain']}%"
            tt += f"<b><span color='#89dceb'>║</span></b> <span color='#cdd6f4'>{h_time:<9}</span> {h_icon} <span color='#fab387'>{h_temp:<4}</span> <span color='#89b4fa'>󰖗 {h_rain:>3}</span>\n"

        tt += "<b><span color='#89dceb'>╠═════════════════════════════════════╣</span></b>\n"
        
        # --- DAILY FORECAST ---
        tt += "<b><span color='#cba6f7'>║ DAILY FORECAST                      ║</span></b>\n"
        for day in weather['weather']:
            date_obj = datetime.strptime(day['date'], "%Y-%m-%d")
            day_name = date_obj.strftime("%A")
            
            m_temp = day['maxtemp' + ('F' if UNITS == 'u' else 'C')]
            n_temp = day['mintemp' + ('F' if UNITS == 'u' else 'C')]
            
            noon_code = day['hourly'][4]['weatherCode']
            d_icon = WEATHER_CODES.get(noon_code, '✨')
            
            tt += f"<b><span color='#89dceb'>║</span></b> <span color='#cdd6f4'>{day_name[:9]:<10}</span> {d_icon}  <span color='#fab387'>{m_temp}°/{n_temp}°</span>\n"
        
        tt += "<b><span color='#89dceb'>╚═════════════════════════════════════╝</span></b>"

        data['text'] = f"{WEATHER_CODES.get(code, '✨')} {temp}{unit_label}"
        data['tooltip'] = tt
        
    except Exception as e:
        data['text'] = "󰖪 Offline"
        data['tooltip'] = f"<span color='#f38ba8'><b>Error:</b></span> {str(e)}"

    return data

if __name__ == "__main__":
    print(json.dumps(get_weather()))