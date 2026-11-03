# ⚡ forge.nvim

**A batteries-included Neovim IDE that works out of the box.**
Built on [LazyVim](https://github.com/LazyVim/LazyVim) and [lazy.nvim](https://github.com/folke/lazy.nvim), tuned for daily work across Python, Go, Rust, C/C++, TypeScript, and modern web frameworks — with a Catppuccin Mocha look that feels right at home in a transparent terminal.

Clone it, open `nvim`, and you get LSP, debugging, linting, formatting, Markdown preview, **full AI development support** (Claude Code, Codex, Antigravity, and OpenCode), and a polished UI — no setup marathon required.

---

## ✨ Why you'll love it

- **Zero-config IDE.** Language servers, formatters, linters, and debug adapters are installed automatically through Mason.
- **Debug like in a real IDE.** Breakpoints, step-through, and a full debugger UI for Python, Go, Rust/C/C++, and JS/TS.
- **Format on save, lint as you type.** `conform.nvim` and `nvim-lint` keep your code clean without thinking about it.
- **Full AI development support.** Claude Code is wired in through [claudecode.nvim](https://github.com/coder/claudecode.nvim) (send selections, add files, review diffs), and Codex, Antigravity, and OpenCode launch from the same keymaps. Jump back into your last AI session with one key.
- **Read Markdown like a document.** Rendered Markdown in the buffer, plus a live browser preview in a VS Code–style theme.
- **Find anything fast.** Project-wide live grep (`Ctrl+Shift+F`), hidden files visible in the explorer, and inline git blame.
- **Looks great, everywhere.** Catppuccin Mocha with transparent background, so your terminal's opacity and blur show through.
- **Keyboard- and mouse-friendly.** Resize splits with `Alt+Arrows` or the mouse.

---

## 🚀 Features

| Area | What you get |
| --- | --- |
| **Theme** | [Catppuccin](https://github.com/catppuccin/nvim) Mocha, transparent background |
| **LSP** | Servers installed and enabled automatically through Mason |
| **DAP** | `nvim-dap` + `nvim-dap-ui` with adapters for Python, Go, Rust/C/C++, JS/TS |
| **Linting** | `nvim-lint` (shellcheck) and ESLint diagnostics for JS/TS frameworks |
| **Formatting** | `conform.nvim` with format-on-save (Ruff, Prettier, stylua, shfmt, clang-format, and more) |
| **AI** | Full AI development support: Claude Code (`claudecode.nvim`), Codex, Antigravity, and OpenCode, with focus and resume for the last-used tool |
| **Markdown** | Rendered in-buffer with `render-markdown.nvim`, plus browser preview |
| **Database** | `.dbml` files render to an SVG schema diagram with one keystroke |
| **Git** | Inline current-line blame, full commit popup, whole-file blame |
| **Search** | Live grep across the project, hidden files in the explorer |

---

## 🧰 Requirements

- Neovim **>= 0.11.2**, built with LuaJIT
- `git`, `make`, `unzip`, and `curl`
- A [Nerd Font](https://www.nerdfonts.com/) for icons
- Node.js and npm (for several LSP servers, Prettier, and DBML rendering)
- Python 3 (for debugpy and Ruff)
- Go and Rust toolchains, if you work with those languages

---

## 📦 Installation

```sh
# back up any existing config
mv ~/.config/nvim ~/.config/nvim.bak

git clone https://github.com/Sembarang28/config-nvim.git ~/.config/nvim
nvim
```

On first launch, lazy.nvim installs the plugins and Mason installs the tools listed in [lua/plugins/tools.lua](lua/plugins/tools.lua). Then run `:checkhealth` to confirm everything is green.

---

## 🌍 Language support

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
| DBML | | | | |

---

## ⌨️ Keymaps

Standard LazyVim defaults apply, plus the custom bindings below.

| Key | Action |
| --- | --- |
| `Ctrl+Shift+F` / `<leader>/` | Live grep (project / cwd) |
| `Alt+Arrows` | Resize splits |
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Start or continue debugging |
| `<leader>du` | Toggle DAP UI |
| `<leader>cf` | Format buffer |
| `<leader>cm` | Open Mason |
| `<leader>ac` | Toggle Claude Code |
| `<leader>ax` | Toggle Codex |
| `<leader>aa` | Toggle Antigravity |
| `<leader>ao` | Toggle OpenCode |
| `<leader>af` | Focus last-used AI tool |
| `<leader>ar` | Resume last-used AI tool |
| `<leader>aC` | Continue last Claude conversation |
| `<leader>as` | Send selection to Claude (visual mode) |
| `<leader>ab` | Add current buffer to Claude |
| `<leader>ay` / `<leader>ad` | Accept / deny Claude diff |
| `<leader>gB` | Toggle inline git blame |
| `<leader>cp` / `Ctrl+Shift+V` | Markdown preview (in Markdown files) |
| `<leader>cP` | Switch preview style (VS Code / GitHub) |
| `<leader>cd` | Render DBML diagram (in DBML files) |

Press `<leader>` (Space) and wait to see the full list in which-key.

---

## 🗂️ Structure

```text
init.lua                     entry point, loads config.lazy
lua/config/lazy.lua          lazy.nvim bootstrap, LazyVim extras, colorscheme
lua/config/options.lua       vim options
lua/config/keymaps.lua       custom keymaps (live grep, split resize)
lua/config/autocmds.lua      DBML render, Markdown writing mode and preview
lua/plugins/colorscheme.lua  Catppuccin Mocha, transparent background
lua/config/ai.lua            AI CLI launchers (Claude, Codex, Antigravity, OpenCode)
lua/plugins/ai.lua           claudecode.nvim and AI keymaps
lua/plugins/editor.lua       explorer, git blame, Markdown rendering and preview
lua/plugins/tools.lua        Mason packages, nvim-lint, conform.nvim
assets/vscode-markdown.css   VS Code–style preview theme
```

---

## 🙏 Credits

- [LazyVim](https://github.com/LazyVim/LazyVim) and [folke](https://github.com/folke) for the base config and plugins
- [Catppuccin](https://github.com/catppuccin/nvim) for the theme
- [coder/claudecode.nvim](https://github.com/coder/claudecode.nvim) for Claude Code integration

---

⭐ If this config saves you time, consider giving the repo a star — it helps others find it!
