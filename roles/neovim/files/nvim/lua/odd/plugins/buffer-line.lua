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
                -- Use the buffer's name instead of the current buffer's file path
                local full_path = buf.name  -- 'buf.name' contains the full path of the file in the buffer
                local cwd = vim.fn.getcwd()  -- Get the current working directory

                -- Strip the cwd from the full path to get the relative path
                if full_path:sub(1, #cwd) == cwd then
                    return full_path:sub(#cwd + 2)  -- +2 to account for the trailing slash
                else
                    return full_path  -- Return the full path if it's outside the cwd
                end
            end,
        },
    },
}
