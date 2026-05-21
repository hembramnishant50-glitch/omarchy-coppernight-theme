#!/usr/bin/env python3
import subprocess
import json
import re
import time
import html
import sys
import os
import threading

# --- CONFIGURATION ---
MAX_TITLE_LEN = 15  # The maximum width of the text area before it starts scrolling
# Sleek Braille dot equalizer pattern
BARS = [" ", "⡀", "⣀", "⣄", "⣤", "⣦", "⣶", "⣿"] 

# --- THE ULTIMATE MUSIC PLAYER LIST ---
MUSIC_PLAYERS = [
    "spotify", "ncspot", "spotifyd", "cider", "apple-music", 
    "rhythmbox", "vlc", "mpv", "amberol", "lollypop", 
    "audacious", "clementine", "strawberry", "cmus", 
    "tauon", "tauonmb", "elisa", "quodlibet", "cantata", 
    "pragha", "deadbeef", "qmmp", "sayonara", "netease", 
    "yesplaymusic", "youtube-music", "ytmdesktop", "feishin", 
    "tidal", "deezer", "music"
]

# --- GLOBAL STATE ---
current_song = ""
is_music_playing = False

# --- EXACT USER APP RULES ---
APP_RULES = {
    # --- 0. Google / Proton ---
    "google-chrome":                  ("", "#4285f4", "Chrome"),
    "google-gmail":                   ("󰊭", "#ea4335", "Gmail"),
    "google-drive":                   ("󰝰", "#34a853", "Drive"),
    "google-calendar":                ("󰸗", "#4285f4", "Calendar"),
    "Chrome-calendar.google.com":     ("󰸗", "#4285f4", "Calendar"),
    "google-keep":                    ("󰟶", "#fbbc04", "Keep"),
    "google-maps":                    ("󰉙", "#34a853", "Maps"),
    "google-docs":                    ("󰈙", "#4285f4", "Docs"),
    "google-sheets":                  ("󰈛", "#34a853", "Sheets"),
    "google-slides":                  ("󰈧", "#fbbc04", "Slides"),
    "google-meet":                    ("󰻵", "#00897b", "Meet"),
    "google-photos":                  ("󰄄", "#ff4500", "Photos"),
    "google-youtube":                 ("󰗃", "#ff0000", "YouTube"),
    "basecamp":                       ("", "#ffcc00", "basecamp"),
    "calendar.google.com": ("󰸗", "#4285f4", "Calendar"),
    "mail.google.com":     ("󰊭", "#ea4335", "Gmail"),
    "drive.google.com":    ("󰝰", "#34a853", "Drive"),
    "keep.google.com":     ("󰟶", "#fbbc04", "Keep"),
    "docs.google.com":     ("󰈙", "#4285f4", "Docs"),
    "sheets.google.com":   ("󰈛", "#34a853", "Sheets"),
    "slides.google.com":   ("󰈧", "#fbbc04", "Slides"),
    "meet.google.com":     ("󰻵", "#00897b", "Meet"),
    "photos.google.com":   ("󰄄", "#ff4500", "Photos"),
    "youtube.com":         ("󰗃", "#ff0000", "YouTube"),
    "www.google.com":      ("", "#4285f4", "Google"),
    "notebooklm.google.com": ("󰠮", "#4285f4", "NotebookLM"),
    "zoom.us": ("󰕧", "#2d8cff", "Zoom"),

    "mail.proton.me":       ("󰇮", "#6d4aff", "Proton Mail"),
    "calendar.proton.me":   ("󰸗", "#6d4aff", "Proton Calendar"),
    "drive.proton.me":      ("󰝰", "#6d4aff", "Proton Drive"),
    "pass.proton.me":       ("󰷖", "#6d4aff", "Proton Pass"),
    "vpn.proton.me":        ("󰖂", "#6d4aff", "Proton VPN"),
    "lumo.proton.me":       ("󱔐", "#6d4aff", "Proton Lumo"),

    # --- 1. STUDENT & RESEARCH (Flathub Versions) ---
    "ClamUI":                         ("󰕥", "#7c4dff", "ClamUI"),
    "md.obsidian.Obsidian":           ("󱓧", "#7c4dff", "Obsidian"),
    "net.ankiweb.Anki":               ("󰮔", "#ffffff", "Anki"),
    "org.zotero.Zotero":              ("󱓷", "#cc2914", "Zotero"),
    "org.libreoffice.LibreOffice":    ("󰏆", "#185abd", "LibreOffice"),
    "org.onlyoffice.desktopeditors":  ("󰏆", "#ff6f21", "ONLYOFFICE"),
    "com.github.xournalpp.xournalpp": ("󱞈", "#2980b9", "Xournal++"),
    "com.github.johnfactotum.Foliate":("󰂵", "#629c44", "Foliate"),
    "org.kde.kalgebra":               ("󰪚", "#3daee9", "KAlgebra"),
    "io.github.fabrialberio.pinapp":  ("󰐚", "#4caf50", "Pins"),
    "org.bunkus.mkvtoolnix-gui":      ("󰔑", "#81a2be", "MKVToolNix"),
    "garden.jamie.Morphosis":         ("󰈹", "#3584e4", "Morphosis"),

    # --- 2. WEB BROWSERS (Flathub Versions) ---
    "io.github.zen_browser.zen":      ("󰈹", "#4f4f4f", "Zen Browser"),
    "org.mozilla.firefox":            ("", "#ff7139", "Firefox"),
    "org.qutebrowser.qutebrowser":    ("󰈹", "#8dc21f", "qutebrowser"),
    "io.gitlab.librewolf-community":  ("󰈹", "#3269d6", "LibreWolf"),
    "com.vivaldi.Vivaldi":            ("", "#ef3939", "Vivaldi"),
    "net.mullvad.MullvadBrowser":     ("󰇚", "#3c9519", "Mullvad Browser"),

    # --- 3. DEVELOPMENT & SYSTEM (Flathub Versions) ---
    "com.visualstudio.code":          ("󰨞", "#007acc", "VS Code"),
    "com.vscodium.codium":            ("󰨞", "#23a7d2", "VSCodium"),
    "com.github.tchx84.Flatseal":     ("󱓷", "#3eb34f", "Flatseal"),
    "io.missioncenter.MissionCenter": ("󱓟", "#3584e4", "Mission Center"),
    "io.github.flattool.Warehouse":   ("", "#ff9500", "Warehouse"),

    # --- 4. MEDIA & DESIGN (Flathub Versions) ---
    "org.videolan.VLC":               ("󰕼", "#ff9900", "VLC"),
    "io.github.celluloid_player.Celluloid": ("󰕼", "#5e5ce6", "MPV/Celluloid"),
    "io.bassi.Amberol":               ("󰎆", "#f8d210", "Amberol"),
    "org.gimp.GIMP":                  ("", "#5c5543", "GIMP"),
    "org.inkscape.Inkscape":          ("", "#ffffff", "Inkscape"),
    "org.kde.kdenlive":               ("", "#3daee9", "Kdenlive"),
    "org.upscayl.Upscayl":            ("󰭹", "#ff4500", "Upscayl"),

    # --- 5. UTILITIES (Flathub Versions) ---
    "org.localsend.localsend_app":    ("󰄶", "#3db2ff", "LocalSend"),
    "com.github.flameshot.Flameshot": ("󰄀", "#ff4081", "Flameshot"),
    "com.github.unhndrd.pdfarranger": ("󰈦", "#f1c40f", "PDF Arranger"),
    "com.bitwarden.desktop":          ("󰞀", "#175DDC", "Bitwarden"),
    "io.github.hlubek.Eyedropper":    ("󰈊", "#3584e4", "Eyedropper"),
    "io.github.kolunmi.Bazaar":       ("", "#5da7e4", "Bazaar"),
    "io.github.michelegiacalone.bazaar": ("", "#e74c3c", "Bazaar"),
    "org.audacityteam.Audacity":      ("󰓃", "#0000eb", "Audacity"),
    "audacity":                       ("󰓃", "#0000eb", "Audacity"),
    "com.rafaelmardojai.Blanket":     ("󰖗", "#3daee9", "Blanket"),
    "blanket":                        ("󰖗", "#3daee9", "Blanket"),
    "org.gnome.gitlab.YaLTeR.VideoTrimmer": ("󰐊", "#c061cb", "Video Trimmer"),
    "org.libretro.RetroArch":         ("󰊴", "#3daee9", "RetroArch"),
    "pinapp":                         ("󰐚", "#4caf50", "Pins"),
    "Pins":                           ("󰐚", "#4caf50", "Pins"),
    
    # --- 6. SOCIAL (Flathub Versions) ---
    "com.discordapp.Discord":         ("", "#5865f2", "Discord"),
    "org.telegram.desktop":           ("", "#24a1de", "Telegram"),
    "com.ayugram.desktop":            ("", "#3399ff", "AyuGram"),

    # --- Omarchy Versions ---
    # --- Gaming ----
    "minecraft-launcher":             ("󰍳", "#3e8527", "Minecraft"),
    "minecraft launcher":             ("󰍳", "#3e8527", "Minecraft"),
    "org.prismlauncher.PrismLauncher":("󰍳", "#52b12e", "Prism"),
    "org.multimc.MultiMC":            ("󰍳", "#f9b000", "MultiMC"),
    "com.gdlauncher.gdlauncher":      ("󰍳", "#14b1e7", "GDLauncher"),
    "retroarch":                      ("󰊴", "#3daee9", "RetroArch"),
    "RetroArch":                      ("󰊴", "#3daee9", "RetroArch"),

    # --- AI & EDUCATION ---
    "careerwill":                     ("🎓", "#ff9900", "Careerwill"),
    "chatgpt":                        ("󰚩", "#74aa9c", "ChatGPT"),
    "gemini":                         ("󰊭", "#8ab4f8", "Gemini AI"),
    "claude":                         ("", "#d97757", "Claude AI"),
    "bing":                           ("", "#2583c6", "Bing Chat"),
    "perplexity":                     ("󰚩", "#2ebfab", "Perplexity"),

    # --- BROWSERS ---
    "com.brave.Browser":              ("󰖟", "#ff542b", "Brave"),
    "brave-browser":                  ("󰖟", "#ff542b", "Brave"),
    "Brave-origin-beta":                  ("󰖟", "#ff542b", "Brave Origin"),
    "omarchy-chromium":               ("", "#00bcd4", "Omarchy Chromium"),
    "librewolf":                      ("󰈹", "#3269d6", "LibreWolf"),
    "tor-browser":                    ("", "#7d4698", "Tor Browser"),
    "ungoogled-chromium":             ("", "#ffffff", "Ungoogled Chromium"),
    "microsoft-edge":                 ("", "#0078d7", "Microsoft Edge"),
    "firefox":                        ("", "#ff7139", "Firefox"),
    "chromium":                       ("", "#4285f4", "Chromium"),
    "cromium":                        ("", "#4285f4", "Chromium"),
    "opera":                          ("", "#ff1b2d", "Opera"),
    "vivaldi":                        ("", "#ef3939", "Vivaldi"),
    "epiphany":                       ("󰈹", "#3584e4", "GNOME Web"),
    "helium":                         ("󰈹", "#ffeb3b", "Helium"),
    "mullvadbrowser":                 ("󰖟", "#ffdc00", "Mullvad"),
    "mullvadbrowser.real":            ("󰖟", "#ffdc00", "Mullvad"),
    "mullvad-browser-bin":            ("󰖟", "#ffdc00", "Mullvad"),
    "mullvad browser":                ("󰖟", "#ffdc00", "Mullvad"),
    "mullvad-browser":                ("󰖟", "#ffdc00", "Mullvad"),

    # --- SOCIAL MEDIA & COMMUNICATION ---
    "ayugram-desktop":                ("", "#3399ff", "AyuGram"),
    "telegram-desktop":               ("", "#24A1DE", "Telegram"),
    "telegram":                       ("", "#24a1de", "Telegram"),
    "discord":                        ("", "#5865f2", "Discord"),
    "whatsapp":                       ("", "#25d366", "WhatsApp"),
    "reddit":                         ("", "#ff4500", "Reddit"),
    "twitter":                        ("", "#1da1f2", "Twitter"),
    "x.com":                          ("", "#000000", "X"), 
    "facebook":                       ("", "#1877f2", "Facebook"),
    "instagram":                      ("", "#c13584", "Instagram"),
    "linkedin":                       ("", "#0077b5", "LinkedIn"),
    "pinterest":                      ("", "#bd081c", "Pinterest"),
    "tumblr":                         ("", "#35465c", "Tumblr"),
    "tiktok":                         ("", "#ff0050", "TikTok"),
    "org.signal.Signal":              ("󰭹", "#3a76f0", "Signal"),
    "signal-desktop":                 ("󰭹", "#3a76f0", "Signal"),
    "signal":                         ("󰭹", "#3a76f0", "Signal"),

    # --- PRODUCTIVITY & OFFICE ---
    "onlyoffice":                     ("󰏆", "#ff6f21", "ONLYOFFICE"),
    "libreoffice-startcenter":        ("󰏆", "#185abd", "LibreOffice"),
    "libreoffice-writer":             ("󰏆", "#005396", "Writer"),
    "libreoffice-calc":               ("󰏆", "#2d7335", "Calc"),
    "libreoffice-impress":            ("󰏆", "#b83c22", "Impress"),
    "libreoffice-draw":               ("󰏆", "#833e14", "Draw"),
    "libreoffice-math":               ("󰏆", "#4285f4", "Math"),
    "libreoffice-base":               ("󰏆", "#622a7a", "Base"),
    "DesktopEditors":                 ("󰏆", "#ff6f21", "ONLYOFFICE"),
    "obsidian":                       ("󱓧", "#7c4dff", "Obsidian"),
    "joplin":                         ("󰮔", "#002e7a", "Joplin"),
    "anki":                           ("󰮔", "#ffffff", "Anki"),
    "zotero":                         ("󱓷", "#cc2914", "Zotero"),
    "xournalpp":                      ("󱞈", "#2980b9", "Xournal++"),
    "pdfarranger":                    ("󰈦", "#f1c40f", "PDF Arranger"),
    "notion":                         ("", "#000000", "Notion"),
    "trello":                         ("", "#0079bf", "Trello"),
    "gmail":                          ("", "#ea4335", "Gmail"),
    "outlook":                        ("", "#0078d4", "Outlook"),
    "hey":                            ("󰮏", "#ffcc00", "HEY Mail"),

    # --- GRAPHICS & MEDIA ---
    "flameshot":                      ("󰄀", "#ff4081", "Flameshot"),
    "gimp":                           ("", "#5c5543", "GIMP"),
    "inkscape":                       ("", "#ffffff", "Inkscape"),
    "figma":                          ("", "#f24e1e", "Figma"),
    "canva":                          ("", "#00c4cc", "Canva"),
    "vlc":                            ("󰕼", "#ff9900", "VLC"),
    "obs":                            ("", "#FFFFFF", "OBS Studio"),
    "spotify":                        ("", "#1db954", "Spotify"),
    "youtube":                        ("", "#ff0000", "YouTube"),

    # --- SYSTEM & UTILITIES ---
    "warehouse":                      ("", "#ff9500", "Warehouse"),
    "bitwarden":                      ("󰞀", "#175DDC", "Bitwarden"),
    "Bitwarden":                      ("󰞀", "#175DDC", "Bitwarden"),
    "pavucontrol":                    ("󰓃", "#67808d", "Volume Control"),
    "bleachbit":                      ("󰃢", "#e6e6e6", "BleachBit"),
    "timeshift":                      ("󰁯", "#ed333b", "Timeshift"),
    "nautilus":                       ("", "#f2c94c", "Files"),
    "dolphin":                        ("", "#3daee9", "Dolphin"),
    "thunar":                         ("", "#a9b665", "Thunar"),
    "calculator":                     ("", "#4193f4", "Calculator"),
    "keypunch":                       ("", "#ff4081", "Keypunch"),
    "bazaar":                         ("", "#e74c3c", "Bazaar"),
    "Com-abdownloadmanager-desktop-appkt": ("󰇚", "#00aaff", "AB Download Manager"),
    "aether":                         ("󰑭", "#a29bfe", "Aether"),
    "typora":                         ("󰂺", "#b4637a", "Typora"),
    "1password":                      ("", "#0572ec", "1Password"),
    "Io.gitlab.adhami3310.converter": ("󱊲", "#3584e4", "Converter"),
    "fr.handbrake.ghb":               ("󱁆", "#b71c1c", "Handbrake"),
    "curlew":                         ("󰕧", "#2e7d32", "Curlew"),
    "soundconverter":                 ("󰓃", "#f57c00", "SoundConverter"),
    "mystiq":                         ("󰕧", "#00d2ff", "MystiQ"),
    "Gitlab.yalter.videotrimmer":     ("󰐊", "#c061cb", "Video Trimmer"),
    "com.ozmartians.VidCutter":       ("󰐊", "#2d8cff", "VidCutter"),
    "losslesscut":                    ("󰐊", "#000000", "LosslessCut"),
    "io.gitlab.clark_johnston.Footage": ("󰿚", "#3584e4", "Footage"),
    "Stremio.stremio":                ("󰐊", "#7b3fe4", "Stremio"),
    "com.stremio.Stremio":            ("󰐊", "#7b3fe4", "Stremio"),
    "stremio":                        ("󰐊", "#7b3fe4", "Stremio"),
    "com.stremio.Service":            ("󱑫", "#7b3fe4", "Stremio Service"),
    "Io.github.sigmasd.stimulator":   ("󰅶", "#f57c00", "Stimulator"),
    "io.github.sigmasd.stimulator":   ("󰅶", "#f57c00", "Stimulator"),
    "stimulator":                     ("󰅶", "#f57c00", "Stimulator"),
    "de.haeckerfelix.Shortwave":      ("󰕱", "#613583", "Shortwave"),
    "Shortwave":                      ("󰕱", "#613583", "Shortwave"),
    "shortwave":                      ("󰕱", "#613583", "Shortwave"),
    "fr.romainvigier.MetadataCleaner":("󰃢", "#5e5c64", "Metadata Cleaner"),
    "metadatacleaner":                ("󰃢", "#5e5c64", "Metadata Cleaner"),
    "Metadata Cleaner":               ("󰃢", "#5e5c64", "Metadata Cleaner"),
    "Morphosis":                      ("󰈹", "#3584e4", "Morphosis"),
    "morphosis":                      ("󰈹", "#3584e4", "Morphosis"),
    "garden.jamie.morphosis":         ("󰈹", "#3584e4", "Morphosis"),
    "mkvtoolnix-gui":                 ("󰔑", "#81a2be", "MKVToolNix"),
    "mkvtoolnix":                     ("󰔑", "#81a2be", "MKVToolNix"),
    "MKVToolNix GUI":                 ("󰔑", "#81a2be", "MKVToolNix"),

    # --- DOWNLOAD MANAGERS ---
    "com.abdownloadmanager.abdownloadmanager": ("󰇚", "#00aaff", "AB Download Manager"),
    "abdownloadmanager":              ("󰇚", "#00aaff", "AB Download Manager"),
    "qbittorrent":                    ("󱑢", "#3b4ba4", "qBittorrent"),
    "transmission":                   ("󰇚", "#e63946", "Transmission"),
    "deluge":                         ("󱑢", "#49a010", "Deluge"),
    "aria2":                          ("󰈚", "#f1c40f", "Aria2"),
    "motrix":                         ("󰇚", "#ff4a00", "Motrix"),
    "xdm":                            ("󱑢", "#2c3e50", "XDM"),
    "uget":                           ("󰈚", "#fa8e3c", "uGet"),
    "jdownloader":                    ("󱑣", "#ff9000", "JDownloader"),
    "persepolis":                     ("󰈚", "#34495e", "Persepolis"),
    "fdm":                            ("󰇚", "#00aaff", "FDM"),
    "kget":                           ("󱑢", "#3daee9", "KGet"),

    # --- GNOME SUITE ---
    "org.gnome.clocks":               ("󱎫", "#3584e4", "Clocks"),
    "gnome-clocks":                   ("󱎫", "#3584e4", "Clocks"),
    "gnome-system-monitor":           ("󱓟", "#3584e4", "System Monitor"),
    "gnome-control-center":           ("⚙️", "#9a9996", "Settings"),
    "gnome-software":                 ("🛍️", "#3584e4", "Software"),

    # --- DEVELOPMENT & TERMINALS ---
    "nvim":                           ("", "#57a143", "Neovim"),
    "vim":                            ("", "#019833", "Vim"),
    "code":                           ("󰨞", "#007acc", "VS Code"),
    "ghostty":                        ("", "#cba6f7", "Ghostty"),
    "kitty":                          ("", "#cba6f7", "Kitty"),
    "alacritty":                      ("", "#f9e2af", "Alacritty"),
    "terminator":                     ("", "#e53935", "Terminator"),
    "foot":                           ("󰽒", "#88c0d0", "Foot"),
    "org.omarchy.terminal":           ("", "#f9e2af", "Terminal"),
    "docker":                         ("", "#2496ed", "Docker"),
    "localhost":                      ("", "#00ff00", "Localhost"),
    
    # --- EXTRA ---
    "com-tonikelope-megabasterd-mainpanel": ("󰗽", "#d92323", "MegaBuster"),
    "usebottles.bottles":                 ("󰡏", "#51a2da", "Bottles"),
    "boxes":                              ("󰆧", "#3584e4", "GNOME Boxes"),
    "localsend":                      ("󰒍", "#3db2ff", "LocalSend"),
    "io.github.vmkspv.lenspect":      ("󰯳", "#cba6f7", "Lenspect"),
    "lenspect":                       ("󰯳", "#cba6f7", "Lenspect"),
    # --- NEW APP CLEANUPS ---
    "antigravity":        ("󰄕", "#cba6f7", "Antigravity"),
    "collision":          ("", "#f38ba8", "Collision"),
    "cryptomator":        ("󰌆", "#3584e4", "Cryptomator"),
    "dialect":            ("", "#89b4fa", "Dialect"),
    "evince":             ("󰈦", "#f38ba8", "Evince"),
    "ente":               ("󰄄", "#cba6f7", "Ente"),
    "fingergo":           ("󰟶", "#a6e3a1", "Fingergo"),
    "fizzy.do":           ("󰐿", "#f9e2af", "Fizzy"),
    
    # --- WEB SERVICES & SHOPPING ---
    "gitlab":                         ("", "#fc6d26", "GitLab"),
    "github-desktop":                 ("󰊤", "#ffffff", "GitHub"),
    "github.com":                 ("󰊤", "#ffffff", "GitHub"),
    "GitHub Desktop":                 ("󰊤", "#ffffff", "GitHub"),
    "io.github.shiftey.Desktop":      ("󰊤", "#ffffff", "GitHub"),
    "stackoverflow":                  ("", "#f48024", "StackOverflow"),
    "amazon":                         ("", "#ff9900", "Amazon"),
    "cafebazaar":                     ("󰄶", "#42b029", "Bazaar"),
    "ir.cafebazaar":                  ("󰄶", "#42b029", "Bazaar"),
}

def track_music_background():
    """Tracks if an allowed music player is currently active and playing."""
    global current_song, is_music_playing
    
    # Wrapped in a while loop so it restarts automatically if Spotify is closed
    while True:
        try:
            process = subprocess.Popen(
                ['playerctl', 'metadata', '--follow', '--format', '{{playerName}}|||{{status}}|||{{title}}|||{{artist}}'],
                stdout=subprocess.PIPE,
                stderr=subprocess.DEVNULL,
                text=True
            )
            
            for line in process.stdout:
                parts = line.strip('\n').split('|||')
                if len(parts) == 4:
                    player, status, title, artist = parts
                    if any(p in player.lower() for p in MUSIC_PLAYERS) and status == "Playing":
                        is_music_playing = True
                        current_song = f"{title} - {artist}" if artist else title
                    else:
                        is_music_playing = False
                        current_song = ""
            
            # If the loop breaks, it means playerctl died (e.g., the user closed Spotify)
            # We must instantly set music to False so the window text comes back!
            is_music_playing = False
            current_song = ""
            
        except Exception:
            is_music_playing = False
            current_song = ""
            
        # Wait 1 second before trying to connect to a player again to save CPU
        time.sleep(1)

def scroll_text(text, width):
    """Creates a smooth scrolling marquee if the text is too long."""
    if not text:
        return ""
    if len(text) <= width:
        return html.escape(text)
    
    padded_text = text + "  •  "
    offset = int(time.time() * 4) % len(padded_text)
    scrolled = (padded_text * 2)[offset:offset+width]
    return html.escape(scrolled)

def get_active_window():
    """Fetches the current active window from Hyprland."""
    try:
        output = subprocess.check_output(["hyprctl", "activewindow", "-j"], stderr=subprocess.DEVNULL).decode("utf-8")
        data = json.loads(output)
        
        raw_title = data.get("title", "")
        raw_class = data.get("class", "").lower()
        title_lower = raw_title.lower()

        def format_output(icon, color, app_name, win_title):
            if app_name == "YouTube":
                clean_title = win_title.replace(" - YouTube", "").replace("YouTube", "").strip()
                clean_title = re.sub(r'\(\d+\)', '', clean_title).strip()
                if not clean_title: clean_title = win_title 
                if len(clean_title) > MAX_TITLE_LEN:
                    clean_title = clean_title[:MAX_TITLE_LEN] + "..."
                return f"<span color='{color}'>{icon}</span>  {app_name} <span color='#788587'>|</span> <span color='#dcd6d6'>{html.escape(clean_title)}</span>", html.escape(win_title)
            return f"<span color='{color}'>{icon}</span>  {app_name}", html.escape(win_title)

        for key, (icon, color, name) in APP_RULES.items():
            if key.lower() in raw_class or key.lower() in title_lower:
                return format_output(icon, color, name, raw_title)
        
        if not raw_class:
            return "<span color='#dcd6d6'>󱂬</span> Desktop", "Workspace"

        clean_name = raw_class.replace("org.gnome.", "").replace("org.kde.", "").replace("com.", "").replace(".desktop", "").capitalize()
        return format_output("", "#dcd6d6", clean_name, raw_title)
    except:
        return "<span color='#dcd6d6'>󱂬</span> Desktop", "Workspace"

def format_cava_output(line):
    """Converts raw Cava numbers into mirrored unicode bars."""
    try:
        nums = [int(n) for n in line.split(";") if n.strip().isdigit()]
    except:
        nums = [0] * 6

    nums = nums[:6] # Ensure we only process 6 bars

    # Build Left and Right (reversed) side bars
    left_bars = "".join(BARS[n] if 0 <= n <= 7 else " " for n in nums)
    right_bars = "".join(BARS[n] if 0 <= n <= 7 else " " for n in reversed(nums))

    # Get smooth scrolling text
    scrolling_title = scroll_text(current_song, MAX_TITLE_LEN)

    if not scrolling_title:
        return f"<span color='#1db954'>{left_bars}</span> <span color='#1db954'>{right_bars}</span>"
    else:
        return f"<span color='#1db954'>{left_bars}</span> <span color='#cdd6f4'>{scrolling_title}</span> <span color='#1db954'>{right_bars}</span>"

def main():
    # Start the robust background thread
    threading.Thread(target=track_music_background, daemon=True).start()

    config_path = "/tmp/waybar_cava_config"
    with open(config_path, "w") as f:
        f.write("[general]\nbars = 6\nframerate = 60\nautosens = 1\n"
                "[output]\nmethod = raw\nraw_target = /dev/stdout\n"
                "data_format = ascii\nascii_max_range = 7\n")

    try:
        cava_process = subprocess.Popen(['cava', '-p', config_path], stdout=subprocess.PIPE, text=True)
    except FileNotFoundError:
        print(json.dumps({"text": "Install Cava", "tooltip": "Run: sudo pacman -S cava"}), flush=True)
        sys.exit(1)

    last_window_update = 0

    # THE MASTER LOOP
    for line in cava_process.stdout:
        now = time.time()
        line_clean = line.strip()

        if is_music_playing:
            # If music is playing, ONLY show the Cava visualizer and song title!
            cava_text = format_cava_output(line_clean)
            print(json.dumps({"text": cava_text, "tooltip": "Click to Play/Pause", "class": "playing"}), flush=True)
        else:
            # If music is paused, stopped, OR the app is closed, show Active Window.
            # Rate-limited to 1 update per second to save CPU.
            if now - last_window_update >= 1.0:
                text, tooltip = get_active_window()
                print(json.dumps({"text": text, "tooltip": tooltip}), flush=True)
                last_window_update = now

if __name__ == "__main__":
    main()