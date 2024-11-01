vim.api.nvim_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>ac', '<cmd>lua vim.lsp.buf.code_action()<CR>', {})
vim.keymap.set('n', '<leader>tc', '<cmd>Telescope commands<CR>')
