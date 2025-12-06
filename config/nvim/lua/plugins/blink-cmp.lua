-- lua/plugins/blink-cmp.lua
 
----  appearance options
local _appearance = {
    nerd_font_variant = "none",
    -- no icons (no nerdfonts, so why icons?)
    kind_icons = {},
  }

local _completion = {
  menu = {
    draw = {
      -- Only show the label (+ description), nothing else
      columns = {
        { "label", "label_description", gap = 1 },
      },
    },
  },
  documentation = {auto_show = false},
}


----  sources --------
local _sources = {
  default = {'lsp', 'path', 'snippets', 'buffer'},
}


--

return {
  "saghen/blink.cmp",
  version = "v1.*",
  event = "InsertEnter",

  opts = {
    appearance = _appearance, 
    completion = _completion, 
    sources = _sources, 
  },
  --just in case some other plugin affects sources.default, merge the lists  
  opts_extend = {"sources.default" }
}
