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
[![Omarchy Quattro](https://img.shields.io/badge/Omarchy-Quattro-89b4fa?style=for-the-badge&logo=archlinux&logoColor=11111b)](https://omarchy.org/)
[![Hyprland](https://img.shields.io/badge/Hyprland-Ready-a6e3a1?style=for-the-badge&logo=hyprland&logoColor=11111b)](https://hyprland.org)
[![License](https://img.shields.io/badge/License-MIT-f5c2e7?style=for-the-badge&logo=opensourceinitiative&logoColor=11111b)](LICENSE)
[![Stars](https://img.shields.io/github/stars/hembramnishant50-glitch/omarchy-coppernight-theme?style=for-the-badge&color=cba6f7&logo=github&logoColor=11111b)](https://github.com/hembramnishant50-glitch/omarchy-coppernight-theme/stargazers)

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
rm -rf ~/.config/omarchy/themes/coppernight/.git && omarchy theme set macchiato-core
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
| 🌅 | **Copper & Mauve Borders** | Active windows glow in warm Copper ` #fab387 `, while inactive windows rest in soft Mauve ` #cba6f7 `. |
| 🎨 | **Pastel Harmony** | A cohesive accent suite — Lite Green ` #a6e3a1 `, Lite Pink ` #f5c2e7 `, Sky ` #89dceb `, and Mauve ` #cba6f7 ` — balanced for syntax, UI, and highlights. |
| 🪟 | **Hyprland — Rounded & Fluid** | `rounding 16px` with `rounding_power 2.0`, `gaps 6 / 14`, `blur 12 / 3`, `shadow 30`, and Mac-style `popin 85%` animations for buttery-smooth switching. |
| 💻 | **Unified Terminals** | Alacritty, Ghostty, Foot, and Kitty — fully stripped of upstream palettes and reborn in pure Copper Night. |
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
| `ghostty_override.conf` | Ghostty override — refined padding and cursor tuning. |
| `foot.ini` | Foot terminal — clean Copper Night palette. |
| `starship.toml` | Starship prompt — minimal, copper-accented. |
| `config.fish` | Fish shell — tailored completions and colors. |
| `helix.toml` | Helix editor — Copper Night syntax and UI. |
| `fastfetch.jsonc` | Fastfetch — system info with themed layout. |
| `cava_theme` | CAVA — audio visualizer tuned to Copper Night. |
| `vencord.theme.css` | Discord Vencord — chat in full Copper Night. |
| `chromium.theme` | Chromium flags for dark-mode harmony. |
| `icons.theme` | Papirus-Dark icon linkage. |
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
| ![#cdd6f4](https://img.shields.io/badge/-%23cdd6f4-cdd6f4?style=flat-square) | **Foreground / Text** | `#cdd6f4` | Standard text and icons — crisp and readable. |
| ![#a6e3a1](https://img.shields.io/badge/-%23a6e3a1-a6e3a1?style=flat-square) | **Lite Green** | `#a6e3a1` | Success states, strings, and active indicators. |
| ![#f5c2e7](https://img.shields.io/badge/-%23f5c2e7-f5c2e7?style=flat-square) | **Lite Pink** | `#f5c2e7` | Special accents, tags, badges, and highlights. |
| ![#89b4fa](https://img.shields.io/badge/-%2389b4fa-89b4fa?style=flat-square) | **Lite Blue** | `#89b4fa` | Links, functions, keywords, and info states. |
| ![#cba6f7](https://img.shields.io/badge/-%23cba6f7-cba6f7?style=flat-square) | **Mauve** | `#cba6f7` | Secondary accent, syntax keywords, and inactive borders. |
| ![#f38ba8](https://img.shields.io/badge/-%23f38ba8-f38ba8?style=flat-square) | **Red** | `#f38ba8` | Warnings, errors, and critical notices. |

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
├── kitty.conf                     # Terminal
├── ghostty.conf                   # Terminal
├── ghostty_override.conf          # Terminal — override tuning
├── foot.ini                       # Terminal
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
