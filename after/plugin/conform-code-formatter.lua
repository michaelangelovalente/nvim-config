vim.keymap.set({ "n", "v" }, "<leader>cf", function()
  vim.notify("Format triggered", vim.log.levels.INFO)
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format file or range (in visual mode)" })
