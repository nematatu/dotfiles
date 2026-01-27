return {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local null_ls = require("null-ls")
        local sources = {
            null_ls.builtins.formatting.clang_format,
        }

        local function add_builtin(getter)
            local ok, builtin = pcall(getter)
            if ok and builtin then
                table.insert(sources, builtin)
            end
        end

        add_builtin(function()
            return null_ls.builtins.formatting.biome
        end)
        add_builtin(function()
            return null_ls.builtins.diagnostics.biome
        end)
        add_builtin(function()
            return null_ls.builtins.code_actions.biome
        end)

        null_ls.setup({
            sources = sources,
        })
    end,
}
