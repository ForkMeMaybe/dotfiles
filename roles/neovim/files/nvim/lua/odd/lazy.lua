-- Load lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ import = "odd.plugins" },
	{ import = "odd.plugins.lsp" },
}, {
	checker = {
		enabled = true,
		notify = true,
	},
	change_detection = {
		notify = true,
	},
	-- Global options for Lazy.nvim to disable luarocks support
	rocks = {
		enabled = false,      -- Disable luarocks support completely
		hererocks = false,    -- Disable hererocks specifically
	}
})

