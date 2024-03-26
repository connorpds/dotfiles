"set runtimepath+=~./vim
filetype on
filetype plugin on
filetype indent on
syntax on
set number
set tabstop=2
set shiftwidth=2
set expandtab
set cursorline
set cursorcolumn
set ignorecase
set splitright
set splitbelow
set noswapfile
"This unsets the "last search pattern" register by hitting return to deal with
"annoying leftover higlighting
nnoremap <CR> :noh<CR><CR>
set backspace=indent,eol,start
highlight CursorLine term=bold cterm=NONE ctermbg=DarkGrey
highlight CursorColumn ctermbg=DarkGray
set clipboard+=unnamedplus
set mouse=a
"colorscheme nord
set background=light
source ~/.config/nvim/colors/nord.vim
set termguicolors
set virtualedit=onemore "allow the cursor to go to theo end of the line

" Use macOS pbcopy and pbpaste for clipboard operations
"if has('mac')
  " Copy to clipboard using pbcopy
  nnoremap <D-c> :let @+=getline('.')<CR>
  vnoremap <D-c> "+y
  inoremap <D-c> <Esc>:let @+=getline('.')<CR>a

  " Paste from clipboard using pbpaste
  nnoremap <D-v> :r !pbpaste<CR>
  inoremap <D-v> <C-r>=system('pbpaste')<CR>
  vnoremap <D-v> :r !pbpaste<CR>
"endif


" Use macOS pbcopy and pbpaste for clipboard operations
"if has('mac')
"  " Copy to clipboard using pbcopy
  nnoremap <D-c> :w !pbcopy<CR>
  vnoremap <D-c> :w !pbcopy<CR>
  inoremap <D-c> <Esc>:w !pbcopy<CR>a

  " Paste from clipboard using pbpaste
"  nnoremap <D-v> :r !pbpaste<CR>
"  inoremap <D-v> <C-r>=system('pbpaste')<CR>
"  vnoremap <D-v> :r !pbpaste<CR>
"endif

