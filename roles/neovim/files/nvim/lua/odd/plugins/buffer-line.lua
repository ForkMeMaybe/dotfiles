return {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    version = "*",
    opts = {
        options = {
            mode = "tabs",
            separator_style = "slant",
            -- Set max name length to a large value
            max_name_length = 40,  -- Adjust this value to suit your screen size
            max_prefix_length = 20,  -- Optional: Adjust prefix length
            name_formatter = function(buf)
                local full_path = vim.fn.expand("%:p")  -- Get the full file path
                local cwd = vim.fn.getcwd()  -- Get the current working directory
                -- Strip the cwd from the full path to get the relative path
                local relative_path = full_path:sub(#cwd + 2)  -- Remove the cwd part
                return relative_path
            end,
        },
    },
}


