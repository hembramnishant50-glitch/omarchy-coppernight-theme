# ---------- Omarchy env ----------
set -gx OMARCHY_PATH $HOME/.local/share/omarchy
set -gx PATH $OMARCHY_PATH/bin $PATH $HOME/.local/bin
set -gx BAT_THEME ansi
set -gx MANROFFOPT -c

# ---------- oh-my-posh prompt ----------
oh-my-posh init fish --config ~/.config/oh-my-posh/amro.omp.json | source

# ---------- zoxide ----------
zoxide init fish | source
function cd
    if test (count $argv) -eq 0
        builtin cd $HOME
    else if test -d $argv[1]
        builtin cd $argv[1]
    else
        __zoxide_z $argv
    end
end

# ---------- mise ----------
mise activate fish | source

# ---------- fzf (Ctrl-R history, Ctrl-T files) ----------
fzf --fish | source

# ---------- fastfetch (once per session) ----------
if not test -f $HOME/.cache/fastfetch_done
    fastfetch
    mkdir -p $HOME/.cache
    touch $HOME/.cache/fastfetch_done
end

# ---------- aichat shell assistant ----------
function ai
    aichat $argv
end

# ---------- Aliases / functions (ported from omarchy) ----------
alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'

function ff
    fzf --preview 'bat --style=numbers --color=always {}'
end

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias c='opencode'
alias d='docker'
alias t='tmux attach || tmux new -s Work'

function n
    if test (count $argv) -eq 0
        command nvim .
    else
        command nvim $argv
    end
end

alias g='git'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
