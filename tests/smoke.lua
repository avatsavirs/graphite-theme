-- Smoke test: run with `scripts/test` (nvim --headless -u NONE -l tests/smoke.lua).
-- Fails on Lua errors, unknown palette keys (a typo like p.bluee would silently give a
-- highlight no colour), missing required groups, and a broken lualine theme.

local failures = {}
local function fail(msg) failures[#failures + 1] = msg end

local graphite = require("graphite")
local palette = require("graphite.palette")

-- 1. Every palette key referenced by highlights.lua must exist.
local strict = setmetatable({}, {
  __index = function(_, key)
    local v = palette[key]
    if v == nil then error("highlights.lua uses unknown palette key: p." .. tostring(key), 2) end
    return v
  end,
})
for _, transparent in ipairs({ false, true }) do
  local ok, err = pcall(function()
    local groups = require("graphite.highlights").get(strict, { transparent = transparent, italic_comments = true })
    for name, spec in pairs(groups) do
      for field, value in pairs(spec) do
        if field ~= "link" and (field == "fg" or field == "bg" or field == "sp") and value ~= "NONE"
            and not tostring(value):match("^#%x%x%x%x%x%x$") then
          fail(("%s.%s is not a #rrggbb colour: %s"):format(name, field, tostring(value)))
        end
      end
    end
  end)
  if not ok then fail(("highlights (transparent=%s): %s"):format(tostring(transparent), err)) end
end

-- 2. Loading the colorscheme applies cleanly, in both modes.
for _, transparent in ipairs({ false, true }) do
  graphite.setup({ transparent = transparent })
  local ok, err = pcall(vim.cmd.colorscheme, "graphite")
  if not ok then fail("colorscheme graphite failed (transparent=" .. tostring(transparent) .. "): " .. err) end
end
if vim.g.colors_name ~= "graphite" then fail("vim.g.colors_name is " .. tostring(vim.g.colors_name)) end

-- 3. Groups the theme must define.
for _, group in ipairs({
  "Normal", "Comment", "String", "Function", "Visual", "Pmenu", "DiagnosticError",
  "@variable", "@function", "@keyword", "@markup.heading.1",
  "TelescopeNormal", "NvimTreeFolderName", "BufferCurrent", "CmpItemKindFunction", "MasonNormal",
}) do
  local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
  if next(hl) == nil then fail("highlight group is empty or missing: " .. group) end
end

-- 4. 16 terminal colours.
for i = 0, 15 do
  if not vim.g["terminal_color_" .. i] then fail("terminal_color_" .. i .. " is not set") end
end

-- 5. lualine theme.
local ok, theme = pcall(require, "lualine.themes.graphite")
if not ok then
  fail("lualine theme failed to load: " .. tostring(theme))
else
  for _, mode in ipairs({ "normal", "insert", "visual", "replace", "command", "inactive" }) do
    if type(theme[mode]) ~= "table" then fail("lualine theme is missing mode: " .. mode) end
  end
end

if #failures > 0 then
  io.stderr:write("FAILED:\n  " .. table.concat(failures, "\n  ") .. "\n")
  os.exit(1)
end
print("ok: graphite smoke test passed")
