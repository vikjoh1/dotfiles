return {
  "mason-org/mason.nvim",
  lazy = false,
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "neovim/nvim-lspconfig",
    { "folke/neodev.nvim", opts = {} },
  },
  config = function ()
    require("neodev").setup()

    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")

    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      ensure_installed = {
        "lua_ls",
        "html",
        "cssls",
        "tailwindcss",
        "gopls",
        "emmet_language_server",
        "marksman",
        "ts_ls",
        "kotlin_language_server",
      },
    })
  end,
}
