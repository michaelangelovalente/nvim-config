-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]


-- Plugin management with Packer
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
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
    use('nvim-lua/plenary.nvim')
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    -- Treesitter (syntax highlighting)
    use {
        'nvim-treesitter/nvim-treesitter',
        { run = ':TSUpdate' }
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

    -- Java basic utils
    use("mfussenegger/nvim-jdtls")

    ----------------------------
    use('mbbill/undotree')
    use('tpope/vim-fugitive')

    -- Window maximizer
    use('szw/vim-maximizer')

    -- Zen mode
    use {
        "folke/zen-mode.nvim",
        config = function()
            require("zen-mode").setup({
                -- Configure as needed
            })
        end
    }


    -- use('neovim/nvim-lspconfig')
    -- use('hrsh7th/cmp-nvim-lsp')
    -- use('hrsh7th/cmp-buffer')
    -- use('hrsh7th/cmp-path')
    -- use('hrsh7th/cmp-cmdline')
    -- use('hrsh7th/nvim-cmp')
    -- use('hrsh7th/cmp-nvim-lsp')

    -- " For vsnip users.
    use('hrsh7th/cmp-vsnip')
    use('hrsh7th/vim-vsnip')

    -- ThePrimeagen harpoon file navigator
    use('ThePrimeagen/harpoon')

    ----- LSP zero
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    }

    ------
    -- Automatically set up configuration after cloning packer.nvim
    if packer_bootstrap then
        require('packer').sync()
    end
end)
