<div align="center">

```
 _____                                             _   _   _           _       _
/  __ \                                           | \ | | (_)         | |     | |
| /  \/   ___    _ __    _ __     ___   _ __      |  \| |  _    __ _  | |__   | |_
| |      / _ \  | '_ \  | '_ \   / _ \ | '__|     | . ` | | |  / _` | | '_ \  | __|
| \__/\ | (_) | | |_) | | |_) | |  __/ | |        | |\  | | | | (_| | | | | | | |_
 \____/  \___/  | .__/  | .__/   \___| |_|        \_| \_/ |_|  \__, | |_| |_|  \__|
                | |     | |                                     __/ |
                |_|     |_|                                    |___/
```

# 🌌 Copper Night

### *An Elegant, Deep Indigo & Glowing Copper Theme for Omarchy Quattro*

> *"Where the deep indigo of Tokyo meets the warm, radiant glow of an ember sunset."*

<br/>

[![Version](https://img.shields.io/badge/Version-2.0.0-fab387?style=for-the-badge&logo=git&logoColor=11111b)](https://github.com/hembramnishant50-glitch/omarchy-coppernight-theme)
[![Omarchy Quattro](https://img.shields.io/badge/Omarchy-Quattro-8aadf4?style=for-the-badge&logo=archlinux&logoColor=11111b)](https://omarchy.org/)
[![Hyprland](https://img.shields.io/badge/Hyprland-Ready-a6da95?style=for-the-badge&logo=hyprland&logoColor=11111b)](https://hyprland.org)
[![License](https://img.shields.io/badge/License-MIT-f5bde6?style=for-the-badge&logo=opensourceinitiative&logoColor=11111b)](LICENSE)
[![Stars](https://img.shields.io/github/stars/hembramnishant50-glitch/omarchy-coppernight-theme?style=for-the-badge&color=c6a0f6&logo=github&logoColor=11111b)](https://github.com/hembramnishant50-glitch/omarchy-coppernight-theme/stargazers)

<br/>

<a href="#-theme-files">
  <img width="100%" alt="Copper Night Hero Preview" src="https://github.com/user-attachments/assets/1123edd2-2feb-484f-ad2f-b2e7cad416d0" style="border-radius: 16px; box-shadow: 0 12px 40px rgba(0,0,0,0.5);" />
</a>

<br/>

[✨ Features](#-features) • [⚡ Installation](#-installation) • [📁 Theme Files](#-theme-files) • [🎨 Color Palette](#-color-palette) • [📁 Theme Structure](#-theme-structure) • [🤝 Contributing](#-contributing)

</div>

---

## ⚡ Installation

Install Copper Night directly from GitHub in one command. Omarchy handles the rest — no manual copying required.

```bash
omarchy-theme-install https://github.com/hembramnishant50-glitch/omarchy-coppernight-theme.git
rm -rf ~/.config/omarchy/themes/coppernight/.git && omarchy theme set coppernight
```

Switch back to Copper Night at any time:

```bash
omarchy theme set coppernight
```

> The theme applies instantly — Hyprland, terminals, GTK apps, and browser styles are all refreshed together.

---

## ✨ Features

<div align="center">

| | **Feature** | **What Makes It Special** |
|:---:|---|---|
| 🌑 | **Deep Indigo Canvas** | An OLED-friendly ` #11111b ` base, carefully tuned for contrast, comfort, and long coding nights. |
| 🌅 | **Copper & Mauve Borders** | Active windows glow in warm Copper ` #fab387 `, while inactive windows rest in soft Mauve ` #c6a0f6 `. |
| 🎨 | **Pastel Harmony** | A cohesive accent suite — Lite Green ` #a6da95 `, Lite Pink ` #f5bde6 `, Lite Blue ` #8aadf4 `, Teal ` #8bd5ca `, and Mauve ` #c6a0f6 ` — balanced for syntax, UI, and highlights. |
| 🪟 | **Hyprland — Rounded & Fluid** | `rounding 16px` with `rounding_power 2.0`, `gaps 6 / 14`, `blur 12 / 3`, `shadow 30`, and Mac-style `popin 85%` animations for buttery-smooth switching. |
| 💻 | **Unified Terminals** | Alacritty, Ghostty, Foot, and Kitty — fully stripped of upstream palettes and reborn in pure Copper Night. |
| ✨ | **Animated Kitty Cursor** | Beam cursor with smooth fade blink and a copper cursor-trail that glides as you type. |
| 🔤 | **Macchiato Text** | All text and syntax tones follow the Catppuccin Macchiato scale on the deep indigo canvas. |
| 🧡 | **Copper Topbar** | Shell bar text and icons glow in Copper ` #fab387 `. |
| 🖼️ | **Icons & Cursor Scripts** | `apply-icons.sh` installs Papirus-Dark with orange folders plus the Bibata-Modern-Amber cursor. |
| 🗂️ | **File Manager Scripts** | `apply-filemanager.sh` paints Nautilus `#11111b` (color only, rest stays default); `remove-gtk.sh` undoes it. |
| 🌐 | **Web — 136+ Userstyles** | YouTube, GitHub, Crunchyroll, CareerWill, Claude, ChatGPT, and more — beautifully themed via `Stylus.json`. |
| 🧩 | **Apps — Fully Themed** | Neovim, VS Code, Helix, btop, CAVA, GTK 3/4, Chromium, Icons, Starship, and Fastfetch — one palette, everywhere. |
| 🎵 | **Discord — Vencord** | A bespoke `vencord.theme.css` that brings Copper Night to your conversations. |

</div>

---

## 📁 Theme Files

<div align="center">

| File | Description |
|------|-------------|
| `colors.toml` | Master palette — the single source of truth for every color in the theme. |
| `hyprland.lua` | Hyprland layout, Mac-style animations, `16px` rounding, blur, and shadows. |
| `gtk.css` | GTK 3/4 styling — fully rounded at `16px` for windows, cards, buttons, and menus. |
| `Stylus.json` | Curated backup of `136+` browser userstyles for Chrome and Firefox. |
| `youtube-coppernight.user.less` | Standalone, finely tuned YouTube theme. |
| `btop.theme` | Diagnostic monitor theme for btop. |
| `neovim.lua` | Neovim colorscheme — Tokyo Night reimagined in Copper Night. |
| `vscode.json` | Visual Studio Code theme linkage. |
| `alacritty.toml` | Alacritty terminal — clean Copper Night palette. |
| `kitty.conf` | Kitty terminal — clean Copper Night palette. |
| `ghostty.conf` | Ghostty terminal — primary Copper Night palette. |
| `foot.ini` | Foot terminal — clean Copper Night palette. |
| `starship.toml` | Starship prompt — minimal, copper-accented. |
| `config.fish` | Fish shell — tailored completions and colors. |
| `helix.toml` | Helix editor — Copper Night syntax and UI. |
| `fastfetch.jsonc` | Fastfetch — system info with themed layout. |
| `cava_theme` | CAVA — audio visualizer tuned to Copper Night. |
| `vencord.theme.css` | Discord Vencord — chat in full Copper Night. |
| `chromium.theme` | Chromium flags for dark-mode harmony. |
| `icons.theme` | Papirus-Dark icon linkage. |
| `shell.toml` | Omarchy shell — copper topbar, popups, menus, and dialogs. |
| `gum_env.lua` | Gum prompt styling for Omarchy menus. |
| `zed.json` | Zed editor theme. |
| `yazi-theme.toml` | Yazi file manager flavor. |
| `filemanager-gtk.css` | Nautilus background color only (`#11111b`), rest stays default. |
| `apply-filemanager.sh` | Applies the file manager background + Yazi flavor. |
| `remove-gtk.sh` | Removes the GTK override, back to default. |
| `apply-icons.sh` | Installs Papirus-Dark (orange folders) + Bibata-Modern-Amber cursor. |
| `remove-icons.sh` | Removes Papirus/Bibata, back to default icons + cursor. |
| `backgrounds/` | Five high-resolution wallpapers, handpicked for the palette. |

</div>

---

## 🎨 Color Palette

<div align="center">

| Swatch | Token | Hex Code | Role & Description |
|:---:|:---|:---:|:---|
| ![#11111b](https://img.shields.io/badge/-%2311111b-11111b?style=flat-square) | **Base / Background** | `#11111b` | The deep indigo canvas — main window and app background. |
| ![#181825](https://img.shields.io/badge/-%23181825-181825?style=flat-square) | **Mantle** | `#181825` | Sidebars, panels, and dropdown containers. |
| ![#313244](https://img.shields.io/badge/-%23313244-313244?style=flat-square) | **Surface0** | `#313244` | Cards, input fields, and inactive borders. |
| ![#fab387](https://img.shields.io/badge/-%23fab387-fab387?style=flat-square) | **Copper — Accent** | `#fab387` | Active borders, focused states, and primary highlights. |
| ![#cad3f5](https://img.shields.io/badge/-%23cad3f5-cad3f5?style=flat-square) | **Foreground / Text** | `#cad3f5` | Standard text and icons — crisp and readable. |
| ![#a6da95](https://img.shields.io/badge/-%23a6da95-a6da95?style=flat-square) | **Lite Green** | `#a6da95` | Success states, strings, and active indicators. |
| ![#f5bde6](https://img.shields.io/badge/-%23f5bde6-f5bde6?style=flat-square) | **Lite Pink** | `#f5bde6` | Special accents, tags, badges, and highlights. |
| ![#8aadf4](https://img.shields.io/badge/-%238aadf4-8aadf4?style=flat-square) | **Lite Blue** | `#8aadf4` | Links, functions, keywords, and info states. |
| ![#c6a0f6](https://img.shields.io/badge/-%23c6a0f6-c6a0f6?style=flat-square) | **Mauve** | `#c6a0f6` | Secondary accent, syntax keywords, and inactive borders. |
| ![#eed49f](https://img.shields.io/badge/-%23eed49f-eed49f?style=flat-square) | **Yellow** | `#eed49f` | Warnings, highlights, and warm accents. |
| ![#8bd5ca](https://img.shields.io/badge/-%238bd5ca-8bd5ca?style=flat-square) | **Teal** | `#8bd5ca` | Operators, links, and cool accents. |
| ![#5b6078](https://img.shields.io/badge/-%235b6078-5b6078?style=flat-square) | **Muted** | `#5b6078` | Comments, line numbers, and disabled states. |
| ![#ed8796](https://img.shields.io/badge/-%23ed8796-ed8796?style=flat-square) | **Red** | `#ed8796` | Warnings, errors, and critical notices. |

</div>

---

## 📁 Theme Structure

```
~/.config/omarchy/themes/coppernight/
├── colors.toml                    # Master palette
├── hyprland.lua                   # Hyprland — 16px rounding, Mac animations
├── gtk.css                        # GTK 3/4 — fully rounded 16px
├── Stylus.json                    # 136+ browser userstyles
├── youtube-coppernight.user.less  # YouTube theme
├── btop.theme                     # btop monitor
├── neovim.lua                     # Neovim — Tokyo Night / Copper
├── vscode.json                    # VS Code linkage
├── chromium.theme                 # Chromium dark flags
├── icons.theme                    # Icon theme linkage
├── alacritty.toml                 # Terminal
├── kitty.conf                     # Terminal — animated beam cursor + trail
├── ghostty.conf                   # Terminal
├── foot.ini                       # Terminal
├── shell.toml                     # Omarchy shell — copper topbar
├── gum_env.lua                    # Gum prompt styling
├── zed.json                       # Zed editor
├── yazi-theme.toml                # Yazi flavor
├── filemanager-gtk.css            # Nautilus background color only
├── apply-filemanager.sh           # Apply file manager background
├── remove-gtk.sh                  # Undo GTK override
├── apply-icons.sh                 # Papirus-Dark + Bibata-Amber setup
├── remove-icons.sh                # Undo icons + cursor setup
├── starship.toml                  # Prompt
├── config.fish                    # Fish shell
├── helix.toml                     # Helix editor
├── fastfetch.jsonc                # System info
├── cava_theme                     # Audio visualizer
├── vencord.theme.css              # Discord Vencord
├── backgrounds/                   # 5 wallpapers
└── README.md                      # This documentation
```

---

## 🤝 Contributing

> Love Omarchy? Love Copper Night? Your contributions make it shine brighter ✨

We warmly welcome **bug reports**, **new website userstyles**, **wallpapers**, and **UI polish** — every thoughtful idea counts.

### How to Contribute

1. 🍴 **Fork** this repository.
2. 🌿 Create your branch — `git checkout -b feature/my-awesome-tweak`
3. 💾 Commit your work — `git commit -m 'feat: add my awesome tweak'`
4. 🚀 Push your branch — `git push origin feature/my-awesome-tweak`
5. 🔃 Open a **Pull Request** — please include a short description and a preview image if possible.

Found a bug? Open an [Issue](https://github.com/hembramnishant50-glitch/omarchy-coppernight-theme/issues) — we reply quickly and kindly 💬

---

<div align="center">

### 💖 Crafted with Passion by [Nishant](https://github.com/hembramnishant50-glitch) — with Love for [Omarchy](https://omarchy.org/) 🥰

*“Night falls on Tokyo, lit by an eternal copper spark — made for the Omarchy family, by the Omarchy family.”*  
*Thank you to the Omarchy community for the inspiration, the tools, and the endless rice love 🌸*

<br/>

[![Stars](https://img.shields.io/github/stars/hembramnishant50-glitch/omarchy-coppernight-theme?style=social)](https://github.com/hembramnishant50-glitch/omarchy-coppernight-theme)

</div>
