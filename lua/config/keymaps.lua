-- /home/patrick/.config/nvim/lua/config/keymaps.lua
-- 1. THE CORE LOGIC FUNCTIONS (No changes here)
local function smart_j()
  if vim.v.count == 0 then
    return vim.fn.line('.') == vim.fn.line('$') and '$' or 'gj'
  end
  return 'j'
end

local function smart_k()
  if vim.v.count == 0 then
    return vim.fn.line('.') == 1 and '^' or 'gk'
  end
  return 'k'
end

-- 2. NORMAL & VISUAL MODE (Directly binding Alt keys)
local modes = { 'n', 'v' }
for _, mode in ipairs(modes) do
  -- Arrow keys & JK
  vim.keymap.set(mode, 'j', smart_j, { expr = true, silent = true })
  vim.keymap.set(mode, 'k', smart_k, { expr = true, silent = true })
  vim.keymap.set(mode, '<Down>', smart_j, { expr = true, silent = true })
  vim.keymap.set(mode, '<Up>', smart_k, { expr = true, silent = true })
  
  -- Alt keys (mapped directly to logic)
  vim.keymap.set(mode, '<M-k>', smart_j, { expr = true, silent = true, desc = 'Smart Down' })
  vim.keymap.set(mode, '<M-,>', smart_j, { expr = true, silent = true, desc = 'Smart Down' })
  vim.keymap.set(mode, '<M-i>', smart_k, { expr = true, silent = true, desc = 'Smart Up' })
end

-- 3. INSERT MODE (Directly binding Alt keys)
local function insert_move(key)
  if key == 'down' then
    if vim.fn.line('.') == vim.fn.line('$') then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-o>$', true, false, true), 'n', true)
    else
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Down>', true, false, true), 'n', true)
    end
  else
    if vim.fn.line('.') == 1 then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-o>^', true, false, true), 'n', true)
    else
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Up>', true, false, true), 'n', true)
    end
  end
end

-- Arrow keys in Insert
vim.keymap.set('i', '<Down>', function() insert_move('down') end, { silent = true })
vim.keymap.set('i', '<Up>', function() insert_move('up') end, { silent = true })

-- Alt keys in Insert (Forcefully override LazyVim defaults)
vim.keymap.set('i', '<M-k>', function() insert_move('down') end, { silent = true, desc = 'Smart Down' })
vim.keymap.set('i', '<M-,>', function() insert_move('down') end, { silent = true, desc = 'Smart Down' })
vim.keymap.set('i', '<M-i>', function() insert_move('up') end, { silent = true, desc = 'Smart Up' })


local opts = { noremap = true}

local function map_visual(shortcut, action)
  vim.keymap.set('v', shortcut, action, opts)
end
local function map_normal(shortcut, action)
  vim.keymap.set('n', shortcut, action, opts)
end

map_normal('<C-c>', function()
  local bufs = vim.fn.getbufinfo({ buflisted = 1 })
  if #bufs > 1 then
    vim.cmd('bdelete')
  else
    vim.cmd('q')
  end
end)

local blink = require('blink.cmp')
blink.setup({
  keymap = {
    ['<C-l>'] = { 'cancel' },  -- cancel completion
  }
})
vim.keymap.set('i', '<C-v>', '<C-r>+', { desc = 'Paste from system clipboard in insert mode' })
vim.keymap.set('v', '<C-c>', 'y', { desc = 'Yank with Ctrl+C in visual mode' })
vim.keymap.set('i', '<C-l>', '<C-e>',{remap=true}) -- break completion
vim.keymap.set('i', '<M-l>', '<C-e>',{remap=true}) -- break completion
map_normal('<C-s>', ':w<CR>') -- save
map_normal('t', 'za') -- toggle section
vim.keymap.set('n', 'ku', 'gcc',{remap=true}) -- toggle comment
vim.keymap.set('v', 'ku', 'gc',{remap=true}) -- toggle comment
vim.keymap.set('n', 'kc', 'gcc',{remap=true}) -- toggle comment
vim.keymap.set('v', 'kc', 'gc',{remap=true}) -- toggle comment
map_normal('<C-f>', '/') -- search
map_normal('<C-y>', '<C-r>') -- redo
map_normal('<C-z>', 'u') -- undo
map_normal('<C-R>', [[:%s%\<<C-r><C-w>\>%%gc<Left><Left><Left>]]) -- search and replace selected word
map_normal('<F2>', [[:%s%\<<C-r><C-w>\>%%gc<Left><Left><Left>]]) -- search and replace selected word
vim.keymap.set('v', '<F2>', function()
  local sel_raw = vim.fn.getregion(vim.fn.getpos('v'), vim.fn.getpos('.'))
  if #sel_raw > 1 then
    -- search and replace in selected text
    vim.api.nvim_input(':s///gc<Left><Left><Left><Left>')
  else
    -- search and replace selected single line text
    vim.api.nvim_input('"hy:%s%<C-r>h%%gc<Left><Left><left>')
  end
end)
vim.keymap.set('v', '<C-R>', function()
  local sel_raw = vim.fn.getregion(vim.fn.getpos('v'), vim.fn.getpos('.'))
  if #sel_raw > 1 then
    -- search and replace in selected text
    vim.api.nvim_input(':s///gc<Left><Left><Left><Left>')
  else
    -- search and replace selected single line text
    vim.api.nvim_input('"hy:%s%<C-r>h%%gc<Left><Left><left>')
  end
end)

map_normal('6', '<C-w>l') -- switch to right window
map_normal('4', '<C-w>h') -- switch to left window
map_normal('8', ':bnext<CR>') -- switch to next tab #TODO
map_normal('2', ':bprevious<CR>') -- switch to previous tab #TODO
map_normal('<A-8>', '<cmd>resize +2<cr>')
map_normal('<A-2>', '<cmd>resize -2<cr>')
map_normal('<A-4>', '<cmd>vertical resize -2<cr>')
map_normal('<A-6>', '<cmd>vertical resize +2<cr>')
map_normal('<F11>',function()
  vim.opt.list = not vim.opt.list:get()
end) -- show hidden

-- Open file in a new window
vim.keymap.set('n', '<C-t>', function()
  vim.cmd('tabnew')
  require('telescope').extensions.file_browser.file_browser()
end, opts)

-- open file in new horizontal split
vim.keymap.set('n', '<A-T>', function()
  vim.cmd('split')
  require('telescope').extensions.file_browser.file_browser()
end, opts)

-- Open file in vertical split
vim.keymap.set('n', '<A-t>', function()
  vim.cmd('vsplit')
  require('telescope').extensions.file_browser.file_browser()
end, opts)

-- Normal Mode: Start Visual Mode and move
vim.keymap.set('n', '<S-Up>', 'v<Up>')
vim.keymap.set('n', '<S-Down>', 'v<Down>')
vim.keymap.set('n', '<S-Left>', 'v<Left>')
vim.keymap.set('n', '<S-Right>', 'v<Right>')

-- Visual Mode: Extend selection (without restarting mode)
vim.keymap.set('v', '<S-Up>', '<Up>')
vim.keymap.set('v', '<S-Down>', '<Down>')
vim.keymap.set('v', '<S-Left>', '<Left>')
vim.keymap.set('v', '<S-Right>', '<Right>')

-- Insert Mode (Optional): Exit insert, start visual, and select
vim.keymap.set('i', '<S-Up>', '<Esc>v<Up>')
vim.keymap.set('i', '<S-Down>', '<Esc>v<Down>')
vim.keymap.set('i', '<S-Left>', '<Esc>v<Left>')
vim.keymap.set('i', '<S-Right>', '<Esc>v<Right>')
-- Search for selected text in Visual mode with Ctrl+f
vim.keymap.set('v', '<C-f>', '"sy/<C-r>s', { noremap = true })
vim.keymap.set('i', '<C-f>', '<Esc>/', { noremap = true })
