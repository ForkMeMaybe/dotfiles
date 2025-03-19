-- return {
--     "echasnovski/mini.hipatterns",
--     recommended = true,
--     desc = "Highlight colors in your code. Also includes Tailwind CSS support.",
--     -- event = "LazyFile",
--     event = { "BufReadPost", "BufWritePost", "BufNewFile" },
--     opts = function()
--         local hi = require("mini.hipatterns")
--         return {
--             -- custom LazyVim option to enable the tailwind integration
--             tailwind = {
--                 enabled = true,
--                 ft = {
--                     "astro",Error executing vim.schedule lua callback: /home/odd/.config/nvim/lua/odd/plugins/hipattern.lua:73: attempt to index global 'M' (a nil value)
-- stack traceback:
--         /home/odd/.config/nvim/lua/odd/plugins/hipattern.lua:73: in function 'group'
--         .../share/nvim/lazy/mini.hipatterns/lua/mini/hipatterns.lua:941: in function ''
--         vim/_editor.lua: in function <vim/_editor.lua:0>
--                     "css",
--                     "heex",
--                     "html",
--                     "html-eex",
--                     "javascript",
--                     "javascriptreact",
--                     "rust",
--                     "svelte",
--                     "typescript",
--                     "typescriptreact",
--                     "vue",
--                 },
--                 -- full: the whole css class will be highlighted
--                 -- compact: only the color will be highlighted
--                 style = "full",
--             },
--             highlighters = {
--                 hex_color = hi.gen_highlighter.hex_color({ priority = 2000 }),
--                 shorthand = {
--                     pattern = "()#%x%x%x()%f[^%x%w]",
--                     group = function(_, _, data)
--                         ---@type string
--                         local match = data.full_match
--                         local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
--                         local hex_color = "#" .. r .. r .. g .. g .. b .. b
--
--                         return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
--                     end,
--                     extmark_opts = { priority = 2000 },
--                 },
--             },
--         }
--     end,
--     config = function(_, opts)
--         if type(opts.tailwind) == "table" and opts.tailwind.enabled then
--             -- reset hl groups when colorscheme changes
--             vim.api.nvim_create_autocmd("ColorScheme", {
--                 callback = function()
--                     M.hl = {}
--                 end,
--             })
--             opts.highlighters.tailwind = {
--                 pattern = function()
--                     if not vim.tbl_contains(opts.tailwind.ft, vim.bo.filetype) then
--                         return
--                     end
--                     if opts.tailwind.style == "full" then
--                         return "%f[%w:-]()[%w:-]+%-[a-z%-]+%-%d+()%f[^%w:-]"
--                     elseif opts.tailwind.style == "compact" then
--                         return "%f[%w:-][%w:-]+%-()[a-z%-]+%-%d+()%f[^%w:-]"
--                     end
--                 end,
--                 group = function(_, _, m)
--                     ---@type string
--                     local match = m.full_match
--                     ---@type string, number
--                     local color, shade = match:match("[%w-]+%-([a-z%-]+)%-(%d+)")
--                     shade = tonumber(shade)
--                     local bg = vim.tbl_get(M.colors, color, shade)
--                     if bg then
--                         local hl = "MiniHipatternsTailwind" .. color .. shade
--                         if not M.hl[hl] then
--                             M.hl[hl] = true
--                             local bg_shade = shade == 500 and 950 or shade < 500 and 900 or 100
--                             local fg = vim.tbl_get(M.colors, color, bg_shade)
--                             vim.api.nvim_set_hl(0, hl, { bg = "#" .. bg, fg = "#" .. fg })
--                         end
--                         return hl
--                     end
--                 end,
--                 extmark_opts = { priority = 2000 },
--             }
--         end
--         require("mini.hipatterns").setup(opts)
--     end,
-- }











return {
    "echasnovski/mini.hipatterns",
    recommended = true,
    desc = "Highlight colors in your code. Also includes Tailwind CSS support.",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = function()
        local hi = require("mini.hipatterns")
        return {
            tailwind = {
                enabled = true,
                ft = {
                    "astro",
                    "css",
                    "heex",
                    "html",
                    "html-eex",
                    "javascript",
                    "javascriptreact",
                    "rust",
                    "svelte",
                    "typescript",
                    "typescriptreact",
                    "vue",
                },
                style = "full",
            },
            highlighters = {
                hex_color = hi.gen_highlighter.hex_color({ priority = 2000 }),
                shorthand = {
                    pattern = "()#%x%x%x()%f[^%x%w]",
                    group = function(_, _, data)
                        local match = data.full_match
                        local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
                        local hex_color = "#" .. r .. r .. g .. g .. b .. b
                        return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
                    end,
                    extmark_opts = { priority = 2000 },
                },
            },
        }
    end,
    config = function(_, opts)
        local M = {} -- Define M before using it
        M.hl = {}
        M.colors = {} -- Ensure colors table exists

        if type(opts.tailwind) == "table" and opts.tailwind.enabled then
            vim.api.nvim_create_autocmd("ColorScheme", {
                callback = function()
                    M.hl = {} -- Reset highlighting table
                end,
            })
            opts.highlighters.tailwind = {
                pattern = function()
                    if not vim.tbl_contains(opts.tailwind.ft, vim.bo.filetype) then
                        return
                    end
                    if opts.tailwind.style == "full" then
                        return "%f[%w:-]()[%w:-]+%-[a-z%-]+%-%d+()%f[^%w:-]"
                    elseif opts.tailwind.style == "compact" then
                        return "%f[%w:-][%w:-]+%-()[a-z%-]+%-%d+()%f[^%w:-]"
                    end
                end,
                group = function(_, _, m)
                    local match = m.full_match
                    local color, shade = match:match("[%w-]+%-([a-z%-]+)%-(%d+)")
                    shade = tonumber(shade)
                    local bg = vim.tbl_get(M.colors, color, shade) -- Now M.colors is defined
                    if bg then
                        local hl = "MiniHipatternsTailwind" .. color .. shade
                        if not M.hl[hl] then
                            M.hl[hl] = true
                            local bg_shade = shade == 500 and 950 or shade < 500 and 900 or 100
                            local fg = vim.tbl_get(M.colors, color, bg_shade)
                            vim.api.nvim_set_hl(0, hl, { bg = "#" .. bg, fg = "#" .. fg })
                        end
                        return hl
                    end
                end,
                extmark_opts = { priority = 2000 },
            }
        end
        require("mini.hipatterns").setup(opts)
    end,
}

