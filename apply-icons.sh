#!/bin/bash
# Papirus-Dark + orange folders + Bibata-Modern-Amber cursor for coppernight.
# Run in a terminal (install steps need your sudo password):
#   ./apply-icons.sh
set -e

THEME_DIR="$(cd "$(dirname "$0")" && pwd)"
PASS=0
FAIL=0

ok()   { PASS=$((PASS + 1)); echo "  ✓ $1"; }
warn() { FAIL=$((FAIL + 1)); echo "  ✗ $1"; }

echo "→ Coppernight icon + cursor setup (Papirus-Dark orange folders, Bibata-Modern-Amber)"

# 1. Install Papirus icon theme if missing
if pacman -Q papirus-icon-theme >/dev/null 2>&1; then
  ok "papirus-icon-theme already installed"
elif command -v omarchy >/dev/null 2>&1; then
  echo "→ installing papirus-icon-theme (sudo password needed)"
  if omarchy pkg add papirus-icon-theme; then
    ok "papirus-icon-theme installed"
  else
    warn "install failed — run 'omarchy pkg add papirus-icon-theme' manually"
  fi
else
  warn "omarchy not found — install papirus-icon-theme with your package manager"
fi

# 2. Orange folders for Papirus-Dark
if command -v papirus-folders >/dev/null 2>&1; then
  echo "→ papirus-folders -C orange --theme Papirus-Dark"
  if papirus-folders -C orange --theme Papirus-Dark >/dev/null 2>&1; then
    ok "folders set to orange"
  else
    warn "papirus-folders failed"
  fi
else
  warn "papirus-folders not found (comes with papirus-icon-theme)"
fi

# 3. Install Bibata cursor theme if missing (AUR)
if pacman -Q bibata-cursor-theme >/dev/null 2>&1; then
  ok "bibata-cursor-theme already installed"
elif command -v omarchy >/dev/null 2>&1; then
  echo "→ installing bibata-cursor-theme from AUR (sudo password needed)"
  if omarchy pkg aur add bibata-cursor-theme; then
    ok "bibata-cursor-theme installed"
  else
    warn "install failed — run 'omarchy pkg aur add bibata-cursor-theme' manually"
  fi
else
  warn "omarchy not found — install bibata-cursor-theme from AUR manually"
fi

# 4. Apply Bibata-Modern-Amber cursor (GTK + Hyprland, best effort)
if [ -d /usr/share/icons/Bibata-Modern-Amber ] || [ -d "$HOME/.icons/Bibata-Modern-Amber" ] \
    || [ -d "$HOME/.local/share/icons/Bibata-Modern-Amber" ]; then
  echo "→ applying Bibata-Modern-Amber cursor"
  gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Amber" 2>/dev/null \
    && ok "GNOME cursor applied" || warn "gsettings cursor apply failed"
  if command -v hyprctl >/dev/null 2>&1; then
    hyprctl setcursor Bibata-Modern-Amber 24 >/dev/null 2>&1 \
      && ok "Hyprland cursor applied" || warn "hyprctl setcursor failed"
  fi
else
  warn "Bibata-Modern-Amber not found — cursor not applied"
fi

# 5. Point this theme at Papirus-Dark
echo "Papirus-Dark" > "$THEME_DIR/icons.theme" && ok "icons.theme → Papirus-Dark"

# 6. Apply now (best effort each step)
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark" 2>/dev/null \
  && ok "GNOME icon theme applied" || warn "gsettings apply failed"
if command -v omarchy >/dev/null 2>&1; then
  timeout 60 omarchy theme set coppernight >/dev/null 2>&1 \
    && ok "omarchy theme restaged" || warn "theme restage skipped/failed (harmless)"
fi

echo "— Summary: $PASS ok, $FAIL failed —"
echo "✓ Done — folders should now be orange Papirus-Dark. Log out/in if icons look stale."
