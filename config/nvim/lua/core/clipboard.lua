---------------------------------------------------------------------------
-- Cross-platform system clipboard integration for Neovim
--
-- Adds support for macOS, Linux (Wayland/X11/Plasma), Windows, WSL2, and tmux.
-- If no provider is found, warns loudly (press ENTER to continue) and
-- includes install instructions.
---------------------------------------------------------------------------
-- lua/plugins/clipboard.lua

local uname = vim.loop.os_uname().sysname
local is_wsl = (vim.fn.has("wsl") == 1) or (os.getenv("WSL_DISTRO_NAME") ~= nil)


if uname == "Darwin" then
  -- macOS
  vim.g.clipboard = {
    name = "macOS-clipboard",
    copy = {
      ["+"] = "pbcopy",
      ["*"] = "pbcopy",
    },
    paste = {
      ["+"] = "pbpaste",
      ["*"] = "pbpaste",
    },
    cache_enabled = 0,
  }

elseif uname == "Linux" and not is_wsl then
  -- regular Linux (non-WSL), using xclip here as before

  vim.g.clipboard = {
    name = "linux-clipboard",
    copy = {
      ["+"] = "xclip -selection clipboard",
      ["*"] = "xclip -selection primary",
    },
    paste = {
      ["+"] = "xclip -selection clipboard -o",

      ["*"] = "xclip -selection primary -o",
    },
    cache_enabled = 0,

  }

elseif is_wsl then
  -- WSL: talk to Windows clipboard
  vim.g.clipboard = {
    name = "wsl-clipboard",
    copy = {
      ["+"] = { "win32yank.exe", "-i", "--crlf" },
      ["*"] = { "win32yank.exe", "-i", "--crlf" },
    },
    paste = {
      ["+"] = { "win32yank.exe", "-o", "--lf" },
      ["*"] = { "win32yank.exe", "-o", "--lf" },
    },
    cache_enabled = 0,
  }
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
