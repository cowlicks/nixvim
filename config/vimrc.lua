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


-- This was causing <Tab> to split the pane
---- Make it so holding down 'ctrl', and pressing 'w' will cycle through windows for every press of 'w' after the first instead of every 2 presses.
---- Track the timestamp of last <C-w> press
--local last_w_press = 0
---- Time window for last press to count for cycle window
--local last_w_press_time_limit = 1000;
--vim.keymap.set('n', '<C-w>', function()
--    local now = vim.loop.now()
--    -- If pressed within 200ms, cycle windows
--    if now - last_w_press < last_w_press_time_limit then
--        vim.cmd('wincmd w')
--    else
--        -- Otherwise, act as normal <C-w>
--        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-w>', true, false, true), 'n', false)
--    end
--    last_w_press = now
--end, { noremap = true })

-- flash hotkey
vim.keymap.set({ 'n', 'x', 'o' }, 's', function()
    require('flash').jump()
end)

-- Disable sign column completely
-- disabled bc it takes up a whole column to show diagnostics and it is mostly empty
-- I would like an alternative wher instead the column number just changes color
vim.opt.signcolumn = "no"

-- highlight <thing> then ,d will put: console.log("<thing>", <thing>) on the next line
local function wrap_with_console_log()
  -- Get the visual selection
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  local start_col = vim.fn.col("'<")
  local end_col = vim.fn.col("'>")
  
  -- Get the selected text
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  
  -- Handle multi-line selections
  if #lines > 1 then
    -- Adjust first and last lines for partial selections
    lines[1] = string.sub(lines[1], start_col)
    lines[#lines] = string.sub(lines[#lines], 1, end_col)
  else
    -- Handle single line selection
    lines[1] = string.sub(lines[1], start_col, end_col)
  end
  
  local selected_text = table.concat(lines, '\n')
  
  -- Get the indentation of the first line
  local indent = vim.fn.indent(start_line)
  local spaces = string.rep(' ', indent)
  
  -- Create the debug line
  local debug_line = spaces .. 'console.log(" let ' .. selected_text .. ' = ", ' .. selected_text .. ', ";");'
  
  -- Insert the debug line after the selection
  vim.api.nvim_buf_set_lines(0, end_line, end_line, false, {debug_line})
end

-- Create the command
vim.api.nvim_create_user_command('WrapConsoleLog', function()
  wrap_with_console_log()
end, { range = true })

-- Set up the keybinding (optional)
vim.keymap.set('v', '<leader>d', ':WrapConsoleLog<CR>', { noremap = true, silent = true })


-- instead of having to do <C-w>w <C-w>w multiple times to change windows-
-- just do <C-s>
vim.keymap.set('n', '<C-s>', function()
    vim.cmd('wincmd w')
end, { noremap = true })

-- make Ctrl-s work in terminal mode
--vim.keymap.set('t', '<C-w><C-w>', '<C-\\><C-n><C-w><C-w>', { noremap = true })
-- OR if you want to use just a single press of w while holding Ctrl
vim.keymap.set('t', '<C-s>', '<C-\\><C-n><C-w>w', { noremap = true })

