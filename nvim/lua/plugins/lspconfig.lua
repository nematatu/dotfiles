-- plugins/lspconfig.lua にまとめて書く
return {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "williamboman/mason.nvim",           version = "^1.0.0" },
        { "williamboman/mason-lspconfig.nvim", version = "^1.0.0" },
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = { "lua_ls", "ts_ls", "denols" },
        })

        local lspconfig = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        local on_attach = function(client)
            vim.notify("LSP client attached: " .. client.name, vim.log.levels.INFO)
            if client.name == "ts_ls" then
                client.server_capabilities.document_formatting = false
                client.server_capabilities.document_range_formatting = false
            end
        end

        local is_deno = function(fname)
            return lspconfig.util.root_pattern("deno.json", "deno.jsonc")(fname) ~= nil
        end

        require("mason-lspconfig").setup_handlers({
            function(server_name)
                local opts = {
                    capabilities = capabilities,
                    on_attach = on_attach,
                }

                if server_name == "denols" then
                    opts.root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc")
                elseif server_name == "ts_ls" then
                    opts.root_dir = function(fname)
                        if is_deno(fname) then
                            return nil
                        end
                        return lspconfig.util.root_pattern("package.json")(fname)
                    end
                    opts.single_file_support = false
                elseif server_name == "lua_ls" then
                    opts.settings = {
                        Lua = {
                            runtime = { version = "LuaJIT", path = { "?.lua", "?/init.lua" } },
                            workspace = {
                                library = { vim.fn.stdpath("config") },
                                maxPreload = 1000,
                                preloadFileSize = 100,
                                checkThirdParty = false,
                            },
                            telemetry = { enable = false },
                        },
                    }
                end

                lspconfig[server_name].setup(opts)
            end,
        })
    end
}
