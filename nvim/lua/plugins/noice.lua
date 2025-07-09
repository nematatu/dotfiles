return {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
        views = {
            notify = {
                backend = "notify"
            }
        },
        routes = {
            {
                view = "notify",
                filter = { event = "msg_showmode" },
            },
        },
    }
}
