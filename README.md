<div align="center">

# 🌌 Omarchy: Copper Night

> *"Where the deep indigo of Tokyo meets the warm glow of an ember sunset."*

A high-performance **Hyprland** rice for Omarchy featuring a custom **Tokyo Night** palette accented by a striking **Copper-Orange** border.

![Version](https://img.shields.io/badge/version-1.2-orange?style=for-the-badge)
![License](https://img.shields.io/badge/license-MIT-blue?style=for-the-badge)
![Hyprland](https://img.shields.io/badge/Hyprland-Rice-indigo?style=for-the-badge&logo=archlinux)

</div>

---

## 📸 Preview

<img width="1920" height="1080" alt="Image" src="https://github.com/user-attachments/assets/a3d1a123-d1fa-42a8-91cf-a25dcbcf6e2a" />
<img width="1920" height="1080" alt="Image" src="https://github.com/user-attachments/assets/5866f47e-486c-4c46-9fc9-0b76489d6a1f" />
<img width="1920" height="1080" alt="Image" src="https://github.com/user-attachments/assets/cbb78c2d-9ecd-4c36-a5ff-94e0a9fd434b" />
<img width="1920" height="1080" alt="Image" src="https://github.com/user-attachments/assets/859d656f-9031-4899-af3d-74216516b4d9" />
<img width="1920" height="1080" alt="Image" src="https://github.com/user-attachments/assets/3084a665-4a04-4b8a-97b1-557ae9e77c46" />
<img width="1920" height="1080" alt="Image" src="https://github.com/user-attachments/assets/7bd9a22f-c05c-4876-8e61-1af675908163" />
---

| **Feature** | **Description** |
|:---|:---|
| 🖼️ **Wallpaper** | Traditional Japanese Pixel Art Pagoda. |
| 🪟 **UI** | Floating diagnostic widgets with custom resource bars. |
| 🎨 **Colors** | Deep Indigos, Magentas, and Copper-Orange accents. |

---
## ⚙️ Configuration

## Installation Only Theme

Run the following command to install this theme:

```bash
omarchy-theme-install https://github.com/hembramnishant50-glitch/omarchy-coppernight-theme.git
```

### 🌤️ Changing the Weather Location
The weather widget is set to **New York** by default. To change this to your city:

1.  **Open the configuration script:**
    ```bash
    nano ~/.config/waybar/scripts/weather.py
    ```

2.  **Find the `CITY` variable** near the top of the file and replace it with your location:
    ```python
    # Configuration
    CITY = "New York"  # Change "Your_City" to your city name
    ```

3.  **Save and Exit:**
    * Press `Ctrl + O` then `Enter` to save.
    * Press `Ctrl + X` to exit.

4.  **Restart Waybar** to apply changes:
    ```bash
    killall waybar; waybar &
    ```


## 🔒 Hyprlock Setup

Note : Use this after 🚀 Easy Installation (One-Line) Or Installation Only Theme

To enable the custom lock screen and fix media controls, run the following commands:

```bash
# 1. Install Playerctl (Media Controller)
sudo pacman -S --needed playerctl

# 2. Fix Spotify (Only if you use Flatpak version)
if command -v flatpak &> /dev/null; then
    flatpak override --user --talk-name=org.mpris.MediaPlayer2.spotify com.spotify.Client
fi

# 3. Install Config Files
# Copies files from your active Omarchy theme to the Hyprland config folder
cp -r ~/.config/omarchy/current/theme/scripts ~/.config/omarchy/current/theme/quotes.txt ~/.config/omarchy/current/theme/hyprlock.conf ~/.config/hypr/

# Make scripts executable
chmod +x ~/.config/hypr/scripts/*
```

## 🚀 Easy Installation (One-Line)

This command installs all system dependencies (Python libraries, NetworkManager, and Papirus Icons), performs a safe backup of your existing Waybar config, and applies the Copper Night theme.

```bash
sudo pacman -S --needed python-requests python-psutil networkmanager papirus-icon-theme && \
omarchy-theme-install https://github.com/hembramnishant50-glitch/omarchy-coppernight-theme.git && \
{ [ -d ~/.config/waybar ] && mv ~/.config/waybar ~/.config/waybar-backup-$RANDOM; }; \
mkdir -p ~/.config/waybar && \
cp -r ~/.config/omarchy/themes/coppernight/waybar/. ~/.config/waybar/ && \
chmod +x ~/.config/waybar/scripts/* && \
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark' && \
killall waybar; waybar &

