local keys = require('core.keymap')
local lsp = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')


M = {}


M.setup_server = function(server_name)
  local capabilities = cmp_nvim_lsp.default_capabilities()

  lsp[server_name].setup {
    capabilities = capabilities,
    keymap = {
      recommended = true,
      jump_to_mark = "<c-Tab>",
    },
    flags = {
      debounce_text_changed = 150,
    },

    on_attach = function(_, bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }

      keys.map("<leader>r", "Show LSP References", ":Telescope lsp_references<CR>", opts)
      keys.map("<leader>D", "Go to declaration", vim.lsp.buf.declaration, opts)
      keys.map("<leader>d", "Show Definitions", ":Telescope lsp_definitions<CR>", opts)
      keys.map("<leader>i", "Show Implementation", ":Telesecope lsp_implementations<CR>", opts)
      keys.map("<leader>t", "Show Type", ":Telesecope lsp_type_definitions<CR>", opts)
      keys.map("<leader>ca", "Show Code Actions", vim.lsp.buf.code_action, opts)
      keys.map("<leader>rn", "Rename Symbol", vim.lsp.buf.rename, opts)
      --keys.map("<leader>D", "Show Buffer Diagnostics", ":Telescope diagnostics buffnr=0<CR>", opts)
      --keys.map("<leader>d", "Show Line Diagnostics", vim.diagnostic.open_float, opts)
      keys.map("K", "Show documentation", vim.lsp.buf.hover, opts)
      keys.map("<c-k>", "Show Signature Help", vim.lsp.buf.signature_help, opts)
      keys.map("<leader>rs", "Restart LSP", ":LspRestart<CR>", opts)
      --keys.map("<leader>f", "Format", vim.lsp.buf.format, opts)
    end
  }
end


return M
