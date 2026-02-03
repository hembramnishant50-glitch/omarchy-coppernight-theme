import subprocess
import json
import hashlib
import random
import re  # <--- ADDED THIS FOR REMOVING (33)

# --- CONFIGURATION ---
MAX_TITLE_LEN = 35 

# --- MUSIC FILTER ---
MUSIC_PLAYERS = ["spotify", "ncspot", "cider", "rhythmbox", "vlc", "mpv", "music"]
MUSIC_WEB_KEYWORDS = ["spotify", "soundcloud", "music", "deezer", "bandcamp"]

# --- APP & WEBSITE MAP ---
APP_MAP = {
    # --- 1. USER FAVORITES & AI ---
    "careerwill": ("🎓", "#ff9900", "Careerwill"),
    "chatgpt":    ("󰚩", "#74aa9c", "ChatGPT"),
    "gemini":     ("", "#8ab4f8", "Gemini AI"),
    "claude":     ("", "#d97757", "Claude AI"),
    "bing":       ("", "#2583c6", "Bing Chat"),
    "perplexity": ("󰚩", "#2ebfab", "Perplexity"),

    # --- 2. TOP SOCIAL MEDIA ---
    "reddit":     ("", "#ff4500", "Reddit"),
    "twitter":    ("", "#1da1f2", "Twitter"),
    "x.com":      ("", "#000000", "X"), 
    "facebook":   ("", "#1877f2", "Facebook"),
    "instagram":  ("", "#c13584", "Instagram"),
    "linkedin":   ("", "#0077b5", "LinkedIn"),
    "discord":    ("", "#5865f2", "Discord"),
    "whatsapp":   ("", "#25d366", "WhatsApp"),
    "telegram":   ("", "#24a1de", "Telegram"),
    "pinterest":  ("", "#bd081c", "Pinterest"),
    "tumblr":     ("", "#35465c", "Tumblr"),
    "tiktok":     ("", "#ff0050", "TikTok"),

    # --- 3. VIDEO & STREAMING ---
    "youtube":    ("", "#ff0000", "YouTube"),
    "twitch":     ("", "#9146ff", "Twitch"),
    "netflix":    ("󰝆", "#e50914", "Netflix"),
    "hulu":       ("󰝆", "#1ce783", "Hulu"),
    "prime video":("󰝆", "#00a8e1", "Prime Video"),
    "disney":     ("󰝆", "#113ccf", "Disney+"),
    "spotify":    ("", "#1db954", "Spotify"),
    "soundcloud": ("", "#ff5500", "SoundCloud"),

    # --- 4. DEV & TECH SITES ---
    "github":     ("", "#ffffff", "GitHub"),
    "gitlab":     ("", "#fc6d26", "GitLab"),
    "stackoverflow":("", "#f48024", "StackOverflow"),
    "arch linux": ("", "#1793d1", "Arch Wiki"),
    "wikipedia":  ("", "#ffffff", "Wikipedia"),
    "w3schools":  ("", "#04aa6d", "W3Schools"),
    "mdn":        ("", "#000000", "MDN Web Docs"),
    "kaggle":     ("", "#20beff", "Kaggle"),
    "leetcode":   ("", "#ffa116", "LeetCode"),
    "localhost":  ("", "#00ff00", "Localhost"),

    # --- 5. PRODUCTIVITY & TOOLS ---
    "gmail":      ("", "#ea4335", "Gmail"),
    "outlook":    ("", "#0078d4", "Outlook"),
    "google drive":("", "#1ea362", "Drive"),
    "notion":     ("", "#000000", "Notion"),
    "trello":     ("", "#0079bf", "Trello"),
    "figma":      ("", "#f24e1e", "Figma"),
    "canva":      ("", "#00c4cc", "Canva"),
    "dropbox":    ("", "#0061ff", "Dropbox"),
    "zoom":       ("", "#2d8cff", "Zoom"),
    "meet.google":("", "#00897b", "Google Meet"),

    # --- 6. SHOPPING ---
    "amazon":     ("", "#ff9900", "Amazon"),
    "ebay":       ("", "#e53238", "eBay"),
    "aliexpress": ("", "#ff4747", "AliExpress"),
    "flipkart":   ("", "#2874f0", "Flipkart"),

    # --- 7. BROWSERS ---
    "firefox":    ("", "#ff9500", "Firefox"),
    "zen":        ("", "#ffffff", "Zen Browser"),
    "chrome":     ("", "#4285f4", "Google Chrome"),
    "chromium":   ("", "#2b569a", "Chromium"),
    "brave":      ("🦁", "#ff3300", "Brave"),
    "edge":       ("", "#0078d7", "Edge"),
    "opera":      ("", "#ff1b2d", "Opera"),
    "vivaldi":    ("", "#ef3939", "Vivaldi"),
    "tor":        ("", "#7d4698", "Tor Browser"),

    # --- 8. SYSTEM APPS ---
    "ghostty":    ("", "#cba6f7", "Ghostty"),
    "kitty":      ("", "#cba6f7", "Kitty"),
    "alacritty":  ("", "#f9e2af", "Alacritty"),
    "code":       ("󰨞", "#007acc", "VS Code"),
    "nautilus":   ("", "#f2c94c", "Files"),
    "dolphin":    ("", "#3daee9", "Dolphin"),
    "thunar":     ("", "#a9b665", "Thunar"),
    "vlc":        ("󰕼", "#ff9900", "VLC"),
    "obs":        ("", "#262626", "OBS Studio"),
    "steam":      ("", "#1b2838", "Steam"),
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
                
                # --- NEW: REMOVE NOTIFICATION COUNTS like (33) or (1) ---
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
        
        if "gnome" in raw_class: icon = ""
        elif "kde" in raw_class: icon = ""
        else: icon = ""

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
