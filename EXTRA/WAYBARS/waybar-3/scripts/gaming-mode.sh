#!/bin/bash

STATE_FILE="/tmp/gaming-mode"

# Clean stale backups only when returning to normal state
cleanup_stale_backups() {
    for f in "$HOME/.config/omarchy/current/theme/"*.bak "$HOME/.config/waybar/"*.bak; do
        [[ -f $f ]] && rm -f "$f"
    done
}
HYPRLAND_CONF="$HOME/.config/omarchy/current/theme/hyprland.conf"
HYPRLAND_CONF_BAK="$HOME/.config/omarchy/current/theme/hyprland.conf.bak"
WALKER_CSS="$HOME/.config/omarchy/current/theme/walker.css"
WALKER_CSS_BAK="$HOME/.config/omarchy/current/theme/walker.css.bak"
WAYBAR_CSS="$HOME/.config/omarchy/current/theme/waybar.css"
WAYBAR_CSS_BAK="$HOME/.config/omarchy/current/theme/waybar.css.bak"
WAYBAR_STYLE="$HOME/.config/waybar/style.css"
WAYBAR_STYLE_BAK="$HOME/.config/waybar/style.css.bak"
WAYBAR_CONFIG="$HOME/.config/waybar/config.jsonc"
WAYBAR_CONFIG_BAK="$HOME/.config/waybar/config.jsonc.bak"

HEAVY_PROCS=("firefox" "chromium" "chromium-browser" "chrome" "brave" "electron" "steam" "discord" "slack" "teams" "code" "obsidian" "thunderbird")

suspend_apps() {
    for proc in "${HEAVY_PROCS[@]}"; do
        pkill -STOP -x "$proc" 2>/dev/null || true
    done
}

resume_apps() {
    for proc in "${HEAVY_PROCS[@]}"; do
        pkill -CONT -x "$proc" 2>/dev/null || true
    done
}

count_suspended() {
    local count=0
    for proc in "${HEAVY_PROCS[@]}"; do
        if pgrep -x "$proc" >/dev/null 2>&1; then
            pid=$(pgrep -x "$proc" 2>/dev/null | head -1)
            if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
                state=$(ps -o state= -p "$pid" 2>/dev/null)
                [[ "$state" == "T" ]] && count=$((count + 1))
            fi
        fi
    done
    echo "$count"
}

gaming_hyprland() {
    [ ! -f "$HYPRLAND_CONF_BAK" ] && cp "$HYPRLAND_CONF" "$HYPRLAND_CONF_BAK"
    sed -i \
        -e 's/rounding = 14/rounding = 0/' \
        -e 's/active_opacity = 0.95/active_opacity = 1.0/' \
        -e 's/inactive_opacity = 0.95/inactive_opacity = 1.0/' \
        -e '/blur {/,/^}/s/enabled = true/enabled = false/' \
        -e '/shadow {/,/^}/s/enabled = true/enabled = false/' \
        -e '/animations {/,/^}/s/enabled = yes/enabled = no/' \
        -e 's/gaps_in = 5/gaps_in = 2/' \
        -e 's/gaps_out = 8/gaps_out = 4/' \
        "$HYPRLAND_CONF"
    grep -qxF 'windowrule = opacity 1.0 override 1.0 override' "$HYPRLAND_CONF" || echo 'windowrule = opacity 1.0 override 1.0 override' >> "$HYPRLAND_CONF"
    hyprctl reload
}

normal_hyprland() {
    if [ -f "$HYPRLAND_CONF_BAK" ]; then
        cp "$HYPRLAND_CONF_BAK" "$HYPRLAND_CONF"
        rm -f "$HYPRLAND_CONF_BAK"
        hyprctl reload
    fi
}

gaming_walker() {
    [ ! -f "$WALKER_CSS_BAK" ] && cp "$WALKER_CSS" "$WALKER_CSS_BAK"
    sed -i \
        -e 's/border-radius: 28px;/border-radius: 0px;/g' \
        -e 's/border-radius: 10px;/border-radius: 0px;/g' \
        "$WALKER_CSS"
    omarchy-restart-walker 2>/dev/null || true
}

normal_walker() {
    if [ -f "$WALKER_CSS_BAK" ]; then
        cp "$WALKER_CSS_BAK" "$WALKER_CSS"
        rm -f "$WALKER_CSS_BAK"
        omarchy-restart-walker 2>/dev/null || true
    fi
}

gaming_waybar() {
    [ ! -f "$WAYBAR_CSS_BAK" ] && cp "$WAYBAR_CSS" "$WAYBAR_CSS_BAK"
    sed -i \
        -e 's/alpha(@background, [^)]*)/@background/g' \
        -e 's/alpha(@cyan, [^)]*)/@cyan/g' \
        -e 's/alpha(@magenta, [^)]*)/@magenta/g' \
        "$WAYBAR_CSS"
    [ ! -f "$WAYBAR_STYLE_BAK" ] && cp "$WAYBAR_STYLE" "$WAYBAR_STYLE_BAK"
    sed -i \
        -e 's/border-radius: 14px;/border-radius: 0px;/g' \
        -e 's/border-radius: 10px;/border-radius: 0px;/g' \
        -e 's/margin: 4px 3px;/margin: 0px 0px;/g' \
        -e 's/margin: 3px 1px;/margin: 0px 0px;/g' \
        -e 's/font-size: 13px;/font-size: 10px;/g' \
        -e '/transition:/d' \
        -e 's/border: 2px solid #cdd6f4;/border: 3px solid #cdd6f4;/g' \
        "$WAYBAR_STYLE"
    [ ! -f "$WAYBAR_CONFIG_BAK" ] && cp "$WAYBAR_CONFIG" "$WAYBAR_CONFIG_BAK"
    sed -i 's/"height": 44,/"height": 28,/g' "$WAYBAR_CONFIG"
    grep -q 'Arcade retro gaming' "$WAYBAR_STYLE" || cat >> "$WAYBAR_STYLE" << 'RULES'

/* Arcade retro gaming */
#custom-omarchy, #workspaces, #clock, #network, #cpu, #bluetooth, #mpris, #pulseaudio,
#battery, #custom-weather, #custom-power, #custom-update, #custom-voxtype, #custom-gaming,
#custom-screenrecording-indicator, #custom-idle-indicator,
#custom-notification-silencing-indicator, #custom-expand-icon {
    border-width: 3px;
}
#tray {
    border-width: 3px;
}
RULES
}

normal_waybar() {
    if [ -f "$WAYBAR_CSS_BAK" ]; then
        cp "$WAYBAR_CSS_BAK" "$WAYBAR_CSS"
        rm -f "$WAYBAR_CSS_BAK"
    fi
    if [ -f "$WAYBAR_STYLE_BAK" ]; then
        cp "$WAYBAR_STYLE_BAK" "$WAYBAR_STYLE"
        rm -f "$WAYBAR_STYLE_BAK"
    fi
    if [ -f "$WAYBAR_CONFIG_BAK" ]; then
        cp "$WAYBAR_CONFIG_BAK" "$WAYBAR_CONFIG"
        rm -f "$WAYBAR_CONFIG_BAK"
    fi
}

if [ "$1" = "--status" ]; then
    if [ -f "$STATE_FILE" ]; then
        suspended=$(count_suspended)
        tooltip="🎮 Gaming Mode: ON\n"
        tooltip+="━━━━━━━━━━━━━━━━━━\n"
        tooltip+="󰄱 Blur: disabled\n"
        tooltip+="󰕿 Rounding: disabled\n"
        tooltip+="󰤂 Transparency: forced opaque (all windows)\n"
        tooltip+="󰁅 Gaps: tight (2 / 4)\n"
        tooltip+="󰘓 Walker: no rounding\n"
        tooltip+="󰾲 Apps suspended: $suspended\n"
        tooltip+="━━━━━━━━━━━━━━━━━━\n"
        tooltip+="󰐥 Click to disable"
        echo "{\"text\": \"\", \"alt\": \"gaming\", \"tooltip\": \"$tooltip\", \"class\": \"gaming\"}"
    else
        tooltip="🎮 Gaming Mode: OFF\n"
        tooltip+="━━━━━━━━━━━━━━━━━━\n"
        tooltip+="󰄱 Blur: enabled\n"
        tooltip+="󰕿 Rounding: enabled\n"
        tooltip+="󰤂 Transparency: normal\n"
        tooltip+="󰁅 Gaps: 5 / 8\n"
        tooltip+="󰘓 Walker: normal\n"
        tooltip+="━━━━━━━━━━━━━━━━━━\n"
        tooltip+="󰐥 Click to enable"
        echo "{\"text\": \"\", \"alt\": \"default\", \"tooltip\": \"$tooltip\", \"class\": \"default\"}"
    fi
    exit 0
fi

if [ -f "$STATE_FILE" ]; then
    rm -f "$STATE_FILE"
    normal_hyprland
    resume_apps
    normal_walker
    cleanup_stale_backups
    notify-send "🎮 Gaming Mode" "Off — restored to normal" -t 1500
    pkill -RTMIN+12 waybar 2>/dev/null || true
else
    cleanup_stale_backups
    touch "$STATE_FILE"
    gaming_hyprland
    suspend_apps
    gaming_walker
    notify-send "🎮 Gaming Mode" "On — maximum performance, all opacity removed" -t 2000
    pkill -RTMIN+12 waybar 2>/dev/null || true
fi
