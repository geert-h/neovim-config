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

vim.keymap.set("n", "<leader>n", "<cmd>Neotree toggle reveal<CR>", { desc = "Toggle file tree" })
vim.keymap.set("n", "<leader>N", "<cmd>Neotree focus<CR>", { desc = "Focus file tree" })
