-- plugins.lua or another plugin file
return {
    {
        "tweekmonster/django-plus.vim",
        ft = { "python", "html", "htmldjango" },
        config = function()
            -- Optional: Add custom mappings or configurations here
            -- Example: vim.keymap.set('n', '<leader>...', '<cmd>...')
        end,
    },
}

