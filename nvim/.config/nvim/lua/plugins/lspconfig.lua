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
            ensure_installed = { "lua_ls", "ts_ls", "biome", "clangd", "html", "astro" },
        })

        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        local ts_defaults = {}
        do
            local ok, defaults = pcall(require, "lsp.ts_ls")
            if ok and type(defaults) == "table" then
                ts_defaults = defaults
            end
        end

        vim.lsp.config("lua_ls", {
            capabilities = capabilities,
            settings = {
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
            },
        })

        vim.lsp.config("ts_ls", {
            capabilities = capabilities,
            workspace_required = true,
            root_dir = function(bufnr, on_dir)
                if type(ts_defaults.root_dir) == "function" then
                    return ts_defaults.root_dir(bufnr, on_dir)
                end

                local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
                if vim.fn.has("nvim-0.11.3") == 1 then
                    root_markers = { root_markers, { ".git" } }
                else
                    root_markers = vim.list_extend(root_markers, { ".git" })
                end
                local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()
                if project_root then
                    on_dir(project_root)
                end
            end,

    settings = {
      javascript = {
        implicitProjectConfig = {
          checkJs = true,
          strictNullChecks = true,
          noImplicitAny = true,
        },
      },
      typescript = {
        implicitProjectConfig = {
          strictNullChecks = true,
          noImplicitAny = true,
        },
      },
    },
        })

        vim.lsp.enable({ "lua_ls", "ts_ls" })

        local group = vim.api.nvim_create_augroup("user_lsp_ts_formatting", { clear = true })
        vim.api.nvim_create_autocmd("LspAttach", {
            group = group,
            callback = function(event)
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client.name == "ts_ls" then
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                end
            end,
        })

        vim.lsp.config("clangd", {
            autostart = true,
            filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
        })

        vim.lsp.enable({"clangd"})
        vim.lsp.config("html", {
            autostart = true,
            filetypes = { 'html' },
        })
        vim.lsp.enable({"html"})
        vim.lsp.config("astro", {
            autostart = true,
            filetypes = { 'astro' },
        })
        vim.lsp.enable({"astro"})
    end
}
