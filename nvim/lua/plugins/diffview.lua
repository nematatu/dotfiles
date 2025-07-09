return {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    -- cmd = { "diffviewopen", "diffviewfilehistory" },
    config = function()
        require("diffview").setup()
    end
}
