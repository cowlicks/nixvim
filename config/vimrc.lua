vim.api.nvim_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>ac', '<cmd>lua vim.lsp.buf.code_action()<CR>', {})
vim.keymap.set('n', '<leader>tc', '<cmd>Telescope commands<CR>')
vim.keymap.set('n', '<leader>o', "<cmd>lua vim.cmd.RustLsp('openDocs')<CR>", {})
-- :bd to close buffer and keep window open
vim.keymap.set('n', '<leader>bd', function()
    local current_buf = vim.api.nvim_get_current_buf()
    local buffers = vim.fn.getbufinfo({buflisted = 1})

    if #buffers <= 1 then
        -- If this is the last buffer, create a new one before deleting
        vim.cmd('enew')
    else
        vim.cmd('bprevious')
    end

    vim.api.nvim_buf_delete(current_buf, {})
end, { noremap = true })
