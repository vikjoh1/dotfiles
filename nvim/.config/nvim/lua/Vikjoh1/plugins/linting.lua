return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },

  config = function ()
    local lint = require("lint")
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
      function ()
        return vim.fn.expand("%:p")
      end,
    }

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function ()
        lint.try_lint()
      end
    })

    vim.keymap.set("n", "<leader>l", function ()
      lint.try_lint()
    end, { desc = "trigger linting for current file" })
  end
}
