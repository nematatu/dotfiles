local remote = "r2:blog-images/paste-images"

local function file_name()
    return os.date("%Y%m%d%H%M%S")
end

local function run(cmd)
    local output = vim.fn.system(cmd)
    if vim.v.shell_error ~= 0 then
        vim.notify(output, vim.log.levels.ERROR)
        return false
    end
    return true
end

local function template(context)
    local url = vim.fn.system({ "rclone", "link", ("%s/%s"):format(remote, context.file_name) })
    if vim.v.shell_error ~= 0 then
        vim.notify(url, vim.log.levels.ERROR)
        return context.file_path
    end
    vim.fn.delete(context.file_path)
    return ("![](%s)"):format(vim.trim(url):match("[^\n]+$"))
end

local function patch_clipboard()
    local clipboard = require("img-clip.clipboard")

    clipboard.content_is_image = function()
        local output = vim.fn.system({
            "osascript",
            "-e",
            "try",
            "-e",
            "the clipboard as «class PNGf»",
            "-e",
            "return \"1\"",
            "-e",
            "on error",
            "-e",
            "return \"0\"",
            "-e",
            "end try",
        })
        return vim.trim(output) == "1"
    end

    clipboard.save_image = function(file_path)
        local png = vim.fn.tempname() .. ".png"
        local avif = vim.fn.fnamemodify(file_path, ":p")
        local object = remote .. "/" .. vim.fn.fnamemodify(avif, ":t")

        local ok = run({
            "osascript",
            "-e",
            "set pngData to (the clipboard as «class PNGf»)",
            "-e",
            "set outFile to open for access POSIX file " .. vim.inspect(png) .. " with write permission",
            "-e",
            "set eof outFile to 0",
            "-e",
            "write pngData to outFile",
            "-e",
            "close access outFile",
        })
            and run({ "avifenc", "--lossless", "--speed", "4", png, avif })
            and run({ "rclone", "copyto", avif, object })

        vim.fn.delete(png)
        return ok
    end
end

return {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
        default = {
            dir_path = vim.fn.stdpath("cache") .. "/img-clip",
            extension = "avif",
            file_name = file_name,
            prompt_for_file_name = false,
            template = template,
        },
    },
    config = function(_, opts)
        require("img-clip").setup(opts)
        patch_clipboard()
    end,
    keys = {
        { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
    },
}
