-- return {
--     {
--         "williamboman/mason.nvim",
--         config = function()
--             require("mason").setup({
--                 auto_install = true,
--                 ui = {
--                     icons = {
--                         package_installed = "✓",
--                         package_pending = "➜",
--                         package_uninstalled = "✗",
--                     },
--                 },
--             })
--         end,
--     },
--     {
--         "williamboman/mason-lspconfig.nvim",
--         dependencies = {
--             "williamboman/mason.nvim",
--             "neovim/nvim-lspconfig",
--             "nvimtools/none-ls.nvim", -- changed from null-ls
--             "jay-babu/mason-null-ls.nvim",
--         },
--         config = function()
--             require("mason-lspconfig").setup({
--                 ensure_installed = {
--                     "lua_ls",
--                     "clangd",
--                     "marksman",
--                     "bashls",
--                     "cssls",
--                     "emmet_ls",
--                     "pyright",
--                 },
--             })
--
--             require("mason-null-ls").setup({
--                 ensure_installed = {
--                     "prettier",
--                     "stylua",
--                     "eslint_d",
--                     "ruff",
--                     "black",
--                     "clang-format",
--                     "mypy",
--                     "sqruff",
--                 },
--                 automatic_installation = true,
--             })
--
--             require("mason-lspconfig").setup_handlers({
--                 function(server_name)
--                     require("lspconfig")[server_name].setup({
--                         capabilities = require("cmp_nvim_lsp").default_capabilities(),
--                     })
--                 end,
--
--                 ["pyright"] = function()
--                     local venv_path = os.getenv("VIRTUAL_ENV") and os.getenv("VIRTUAL_ENV") .. "/bin/python" or "python3"
--
--                     require("lspconfig")["pyright"].setup({
--                         capabilities = require("cmp_nvim_lsp").default_capabilities(),
--                         settings = {
--                             python = {
--                                 analysis = {
--                                     typeCheckingMode = "basic",
--                                     useLibraryCodeForTypes = true,
--                                     diagnosticMode = "workspace",
--                                     stubPath = "typings",
--                                 },
--                                 pythonPath = venv_path,
--                             },
--                         },
--                     })
--                 end,
--
--                 ["emmet_ls"] = function()
--                     require("lspconfig")["emmet_ls"].setup({
--                         capabilities = require("cmp_nvim_lsp").default_capabilities(),
--                         filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
--                     })
--                 end,
--
--                 ["lua_ls"] = function()
--                     require("lspconfig")["lua_ls"].setup({
--                         capabilities = require("cmp_nvim_lsp").default_capabilities(),
--                         settings = {
--                             Lua = {
--                                 diagnostics = { globals = { "vim" } },
--                                 completion = { callSnippet = "Replace" },
--                             },
--                         },
--                     })
--                 end,
--             })
--
--             local null_ls = require("null-ls") -- changed from require("null-ls")
--
--             null_ls.setup({
--                 sources = {
--                     null_ls.builtins.formatting.black.with({
--                         extra_args = { "--fast" },
--                     }),
--                     null_ls.builtins.diagnostics.sqruff,
--                     null_ls.builtins.diagnostics.mypy.with({
--                         extra_args = { "--strict" },
--                     }),
--                 },
--                 on_attach = function(client)
--                     if client.resolved_capabilities.document_formatting then
--                         vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
--                     end
--                 end,
--             })
--         end,
--     },
-- }
























return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "clangd",
          "marksman",
          "bashls",
          "cssls",
          "emmet_ls",
          "pyright",
        },
      })
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim", -- formerly null-ls
    },
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = {
          "prettier",
          "stylua",
          "eslint_d",
          "ruff",
          "black",
          "clang-format",
          "mypy",
          "sqruff",
        },
        automatic_installation = true,
      })
    end,
  },
}

