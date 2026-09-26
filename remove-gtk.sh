#!/bin/bash
# Coppernight GTK remover — run from inside ~/.config/omarchy/themes/coppernight
# Usage:  ./remove-gtk.sh
# Undoes what apply-filemanager.sh did to GTK:
#   - restores gtk.css.pre-coppernight backups if they exist,
#   - otherwise deletes the applied gtk.css (back to default: no override),
#   - reloads Nautilus.
# Yazi flavor is left untouched (colors only, harmless).
set -e

GTK3="$HOME/.config/gtk-3.0/gtk.css"
GTK4="$HOME/.config/gtk-4.0/gtk.css"
PASS=0
FAIL=0

ok()   { PASS=$((PASS + 1)); echo "  ✓ $1"; }
skip() { echo "  – $1 (skipped)"; }
warn() { FAIL=$((FAIL + 1)); echo "  ✗ $1"; }

echo "→ Coppernight GTK remover"

for target in "$GTK3" "$GTK4"; do
  where="$(basename "$(dirname "$target")")/gtk.css"
  if [ -f "$target.pre-coppernight" ]; then
    if mv "$target.pre-coppernight" "$target"; then
      ok "restored backup for $where"
    else
      warn "could not restore backup for $where"
    fi
  elif [ -f "$target" ]; then
    if rm "$target"; then
      ok "removed $where (back to default)"
    else
      warn "could not remove $target"
    fi
    # tidy up empty dirs left behind
    rmdir "$(dirname "$target")" 2>/dev/null || true
  else
    skip "$where already at default"
  fi
done

if command -v nautilus >/dev/null 2>&1; then
  echo "→ reloading Nautilus"
  nautilus -q 2>/dev/null || true
  gsettings set org.gnome.desktop.interface gtk-theme "Adwaita" 2>/dev/null || true
  gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark" 2>/dev/null || true
  ok "nautilus reloaded"
else
  skip "nautilus not installed"
fi

echo "— Summary: $PASS ok, $FAIL failed —"
echo "✓ Done — file manager GTK is back to default. Reopen Files to see."
