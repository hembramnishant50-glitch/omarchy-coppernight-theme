import subprocess
import json
import hashlib
import random
import re

# --- CONFIGURATION ---
MAX_TITLE_LEN = 35 

# --- MUSIC FILTER ---
MUSIC_PLAYERS = ["spotify", "ncspot", "cider", "rhythmbox", "vlc", "mpv", "music"]
MUSIC_WEB_KEYWORDS = ["spotify", "soundcloud", "music", "deezer", "bandcamp"]

# --- APP & WEBSITE MAP ---
APP_MAP = {

    #----- All Flathub Versions ----

    # --- 1. STUDENT & RESEARCH (Flathub Versions) ---
    "md.obsidian.Obsidian":           ("󱓧", "#7c4dff", "Obsidian"),
    "net.ankiweb.Anki":               ("󰮔", "#ffffff", "Anki"),
    "org.zotero.Zotero":              ("󱓷", "#cc2914", "Zotero"),
    "org.libreoffice.LibreOffice":    ("󰏆", "#185abd", "LibreOffice"),
    "org.onlyoffice.desktopeditors":  ("󰏆", "#ff6f21", "ONLYOFFICE"),
    "com.github.xournalpp.xournalpp": ("󱞈", "#2980b9", "Xournal++"),
    "com.github.johnfactotum.Foliate":("󰂵", "#629c44", "Foliate"),
    "org.kde.kalgebra":               ("󰪚", "#3daee9", "KAlgebra"),

    # --- 2. WEB BROWSERS (Flathub Versions) ---
    "io.github.zen_browser.zen":      ("󰈹", "#4f4f4f", "Zen Browser"),
    "org.mozilla.firefox":            ("", "#ff7139", "Firefox"),
    "com.brave.Browser":              ("", "#ff1a1a", "Brave"),
    "org.qutebrowser.qutebrowser":    ("󰈹", "#8dc21f", "qutebrowser"),
    "io.gitlab.librewolf-community":  ("󰈹", "#3269d6", "LibreWolf"),
    "com.vivaldi.Vivaldi":            ("", "#ef3939", "Vivaldi"),
    "net.mullvad.MullvadBrowser":     ("󰇚", "#3c9519", "Mullvad Browser"),

    # --- 3. DEVELOPMENT & SYSTEM (Flathub Versions) ---
    "com.visualstudio.code":          ("󰨞", "#007acc", "VS Code"),
    "com.vscodium.codium":            ("󰨞", "#23a7d2", "VSCodium"),
    "com.github.tchx84.Flatseal":     ("󱓷", "#3eb34f", "Flatseal"),
    "io.missioncenter.MissionCenter": ("󱓟", "#3584e4", "Mission Center"),
    "io.github.flattool.Warehouse":   ("", "#ff9500", "Warehouse"),

    # --- 4. MEDIA & DESIGN (Flathub Versions) ---
    "org.videolan.VLC":               ("󰕼", "#ff9900", "VLC"),
    "io.github.celluloid_player.Celluloid": ("󰕼", "#5e5ce6", "MPV/Celluloid"),
    "io.bassi.Amberol":               ("󰎆", "#f8d210", "Amberol"),
    "org.gimp.GIMP":                  ("", "#5c5543", "GIMP"),
    "org.inkscape.Inkscape":          ("", "#ffffff", "Inkscape"),
    "org.kde.kdenlive":               ("", "#3daee9", "Kdenlive"),
    "org.upscayl.Upscayl":            ("󰭹", "#ff4500", "Upscayl"),

    # --- 5. UTILITIES (Flathub Versions) ---
    "org.localsend.localsend_app":    ("󰄶", "#3db2ff", "LocalSend"),
    "com.github.flameshot.Flameshot": ("󰄀", "#ff4081", "Flameshot"),
    "com.github.unhndrd.pdfarranger": ("󰈦", "#f1c40f", "PDF Arranger"),
    "com.bitwarden.desktop":          ("󰞀", "#175DDC", "Bitwarden"),
    "io.github.hlubek.Eyedropper":    ("󰈊", "#3584e4", "Eyedropper"),
    "io.github.kolunmi.Bazaar":       ("", "#5da7e4", "Bazaar Weather"),
    "io.github.michelegiacalone.bazaar": ("", "#e74c3c", "Bazaar"),

    # --- 6. SOCIAL (Flathub Versions) ---
    # FIX: Removed duplicate "com.ayugram.desktop" key that was here before.
    #      It is correctly defined below in the Omarchy/Social section.
    "com.discordapp.Discord":         ("", "#5865f2", "Discord"),
    "org.telegram.desktop":           ("", "#24a1de", "Telegram"),


    # --- Omarchy Versions

    # --- 1. AI & EDUCATION ---
    "careerwill":     ("🎓", "#ff9900", "Careerwill"),
    "chatgpt":        ("󰚩", "#74aa9c", "ChatGPT"),
    "gemini":         ("", "#8ab4f8", "Gemini AI"),
    "claude":         ("", "#d97757", "Claude AI"),
    "bing":           ("", "#2583c6", "Bing Chat"),
    "perplexity":     ("󰚩", "#2ebfab", "Perplexity"),

    # --- 2. BROWSERS (Specific IDs first) ---
    "mullvad-browser":  ("󰇚", "#3c9519", "Mullvad Browser"),
    "omarchy-chromium": ("", "#00bcd4", "Omarchy Chromium"),
    "librewolf":        ("󰈹", "#3269d6", "LibreWolf"),
    "tor-browser":      ("", "#7d4698", "Tor Browser"),
    "ungoogled-chromium": ("", "#ffffff", "Ungoogled Chromium"),
    "brave-browser":    ("", "#ff1a1a", "Brave"),
    "google-chrome":    ("", "#4285f4", "Google Chrome"),
    "microsoft-edge":   ("", "#0078d7", "Microsoft Edge"),
    "firefox":          ("", "#ff7139", "Firefox"),
    "chromium":         ("", "#4285f4", "Chromium"),
    "cromium":          ("", "#4285f4", "Chromium"),
    "opera":            ("", "#ff1b2d", "Opera"),
    "vivaldi":          ("", "#ef3939", "Vivaldi"),
    "epiphany":         ("󰈹", "#3584e4", "GNOME Web"),
    "helium":           ("󰈹", "#ffeb3b", "Helium"),

    # --- 3. SOCIAL MEDIA & COMMUNICATION ---
    "com.ayugram.desktop": ("", "#3399ff", "AyuGram"),
    "ayugram-desktop":     ("", "#3399ff", "AyuGram"),
    "telegram-desktop":    ("", "#24A1DE", "Telegram"),
    "telegram":            ("", "#24a1de", "Telegram"),
    "discord":             ("", "#5865f2", "Discord"),
    "whatsapp":            ("", "#25d366", "WhatsApp"),
    "reddit":              ("", "#ff4500", "Reddit"),
    "twitter":             ("", "#1da1f2", "Twitter"),
    "x.com":               ("", "#000000", "X"), 
    "facebook":            ("", "#1877f2", "Facebook"),
    "instagram":           ("", "#c13584", "Instagram"),
    "linkedin":            ("", "#0077b5", "LinkedIn"),
    "pinterest":           ("", "#bd081c", "Pinterest"),
    "tumblr":              ("", "#35465c", "Tumblr"),
    "tiktok":              ("", "#ff0050", "TikTok"),

    # --- 4. PRODUCTIVITY & OFFICE ---
    "onlyoffice":     ("󰏆", "#ff6f21", "ONLYOFFICE"),
    "libreoffice-startcenter": ("󰏆", "#185abd", "LibreOffice"),
    "libreoffice-writer":      ("󰏆", "#005396", "Writer"),
    "libreoffice-calc":        ("󰏆", "#2d7335", "Calc"),
    "libreoffice-impress":     ("󰏆", "#b83c22", "Impress"),
    "libreoffice-draw":        ("󰏆", "#833e14", "Draw"),
    "libreoffice-math":        ("󰏆", "#4285f4", "Math"),
    "libreoffice-base":        ("󰏆", "#622a7a", "Base"),
    "DesktopEditors": ("󰏆", "#ff6f21", "ONLYOFFICE"),
    "obsidian":       ("󱓧", "#7c4dff", "Obsidian"),
    "joplin":         ("󰮔", "#002e7a", "Joplin"),
    "anki":           ("󰮔", "#ffffff", "Anki"),
    "zotero":         ("󱓷", "#cc2914", "Zotero"),
    "xournalpp":      ("󱞈", "#2980b9", "Xournal++"),
    "pdfarranger":    ("󰈦", "#f1c40f", "PDF Arranger"),
    "notion":         ("", "#000000", "Notion"),
    "trello":         ("", "#0079bf", "Trello"),
    "gmail":          ("", "#ea4335", "Gmail"),
    "outlook":        ("", "#0078d4", "Outlook"),
    "hey":            ("󰮏", "#ffcc00", "HEY Mail"),
    "basecamp":       ("", "#ffcc00", "basecamp"),

    # --- 5. GRAPHICS & MEDIA ---
    "flameshot":      ("󰄀", "#ff4081", "Flameshot"),
    "gimp":           ("", "#5c5543", "GIMP"),
    "inkscape":       ("", "#ffffff", "Inkscape"),
    "figma":          ("", "#f24e1e", "Figma"),
    "canva":          ("", "#00c4cc", "Canva"),
    "vlc":            ("󰕼", "#ff9900", "VLC"),
    "obs":            ("", "#262626", "OBS Studio"),
    "spotify":        ("", "#1db954", "Spotify"),
    "youtube":        ("", "#ff0000", "YouTube"),

    # --- 6. SYSTEM & UTILITIES ---
    "io.github.flattool.Warehouse": ("", "#ff9500", "Warehouse"),
    "warehouse":                     ("", "#ff9500", "Warehouse"),
    "bitwarden":      ("󰞀", "#175DDC", "Bitwarden"),
    "Bitwarden":      ("󰞀", "#175DDC", "Bitwarden"),
    "pavucontrol":    ("󰓃", "#67808d", "Volume Control"),
    "bleachbit":      ("󰃢", "#e6e6e6", "BleachBit"),
    "timeshift":      ("󰁯", "#ed333b", "Timeshift"),
    "nautilus":       ("", "#f2c94c", "Files"),
    "dolphin":        ("", "#3daee9", "Dolphin"),
    "thunar":         ("", "#a9b665", "Thunar"),
    "calculator":     ("", "#4193f4", "Calculator"),
    "keypunch":       ("", "#ff4081", "Keypunch"),
    "bazaar":                              ("", "#e74c3c", "Bazaar"),
    "Com-abdownloadmanager-desktop-appkt": ("󰇚", "#00aaff", "AB Download Manager"),
    "aether":         ("󰑭", "#a29bfe", "Aether"),
    "typora":         ("󰂺", "#b4637a", "Typora"),

    # --- DOWNLOAD MANAGERS ---
    "com.abdownloadmanager.abdownloadmanager": ("󰇚", "#00aaff", "AB Download Manager"),
    "abdownloadmanager":                       ("󰇚", "#00aaff", "AB Download Manager"),
    "qbittorrent":                             ("󱑢", "#3b4ba4", "qBittorrent"),
    "transmission":             ("󰇚", "#e63946", "Transmission"),
    "deluge":                   ("󱑢", "#49a010", "Deluge"),
    "aria2":                    ("󰈚", "#f1c40f", "Aria2"),
    "motrix":         ("󰇚", "#ff4a00", "Motrix"),
    "xdm":            ("󱑢", "#2c3e50", "XDM"),
    "uget":           ("󰈚", "#fa8e3c", "uGet"),
    "jdownloader":    ("󱑣", "#ff9000", "JDownloader"),
    "persepolis":     ("󰈚", "#34495e", "Persepolis"),
    "fdm":            ("󰇚", "#00aaff", "FDM"),
    "kget":           ("󱑢", "#3daee9", "KGet"),

    # --- 7. WEB SERVICES & SHOPPING ---
    "github":         ("", "#ffffff", "GitHub"),
    "gitlab":         ("", "#fc6d26", "GitLab"),
    "stackoverflow":  ("", "#f48024", "StackOverflow"),
    "amazon":         ("", "#ff9900", "Amazon"),
    "cafebazaar":     ("󰄶", "#42b029", "Bazaar"),
    "ir.cafebazaar":  ("󰄶", "#42b029", "Bazaar"),

    # --- 8. GNOME SUITE ---
    "org.gnome.clocks":     ("󱎫", "#3584e4", "Clocks"),
    "gnome-clocks":         ("󱎫", "#3584e4", "Clocks"),
    "gnome-system-monitor": ("󱓟", "#3584e4", "System Monitor"),
    "gnome-control-center": ("⚙️", "#9a9996", "Settings"),
    "gnome-software":       ("🛍️", "#3584e4", "Software"),

    # --- 9. DEVELOPMENT & TERMINALS ---
    "nvim":           ("", "#57a143", "Neovim"),
    "vim":            ("", "#019833", "Vim"),
    "code":           ("󰨞", "#007acc", "VS Code"),
    "ghostty":        ("", "#cba6f7", "Ghostty"),
    "kitty":          ("", "#cba6f7", "Kitty"),
    "alacritty":      ("", "#f9e2af", "Alacritty"),
    "terminator":     ("", "#e53935", "Terminator"),
    "foot":           ("󰽒", "#88c0d0", "Foot"),
    "org.omarchy.terminal": ("", "#f9e2af", "Terminal"),
    "docker":         ("", "#2496ed", "Docker"),
    "localhost":      ("", "#00ff00", "Localhost"),

}

PATTERNS = [" ▃▆▄", " ▄▃▇", " ▆▃▅", " ▇▆▃", " ▃▅▇"]

def get_media_info():
    """Handles Music Visualizer (High Priority)"""
    try:
        status = subprocess.check_output(["playerctl", "status"], stderr=subprocess.DEVNULL).decode().strip()
        if status == "Playing":
            player_name = subprocess.check_output(["playerctl", "metadata", "--format", "{{playerName}}"], stderr=subprocess.DEVNULL).decode().strip().lower()
            title = subprocess.check_output(["playerctl", "metadata", "title"], stderr=subprocess.DEVNULL).decode().strip()
            artist = subprocess.check_output(["playerctl", "metadata", "artist"], stderr=subprocess.DEVNULL).decode().strip()
            
            is_music_app = any(app in player_name for app in MUSIC_PLAYERS)
            is_music_web = any(web in title.lower() for web in MUSIC_WEB_KEYWORDS)

            if is_music_app or is_music_web:
                bars = random.choice(PATTERNS)
                display_title = title if len(title) < 25 else title[:25] + "..."
                display = f"<span color='#a6e3a1'>{bars}</span>  {display_title}"
                tooltip = f"Now Playing: {title} by {artist} ({player_name})"
                return display, tooltip
            return None, None
        elif status == "Paused":
            return "<span color='#f9e2af'>󰏤 Paused</span>", "Click to Resume"
    except:
        pass
    return None, None

def get_active_window():
    try:
        output = subprocess.check_output(["hyprctl", "activewindow", "-j"], stderr=subprocess.DEVNULL).decode("utf-8")
        data = json.loads(output)
        
        raw_title = data.get("title", "")
        raw_class = data.get("class", "").lower()
        title_lower = raw_title.lower()

        def format_output(icon, color, app_name, win_title):
            # --- THE YOUTUBE EXCEPTION ---
            if app_name == "YouTube":
                clean_title = win_title.replace(f" - {app_name}", "").replace(f"- {app_name}", "").strip()
                clean_title = clean_title.replace(" - YouTube", "").strip()
                
                # Remove notification counts like (33) or (1)
                clean_title = re.sub(r'\(\d+\)', '', clean_title).strip()

                if not clean_title: clean_title = win_title 

                if len(clean_title) > MAX_TITLE_LEN:
                    clean_title = clean_title[:MAX_TITLE_LEN] + "..."
                
                return f"<span color='{color}'>{icon}</span>  {app_name} <span color='#6c7086'>|</span> <span color='#e6e9ef'>{clean_title}</span>", win_title

            # --- FOR EVERYONE ELSE (NO TITLES) ---
            return f"<span color='{color}'>{icon}</span>  {app_name}", win_title

        # 1. Check APP_MAP
        for key, (icon, color, name) in APP_MAP.items():
            if key in raw_class or key in title_lower:
                return format_output(icon, color, name, raw_title)
        
        # 2. Desktop Check
        if not raw_class:
            return "<span color='#cdd6f4'>󱂬</span> Desktop", "Workspace"

        # 3. Fallback
        clean_name = raw_class.replace("org.gnome.", "").replace("org.kde.", "").replace("com.", "").replace(".desktop", "")
        if "mitchellh." in clean_name: clean_name = clean_name.replace("mitchellh.", "")
        
        clean_name = clean_name.capitalize()
        hex_color = "#" + hashlib.md5(clean_name.encode()).hexdigest()[:6]
        
        if "gnome" in raw_class: icon = ""
        elif "kde" in raw_class: icon = ""
        else: icon = ""

        return format_output(icon, hex_color, clean_name, raw_title)

    except:
        return "<span color='#cdd6f4'>󱂬</span> Desktop", "Workspace"

if __name__ == "__main__":
    media_text, media_tooltip = get_media_info()
    if media_text:
        display_text = media_text
        tooltip_text = media_tooltip
    else:
        display_text, tooltip_text = get_active_window()
    print(json.dumps({"text": display_text, "tooltip": tooltip_text}))