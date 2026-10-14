# Neovim Config

My personal Neovim setup built on [LazyVim](https://github.com/LazyVim/LazyVim) and [lazy.nvim](https://github.com/folke/lazy.nvim).
It is a full IDE setup with a Catppuccin Mocha theme, LSP, DAP, linting, and formatting for the languages I work with.

## Features

- **Theme:** [Catppuccin](https://github.com/catppuccin/nvim) Mocha (default flavour)
- **LSP:** servers installed and enabled automatically through Mason
- **DAP:** debugging via `nvim-dap` and `nvim-dap-ui`, with adapters for Python, Go, Rust/C/C++, and JS/TS
- **Linting:** `nvim-lint` for shell scripts, plus ESLint diagnostics for JS/TS frameworks
- **Formatting:** `conform.nvim` with format-on-save

## Requirements

- Neovim >= 0.11.2, built with LuaJIT
- `git`, `make`, `unzip`, and `curl`
- A [Nerd Font](https://www.nerdfonts.com/) for icons
- Node.js and npm (for several LSP servers and Prettier)
- Python 3 (for debugpy and Ruff)
- Go and Rust toolchains if you work with those languages

## Installation

```sh
# back up any existing config
mv ~/.config/nvim ~/.config/nvim.bak

git clone <this-repo-url> ~/.config/nvim
nvim
```

On first launch, lazy.nvim installs the plugins and Mason installs the tools listed in [lua/plugins/tools.lua](lua/plugins/tools.lua). Run `:checkhealth` afterwards to confirm everything is working.

## Language support

Languages are enabled through LazyVim extras in [lua/config/lazy.lua](lua/config/lazy.lua).

| Language / framework | LSP | Formatter | Linter | DAP |
| --- | --- | --- | --- | --- |
| Lua | lua_ls | stylua | | |
| Python | pyright, ruff | ruff_organize_imports, ruff_format | ruff (LSP) | debugpy |
| Go | gopls | goimports, gofumpt | golangci-lint | delve |
| Rust | rust-analyzer | rustfmt | | codelldb |
| C / C++ | clangd | clang-format | | codelldb |
| TypeScript / JavaScript | vtsls | prettier | ESLint | js-debug-adapter |
| React, Next.js, Vite | vtsls, tailwindcss, eslint | prettier | ESLint | js-debug-adapter |
| SvelteKit | svelte, vtsls, tailwindcss, eslint | prettier | ESLint | js-debug-adapter |
| Nuxt / Vue | vue, vtsls, tailwindcss, eslint | prettier | ESLint | js-debug-adapter |
| Shell (sh, bash) | bashls | shfmt | shellcheck | |
| JSON / YAML | jsonls, yamlls | prettier | | |
| Markdown | marksman | prettier | | |
| Docker | dockerls | | | |

## Keymaps

These are the LazyVim defaults, plus the debugger keys below.

| Key | Action |
| --- | --- |
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Start or continue debugging |
| `<leader>du` | Toggle DAP UI |
| `<leader>cf` | Format buffer |
| `<leader>cm` | Open Mason |

Press `<leader>` (Space) and wait to see the full list in which-key.

## Structure

```text
init.lua                   entry point, loads config.lazy
lua/config/lazy.lua        lazy.nvim bootstrap, LazyVim extras, colorscheme
lua/config/options.lua     vim options
lua/config/keymaps.lua     custom keymaps
lua/config/autocmds.lua    custom autocmds
lua/plugins/colorscheme.lua  Catppuccin Mocha
lua/plugins/tools.lua      Mason packages, nvim-lint, conform.nvim
```

## Credits

- [LazyVim](https://github.com/LazyVim/LazyVim) and [folke](https://github.com/folke) for the base config and plugins
- [Catppuccin](https://github.com/catppuccin/nvim) for the theme
