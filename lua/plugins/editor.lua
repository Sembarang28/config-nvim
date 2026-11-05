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

  -- git blame: inline author/date at end of the cursor line (toggle <leader>gB),
  -- full commit popup with <leader>ghb (LazyVim default), whole-file blame with <leader>ghB
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = { delay = 300, virt_text_pos = "eol" },
      current_line_blame_formatter = "   <author>, <author_time:%d %b %Y> - <summary>",
    },
    keys = {
      { "<leader>gB", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle Inline Git Blame" },
    },
  },

  -- sticky scroll: pins the opening line of the enclosing block ({ of function / if / for / class)
  -- at the top of the window while scrolling, so you always know which scope you're in
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "LazyFile",
    opts = {
      enable = true,
      max_lines = 5, -- cap how many header lines stick at once
      min_window_height = 0, -- never disable, even in small windows
      multiline_threshold = 20, -- keep multi-line headers (e.g. wrapped params) fully visible
      trim_scope = "outer", -- drop the outermost scope when there are too many
      mode = "topline", -- like VS Code: scopes of the top visible line, not the cursor
      line_numbers = true,
      separator = "─", -- line under the sticky header
    },
    config = function(_, opts)
      require("treesitter-context").setup(opts)
      -- make the sticky header clearly visible (default blends into the background)
      local function hl()
        vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#1f2335" })
        vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { bg = "#1f2335", fg = "#7aa2f7" })
        vim.api.nvim_set_hl(0, "TreesitterContextSeparator", { fg = "#7aa2f7" })
      end
      hl()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = hl })
    end,
    keys = {
      { "<leader>ut", function() require("treesitter-context").toggle() end, desc = "Toggle Sticky Context" },
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
