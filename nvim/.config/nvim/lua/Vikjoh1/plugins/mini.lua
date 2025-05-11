return {
  { "echasnovski/mini.nvim", version = false },
  {
    "echasnovski/mini.comment",
    version = false,
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function ()
      require("ts_context_commentstring").setup {
        enable_autocmd = false,
      }
      require("mini.comment").setup {
        options = {
          custom_commentstring = function ()
            return require("ts_context_commentstring.internal").calculate_commentstring({ key =
              "commentstring" })
              or vim.bo.commentstring
          end,
        },
      }
    end
  },
  {
    "echasnovski/mini.files",
    config = function ()
      local minifiles = require("mini.files")
      minifiles.setup({
        mappings = {
          go_in = "<CR>",
          go_in_plus = "L",
          go_out = "-",
          go_out_plus = "H",
        },
      })
      vim.keymap.set("n", "<leader>ee", "<cmd>lua MiniFiles.open()<CR>", { desc = "toggle mini file explorer" })
      vim.keymap.set("n", "<leader>ef", function ()
        minifiles.open(vim.api.nvim_buf_get_name(0), false)
        minifiles.reveal_cwd()
      end, { desc = "toggle into currently opened file" })
    end
  },
  {
    "echasnovski/mini.surround",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      custom_surroundings = nil,
      highlight_duration = 300,
      mappings = {
        add = "sa",
        delete = "ds",
        find = "sf",
        find_left = "sF",
        highlight = "sh",
        replace = "sr",
        update_n_lines = "sn",
        suffix_last = "l",
        suffix_next = "n",
      },
      n_lines = 20,
      respect_selection_type = false,
      search_method = "cover",
    },
  },
  {
    "echasnovski/mini.trailspace",
    event = { "BufReadPost", "BufNewFile" },
    config = function ()
      local mini_trailspace = require("mini.trailspace")

      mini_trailspace.setup({
        only_in_normal_buffers = true,
      })

      vim.keymap.set("n", "<leader>cw", function () mini_trailspace.trim() end, { desc = "erase whitespace" })
    end
  },
}
