-- lualine theme: require("lualine").setup({ options = { theme = "graphite" } })
local p = require("graphite.palette")

local function mode(color)
  return {
    a = { fg = p.bg, bg = color, gui = "bold" },
    b = { fg = p.fg_term, bg = p.bg_raised },
    c = { fg = p.muted, bg = p.bg_chrome },
  }
end

return {
  normal = mode(p.accent),
  insert = mode(p.green),
  visual = mode(p.magenta),
  replace = mode(p.red),
  command = mode(p.yellow),
  terminal = mode(p.cyan),
  inactive = {
    a = { fg = p.dim, bg = p.bg_chrome },
    b = { fg = p.dim, bg = p.bg_chrome },
    c = { fg = p.dim, bg = p.bg_chrome },
  },
}
