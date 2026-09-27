#!/bin/bash
# Coppernight fastfetch remover.
# Run from inside ~/.config/omarchy/themes/coppernight:
#   ./remove-fastfetch.sh              # remove the config only
#   ./remove-fastfetch.sh --uninstall  # config + uninstall the fastfetch package
#
# Restores ~/.config/fastfetch/*.pre-coppernight when the backups exist, and
# deletes the applied files otherwise (fastfetch then falls back to its
# built-in default). The directory itself is left alone unless it ends up
# empty, so an unrelated config of yours is never destroyed.
set -e

DEST="$HOME/.config/fastfetch"
UNINSTALL=0
PASS=0
FAIL=0

for arg in "$@"; do
  case "$arg" in
    --uninstall) UNINSTALL=1 ;;
    -h|--help)
      echo "Usage: ./remove-fastfetch.sh [--uninstall]"
      echo "  (no flag)   remove/restore the fastfetch config files"
      echo "  --uninstall also run 'pacman -Rns fastfetch'"
      exit 0
      ;;
    *)
      echo "Unknown option: $arg" >&2
      echo "Usage: ./remove-fastfetch.sh [--uninstall]" >&2
      exit 2
      ;;
  esac
done

ok()   { PASS=$((PASS + 1)); echo "  ✓ $1"; }
skip() { echo "  – $1 (skipped)"; }
warn() { FAIL=$((FAIL + 1)); echo "  ✗ $1"; }

echo "→ Coppernight fastfetch remover"

if [ ! -d "$DEST" ]; then
  skip "$DEST does not exist — nothing to remove"
else
  # Restore-or-delete, same rule as remove-gtk.sh.
  for name in config.jsonc 1.png; do
    target="$DEST/$name"
    backup="$target.pre-coppernight"
    if [ -f "$backup" ]; then
      if mv "$backup" "$target"; then
        ok "restored backup for $name"
      else
        warn "could not restore $backup"
      fi
    elif [ -f "$target" ]; then
      if rm "$target"; then
        ok "removed $name (fastfetch back to its default)"
      else
        warn "could not remove $target"
      fi
    else
      skip "$name already gone"
    fi
  done

  # Only tidy the directory if we emptied it. fastfetch.jsonc lives in the same
  # place when a user configures fastfetch by hand — leave it be.
  rmdir "$DEST" 2>/dev/null && ok "removed empty $DEST" || skip "$DEST still has files, kept"
fi

# Optional: uninstall the package too. Only with the explicit flag.
if [ "$UNINSTALL" -eq 1 ]; then
  echo "→ uninstalling fastfetch (sudo password needed)"
  if pacman -Q fastfetch >/dev/null 2>&1; then
    if sudo pacman -Rns --noconfirm fastfetch; then
      ok "fastfetch uninstalled"
    else
      warn "pacman could not remove fastfetch — try 'sudo pacman -Rns fastfetch'"
    fi
  else
    skip "fastfetch is not installed"
  fi
else
  skip "package left installed (pass --uninstall to remove it)"
fi

echo "— Summary: $PASS ok, $FAIL failed —"
if [ "$UNINSTALL" -eq 1 ]; then
  echo "✓ Done — config gone and fastfetch removed. 'fastfetch' is no longer available."
else
  echo "✓ Done — fastfetch is back to its default. Pass --uninstall to remove the package too."
fi
