-- Launchers for the AI CLIs.
--   <leader>ac  Claude      <leader>ax  Codex
--   <leader>aa  Antigravity <leader>ao  OpenCode
-- <leader>af (focus) and <leader>ar (resume) act on whichever tool was used last.
local M = {}

local state_dir = vim.fn.stdpath("state")
local state_file = state_dir .. "/ai_last_tool"

-- Claude goes through claudecode.nvim (IDE integration); the others run in a snacks terminal.
-- `resume` is the argument list that resumes the last conversation for that CLI.
M.tools = {
  claude = { label = "Claude" },
  codex = { label = "Codex", cmd = { "codex" }, resume = { "resume" } },
  agy = { label = "Antigravity", cmd = { "agy" }, resume = { "--continue" } },
  opencode = { label = "OpenCode", cmd = { "opencode" }, resume = { "--continue" } },
}

local function read_last()
  local ok, lines = pcall(vim.fn.readfile, state_file)
  local name = ok and lines[1] or nil
  return M.tools[name] and name or "claude"
end

-- Last tool used, restored from the state file so it survives restarts.
M.last = read_last()

local function remember(name)
  M.last = name
  pcall(function()
    vim.fn.mkdir(state_dir, "p")
    vim.fn.writefile({ name }, state_file)
  end)
end

-- mode: "toggle" (open/hide), "focus" (jump into it), "resume" (continue last conversation)
function M.run(name, mode)
  remember(name)

  if name == "claude" then
    if mode == "focus" then
      return vim.cmd("ClaudeCodeFocus")
    elseif mode == "resume" then
      return vim.cmd("ClaudeCode --resume")
    end
    return vim.cmd("ClaudeCode")
  end

  local tool = M.tools[name]
  local cmd = vim.deepcopy(tool.cmd)
  if mode == "resume" then
    vim.list_extend(cmd, tool.resume)
  end
  local opts = { cwd = LazyVim.root() }

  if mode == "focus" then
    return Snacks.terminal.focus(cmd, opts)
  end
  return Snacks.terminal.toggle(cmd, opts)
end

return M
