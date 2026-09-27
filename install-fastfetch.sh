#!/bin/bash
# Coppernight fastfetch installer.
# Run in a terminal (install step needs your sudo password):
#   ./install-fastfetch.sh
#
# Copies this theme's fastfetch/ into ~/.config/fastfetch/, backing up
# whatever is already there as *.pre-coppernight. fastfetch only reads a
# config when it lives at ~/.config/fastfetch/{fastfetch,config}.jsonc,
# so the files are copied rather than symlinked — the theme folder can move
# and fastfetch keeps working.
set -e

THEME_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="$THEME_DIR/fastfetch"
DEST="$HOME/.config/fastfetch"
PASS=0
FAIL=0

ok()   { PASS=$((PASS + 1)); echo "  ✓ $1"; }
skip() { echo "  – $1 (skipped)"; }
warn() { FAIL=$((FAIL + 1)); echo "  ✗ $1"; }

echo "→ Coppernight fastfetch setup"

if [ ! -d "$SRC" ] || [ ! -f "$SRC/config.jsonc" ]; then
  warn "no config.jsonc in $SRC — is the theme folder complete?"
  echo "— Summary: $PASS ok, $FAIL failed —"
  exit 1
fi

# 1. Install fastfetch if missing. It is in the pacman 'extra' repo, so no
#    AUR helper is needed — omarchy pkg add keeps it consistent with the
#    rest of the system, plain pacman is the fallback.
if command -v fastfetch >/dev/null 2>&1; then
  ok "fastfetch already installed"
else
  echo "→ installing fastfetch (sudo password needed)"
  if command -v omarchy >/dev/null 2>&1 && omarchy pkg add fastfetch; then
    ok "fastfetch installed"
  elif sudo pacman -S --needed --noconfirm fastfetch; then
    ok "fastfetch installed"
  else
    warn "install failed — run 'omarchy pkg add fastfetch' manually"
  fi
fi

# 2. Install the config files.
mkdir -p "$DEST"

install_file() {
  local from="$1" to="$DEST/$2"
  # Back up once, so a second run does not overwrite the original with an
  # already-overwritten copy.
  if [ -f "$to" ] && [ ! -f "$to.pre-coppernight" ]; then
    cp "$to" "$to.pre-coppernight" && ok "backed up $2.pre-coppernight"
  fi
  if cp "$from" "$to"; then
    ok "installed $2"
  else
    warn "could not install $2"
  fi
}

install_file "$SRC/config.jsonc" "config.jsonc"
# The logo is referenced by absolute path from the config, so it has to sit
# next to it. Skip 1.png entirely if the config has no local logo source.
if grep -q '~/.config/fastfetch/1.png' "$SRC/config.jsonc"; then
  if [ -f "$SRC/1.png" ]; then
    install_file "$SRC/1.png" "1.png"
  else
    warn "1.png missing from $SRC — fastfetch will draw a placeholder logo"
  fi
else
  skip "1.png (config uses an external logo source)"
fi

# 3. Sanity check what we just wrote.
if [ -f "$DEST/config.jsonc" ]; then
  ok "~/.config/fastfetch/config.jsonc in place"
else
  warn "config.jsonc not found in $DEST"
fi

if command -v fastfetch >/dev/null 2>&1; then
  echo
  echo "→ preview"
  fastfetch 2>&1 | head -20 || true
  echo
fi

echo "— Summary: $PASS ok, $FAIL failed —"
echo "✓ Done — run 'fastfetch' any time. The config stays in ~/.config/fastfetch/."
