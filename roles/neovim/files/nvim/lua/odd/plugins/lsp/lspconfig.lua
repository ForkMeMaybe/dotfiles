return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
        { "folke/neodev.nvim", opts = {} },
        { "nvimtools/none-ls.nvim" },
    },
    config = function()
        local lspconfig = require("lspconfig")
        local mason_lspconfig = require("mason-lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local null_ls = require("null-ls")  -- changed from require("null-ls")

        local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

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

        mason_lspconfig.setup_handlers({
            function(server_name)
                lspconfig[server_name].setup({
                    capabilities = capabilities,
                })
            end,
            ["emmet_ls"] = function()
                lspconfig["emmet_ls"].setup({
                    capabilities = capabilities,
                    filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
                })
            end,
            ["lua_ls"] = function()
                lspconfig["lua_ls"].setup({
                    capabilities = capabilities,
                    settings = {
                        Lua = {
                            diagnostics = { globals = { "vim" } },
                            completion = { callSnippet = "Replace" },
                        },
                    },
                })
            end,
        })

        local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            pattern = "*.py",
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
                null_ls.builtins.formatting.black.with({
                    extra_args = { "--fast" },
                }),
                null_ls.builtins.diagnostics.sqruff,
                null_ls.builtins.diagnostics.mypy.with({
                    extra_args = { "--strict" },
                }),
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

        -- null_ls.setup({
        --     sources = {
        --         null_ls.builtins.formatting.black,
        --         null_ls.builtins.diagnostics.sqruff,
        --     },
        --     on_attach = function(client, bufnr)
        --         if client.supports_method("textDocument/formatting") then
        --             vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        --             vim.api.nvim_create_autocmd("BufWritePre", {
        --                 group = augroup,
        --                 buffer = bufnr,
        --                 callback = function()
        --                     vim.lsp.buf.format({ async = false })
        --                 end,
        --             })
        --         end
        --     end,
        -- })
    end,
}

