-- add plugins
vim.pack.add({
  { src = "stevearc/oil.nvim" },
  { src = "https://github.com/echasnovski/mini.pick" },
  { src = "https://github.com/windwp/nvim-autopairs" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
  { src = "https://github.com/hrsh7th/nvim-cmp" },
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
  { src = "https://github.com/hrsh7th/cmp-buffer" },
  { src = "https://github.com/hrsh7th/cmp-path" },
  { src = "https://github.com/saadparwaiz1/cmp_luasnip" },
  { src = "https://github.com/L3MON4D3/LuaSnip" },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/windwp/nvim-ts-autotag" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/zbirenbaum/copilot.lua" },
  { src = "https://github.com/zbirenbaum/copilot-cmp" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/christoomey/vim-tmux-navigator" },
  { src = "https://github.com/mfussenegger/nvim-lint" },
  { src = "https://github.com/gelguy/wilder.nvim" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  { src = "https://github.com/romgrk/fzy-lua-native" },
})

-- treesitter setup
require("nvim-treesitter.configs").setup({
  highlight = { enable = true },
  indent = { enable = true },
  ensure_installed = {
    "json",
    "javascript",
    "typescript",
    "tsx",
    "go",
    "yaml",
    "html",
    "css",
    "python",
    "http",
    "prisma",
    "markdown",
    "markdown_inline",
    "svelte",
    "graphql",
    "bash",
    "lua",
    "vim",
    "dockerfile",
    "gitignore",
    "query",
    "vimdoc",
    "c",
    "java",
    "rust",
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = false,
    },
  },
  additional_vim_regex_highlighting = false,
})

-- Oil setup
require("oil").setup({
  default_file_explorer = true,
  columns = {},
  keymaps = {
    ["<C-h>"] = false,
    ["<C-c>"] = false,
    ["<M-h>"] = "actions.select_split",
    ["q"] = "actions.close",
  },
  delete_to_trash = true,
  view_options = {
    show_hidden = true,
  },
  skip_confirm_for_simple_edits = true,
})
vim.keymap.set("n", "-", ":Oil<CR>", { desc = "open parent dir" })
vim.keymap.set("n", "<leader>-", require("oil").toggle_float, { desc = "open float dir" })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "oil",
  callback = function()
    vim.opt_local.cursorline = true
  end,
})

-- mini.pick setup
require("mini.pick").setup()
vim.keymap.set("n", "<leader>pf", ":Pick files<CR>")

-- LSP setup
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
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
    vim.keymap.set({ "n", "v" }, "<leader>vca", function()
      vim.lsp.buf.code_action()
    end, opts)

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

    vim.keymap.set("i", "<C-h>", function()
      vim.lsp.buf.signature_help()
    end, opts)
  end,
})

local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

local lspkind_ok, lspkind = pcall(require, "lspkind")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ["<S-Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  }),
  sources = {
    { name = "copilot" },
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
    { name = "buffer" },
  },
  formatting = lspkind_ok and {
    format = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50, ellipsis_char = "_" }),
  } or nil,
})

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "emmet_language_server", "ts_ls", "graphql", "gopls" },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()
vim.lsp.config("*", {
  capabilities = capabilities,
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.config("ts_ls", {
  single_file_support = false,
  root_dir = function(fname)
    local util = require("lspconfig.util")
    local path = fname or vim.api.nvim_buf_get_name(0)
    if not path or path == "" then
      return nil
    end
    if util.root_pattern("deno.json", "deno.jsonc")(path) then
      return nil
    end
    return util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git")(path)
  end,
  init_options = {
    preferences = {
      includeCompletionsWithSnippetText = true,
      includeCompletionsForImportStatements = true,
    },
  },
})

vim.lsp.config("emmet_language_server", {
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

-- autopairs setup
require("nvim-autopairs").setup({
  check_ts = true,
  ts_config = {
    lua = { "string" },
    javascript = { "template_string" },
    java = false,
  },
})

-- autotag setup
require("nvim-ts-autotag").setup({
  opts = {
    enable_close = true,
    enable_rename = true,
    enable_close_on_slash = false,
  },
  per_filetype = {
    ["html"] = {
      enable_close = true,
    },
    ["typescriptreact"] = {
      enable_close = true,
    },
  },
})

-- telescope setup
local telescope = require("telescope")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

telescope.load_extension("fzf")

telescope.setup({
  defaults = {
    path_display = { "smart" },
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
    },
  },
})

vim.keymap.set("n", "<leader>pr", "<cmd>Telescope oldfiles<CR>", { desc = "fuzzy find recent files" })
vim.keymap.set("n", "<leader>pWs", function()
  local word = vim.fn.expand("<cWORD>")
  builtin.grep_string({ search = word })
end, { desc = "find connected words under cursor" })

-- copilot setup
require("copilot").setup({
  suggestion = {
    enabled = true,
    auto_trigger = true,
    debounce = 75,
    keymap = {
      accept = "<C-l>",
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
  },
  panel = { enabled = false },
})

require("copilot_cmp").setup()

-- conform setup
require("conform").setup({
  formatters = {
    ["markdown-toc"] = {
      condition = function(_, ctx)
        for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, 1, false)) do
          if line:find("<!%-%- toc %-%->") then
            return true
          end
        end
      end,
    },
    ["markdownlint-cli2"] = {
      condition = function(_, ctx)
        local diag = vim.tbl_filter(function(d)
          return d.source == "markdownlint"
        end, vim.diagnostic.get(ctx.buf))
        return #diag > 0
      end,
    },
  },
  formatters_by_ft = {
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    svelte = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    graphql = { "prettier" },
    liquid = { "prettier" },
    lua = { "stylua" },
    python = { "black" },
    markdown = { "prettier" },
    ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
  },
})

require("conform").formatters.prettier = {
  args = {
    "--stdin-filepath",
    "$FILENAME",
    "--tab-width",
    "2",
    "--use-tabs",
    "false",
  },
}

require("conform").formatters.shfmt = {
  prepend_args = { "-i", "4" },
}

vim.keymap.set({ "n", "v" }, "<leader>mp", function()
  require("conform").format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 1000,
  })
end, { desc = "prettier format whole file  or range (in visual mode)" })

-- nvim-lint setup
local lint = require "lint"
local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
local eslint = lint.linters.eslint_d

lint.linters_by_ft = {
  javascript = { "eslint_d" },
  typescript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  svelte = { "eslint_d" },
  python = { "pylint" },
}

eslint.args = {
  "--no-warn-ignores",
  "--format",
  "json",
  "--stdin",
  "--stdin-filename",
  function()
    return vim.fn.expand("%:p")
  end,
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = lint_augroup,
  callback = function()
    lint.try_lint()
  end
})

vim.keymap.set("n", "<leader>l", function()
  lint.try_lint()
end, { desc = "trigger linting for current file" })

-- wilder setup
local wilder = require "wilder"

wilder.setup({
  modes = { ":", "/", "?" },
})

wilder.set_option(
  "renderer",
  wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
    min_width = "20%",
    min_height = "15%",
    reverse = 0,
    highlighter = {
      wilder.lua_pcre2_highlighter(),
      wilder.lua_fzy_highlighter(),
    },
    highlights = {
      default = wilder.make_hl(
        "WilderPopupMenu",
        "Pmenu",
        { { a = 1 }, { a = 1 }, { background = "#1E212B" } }
      ),
      accent = wilder.make_hl(
        "WilderAccent",
        "Pmenu",
        { { a = 1 }, { a = 1 }, { foreground = "#58FFD6", background = "#1e1e2e" } }
      ),
    },
    border = "single",
  }))
)

-- lualine setup
local lualine = require "lualine"
-- local lazy_status = require "lazy.status"

local colors = {
  color0 = "#092236",
  color1 = "#ff5874",
  color2 = "#c3ccdc",
  color3 = "#1c1e26",
  color6 = "#a1aab8",
  color7 = "#828697",
  color8 = "#ae81ff",
}
local my_lualine_theme = {
  replace = {
    a = { fg = colors.color0, bg = colors.color1, gui = "bold" },
    b = { fg = colors.color2, bg = colors.color3 },
  },
  inactive = {
    a = { fg = colors.color6, bg = colors.color3, gui = "bold" },
    b = { fg = colors.color6, bg = colors.color3 },
    c = { fg = colors.color6, bg = colors.color3 },
  },
  normal = {
    a = { fg = colors.color0, bg = colors.color7, gui = "bold" },
    b = { fg = colors.color2, bg = colors.color3 },
    c = { fg = colors.color2, bg = colors.color3 },
  },
  visual = {
    a = { fg = colors.color0, bg = colors.color8, gui = "bold" },
    b = { fg = colors.color2, bg = colors.color3 },
  },
  insert = {
    a = { fg = colors.color0, bg = colors.color2, gui = "bold" },
    b = { fg = colors.color2, bg = colors.color3 },
  },
}
local mode = {
  'mode',
  fmt = function(str)
    return ' ' .. str
  end,
}
local diff = {
  'diff',
  colored = true,
  symbols = { added = ' ', modified = ' ', removed = ' ' },
}
local filename = {
  'filename',
  file_status = true,
  path = 0,
}
local branch = { 'branch', icon = { '', color = { fg = '#A6D4DE' } }, '|' }
lualine.setup({
  icons_enabled = true,
  options = {
    theme = my_lualine_theme,
    component_separators = { left = "|", right = "|" },
    section_separators = { left = "|", right = "" },
  },
  sections = {
    lualine_a = { mode },
    lualine_b = { branch },
    lualine_c = { diff, filename },
    lualine_x = {
      { "diagnostics" },
      { "encoding" },
      { "fileformat" },
      { "filetype" },
    },
  },
})
