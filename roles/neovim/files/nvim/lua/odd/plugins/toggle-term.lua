return	{
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function ()
        require("toggleterm").setup({
            size = 60,
            direction = "vertical",
            float_opts = {
                border = "curved",
            },
            open_mapping = [[<c-\>]],
        })
        function _G.set_terminal_keymaps()
            local opts = { noremap = true }
            vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
            vim.api.nvim_buf_set_keymap(0, "t", "<S-Space>", [[<C-\><C-n>]], opts)
            vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
            vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
            vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
            vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
            vim.api.nvim_buf_set_keymap(0, "t", "<S-l>", [[<C-\><C-n><C-W>l]], opts)
        end
        vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

        -- Ensure terminal always starts in insert mode
        vim.api.nvim_create_autocmd("BufEnter", {
            pattern = "term://*",
            callback = function()
                vim.defer_fn(function()
                    vim.cmd("startinsert")
                end, 10)
            end,
        })
    end
}
