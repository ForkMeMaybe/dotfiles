return {
	"scottmckendry/cyberdream.nvim",
	config = function()
		vim.cmd.colorscheme("cyberdream")
	
		-- set transparent background
		vim.api.nvim_set_hl(0, "Normal", { bg = "none" } )
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" } )
	end,
}
