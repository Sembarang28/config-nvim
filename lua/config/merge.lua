-- Merge conflict helpers
--   :MergeListConflicts            list every conflicted file in the quickfix window
--   :MergeAcceptCurrent[!] [file]  keep the "current" side (HEAD / ours) of every conflict block
--   :MergeAcceptIncoming[!] [file] keep the "incoming" side (theirs) of every conflict block
--   :MergeAcceptBoth[!] [file]     keep both sides, current first then incoming
-- Without a file the current buffer is used; with ! every conflicted file in the repo is resolved.
-- Resolved files are written back and staged with `git add`.

local M = {}

local function git(args)
  local out = vim.fn.systemlist(vim.list_extend({ "git" }, args))
  return out, vim.v.shell_error
end

local function repo_root()
  local out, code = git({ "rev-parse", "--show-toplevel" })
  if code ~= 0 or not out[1] then
    return nil
  end
  return out[1]
end

-- Relative paths of files with unmerged entries (conflicts)
local function conflicted_files()
  local out, code = git({ "diff", "--name-only", "--diff-filter=U" })
  if code ~= 0 then
    return nil
  end
  return out
end

-- Number of conflict blocks in a list of lines
local function count_blocks(lines)
  local n = 0
  for _, l in ipairs(lines) do
    if l:match("^<<<<<<< ") or l == "<<<<<<<" then
      n = n + 1
    end
  end
  return n
end

-- Keep one side of every conflict block. side = "current" | "incoming"
local function resolve_lines(lines, side)
  local out, state = {}, "none" -- none | current | base | incoming
  for _, l in ipairs(lines) do
    if l:match("^<<<<<<<") then
      state = "current"
    elseif l:match("^|||||||") and state == "current" then
      state = "base" -- diff3 style: drop the base section
    elseif l:match("^=======$") and (state == "current" or state == "base") then
      state = "incoming"
    elseif l:match("^>>>>>>>") and state == "incoming" then
      state = "none"
    elseif state == "none" then
      out[#out + 1] = l
    elseif side == "both" then
      out[#out + 1] = l -- keep current then incoming, markers dropped
    elseif state == side then
      out[#out + 1] = l
    end
  end
  return out
end

local function reload_buffer(path)
  local bufnr = vim.fn.bufnr(path)
  if bufnr == -1 or not vim.api.nvim_buf_is_loaded(bufnr) then
    return
  end
  if vim.bo[bufnr].modified then
    vim.notify("Buffer has unsaved changes, not reloaded: " .. path, vim.log.levels.WARN)
    return
  end
  vim.api.nvim_buf_call(bufnr, function()
    vim.cmd("silent! edit!")
  end)
end

-- Resolve one file (absolute path). Returns the number of blocks resolved, or nil on error.
local function resolve_file(path, side)
  if vim.fn.filereadable(path) == 0 then
    vim.notify("File not found: " .. path, vim.log.levels.ERROR)
    return nil
  end
  local lines = vim.fn.readfile(path)
  local blocks = count_blocks(lines)
  if blocks == 0 then
    return 0
  end
  vim.fn.writefile(resolve_lines(lines, side), path)
  local root = repo_root()
  if root then
    vim.fn.system({ "git", "-C", root, "add", "--", path })
  end
  reload_buffer(path)
  return blocks
end

local function list_conflicts()
  local root = repo_root()
  if not root then
    return vim.notify("Not inside a git repository", vim.log.levels.WARN)
  end
  local files = conflicted_files()
  if not files then
    return vim.notify("Could not read conflicts from git", vim.log.levels.ERROR)
  end
  if #files == 0 then
    return vim.notify("No merge conflicts", vim.log.levels.INFO)
  end
  local items = {}
  for _, rel in ipairs(files) do
    local full = root .. "/" .. rel
    local lines = vim.fn.filereadable(full) == 1 and vim.fn.readfile(full) or {}
    items[#items + 1] = {
      filename = full,
      lnum = 1,
      text = string.format("%d conflict block(s)", count_blocks(lines)),
    }
  end
  vim.fn.setqflist({}, " ", { title = "Merge conflicts", items = items })
  vim.cmd("copen")
  vim.notify(#files .. " conflicted file(s)", vim.log.levels.INFO)
end

local function accept(side, bang, arg)
  local targets = {}
  if bang then
    local root = repo_root()
    local files = conflicted_files() or {}
    for _, rel in ipairs(files) do
      targets[#targets + 1] = root .. "/" .. rel
    end
    if #targets == 0 then
      return vim.notify("No merge conflicts", vim.log.levels.INFO)
    end
  else
    local path = arg ~= "" and vim.fn.fnamemodify(arg, ":p") or vim.api.nvim_buf_get_name(0)
    if path == "" then
      return vim.notify("No file to resolve", vim.log.levels.WARN)
    end
    targets = { path }
  end

  local total, files_done = 0, 0
  for _, path in ipairs(targets) do
    local n = resolve_file(path, side)
    if n and n > 0 then
      total = total + n
      files_done = files_done + 1
    end
  end
  vim.notify(
    string.format("Accepted %s in %d file(s) (%d block(s))", side, files_done, total),
    vim.log.levels.INFO
  )
end

function M.setup()
  vim.api.nvim_create_user_command("MergeListConflicts", list_conflicts, {
    desc = "List files with merge conflicts",
  })
  vim.api.nvim_create_user_command("MergeAcceptCurrent", function(o)
    accept("current", o.bang, o.args)
  end, { bang = true, nargs = "?", complete = "file", desc = "Accept current (ours) side of conflicts" })
  vim.api.nvim_create_user_command("MergeAcceptIncoming", function(o)
    accept("incoming", o.bang, o.args)
  end, { bang = true, nargs = "?", complete = "file", desc = "Accept incoming (theirs) side of conflicts" })

  vim.api.nvim_create_user_command("MergeAcceptBoth", function(o)
    accept("both", o.bang, o.args)
  end, { bang = true, nargs = "?", complete = "file", desc = "Accept both sides of conflicts (current then incoming)" })

  vim.keymap.set("n", "<leader>mc", "<cmd>MergeAcceptCurrent<cr>", { desc = "Accept current (conflict file)" })
  vim.keymap.set("n", "<leader>mi", "<cmd>MergeAcceptIncoming<cr>", { desc = "Accept incoming (conflict file)" })
  vim.keymap.set("n", "<leader>mb", "<cmd>MergeAcceptBoth<cr>", { desc = "Accept both (conflict file)" })
  vim.keymap.set("n", "<leader>ml", "<cmd>MergeListConflicts<cr>", { desc = "List conflict files" })
end

return M
