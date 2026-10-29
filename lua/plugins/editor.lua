return {
  -- explorer shows dotfiles (.git, .dockerignore, ...) by default; toggle with H inside the explorer
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = { hidden = true },
        },
      },
    },
  },

  -- rendered markdown view in the buffer (render-markdown.nvim + browser preview), toggle with <leader>um
  { import = "lazyvim.plugins.extras.lang.markdown" },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      file_types = { "markdown", "norg", "rmd", "org", "codecompanion" },
      -- keep rendering in insert mode too, so .md reads like a document while editing
      render_modes = { "n", "c", "t", "i" },
      -- show the raw text of only the cursor line, everything else stays rendered
      anti_conceal = { enabled = true },
      -- plain document look: bold headings (no icons/background), no gutter signs
      heading = {
        sign = false,
        icons = { "", "", "", "", "", "" },
        backgrounds = {},
        width = "full",
        border = false,
      },
      code = {
        sign = false,
        style = "normal", -- no language icon/name, just a quiet block
        width = "full",
        left_pad = 2,
        right_pad = 2,
        border = "hide",
        inline_pad = 1,
      },
      bullet = { icons = { "•", "◦", "▪", "▫" } },
      checkbox = {
        unchecked = { icon = "☐ " },
        checked = { icon = "☑ " },
      },
      pipe_table = { preset = "none", style = "full", cell = "padded", border_virtual = true },
      quote = { repeat_linebreak = true },
      link = { enabled = true, image = "", email = "", hyperlink = "", custom = {} },
    },
  },

  {
    "iamcco/markdown-preview.nvim",
    init = function()
      vim.g.mkdp_auto_close = 0 -- keep the browser tab when switching buffers
      vim.g.mkdp_refresh_slow = 0 -- update live while typing
      vim.g.mkdp_theme = "dark"
      -- VS Code-like styling for the preview page
      vim.g.mkdp_markdown_css = vim.fn.stdpath("config") .. "/assets/vscode-markdown.css"
      vim.g.mkdp_preview_options = { sync_scroll_type = "middle", disable_sync_scroll = 0 }
      vim.g.mkdp_echo_preview_url = 1
      vim.g.mkdp_page_title = "${name}"
    end,
  },
}
