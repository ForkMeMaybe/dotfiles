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
