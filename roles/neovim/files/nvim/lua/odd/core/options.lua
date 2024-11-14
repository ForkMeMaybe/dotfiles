local opt = vim.opt

opt.relativenumber = true           -- Show line numbers relative to the current line
opt.number = true                    -- Show the absolute line number on the current line

-- Tabs & Indentation
opt.tabstop = 4                      -- Set the width of a tab character to 4 spaces
opt.shiftwidth = 4                   -- Set the width for auto-indent (used when indenting code) to 4 spaces
opt.expandtab = true                 -- Convert tabs to spaces
opt.autoindent = true                -- Auto-indent new lines to match the current line's indentation
opt.smartindent = true               -- Use "smart" indentation based on syntax and context

opt.wrap = false                     -- Disable line wrapping; long lines extend past the screen width

-- Search Settings
opt.ignorecase = true                -- Ignore case when searching
opt.smartcase = true                 -- If a capital letter is used in the search, make it case-sensitive

opt.cursorline = true                -- Highlight the line where the cursor is located

-- Colorscheme and Terminal Colors
opt.termguicolors = true             -- Enable true color support for better color rendering in terminal
opt.background = "dark"              -- Set background for dark color schemes
opt.signcolumn = "yes"               -- Always show the sign column to avoid text shifting when showing diagnostics

-- Backspace Behavior
opt.backspace = "indent,eol,start"   -- Allow backspace over indentation, line breaks, and start of insert mode

-- Clipboard
opt.clipboard:append("unnamedplus")  -- Use the system clipboard as the default register (yanks and pastes with the system clipboard)

-- Split Windows Behavior
opt.splitright = true                -- Vertical splits open to the right of the current window
opt.splitbelow = true                -- Horizontal splits open below the current window

-- Swap and Undo Files
opt.swapfile = false                 -- Disable swapfile creation to avoid temporary backup files
-- opt.backup = false                 -- (Commented out) Disable backup file creation
-- opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- (Commented out) Set a directory for storing undo history files
-- opt.undofile = true                -- (Commented out) Enable undo files to persist undo history across sessions

-- Search Highlighting
opt.hlsearch = false                 -- Do not keep search results highlighted after the search is complete
opt.incsearch = true                 -- Highlight matches as you type in search

opt.scrolloff = 8                    -- Keep 8 lines of context around the cursor when scrolling

-- opt.colorcolumn = "80"               -- Show a vertical line at column 80 to guide line length

opt.updatetime = 50
