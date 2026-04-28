local ok, gitsigns = pcall(require, "gitsigns")
if not ok then
    return
end

gitsigns.setup({
    signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "^" },
        changedelete = { text = "~" },
        untracked = { text = "+" },
    },
    signs_staged = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "^" },
        changedelete = { text = "~" },
        untracked = { text = "+" },
    },
    current_line_blame = true,
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 50,
        ignore_whitespace = false,
    },
    current_line_blame_formatter = " <author>, <author_time:%Y-%m-%d> - <summary>",
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("n", "]c", function()
            if vim.wo.diff then
                vim.cmd.normal({ "]c", bang = true })
                return
            end
            gs.nav_hunk("next")
        end, "Next git change")

        map("n", "[c", function()
            if vim.wo.diff then
                vim.cmd.normal({ "[c", bang = true })
                return
            end
            gs.nav_hunk("prev")
        end, "Previous git change")

        map("n", "<leader>hp", gs.preview_hunk, "Preview git hunk")
        map("n", "<leader>hb", function()
            gs.blame_line({ full = true })
        end, "Show git blame for line")
        map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle git blame")
        map("n", "<leader>td", gs.toggle_deleted, "Toggle deleted lines")
    end,
})
