return {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		dashboard.section.header.val = {
			" _______  _____   ______ _     _ _______ _______ _______ _______ __   __ ______  _______ ",
			" |______ |     | |_____/ |____/  |  |  | |______ |  |  | |_____|   \\_/   |_____] |______ ",
			" |       |_____| |    \\_ |    \\_ |  |  | |______ |  |  | |     |    |    |_____] |______ ",
			"                                                                                         ",
		}

		dashboard.section.buttons.val = {
			dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
			dashboard.button("r", "  Recent files", ":Telescope oldfiles <CR>"),
			dashboard.button("q", "  Quit", ":qa <CR>"),
		}

		alpha.setup(dashboard.opts)
	end,
}
