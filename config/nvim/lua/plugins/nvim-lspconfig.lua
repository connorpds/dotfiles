return {                                              -- This file returns one plugin spec table for lazy.nvim.
  "neovim/nvim-lspconfig",                            -- Plugin that provides built-in LSP server configs (data only now).

  config = function()                                 -- Function lazy.nvim will run after loading this plugin.
    local capabilities = vim.lsp.protocol             -- Start from Neovim's built-in LSP client...
      .make_client_capabilities()                     -- ...and build a default "capabilities" table.

    local ok, blink = pcall(require, "blink.cmp")     -- Safely try to load the blink.cmp module.
    if ok and blink.get_lsp_capabilities then         -- If blink loaded AND exposes get_lsp_capabilities...
      capabilities = blink.get_lsp_capabilities(      -- ...let blink extend our capabilities
        capabilities                                  -- (adds extra completion/snippet things).
      )
    end                                               


    vim.lsp.config("*", {                             -- Configure ALL LSP servers ("*") in one go...
      capabilities = capabilities,                    -- ...so they all share these capabilities by default.
    })

    local servers = {                                 
      "lua_ls",                                       -- Lua 
      "pyright",                                      -- Python 
      "ts_ls",                                        -- TypeScript / JavaScript
      "clangd",                                       -- C / C++
      "rust_analyzer",                                -- Rust
      "bashls",                                       -- Bash
    }

    --loop through all the lsps in servers, enabling each 
    for _, server in ipairs(servers) do               
      vim.lsp.enable(server)                          
    end                                               
   -- Show inline error/warning text.
    vim.diagnostic.config({
      virtual_text = true,                           
    })
  end,                                               
}

