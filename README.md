.

🌌 Omarchy: Copper Night
"Where the deep indigo of Tokyo meets the warm glow of an ember sunset."

A high-performance Hyprland rice for Omarchy featuring a custom Tokyo Night palette accented by a striking Copper-Orange border.

📸 Preview
Wallpaper: Traditional Japanese Pixel Art Pagoda.

UI: Floating diagnostic widgets with custom resource bars.

Colors: Deep Indigos, Magentas, and Copper-Orange accents.

🚀 Easy Installation (One-Line)
This command installs all system dependencies (Python libraries, NetworkManager, and Papirus Icons), performs a safe backup of your existing Waybar config, and applies the Copper Night theme.

Bash
sudo pacman -S --needed python-requests python-psutil networkmanager papirus-icon-theme && \
omarchy-theme-install https://github.com/hembramnishant50-glitch/omarchy-coppernight.git && \
{ [ -d ~/.config/waybar ] && mv ~/.config/waybar ~/.config/waybar-backup-$RANDOM; }; \
mkdir -p ~/.config/waybar && \
cp -r ~/.config/omarchy/themes/coppernight/waybar/. ~/.config/waybar/ && \
chmod +x ~/.config/waybar/scripts/* && \
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark' && \
killall waybar; waybar &
🛠️ What This Setup Includes
📊 System Diagnostics (Waybar)
Powered by custom scripts located in ~/.config/waybar/scripts/:

Weather: weather.py (Real-time updates for Purnia, India).

System Info: system_info.py (CPU, RAM, and Disk tracking).

Network: wifi_info.sh (Active SSID and signal strength).

🎨 Visuals
Icons: Papirus-Dark (automatically applied).

Fastfetch: Custom rainbow-branded "OMARCHY" logo with integrated resource bars.

Fonts: JetBrainsMono Nerd Font (required for bar icons).

📦 Requirements
If you prefer to install parts manually, ensure you have these packages:

System: waybar, hyprland, fastfetch, ghostty

Icons: papirus-icon-theme

Python: python-requests, python-psutil

Network: networkmanager

⚠️ Notes
Waybar Backup: Your old configuration will be automatically saved as ~/.config/waybar-backup-[RANDOM_NUMBER].

Weather Script: You may need to edit ~/.config/waybar/scripts/weather.py if you wish to change the default location from Purnia to your local area.
