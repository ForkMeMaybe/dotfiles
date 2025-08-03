return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
    { "nvimtools/none-ls.nvim" }, -- formerly null-ls
  },
  config = function()
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local null_ls = require("null-ls") -- formerly null-ls

    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN]  = " ",
          [vim.diagnostic.severity.HINT]  = "󰠠 ",
          [vim.diagnostic.severity.INFO]  = " ",
        },
      },
    })

    local keymap = vim.keymap
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        keymap.set("n", "K", vim.lsp.buf.hover, opts)
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
      end,
    })

    local capabilities = cmp_nvim_lsp.default_capabilities()

    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            completion = { callSnippet = "Replace" },
          },
        },
      },
      emmet_ls = {
        filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
      },
      pyright = {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
              stubPath = "typings",
            },
            pythonPath = os.getenv("VIRTUAL_ENV") and os.getenv("VIRTUAL_ENV") .. "/bin/python" or "python3",
          },
        },
      },
      clangd = {},
      marksman = {},
      bashls = {},
      cssls = {},
      jdtls = {},
    }

    -- for server_name, config in pairs(servers) do
    --   config.capabilities = capabilities
    --   lspconfig[server_name].setup(config)
    -- end

    for server_name, config in pairs(servers) do
      config.capabilities = capabilities
      if server_name ~= "jdtls" then
        lspconfig[server_name].setup(config)
      end
    end


    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = function()
        local jdtls = require("jdtls")
        local jdtls_setup = require("jdtls.setup")

        local root_dir = jdtls_setup.find_root({ ".git", "pom.xml", "build.gradle", "mvnw", "gradlew"}) or vim.fn.getcwd()
        local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
        local workspace_dir = vim.fn.stdpath("data") .. "/site/java/workspace-root/" .. project_name

        jdtls.start_or_attach({
          cmd = { "jdtls" },
          root_dir = root_dir,
          capabilities = capabilities,
          workspace_folders = { { name = "workspace", uri = vim.uri_from_fname(workspace_dir) } },
          settings = {},
        })
      end,
    })



    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      pattern = { "*.py", "*.java" },
      callback = function()
        vim.lsp.buf.format({
          async = false,
          filter = function(client)
            return client.name == "null-ls"
          end,
        })
      end,
    })

    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.black,
        null_ls.builtins.diagnostics.sqruff,
        null_ls.builtins.formatting.google_java_format,
      },
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false })
            end,
          })
        end
      end,
    })
  end,
}

