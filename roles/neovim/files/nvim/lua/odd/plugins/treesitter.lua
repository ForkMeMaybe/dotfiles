return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate", -- Automatically run `:TSUpdate` after installation
  config = function()
    require("nvim-treesitter.configs").setup({
      -- List of parsers to install or "all"
      ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "python", "php" },

      -- Install parsers synchronously for `ensure_installed`
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      auto_install = true,

      highlight = {
        enable = true, -- Enable Treesitter-based highlighting

        -- Run `:h syntax` and Treesitter at the same time if needed
        additional_vim_regex_highlighting = false,
      },
    })
  end,
}

