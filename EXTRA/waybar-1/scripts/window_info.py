#!/usr/bin/env python3
import subprocess
import json
import re
import time

# --- CONFIGURATION ---
TITLE_LIMIT = 25 
# Animation frames for the music visualizer (Nerd Font icons)
ANIMATION_FRAMES = ["󰎊", "󰎋", "󰎌"]

def get_active_window():
    """Fetches the title and class of the currently focused window via hyprctl."""
    try:
        out = subprocess.check_output(["hyprctl", "activewindow", "-j"]).decode("utf-8")
        win_data = json.loads(out)
        return str(win_data.get("title", "")), str(win_data.get("class", ""))
    except Exception:
        return "Desktop", ""

def get_music_animation():
    """Returns a cycling animation frame if music is playing on supported apps."""
    try:
        # Check playback status
        status = subprocess.check_output(["playerctl", "status"], stderr=subprocess.DEVNULL).decode("utf-8").strip()
        # Get the name of the current player
        player = subprocess.check_output(["playerctl", "-f", "{{playerName}}", "metadata"], stderr=subprocess.DEVNULL).decode("utf-8").strip().lower()
        
        # Supported apps for the animation
        music_apps = ["spotify", "applemusic", "youtubemusic", "gaana", "jiosaavn", "chromium", "firefox", "brave"]
        
        if status == "Playing" and any(app in player for app in music_apps):
            # Cycle frames based on system time (1-second updates)
            frame_index = int(time.time()) % len(ANIMATION_FRAMES)
            return f"{ANIMATION_FRAMES[frame_index]} "
        return ""
    except:
        return ""

def truncate(text, limit):
    """Limits text length to keep the bar clean."""
    if not text: return ""
    return text if len(text) <= limit else text[:limit-3] + "..."

def get_brand_info(title, app_class):
    """Returns icon, label, and color based on the window details."""
    brands = {

        # --- Development & Version Control ---
        "vscode": ("󰨞", "VS Code", "#89B4FA"),       # Lite Blue
        "code": ("󰨞", "VS Code", "#89B4FA"),         # Lite Blue
        "neovim": ("", "Neovim", "#A6E3A1"),       # Lite Green
        "terminal": ("", "Terminal", "#9399B2"),   # Soft Muted Blue
        "github": ("󰊤", "GitHub", "#B4BEFE"),       # Lavender
        "git": ("󰊢", "Git", "#F38BA8"),             # Lite Coral
        "docker": ("", "Docker", "#74C7EC"),       # Lite Sky Blue
        "postman": ("󱓎", "Postman", "#FAB387"),     # Lite Peach
        "bitbucket": ("󰊭", "Bitbucket", "#89B4FA"),  # Lite Blue
        "alacritty": ("", "Alacritty", "#F9E2AF"),  # Lite Amber

        # --- Terminal Emulators & Shells ---
        "alacritty": ("", "Alacritty", "#F9E2AF"),
        "ghostty": ("󰊠", "Ghostty", "#D9E0EE"),      # Soft White
        "kitty": ("󰄛", "Kitty", "#EBCB8B"),         # Lite Sand
        "foot": ("󰞷", "Foot", "#89DCEB"),           # Lite Cyan
        "wezterm": ("󰞷", "WezTerm", "#94E2D5"),      # Lite Teal
        "konsole": ("󰞷", "Konsole", "#89B4FA"),      # Lite Blue
        "gnome-terminal": ("", "GNOME Terminal", "#6E6C7E"),
        "xfce4-terminal": ("󰞷", "XFCE Terminal", "#9399B2"),
        "st": ("", "Simple Terminal", "#BAC2DE"),

        # --- Linux Distributions & Kernel ---
        "tux": ("", "Kernel", "#F9E2AF"),          # Lite Yellow
        "arch": ("", "Arch Linux", "#89DCEB"),     # Lite Cyan
        "nixos": ("", "NixOS", "#B4BEFE"),         # Lite Lavender
        "ubuntu": ("", "Ubuntu", "#F8BD96"),       # Lite Orange
        "fedora": ("", "Fedora", "#89B4FA"),       # Lite Blue
        "debian": ("", "Debian", "#F28FAD"),       # Lite Rose
        "gentoo": ("", "Gentoo", "#CBA6F7"),       # Lite Mauve
        
        "org.gnome.nautilus": ("󰉋", "Files", "#89B4FA"),
        "org.gnome.console": ("󰞷", "Console", "#6E6C7E"),
        "org.gnome.terminal": ("", "Terminal", "#6E6C7E"),
        "org.gnome.settings": ("󰒓", "Settings", "#A6ADC8"),
        "org.gnome.calculator": ("󰪚", "Calculator", "#A6E3A1"),
        "org.gnome.software": ("󰀻", "Software", "#89B4FA"),
        "org.gnome.systemmonitor": ("󰓅", "System Monitor", "#94E2D5"),
        "org.gnome.baobab": ("󰓅", "Disk Usage", "#F9E2AF"),
        "org.gnome.characters": ("󰬈", "Characters", "#FAB387"),
        "org.gnome.font-viewer": ("󰬈", "Fonts", "#89B4FA"),
        "org.gnome.logs": ("󰘙", "Logs", "#F38BA8"),
        "org.gnome.gedit": ("󰪚", "Calculator", "#A6E3A1"),

        # --- GNOME Ecosystem ---
        "nautilus": ("󰉋", "Files", "#89B4FA"),
        "gnome-terminal": ("", "Terminal", "#6E6C7E"),
        "gnome-console": ("󰞷", "Console", "#6E6C7E"),
        "gnome-settings": ("󰒓", "Settings", "#A6ADC8"),
        "gnome-tweaks": ("󰒓", "Tweaks", "#9399B2"),
        "gnome-software": ("󰀻", "Software", "#89B4FA"),
        "gnome-system-monitor": ("󰓅", "System Monitor", "#94E2D5"),
        "gnome-disks": ("󰋊", "Disks", "#BAC2DE"),
        "gnome-calculator": ("󰪚", "Calculator", "#A6E3A1"),
        "gnome-calendar": ("󰸗", "Calendar", "#F38BA8"),
        "gnome-clocks": ("󰥔", "Clocks", "#CBA6F7"),
        "gnome-weather": ("󰖕", "Weather", "#89DCEB"),
        "gnome-maps": ("󰉙", "Maps", "#A6E3A1"),
        "gnome-text-editor": ("󰷈", "Text Editor", "#FAB387"),
        "gnome-music": ("󰝚", "Music", "#FAB387"),
        "gnome-photos": ("󰄄", "Photos", "#CBA6F7"),
        "gnome-videos": ("󰿎", "Videos", "#89B4FA"),
        "gnome-contacts": ("󰻙", "Contacts", "#FAB387"),
        "gnome-builder": ("󰨞", "Builder", "#89B4FA"),
        "gnome-boxes": ("󰢹", "Boxes", "#CBA6F7"),
        "gnome-logs": ("󰘙", "Logs", "#F38BA8"),
        "epiphany": ("󰖟", "Web (Epiphany)", "#89B4FA"),
        "geary": ("󰇮", "Geary Mail", "#89DCEB"),
        "polari": ("󰒱", "Polari IRC", "#F5C2E7"),
        "fragments": ("󰇚", "Fragments", "#89B4FA"),

        # --- Omarchy & Modern Linux Stack ---
        "omarchy": ("󱓞", "Omarchy Menu", "#F8BD96"),
        "hyprland": ("", "Hyprland", "#94E2D5"),
        "waybar": ("󰇄", "Waybar", "#D9E0EE"),
        "ghostty": ("󰊠", "Ghostty Terminal", "#FFFFFF"),
        "lazygit": ("󰊢", "LazyGit", "#F38BA8"),
        "lazydocker": ("", "LazyDocker", "#89B4FA"),
        "btop": ("󰓅", "Btop Monitor", "#74C7EC"),
        "basecamp": ("󰭹", "Basecamp", "#A6E3A1"),
        "hey": ("󰇮", "HEY Mail", "#F9E2AF"),
        "1password": ("󰢁", "1Password", "#89B4FA"),
        "aether": ("󰨚", "Aether", "#F28FAD"),

        # --- Productivity & Creative ---
        "notion": ("󰇈", "Notion", "#A6ADC8"),
        "obsidian": ("󱓧", "Obsidian", "#CBA6F7"),
        "trello": ("󰓓", "Trello", "#89B4FA"),
        "todoist": ("󰄱", "Todoist", "#F38BA8"),
        "slack": ("󰒱", "Slack", "#CBA6F7"),
        "teams": ("󰊻", "MS Teams", "#B4BEFE"),
        "zoom": ("󰕧", "Zoom", "#89B4FA"),
        "figma": ("󰈔", "Figma", "#F8BD96"),
        "typora": ("󰷈", "Typora", "#9399B2"),
        "libreoffice": ("󰈙", "LibreOffice", "#A6E3A1"),
        "kdenlive": ("", "Kdenlive", "#89DCEB"),
        "inkscape": ("", "Inkscape", "#A6ADC8"),
        "obs": ("󰕧", "OBS Studio", "#6E6C7E"),

        # --- Gaming & Multimedia ---
        "steam": ("󰓓", "Steam", "#B4BEFE"),
        "lutris": ("", "Lutris", "#F8BD96"),
        "heroic": ("󰊗", "Heroic Games", "#D9E0EE"),
        "bottles": ("󰏖", "Bottles", "#89B4FA"),
        "itchio": ("󰪚", "Itch.io", "#F38BA8"),
        "gog": ("󰓓", "GOG Galaxy", "#CBA6F7"),
        "retroarch": ("󰓓", "RetroArch", "#BAC2DE"),
        "minigalaxy": ("󰀻", "Minigalaxy", "#89DCEB"),
        "spotify": ("󰓇", "Spotify", "#A6E3A1"),
        "mangohud": ("󰓅", "MangoHud", "#A6E3A1"),
        "goverlay": ("󰒓", "GOverlay", "#FAB387"),
        "corectrl": ("󰢮", "CoreCtrl", "#F38BA8"),
        "piper": ("󰍽", "Piper Mouse", "#94E2D5"),
        "gamemode": ("󰓅", "Feral GameMode", "#89DCEB"),
        "geforce-now": ("󰊗", "GeForce Now", "#A6E3A1"),
        "xbox-cloud": ("󰓓", "Xbox Cloud", "#A6E3A1"),
        "moonlight": ("󰖟", "Moonlight Stream", "#CBA6F7"),

        # --- Google Ecosystem ---
        "google": ("", "Google", "#89B4FA"),
        "chrome": ("", "Chrome", "#89B4FA"),
        "gmail": ("󰊫", "Gmail", "#F38BA8"),
        "drive": ("󰊭", "Google Drive", "#A6E3A1"),
        "calendar": ("󰸗", "Google Calendar", "#89B4FA"),
        "sheets": ("󰈛", "Google Sheets", "#A6E3A1"),
        "docs": ("󰈙", "Google Docs", "#89B4FA"),
        "slides": ("󰈧", "Google Slides", "#F9E2AF"),
        "meet": ("󰕧", "Google Meet", "#94E2D5"),
        "keep": ("󰠮", "Google Keep", "#F9E2AF"),
        "photos": ("󰄄", "Google Photos", "#89B4FA"),
        "maps": ("󰉙", "Google Maps", "#A6E3A1"),
        "youtube": ("󰗃", "YouTube", "#F38BA8"),

        # --- AI & LLM Tools ---
        "chatgpt": ("󰭻", "ChatGPT (OpenAI)", "#94E2D5"),
        "claude": ("󰚩", "Claude (Anthropic)", "#F8BD96"),
        "gemini": ("󰚩", "Google Gemini", "#B4BEFE"),
        "perplexity": ("󰖟", "Perplexity AI", "#89DCEB"),
        "deepseek": ("󰚩", "DeepSeek", "#89B4FA"),
        "grok": ("󰚩", "Grok (xAI)", "#D9E0EE"),
        "mistral": ("󰚩", "Mistral AI", "#FAB387"),
        "ollama": ("󱓞", "Ollama (Local)", "#BAC2DE"),
        "jan": ("󰚩", "Jan AI", "#94E2D5"),
        "lm-studio": ("󰚩", "LM Studio", "#D9E0EE"),
        "cursor": ("󰨞", "Cursor IDE", "#94E2D5"),
        "copilot": ("󰊤", "GitHub Copilot", "#CBA6F7"),
        "windsurf": ("󰖟", "Windsurf", "#94E2D5"),
        "aider": ("", "Aider CLI", "#F9E2AF"),
        "antigravity": ("󰚩", "Google Antigravity", "#89B4FA"),
        "lovable": ("󱓎", "Lovable AI", "#F5C2E7"),

        # --- Browsers & Privacy Tools ---
        "firefox": ("", "Firefox", "#FAB387"),
        "brave": ("", "Brave", "#F8BD96"),
        "chromium": ("", "Chromium", "#89B4FA"),
        "librewolf": ("󰈹", "LibreWolf", "#74C7EC"),
        "mullvad-browser": ("󰖟", "Mullvad Browser", "#FAB387"),
        "vivaldi": ("󰖟", "Vivaldi", "#F38BA8"),
        "thorium": ("󰖟", "Thorium", "#9399B2"),
        "ladybird": ("󰖟", "Ladybird", "#F5C2E7"),
        "signal": ("󰈰", "Signal Messenger", "#89B4FA"),
        "simplex": ("󰭻", "SimpleX Chat", "#D9E0EE"),
        "session": ("󰚩", "Session", "#A6E3A1"),
        "threema": ("󰒱", "Threema", "#A6E3A1"),
        "element": ("󰒱", "Element (Matrix)", "#94E2D5"),
        "discord-canary": ("󰙯", "Discord Canary", "#B4BEFE"),
        "bitwarden": ("󰞀", "Bitwarden", "#89B4FA"),
        "keepassxc": ("󰞀", "KeePassXC", "#A6E3A1"),
        "1password": ("󰢁", "1Password", "#89B4FA"),
        "proton-mail": ("󰇮", "Proton Mail", "#CBA6F7"),
        "tuta": ("󰇮", "Tuta Mail", "#F38BA8"),
        "duckduckgo": ("󰇥", "DuckDuckGo", "#F8BD96"),
        "veracrypt": ("󰞁", "VeraCrypt", "#89B4FA"),
        "mullvad": ("󰖂", "Mullvad VPN", "#A6E3A1"),
        "proton-vpn": ("󰖂", "Proton VPN", "#CBA6F7"),
        "ivpn": ("󰖂", "IVPN", "#74C7EC"),
        "tailscale": ("󰖂", "Tailscale", "#B4BEFE"),
        "dropbox": ("󰇖", "Dropbox", "#89B4FA"),

    }

    low_title = title.lower()
    low_class = app_class.lower()

    # Browser Detection: Highlight website, hide browser name
    browsers = ["chromium", "firefox", "brave", "chrome"]
    is_browser = any(b in low_class for b in browsers)

    if is_browser:
        clean_title = re.sub(r' - (Chromium|Firefox|Brave|Google Chrome)$', '', title, flags=re.I)
        for key, (w_icon, w_name, w_color) in brands.items():
            if key in low_title and key not in browsers:
                if key == "youtube":
                    clean_title = re.sub(r' - YouTube$', '', clean_title, flags=re.I)
                return w_icon, truncate(clean_title, TITLE_LIMIT), w_color
        return "󰖟", truncate(clean_title, TITLE_LIMIT), "#4285F4"

    for key, (icon, name, color) in brands.items():
        if key in low_class or key in low_title:
            return icon, name, color

    fallback_name = app_class.split('.')[-1].capitalize() if app_class else "Desktop"
    return "󰍹", truncate(fallback_name, TITLE_LIMIT), "#CBA6F7"

def main():
    title, app_class = get_active_window()
    
    if not title or title in ["null", "Desktop", ""]:
        print(json.dumps({"text": "Omarchy OS", "tooltip": "Workspace"}))
        return

    icon, display_text, brand_color = get_brand_info(title, app_class)
    animation = get_music_animation()

    # Bar Text: [Animation] [Colored Icon] [Truncated Title]
    bar_output = f"{animation}<span color='{brand_color}'>{icon} {display_text}</span>"

    # Hover Details (Tooltip)
    tooltip_content = (
        f"<span size='large' weight='bold'>{icon} {display_text}</span>\n"
        f"<span color='#585B70'>──────────────────────────</span>\n"
        f"<span color='#89B4FA'>󰣆 Class:</span> <span color='#CDD6F4'>{app_class}</span>\n"
        f"<span color='#FAB387'>󰖟 Full Title:</span> <span color='#CDD6F4'>{title}</span>"
    )

    # JSON for Waybar
    print(json.dumps({
        "text": bar_output,
        "tooltip": tooltip_content,
        "class": app_class
    }))

if __name__ == "__main__":
    main()