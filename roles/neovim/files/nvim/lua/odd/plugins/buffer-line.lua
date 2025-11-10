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
                local buflist = vim.fn.getbufinfo({buflisted = 1})
                local duplicates = {}
                for _, b in ipairs(buflist) do
                    local file_name = vim.fn.fnamemodify(b.name, ":t")
                    if duplicates[file_name] == nil then
                        duplicates[file_name] = {}
                    end
                    table.insert(duplicates[file_name], b.bufnr)
                end

                local file_name = vim.fn.fnamemodify(buf.name, ":t")
                if duplicates[file_name] and #duplicates[file_name] > 1 then
                    return vim.fn.fnamemodify(buf.name, ":p:h:t") .. "/" .. file_name
                else
                    return file_name
                end
            end,
        },
    },
}
