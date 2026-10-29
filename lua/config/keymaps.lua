-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Project-wide live grep (VS Code's cmd+shift+f).
-- Terminals can't send <D-...>, so map ctrl+shift+f (needs kitty/wezterm/ghostty) and <leader>sg is the fallback.
-- In your terminal config, map cmd+shift+f to send "\x1b[102;6u" (CSI u for ctrl+shift+f) to use the real shortcut.
local function live_grep()
  LazyVim.pick("live_grep", { root = false })()
end
vim.keymap.set({ "n", "i", "v" }, "<C-S-f>", live_grep, { desc = "Live grep (project)" })
vim.keymap.set({ "n", "i", "v" }, "<D-S-f>", live_grep, { desc = "Live grep (project)" })
vim.keymap.set("n", "<leader>/", live_grep, { desc = "Live grep (cwd)" })

-- Resize splits with the keyboard when the mouse isn't handy (alt+arrows)
vim.keymap.set("n", "<M-Up>", "<cmd>resize +2<cr>", { desc = "Increase height" })
vim.keymap.set("n", "<M-Down>", "<cmd>resize -2<cr>", { desc = "Decrease height" })
vim.keymap.set("n", "<M-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease width" })
vim.keymap.set("n", "<M-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase width" })
