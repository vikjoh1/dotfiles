return {
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  config = function()
    require("gruvbox").setup({
      italic = {
        comments = true,
      }
    })
    vim.cmd.colorscheme("gruvbox")
  end
}
