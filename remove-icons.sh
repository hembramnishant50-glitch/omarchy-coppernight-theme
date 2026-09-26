#!/bin/bash
# Icon + cursor remover for coppernight — run from inside ~/.config/omarchy/themes/coppernight
# Usage:  ./remove-icons.sh
# Undoes what apply-icons.sh installed:
#   - resets icon theme to Yaru-dark (theme default) and removes Papirus,
#   - resets cursor to Adwaita and removes Bibata (optional).
# Run in a terminal (uninstall steps need your sudo password).
set -e

THEME_DIR="$(cd "$(dirname "$0")" && pwd)"
PASS=0
FAIL=0

ok()   { PASS=$((PASS + 1)); echo "  ✓ $1"; }
skip() { echo "  – $1 (skipped)"; }
warn() { FAIL=$((FAIL + 1)); echo "  ✗ $1"; }

echo "→ Coppernight icon + cursor remover"

# 1. Icons back to theme default (Yaru-dark)
echo "Yaru-dark" > "$THEME_DIR/icons.theme" && ok "icons.theme → Yaru-dark"
gsettings set org.gnome.desktop.interface icon-theme "Yaru-dark" 2>/dev/null \
  && ok "GNOME icon theme reset" || warn "gsettings icon reset failed"

read -r -p "Uninstall papirus-icon-theme? [y/N] " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
  if pacman -Q papirus-icon-theme >/dev/null 2>&1; then
    if sudo pacman -Rns --noconfirm papirus-icon-theme; then
      ok "papirus-icon-theme removed"
    else
      warn "could not remove papirus-icon-theme"
    fi
  else
    skip "papirus-icon-theme not installed"
  fi
else
  skip "keeping papirus-icon-theme"
fi

# 2. Cursor back to Adwaita
gsettings set org.gnome.desktop.interface cursor-theme "Adwaita" 2>/dev/null \
  && ok "GNOME cursor reset to Adwaita" || warn "gsettings cursor reset failed"
if command -v hyprctl >/dev/null 2>&1; then
  hyprctl setcursor Adwaita 24 >/dev/null 2>&1 \
    && ok "Hyprland cursor reset" || warn "hyprctl setcursor failed"
fi

read -r -p "Uninstall bibata-cursor-theme? [y/N] " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
  if pacman -Q bibata-cursor-theme >/dev/null 2>&1; then
    if sudo pacman -Rns --noconfirm bibata-cursor-theme; then
      ok "bibata-cursor-theme removed"
    else
      warn "could not remove bibata-cursor-theme"
    fi
  else
    skip "bibata-cursor-theme not installed"
  fi
else
  skip "keeping bibata-cursor-theme"
fi

echo "— Summary: $PASS ok, $FAIL failed —"
echo "✓ Done — icons and cursor are back to default. Log out/in if anything looks stale."
