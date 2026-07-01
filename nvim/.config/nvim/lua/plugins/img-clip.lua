local function run(cmd)
  local out = vim.fn.system(cmd)
  return vim.v.shell_error == 0 or vim.notify(cmd[1] .. " failed: " .. out, 4)
end

local function template(ctx)
  local avif = ctx.file_path:gsub("%.png$", ".avif")
  local obj = "r2:blog-images/paste-images/" .. vim.fn.fnamemodify(avif, ":t")
  local rcl = vim.fn.glob(vim.fn.expand("~/.local/share/mise/installs/rclone/latest/rclone-*/rclone")):match("[^\n]+") or "rclone"
  local p3, srgb = "/System/Library/ColorSync/Profiles/Display P3.icc", "/System/Library/ColorSync/Profiles/sRGB Profile.icc"
  local magick = vim.fn.executable("magick") == 1 and "magick" or "convert"
  local m = { magick, ctx.file_path }
  if vim.fn.filereadable(p3) == 1 and vim.fn.filereadable(srgb) == 1 then
    vim.list_extend(m, { "-profile", p3, "-profile", srgb })
  else
    vim.list_extend(m, { "-colorspace", "sRGB" })
  end
  vim.list_extend(m, { "-strip", "-density", 72, "-alpha", "on", ctx.file_path })

  if run(m) and run({ "avifenc", "-q", 100, "-s", 8, "-y", "444", "--cicp", "1/13/1", "-r", "f", "--advanced", "color:sharpness=2", ctx.file_path, avif }) and run({ rcl, "copyto", "--contimeout", "10s", avif, obj }) then
    local url = vim.fn.system({ rcl, "link", obj })
    local link = vim.v.shell_error == 0 and url:match("https?://[^\n]+")
    vim.fn.delete(ctx.file_path); vim.fn.delete(avif)
    if link then return ("![](%s)"):format(link) end
  end
  return ("![](%s)"):format(ctx.file_path)
end

return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  opts = {
    default = {
      dir_path = vim.fn.stdpath("cache") .. "/img-clip",
      file_name = function() return os.date("%Y%m%d%H%M%S") end,
      prompt_for_file_name = false, -- 入力欄を非表示にする
      use_absolute_path = true,
      template = template,
      drag_and_drop = { insert_mode = true },
    },
    filetypes = { markdown = { template = template, prompt_for_file_name = false } },
  },
  config = function(_, opts)
    local paths = { "/opt/homebrew/bin", vim.fn.expand("~/.local/share/mise/installs/rclone/latest/bin") }
    for _, d in ipairs(paths) do
      if vim.fn.isdirectory(d) == 1 and not vim.env.PATH:find(d, 1, true) then
        vim.env.PATH = d .. ":" .. vim.env.PATH
      end
    end
    require("img-clip").setup(opts)
  end,
  keys = { { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image" } },
}
