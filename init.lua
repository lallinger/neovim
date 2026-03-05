require("config.lazy")
-- fix for terminal copy/paste timeout
function no_paste(reg)
    return function(lines)
        -- Do nothing! We cant paste with OSC52
    end
end

vim.g.clipboard = {
    name = "OSC 52",
    copy = {
         ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
         ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
        ["+"] = no_paste("+"), -- Pasting disabled
        ["*"] = no_paste("*"), -- Pasting disabled
    }
}
vim.cmd(":set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<,space:⋅")
vim.cmd(":set nolist")
vim.cmd(":set whichwrap+=<,>,[,]")

local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = true, desc = desc })
end

-- Create a group so we don't duplicate the autocmd on reload
local custom_nav_group = vim.api.nvim_create_augroup('AltNavFix', { clear = true })

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
    group = custom_nav_group,
    pattern = '*',
    callback = function()
        -- 1. NAVIGATION (Alt + JIKL)
        -- Normal Mode (Force override Move Line)
        map('n', '<M-j>', '<Left>',  'Move Left')
        map('n', '<M-l>', '<Right>', 'Move Right')

        -- Insert Mode (Move without exiting)
        map('i', '<M-j>', '<Left>',  'Move Left')
        map('i', '<M-l>', '<Right>', 'Move Right')

        -- Visual Mode (Force override Move Line selection)
        map('v', '<M-j>', '<Left>',  'Move Left')
        map('v', '<M-l>', '<Right>', 'Move Right')

        -- control (:) mode
        map('c', '<M-j>', '<Left>',  'Move Left')
        map('c', '<M-i>', '<Up>',    'Move Up')
        map('c', '<M-k>', '<Down>',  'Move Down')
        map('c', '<M-,>', '<Down>',  'Move Down')
        map('c', '<M-l>', '<Right>', 'Move Right')

        -- 2. SELECTION (Alt + Shift + JIKL)
        -- Normal Mode -> Starts Visual mode
        map('n', '<M-S-j>', 'v<Left>',  'Select Left')
        map('n', '<M-S-i>', 'v<Up>',    'Select Up')
        map('n', '<M-S-k>', 'v<Down>',  'Select Down')
        map('n', '<M-;>', 'v<Down>',  'Select Down')
        map('n', '<M-S-l>', 'v<Right>', 'Select Right')

        -- Add these specifically inside your callback function:

        -- From Insert Mode -> Start Selection (Alt + Shift + JIKL)
        -- We use 'v' to start character-wise visual mode
        map('i', '<M-S-j>', '<Esc>v<Left>',  'Select Left from Insert')
        map('i', '<M-S-i>', '<Esc>v<Up>',    'Select Up from Insert')
        map('i', '<M-S-k>', '<Esc>v<Down>',  'Select Down from Insert')
        map('i', '<M-;>', '<Esc>v<Down>',  'Select Down from Insert')
        map('i', '<M-S-l>', '<Esc>v<Right>', 'Select Right from Insert')

        -- Visual Mode -> Extends current selection
        map('v', '<M-S-j>', '<Left>',  'Extend Select Left')
        map('v', '<M-S-i>', '<Up>',    'Extend Select Up')
        map('v', '<M-S-k>', '<Down>',  'Extend Select Down')
        map('v', '<M-;>', '<Down>',  'Extend Select Down')
        map('v', '<M-S-l>', '<Right>', 'Extend Select Right')
    end,
})

-- break insert and visual mode
vim.keymap.set('i', '<C-o>', '<Esc>', { noremap = true, silent = true })
vim.keymap.set('v', '<C-o>', '<Esc>', { noremap = true, silent = true })
vim.keymap.set('i', '<M-o>', '<Esc>', { noremap = true, silent = true })
vim.keymap.set('v', '<M-o>', '<Esc>', { noremap = true, silent = true })


-- Move to start of line (Alt+d)
vim.keymap.set({'n', 'i', 'v'}, '<M-S-a>', '<Home>', { noremap = true, silent = true })
vim.keymap.set({'n', 'i', 'v'}, '<M-a>', '<Home>', { noremap = true, silent = true })
-- Move to end of line (Alt+f)
vim.keymap.set({'n', 'i', 'v'}, '<M-S-f>', '<End>', { noremap = true, silent = true })
vim.keymap.set({'n', 'i', 'v'}, '<M-f>', '<End>', { noremap = true, silent = true })

-- Page Down with Alt+x
vim.keymap.set({'n', 'i', 'v'}, '<M-S-x>', '<PageDown>', { noremap = true, silent = true })
vim.keymap.set({'n', 'i', 'v'}, '<M-x>', '<PageDown>', { noremap = true, silent = true })
-- Page Up with Alt+e
vim.keymap.set({'n', 'i', 'v'}, '<M-S-e>', '<PageUp>', { noremap = true, silent = true })
vim.keymap.set({'n', 'i', 'v'}, '<M-e>', '<PageUp>', { noremap = true, silent = true })
vim.keymap.set({'n', 'i', 'v'}, '<M-S-r>', '<PageUp>', { noremap = true, silent = true })
vim.keymap.set({'n', 'i', 'v'}, '<M-r>', '<PageUp>', { noremap = true, silent = true })


-- Paste from system clipboard with Alt+v
-- Normal Mode: Paste after cursor
vim.keymap.set('n', '<M-v>', 'p', { noremap = true })
-- Insert Mode: Paste at cursor (using <C-r> to stay in Insert mode)
vim.keymap.set('i', '<M-v>', '<C-r>+', { noremap = true })
-- Visual Mode: Replace selection with clipboard content
vim.keymap.set('v', '<M-v>', 'p', { noremap = true })
-- Copy to system clipboard with Alt+c
-- Normal Mode: Copy the current line
vim.keymap.set('n', '<M-c>', 'yy', { noremap = true, silent = true })
-- Visual Mode: Copy the selection
vim.keymap.set('v', '<M-c>', 'y', { noremap = true, silent = true })
-- Insert Mode: Copy the current line (without leaving Insert mode)
vim.keymap.set('i', '<M-c>', '<C-o>yy', { noremap = true, silent = true })
-- Make Alt+Enter behave like a normal Enter key in Insert mode
vim.keymap.set('i', '<M-CR>', '<CR>', { noremap = true, silent = true })
-- Also useful: Normal mode Alt+Enter creates a new line below without leaving Normal mode
vim.keymap.set('n', '<M-CR>', 'i<Right><CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-v>', 'p', { noremap = true, silent = true })
-- Make Alt+d act like the Delete key
vim.keymap.set({'n', 'i', 'v'}, '<M-d>', '<Del>', { noremap = true, silent = true })
-- Force Alt+Backspace to just be Backspace in Insert Mode
vim.keymap.set('i', '<M-BS>', '<BS>', { noremap = true, silent = true })
