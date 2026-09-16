# Coppernight terminal colors — bash/zsh
# Install: copy to ~/.config/opencode/themes/ as coppernight.json is for opencode;
# for shells, source this file from ~/.zshrc or ~/.bashrc:
#   source ~/.config/omarchy/themes/coppernight/terminal-colors.sh

# fzf — coppernight palette
export FZF_DEFAULT_OPTS="--color=bg:#11111b,bg+:#313244,fg:#cdd6f4,fg+:#cdd6f4,header:#fab387,hl:#fab387,hl+:#fab387,pointer:#fab387,marker:#a6e3a1,prompt:#fab387,spinner:#cba6f7,info:#a6adc8,border:#585b70,separator:#585b70,scrollbar:#585b70,gutter:#11111b,query:#cdd6f4 --pointer=❯ --marker=✓ --border=rounded --highlight-line"

# eza — copper dirs, mauve links, green executables
export EZA_COLORS="di=1;38;2;250;179;135:ln=38;2;203;166;247:ex=1;38;2;166;227;161:fi=38;2;205;214;244:pi=38;2;249;226;175:so=38;2;245;194;231:bd=38;2;249;226;175:cd=38;2;249;226;175:or=1;38;2;243;139;168:mi=1;38;2;243;139;168:tw=1;38;2;250;179;135:ow=1;38;2;250;179;135:st=38;2;250;179;135:su=1;38;2;243;139;168:sg=1;38;2;249;226;175:ca=38;2;148;226;213:mh=38;2;166;227;161:sn=38;2;166;173;200:sb=38;2;88;91;112:nb=38;2;250;179;135:nk=38;2;148;226;213:uu=38;2;205;214;244:un=38;2;137;180;250:gu=38;2;205;214;244:gn=38;2;137;180;250:da=38;2;166;173;200"

# ls fallback
export LS_COLORS="di=1;38;2;250;179;135:ln=38;2;203;166;247:ex=1;38;2;166;227;161:fi=38;2;205;214;244:pi=38;2;249;226;175:so=38;2;245;194;231:bd=38;2;249;226;175:cd=38;2;249;226;175:or=1;38;2;243;139;168:mi=1;38;2;243;139;168:tw=1;38;2;250;179;135:ow=1;38;2;250;179;135:st=38;2;250;179;135"

# bat — use the Coppernight tmTheme from this theme dir
export BAT_THEME="Coppernight"
