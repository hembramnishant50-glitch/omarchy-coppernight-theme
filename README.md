<div align="center">

```
    ╭─────────────────────────────────╮
    │   C O P P E R   ·   N I G H T   │
    ╰─────────────────────────────────╯
```

# 🌌 銅夜 — Copper Night

### *An Elegant, Deep Indigo & Glowing Copper Theme for Omarchy 4*

*どうや — "Dōya"*

> *"Where the deep indigo of a Tokyo night meets the warm, radiant glow of a distant ember —*
> *侘寂 (wabi-sabi) in every pixel, 静けさ (silence) in every shadow."*

<br/>

[![Version](https://img.shields.io/badge/Version-3.0.0-fab387?style=for-the-badge&logo=git&logoColor=11111b)](https://github.com/hembramnishant50-glitch/omarchy-coppernight-theme)
[![Omarchy](https://img.shields.io/badge/Omarchy-4-8aadf4?style=for-the-badge&logo=archlinux&logoColor=11111b)](https://omarchy.org/)
[![Hyprland](https://img.shields.io/badge/Hyprland-Ready-a6da95?style=for-the-badge&logo=hyprland&logoColor=11111b)](https://hyprland.org)
[![License](https://img.shields.io/badge/License-MIT-f5bde6?style=for-the-badge&logo=opensourceinitiative&logoColor=11111b)](LICENSE)
[![Stars](https://img.shields.io/github/stars/hembramnishant50-glitch/omarchy-coppernight-theme?style=for-the-badge&color=c6a0f6&logo=github&logoColor=11111b)](https://github.com/hembramnishant50-glitch/omarchy-coppernight-theme/stargazers)

<br/>

<img width="100%" alt="Copper Night Preview" src="https://github.com/user-attachments/assets/1123edd2-2feb-484f-ad2f-b2e7cad416d0" style="border-radius: 16px; box-shadow: 0 12px 40px rgba(0,0,0,0.5);" />

<br/>

⛩️ [美学 Philosophy](#-美学--the-design-philosophy) • ⚡ [Installation](#-installation) • 📁 [File Reference](#-file-reference) • 🚀 [Fastfetch](#-fastfetch) • 🧹 [Uninstall](#-uninstall) • 🎨 [Color Palette](#-色-color-palette) • 🤝 [Contributing](#-contributing)

</div>

---

## 🏮 美学 — The Design Philosophy

Copper Night is built from three decisions, each one about restraint:

| Concept | Meaning | How it shows up in the theme |
|:---:|:---|:---|
| **藍** *ai* — indigo | Indigo is *dyed*, never printed. Its depth comes from layering, not from one flat coat. | Four separate blacks — `#11111b` canvas, `#0b0b12` and `#060609` for wells, `#1e1e2e` for raised surfaces. You should feel cloth, not slabs. |
| **鈍** *don* — blunt, unsharpened | A surface that has been handled a thousand times loses its glare. | Soft `10–16px` corners, dimmed `#5b6078` for comments and line numbers, no pure-white anywhere. Nothing snaps. |
| **銅** *dō* — copper | Metal that has been held for a century, not a fresh LED. | Exactly one warm hue — `#fab387` — and it only appears where your attention already belongs: focus rings, the active border, the topbar. |

Indigo for the ninety-nine percent of the night that is empty; copper for the one percent that isn't. The whole theme is arranged so the only warm pixel on your screen is the one you were looking for.

---

## ⚡ Installation

### One command

Installs the theme, activates it, then applies the file manager background and the
Papirus-Dark icons with orange folders and a matching peach cursor:

```bash
omarchy-theme-install https://github.com/hembramnishant50-glitch/omarchy-coppernight-theme.git && rm -rf ~/.config/omarchy/themes/coppernight/.git && omarchy theme set coppernight && cd ~/.config/omarchy/themes/coppernight && ./apply-filemanager.sh && ./apply-icons.sh
```

> Run it in a real terminal — the icon/cursor step needs your sudo password.

> **注意 (chūi) — heads up:** re-running the installer wipes and replaces the theme folder.
> `omarchy-theme-install` deletes `~/.config/omarchy/themes/coppernight` *before* it clones, so
> if the clone fails you are left with nothing. Keep any local edits backed up elsewhere.

---

## 📁 File Reference

<details>
<summary><b>🖥️ Desktop & Shell</b></summary>

| File | Description |
|---|---|
| `colors.toml` | **Master palette** — single source of truth for every color. |
| `hyprland.lua` | Layout, Mac-style animations, `16px` rounding, blur, shadows. |
| `shell.toml` | Omarchy shell — copper topbar, popups, menus, dialogs. |
| `gtk.css` | GTK 3/4 — fully rounded `16px` windows, cards, buttons, menus. |
| `gum_env.lua` | Gum prompt styling for Omarchy menus. |
| `yazi-theme.toml` | Yazi file manager flavor. |
| `filemanager-gtk.css` | Nautilus background color only (`#11111b`), rest stays default. |
| `hyprland-preview-share-picker.css` | Share-picker plugin styling. |
| `keyboard.rgb` | Keyboard RGB accent value. |

</details>

<details>
<summary><b>💻 Terminals & Shells</b></summary>

| File | Description |
|---|---|
| `alacritty.toml` | Alacritty — clean Copper Night palette. |
| `ghostty.conf` | Ghostty — primary Copper Night palette. |
| `foot.ini` | Foot — clean Copper Night palette. |
| `kitty.conf` | Kitty — palette + animated beam cursor and copper trail. |
| `tmux-coppernight.conf` | tmux status bar and pane theming. |
| `config.fish` | Fish shell — completions and colors. |
| `zshrc` | Zsh configuration with Copper Night touches. |
| `starship.toml` | Starship prompt — minimal, copper-accented. |
| `terminal-colors.sh` | Bash/Zsh color helpers (fzf, ls, grep). |
| `terminal-colors.fish` | Fish equivalent of the color helpers. |

</details>

<details>
<summary><b>📝 Editors & IDEs</b></summary>

| File | Description |
|---|---|
| `neovim.lua` | Neovim colorscheme — Tokyo Night reimagined in Copper Night. |
| `helix.toml` | Helix — syntax and UI. |
| `zed.json` | Zed editor theme. |
| `vscode.json` | VS Code settings — drops in the theme, icon theme and editor feel. |
| `vscode-theme.json` | The Copper Night color theme — 664 tokens, `#11111b` base, `#fab387` accent. |
| `coppernight.vim` | Vim colorscheme. |
| `coppernight-theme.el` | Emacs theme. |
| `Coppernight.tmTheme` | TextMate/Sublime Text scheme. |
| `sublime-coppernight.sublime-color-scheme` | Sublime Text color scheme. |
| `obsidian.css` | Obsidian snippet styling. |

</details>

<details>
<summary><b>🛠️ CLI, TUI & AI Tools</b></summary>

| File | Description |
|---|---|
| `btop.theme` | btop system monitor. |
| `cava_theme` | CAVA audio visualizer. |
| `lazygit-coppernight.yml` | lazygit TUI theme. |
| `delta-coppernight.gitconfig` | delta git diff viewer. |
| `fastfetch.jsonc` | Fastfetch layout, reading the logo from this folder. |
| `fastfetch/` | The same layout for copying to `~/.config/fastfetch/` — logo path rewritten. |
| `claude.json` | Claude Code theme. |
| `coppernight-opencode.json` | opencode theme. |
| `pi.json` | pi coding-agent theme. |
| `t3code.json` | t3code theme. |
| `hermes.yaml` | Hermes theme. |

</details>

<details>
<summary><b>🌐 Web, Browser & Apps</b></summary>

| File | Description |
|---|---|
| `Stylus.json` | Curated `136+` browser userstyles for Chrome and Firefox. |
| `youtube-coppernight.user.less` | Standalone finely tuned YouTube theme. |
| `firefox-userChrome.css` | Firefox `userChrome.css` for deep dark chrome. |
| `chromium.theme` | Chromium flags for dark-mode harmony. |
| `vencord.theme.css` | Discord (Vencord QuickCSS) — official Catppuccin Mocha + peach, all canvas surfaces pinned to `#11111b`. |

</details>

<details>
<summary><b>🎨 Assets & Scripts</b></summary>

| File | Description |
|---|---|
| `icons.theme` | Icon theme linkage (Papirus-Dark). |
| `1.png` | Fastfetch logo — Catppuccin-style mark in the Copper accent. |
| `fastfetch/` | `config.jsonc` + `1.png`, staged for `~/.config/fastfetch/`. |
| `backgrounds/` | Five handpicked wallpapers. |
| `apply-filemanager.sh` | Applies file manager background + Yazi flavor. |
| `remove-gtk.sh` | Removes the GTK override — back to default. |
| `apply-icons.sh` | Installs Papirus-Dark with orange folders + peach cursor. |
| `remove-icons.sh` | Removes Papirus, papirus-folders-catppuccin-git and the cursor package — back to default. |
| `install-fastfetch.sh` | Copies `fastfetch/` to `~/.config/fastfetch/`, backing up what was there. |
| `remove-fastfetch.sh` | Restores the backups — or `--uninstall` also drops the package. |

</details>

---

## 🚀 Fastfetch

The theme ships a `fastfetch` layout in the Copper palette — Copper keys, blue hardware
and lavender WM/TUI groups, the theme-aware `THM` module, and a themed logo.

**fastfetch only reads a config that lives in its own config dir**, so the files are
copied there rather than symlinked — then the theme folder can move and `fastfetch`
keeps working.

```bash
# install + apply coppernight fastfetch to ~/.config/fastfetch/
~/.config/omarchy/themes/coppernight/install-fastfetch.sh
# or, by hand:
sudo pacman -S --needed --noconfirm fastfetch && mkdir -p ~/.config/fastfetch && cp ~/.config/omarchy/themes/coppernight/fastfetch/* ~/.config/fastfetch/
```

Then:

```bash
fastfetch
```

> **まだ (mada) — not yet here.** Run `./install-fastfetch.sh` and paste your terminal
> output into a PR — a real render is more useful than a mock-up.

<details>
<summary><b>How it behaves</b></summary>

- Any existing `~/.config/fastfetch/config.jsonc` or `1.png` is copied to
  `*.pre-coppernight` **once** — a second run won't overwrite the backup with the
  already-replaced file.
- `1.png` is only copied when the config actually points at a local logo source.
- `./remove-fastfetch.sh` restores those backups, or deletes the files if there are none
  (fastfetch then falls back to its built-in default). The directory is only removed if
  it ends up empty, so a hand-written `fastfetch.jsonc` of your own survives.

</details>

To undo it:

```bash
# config only — restore backups
~/.config/omarchy/themes/coppernight/remove-fastfetch.sh

# config + pacman -R
~/.config/omarchy/themes/coppernight/remove-fastfetch.sh --uninstall
```

---

## 🧹 Uninstall

### 1. Revert the optional extras

```bash
cd ~/.config/omarchy/themes/coppernight

./remove-gtk.sh        # file manager back to default
./remove-icons.sh      # icons + cursor back to default (asks before uninstalling packages)
./remove-fastfetch.sh  # fastfetch config back to default
```

### 2. By hand

> **One transaction, not two.** `papirus-folders-catppuccin-git` *depends on*
> `papirus-icon-theme`, so removing them separately fails with
> `removing papirus-icon-theme breaks dependency … required by papirus-folders-catppuccin-git`.

```bash
sudo pacman -Rns papirus-folders-catppuccin-git papirus-icon-theme
sudo pacman -Rns catppuccin-cursors-macchiato   # optional: the peach cursor
```

### 3. Remove the theme itself

```bash
omarchy theme set <some-other-theme>   # switch away first
omarchy theme remove coppernight       # then delete it
```

Or just delete the directory:

```bash
rm -rf ~/.config/omarchy/themes/coppernight
```

---

## 🎨 色 Color Palette

<div align="center">

### 基調 — Core Tones

| Swatch | Token | Hex | 和名 *(mood)* | Role |
|:---:|:---|:---:|:---|:---|
| ![#11111b](https://img.shields.io/badge/-%2311111b-11111b?style=flat-square) | **background** | `#11111b` | 藍夜 *ai-yoru* — "indigo night" | Deep indigo canvas — main app background. |
| ![#0b0b12](https://img.shields.io/badge/-%230b0b12-0b0b12?style=flat-square) | **dark_background** | `#0b0b12` | 漆黒 *shikkoku* — "lacquer black" | Deeper wells, terminal backgrounds. |
| ![#060609](https://img.shields.io/badge/-%23060609-060609?style=flat-square) | **darker_background** | `#060609` | 玄 *gen* — "profound black" | Deepest wells, OLED black. |
| ![#1e1e2e](https://img.shields.io/badge/-%231e1e2e-1e1e2e?style=flat-square) | **lighter_background** | `#1e1e2e` | 宵闇 *yoiyami* — "dusk haze" | Raised surfaces. |
| ![#313244](https://img.shields.io/badge/-%23313244-313244?style=flat-square) | **selection** | `#313244` | 鈍色 *nibiiro* — "muted grey" | Selection, cards, inactive borders. |
| ![#cad3f5](https://img.shields.io/badge/-%23cad3f5-cad3f5?style=flat-square) | **foreground** | `#cad3f5` | 月白 *tsukishiro* — "moon white" | Primary text and icons. |
| ![#b8c0e0](https://img.shields.io/badge/-%23b8c0e0-b8c0e0?style=flat-square) | **light_foreground** | `#b8c0e0` | 白藤 *shirafuji* — "pale wisteria" | Bright secondary text. |
| ![#6e738d](https://img.shields.io/badge/-%236e738d-6e738d?style=flat-square) | **dark_foreground** | `#6e738d` | 鼠色 *nezumiiro* — "mouse grey" | Dimmed text. |
| ![#5b6078](https://img.shields.io/badge/-%235b6078-5b6078?style=flat-square) | **muted** | `#5b6078` | 消炭色 *keshizumiiro* — "spent-charcoal" | Comments, line numbers, disabled states. |

### 彩り — Accents

| Swatch | Token | Hex | 和名 *(mood)* | Role |
|:---:|:---|:---:|:---|:---|
| ![#fab387](https://img.shields.io/badge/-%23fab387-fab387?style=flat-square) | **accent / orange** | `#fab387` | 銅色 *akagane-iro* — "copper" | **The lantern.** Active borders, focus, highlights, topbar. |
| ![#a6da95](https://img.shields.io/badge/-%23a6da95-a6da95?style=flat-square) | **green** | `#a6da95` | 若緑 *wakamidori* — "young green" | Success, strings, active indicators. |
| ![#eed49f](https://img.shields.io/badge/-%23eed49f-eed49f?style=flat-square) | **yellow** | `#eed49f` | 生成り *kinari* — "raw silk" | Warnings, warm accents. |
| ![#8bd5ca](https://img.shields.io/badge/-%238bd5ca-8bd5ca?style=flat-square) | **cyan** | `#8bd5ca` | 青緑 *aomidori* — "teal" | Operators, links, cool accents. |
| ![#8aadf4](https://img.shields.io/badge/-%238aadf4-8aadf4?style=flat-square) | **blue** | `#8aadf4` | 縹色 *hanadairo* — "pale indigo-blue" | Functions, keywords, info states. |
| ![#c6a0f6](https://img.shields.io/badge/-%23c6a0f6-c6a0f6?style=flat-square) | **magenta** | `#c6a0f6` | 藤紫 *fujimurasaki* — "wisteria purple" | Secondary accent, inactive borders. |
| ![#f5bde6](https://img.shields.io/badge/-%23f5bde6-f5bde6?style=flat-square) | **pink** | `#f5bde6` | 桜色 *sakura-iro* — "cherry blossom" | Tags, badges, special highlights. |
| ![#ed8796](https://img.shields.io/badge/-%23ed8796-ed8796?style=flat-square) | **red / cursor** | `#ed8796` | 紅 *kurenai* — "crimson" | Errors, critical notices, terminal cursor. |
| ![#7b5b55](https://img.shields.io/badge/-%237b5b55-7b5b55?style=flat-square) | **brown** | `#7b5b55` | 焦茶 *kogecha* — "scorched tea" | Warm muted brown. |

</div>

> `colors.toml` is the single source of truth. Change `accent` there and the whole theme follows.

---

## 🤝 Contributing

> Love Omarchy? Love Copper Night? Your contributions make it shine brighter ✨

We warmly welcome **bug reports**, **new website userstyles**, **wallpapers**, and **UI polish** — every thoughtful idea counts. 一期一会 *(ichi-go ichi-e)* — every contribution, however small, is treasured.

### How to Contribute

1. 🍴 **Fork** this repository.
2. 🌿 Create your branch — `git checkout -b feature/my-awesome-tweak`
3. 💾 Commit your work — `git commit -m 'feat: add my awesome tweak'`
4. 🚀 Push your branch — `git push origin feature/my-awesome-tweak`
5. 🔃 Open a **Pull Request** — include a short description and a preview image if possible.

### Adding a new app

1. Copy the existing pattern — most app themes are a single JSON/TOML/CSS file.
2. Use the hex values from `colors.toml` so everything stays consistent.
3. Add a row to [📁 File Reference](#-file-reference).

Found a bug? Open an [Issue](https://github.com/hembramnishant50-glitch/omarchy-coppernight-theme/issues) — we reply quickly and kindly 💬

---

<div align="center">

⛩️ 🌸 ⛩️

### 💖 Crafted with Passion by [Nishant](https://github.com/hembramnishant50-glitch) — with Love for [Omarchy](https://omarchy.org/) 🥰

*"夜は東京に落ち、永遠の銅の輝きに照らされる —*
*Night falls on Tokyo, lit by an eternal copper spark —*
*made for the Omarchy family, by the Omarchy family."*

Thank you to the Omarchy community for the inspiration, the tools, and the endless rice love 🌸

<br/>

[![Stars](https://img.shields.io/github/stars/hembramnishant50-glitch/omarchy-coppernight-theme?style=social)](https://github.com/hembramnishant50-glitch/omarchy-coppernight-theme)

</div>
