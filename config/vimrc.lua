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

-- Make it so holding down 'ctrl', and pressing 'w' will cycle through windows for every press of 'w' after the first instead of every 2 presses.
-- Track the timestamp of last <C-w> press
local last_w_press = 0
-- Time window for last press to count for cycle window
local last_w_press_time_limit = 1000;
vim.keymap.set('n', '<C-w>', function()
    local now = vim.loop.now()
    -- If pressed within 200ms, cycle windows
    if now - last_w_press < last_w_press_time_limit then
        vim.cmd('wincmd w')
    else
        -- Otherwise, act as normal <C-w>
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-w>', true, false, true), 'n', false)
    end
    last_w_press = now
end, { noremap = true })
