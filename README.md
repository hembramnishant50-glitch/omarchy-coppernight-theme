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

| | |
|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/39ec8953-3b6f-4420-a9fe-88eb83d76899" width="100%"> | <img src="https://github.com/user-attachments/assets/b84e6655-4653-408d-8281-03d9a34d7b4d" width="100%"> |
| <img src="https://github.com/user-attachments/assets/9560a87d-5b0a-4dfb-803c-29b647411de4" width="100%"> | <img src="https://github.com/user-attachments/assets/16bef38a-b05b-4b98-8da7-eb614974d2d3" width="100%"> |
| <img src="https://github.com/user-attachments/assets/5521874f-feab-4880-b59c-bb2350045173" width="100%"> | <img src="https://github.com/user-attachments/assets/d2dd0073-0f8d-4a87-91e2-7772e865e705" width="100%"> |
| <img src="https://github.com/user-attachments/assets/3a8c2c4a-7bdd-4c73-94c1-8d4ae6f0c6ef" width="100%"> | <img src="https://github.com/user-attachments/assets/c0208938-787d-4e68-8d97-022438678f02" width="100%"> |
---

| **Feature** | **Description** |
|:---|:---|
| 🖼️ **Wallpaper** | Traditional Japanese Pixel Art Pagoda. |
| 🪟 **UI** | Floating diagnostic widgets with custom resource bars. |
| 🎨 **Colors** | Deep Indigos, Magentas, and Copper-Orange accents. |

---

## Installation Only Theme

Run the following command to install this theme:

```bash
omarchy-theme-install https://github.com/hembramnishant50-glitch/omarchy-coppernight-theme.git
```

## 🚀 Easy Installation (One-Line) : Install Theme and Waybar

This command installs all system dependencies (Python libraries, NetworkManager, and Papirus Icons), performs a safe backup of your existing Waybar config, and applies the Copper Night theme.

```bash
sudo pacman -S --needed python-requests python-psutil networkmanager papirus-icon-theme pavucontrol && \
omarchy-theme-install https://github.com/hembramnishant50-glitch/omarchy-coppernight-theme.git && \
{ [ -d ~/.config/waybar ] && mv ~/.config/waybar ~/.config/waybar-backup-$RANDOM; }; \
mkdir -p ~/.config/waybar && \
cp -r ~/.config/omarchy/themes/coppernight/waybar/. ~/.config/waybar/ && \
chmod +x ~/.config/waybar/scripts/* && \
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark' && \
killall waybar; waybar &
```

## ⚙️ Configuration

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

## 📸 Preview

<img width="1311" height="737" alt="Image" src="https://github.com/user-attachments/assets/86b69c94-6096-411f-a41e-4704c238f394" />

---

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
### 🖼️ Customizing Lock Screen Images

To change your **Profile Picture** or **Background Wallpaper**, you need to edit the Hyprlock configuration file directly.

1.  **Open the configuration file:**
    ```bash
    nano ~/.config/hypr/hyprlock.conf
    ```

2.  **Find and Edit the Image Paths:**
    * Look for the `background { ... }` section to change the wallpaper.
    * Look for the `image { ... }` section to change the profile picture.
    * Update the `path = ...` line to point to your desired `.jpg` or `.png` file.
    * **Blur Effect:** Adjust `blur_passes` and `blur_size` to change the glass effect.
        * `blur_passes = 0` (No blur, sharp image)
        * `blur_passes = 3` (Standard blur)
        * `blur_size = 7` (Strength of the blur)

    **Example:**
    ```ini
    background {
        monitor =
        path = /home/user/Pictures/my-wallpaper.jpg   # <--- Change this path Jpg/Png
        color = rgba(25, 20, 20, 1.0)
        blur_passes = 0
    }

    image {
        monitor =
        path = /home/user/Pictures/me.png             # <--- Change this path  Jpg/Png
        size = 150
        ...
    }
    ```

