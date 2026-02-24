#!/usr/bin/env python3
import subprocess
import json

def get_battery_info():
    try:
        # Get the battery path
        enumerate_out = subprocess.check_output(["upower", "-e"]).decode("utf-8")
        bat_path = next((line for line in enumerate_out.splitlines() if "battery" in line), None)
        
        if not bat_path:
            return {"text": "󰂎 !!", "tooltip": "<span color='#f38ba8'>No battery detected</span>"}

        # Get detailed info
        info_out = subprocess.check_output(["upower", "-i", bat_path]).decode("utf-8")
        
        data = {}
        for line in info_out.splitlines():
            if ":" in line:
                key, val = line.split(":", 1)
                data[key.strip()] = val.strip()

        percentage = int(data.get("percentage", "0").replace("%", ""))
        state = data.get("state", "discharging")
        
        # Icon logic
        icons = ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
        icon = icons[min(len(icons) - 1, percentage // 10)]
        
        # Color & State Logic
        color = "#a6e3a1"  # Default Green
        css_class = "normal"
        
        if state == "charging" or state == "fully-charged":
            icon = "󱐋"
            color = "#f9e2af" # Yellow
            css_class = "charging"
        elif percentage <= 15:
            color = "#f38ba8" # Red
            css_class = "critical"
        elif percentage <= 30:
            color = "#fab387" # Orange
            css_class = "warning"

        # Build Colorful Tooltip
        # Legend: Blue (#89b4fa), Purple (#cba6f7), Green (#a6e3a1), Red (#f38ba8)
        tooltip = (
            f"<span size='large' color='#89b4fa'><b>󱊦 Battery Statistics</b></span>\n"
            f"<span color='#585b70'>━━━━━━━━━━━━━━━━━━━━━━━━━━</span>\n"
            f"<span color='#cba6f7'>󱐥</span> <b>State:</b>\t\t<span color='{color}'>{state.capitalize()}</span>\n"
            f"<span color='#cba6f7'>󰚥</span> <b>Cycles:</b>\t\t<span color='#cdd6f4'>{data.get('charge-cycles', '0')}</span>\n"
            f"<span color='#cba6f7'>󱄊</span> <b>Health:</b>\t\t<span color='#a6e3a1'>{data.get('capacity', 'N/A')}</span>\n"
            f"<span color='#585b70'>──────────────────────────</span>\n"
            f"<span color='#89b4fa'>󱄌</span> <b>Voltage:</b>\t\t<span color='#cdd6f4'>{data.get('voltage', 'N/A')}</span>\n"
            f"<span color='#89b4fa'>󱠚</span> <b>Energy Rate:</b>\t<span color='#f38ba8'>{data.get('energy-rate', 'N/A')}</span>\n"
            f"<span color='#89b4fa'>󰃰</span> <b>Full Design:</b>\t<span color='#cdd6f4'>{data.get('energy-full-design', 'N/A')}</span>\n"
            f"<span color='#585b70'>──────────────────────────</span>\n"
            f"<span color='#fab387'>󱑂</span> <b>Time Status:</b>\n"
            f"  <span color='#94e2d5'>󰔛</span> To Empty: \t<span color='#cdd6f4'>{data.get('time to empty', 'N/A')}</span>\n"
            f"  <span color='#94e2d5'>󱐋</span> To Full:  \t<span color='#cdd6f4'>{data.get('time to full', 'N/A')}</span>\n"
            f"<span color='#585b70'>━━━━━━━━━━━━━━━━━━━━━━━━━━</span>\n"
            f"<b>Model:</b> <span color='#bac2de'>{data.get('model', 'Unknown')}</span>"
        )

        return {
            "text": f"{icon} {percentage}%",
            "tooltip": tooltip,
            "class": css_class,
            "percentage": percentage
        }
    except Exception as e:
        return {"text": "󰂎 !!", "tooltip": f"<span color='#f38ba8'>Error: {str(e)}</span>"}

if __name__ == "__main__":
    print(json.dumps(get_battery_info()))