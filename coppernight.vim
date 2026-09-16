" Coppernight for Vim — deep indigo + glowing copper
" Install: copy to ~/.vim/colors/coppernight.vim, then :colorscheme coppernight
set background=dark
hi clear
if exists('syntax_on')
  syntax reset
endif
let g:colors_name = 'coppernight'

hi Normal       guifg=#cdd6f4 guibg=#11111b ctermfg=254 ctermbg=234
hi Comment      guifg=#a6adc8 gui=italic ctermfg=248 cterm=italic
hi Constant     guifg=#fab387 ctermfg=216
hi String       guifg=#a6e3a1 ctermfg=157
hi Character    guifg=#a6e3a1 ctermfg=157
hi Number       guifg=#fab387 ctermfg=216
hi Boolean      guifg=#fab387 ctermfg=216
hi Identifier   guifg=#cdd6f4 ctermfg=254
hi Function     guifg=#89b4fa gui=bold ctermfg=111 cterm=bold
hi Statement    guifg=#cba6f7 ctermfg=183
hi Conditional  guifg=#cba6f7 ctermfg=183
hi Repeat       guifg=#cba6f7 ctermfg=183
hi Label        guifg=#89b4fa ctermfg=111
hi Operator     guifg=#94e2d5 ctermfg=122
hi Keyword      guifg=#cba6f7 ctermfg=183
hi Exception    guifg=#f38ba8 ctermfg=211
hi PreProc      guifg=#f9e2af ctermfg=229
hi Include      guifg=#89b4fa ctermfg=111
hi Define       guifg=#cba6f7 ctermfg=183
hi Type         guifg=#f9e2af ctermfg=229
hi StorageClass guifg=#f9e2af ctermfg=229
hi Structure    guifg=#f9e2af ctermfg=229
hi Special      guifg=#94e2d5 ctermfg=122
hi SpecialChar  guifg=#cba6f7 ctermfg=183
hi Delimiter    guifg=#6c7086 ctermfg=242
hi Underlined   guifg=#89b4fa gui=underline ctermfg=111 cterm=underline
hi Error        guifg=#f38ba8 guibg=#11111b ctermfg=211 ctermbg=234
hi Todo         guifg=#fab387 guibg=#313244 gui=bold ctermfg=216 ctermbg=236 cterm=bold

hi Cursor       guifg=#11111b guibg=#f38ba8 ctermfg=234 ctermbg=211
hi CursorLine   guibg=#181825 ctermbg=236 cterm=NONE
hi CursorLineNr guifg=#fab387 gui=bold ctermfg=216 cterm=bold
hi LineNr       guifg=#a6adc8 guibg=#11111b ctermfg=248 ctermbg=234
hi CursorColumn guibg=#181825 ctermbg=236
hi ColorColumn  guibg=#181825 ctermbg=236
hi Visual       guibg=#313244 ctermbg=236
hi Search       guifg=#11111b guibg=#f9e2af ctermfg=234 ctermbg=229
hi IncSearch    guifg=#11111b guibg=#fab387 ctermfg=234 ctermbg=216
hi MatchParen   guifg=#fab387 guibg=#313244 gui=bold ctermfg=216 ctermbg=236 cterm=bold

hi StatusLine   guifg=#cdd6f4 guibg=#181825 ctermfg=254 ctermbg=236
hi StatusLineNC guifg=#6c7086 guibg=#0b0b12 ctermfg=242 ctermbg=233
hi VertSplit    guifg=#313244 guibg=#11111b ctermfg=236 ctermbg=234
hi TabLine      guifg=#6c7086 guibg=#0b0b12 ctermfg=242 ctermbg=233
hi TabLineFill  guibg=#0b0b12 ctermbg=233
hi TabLineSel   guifg=#fab387 guibg=#11111b gui=bold ctermfg=216 ctermbg=234 cterm=bold
hi WildMenu     guifg=#11111b guibg=#fab387 ctermfg=234 ctermbg=216
hi Pmenu        guifg=#cdd6f4 guibg=#181825 ctermfg=254 ctermbg=236
hi PmenuSel     guifg=#11111b guibg=#fab387 gui=bold ctermfg=234 ctermbg=216 cterm=bold
hi PmenuSbar    guibg=#313244 ctermbg=236
hi PmenuThumb   guibg=#fab387 ctermbg=216

hi DiffAdd      guifg=#a6e3a1 guibg=#181825 ctermfg=157 ctermbg=236
hi DiffChange   guifg=#f9e2af guibg=#181825 ctermfg=229 ctermbg=236
hi DiffDelete   guifg=#f38ba8 guibg=#181825 ctermfg=211 ctermbg=236
hi DiffText     guifg=#fab387 guibg=#313244 gui=bold ctermfg=216 ctermbg=236 cterm=bold
hi Folded       guifg=#a6adc8 guibg=#181825 ctermfg=248 ctermbg=236
hi FoldColumn   guifg=#585b70 guibg=#11111b ctermfg=240 ctermbg=234
hi SignColumn   guibg=#11111b ctermbg=234
hi SpellBad     guisp=#f38ba8 gui=undercurl ctermfg=211 cterm=underline
hi SpellCap     guisp=#f9e2af gui=undercurl ctermfg=229 cterm=underline
hi Directory    guifg=#89b4fa gui=bold ctermfg=111 cterm=bold
hi Title        guifg=#fab387 gui=bold ctermfg=216 cterm=bold
hi Question     guifg=#a6e3a1 ctermfg=157
hi MoreMsg      guifg=#a6e3a1 ctermfg=157
hi ModeMsg      guifg=#fab387 gui=bold ctermfg=216 cterm=bold
hi WarningMsg   guifg=#f9e2af ctermfg=229
hi ErrorMsg     guifg=#f38ba8 ctermfg=211
