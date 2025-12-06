-- lua/plugins/blink-cmp.lua
 
----  appearance options
local _appearance = {
  nerd_font_variant = "none",
  -- no icons (no nerdfonts, so why icons?)
  kind_icons = {},
}

----- completion options!
local _completion = {
  --- completion menu settings
  menu = {
    draw = {
      -- Only show the label (+ description), nothing else
      columns = {
        { "label", "label_description", gap = 1 },
      },
    },
  },

  --- docs settings 
  --documentation = {auto_show = false},

  --- list settings 
  list = {
    selection = {
      preselect = false,
      auto_insert = false,
    },
  },
}


----  sources --------
local _sources = {
  default = {'lsp', 'path', 'snippets', 'buffer'},
}


---- keymap ------- 
local _keymap = {
  --disable default preset 
  preset = 'none',
  
  ['<Up>'] = { 'select_prev', 'fallback'},
  ['<Down>'] = { 'select_next', 'fallback'},
  ['<Right>'] = { 'accept', 'fallback'},
}

---- cmdline settings recommended by dev for behavior matching default. 
local _cmdline = {
  keymap = { preset = 'inherit' },
  completion = { menu = { auto_show = true } },
}

return {
  "saghen/blink.cmp",
  version = "v1.*",
  event = "InsertEnter",

  opts = {
    appearance = _appearance, 
    completion = _completion, 
    sources = _sources,
    keymap = _keymap, 
    cmdline = _cmdline,
  },
  --just in case some other plugin affects sources.default, merge the lists  
  opts_extend = {"sources.default" }
}
