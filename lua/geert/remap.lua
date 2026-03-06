vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "<S-Tab>", function()
    vim.cmd("normal! <<")
end)

vim.keymap.set("i", "<S-Tab>", function()
    vim.cmd("normal! <<")
end)


vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

vim.keymap.set("n", "<leader>vwm", function()
    require("vim-with-me").StartVimWithMe()
end)
vim.keymap.set("n", "<leader>svwm", function()
    require("vim-with-me").StopVimWithMe()
end)

vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>ll", "<plug>(vimtex-compile)", { silent = true })
vim.keymap.set("n", "<leader>lv", "<plug>(vimtex-view)",    { silent = true })
vim.keymap.set("n", "<leader>lc", "<plug>(vimtex-clean)",   { silent = true })
vim.keymap.set("n", "<leader>lt", "<plug>(vimtex-toc-open)",{ silent = true })

-- open a floating window with the diagnostic under the cursor
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)

-- jump between diagnostics
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)

-- show all diagnostics in location list (current window)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

vim.keymap.set(
    "n",
    "<leader>ee",
    "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
)

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/theprimeagen/packer.lua<CR>");
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

local fqbn = "esp8266:esp8266:nodemcuv2"
local port = "/dev/tty.usbserial-57670561871"

vim.keymap.set('n', '<leader>ab', function()
  vim.cmd('!' .. ('arduino-cli compile -b %s'):format(fqbn))
end, { silent = true })

vim.keymap.set('n', '<leader>au', function()
  vim.cmd('!' .. ('arduino-cli upload -b %s -p %s'):format(fqbn, port))
end, { silent = true })

vim.keymap.set('n', '<leader>am', function()
  vim.cmd('!arduino-cli monitor -p ' .. port .. ' -c baudrate=115200')
end, { silent = true })
