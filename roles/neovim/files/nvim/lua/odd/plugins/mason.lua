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
                    "mypy", -- Python type checker
                   -- "checkmake",    -- Makefile checker
                },
                automatic_installation = true,  -- Automatically install external tools if missing
            })
        end,
    },
}

