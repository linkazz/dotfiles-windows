-- lsp configs
local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local util = require "lspconfig/util"

lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "gopls" },
  filetypes = {
    "go",
    "gomod",
    "gowork",
    "gotmpl",
  },
  root_dir = util.root_pattern("go.work", "go.mod"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
}

lspconfig.tsserver.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {
    "typescript-language-server",
    "--stdio",
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  -- root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
  root_dir = function()
    return vim.loop.cwd()
  end,
}

lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {
    "python",
  },
}

-- -- import exisiting lspconfig
-- local config = require("plugins.configs.lspconfig")
-- local on_attach = config.on_attach
-- local capabilities = config.capabilities
--
-- -- custom lspconfig
-- local lspconfig = require("lspconfig")
--
-- lspconfig.pyright.setup({
--   on_attach = on_attach,
--   capabilities = capabilities,
--   filetypes = {"python"},
-- })
--
-- lspconfig.rust_analyzer.setup({
--   on_attach = on_attach,
--   capabilities = capabilities,
--   filetypes = {"rust"},
--   root_dir = lspconfig.util.root_pattern("Cargo.toml"),
-- })
