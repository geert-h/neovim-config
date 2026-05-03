local ok, neo_tree = pcall(require, "neo-tree")
if not ok then
    return
end

neo_tree.setup({
    close_if_last_window = true,
    filesystem = {
        follow_current_file = {
            enabled = true,
        },
        use_libuv_file_watcher = true,
    },
    window = {
        width = 32,
        mappings = {
            ["<space>"] = "none",
        },
    },
})

local last_edit_win

local function is_tree_win(win)
    if not vim.api.nvim_win_is_valid(win) then
        return false
    end

    local buf = vim.api.nvim_win_get_buf(win)
    return vim.bo[buf].filetype == "neo-tree"
end

local function is_edit_win(win)
    if not vim.api.nvim_win_is_valid(win) or is_tree_win(win) then
        return false
    end

    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
        return false
    end

    local buf = vim.api.nvim_win_get_buf(win)
    return vim.bo[buf].buftype == ""
end

local function focus_edit_window()
    if last_edit_win and is_edit_win(last_edit_win) then
        vim.api.nvim_set_current_win(last_edit_win)
        return
    end

    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if is_edit_win(win) then
            last_edit_win = win
            vim.api.nvim_set_current_win(win)
            return
        end
    end
end

local focus_augroup = vim.api.nvim_create_augroup("geert-neo-tree-focus", { clear = true })

vim.api.nvim_create_autocmd("WinEnter", {
    group = focus_augroup,
    callback = function()
        local win = vim.api.nvim_get_current_win()

        if is_edit_win(win) then
            last_edit_win = win
        end
    end,
})

vim.api.nvim_create_autocmd("WinClosed", {
    group = focus_augroup,
    callback = function()
        vim.schedule(function()
            local win = vim.api.nvim_get_current_win()

            if is_tree_win(win) then
                focus_edit_window()
            end
        end)
    end,
})

vim.keymap.set("n", "<leader>n", function()
    vim.cmd("Neotree toggle reveal")
    vim.schedule(focus_edit_window)
end, { desc = "Toggle file tree" })

vim.keymap.set("n", "<leader>N", function()
    vim.cmd("Neotree focus")
end, { desc = "Focus file tree" })
