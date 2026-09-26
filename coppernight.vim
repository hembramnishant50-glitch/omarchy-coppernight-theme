" Coppernight for Vim — deep indigo + glowing copper
" Install: copy to ~/.vim/colors/coppernight.vim, then :colorscheme coppernight
set background=dark
hi clear
if exists('syntax_on')
  syntax reset
endif
let g:colors_name = 'coppernight'

hi Normal       guifg=#cad3f5 guibg=#11111b ctermfg=254 ctermbg=234
hi Comment      guifg=#a5adcb gui=italic ctermfg=248 cterm=italic
hi Constant     guifg=#fab387 ctermfg=216
hi String       guifg=#a6da95 ctermfg=157
hi Character    guifg=#a6da95 ctermfg=157
hi Number       guifg=#fab387 ctermfg=216
hi Boolean      guifg=#fab387 ctermfg=216
hi Identifier   guifg=#cad3f5 ctermfg=254
hi Function     guifg=#8aadf4 gui=bold ctermfg=111 cterm=bold
hi Statement    guifg=#c6a0f6 ctermfg=183
hi Conditional  guifg=#c6a0f6 ctermfg=183
hi Repeat       guifg=#c6a0f6 ctermfg=183
hi Label        guifg=#8aadf4 ctermfg=111
hi Operator     guifg=#8bd5ca ctermfg=122
hi Keyword      guifg=#c6a0f6 ctermfg=183
hi Exception    guifg=#ed8796 ctermfg=211
hi PreProc      guifg=#eed49f ctermfg=229
hi Include      guifg=#8aadf4 ctermfg=111
hi Define       guifg=#c6a0f6 ctermfg=183
hi Type         guifg=#eed49f ctermfg=229
hi StorageClass guifg=#eed49f ctermfg=229
hi Structure    guifg=#eed49f ctermfg=229
hi Special      guifg=#8bd5ca ctermfg=122
hi SpecialChar  guifg=#c6a0f6 ctermfg=183
hi Delimiter    guifg=#6e738d ctermfg=242
hi Underlined   guifg=#8aadf4 gui=underline ctermfg=111 cterm=underline
hi Error        guifg=#ed8796 guibg=#11111b ctermfg=211 ctermbg=234
hi Todo         guifg=#fab387 guibg=#313244 gui=bold ctermfg=216 ctermbg=236 cterm=bold

hi Cursor       guifg=#11111b guibg=#ed8796 ctermfg=234 ctermbg=211
hi CursorLine   guibg=#181825 ctermbg=236 cterm=NONE
hi CursorLineNr guifg=#fab387 gui=bold ctermfg=216 cterm=bold
hi LineNr       guifg=#a5adcb guibg=#11111b ctermfg=248 ctermbg=234
hi CursorColumn guibg=#181825 ctermbg=236
hi ColorColumn  guibg=#181825 ctermbg=236
hi Visual       guibg=#313244 ctermbg=236
hi Search       guifg=#11111b guibg=#eed49f ctermfg=234 ctermbg=229
hi IncSearch    guifg=#11111b guibg=#fab387 ctermfg=234 ctermbg=216
hi MatchParen   guifg=#fab387 guibg=#313244 gui=bold ctermfg=216 ctermbg=236 cterm=bold

hi StatusLine   guifg=#cad3f5 guibg=#181825 ctermfg=254 ctermbg=236
hi StatusLineNC guifg=#6e738d guibg=#0b0b12 ctermfg=242 ctermbg=233
hi VertSplit    guifg=#313244 guibg=#11111b ctermfg=236 ctermbg=234
hi TabLine      guifg=#6e738d guibg=#0b0b12 ctermfg=242 ctermbg=233
hi TabLineFill  guibg=#0b0b12 ctermbg=233
hi TabLineSel   guifg=#fab387 guibg=#11111b gui=bold ctermfg=216 ctermbg=234 cterm=bold
hi WildMenu     guifg=#11111b guibg=#fab387 ctermfg=234 ctermbg=216
hi Pmenu        guifg=#cad3f5 guibg=#181825 ctermfg=254 ctermbg=236
hi PmenuSel     guifg=#11111b guibg=#fab387 gui=bold ctermfg=234 ctermbg=216 cterm=bold
hi PmenuSbar    guibg=#313244 ctermbg=236
hi PmenuThumb   guibg=#fab387 ctermbg=216

hi DiffAdd      guifg=#a6da95 guibg=#181825 ctermfg=157 ctermbg=236
hi DiffChange   guifg=#eed49f guibg=#181825 ctermfg=229 ctermbg=236
hi DiffDelete   guifg=#ed8796 guibg=#181825 ctermfg=211 ctermbg=236
hi DiffText     guifg=#fab387 guibg=#313244 gui=bold ctermfg=216 ctermbg=236 cterm=bold
hi Folded       guifg=#a5adcb guibg=#181825 ctermfg=248 ctermbg=236
hi FoldColumn   guifg=#5b6078 guibg=#11111b ctermfg=240 ctermbg=234
hi SignColumn   guibg=#11111b ctermbg=234
hi SpellBad     guisp=#ed8796 gui=undercurl ctermfg=211 cterm=underline
hi SpellCap     guisp=#eed49f gui=undercurl ctermfg=229 cterm=underline
hi Directory    guifg=#8aadf4 gui=bold ctermfg=111 cterm=bold
hi Title        guifg=#fab387 gui=bold ctermfg=216 cterm=bold
hi Question     guifg=#a6da95 ctermfg=157
hi MoreMsg      guifg=#a6da95 ctermfg=157
hi ModeMsg      guifg=#fab387 gui=bold ctermfg=216 cterm=bold
hi WarningMsg   guifg=#eed49f ctermfg=229
hi ErrorMsg     guifg=#ed8796 ctermfg=211
