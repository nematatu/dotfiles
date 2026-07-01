local M = {}

function M.copy_relative_file_path()
    local absolute_file_path = vim.api.nvim_buf_get_name(0)
    local git_path = vim.fn.system("git rev-parse --show-toplevel"):gsub("%s+$", "")

    local relative_file_path = "/" .. string.sub(absolute_file_path, git_path:len() + 1)
    local text = "." .. relative_file_path
    local copy_command = nil
    if vim.fn.executable("pbcopy") == 1 then
        copy_command = "printf %s " .. vim.fn.shellescape(text) .. " | pbcopy"
    elseif vim.fn.executable("clip.exe") == 1 then
        copy_command = "printf %s " .. vim.fn.shellescape(text) .. " | clip.exe"
    end

    if copy_command then
        vim.fn.system(copy_command)
    else
        vim.fn.setreg("+", text)
    end
    print(relative_file_path)
    if copy_command then
        print("command:" .. copy_command)
    end
    return true
end

return M
