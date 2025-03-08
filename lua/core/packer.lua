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

    use('mbbill/undotree')
    use('tpope/vim-fugitive')

    use('neovim/nvim-lspconfig')
    use('hrsh7th/cmp-nvim-lsp')
    use('hrsh7th/cmp-buffer')
    use('hrsh7th/cmp-path')
    use('hrsh7th/cmp-cmdline')
    use('hrsh7th/nvim-cmp')

    -- " For vsnip users.
    Plug 'hrsh7th/cmp-vsnip'
    Plug 'hrsh7th/vim-vsnip'

    -- ThePrimeagen harpoon file navigator
    use('ThePrimeagen/harpoon')

    -- LSP ZERO
    -- NOTE: to make any of this work you need a language server.
    -- If you don't know what that is, watch this 5 min video:
    -- https://www.youtube.com/watch?v=LaS32vctfOY

    -- Reserve a space in the gutter
    vim.opt.signcolumn = 'yes'

    -- Add cmp_nvim_lsp capabilities settings to lspconfig
    -- This should be executed before you configure any language server
    local lspconfig_defaults = require('lspconfig').util.default_config
    lspconfig_defaults.capabilities = vim.tbl_deep_extend(
        'force',
        lspconfig_defaults.capabilities,
        require('cmp_nvim_lsp').default_capabilities()
    )

    -- This is where you enable features that only work
    -- if there is a language server active in the file
    vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP actions',
        callback = function(event)
            local opts = { buffer = event.buf }

            vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
            vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
            vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
            vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
            vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
            vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
            vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
            vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
            vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
            vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
        end,
    })

    -- You'll find a list of language servers here:
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
    -- These are example language servers.
    require('lspconfig').gleam.setup({})
    require('lspconfig').ocamllsp.setup({})

    local cmp = require('cmp')

    cmp.setup({
        sources = {
            { name = 'nvim_lsp' },
        },
        snippet = {
            expand = function(args)
                -- You need Neovim v0.10 to use vim.snippet
                vim.snippet.expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert({}),
    })
    -- Automatically set up configuration after cloning packer.nvim
    if packer_bootstrap then
        require('packer').sync()
    end
end)
