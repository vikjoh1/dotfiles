return {
  "mason-org/mason.nvim",
  lazy = false,
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "neovim/nvim-lspconfig",
    { "folke/neodev.nvim", opts = {} },
  },
  config = function ()
    require("neodev").setup()

    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")

    -- local cmp_nvim_lsp = require("cmp_nvim_lsp")

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
      },
    })

    -- local capabilities = cmp_nvim_lsp.default_capabilities()
    -- vim.lsp.config("*", {
    --   capabilities = capabilities,
    -- })
  end,
}
