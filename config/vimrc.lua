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

-- Terminal Rerun Plugin
local M = {}

-- Store the last terminal buffer job id
M.last_terminal_chan_id = nil

-- Function to record terminal job id when terminal is opened
local function record_terminal_id(ev)
    local buf = vim.api.nvim_get_current_buf()
    local chan_id = vim.b[buf].terminal_job_id
    M.last_terminal_bufnr = ev.buf
    if chan_id then
        M.last_terminal_chan_id = chan_id
    end
end

-- Function to clear scrollback and screen
function M.clear_terminal()
    -- Temporarily set scrollback to 1 to clear history
    if M.last_terminal_bufnr then
        vim.bo[M.last_terminal_bufnr].scrollback = 1
        vim.cmd('sleep 100m')
        vim.bo[M.last_terminal_bufnr].scrollback = 100000
    else
        vim.bo.scrollback = 1
        vim.cmd('sleep 100m')
        vim.bo.scrollback = 100000
    end

    -- Send Ctrl-L to clear the screen
    if M.last_terminal_chan_id then
        vim.fn.chansend(M.last_terminal_chan_id, vim.api.nvim_replace_termcodes('<C-l>', true, true, true))
    end
end


-- Function to rerun last command
function M.rerun_last_command()
    if not M.last_terminal_chan_id then
        vim.notify("No terminal found", vim.log.levels.ERROR)
        return
    end

    -- Clear terminal
    M.clear_terminal()

    -- Send commands to rerun last command
    local keys = vim.api.nvim_replace_termcodes('<C-u>!!<CR><CR>', true, true, true)
    vim.fn.chansend(M.last_terminal_chan_id, keys)
end

-- Function to send Ctrl-C to terminal
function M.send_ctrl_c()
    if not M.last_terminal_chan_id then
        vim.notify("No terminal found", vim.log.levels.ERROR)
        return
    end

    local keys = vim.api.nvim_replace_termcodes('<C-c><CR><CR>', true, true, true)
    vim.fn.chansend(M.last_terminal_chan_id, keys)
end

-- Setup function
function M.setup()
    -- Create autocmd to record terminal job id
    vim.api.nvim_create_autocmd("TermOpen", {
        callback = record_terminal_id,
    })

    -- Create user commands
    vim.api.nvim_create_user_command('ClearTerminalScrollback', M.clear_terminal, {})
    vim.api.nvim_create_user_command('RerunLastThingInLastTerminal', M.rerun_last_command, {})
    vim.api.nvim_create_user_command('CancelInLastTerminal', M.send_ctrl_c, {})

    -- Setup keymaps
    vim.keymap.set('n', '<leader>p', ':w<CR>:RerunLastThingInLastTerminal<CR>', { silent = true })
    vim.keymap.set('n', '<leader>c', ':w<CR>:CancelInLastTerminal<CR>', { silent = true })
end
M.setup()

-- instead of having to do <C-w>w <C-w>w multiple times to change windows-
-- just do <C-s>
vim.keymap.set('n', '<C-s>', function()
    vim.cmd('wincmd w')
end, { noremap = true })

-- Open a window. Useful for helping break habits when learning new keybindings.
--
-- Example usage:
-- Single line:
-- create_alert_window("Hello World!")
--
-- Multiple lines:
-- create_alert_window({
--     "First Line",
--     "Second Line",
--     "Third Line"
-- })
local current_float_win = nil
local win_size_scaler = 0.5
local function create_alert_window(message)
    -- Close existing floating window if it exists
    if current_float_win and vim.api.nvim_win_is_valid(current_float_win) then
        vim.api.nvim_win_close(current_float_win, true)
    end

    -- Convert message to table if it's a string
    local lines = type(message) == "string" and {message} or message

    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")

    -- Calculate window size
    local win_height = math.ceil(height * win_size_scaler)
    local win_width = math.ceil(width * win_size_scaler)
    local row = math.ceil((height - win_height) / 2)
    local col = math.ceil((width - win_width) / 2)

    local buf = vim.api.nvim_create_buf(false, true)

    local opts = {
        style = "minimal",
        relative = "editor",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
        border = "rounded"
    }

    -- Set buffer lines with vertical centering
    local pad_top = math.floor((win_height - #lines - 2) / 2)  -- -2 to account for footer
    local pad_lines = {}
    for _ = 1, pad_top do
        table.insert(pad_lines, "")
    end

    -- Center each line horizontally
    for _, line in ipairs(lines) do
        local padding = math.floor((win_width - vim.fn.strdisplaywidth(line)) / 2)
        table.insert(pad_lines, string.rep(" ", padding) .. line)
    end

    -- Add padding until footer
    local remaining_lines = win_height - #pad_lines - 2  -- -2 for footer and buffer
    for _ = 1, remaining_lines do
        table.insert(pad_lines, "")
    end

    -- Add footer
    local footer = "Press 'n' or 'q' to exit"
    local footer_padding = math.floor((win_width - vim.fn.strdisplaywidth(footer)) / 2)
    table.insert(pad_lines, string.rep(" ", footer_padding) .. footer)

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, pad_lines)

    local win = vim.api.nvim_open_win(buf, true, opts)

    -- Store the new window ID globally
    current_float_win = win

    -- Set up close keybindings for this buffer
    vim.keymap.set('n', 'q', function()
        vim.api.nvim_win_close(win, true)
        current_float_win = nil
    end, { buffer = buf })

    vim.keymap.set('n', 'n', function()
        vim.api.nvim_win_close(win, true)
        current_float_win = nil
    end, { buffer = buf })

    vim.api.nvim_win_set_option(win, 'winblend', 10)
    vim.api.nvim_win_set_option(win, 'cursorline', true)

    return buf, win
end

-- Function to help break habits by showing an alert when using deprecated key sequences
-- @param keys: table of key sequences to break the habit of using
-- @param message: string message to show when keys are pressed
-- @param alternative: (optional) string suggesting the alternative key sequence
local function break_habit(keys, message, alternative)
    -- If alternative is provided, create a multi-line message array
    local display_message = alternative
        and {message, "Use " .. alternative .. " instead"}
        or {message}

    -- For each key sequence, create a keymap
    for _, key in ipairs(keys) do
        -- Create the keymap for both normal and command mode
        vim.keymap.set({"n", "c"}, key, function()
            create_alert_window(display_message)
        end, {
            desc = "habit breaking is habit making",
            silent = true
        })
    end
end

break_habit(
    { "<C-w>w", "<C-w><C-w>" },
    "Stop using <C-w>w & <C-w><C-w>",
    "<C-s>"
)

-- Toggle hardtime
vim.keymap.set('n', '<leader>ht', '<cmd>Hardtime toggle<CR>')
