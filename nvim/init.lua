--nick doesnt know
-- vim.loader.enable()

--execute vimscript code in the .vim file
vim.cmd('source ' .. vim.fn.stdpath('config') .. '/config.vim')

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

require('lazy').setup {
  { import = 'plugins' },
  'folke/zen-mode.nvim',
  -- deps that a lot of packages want
  'nvim-lua/plenary.nvim',
  'MunifTanjim/nui.nvim',
  -- Allow us to use `:ClangFormat` to format w/o an lsp
  'rhysd/vim-clang-format',
}

local keys = require('core.keymap')
keys.map("<C-/>", "Live Grep", ":Telescope live_grep<CR>", { mode = 'n' })
keys.map("<C-f>", "Display git files", ":Telescope git_files<cr>", { mode = "n" })
keys.map("<C-p>", "Display all files", ":Telescope find_files<CR>", { mode = "n" })
keys.map("<leader>b", "Show buffers", ":Telescope buffers<CR>", { mode = 'n' })


keys.map("<", "Dedent", "<gv", { mode = "v" })
keys.map(">", "Indent", ">gv", { mode = "v" })
