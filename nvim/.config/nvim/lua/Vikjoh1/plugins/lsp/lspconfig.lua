return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
  },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        opts.desc = "show LSP references"
        vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

        opts.desc = "go to declaration"
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "show LSP definitions"
        vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

        opts.desc = "show LSP implementations"
        vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

        opts.desc = "show LSP type definitions"
        vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

        opts.desc = "see available code actions"
        vim.keymap.set({ "n", "v" }, "<leader>vca", function() vim.lsp.buf.code_action() end, opts)

        opts.desc = "smart rename"
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        opts.desc = "show buffer diagnostics"
        vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

        opts.desc = "show line diagnostics"
        vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

        opts.desc = "show documentation for what is under cursor"
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "restart LSP"
        vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
      end
    })

    local signs = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN]  = " ",
      [vim.diagnostic.severity.HINT]  = "󰠠 ",
      [vim.diagnostic.severity.INFO]  = " ",
    }

    vim.diagnostic.config({
      signs = { text = signs },
      virtual_text = true,
      underline = true,
      update_in_insert = false,
    })

    -- local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local capabilities = cmp_nvim_lsp.default_capabilities()
    -- local util = require("lspconfig.util")
    --


    vim.lsp.config('lua_ls', {
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

    vim.lsp.config('ts_ls', {
      capabilities = capabilities,
      root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        on_dir(
          vim.fs.root(fname, "tsconfig.json")
          or vim.fs.root(fname, "jsconfig.json")
          or vim.fs.root(fname, "package.json")
          or vim.fs.root(fname, ".git")
        )
      end,
      single_file_support = false,
      init_options = {
        preferences = {
          includeCompletionsWithSnippetText = true,
          includeCompletionsForImportStatements = true,
        },
      },
    })

    vim.lsp.config('gopls', {
      cmd = { "gopls" },
      filetypes = { "go", "gomod", "gowork", "gotmpl" },
      root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        on_dir(
          vim.fs.root(fname, "go.work")
          or vim.fs.root(fname, "go.mod")
          or vim.fs.root(fname, ".git")
        )
      end,
      capabilities = capabilities,
      settings = {
        gopls = {
          gofumpt = true,
          completeUnimported = true,
          analyses = {
            unusedparams = true,
            shadow = true,
          },
          staticcheck = true,
        },
      },
    })

    vim.lsp.config('kotlin_language_server', {
      capabilities = capabilities,
      root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        on_dir(
          vim.fs.root(fname, "settings.gradle")
          or vim.fs.root(fname, "settings.gradle.kts")
          or vim.fs.root(fname, "build.gradle")
          or vim.fs.root(fname, "build.gradle.kts")
          or vim.fs.root(fname, ".git")
        )
      end,
      init_options = {
        storagePath = vim.fn.stdpath("cache") .. "/kotlin_language_server",
      },
      settings = {
        kotlin = {
          android = {
            sdk = vim.fn.expand("$HOME/Android/Sdk"),
          },
          compiler = {
            jvm = {
              target = "17",
            },
          },
          externalSources = {
            autoConvertToKotlin = true,
            useKlsScheme = true,
          },
          indexing = {
            enabled = true,
          },
        },
      },
    })

    vim.lsp.enable('lua_ls')
    vim.lsp.enable('ts_ls')
    vim.lsp.enable('gopls')
    vim.lsp.enable('kotlin_language_server')

    vim.lsp.set_log_level("WARN")
  end
}
