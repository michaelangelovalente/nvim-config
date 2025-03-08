-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]


-- Plugin management with Packer
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Initialize plugins using Packer
require('packer').startup(function(use)


  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Colorscheme
  use 'folke/tokyonight.nvim'

  -- Telescope (fuzzy finder)
  use ('nvim-lua/plenary.nvim')
  use {
   'nvim-telescope/telescope.nvim', tag = '0.1.8',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- Treesitter (syntax highlighting)
  use {
    'nvim-treesitter/nvim-treesitter',
    { run = ':TSUpdate'}
  }

 use {
    'nvim-treesitter/playground'
 }

  -- LSP Configuration
  use {
    'neovim/nvim-lspconfig',
    'williamboman/mason.nvim',           -- Package manager for LSP servers
    'williamboman/mason-lspconfig.nvim', -- Bridge between mason and lspconfig
  }

  -- Autocompletion
  use {
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
  }

  -- Status line
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  -- Git integration
  use 'lewis6991/gitsigns.nvim'

  -- Autopairs
  use 'windwp/nvim-autopairs'

  -- File explorer
  use {
    'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons' }
  }

  -- ThePrimeagen harpoon file navigator
  use ('ThePrimeagen/harpoon')
  use('mbbill/undotree')

  -- Automatically set up configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)


