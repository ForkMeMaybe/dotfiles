return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer", -- A source for autocompletion from the current buffer (i.e., it suggests words already typed in the current file).
    "hrsh7th/cmp-path", -- A source for autocompletion of file system paths, useful for suggesting file names when typing paths.
    {
      "L3MON4D3/LuaSnip", -- A snippet engine for Neovim. This allows you to use and expand code snippets in your code (e.g., autocompleting for loops, function definitions).
      -- follow latest release.
      version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
      -- install jsregexp (optional!).
      build = "make install_jsregexp",
    },
    "saadparwaiz1/cmp_luasnip", -- (for autocompletion) Integrates LuaSnip with nvim-cmp, allowing you to use LuaSnip’s snippets in the autocompletion menu.
    "rafamadriz/friendly-snippets", -- (useful snippets) A collection of pre-built snippets for many programming languages that you can use with LuaSnip.
    "onsails/lspkind.nvim", -- Adds VS Code-like pictograms/icons to the autocompletion suggestions. It helps visually distinguish between completion items (e.g., showing an icon for functions, variables, 
    "hrsh7th/cmp-cmdline", -- This plugin extends nvim-cmp to provide autocompletion suggestions for command-line mode in Neovim.
    "nvimdev/lspsaga.nvim", -- lspsaga is a set of enhanced LSP functionalities for Neovim. 
  },
  config = function()
    local cmp = require("cmp")

    local luasnip = require("luasnip")

    local lspkind = require("lspkind")

    -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      completion = {
	--  ensures that the completion menu shows up properly and offers preview options.
        completeopt = "menu,menuone,preview,noselect",
      },
      snippet = { -- configure how nvim-cmp interacts with snippet engine
	-- This tells nvim-cmp to use LuaSnip to expand any snippets when the user selects a snippet suggestion.
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
        ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
	-- <C-b> and <C-f> allow you to scroll through documentation while in the completion menu.
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
        ["<C-e>"] = cmp.mapping.abort(), -- close completion window
        ["<CR>"] = cmp.mapping.confirm({ select = false }), -- <CR> confirms the selected suggestion, but with select = false (meaning you can choose from any item, not just the first).
      }),
      -- sources for autocompletion
      sources = cmp.config.sources({
        { name = "nvim_lsp"},
        { name = "luasnip" }, -- snippets
        { name = "buffer" }, -- text within current buffer
        { name = "path" }, -- file system paths
      }),

      -- configure lspkind for vs-code like pictograms in completion menu
      formatting = {
        format = lspkind.cmp_format({
          maxwidth = 50,
          ellipsis_char = "...",
        }),
      },
    })
  end,
}

