return {
  -- external tools installed via :Mason (LSP servers and DAP adapters come from the lang extras)
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP servers
        "lua-language-server",
        "pyright",
        "ruff",
        "gopls",
        "rust-analyzer",
        "clangd",
        "vtsls",
        "svelte-language-server",
        "vue-language-server",
        "tailwindcss-language-server",
        "eslint-lsp",
        "bash-language-server",
        "json-lsp",
        "yaml-language-server",
        "marksman",
        "dockerfile-language-server",
        -- formatters
        "stylua",
        "shfmt",
        "ruff",
        "prettier",
        "clang-format",
        -- linters
        "shellcheck",
        -- debuggers
        "codelldb",
        "debugpy",
        "delve",
        "js-debug-adapter",
      },
    },
  },

  -- linters (nvim-lint runs on BufWritePost / BufReadPost via LazyFile)
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        sh = { "shellcheck" },
        bash = { "shellcheck" },
      },
    },
  },

  -- formatters (conform.nvim, format-on-save is already on in LazyVim)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_organize_imports", "ruff_format" },
        c = { "clang_format" },
        cpp = { "clang_format" },
      },
    },
  },
}
