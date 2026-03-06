" VIM SETTINGS
" =============================================================================
set colorcolumn=80,100,120                              " Column guides
set hidden                                              " Don't close when switching buffers
set list listchars=tab:\▶\ ,trail:·,nbsp:·,space:·      " Highlight whitespace
set mouse=a                                             " Enable mouse scrolling
set number                                              " Show the current line number
set scrolloff=5                                         " Always have 5 lines above/below the current line
set showbreak=↩\ 
set signcolumn=yes                                      " Always show the sign column for git gutter
set nojoinspaces                                        " One space after period when doing gq

" Tabs
set expandtab                                           " Insert spaces instead of tabs
set shiftwidth=4                                        " 4 is the only way
set tabstop=8

" Search
set ignorecase  " ignore case...
set smartcase   " unless the search string has uppercase letters

" Tabs and Buffers ------------------------------------------------------------
set showtabline=2       " Always show the tab bar
set splitbelow          " Default split below, rather than above
set splitright          " Default split to the right, rather than the left

" Custom keybindings ----------------------------------------------------------
" Make j and k behave nicer when the line wraps
noremap j gj
noremap k gk

" Clean up paragraph
noremap <C-c> vipgq

" Undo and Swap ---------------------------------------------------------------
" Note: ~/tmp is a tmpfs, so writing to it does not use disk)
set undofile                    " Use an undo file
set undodir=~/tmp/nvim/undo//   " Store undo files in ~/tmp to avoid disk I/O
set directory=~/tmp/nvim/swap// " Store swap files in ~/tmp to aviod disk I/O
