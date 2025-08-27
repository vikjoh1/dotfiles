return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      quickfile = {
        enabled = true,
        exclude = { "latex" },
      },
      picker = {
        enabled = true,
        matchers = {
          frecency = true,
          cwd_bonus = true,
        },
        formatters = {
          file = {
            filename_first = false,
            filename_only = false,
            icon_width = 2,
          }
        },
        layout = {
          preset = "telescope",
          cycle = false,
        },
        layouts = {
          select = {
            preview = false,
            layout = {
              backdrop = false,
              width = 0.6,
              min_width = 80,
              height = 0.4,
              min_height = 10,
              box = "vertical",
              border = "rounded",
              title = "{title}",
              title_pos = "center",
              { win = "input", height = 1, border = "bottom" },
              { win = "list", border = "none" },
              { win = "preview", title = "{preview}", width = 0.6, height = 0.4, border = "top" },
            },
          },
          ivy = {
            layout = {
              box = "vertical",
              backdrop = false,
              width = 0,
              height = 0.4,
              position = "bottom",
              border = "top",
              title = "{title} {live} {flags}",
              title_pos = "left",
              { win = "input", height = 1, border = "bottom" },
              {
                box = "horizontal",
                { win = "list", border = "none" },
                { win = "preview", title = "{preview}", width = 0.5, border = "left" },
              },
            },
          },
        }
      },
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
          {
            section = "terminal",
            cmd = "ascii-image-converter ~/.config/backgrounds/wp11095021-godspeed-you-black-emperor-wallpapers.jpg -c -C -f",
            random = 10,
            pane = 2,
            indent = 4,
            height = 30,
          },
        }
      }
    },
    keys = {
      { "<leader>lg", function () require("snacks").lazygit() end, desc = "LazyGit" },
      { "<leader>gl", function () require("snacks").lazygit.log() end, desc = "LazyGit logs" },

      -- Picker
      { "<leader>pf", function () require("snacks").picker.files() end, desc = "find files" },
      { "<leader>pc", function () require("snacks").picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "find config" },
      { "<leader>ps", function () require("snacks").picker.grep() end, desc = "grep word" },
      { "<leader>pws", function () require("snacks").picker.grep_word() end, desc = "search word under cursor or visual sel", mode = { "n", "x" } },
      { "<leader>pk", function () require("snacks").picker.keymaps({ layput = "ivy" }) end, desc = "search keymaps" },
    },
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>pt", function () require("snacks").picker.todo_comments() end, desc = "todo" },
      { "<leader>pT", function () require("snacks").picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
    }
  },
}
