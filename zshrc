# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# ---------- Oh My Zsh ----------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="" # starship renders the prompt
plugins=(git sudo)
source "$ZSH/oh-my-zsh.sh"

# ---------- History ----------
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# ---------- Omarchy env ----------
export OMARCHY_PATH=$HOME/.local/share/omarchy
export PATH=$OMARCHY_PATH/bin:$PATH:$HOME/.local/bin
export SUDO_EDITOR="${EDITOR:-nvim}"
export BAT_THEME=ansi
export MANROFFOPT="-c"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# ---------- Autosuggestions + syntax highlighting ----------
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# ---------- fzf ----------
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# ---------- oh-my-posh prompt ----------
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/amro.omp.json)"

# ---------- zoxide ----------
eval "$(zoxide init zsh)"
cd() {
  if (( $# == 0 )); then
    builtin cd ~ || return
  elif [[ -d $1 ]]; then
    builtin cd "$1" || return
  else
    if ! z "$@"; then
      echo "Error: Directory not found"
      return 1
    fi
    printf "\U000F17A9 "
    pwd
  fi
}

# ---------- mise ----------
if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi

# ---------- fastfetch (once per session) ----------
if [[ ! -f "$HOME/.cache/fastfetch_done" ]]; then
  fastfetch
  mkdir -p "$HOME/.cache"
  touch "$HOME/.cache/fastfetch_done"
fi

# ---------- aichat shell assistant ----------
ai() { aichat "$@"; }

# ---------- Aliases / functions (ported from omarchy) ----------
alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'

if [[ "$TERM" == "xterm-kitty" ]]; then
  ff() { fzf --preview 'case $(file --mime-type -b {}) in image/*) kitty icat --clear --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0 {} ;; *) bat --style=numbers --color=always {} ;; esac'; }
else
  ff() { fzf --preview 'bat --style=numbers --color=always {}'; }
fi
alias eff='$EDITOR "$(ff)"'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias c='opencode'
alias d='docker'
alias t='tmux attach || tmux new -s Work'

n() { if [ "$#" -eq 0 ]; then command nvim .; else command nvim "$@"; fi; }

alias g='git'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
gcad() { git commit -a --amend "$@"; }

# >>> Android Studio >>>
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"
# <<< Android Studio <<<
