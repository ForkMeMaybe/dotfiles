-- return {
-- 	"scottmckendry/cyberdream.nvim",
-- 	config = function()
--         vim.cmd.colorscheme("cyberdream")
-- 		-- set transparent background
-- 		-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" } )
--         -- vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
-- 		-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" } )
-- 	end,
-- }

-- return {
-- 	"scottmckendry/cyberdream.nvim",
-- 	config = function()
--         -- Setup cyberdream plugin with customized settings
--         require("cyberdream").setup({
--             -- Enable transparent background
--             transparent = true,
--
--             -- Enable italics comments
--             italic_comments = false,
--
--             -- Replace all fillchars with ' ' for the ultimate clean look
--             hide_fillchars = false,
--
--             -- Modern borderless telescope theme - also applies to fzf-lua
--             borderless_pickers = true,
--
--             -- Set terminal colors used in `:terminal`
--             terminal_colors = true,
--
--             -- Improve start up time by caching highlights
--             cache = false,
--
--             theme = {
--                 variant = "default", -- use "light" for the light variant. Also accepts "auto" to set dark or light colors based on the current value of `vim.o.background`
--                 saturation = 1, -- accepts a value between 0 and 1. 0 will be fully desaturated (greyscale) and 1 will be the full color (default)
--                 highlights = {
--                     -- Highlight groups to override
--                     Comment = { fg = "#696969", bg = "NONE", italic = true },
--                 },
--
--                 -- Override a highlight group entirely using the color palette
--                 overrides = function(colors)
--                     return {
--                         Comment = { fg = colors.green, bg = "NONE", italic = true },
--                         ["@property"] = { fg = colors.magenta, bold = true },
--                     }
--                 end,
--
--                 -- Override a color entirely
--                 colors = {
--                     bg = "#000000",
--                     green = "#00ff00",
--                     magenta = "#ff00ff",
--                 },
--             },
--
--             -- Disable or enable colorscheme extensions
--             extensions = {
--                 telescope = true,
--                 notify = true,
--                 mini = true,
--                 -- Add additional extensions if needed
--             },
--         })
--
--         -- Apply the colorscheme
--         vim.cmd.colorscheme("cyberdream")
--
--         -- Set a semi-transparent background for Neovim UI
--         vim.cmd [[highlight Normal guibg=#000000AA]]
-- 	end,
-- }







return {
	"scottmckendry/cyberdream.nvim",
	config = function()
        require("cyberdream").setup({
            transparent = true,
            italic_comments = false,
            hide_fillchars = false,
            borderless_pickers = true,
            terminal_colors = true,
            cache = false,

            -- Move theme options directly into the setup() table
            variant = "default",
            saturation = 1,
            highlights = {
                Comment = { fg = "#696969", bg = "NONE", italic = true },
            },

            -- Override highlight groups
            overrides = function(colors)
                return {
                    Comment = { fg = colors.green, bg = "NONE", italic = true },
                    ["@property"] = { fg = colors.magenta, bold = true },
                }
            end,

            -- Override specific colors
            colors = {
                bg = "#000000",
                green = "#00ff00",
                magenta = "#ff00ff",
            },

            -- Extensions
            extensions = {
                telescope = true,
                notify = true,
                mini = true,
            },
        })

        vim.cmd.colorscheme("cyberdream")
        vim.cmd [[highlight Normal guibg=#000000AA]]
	end,
}

