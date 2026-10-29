-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- DBML: render the schema to an SVG diagram and open it (needs node/npx)
vim.filetype.add({ extension = { dbml = "dbml" } })

local function dbml_render()
  local src = vim.api.nvim_buf_get_name(0)
  local out = vim.fn.stdpath("cache") .. "/dbml-" .. vim.fn.fnamemodify(src, ":t:r") .. ".svg"
  vim.cmd("silent! write")
  vim.system({ "npx", "--yes", "@softwaretechnik/dbml-renderer", "-i", src, "-o", out }, { text = true }, function(res)
    vim.schedule(function()
      if res.code ~= 0 then
        return vim.notify("DBML render failed:\n" .. (res.stderr or ""), vim.log.levels.ERROR)
      end
      vim.ui.open(out)
    end)
  end)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "dbml",
  callback = function(ev)
    vim.keymap.set("n", "<leader>cd", dbml_render, { buffer = ev.buf, desc = "DBML diagram (open SVG)" })
    vim.api.nvim_buf_create_user_command(ev.buf, "DbmlPreview", dbml_render, {})
  end,
})

-- Markdown: read it like prose (soft wrap at word boundaries, concealed syntax, no spell noise)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "rmd" },
  callback = function()
    vim.wo.wrap = true
    vim.wo.linebreak = true
    vim.wo.breakindent = true
    vim.wo.conceallevel = 2
    vim.wo.concealcursor = ""
    vim.wo.spell = false
    vim.keymap.set("n", "<leader>cp", "<cmd>MarkdownPreviewToggle<cr>", { buffer = true, desc = "Markdown Preview" })
  end,
})

-- VS Code-style preview shortcuts (ctrl+shift+v, like "Markdown: Open Preview")
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "rmd" },
  callback = function(ev)
    vim.keymap.set({ "n", "i" }, "<C-S-v>", "<cmd>MarkdownPreviewToggle<cr>", { buffer = ev.buf, desc = "Markdown Preview" })
  end,
})

-- Switch the browser preview between the VS Code look and GitHub's look (markdown-preview's built-in style)
vim.api.nvim_create_user_command("MarkdownPreviewStyle", function(o)
  local style = o.args ~= "" and o.args or (vim.g.mkdp_markdown_css == "" and "vscode" or "github")
  vim.g.mkdp_markdown_css = style == "vscode" and (vim.fn.stdpath("config") .. "/assets/vscode-markdown.css") or ""
  vim.notify("Markdown preview style: " .. style .. " (restart the preview to apply)")
end, {
  nargs = "?",
  complete = function()
    return { "vscode", "github" }
  end,
})
vim.keymap.set("n", "<leader>cP", "<cmd>MarkdownPreviewStyle<cr>", { desc = "Toggle preview style (VS Code/GitHub)" })

-- Markdown as a clean document (VS Code preview look): neutral colors, no diagnostics/gutter noise
local function markdown_hl()
  local text, link, code_bg, block_bg, rule = "#cdd6f4", "#89b4fa", "#313244", "#181825", "#45475a"
  local set = vim.api.nvim_set_hl
  for i = 1, 6 do
    set(0, "RenderMarkdownH" .. i, { fg = text, bold = true })
    set(0, "RenderMarkdownH" .. i .. "Bg", {})
    set(0, "@markup.heading." .. i .. ".markdown", { fg = text, bold = true })
  end
  set(0, "@markup.heading.markdown", { fg = text, bold = true })
  set(0, "@markup.heading.marker.markdown", { fg = rule })
  set(0, "RenderMarkdownCode", { bg = block_bg })
  set(0, "RenderMarkdownCodeInline", { fg = text, bg = code_bg })
  set(0, "RenderMarkdownCodeBorder", { bg = block_bg })
  set(0, "RenderMarkdownBullet", { fg = text })
  set(0, "RenderMarkdownLink", { fg = link })
  set(0, "RenderMarkdownQuote", { fg = rule })
  set(0, "RenderMarkdownDash", { fg = rule })
  set(0, "RenderMarkdownTableHead", { fg = text, bold = true })
  set(0, "RenderMarkdownTableRow", { fg = rule })
  set(0, "RenderMarkdownChecked", { fg = text })
  set(0, "RenderMarkdownUnchecked", { fg = text })
  for _, g in ipairs({
    "@markup.raw.markdown_inline", "@markup.raw.block.markdown", "@markup.list.markdown",
    "@markup.list.checked.markdown", "@markup.list.unchecked.markdown", "@markup.quote.markdown",
    "@punctuation.special.markdown", "@punctuation.delimiter.markdown", "@markup.math.markdown_inline",
    "@string.escape.markdown_inline", "@label.markdown", "@conceal.markdown_inline",
  }) do
    set(0, g, { fg = text })
  end
  set(0, "@markup.link.label.markdown_inline", { fg = link })
  set(0, "@markup.link.url.markdown_inline", { fg = link, underline = true })
  set(0, "@markup.link.markdown_inline", { fg = rule })
  set(0, "@markup.strong.markdown_inline", { fg = text, bold = true })
  set(0, "@markup.italic.markdown_inline", { fg = text, italic = true })
end
local md_group = vim.api.nvim_create_augroup("md_clean", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", { group = md_group, callback = markdown_hl })
vim.api.nvim_create_autocmd("VimEnter", { group = md_group, callback = markdown_hl })

vim.api.nvim_create_autocmd("FileType", {
  group = md_group,
  pattern = { "markdown", "rmd" },
  callback = function(ev)
    markdown_hl()
    vim.diagnostic.enable(false, { bufnr = ev.buf }) -- no markdownlint/marksman noise in prose
  end,
})

-- window-local look: no numbers/signs/cursorline, a small left margin instead
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = md_group,
  callback = function(ev)
    local ft = vim.bo[ev.buf].filetype
    if ft ~= "markdown" and ft ~= "rmd" then
      return
    end
    local w = vim.wo
    vim.w.md_saved = { w.number, w.relativenumber, w.cursorline, w.statuscolumn, w.signcolumn, w.colorcolumn }
    w.number, w.relativenumber, w.cursorline, w.colorcolumn = false, false, false, ""
    w.signcolumn = "no"
    w.statuscolumn = "    "
  end,
})
vim.api.nvim_create_autocmd("BufWinLeave", {
  group = md_group,
  callback = function()
    local s = vim.w.md_saved
    if s then
      local w = vim.wo
      w.number, w.relativenumber, w.cursorline, w.statuscolumn, w.signcolumn, w.colorcolumn =
        s[1], s[2], s[3], s[4], s[5], s[6]
      vim.w.md_saved = nil
    end
  end,
})
