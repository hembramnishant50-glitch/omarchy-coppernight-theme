#!/bin/bash
# Coppernight file manager color applier — run from inside ~/.config/omarchy/themes/coppernight
# Usage:  ./apply-filemanager.sh
# Applies background COLOR ONLY (#11111b) to Nautilus via filemanager-gtk.css,
# plus the coppernight Yazi flavor. Everything else stays at default.
# Existing gtk.css files are backed up to gtk.css.pre-coppernight (once).
set -e

THEME_DIR="$(cd "$(dirname "$0")" && pwd)"
GTK3="$HOME/.config/gtk-3.0/gtk.css"
GTK4="$HOME/.config/gtk-4.0/gtk.css"
SRC="$THEME_DIR/filemanager-gtk.css"
PASS=0
FAIL=0

ok()   { PASS=$((PASS + 1)); echo "  ✓ $1"; }
skip() { echo "  – $1 (skipped)"; }
warn() { FAIL=$((FAIL + 1)); echo "  ✗ $1"; }

echo "→ Coppernight file manager applier ($THEME_DIR)"

# 0. Preconditions
if [ ! -f "$SRC" ]; then
  echo "  ✗ filemanager-gtk.css missing in $THEME_DIR — aborting"
  exit 1
fi

# 1. Restage Omarchy theme (best effort; never blocks the rest)
if command -v omarchy >/dev/null 2>&1; then
  echo "→ omarchy theme set coppernight"
  if timeout 60 omarchy theme set coppernight; then
    ok "theme restaged"
  else
    warn "theme set failed/hung — continuing with file applies"
  fi
else
  skip "omarchy not found"
fi

# 2. GTK background color only (with one-time backup)
echo "→ GTK background color (#11111b)"
mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
for target in "$GTK3" "$GTK4"; do
  if [ -f "$target" ] && [ ! -f "$target.pre-coppernight" ] && ! cmp -s "$target" "$SRC"; then
    cp "$target" "$target.pre-coppernight" && ok "backed up $(basename "$(dirname "$target")")/gtk.css"
  fi
  if cp "$SRC" "$target"; then
    ok "applied $(basename "$(dirname "$target")")/gtk.css"
  else
    warn "could not write $target"
  fi
done

# 3. Reload Nautilus
if command -v nautilus >/dev/null 2>&1; then
  echo "→ reloading Nautilus"
  nautilus -q 2>/dev/null || true
  gsettings set org.gnome.desktop.interface gtk-theme "Adwaita" 2>/dev/null || true
  gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark" 2>/dev/null || true
  ok "nautilus reloaded"
else
  skip "nautilus not installed"
fi

# 4. Yazi flavor (terminal file manager, colors only)
if [ -f "$THEME_DIR/yazi-theme.toml" ]; then
  echo "→ Yazi flavor coppernight"
  mkdir -p "$HOME/.config/yazi/flavors/coppernight.yazi" "$HOME/.config/yazi"
  cp "$THEME_DIR/yazi-theme.toml" "$HOME/.config/yazi/flavors/coppernight.yazi/theme.toml" \
    && ok "flavor installed"
  if [ ! -f "$HOME/.config/yazi/theme.toml" ]; then
    printf '[flavor]\ndark = "coppernight"\n' > "$HOME/.config/yazi/theme.toml" \
      && ok "yazi now uses coppernight"
  elif grep -q 'coppernight' "$HOME/.config/yazi/theme.toml" 2>/dev/null; then
    ok "yazi already uses coppernight"
  elif grep -q '^\[flavor\]' "$HOME/.config/yazi/theme.toml"; then
    sed -i 's/^\s*dark\s*=.*/dark = "coppernight"/' "$HOME/.config/yazi/theme.toml" \
      && ok "yazi switched to coppernight"
  else
    printf '\n[flavor]\ndark = "coppernight"\n' >> "$HOME/.config/yazi/theme.toml" \
      && ok "yazi switched to coppernight"
  fi
else
  warn "yazi-theme.toml not found in $THEME_DIR"
fi

echo "— Summary: $PASS ok, $FAIL failed —"
echo "✓ Done — reopen Files to see #11111b. Run ./remove-gtk.sh to undo the GTK part."
