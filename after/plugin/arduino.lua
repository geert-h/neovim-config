vim.api.nvim_create_autocmd({"BufNewFile","BufRead"}, {
  pattern = "*.ino",
  callback = function() vim.bo.filetype = "arduino" end,
})

pcall(function()
  vim.treesitter.language.register('cpp', 'arduino')
end)

-- LSP: Arduino Language Server (spawns clangd under the hood)
local fqbn = "esp8266:esp8266:nodemcuv2"
vim.lsp.config('arduino_language_server', {
  cmd = {
    "arduino-language-server",
    "-cli", "arduino-cli",
    "-cli-config", vim.fn.expand("~/.arduino15/arduino-cli.yaml"),
    "-fqbn", fqbn,
    "-clangd", "clangd",
  },
  filetypes = { "arduino", "ino" },
})
vim.lsp.enable({ 'arduino_language_server' })
