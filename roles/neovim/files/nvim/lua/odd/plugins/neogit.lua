return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",         -- required
    "sindrets/diffview.nvim",        -- optional - Diff integration
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    -- Set up a keymap to launch Neogit
    vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = 'open neogit' })
  end
}

