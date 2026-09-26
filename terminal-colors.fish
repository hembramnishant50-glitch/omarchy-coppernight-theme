# Coppernight terminal colors — fish
# Install: source from ~/.config/fish/config.fish:
#   source ~/.config/omarchy/themes/coppernight/terminal-colors.fish

# fzf — coppernight palette
set -gx FZF_DEFAULT_OPTS "--color=bg:#11111b,bg+:#313244,fg:#cad3f5,fg+:#cad3f5,header:#fab387,hl:#fab387,hl+:#fab387,pointer:#fab387,marker:#a6da95,prompt:#fab387,spinner:#c6a0f6,info:#a5adcb,border:#5b6078,separator:#5b6078,scrollbar:#5b6078,gutter:#11111b,query:#cad3f5 --pointer=❯ --marker=✓ --border=rounded --highlight-line"

# eza — copper dirs, mauve links, green executables
set -gx EZA_COLORS "di=1;38;2;250;179;135:ln=38;2;198;160;246:ex=1;38;2;166;218;149:fi=38;2;202;211;245:pi=38;2;238;212;159:so=38;2;245;189;230:bd=38;2;238;212;159:cd=38;2;238;212;159:or=1;38;2;237;135;150:mi=1;38;2;237;135;150:tw=1;38;2;250;179;135:ow=1;38;2;250;179;135:st=38;2;250;179;135:su=1;38;2;237;135;150:sg=1;38;2;238;212;159:ca=38;2;139;213;202:mh=38;2;166;218;149:sn=38;2;165;173;203:sb=38;2;91;96;120:nb=38;2;250;179;135:nk=38;2;139;213;202:uu=38;2;202;211;245:un=38;2;138;173;244:gu=38;2;202;211;245:gn=38;2;138;173;244:da=38;2;165;173;203"

# ls fallback
set -gx LS_COLORS "di=1;38;2;250;179;135:ln=38;2;198;160;246:ex=1;38;2;166;218;149:fi=38;2;202;211;245:pi=38;2;238;212;159:so=38;2;245;189;230:bd=38;2;238;212;159:cd=38;2;238;212;159:or=1;38;2;237;135;150:mi=1;38;2;237;135;150:tw=1;38;2;250;179;135:ow=1;38;2;250;179;135:st=38;2;250;179;135"

# bat — use the Coppernight tmTheme from this theme dir
set -gx BAT_THEME "Coppernight"
