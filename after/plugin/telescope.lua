local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Telescope find files' }) -- project files (all file search)
vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'Telescope find git files' }) -- git specific file search
vim.keymap.set('n', '<leader>ps',  function()
 builtin.grep_string({search = vim.fn.input("Grep > ")});
end)
