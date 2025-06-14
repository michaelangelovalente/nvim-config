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
    -- use 'folke/tokyonight.nvim'
    use 'rmehri01/onenord.nvim'

    -- Telescope (fuzzy finder)
    use('nvim-lua/plenary.nvim')
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    -- Telescope extensions
    use { 'nvim-telescope/telescope-file-browser.nvim' }

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

    -- Tabs enhanced ( either use barbar or bufferline)
    -- Barbar
    use {
        'nvim-tree/nvim-web-devicons', -- " OPTIONAL: for file icons
        'romgrk/barbar.nvim'
    }

    -- Bufferline
    -- use { 'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons' }


    --- TODO: delete old lsp???
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

    -- Icon Support
    use {
        'nvim-tree/nvim-web-devicons',
        config = function()
            require('nvim-web-devicons').setup({
                -- Enable globally
                default = true,
            })
        end
    }

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

    --- Code formatter
    use {
        'stevearc/conform.nvim',
        config = function()
            require('conform').setup({
                formatters_by_ft = {
                    sh = { 'shfmt' },
                    bash = { 'shfmt' },
                },
                -- Format on save (optional)
                format_on_save = {
                    -- Enable or disable format on save globally
                    lsp_fallback = true,
                    timeout_ms = 500,
                },
                -- Customize shfmt if needed
                formatters = {
                    shfmt = {
                        prepend_args = { "-i", "2", "-ci", "-s" } -- 2 space indentation, indent case, simplify code
                    }
                }
            })
        end
    }

    --- Markdown
    use({
        'MeanderingProgrammer/render-markdown.nvim',
        after = { 'nvim-treesitter' },
        requires = { 'echasnovski/mini.nvim', opt = true }, -- if you use the mini.nvim suite
        -- requires = { 'echasnovski/mini.icons', opt = true }, -- if you use standalone mini plugins
        -- requires = { 'nvim-tree/nvim-web-devicons', opt = true }, -- if you prefer nvim-web-devicons
        config = function()
            require('render-markdown').setup({})
        end,
    })

    --- Go Development
    -- Go plugin for Vim/Neovim with comprehensive tooling
    use {
        'fatih/vim-go',
        run = ':GoUpdateBinaries',
        ft = { 'go' }
    }

    -- Mason Tool Installer for managing Go-related tools
    use {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        requires = { 'williamboman/mason.nvim' }
    }

    -- Debug Adapter for Go
    use {
        'leoluz/nvim-dap-go',
        requires = { 'mfussenegger/nvim-dap' },
    }

    -- Go documentation access
    use { 'ray-x/go.nvim',
        requires = { 'ray-x/guihua.lua' },
        config = function()
            require('go').setup({
                lsp_inlay_hints = {
                    enable = true,
                },
                lsp_document_formatting = true,
                lsp_keymaps = false, -- We'll use our own keymaps
                dap_debug = true,
                dap_debug_gui = true,
            })
        end,
        ft = { 'go', 'gomod' },
    }

    -- IdeaVim-like functionality
    -- Surround plugin (equivalent to 'set surround' in IdeaVim)
    use {
        'kylechui/nvim-surround',
        tag = "*", -- Use for stability; omit to use `main` branch for the latest features
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    }

    -- Highlighted yank (equivalent to 'set highlightedyank' in IdeaVim)
    use {
        'machakann/vim-highlightedyank',
    }

    -- Sneak plugin (equivalent to 'set sneak' in IdeaVim)
    use {
        'justinmk/vim-sneak',
        config = function()
            vim.g['sneak#label'] = 1 -- Label mode for quick navigation
        end
    }

    -- Go Documentation plugin
    use {
        'fredrikaverpil/godoc.nvim',
        requires = {
            { 'nvim-telescope/telescope.nvim' },                         -- optional
            { 'nvim-treesitter/nvim-treesitter' }                        -- required
        },
        ft = { 'go' },                                                   -- Only load for Go files
        run = "go install github.com/lotusirous/gostdsym/stdsym@latest", -- Install required Go tool
        config = function()
            require('godoc').setup({
                -- Force floating window by default
                default_mode = "float",  -- use "float" for floating window
                float_opts = {
                    relative = "editor", -- Position relative to editor
                    border = "rounded",  -- Rounded borders for nicer appearance
                    width = 0.8,         -- 80% of editor width
                    height = 0.7,        -- 70% of editor height
                    row = 0.15,          -- Position from the top
                    col = 0.1            -- Position from the left
                }
            })
        end
    }
    
    -- Java Language Support
    use {
        'mfussenegger/nvim-jdtls',
        ft = { 'java' }  -- Only load for Java files
    }

    --- Telescope file browser
    use {
        "nvim-telescope/telescope-file-browser.nvim",
        requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    }

    ------
    -- Automatically set up configuration after cloning packer.nvim
    if packer_bootstrap then
        require('packer').sync()
    end
end)
