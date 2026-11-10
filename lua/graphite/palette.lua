-- Loads the generated palette from dist/nvim/palette.lua (built from palette.json).
-- It lives in dist/ so it is not on the runtimepath's lua/ folder; locate it relative to this file.
local source = debug.getinfo(1, "S").source:sub(2)
local root = vim.fn.fnamemodify(source, ":p:h:h:h")
return dofile(root .. "/dist/nvim/palette.lua")
