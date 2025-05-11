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
        invert_intend_guides = false,
        inverse = true,
        contrast = "",  -- options: "hard", "soft", "".
        palette_overrides = {},
        overrides = {
          Pmenu = { bg = "" },
        },
        dim_inactive = false,
        transparent_mode = true,
      })
    end,
  }, 
}
