-- set leader to space key
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
-- "=" and not "+" because of Asus Rog Keyboard
keymap.set("n", "<leader>=", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- splimove selected text up or downt move selected text up or downwindow move selected text up or downvertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Split navigation
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to below split" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to above split" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- move selected text up or down
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = 'move selected text up or down' })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = 'move selected text up or down' })


-- takes the line below you and append it to the current line with a space. Allows cursor to remain place
keymap.set("n", "J", "mzJ`z", { desc = 'takes the line below you and append it to the current line with a space. Allows cursor to remain place' })
-- allow half page jumping
keymap.set("n", "<C-d>", "<C-d>zz", { desc = 'allow half page jumping' })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = 'allow half page jumping' })

-- "N" allows search term to stay in the middle
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv", { desc = 'allows search term to stay in the middle' })

-- if you copy a text and want to paste it over some other text without losing the original copied text.
keymap.set("x", "<leader>p", [["_dP]], { desc = 'if you copy a text and want to paste it over some other text without losing the original copied text.' })

-- edit the word your cursor is on throughout the file
keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'edit the word your cursor is on throughout the file' })
-- make a file executable
keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = 'make a file executable' })

-- Copy and paste selected lines or current line if no selection is active
keymap.set('n', '<C-S-Down>', ':t.<CR>gv', { noremap = true, silent = true, desc = 'copy and paste current line' })
keymap.set('v', '<C-S-Down>', ":t'><CR>gv", { noremap = true, silent = true, desc = 'copy and paste selected lines' })

-- Map Ctrl + h, j, k, l for visual selection starting from the cursor's position
keymap.set('n', '<C-S-h>', 'vh', { desc = 'Select text to the left of the line using Ctrl+Shift+h' })  -- Select to the left
keymap.set('n', '<C-S-l>', 'vl', { desc = 'Select text to the right of the line using Ctrl+Shift+l' })    -- Select to the right
keymap.set('n', '<C-S-k>', 'vk', { desc = 'Select the current line upwards using Ctrl+Shift+k' })        -- Select upwards
keymap.set('n', '<C-S-J>', 'vj', { desc = 'Select the current line downwards using Ctrl+Shift+j' })      -- Select downwards
keymap.set('n', '<C-S-Left>', 'v0', { desc = 'Select text to the beginning of the line using Ctrl+Shift+Left' })  -- Select to the beginning of the line
keymap.set('n', '<C-S-Right>', 'v$', { desc = 'Select text to the end of the line using Ctrl+Shift+Right' })    -- Select to the end of the line
keymap.set('n', '<C-S-Up>', 'vgg', { desc = 'Select text to the beginning of the line using Ctrl+Shift+Up' })  -- Select to the beginning of the file
-- keymap.set('n', '<C-S-Down>', 'vG', { desc = 'Select text to the end of the line using Ctrl+Shift+Right' })    -- Select to the end of the file


-- Enable indenting when pressing Tab in visual mode
vim.api.nvim_set_keymap('v', '<Tab>', '>gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-Tab>', '<gv', { noremap = true, silent = true })
