-- lua/plugins/blink-cmp.lua

return {
  "saghen/blink.cmp",
  version = "v1.*",
  event = "InsertEnter",

  opts = {
    appearance = {
      nerd_font_variant = "none",
      -- No icons; you can also just leave this table out
      kind_icons = {},
    },

    completion = {
      menu = {
        draw = {
          -- Only show the label (+ description), nothing else
          columns = {
            { "label", "label_description", gap = 1 },
          },
        },
      },
      documentation = {auto_show = false},
    },

    sources = {
      default = {'lsp', 'path', 'snippets', 'buffer'},
    },
  },
  opts_extend = {"sources.default" }
}
