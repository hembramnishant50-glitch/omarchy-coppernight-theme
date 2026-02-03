local M = {
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = function()
                vim.cmd("set termguicolors")

                local colors = {
                    bg        = "#11111b", -- Updated: Catppuccin Mocha Base
                    fg        = "#e6e6e6", -- Text
                    border    = "#fab387", -- Clock Orange (Waybar Border)
                    primary   = "#89b4fa", -- Menu Blue
                    secondary = "#a6e3a1", -- Workspace Green
                    accent    = "#f38ba8", -- Active Workspace Pink
                    purple    = "#cba6f7", -- Mauve
                    danger    = "#f38ba8", -- Red/Pink
                    warning   = "#f9e2af", -- Yellow
                    info      = "#94e2d5", -- Teal
                    muted     = "#6c7086", -- Grey
                    dark      = "#0b0b12", -- Darker shade for contrast in Floats
                    selection = "#313244", -- Selection grey
                    subtle    = "#181825", -- Subtle bg
                }

                vim.cmd("highlight clear")

                local function set_hl(group, opts)
                    vim.api.nvim_set_hl(0, group, opts)
                end

                -- Main UI
                set_hl("Normal", { fg = colors.fg, bg = colors.bg })
                set_hl("NormalFloat", { fg = colors.fg, bg = colors.dark })
                set_hl("FloatBorder", { fg = colors.border, bg = colors.bg })
                set_hl("WinSeparator", { fg = colors.border }) -- Orange split lines
                set_hl("CursorLine", { bg = colors.subtle })   -- Uses subtle for a faint highlight
                set_hl("LineNr", { fg = colors.muted })
                set_hl("CursorLineNr", { fg = colors.accent, bold = true }) -- Pink current line
                set_hl("Visual", { bg = colors.selection })
                set_hl("Search", { fg = colors.bg, bg = colors.primary }) -- Blue search

                -- Syntax (Matched to Omarchy Colors)
                set_hl("Comment", { fg = colors.muted, italic = true })
                set_hl("Keyword", { fg = colors.accent, bold = true }) -- Pink Keywords
                set_hl("Function", { fg = colors.primary, bold = true }) -- Blue Functions
                set_hl("String", { fg = colors.secondary }) -- Green Strings
                set_hl("Constant", { fg = colors.purple })
                set_hl("Number", { fg = colors.warning })
                set_hl("Type", { fg = colors.warning })
                set_hl("Operator", { fg = colors.info })
                set_hl("Identifier", { fg = colors.fg })
                set_hl("Statement", { fg = colors.accent })

                -- Pmenu (Completions)
                set_hl("Pmenu", { fg = colors.fg, bg = colors.dark })
                set_hl("PmenuSel", { fg = colors.bg, bg = colors.secondary }) -- Green selection

                -- Diagnostics
                set_hl("DiagnosticError", { fg = colors.danger })
                set_hl("DiagnosticWarn", { fg = colors.warning })
                set_hl("DiagnosticInfo", { fg = colors.info })
                set_hl("DiagnosticHint", { fg = colors.muted })

                -- Treesitter Links
                set_hl("@variable", { fg = colors.fg })
                set_hl("@property", { fg = colors.info })
                set_hl("@parameter", { fg = colors.warning, italic = true })
                set_hl("@constructor", { fg = colors.primary })
                set_hl("@tag", { fg = colors.accent })
                set_hl("@tag.delimiter", { fg = colors.muted })

                vim.g.colors_name = "omarchy"
            end,
        },
    },
}

return M