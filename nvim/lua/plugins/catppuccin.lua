return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      styles = {
        comments = { "italic" },
      },
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}
