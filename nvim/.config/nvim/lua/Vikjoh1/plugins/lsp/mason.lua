return {
  "williamboman/mason.nvim",
  lazy = false,
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "neovim/nvim-lspconfig",
    { "folke/neodev.nvim", opts = {} },
  },
  config = function ()
    require("neodev").setup()

    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")

    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local capabilities = cmp_nvim_lsp.default_capabilities()

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
      automatic_enable = false,
      ensure_installed = {
        "lua_ls",
        "html",
        "cssls",
        "tailwindcss",
        "gopls",
        "emmet_ls",
        "emmet_language_server",
        "marksman",
      },

      automatic_installation = true,
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "prettier",
        "stylua",
        "isort",
        "pylint",
        "clangd",
        { "eslint_d", version = "13.1.2" },
      }
    })

    mason_lspconfig.setup_handlers({
      function (server_name)
        lspconfig[server_name].setup({
          capabilities = capabilities,
        })
      end,
      ["emmet_ls"] = function ()
        lspconfig["emmet_ls"].setup({
          capabilities = capabilities,
          filetypes = {
            "html",
            "typescriptreact",
            "javascriptreact",
            "css",
            "sass",
            "scss",
            "less",
            "svelte",
          },
        })
      end,
      ["lua_ls"] = function ()
        lspconfig["lua_ls"].setup({
          capabilities = capabilities,
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
              completion = {
                callSnippet = "Replace",
              },
              workspace = {
                library = {
                  [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                  [vim.fn.stdpath("config") .. "/lua"] = true,
                },
              },
            },
          },
        })
      end,
      ["emmet_language_server"] = function ()
        lspconfig.emmet_language_server.setup({
          filetypes = {
            "css",
            "eruby",
            "html",
            "javascript",
            "javascriptreact",
            "less",
            "sass",
            "scss",
            "pug",
            "typescriptreact",
          },
          init_options = {
            includeLanguages = {},
            excludeLanguages = {},
            extensionsPath = {},
            preferences = {},
            showAbbreviationSuggestions = true,
            showExpandedAbbreviation = "always",
            showSuggestionsAsSnippets = false,
            syntaxProfiles = {},
            variables = {},
          },
        })
      end,
      ["ts_ls"] = function ()
        lspconfig.ts_ls.setup({
          capabilities = capabilities,
          root_dir = function (name)
            local util = lspconfig.util
            return not util.root_pattern("deno.json", "deno.jsonc")(fname)
              and util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git")(fname)
          end,
          single_file_support = false,
          init_options = {
            preferences = {
              includeCompletionsWithSnippetText = true,
              includeCompletionsForImportStatements = true,
            },
          },
        })
      end,
    })
  end,
}
