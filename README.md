<div align="center">

```
░█▀▀█ ░█▀▀▀█ ░█▀▀█ ░█▀▀█ ░█▀▀▀ ░█▀▀█   ░█▄─░█ ░█▀▀▀ ░█▀▀█ ░█─░█ ▀▀█▀▀
░█─── ░█──░█ ░█▄▄█ ░█▄▄█ ░█▀▀▀ ░█▄▄▀   ░█░█░█ ░█▀▀▀ ░█─▄▄ ░█▀▀█ ─░█──
░█▄▄█ ░█▄▄▄█ ░█─── ░█─── ░█▄▄▄ ░█─░█   ░█──▀█ ░█▄▄▄ ░█▄▄█ ░█─░█ ─░█──
```

# 🌌 Copper Night

> *"Where the deep indigo of Tokyo meets the warm glow of an ember sunset."*

A high-performance **Hyprland** rice for **Omarchy** — featuring a carefully crafted **Tokyo Night** palette  
kissed by a striking **Copper-Orange** border that glows like a setting sun.

<br>

[![Version](https://img.shields.io/badge/version-1.2-C87941?style=for-the-badge&logo=git&logoColor=white)](https://github.com/hembramnishant50-glitch/omarchy-coppernight-theme)
[![License](https://img.shields.io/badge/license-MIT-7AA2F7?style=for-the-badge&logo=opensourceinitiative&logoColor=white)](LICENSE)
[![Hyprland](https://img.shields.io/badge/Hyprland-Rice-565f89?style=for-the-badge&logo=archlinux&logoColor=white)](https://hyprland.org)
[![Stars](https://img.shields.io/github/stars/hembramnishant50-glitch/omarchy-coppernight-theme?style=for-the-badge&color=BB9AF7&logo=starship&logoColor=white)](https://github.com/hembramnishant50-glitch/omarchy-coppernight-theme/stargazers)

</div>

---

## 📸 Screenshots

<div align="center">

| | |
|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/74b6b030-6181-4f01-a142-0a56e4046b14" width="100%"> | <img src="https://github.com/user-attachments/assets/94cdb423-e93f-4498-9f0c-a60f7ba3ed0f" width="100%"> |
| <img src="https://github.com/user-attachments/assets/10b7736e-0035-4659-aec4-eff0d3d2fa01" width="100%"> | <img src="https://github.com/user-attachments/assets/16bef38a-b05b-4b98-8da7-eb614974d2d3" width="100%"> |
| <img src="https://github.com/user-attachments/assets/cfb9a3e2-c1ba-4a9c-ac66-248c5705d8eb" width="100%"> | <img src="https://github.com/user-attachments/assets/ab64aa85-bfb6-4b89-8574-3a6e83230cc0" width="100%"> |
| <img src="https://github.com/user-attachments/assets/ccf2cc6d-b891-4ec3-9605-a2d1805fff1b" width="100%"> | <img src="https://github.com/user-attachments/assets/d6114edb-e239-4f6e-8fdd-85d7b54e4ece" width="100%"> |

</div>

---

## ✨ Features

<div align="center">

| | Feature | Description |
|:---:|:---|:---|
| 🖼️ | **Wallpaper** | Traditional Japanese Pixel Art Pagoda — handpicked for the aesthetic |
| 🪟 | **Widgets** | Floating diagnostic panels with custom animated resource bars |
| 🎨 | **Color Palette** | Deep Indigos · Electric Magentas · Warm Copper-Orange accents |
| 🌤️ | **Weather Widget** | Live weather with click-to-change city — no script editing needed |
| 🔒 | **Lock Screen** | Glassmorphism Hyprlock with blur, quotes, and media controls |
| 🎵 | **Media Controls** | Playerctl integration with full Spotify Flatpak support |

</div>

---

## 🎨 Color Palette

<div align="center">

| Swatch | Name | Hex |
|:---:|:---|:---:|
| ![](https://placehold.co/40x20/1a1b2e/1a1b2e) | Background | `#11111b` |
| ![](https://placehold.co/40x20/565f89/565f89) | Deep Indigo | `#565f89` |
| ![](https://placehold.co/40x20/7aa2f7/7aa2f7) | Electric Blue | `#7aa2f7` |
| ![](https://placehold.co/40x20/bb9af7/bb9af7) | Magenta | `#bb9af7` |
| ![](https://placehold.co/40x20/c87941/c87941) | Copper-Orange | `#fab387` |
| ![](https://placehold.co/40x20/c0caf5/c0caf5) | Foreground | `#c0caf5` |

</div>

---

## 🚀 Installation

### Step 1 — Install the Theme

```bash
omarchy-theme-install https://github.com/hembramnishant50-glitch/omarchy-coppernight-theme.git
```

---

### Step 2 — Install Waybar *(Optional)*

> 💾 Your existing Waybar config is automatically backed up before anything is changed.

```bash
# Install dependencies
sudo pacman -S --needed python-requests python-psutil networkmanager \
  papirus-icon-theme pavucontrol bc zenity jq curl
sudo systemctl enable --now NetworkManager
pip install psutil

# Backup existing Waybar config
if [ -d ~/.config/waybar ]; then
    BACKUP_NAME="waybar-backup-$(date +%d-%m-%Y)-$RANDOM"
    mv ~/.config/waybar ~/.config/"$BACKUP_NAME"
    echo "Backed up to ~/.config/$BACKUP_NAME"
fi

# Apply Copper Night Waybar
mkdir -p ~/.config/waybar
SOURCE_DIR="$HOME/.config/omarchy/current/theme/waybar"

if [ -d "$SOURCE_DIR" ]; then
    cp -r "$SOURCE_DIR"/* ~/.config/waybar/

    if [ -d ~/.config/waybar/scripts ]; then
        chmod +x ~/.config/waybar/scripts/*
        # Force system Python to prevent environment conflicts
        find ~/.config/waybar/scripts -type f -name "*.py" \
          -exec sed -i '1s|^#!/usr/bin/env python3|#!/usr/bin/python3|' {} +
    fi
fi

# Apply Papirus Dark icons & restart Waybar
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
killall -q waybar; nohup waybar > /dev/null 2>&1 &
```

---

## 🪟 Waybar Variants

> ⚠️ Waybar-1 and Waybar-2 require **Step 1** or **Step 2** to be completed first.

<br>

### 🅰️ Default Waybar

<div align="center">
<img width="1920" height="55" alt="Default Waybar" src="https://github.com/user-attachments/assets/2aab9a8e-2bed-45e9-ab6b-a2c2e6c51d77" />
<p><em>Clean and minimal — ships out of the box with the full install.</em></p>
</div>

---

### 🅱️ Waybar-1 — Pill Style

<div align="center">
<img width="1920" height="78" src="https://github.com/user-attachments/assets/05fd9edb-4d6b-4f5b-8fd4-56a004b1c428" alt="Waybar-1 Pill Style">
<p><em>Neon pill borders · Rounded segments · Compact & clean</em></p>
</div>

```bash
cd ~/.config/omarchy/current/theme/EXTRA/WAYBARS/waybar-1 \
  && chmod +x Setup-Waybar.sh && ./Setup-Waybar.sh \
  && chmod +x ~/.config/waybar/scripts/*
```

---

### ⚡ Waybar-2 — Ember Arc

<div align="center">
<img width="1917" height="76" alt="Waybar-2 Ember Arc" src="https://github.com/user-attachments/assets/72af47f3-be44-4c73-bca3-d028735b69c0" />
<p><em>Copper warmth · Floating arcs · Glows like a setting sun</em></p>
</div>

```bash
cd ~/.config/omarchy/current/theme/EXTRA/WAYBARS/waybar-2 \
  && chmod +x waybar-setup.sh && ./waybar-setup.sh
```

---

## 🌤️ Weather Widget

No more editing scripts. **One click** updates your city.

<div align="center">

| 🖱️ Click | ⌨️ Type | ✅ Done |
|:---:|:---:|:---:|
| Tap the weather icon | Enter your city name | Press `Enter` |
| `🌡️` `☀️` `🌧️` | `London` · `Tokyo` · `Patna` | Updates instantly |

</div>

> 💡 Your city is saved automatically. To refresh, click the icon again or run `killall waybar; waybar &`.

---

## 🔒 Lock Screen

<div align="center">

<img width="1311" height="737" alt="Hyprlock Preview" src="https://github.com/user-attachments/assets/86b69c94-6096-411f-a41e-4704c238f394" />

*Glassmorphism lock screen with live clock, random quotes, and media controls*

</div>

### Installation

> ⚠️ Complete **Step 1** (theme install) before running this.

```bash
# 1. Install Playerctl (required for media key support)
sudo pacman -S --needed playerctl

# 2. Fix Spotify media controls (Flatpak only)
if command -v flatpak &> /dev/null; then
    flatpak override --user \
      --talk-name=org.mpris.MediaPlayer2.spotify \
      com.spotify.Client
fi

# 3. Copy lock screen config files
mv ~/.config/hypr/hyprlock.conf ~/.config/hypr/hyprlock.conf-Backup && \
cp -r ~/.config/omarchy/current/theme/scripts \
      ~/.config/omarchy/current/theme/quotes.txt \
      ~/.config/omarchy/current/theme/hyprlock.conf \
      ~/.config/hypr/

# 4. Make scripts executable
chmod +x ~/.config/hypr/scripts/*

```

---

> ### ⚠️ Fix: Black Screen on Lock
>
> If your screen goes black when locking, apply this quick fix.
>
> **1. Open the file:**
> ```bash
> nano ~/.local/share/omarchy/bin/omarchy-system-lock
> ```
>
> **2. Find this line at the bottom:**
> ```bash
> omarchy-brightness-display off
> ```
>
> **3. Comment it out by adding `#` at the start:**
> ```bash
> # omarchy-brightness-display off
> ```
>
> **4. Save and exit:** `Ctrl+O` → `Enter` → `Ctrl+X`

---

### Customize the Lock Screen

```bash
nano ~/.config/omarchy/current/theme/hyprlock.conf
```

```ini
# Wallpaper
background {
    monitor =
    path = /home/YOUR_USER/Pictures/your-wallpaper.jpg
    blur_passes = 3   # 0 = sharp · 3 = soft glass · 5+ = dreamy
    blur_size   = 7
}

# Profile Picture
image {
    monitor =
    path = /home/YOUR_USER/Pictures/your-avatar.png
    size = 150
}
```

| `blur_passes` | Effect |
|:---:|:---|
| `0` | Sharp — no blur |
| `2` | Subtle — light frost |
| `3` | Standard — soft glass |
| `5+` | Heavy — dreamy glow |

### Restore the Original Lock Screen

```bash
rm ~/.config/hypr/hyprlock.conf \
  && mv ~/.config/hypr/hyprlock.conf-Backup ~/.config/hypr/hyprlock.conf
```

---

## 🖼️ Wallpaper Collection

<div align="center">

> All wallpapers ship with the theme, optimized for dark desktop aesthetics.

### 🌙 Featured — Cats at Moonrise

<img src="https://github.com/user-attachments/assets/0d5fdda4-00e9-4478-a342-7dc5f7bb214d" width="100%" alt="Cats at Moonrise">

*Five cats perched before a copper sunset — the spirit of Copper Night in one frame.*

<br>

| | |
|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/b15da239-27ee-4555-b2d9-24f8f8f15602" width="100%"> | <img src="https://github.com/user-attachments/assets/55cc1ac0-f377-4fb0-9eb9-0da644e1d9d4" width="100%"> |
| ⚔️ **The Last Swordsman** · *Dark Fantasy* | 👺 **Girl & Hannya** · *Monochrome Yokai* |
| <img src="https://github.com/user-attachments/assets/34e74655-7dd6-4344-b53b-31707e25a4f9" width="100%"> | <img src="https://github.com/user-attachments/assets/ab07a513-d0d3-4daa-9501-ec87862752c1" width="100%"> |
| 🪶 **Itachi & The Crows** · *Akatsuki* | 🏯 **Mountain Castle** · *Pixel Art* |

</div>

| Wallpaper | Style | Resolution |
|:---|:---|:---:|
| 🐱 Cats at Moonrise | Lofi · Ghibli | 3840 × 2160 |
| 🏯 Mountain Castle | Pixel Art | 5120 × 2880 |
| ⚔️ The Last Swordsman | Dark Fantasy | 3840 × 2160 |
| 👺 Girl & Hannya | Monochrome · Yokai | 3840 × 2160 |
| 🪶 Itachi & The Crows | Naruto · Akatsuki | 3840 × 2160 |

---

## 🤝 Contributing

Contributions are warmly welcome!

1. **Fork** this repository
2. **Create** a branch: `git checkout -b feat/your-idea`
3. **Commit** your changes: `git commit -m "feat: add your idea"`
4. **Push** and open a **Pull Request**

---

<div align="center">

Made with 🧡 for **Omarchy**

*If this theme made your desktop beautiful, consider leaving a ⭐ — it means a lot!*

[![GitHub](https://img.shields.io/badge/GitHub-hembramnishant50--glitch-181717?style=for-the-badge&logo=github)](https://github.com/hembramnishant50-glitch)

</div>
