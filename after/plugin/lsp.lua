local on_attach = function(_, bufnr)
  local o = { buffer = bufnr }
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, o)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, o)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, o)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, o)
  vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, o)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, o)
  vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, o)
  vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, o)
  vim.keymap.set({'n','x'}, '<F3>', function() vim.lsp.buf.format({ async = true }) end, o)
  vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, o)
  vim.keymap.set('n', '<leader>hf', function()
    vim.lsp.buf.format({
      async = false,
      filter = function(client)
        return client.name == 'hls'
      end,
    })
  end, o)
end

vim.lsp.config('*', {
  on_attach = on_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = { "clangd", "rust_analyzer", "omnisharp" },
})

local clangd_cmd = {
  "clangd",
  "--compile-commands-dir=build",
  "--all-scopes-completion",
  "--background-index",
  "--query-driver=" ..
    table.concat({
      vim.fn.expand("~/.espressif/**/xtensa-esp*-elf/bin/*-esp*-elf-*"),
      vim.fn.expand("~/.espressif/**/riscv32-esp-elf/bin/riscv32-esp-elf-*"),
    }, ";"),
}

vim.lsp.config('clangd', {
  cmd = clangd_cmd,
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "metal" },
})

vim.lsp.config('hls', {
  cmd = { vim.fn.expand("~/.ghcup/bin/haskell-language-server-wrapper"), "--lsp" },
  settings = {
    haskell = {
      formattingProvider = "ormolu",
      cabalFormattingProvider = "cabal-fmt",
    },
  },
})

vim.lsp.enable({
-- It is therefore not efficient for large lists.
  'clangd',
  'rust_analyzer',
  'omnisharp',
  'hls',
 })
