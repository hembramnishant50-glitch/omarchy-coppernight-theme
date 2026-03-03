<div align="center">

<br>

```
░█▀▀█ ░█▀▀▀█ ░█▀▀█ ░█▀▀█ ░█▀▀▀ ░█▀▀█   ░█▄─░█ ▀█▀ ░█▀▀█ ░█─░█ ▀▀█▀▀
░█─── ░█──░█ ░█▄▄█ ░█▄▄█ ░█▀▀▀ ░█▄▄▀   ░█░█░█ ░█─ ░█─▄▄ ░█▀▀█ ─░█──
░█▄▄█ ░█▄▄▄█ ░█─── ░█─── ░█▄▄▄ ░█─░█   ░█──▀█ ▄█▄ ░█▄▄█ ░█─░█ ─░█──
```

# 🌌 Omarchy: Copper Night

> *"Where the deep indigo of Tokyo meets the warm glow of an ember sunset."*

A high-performance **Hyprland** rice for **Omarchy** — featuring a carefully crafted **Tokyo Night** palette  
kissed by a striking **Copper-Orange** border that glows like a setting sun.

<br>

[![Version](https://img.shields.io/badge/version-1.2-C87941?style=for-the-badge&logo=git&logoColor=white)](https://github.com/hembramnishant50-glitch/omarchy-coppernight-theme)
[![License](https://img.shields.io/badge/license-MIT-7AA2F7?style=for-the-badge&logo=opensourceinitiative&logoColor=white)](LICENSE)
[![Hyprland](https://img.shields.io/badge/Hyprland-Rice-565f89?style=for-the-badge&logo=archlinux&logoColor=white)](https://hyprland.org)
[![Stars](https://img.shields.io/github/stars/hembramnishant50-glitch/omarchy-coppernight-theme?style=for-the-badge&color=BB9AF7&logo=starship&logoColor=white)](https://github.com/hembramnishant50-glitch/omarchy-coppernight-theme/stargazers)

<br>

</div>

---

## 📸 Screenshots

<div align="center">

| | |
|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/39ec8953-3b6f-4420-a9fe-88eb83d76899" width="100%"> | <img src="https://github.com/user-attachments/assets/b84e6655-4653-408d-8281-03d9a34d7b4d" width="100%"> |
| <img src="https://github.com/user-attachments/assets/9560a87d-5b0a-4dfb-803c-29b647411de4" width="100%"> | <img src="https://github.com/user-attachments/assets/16bef38a-b05b-4b98-8da7-eb614974d2d3" width="100%"> |
| <img src="https://github.com/user-attachments/assets/cfb9a3e2-c1ba-4a9c-ac66-248c5705d8eb" width="100%"> | <img src="https://github.com/user-attachments/assets/ab64aa85-bfb6-4b89-8574-3a6e83230cc0" width="100%"> |
| <img src="https://github.com/user-attachments/assets/ccf2cc6d-b891-4ec3-9605-a2d1805fff1b" width="100%"> | <img src="https://github.com/user-attachments/assets/d6114edb-e239-4f6e-8fdd-85d7b54e4ece" width="100%"> |

</div>

<br>

---

## ✨ Theme Highlights

<div align="center">

| Feature | Description |
|:---:|:---|
| 🖼️ **Wallpaper** | Traditional Japanese Pixel Art Pagoda — handpicked for the aesthetic |
| 🪟 **Widgets** | Floating diagnostic panels with custom animated resource bars |
| 🎨 **Color Palette** | Deep Indigos · Electric Magentas · Warm Copper-Orange accents |
| 🌤️ **Weather Widget** | Live weather display with configurable location |
| 🔒 **Lock Screen** | Glassmorphism Hyprlock with blur, quotes, and media controls |
| 🎵 **Media Controls** | Playerctl integration with full Spotify Flatpak support |

</div>

<br>

---

## 🚀 Installation

> **Choose the method that suits you best.** Both paths lead to the same beautiful result.

<br>

### ⚡ Option A — Theme Only *(Minimal)*

Just want the colors and wallpaper? Run this single command:

```bash
omarchy-theme-install https://github.com/hembramnishant50-glitch/omarchy-coppernight-theme.git
```

<br>

### 🌟 Option B — Full Install *(Recommended)*

This installs **all system dependencies**, **backs up** your existing Waybar config safely, and applies the complete **Copper Night** theme with a fully configured Waybar.

```bash
# 1. Install dependencies
sudo pacman -S --needed \
  python-requests \
  python-psutil \
  networkmanager \
  papirus-icon-theme \
  pavucontrol \
  bc

# 2. Install the theme
omarchy-theme-install https://github.com/hembramnishant50-glitch/omarchy-coppernight-theme.git

# 3. Backup existing Waybar config (safe — uses a random suffix)
[ -d ~/.config/waybar ] && mv ~/.config/waybar ~/.config/waybar-backup-$RANDOM

# 4. Apply the Copper Night Waybar config
mkdir -p ~/.config/waybar
cp -r ~/.config/omarchy/themes/coppernight/waybar/. ~/.config/waybar/
chmod +x ~/.config/waybar/scripts/*

# 5. Apply Papirus Dark icons
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'

# 6. Restart Waybar
killall waybar; waybar &
```

> 💡 **Tip:** Your old Waybar config is backed up as `~/.config/waybar-backup-XXXXX`. Nothing is deleted.

<br>

---

## 🎨 Waybar Variants

Copper Night ships with **two Waybar layouts**. Pick the one that fits your style.

<br>

### 🅰️ Waybar Default *(installed by Option B above)*

The default bar — included in the main install.
<img width="1920" height="64" alt="Image" src="https://github.com/user-attachments/assets/5c325dde-bac2-4533-85f7-edefc5da1941" />

<br>

### 🅱️ Waybar-1 — Pill Style *(Alternate)*

<div align="center">

<img width="1920" height="78" src="https://github.com/user-attachments/assets/05fd9edb-4d6b-4f5b-8fd4-56a004b1c428" alt="Waybar-1 — Pill-style status bar with neon rounded borders showing workspaces, clock, CPU, temperature, wifi, volume and battery">

*Neon pill borders · Rounded segments · Compact & clean*

</div>

> ⚠️ **Run this after completing Option A or Option B above.** This replaces the default Waybar config.

```bash
# 1. Create a safe backup of your current waybar config with a random suffix
[ -d ~/.config/waybar ] && mv ~/.config/waybar ~/.config/waybar-$(head /dev/urandom | tr -dc a-z0-9 | head -c 4)

# 2. Create the target directory
mkdir -p ~/.config/waybar

# 3. Copy Waybar-1 files from the theme EXTRA folder
cp -r ~/.config/omarchy/current/theme/EXTRA/waybar-1/* ~/.config/waybar/

# 4. Make all scripts executable
chmod +x ~/.config/waybar/scripts/*

# 5. Restart Waybar to apply changes
killall waybar && waybar &
```

> 💡 **Tip:** Your backup is saved as `~/.config/waybar-XXXX` (4-char random suffix). To restore it, just rename it back to `~/.config/waybar`.

| Widget | Description |
|:---|:---|
| `1 2 3 4` | Workspace switcher with neon pill borders |
| `Omarchy OS` | Active window title |
| `🕐 06:59 PM` | Clock — center-aligned |
| `⊞ 2% 🔄 30%` | CPU & RAM usage |
| `☀️ 23°F` | Temperature sensor |
| `📶` | Network / WiFi status |
| `🔊 90%` | Volume control |
| `⚡ 100%` | Battery indicator |

<br>

---

## ⚙️ Configuration

### 🌤️ Weather Widget — Set Your City

The weather widget displays **New York** by default. Here's how to change it:

**Step 1** — Open the weather script:
```bash
nano ~/.config/waybar/scripts/weather.py
```

**Step 2** — Find the `CITY` variable and update it:
```python
# ── Configuration ─────────────────────────────
CITY = "Tokyo"   # ← Replace with your city name
```

**Step 3** — Save and exit:
```
Ctrl + O  →  Enter    (Save)
Ctrl + X              (Exit)
```

**Step 4** — Restart Waybar to apply:
```bash
killall waybar; waybar &
```

<br>

---

## 🔒 Hyprlock — Custom Lock Screen

<div align="center">

<img width="1311" height="737" alt="Hyprlock Preview" src="https://github.com/user-attachments/assets/86b69c94-6096-411f-a41e-4704c238f394" />

*Glassmorphism lock screen with live clock, random quotes, and media controls*

</div>

<br>

> ⚠️ **Run this after completing Option A or Option B above.**

<br>

### 📦 Setup Commands

```bash
# 1. Install Playerctl (required for media key support)
sudo pacman -S --needed playerctl

# 2. Fix Spotify media controls (only needed for Flatpak version)
if command -v flatpak &> /dev/null; then
    flatpak override --user \
      --talk-name=org.mpris.MediaPlayer2.spotify \
      com.spotify.Client
fi

# 3. Copy lock screen config files to Hyprland directory
cp -r \
  ~/.config/omarchy/current/theme/scripts \
  ~/.config/omarchy/current/theme/quotes.txt \
  ~/.config/omarchy/current/theme/hyprlock.conf \
  ~/.config/hypr/

# 4. Make scripts executable
chmod +x ~/.config/hypr/scripts/*
```

<br>

### 🖼️ Customizing the Lock Screen

You can swap the **background wallpaper** and **profile picture** directly in the config:

```bash
nano ~/.config/hypr/hyprlock.conf
```

Look for these two sections and update the `path =` lines:

```ini
# ── Background Wallpaper ──────────────────────────────────────
background {
    monitor =
    path = /home/YOUR_USER/Pictures/your-wallpaper.jpg   # ← .jpg or .png

    # Blur settings (0 = sharp, higher = more blur)
    blur_passes = 0    # try 3 for a soft glass effect
    blur_size   = 7    # strength of the blur kernel
}

# ── Profile Picture ───────────────────────────────────────────
image {
    monitor =
    path = /home/YOUR_USER/Pictures/your-avatar.png      # ← .jpg or .png
    size = 150
}
```

> **Blur Presets:**
> | `blur_passes` | Effect |
> |:---:|:---|
> | `0` | Sharp — no blur at all |
> | `2` | Subtle — light frost |
> | `3` | Standard — soft glass |
> | `5+` | Heavy — dreamy glow |

<br>

---

## 🎨 Color Palette

<div align="center">

| Name | Hex | Preview |
|:---|:---|:---:|
| Background | `#1a1b2e` | ![](https://placehold.co/60x20/1a1b2e/1a1b2e) |
| Deep Indigo | `#565f89` | ![](https://placehold.co/60x20/565f89/565f89) |
| Electric Blue | `#7aa2f7` | ![](https://placehold.co/60x20/7aa2f7/7aa2f7) |
| Magenta | `#bb9af7` | ![](https://placehold.co/60x20/bb9af7/bb9af7) |
| Copper-Orange | `#c87941` | ![](https://placehold.co/60x20/c87941/c87941) |
| Foreground | `#c0caf5` | ![](https://placehold.co/60x20/c0caf5/c0caf5) |

</div>

<br>

---

## 🖼️ Wallpaper Collection

<div align="center">

> All wallpapers are included with the theme and optimized for dark desktop aesthetics.

<br>

### 🌙 Featured — Cats at Moonrise

<img src="https://github.com/user-attachments/assets/0d5fdda4-00e9-4478-a342-7dc5f7bb214d" width="100%" alt="Cats at Moonrise — Lofi Ghibli aesthetic, five cats seated before a copper sunset and full moon">

*Five cats perched before a copper sunset — the spirit of Copper Night in one frame.*

<br>

## 🖼️ Full Collection

| | |
|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/b15da239-27ee-4555-b2d9-24f8f8f15602" width="100%"> | <img src="https://github.com/user-attachments/assets/55cc1ac0-f377-4fb0-9eb9-0da644e1d9d4" width="100%"> |
| ⚔️ **The Last Swordsman** · *Dark Fantasy* | 👺 **Girl & Hannya** · *Monochrome Yokai* |
| <img src="https://github.com/user-attachments/assets/34e74655-7dd6-4344-b53b-31707e25a4f9" width="100%"> | <img src="https://github.com/user-attachments/assets/ab07a513-d0d3-4daa-9501-ec87862752c1" width="100%"> |
| 🪶 **Itachi & The Crows** · *Akatsuki* | 🏯 **Mountain Castle** · *Pixel Art* |

---

## 📊 Catalog & Specs

| Wallpaper | Style | Resolution |
| :--- | :--- | :---: |
| 🐱 **Cats at Moonrise** | Lofi · Ghibli | 3840 × 2160 |
| 🏯 **Mountain Castle** | Pixel Art | 5120 × 2880 |
| ⚔️ **The Last Swordsman** | Dark Fantasy | 3840 × 2160 |
| 👺 **Girl & Hannya** | Monochrome · Yokai | 3840 × 2160 |
| 🪶 **Itachi & The Crows** | Naruto · Akatsuki | 3840 × 2160 |


</div>


<br>

---

## 🤝 Contributing

Got ideas? Found a bug? Contributions are warmly welcome!

1. **Fork** this repository
2. **Create** a feature branch: `git checkout -b feat/your-idea`
3. **Commit** your changes: `git commit -m "feat: add your idea"`
4. **Push** and open a **Pull Request**

<br>

---

<div align="center">

Made with 🧡 Omarchy

*If this theme made your desktop beautiful, consider leaving a ⭐ — it means a lot!*

[![GitHub](https://img.shields.io/badge/GitHub-hembramnishant50--glitch-181717?style=for-the-badge&logo=github)](https://github.com/hembramnishant50-glitch)

</div>
