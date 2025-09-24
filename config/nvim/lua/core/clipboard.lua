---------------------------------------------------------------------------
-- Cross-platform system clipboard integration for Neovim
--
-- Adds support for macOS, Linux (Wayland/X11/Plasma), Windows, WSL2, and tmux.
-- If no provider is found, warns loudly (press ENTER to continue) and
-- includes install instructions.
---------------------------------------------------------------------------

local sysname = vim.loop.os_uname().sysname
local is_wsl  = (vim.fn.has("wsl") == 1)

-- === macOS ===
if sysname == "Darwin" then
  vim.g.clipboard = {
    name = "macOS-clipboard",
    copy = { ["+"] = "pbcopy", ["*"] = "pbcopy" },
    paste = { ["+"] = "pbpaste", ["*"] = "pbpaste" },
    cache_enabled = 0,
  }
end

-- === Linux (Wayland / X11 / KDE Plasma) ===
if sysname == "Linux" and not is_wsl then
  if vim.fn.executable("wl-copy") == 1 then
    vim.g.clipboard = {
      name = "wl-clipboard",
      copy = { ["+"] = "wl-copy --foreground --type text/plain",
               ["*"] = "wl-copy --foreground --type text/plain" },
      paste = { ["+"] = "wl-paste --no-newline",
                ["*"] = "wl-paste --no-newline" },
      cache_enabled = 0,
    }
  elseif vim.fn.executable("xclip") == 1 then
    vim.g.clipboard = {
      name = "xclip",
      copy = { ["+"] = "xclip -selection clipboard",
               ["*"] = "xclip -selection primary" },
      paste = { ["+"] = "xclip -selection clipboard -o",
                ["*"] = "xclip -selection primary -o" },
      cache_enabled = 0,
    }
  elseif vim.fn.executable("xsel") == 1 then
    vim.g.clipboard = {
      name = "xsel",
      copy = { ["+"] = "xsel --clipboard --input",
               ["*"] = "xsel --primary --input" },
      paste = { ["+"] = "xsel --clipboard --output",
                ["*"] = "xsel --primary --output" },
      cache_enabled = 0,
    }
  end
end

-- === Windows native ===
if sysname:match("Windows") and not is_wsl then
  vim.g.clipboard = {
    name = "win32yank",
    copy = { ["+"] = "win32yank.exe -i --crlf",
             ["*"] = "win32yank.exe -i --crlf" },
    paste = { ["+"] = "win32yank.exe -o --lf",
              ["*"] = "win32yank.exe -o --lf" },
    cache_enabled = 0,
  }
end

-- === WSL2 ===
if is_wsl then
  if vim.fn.executable("win32yank.exe") == 1 then
    vim.g.clipboard = {
      name = "win32yank-wsl",
      copy = { ["+"] = "win32yank.exe -i --crlf",
               ["*"] = "win32yank.exe -i --crlf" },
      paste = { ["+"] = "win32yank.exe -o --lf",
                ["*"] = "win32yank.exe -o --lf" },
      cache_enabled = 0,
    }
  elseif vim.fn.executable("/mnt/c/Windows/System32/clip.exe") == 1 then
    vim.g.clipboard = {
      name = "wsl-clip-fallback",
      copy = { ["+"] = "/mnt/c/Windows/System32/clip.exe",
               ["*"] = "/mnt/c/Windows/System32/clip.exe" },
      paste = { ["+"] = "powershell.exe -NoProfile -Command Get-Clipboard | tr -d '\r'",
                ["*"] = "powershell.exe -NoProfile -Command Get-Clipboard | tr -d '\r'" },
      cache_enabled = 0,
    }
  end
end

-- === tmux ===
-- If Neovim is running inside tmux and no provider is set yet,
-- fall back to using tmux buffer commands.
if vim.g.clipboard == nil and os.getenv("TMUX") then
  if vim.fn.executable("tmux") == 1 then
    vim.g.clipboard = {
      name = "tmux-clipboard",
      copy = {
        ["+"] = "tmux load-buffer -",
        ["*"] = "tmux load-buffer -",
      },
      paste = {
        ["+"] = "tmux save-buffer -",
        ["*"] = "tmux save-buffer -",
      },
      cache_enabled = 0,
    }
  end
end




---------------------------------------------------------------------------
-- Final fallback if no provider was set above.
-- Shows a loud warning and lists install instructions.
---------------------------------------------------------------------------
if vim.g.clipboard == nil then
  vim.schedule(function()
    vim.cmd([[
      echohl WarningMsg
      echom "WARNING: No clipboard provider found!"
      echom "Yanks/pastes will NOT sync with the system clipboard."
      echom ""
      echom "Install instructions by platform:"
      echom "  • macOS: already ships pbcopy/pbpaste (in /usr/bin)."
      echom "  • Linux (Wayland):   sudo apt install wl-clipboard"
      echom "  • Linux (X11/Plasma): sudo apt install xclip   OR   sudo apt install xsel"
      echom "  • KDE Plasma: ensure xclip or xsel is installed (Klipper integrates with them)."
      echom "  • tmux: Neovim can use tmux load-buffer/save-buffer automatically if tmux is in PATH."
      echom "          IMPORTANT: Add 'set -g set-clipboard on' to ~/.tmux.conf"
      echom "          Without this, tmux won’t sync its buffer with your system clipboard."
      echom "  • Windows/WSL2: win32yank.exe (from Neovim releases) in your PATH."
      echom "    Download: https://github.com/neovim/neovim/wiki/FAQ#where-to-download-win32yankexe"
      echom ""
      echohl None
      echo "Press ENTER to continue" | call getchar()
    ]])
  end)
end
