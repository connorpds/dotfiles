
-- Enable filetype detection/plugins/indents?
vim.cmd("filetype plugin indent on")

-- enable syntax highlighting?
vim.cmd("syntax on")

-------------------------------- set options ---------------------------
local opt_options = {
---------------display options--------------
  number = true, -- show line numbers

---------------tab options------------------
  expandtab = true, --use spaces instead of tabs
  tabstop = 2, --set tab width to 2 spaces
  shiftwidth = 2, --set indent width to 2 spaces

---------------cursor-related options------------
  backspace = {"indent", "eol", "start"}, --let backspace delete autoindents/line breaks 
                                              --and delete before current insertion point.
  virtualedit = "onemore", --fix awkward cursor positioning behavior at EOL
  cursorline = true, --I'm just a crosshair...
  cursorcolumn = true, --I'm just a shot away from you...

---------------editor options--------------
  mouse = "a", --enable mouse input!
  ignorecase = true, --case insensitive search/filtering by default
  clipboard = "unnamedplus",
  emoji = false,
---------------pane options-----------------
  splitright = true, -- vsplit opens to the right 
  splitbelow = true, -- split opens below

---------------file options-----------------
  swapfile = false,
  
---------------colors-----------------------
  background = "dark",
  termguicolors = true,
}



for opt_field, values in pairs(opt_options) do
  vim.opt[opt_field] = values
end



------------------  named key actions  -------------------------
-- name = {"[MODE]", "[INPUT KEY(s)]", "[NEW BEHAVIOR]", "[DESC]"} 
local action_binds = {
  --clear current search highlight and carriage return on enter. preserves search history.
  clear_hl_enter = {"n", "<CR>", "<Cmd>nohlsearch<CR><CR>", "Clear search highlight and carriage return."},
}

--Iterate across action_binds, configuring each keymap with the relevant fields
for _, fields in pairs(action_binds) do
  vim.keymap.set(fields[1], fields[2], fields[3], {silent = true, desc = fields[4]})
end


------------------  enhanced clipboard behavior ----------------

--three different tables, each containing the appropriate rebinds
--for graphical mac, linux, and windows' clipboards to interact
--intuitvely with vim's yank and paste functions
require("core.clipboard") --see clipboard.lua!


------------------  colorscheme nord!
vim.cmd.colorscheme("nord")


------------------  no nerdfonts!
vim.g.have_nerd_font = false

----------------- lazy 
require("core.lazy")
