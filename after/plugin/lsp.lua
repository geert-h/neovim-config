local function replace_buffer_text(bufnr, text)
  local view = vim.fn.winsaveview()
  local lines = vim.split(text, '\n', { plain = true })

  if lines[#lines] == '' then
    table.remove(lines, #lines)
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.fn.winrestview(view)
end

local function format_haskell_with_ormolu(bufnr)
  if vim.bo[bufnr].filetype ~= 'haskell' or vim.fn.executable('ormolu') ~= 1 then
    return false
  end

  local filename = vim.api.nvim_buf_get_name(bufnr)
  local input_file = filename ~= '' and filename or 'Main.hs'
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local text = table.concat(lines, '\n')

  if vim.bo[bufnr].endofline then
    text = text .. '\n'
  end

  local result = vim.system({
    'ormolu',
    '--stdin-input-file',
    input_file,
  }, {
    stdin = text,
    text = true,
  }):wait()

  if result.code ~= 0 then
    local message = (result.stderr and result.stderr ~= '') and result.stderr or 'ormolu failed'
    vim.notify(message, vim.log.levels.ERROR)
    return true
  end

  if result.stdout ~= text then
    replace_buffer_text(bufnr, result.stdout)
  end

  return true
end

local function resolve_root(bufnr, markers)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  local cwd = vim.uv.cwd()

  if fname ~= '' then
    local root = vim.fs.root(fname, markers)
    if root then
      return root
    end

    if cwd and vim.startswith(fname, cwd) then
      return cwd
    end

    return vim.fs.dirname(fname)
  end

  return cwd
end

local function format_haskell(bufnr)
  if format_haskell_with_ormolu(bufnr) then
    return
  end

  vim.lsp.buf.format({
    bufnr = bufnr,
    async = false,
    timeout_ms = 10000,
    filter = function(client)
      return client.name == 'hls'
    end,
  })
end

local function format_rust(bufnr)
  vim.lsp.buf.format({
    bufnr = bufnr,
    async = false,
    timeout_ms = 10000,
    filter = function(client)
      return client.name == 'rust_analyzer'
    end,
  })
end

local function set_lsp_keymaps(bufnr)
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
  vim.keymap.set({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, o)
  vim.keymap.set('n', '<leader>hf', function()
    format_haskell(bufnr)
  end, o)
  vim.keymap.set('n', '<leader>rf', function()
    format_rust(bufnr)
  end, o)
end

local agda_ls_path = vim.fn.expand("~/.ghcup/bin/als")
local rust_format_augroup = vim.api.nvim_create_augroup('geert-rust-format', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    set_lsp_keymaps(args.buf)

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == 'rust_analyzer' then
      vim.api.nvim_clear_autocmds({ group = rust_format_augroup, buffer = args.buf })
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = rust_format_augroup,
        buffer = args.buf,
        callback = function()
          format_rust(args.buf)
        end,
      })
    end
  end,
})

vim.lsp.config('*', {
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

local haskell_settings = {
  formattingProvider = "ormolu",
}

if vim.fn.executable('cabal-fmt') == 1 then
  haskell_settings.cabalFormattingProvider = "cabal-fmt"
end

vim.lsp.config('clangd', {
  cmd = clangd_cmd,
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "metal" },
})

vim.lsp.config('hls', {
  cmd = { vim.fn.expand("~/.ghcup/bin/haskell-language-server-wrapper"), "--lsp" },
  settings = {
    haskell = haskell_settings,
  },
})

vim.lsp.config('rust_analyzer', {
  root_dir = function(bufnr, on_dir)
    on_dir(resolve_root(bufnr, { 'Cargo.toml', 'rust-project.json', '.git' }))
  end,
})

vim.lsp.config('agda_ls', {
  cmd = vim.fn.executable(agda_ls_path) == 1 and { agda_ls_path } or { 'als' },
  root_dir = function(bufnr, on_dir)
    on_dir(resolve_root(bufnr, { '.git', '*.agda-lib' }))
  end,
})

vim.lsp.enable({
-- It is therefore not efficient for large lists.
  'clangd',
  'rust_analyzer',
  'omnisharp',
  'agda_ls',
  'hls',
 })
