--OPTIONAL: FOR USE WITH LAZY! Also for some fucking reason absolutely INSISTS upon opening 
--when switching to visual mode. 
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    -- make key-hints responsive but not jumpy

    local wk = require("which-key")
    wk.setup({
      opts = {
          triggers = {
            {"<leader>", mode = {"n", "v",},},
            {"g", mode = {"n", "v",},},
        },
      },
      icons = {
        breadcrumb = ">>",   -- top line path
        separator  = "->",   -- group separator
        group      = "+",    -- group marker
        mappings   = false,  -- NO per-mapping icons (prevents nerd/emoji)
        ellipsis = "...",
        --set all of the key "icons" manually since we are avoiding nerdfonts
        keys = {
          Esc = "esc",
          BS = "bksp",
          Up = "↑",
          Down = "↓",
          Right = "→",
          Left = "←",
          C = "ctrl",
          M = "alt", --the M is for "Meta"
          D = "⌘",
          S = "shift",
          CR = "enter",
          ScrollWheelDown = "SW↓",
          ScrollWheelUp = "SW↑",
        },
      },
      win = {
        border = "rounded",
      },
    })
  end,
}


