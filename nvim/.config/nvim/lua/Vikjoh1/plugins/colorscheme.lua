return {
  {
    "ellisonleao/gruvbox.nvim",
    -- priority = 1000 ,
    config = function()
      require("gruvbox").setup({
        terminal_colors = true,
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = false,
          emphasis = false,
          comments = false,
          folds = false,
          operators = false,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_indent_guides = false,
        inverse = true,
        contrast = "",  -- options: "hard", "soft", "".
        palette_overrides = {},
        overrides = {
          Pmenu = { bg = "NONE" },
        },
        dim_inactive = false,
        transparent_mode = true,
      })
    end,
  },
  {
    "sainnhe/gruvbox-material",
    priority = 1000,
    lazy = false,
    config = function()
      vim.o.termguicolors = true
      vim.o.background = "dark"
      vim.g.gruvbox_material_foreground = "material"
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_transparent_background = 1
      vim.g.gruvbox_material_enable_bold = 1
      vim.g.gruvbox_material_enable_italic = 0
    end
  }
}
