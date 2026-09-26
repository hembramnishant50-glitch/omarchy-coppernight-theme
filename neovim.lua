return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = {
      style = "night",
      transparent = false,
      styles = {
        sidebars = "dark",
        floats = "dark",
      },
      -- Keep the dark background, remap everything else to coppernight brights
      on_colors = function(colors)
        colors.bg = "#11111b"
        colors.bg_dark = "#0b0b12"
        colors.bg_float = "#181825"
        colors.bg_sidebar = "#181825"
        colors.bg_popup = "#181825"
        colors.bg_search = "#313244"
        colors.fg = "#cad3f5"
        colors.fg_dark = "#b8c0e0"
        colors.fg_gutter = "#a5adcb"
        colors.blue = "#8aadf4"
        colors.green = "#a6da95"
        colors.yellow = "#eed49f"
        colors.orange = "#fab387"
        colors.red = "#ed8796"
        colors.magenta = "#c6a0f6"
        colors.cyan = "#8bd5ca"
        colors.purple = "#c6a0f6"
        colors.teal = "#8bd5ca"
        colors.comment = "#a5adcb"
        colors.border = "#fab387"
      end,
      -- Bright, colourful file names + text, dark background untouched
      on_highlights = function(hl, c)
        -- Core directory / file name groups (netrw, generic)
        hl.Directory = { fg = c.blue, bold = true }

        -- Comments / line numbers: bright, never dim grey
        hl.Comment = { fg = "#a5adcb", italic = true }
        hl.LineNr = { fg = "#a5adcb" }
        hl.CursorLineNr = { fg = c.orange, bold = true }

        -- Neo-tree (if installed later)
        hl.NeoTreeFileName = { fg = c.fg }
        hl.NeoTreeFileNameOpened = { fg = c.orange, bold = true }
        hl.NeoTreeDirectoryName = { fg = c.blue, bold = true }
        hl.NeoTreeDirectoryIcon = { fg = c.orange }
        hl.NeoTreeFileIcon = { fg = c.cyan }
        hl.NeoTreeRootName = { fg = c.magenta, bold = true }

        -- nvim-tree (if installed later)
        hl.NvimTreeFileName = { fg = c.fg }
        hl.NvimTreeFolderName = { fg = c.blue, bold = true }
        hl.NvimTreeFolderIcon = { fg = c.orange }
        hl.NvimTreeRootFolder = { fg = c.magenta, bold = true }
        hl.NvimTreeOpenedFile = { fg = c.orange, bold = true }

        -- Snacks picker + explorer (LazyVim default)
        hl.SnacksPickerDir = { fg = c.blue, bold = true }
        hl.SnacksPickerFile = { fg = c.fg, bold = true }
        hl.SnacksPickerPathHidden = { fg = "#a5adcb" }
        hl.SnacksPickerTitle = { fg = c.orange, bold = true }
        hl.SnacksPickerPrompt = { fg = c.orange, bold = true }
        hl.SnacksPickerMatch = { fg = c.orange, bold = true }
        hl.SnacksExplorerDirectory = { fg = c.blue, bold = true }
        hl.SnacksExplorerFile = { fg = c.fg }

        -- Telescope
        hl.TelescopeNormal = { fg = c.fg }
        hl.TelescopeBorder = { fg = c.orange }
        hl.TelescopePromptPrefix = { fg = c.red, bold = true }
        hl.TelescopePromptTitle = { fg = c.orange, bold = true }
        hl.TelescopeResultsTitle = { fg = c.green, bold = true }
        hl.TelescopePreviewTitle = { fg = c.blue, bold = true }
        hl.TelescopeSelection = { bg = c.bg_search, fg = c.fg, bold = true }
        hl.TelescopeMatching = { fg = c.orange, bold = true }

        -- mini.files / oil
        hl.MiniFilesTitle = { fg = c.orange, bold = true }
        hl.MiniFilesNormal = { fg = c.fg }
        hl.MiniFilesDirectory = { fg = c.blue, bold = true }
        hl.MiniFilesFile = { fg = c.fg }
        hl.OilDir = { fg = c.blue, bold = true }
        hl.OilFile = { fg = c.fg }

        -- Winbar breadcrumbs: colourful per symbol kind
        hl.NavicText = { fg = c.fg, bold = true }
        hl.NavicIconsFile = { fg = c.blue }
        hl.NavicIconsDirectory = { fg = c.blue }
        hl.NavicIconsFunction = { fg = c.magenta }
        hl.NavicIconsMethod = { fg = c.magenta }
        hl.NavicIconsClass = { fg = c.yellow }
        hl.NavicIconsVariable = { fg = c.cyan }
        hl.NavicIconsConstant = { fg = c.orange }
        hl.NavicIconsString = { fg = c.green }
        hl.NavicIconsKeyword = { fg = c.red }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },
}
