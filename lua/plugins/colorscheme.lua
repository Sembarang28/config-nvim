return {
  -- Catppuccin Mocha as the default flavour (LazyVim already wires the integrations)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      -- let the terminal's opacity + blur show through instead of painting an opaque bg
      transparent_background = true,
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
}
