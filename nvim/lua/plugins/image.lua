return {
    "3rd/image.nvim",
    dependencies = { "luarocks.nvim" },
    config = function()
        local image_opts = {
            backend = "kitty", -- or "ueberzug"
            kitty_method = "normal",
            max_height_window_percentage = 10,
            max_width_window_percentage = 25,
            max_height = 6,
            max_width = 16,
            scale_factor = 1.0,
            window_overlap_clear_enabled = false,
            ignore_download_error = true,
            integrations = {
                markdown = {
                    enabled = true,
                    clear_in_insert_mode = true,
                    only_render_image_at_cursor = true,
                    only_render_image_at_cursor_mode = "inline",
                    download_remote_images = true,
                    filetypes = { "markdown", "vimwiki", "markdown.mdx" },
                    resolve_image_path = function(document_path, image_path, fallback)
                        if image_path:match("^https?://") or image_path:sub(1, 1) == "/" then
                            return image_path
                        end

                        local doc_dir = vim.fn.fnamemodify(document_path, ":p:h")
                        local from_doc = doc_dir .. "/" .. image_path
                        if vim.fn.filereadable(from_doc) == 1 then
                            return from_doc
                        end

                        local from_cwd = vim.fn.getcwd() .. "/" .. image_path
                        if vim.fn.filereadable(from_cwd) == 1 then
                            return from_cwd
                        end

                        return fallback(document_path, image_path)
                    end,
                },
                neorg = { enabled = false },
                typst = { enabled = false },
                syslang = { enabled = false },
                html = { enabled = false },
                css = { enabled = false },
                org = { enabled = false },
            },
            editor_only_render_when_focused = true,
            hijack_file_patterns = {
                "*.png",
                "*.jpg",
                "*.jpeg",
                "*.gif",
                "*.webp",
                "*.svg",
            },
        }

        local image = require("image")
        image.setup(image_opts)

        local function find_image_at_cursor()
            local win = vim.api.nvim_get_current_win()
            local buf = vim.api.nvim_get_current_buf()
            local cursor_row = vim.api.nvim_win_get_cursor(win)[1] - 1
            local images = image.get_images({ window = win, buffer = buf, namespace = "markdown" })
            local closest = nil
            local closest_dist = math.huge
            for _, img in ipairs(images) do
                if img.geometry and img.geometry.y ~= nil then
                    if img.geometry.y == cursor_row then
                        return img
                    end
                    local dist = math.abs(img.geometry.y - cursor_row)
                    if dist < closest_dist then
                        closest = img
                        closest_dist = dist
                    end
                end
            end
            return closest
        end

        local function open_image_popup(img)
            local term = require("image/utils").term.get_size()
            local width = math.max(20, math.floor(term.screen_cols * 0.8))
            local height = math.max(6, math.floor(term.screen_rows * 0.8))
            local row = math.max(0, math.floor((term.screen_rows - height) / 2))
            local col = math.max(0, math.floor((term.screen_cols - width) / 2))

            local buf = vim.api.nvim_create_buf(false, true)
            vim.bo[buf].modifiable = true
            vim.bo[buf].buftype = "nofile"
            vim.bo[buf].bufhidden = "wipe"
            vim.bo[buf].swapfile = false
            vim.bo[buf].filetype = "image_nvim_popup"

            local win = vim.api.nvim_open_win(buf, true, {
                relative = "editor",
                row = row,
                col = col,
                width = width,
                height = height,
                style = "minimal",
                border = "rounded",
            })
            vim.wo[win].winblend = 0
            vim.wo[win].number = false
            vim.wo[win].relativenumber = false
            vim.wo[win].cursorline = false
            vim.wo[win].signcolumn = "no"
            vim.wo[win].foldcolumn = "0"
            vim.api.nvim_win_set_option(win, "winhl", "NormalFloat:Normal,FloatBorder:Normal")

            local filler = {}
            local line = string.rep(" ", width)
            for _ = 1, height do
                filler[#filler + 1] = line
            end
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, filler)
            vim.bo[buf].modifiable = false

            local popup_image = image.from_file(img.original_path, {
                window = win,
                buffer = buf,
                inline = false,
                with_virtual_padding = false,
                render_offset_top = 0,
                namespace = "markdown",
            })

            if popup_image then
                popup_image.ignore_global_max_size = true
                vim.defer_fn(function()
                    if vim.api.nvim_win_is_valid(win) then
                        popup_image:render({ x = 0, y = 0, width = width, height = height })
                    end
                end, 10)
            end

            local closed = false
            local function close_popup()
                if closed then
                    return
                end
                closed = true
                if popup_image then
                    popup_image:clear(true)
                end
                if vim.api.nvim_win_is_valid(win) then
                    vim.api.nvim_win_close(win, true)
                end
            end

            vim.keymap.set("n", "q", close_popup, { buffer = buf, nowait = true })
            vim.api.nvim_create_autocmd({ "WinClosed", "BufLeave" }, {
                once = true,
                buffer = buf,
                callback = close_popup,
            })
        end

        vim.api.nvim_create_user_command("ImageZoom", function()
            local img = find_image_at_cursor()
            if not img or not img.original_path then
                vim.notify("No image under cursor", vim.log.levels.INFO)
                return
            end
            open_image_popup(img)
        end, {})
        vim.keymap.set("n", "<leader>iz", "<cmd>ImageZoom<CR>", { desc = "Image zoom" })

        vim.api.nvim_create_user_command("ImageToggle", function()
            local image = require("image")
            if image.is_enabled() then
                image.disable() -- 描画済み画像も消える
                vim.notify("image.nvim: disabled")
            else
                image.enable()
                vim.notify("image.nvim: enabled")
            end
        end, {})

        vim.keymap.set("n", "<leader>it", "<cmd>ImageToggle<CR>", {
            desc =
            "Toggle image.nvim"
        })
        local json = require("image/utils").json
        if not json._function_safe_encode then
            local original_encode = json.encode
            json.encode = function(value, indent)
                local function sanitize(val, seen)
                    local val_type = type(val)
                    if val_type == "function" then
                        return "<function>"
                    end
                    if val_type ~= "table" then
                        return val
                    end
                    if seen[val] then
                        return "<cycle>"
                    end
                    seen[val] = true
                    local out = {}
                    for k, v in pairs(val) do
                        out[k] = sanitize(v, seen)
                    end
                    return out
                end

                return original_encode(sanitize(value, {}), indent)
            end
            json._function_safe_encode = true
        end
    end,
}
