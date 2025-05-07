-- https://github.com/okuuva/auto-save.nvim
-- This is a fork of original plugin `pocco81/auto-save.nvim` but the original
-- one was updated 2 years ago, and I was experiencing issues with autoformat
-- undo/redo
--
-- Filename: ~/github/dotfiles-latest/neovim/nvim-lazyvim/lua/plugins/auto-save.lua
-- ~/github/dotfiles-latest/neovim/nvim-lazyvim/lua/plugins/auto-save.lua

-- return {
--     {
--         "okuuva/auto-save.nvim",
--         cmd = "ASToggle", -- optional for lazy loading on command
--         event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
--         opts = {
--             --
--             -- All of these are just the defaults
--             --
--             enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
--             trigger_events = { -- See :h events
--                 immediate_save = { "BufLeave", "FocusLost" }, -- vim events that trigger an immediate save
--                 defer_save = { "InsertLeave", "TextChanged" }, -- vim events that trigger a deferred save (saves after `debounce_delay`)
--                 cancel_deferred_save = { "InsertEnter" }, -- vim events that cancel a pending deferred save
--             },
--             -- function that takes the buffer handle and determines whether to save the current buffer or not
--             -- return true: if buffer is ok to be saved
--             -- return false: if it's not ok to be saved
--             -- if set to `nil` then no specific condition is applied
--             condition = nil,
--             write_all_buffers = false, -- write all buffers when the current one meets `condition`
--             -- Do not execute autocmds when saving
--             -- This is what fixed the issues with undo/redo that I had
--             -- https://github.com/okuuva/auto-save.nvim/issues/55
--             noautocmd = false,
--             lockmarks = false, -- lock marks when saving, see `:h lockmarks` for more details
--             -- delay after which a pending save is executed (default 1000)
--             debounce_delay = 1000, -- This could be adjusted slightly to allow time for formatting
--             -- log debug messages to 'auto-save.log' file in neovim cache directory, set to `true` to enable
--             debug = false,
--         },
--         config = function()
--             -- Hook into the auto-save plugin to delay format after a paste
--             vim.api.nvim_create_autocmd("TextChanged", {
--                 group = vim.api.nvim_create_augroup("AutoSaveFormatting", { clear = true }),
--                 callback = function()
--                     -- Check if a format action is available, if so format after the delay
--                     vim.defer_fn(function()
--                         if vim.lsp.buf.format then
--                             vim.lsp.buf.format({ async = false })
--                         end
--                     end, 50) -- 50ms delay to make sure paste is done
--                 end,
--             })
--         end,
--     },
-- }

















return {
    {
        "okuuva/auto-save.nvim",
        event = "VeryLazy", -- more reliable
        opts = {
            enabled = true,
            trigger_events = {
                immediate_save = { "BufLeave", "FocusLost" },
                defer_save = { "InsertLeave", "TextChanged" },
                cancel_deferred_save = { "InsertEnter" },
            },
            debounce_delay = 1000,
            condition = function(buf)
                -- optional: only save normal files, not help or terminal
                local ft = vim.bo[buf].filetype
                return vim.fn.getbufvar(buf, "&modifiable") == 1 and ft ~= "help" and ft ~= "terminal"
            end,
            noautocmd = false,
        },
    },
}
