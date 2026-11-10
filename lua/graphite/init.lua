local M = {}

---@class graphite.Config
---@field transparent boolean  Don't paint a background (use the terminal's).
---@field italic_comments boolean
M.config = {
  transparent = false,
  italic_comments = true,
}

---@param opts? graphite.Config
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

function M.load()
  if vim.g.colors_name then
    vim.cmd("hi clear")
  end
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end
  vim.o.termguicolors = true
  vim.o.background = "dark"
  vim.g.colors_name = "graphite"

  local p = require("graphite.palette")
  for group, spec in pairs(require("graphite.highlights").get(p, M.config)) do
    vim.api.nvim_set_hl(0, group, spec)
  end

  for i, color in ipairs(p.ansi) do
    vim.g["terminal_color_" .. (i - 1)] = color
  end
end

return M
