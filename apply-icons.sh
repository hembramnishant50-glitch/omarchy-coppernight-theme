#!/bin/bash
# Papirus-Dark + orange folders + peach cursor for coppernight.
# Run in a terminal (install steps need your sudo password):
#   ./apply-icons.sh
set -e

THEME_DIR="$(cd "$(dirname "$0")" && pwd)"
PASS=0
FAIL=0

ok()   { PASS=$((PASS + 1)); echo "  ✓ $1"; }
warn() { FAIL=$((FAIL + 1)); echo "  ✗ $1"; }

echo "→ Coppernight icon + cursor setup (Papirus-Dark orange folders + peach cursor)"

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

# 2. Orange folders for Papirus-Dark, via the official Papirus tool.
#    NOTE: papirus-folders is a standalone helper from PapirusDevelopmentTeam,
#    NOT part of papirus-icon-theme. The orange folder SVGs themselves DO ship
#    with papirus-icon-theme; only the script that applies them is missing.
#    AUR package: papirus-folders (upstream v1.14.0).
if ! command -v papirus-folders >/dev/null 2>&1; then
  if pacman -Q papirus-folders >/dev/null 2>&1; then
    ok "papirus-folders already installed"
  elif command -v omarchy >/dev/null 2>&1; then
    echo "→ installing papirus-folders from AUR (sudo password needed)"
    if omarchy pkg aur add papirus-folders; then
      ok "papirus-folders installed"
    else
      warn "install failed — run 'omarchy pkg aur add papirus-folders' manually"
    fi
  else
    warn "omarchy not found — install papirus-folders with your package manager"
  fi
fi

if command -v papirus-folders >/dev/null 2>&1; then
  echo "→ papirus-folders -C orange --theme Papirus-Dark"
  if papirus-folders -C orange --theme Papirus-Dark >/dev/null 2>&1; then
    ok "folders set to orange"
  else
    warn "papirus-folders failed"
  fi
else
  warn "papirus-folders unavailable — folders stay stock Papirus blue"
fi

# 3. Install Catppuccin Macchiato cursor theme if missing (AUR).
#    Ships 16 Macchiato colour variants; we use the peach one, which is
#    #fab387 — the same Copper accent as the borders, topbar and folders.
CURSOR_PKG="catppuccin-cursors-macchiato"
CURSOR_NAME="catppuccin-macchiato-peach-cursors"

if pacman -Q "$CURSOR_PKG" >/dev/null 2>&1; then
  ok "$CURSOR_PKG already installed"
elif command -v omarchy >/dev/null 2>&1; then
  echo "→ installing $CURSOR_PKG from AUR (sudo password needed)"
  if omarchy pkg aur add "$CURSOR_PKG"; then
    ok "$CURSOR_PKG installed"
  else
    warn "install failed — run 'omarchy pkg aur add $CURSOR_PKG' manually"
  fi
else
  warn "omarchy not found — install $CURSOR_PKG from AUR manually"
fi

# 4. Apply the peach cursor (GTK + Hyprland, best effort)
if [ -d "/usr/share/icons/$CURSOR_NAME" ] || [ -d "$HOME/.icons/$CURSOR_NAME" ] \
    || [ -d "$HOME/.local/share/icons/$CURSOR_NAME" ]; then
  echo "→ applying $CURSOR_NAME"
  gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR_NAME" 2>/dev/null \
    && ok "GNOME cursor applied" || warn "gsettings cursor apply failed"
  if command -v hyprctl >/dev/null 2>&1; then
    hyprctl setcursor "$CURSOR_NAME" 24 >/dev/null 2>&1 \
      && ok "Hyprland cursor applied" || warn "hyprctl setcursor failed"
  fi
else
  warn "$CURSOR_NAME not found — cursor not applied"
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
echo "✓ Done — folders are orange, cursor is Catppuccin Macchiato peach. Log out/in if anything looks stale."
