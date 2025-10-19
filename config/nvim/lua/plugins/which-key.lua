return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    -- make key-hints responsive but not jumpy

    local wk = require("which-key")
    wk.setup({
      icons = {
        breadcrumb = ">>",   -- top line path
        separator  = "->",   -- group separator

        group      = "+",    -- group marker
        mappings   = false,  -- NO per-mapping icons (prevents nerd/emoji)
        keys = {
          Esc = "esc",
          BS = "bksp",
        },
      },
      win = {
        border = "rounded",
      },
    })
  end,
}


