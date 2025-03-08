call plug#begin('~/.config/nvim/autoload/plugged')

" List your plugins here
" Plug 'tpope/vim-sensible'
  Plug 'preservim/nerdtree'
  Plug 'nvim-telescope/telescope.nvim'
" Telescope dependcies
  Plug 'nvim-lua/plenary.nvim'

  Plug 'francoiscabrol/ranger.vim'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

call plug#end()
