-- return {
--     "akinsho/toggleterm.nvim",
--     version = "*",
--     config = function()
--         require("toggleterm").setup({
--             size = 60,
--             direction = "vertical",
--             float_opts = {
--                 border = "curved",
--             },
--             open_mapping = [[<c-\>]],
--         })
--
--         -- Define the toggle function globally
--         _G.toggle_terminals = function()
--             local count = vim.v.count1 -- Get the count (e.g., `2<C-\>` -> count = 2)
--             if count > 1 then
--                 -- Toggle a specific terminal
--                 vim.cmd(count .. "ToggleTerm")
--             else
--                 -- Default to toggling the first terminal
--                 local terminals = require("toggleterm.terminal").get_all()
--                 if vim.tbl_isempty(terminals) then
--                     -- Open the first terminal if none are open
--                     vim.cmd("1ToggleTerm")
--                 else
--                     -- Toggle all terminals if at least one is open
--                     for _, term in pairs(terminals) do
--                         term:toggle()
--                     end
--                 end
--             end
--         end
--
--         -- Map <C-\> to toggle all terminals or a specific terminal based on count
--         vim.api.nvim_set_keymap("n", [[<C-\>]], [[:lua toggle_terminals()<CR>]], { noremap = true, silent = true })
--         vim.api.nvim_set_keymap("i", [[<C-\>]], [[:lua toggle_terminals()<CR>]], { noremap = true, silent = true })
--         vim.api.nvim_set_keymap("t", [[<C-\>]], [[:lua toggle_terminals()<CR>]], { noremap = true, silent = true })
--
--         -- Set terminal keymaps for better usability
--         function _G.set_terminal_keymaps()
--             local opts = { noremap = true }
--             vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
--             vim.api.nvim_buf_set_keymap(0, "t", "<S-Space>", [[<C-\><C-n>]], opts)
--             vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
--             vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
--             vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
--             vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
--             vim.api.nvim_buf_set_keymap(0, "t", "<S-l>", [[<C-\><C-n><C-W>l]], opts)
--         end
--         vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
--
--         -- Ensure terminal always starts in insert mode
--         vim.api.nvim_create_autocmd("BufEnter", {
--             pattern = "term://*",
--             callback = function()
--                 vim.defer_fn(function()
--                     vim.cmd("startinsert")
--                 end, 10)
--             end,
--         })
--     end
-- }

return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup({
            size = 60,
            direction = "vertical",
            float_opts = {
                border = "curved",
            },
            open_mapping = [[<c-\>]],
        })

        -- Define the toggle function globally
        _G.toggle_terminals = function()
            local count = vim.v.count1 -- Get the count (e.g., `2<C-\>` -> count = 2)
            if count > 1 then
                -- Toggle a specific terminal
                vim.cmd(count .. "ToggleTerm")
            else
                -- Default to toggling the first terminal
                local terminals = require("toggleterm.terminal").get_all()
                if vim.tbl_isempty(terminals) then
                    -- Open the first terminal if none are open
                    vim.cmd("1ToggleTerm")
                else
                    -- Toggle all terminals if at least one is open
                    for _, term in pairs(terminals) do
                        term:toggle()
                    end
                end
            end
        end

        -- Map <C-\> to toggle all terminals or a specific terminal based on count
        vim.api.nvim_set_keymap("n", [[<C-\>]], [[:lua toggle_terminals()<CR>]], { noremap = true, silent = true })
        vim.api.nvim_set_keymap("i", [[<C-\>]], [[:lua toggle_terminals()<CR>]], { noremap = true, silent = true })
        vim.api.nvim_set_keymap("t", [[<C-\>]], [[:lua toggle_terminals()<CR>]], { noremap = true, silent = true })

        -- Set terminal keymaps for better usability
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

