local function launch(name, mode)
  return function()
    require("config.ai").run(name, mode)
  end
end

-- "last" resolves at key press, so it always uses the tool used most recently
local function launch_last(mode)
  return function()
    local ai = require("config.ai")
    ai.run(ai.last, mode)
  end
end

return {
  {
    "coder/claudecode.nvim",
    opts = {},
    keys = {
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },

      -- open a specific CLI
      { "<leader>ac", launch("claude", "toggle"), desc = "Toggle Claude" },
      { "<leader>ax", launch("codex", "toggle"), desc = "Toggle Codex" },
      { "<leader>aa", launch("agy", "toggle"), desc = "Toggle Antigravity" },
      { "<leader>ao", launch("opencode", "toggle"), desc = "Toggle OpenCode" },

      -- act on the last tool used
      { "<leader>af", launch_last("focus"), desc = "Focus last AI" },
      { "<leader>ar", launch_last("resume"), desc = "Resume last AI" },

      -- Claude-only actions
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil" },
      },

      -- Diff management (accept moved to <leader>ay because <leader>aa is Antigravity)
      { "<leader>ay", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
}
