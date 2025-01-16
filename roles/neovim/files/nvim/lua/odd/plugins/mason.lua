-- return {
--     {
--         "williamboman/mason.nvim",
--         config = function()
--             -- Configure mason to auto-install tools
--             require("mason").setup({
--                 auto_install = true,  -- Automatically installs tools managed by mason
-- 		ui = {
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
--             "williamboman/mason.nvim",       -- mason for managing LSP servers
--             "neovim/nvim-lspconfig",         -- nvim-lspconfig for LSP configuration
-- 	    "jose-elias-alvarez/null-ls.nvim", -- null-ls for external tools integration
--             "jay-babu/mason-null-ls.nvim",   -- mason-null-ls for integrating external tools with null-ls
--         },
--         config = function()
--             -- Setup mason-lspconfig to ensure certain LSP servers are installed
--             require("mason-lspconfig").setup({
--                 ensure_installed = {
--                     "lua_ls",      -- Lua language server
--                     "clangd",      -- C/C++/Objective-C language server
--                     "marksman",    -- Markdown language server
--                     "bashls",      -- Bash language server
--                     "cssls",       -- CSS language server
--                     "emmet_ls",    -- Emmet language server (HTML, CSS, etc.)
--         		    "pyright",     -- Python language server
--                 },
--             })
--
--             -- Setup mason-null-ls to ensure certain external tools are installed
--             require("mason-null-ls").setup({
--                 ensure_installed = {
--                     "prettier",     -- ts/js formatter
--                     "stylua",       -- Lua formatter
--                     "eslint_d",     -- ts/js linter
--                     "ruff",         -- Python linter
--                     "black",        -- Python formatter
--                     "clang-format", -- C/C++ formatter
--                     "mypy", -- Python type checker
--                    -- "checkmake",    -- Makefile checker
--                 },
--                 automatic_installation = true,  -- Automatically install external tools if missing
--             })
--         end,
--     },
-- }

return {
    {
        "williamboman/mason.nvim",
        config = function()
            -- Configure mason to auto-install tools
            require("mason").setup({
                auto_install = true,  -- Automatically installs tools managed by mason
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
            "williamboman/mason.nvim",       -- mason for managing LSP servers
            "neovim/nvim-lspconfig",         -- nvim-lspconfig for LSP configuration
            "jose-elias-alvarez/null-ls.nvim", -- null-ls for external tools integration
            "jay-babu/mason-null-ls.nvim",   -- mason-null-ls for integrating external tools with null-ls
        },
        config = function()
            -- Setup mason-lspconfig to ensure certain LSP servers are installed
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",      -- Lua language server
                    "clangd",      -- C/C++/Objective-C language server
                    "marksman",    -- Markdown language server
                    "bashls",      -- Bash language server
                    "cssls",       -- CSS language server
                    "emmet_ls",    -- Emmet language server (HTML, CSS, etc.)
                    "pyright",     -- Python language server
                },
            })

            -- Setup mason-null-ls to ensure certain external tools are installed
            require("mason-null-ls").setup({
                ensure_installed = {
                    "prettier",     -- ts/js formatter
                    "stylua",       -- Lua formatter
                    "eslint_d",     -- ts/js linter
                    "ruff",         -- Python linter
                    "black",        -- Python formatter
                    "clang-format", -- C/C++ formatter
                    "mypy",         -- Python type checker
                },
                automatic_installation = true,  -- Automatically install external tools if missing
            })

            -- Custom handler for Pyright to specify settings
            require("mason-lspconfig").setup_handlers({
                -- Default handler for all LSP servers
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        capabilities = require("cmp_nvim_lsp").default_capabilities(),
                    })
                end,
                
                -- Custom handler for Pyright to specify Python settings
                ["pyright"] = function()
                    require("lspconfig")["pyright"].setup({
                        capabilities = require("cmp_nvim_lsp").default_capabilities(),
                        settings = {
                            python = {
                                analysis = {
                                    typeCheckingMode = "strict", -- Use strict type checking
                                    useLibraryCodeForTypes = true,
                                    diagnosticMode = "workspace",
                                    stubPath = "typings",
                                },
                                pythonPath = "/home/odd/.local/share/virtualenvs/Shop-Sphere-CQc6ccCN/bin/python", -- Path to the virtual environment Python interpreter
                            },
                        },
                    })
                end,
                
                -- Example of other LSPs
                ["emmet_ls"] = function()
                    require("lspconfig")["emmet_ls"].setup({
                        capabilities = require("cmp_nvim_lsp").default_capabilities(),
                        filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
                    })
                end,
                
                ["lua_ls"] = function()
                    require("lspconfig")["lua_ls"].setup({
                        capabilities = require("cmp_nvim_lsp").default_capabilities(),
                        settings = {
                            Lua = {
                                diagnostics = { globals = { "vim" } },
                                completion = { callSnippet = "Replace" },
                            },
                        },
                    })
                end,
            })

            -- Setup null-ls for Python tools like formatting (black), diagnostics (ruff), and static checking (mypy)
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    -- Python formatter (Black)
                    null_ls.builtins.formatting.black.with({
                        extra_args = { "--fast" },  -- Optional: Faster formatting with black
                    }),
                    -- Python linter (Ruff)
                    null_ls.builtins.diagnostics.ruff,
                    -- Static type checker (Mypy)
                    null_ls.builtins.diagnostics.mypy.with({
                        extra_args = { "--strict" },
                    }),
                },
                -- Optional: You can define your custom format on save actions
                on_attach = function(client)
                    -- Automatically format on save if the formatter is available
                    if client.resolved_capabilities.document_formatting then
                        vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
                    end
                end,
            })
        end,
    },
}

