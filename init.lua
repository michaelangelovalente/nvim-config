--source ~/.config/nvim/vim-plug/plugins.vim
--source ~/.config/nvim/keybinds.vim
--
--set rnu
--
--set tabstop=4
--set shiftwidth=4
--set expandtab

print("HELLOO FROM OUTER INIT LUA")
require("core")

vim.cmd[[
  "
   set rnu

   set tabstop=3
   set expandtab

]]
-- vim.cmd[[
--  "
--   source ~/.config/nvim/vim-plug/plugins.vim
--   source ~/.config/nvim/keybinds.vim
--   set rnu

--   set tabstop=3
--   set expandtab
--
--]]

-- init.lua for Neovim
-- Basic Options
vim.opt.number = true                -- Show line numbers
vim.opt.relativenumber = true        -- Show relative line numbers
vim.opt.tabstop = 4                  -- Number of spaces tabs count for
vim.opt.softtabstop = 4              -- Number of spaces for a tab while editing
vim.opt.shiftwidth = 4               -- Size of an indent
vim.opt.expandtab = true             -- Use spaces instead of tabs
vim.opt.smartindent = true           -- Insert indents automatically
vim.opt.wrap = false                 -- Disable line wrap
vim.opt.swapfile = false             -- Don't use swapfile
vim.opt.backup = false               -- Don't create backup files
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"  -- Undodir location
vim.opt.undofile = true              -- Enable persistent undo
vim.opt.hlsearch = false             -- Don't highlight search
vim.opt.incsearch = true             -- Show search matches as you type
vim.opt.termguicolors = true         -- True color support
vim.opt.scrolloff = 8                -- Minimum lines to keep above/below cursor
vim.opt.signcolumn = "yes"           -- Always show the signcolumn
vim.opt.updatetime = 50              -- Faster completion
vim.opt.colorcolumn = "80"           -- Show column at 80 characters

vim.opt.modifiable = true            -- Set modifiable to true

-- Set leader key to space
vim.g.mapleader = " "

-- Keymaps
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- General keymaps
keymap("n", "<leader>pv", vim.cmd.Ex, opts)                   -- Open file explorer
keymap("n", "<C-d>", "<C-d>zz", opts)                         -- Scroll down and center
keymap("n", "<C-u>", "<C-u>zz", opts)                         -- Scroll up and center
keymap("n", "n", "nzzzv", opts)                               -- Next search result and center
keymap("n", "N", "Nzzzv", opts)                               -- Previous search result and center

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", opts)                          -- Move to left window
keymap("n", "<C-j>", "<C-w>j", opts)                          -- Move to bottom window
keymap("n", "<C-k>", "<C-w>k", opts)                          -- Move to top window
keymap("n", "<C-l>", "<C-w>l", opts)                          -- Move to right window

-- Buffer navigation
keymap("n", "<leader>bn", ":bnext<CR>", opts)                 -- Next buffer
keymap("n", "<leader>bp", ":bprevious<CR>", opts)             -- Previous buffer
keymap("n", "<leader>bd", ":bdelete<CR>", opts)               -- Delete buffer

-- Visual mode improvements
keymap("v", "J", ":m '>+1<CR>gv=gv", opts)                    -- Move text down
keymap("v", "K", ":m '<-2<CR>gv=gv", opts)                    -- Move text up
keymap("v", "<", "<gv", opts)                                 -- Stay in indent mode
keymap("v", ">", ">gv", opts)                                 -- Stay in indent mode

-- Colorscheme configuration
vim.cmd[[colorscheme tokyonight]]

-- Telescope configuration
local telescope = require('telescope')
telescope.setup{
  defaults = {
    file_ignore_patterns = { "node_modules", ".git/" }
  }
}

-- Telescope keymaps
keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", opts)
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", opts)
keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", opts)
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", opts)

-- Treesitter configuration
-- require('nvim-treesitter.configs').setup {
--   ensure_installed = { "lua", "vim", "javascript", "typescript", "python", "bash", "markdown" },
--   sync_install = false,
--   highlight = {
--     enable = true,
--   },
--   indent = {
--     enable = true,
--   },
-- }

-- LSP configuration
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "pyright", "ts_ls", "bashls" },
})

local lspconfig = require('lspconfig')

-- LSP server setup
-- Lua language server
lspconfig.lua_ls.setup{
  settings = {
    Lua = {
      diagnostics = {
        globals = {'vim'},
      },
    },
  },
}

-- Python language server
lspconfig.pyright.setup{}

-- TypeScript language server
lspconfig.ts_ls.setup{}

-- Global mappings for LSP
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
keymap('n', '<leader>e', vim.diagnostic.open_float, opts)
keymap('n', '[d', vim.diagnostic.goto_prev, opts)
keymap('n', ']d', vim.diagnostic.goto_next, opts)
keymap('n', '<leader>q', vim.diagnostic.setloclist, opts)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap=true, silent=true, buffer=ev.buf }
    keymap('n', 'gD', vim.lsp.buf.declaration, bufopts)
    keymap('n', 'gd', vim.lsp.buf.definition, bufopts)
    keymap('n', 'K', vim.lsp.buf.hover, bufopts)
    keymap('n', 'gi', vim.lsp.buf.implementation, bufopts)
    keymap('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    keymap('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    keymap('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    keymap('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    keymap('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
    keymap('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    keymap('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    keymap('n', 'gr', vim.lsp.buf.references, bufopts)
    keymap('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
  end,
})

-- Completion setup
local cmp = require'cmp'
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
    { name = 'path' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- LuaLine configuration
require('lualine').setup {
  options = {
    theme = 'tokyonight',
    component_separators = { left = '|', right = '|'},
    section_separators = { left = '', right = ''},
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
}

-- GitSigns configuration
require('gitsigns').setup {}

-- Autopairs configuration
require('nvim-autopairs').setup {}

-- NvimTree configuration
require('nvim-tree').setup {
  sort_by = "case_sensitive",
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
}

-- NvimTree keymap
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- Custom autocommands
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Remove trailing whitespace on save
local TrimWhiteSpaceGrp = augroup('TrimWhiteSpaceGrp', {})
autocmd('BufWritePre', {
  group = TrimWhiteSpaceGrp,
  pattern = '*',
  command = '%s/\\s\\+$//e',
})

-- Remember last location in file
autocmd('BufReadPost', {
  pattern = '*',
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Automatically install any new plugins
autocmd('BufWritePost', {
  pattern = 'init.lua',
  command = 'source <afile> | PackerCompile',
})
