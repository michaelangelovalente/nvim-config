vim.g.mapleader = " "
vim.opt.backspace = "2"
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.autoread = true

-- use spaces for tabs and whatnot
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = true

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })
-- vim.keymap.set("n", "<leader>tb", ":botright 20split | terminal<CR>", { noremap = true })

-- Maximizer toggl
vim.keymap.set("n", "<leader>mx", ":MaximizerToggle<CR>", { noremap = true })

-- Zenmode
vim.keymap.set("n", "<leader>zm", ":Zenmode<CR>", { noremap = true, silent = true })


-- Float terminal
vim.keymap.set('n', '<leader>ft', ":Floaterminal<CR>", { desc = "Toggle Floating Terminal" })

-- IDEAVIM equiv
-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)                 -- Move to left window
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)                 -- Move to bottom window
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)                 -- Move to top window
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)                 -- Move to right window
-- Window splits (equivalent to IdeaVim actions)
vim.keymap.set("n", "<leader>wv", "<cmd>vsplit<CR>", opts)   -- Split vertically
vim.keymap.set("n", "<leader>ws", "<cmd>split<CR>", opts)    -- Split horizontally
vim.keymap.set("n", "<leader>wu", "<cmd>close<CR>", opts)    -- Close current window/unsplit
vim.keymap.set("n", "<leader>wm", "<cmd>wincmd x<CR>", opts) -- Swap current window with next

-- Close current buffer (equivalent to IdeaVim's CloseContent)
vim.keymap.set("n", "<leader>q", "<cmd>bd<CR>", opts) -- Close current buffer
