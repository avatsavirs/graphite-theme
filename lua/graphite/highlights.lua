local M = {}

---@param p table  palette (see lua/graphite/palette.lua)
---@param cfg graphite.Config
function M.get(p, cfg)
  local bg = cfg.transparent and "NONE" or p.bg
  local bg_chrome = cfg.transparent and "NONE" or p.bg_chrome
  local comment = { fg = p.dim, italic = cfg.italic_comments }

  local function tint(color, amount)
    -- blend `color` into the background; used for diff / diagnostic backgrounds
    local function ch(hex, i) return tonumber(hex:sub(i, i + 1), 16) end
    local out = "#"
    for _, i in ipairs({ 2, 4, 6 }) do
      out = out .. string.format("%02x", math.floor(ch(p.bg, i) * (1 - amount) + ch(color, i) * amount + 0.5))
    end
    return out
  end

  local hl = {
    -- Editor ---------------------------------------------------------------
    Normal = { fg = p.fg_term, bg = bg },
    NormalNC = { fg = p.fg_term, bg = bg },
    NormalFloat = { fg = p.fg_term, bg = p.bg_raised },
    FloatBorder = { fg = p.input, bg = p.bg_raised },
    FloatTitle = { fg = p.accent, bg = p.bg_raised, bold = true },
    Cursor = { fg = p.bg, bg = p.cursor },
    lCursor = { link = "Cursor" },
    TermCursor = { link = "Cursor" },
    CursorLine = { bg = p.bg_hover },
    CursorColumn = { link = "CursorLine" },
    ColorColumn = { bg = p.bg_hover },
    CursorLineNr = { fg = p.fg, bold = true },
    LineNr = { fg = p.dim },
    SignColumn = { fg = p.dim, bg = bg },
    FoldColumn = { fg = p.dim, bg = bg },
    Folded = { fg = p.muted, bg = p.bg_hover },
    EndOfBuffer = { fg = p.bg },
    NonText = { fg = p.border },
    Whitespace = { fg = p.border },
    SpecialKey = { fg = p.border },
    Conceal = { fg = p.dim },
    Directory = { fg = p.blue },
    Title = { fg = p.accent, bold = true },
    MatchParen = { fg = p.fg, bg = p.selection, bold = true },
    Visual = { bg = p.selection },
    VisualNOS = { bg = p.selection },
    Search = { fg = p.bg, bg = p.yellow },
    IncSearch = { fg = p.bg, bg = p.accent },
    CurSearch = { fg = p.bg, bg = p.accent },
    Substitute = { fg = p.bg, bg = p.red },
    WinSeparator = { fg = p.border },
    VertSplit = { link = "WinSeparator" },
    Question = { fg = p.green },
    MoreMsg = { fg = p.green },
    ModeMsg = { fg = p.fg, bold = true },
    WarningMsg = { fg = p.working },
    ErrorMsg = { fg = p.blocked },
    healthSuccess = { fg = p.green },
    healthWarning = { fg = p.working },
    healthError = { fg = p.blocked },
    WildMenu = { bg = p.selection },
    QuickFixLine = { bg = p.selection },

    -- Menus / bars -----------------------------------------------------------
    Pmenu = { fg = p.fg_term, bg = p.bg_raised },
    PmenuSel = { fg = p.fg, bg = p.selection },
    PmenuSbar = { bg = p.input },
    PmenuThumb = { bg = p.dim },
    StatusLine = { fg = p.fg_term, bg = bg_chrome },
    StatusLineNC = { fg = p.dim, bg = bg_chrome },
    TabLine = { fg = p.muted, bg = bg_chrome },
    TabLineFill = { bg = bg_chrome },
    TabLineSel = { fg = p.fg, bg = bg, bold = true },
    WinBar = { fg = p.fg_term, bg = bg },
    WinBarNC = { fg = p.dim, bg = bg },

    -- Syntax -----------------------------------------------------------------
    Comment = comment,
    Constant = { fg = p.yellow },
    String = { fg = p.green },
    Character = { fg = p.green },
    Number = { fg = p.yellow },
    Boolean = { fg = p.yellow },
    Float = { fg = p.yellow },
    Identifier = { fg = p.red },
    Function = { fg = p.blue },
    Statement = { fg = p.magenta },
    Conditional = { fg = p.magenta },
    Repeat = { fg = p.magenta },
    Label = { fg = p.magenta },
    Operator = { fg = p.cyan },
    Keyword = { fg = p.magenta },
    Exception = { fg = p.magenta },
    PreProc = { fg = p.magenta },
    Include = { fg = p.magenta },
    Define = { fg = p.magenta },
    Macro = { fg = p.cyan },
    PreCondit = { fg = p.magenta },
    Type = { fg = p.working },
    StorageClass = { fg = p.working },
    Structure = { fg = p.working },
    Typedef = { fg = p.working },
    Special = { fg = p.cyan },
    SpecialChar = { fg = p.cyan },
    Tag = { fg = p.blue },
    Delimiter = { fg = p.fg_term },
    SpecialComment = { fg = p.dim, bold = true },
    Debug = { fg = p.red },
    Underlined = { underline = true },
    Bold = { bold = true },
    Italic = { italic = true },
    Ignore = { fg = p.dim },
    Error = { fg = p.blocked },
    Todo = { fg = p.bg, bg = p.working, bold = true },

    -- Diff ---------------------------------------------------------------------
    DiffAdd = { bg = tint(p.green, 0.12) },
    DiffChange = { bg = tint(p.blue, 0.1) },
    DiffDelete = { bg = tint(p.red, 0.12) },
    DiffText = { bg = tint(p.blue, 0.25) },
    Added = { fg = p.green },
    Changed = { fg = p.blue },
    Removed = { fg = p.red },

    -- Diagnostics ----------------------------------------------------------------
    DiagnosticError = { fg = p.blocked },
    DiagnosticWarn = { fg = p.working },
    DiagnosticInfo = { fg = p.done },
    DiagnosticHint = { fg = p.cyan },
    DiagnosticOk = { fg = p.green },
    DiagnosticVirtualTextError = { fg = p.blocked, bg = tint(p.blocked, 0.1) },
    DiagnosticVirtualTextWarn = { fg = p.working, bg = tint(p.working, 0.1) },
    DiagnosticVirtualTextInfo = { fg = p.done, bg = tint(p.done, 0.1) },
    DiagnosticVirtualTextHint = { fg = p.cyan, bg = tint(p.cyan, 0.1) },
    DiagnosticUnderlineError = { sp = p.blocked, undercurl = true },
    DiagnosticUnderlineWarn = { sp = p.working, undercurl = true },
    DiagnosticUnderlineInfo = { sp = p.done, undercurl = true },
    DiagnosticUnderlineHint = { sp = p.cyan, undercurl = true },
    DiagnosticUnderlineOk = { sp = p.green, undercurl = true },
    DiagnosticUnnecessary = { fg = p.dim },
    -- deprecated symbols (tsserver etc. tag these); strikethrough keeps the symbol's own color
    DiagnosticDeprecated = { strikethrough = true },
    ["@lsp.mod.deprecated"] = { link = "DiagnosticDeprecated" },
    SpellBad = { sp = p.blocked, undercurl = true },
    SpellCap = { sp = p.working, undercurl = true },
    SpellLocal = { sp = p.cyan, undercurl = true },
    SpellRare = { sp = p.magenta, undercurl = true },

    -- LSP ---------------------------------------------------------------------------
    LspReferenceText = { bg = p.bg_selected },
    LspReferenceRead = { bg = p.bg_selected },
    LspReferenceWrite = { bg = p.bg_selected },
    LspSignatureActiveParameter = { fg = p.working, bold = true },
    LspInlayHint = { fg = p.dim, bg = tint(p.dim, 0.1) },
    LspCodeLens = { fg = p.dim },

    -- Treesitter -----------------------------------------------------------------------
    ["@variable"] = { fg = p.fg_term },
    ["@variable.builtin"] = { fg = p.red },
    ["@variable.parameter"] = { fg = p.red },
    ["@variable.member"] = { fg = p.red },
    ["@constant"] = { fg = p.yellow },
    ["@constant.builtin"] = { fg = p.yellow },
    ["@module"] = { fg = p.working },
    ["@string"] = { link = "String" },
    ["@string.escape"] = { fg = p.cyan },
    ["@string.regexp"] = { fg = p.cyan },
    ["@string.special.url"] = { fg = p.accent, underline = true },
    ["@character"] = { link = "Character" },
    ["@number"] = { link = "Number" },
    ["@boolean"] = { link = "Boolean" },
    ["@type"] = { link = "Type" },
    ["@type.builtin"] = { fg = p.working },
    ["@attribute"] = { fg = p.yellow },
    ["@property"] = { fg = p.red },
    ["@function"] = { link = "Function" },
    ["@function.builtin"] = { fg = p.blue },
    ["@function.macro"] = { fg = p.cyan },
    ["@constructor"] = { fg = p.working },
    ["@operator"] = { link = "Operator" },
    ["@keyword"] = { link = "Keyword" },
    ["@keyword.function"] = { fg = p.magenta },
    ["@keyword.return"] = { fg = p.magenta },
    ["@keyword.operator"] = { fg = p.magenta },
    ["@punctuation"] = { fg = p.fg_term },
    ["@punctuation.special"] = { fg = p.cyan },
    ["@comment"] = { link = "Comment" },
    ["@comment.error"] = { fg = p.bg, bg = p.blocked, bold = true },
    ["@comment.warning"] = { fg = p.bg, bg = p.working, bold = true },
    ["@comment.todo"] = { fg = p.bg, bg = p.done, bold = true },
    ["@comment.note"] = { fg = p.bg, bg = p.cyan, bold = true },
    ["@tag"] = { fg = p.red },
    ["@tag.attribute"] = { fg = p.yellow },
    ["@tag.delimiter"] = { fg = p.dim },
    ["@markup.heading"] = { fg = p.magenta, bold = true },
    ["@markup.heading.1"] = { fg = p.accent, bold = true },
    ["@markup.heading.2"] = { fg = p.magenta, bold = true },
    ["@markup.heading.3"] = { fg = p.cyan, bold = true },
    ["@markup.heading.4"] = { fg = p.green, bold = true },
    ["@markup.heading.5"] = { fg = p.yellow, bold = true },
    ["@markup.heading.6"] = { fg = p.muted, bold = true },
    ["@markup.strong"] = { bold = true },
    ["@markup.italic"] = { italic = true },
    ["@markup.strikethrough"] = { strikethrough = true },
    ["@markup.link"] = { fg = p.blue },
    ["@markup.link.url"] = { fg = p.accent, underline = true },
    ["@markup.raw"] = { fg = p.green },
    ["@markup.list"] = { fg = p.blue },
    ["@diff.plus"] = { link = "Added" },
    ["@diff.minus"] = { link = "Removed" },
    ["@diff.delta"] = { link = "Changed" },

    -- LSP semantic tokens
    ["@lsp.type.namespace"] = { link = "@module" },
    ["@lsp.type.parameter"] = { link = "@variable.parameter" },
    ["@lsp.type.property"] = { link = "@property" },
    ["@lsp.type.enumMember"] = { link = "@constant" },
    ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },

    -- Plugins ------------------------------------------------------------------------------
    GitSignsAdd = { fg = p.green },
    GitSignsChange = { fg = p.blue },
    GitSignsDelete = { fg = p.red },

    -- telescope.nvim
    TelescopeNormal = { fg = p.fg_term, bg = bg },
    TelescopeBorder = { fg = p.input, bg = bg },
    TelescopeTitle = { fg = p.accent, bg = bg, bold = true },
    TelescopeSelection = { fg = p.fg, bg = p.selection },
    TelescopeSelectionCaret = { fg = p.accent, bg = p.selection },
    TelescopeMultiSelection = { fg = p.magenta },
    TelescopeMultiIcon = { fg = p.magenta },
    TelescopeMatching = { fg = p.accent, bold = true },
    TelescopePromptNormal = { fg = p.fg, bg = bg },
    TelescopePromptBorder = { fg = p.input, bg = bg },
    TelescopePromptTitle = { fg = p.accent, bg = bg, bold = true },
    TelescopePromptPrefix = { fg = p.accent },
    TelescopePromptCounter = { fg = p.dim },
    TelescopeResultsNormal = { fg = p.fg_term, bg = bg },
    TelescopeResultsBorder = { fg = p.input, bg = bg },
    TelescopeResultsTitle = { fg = p.muted, bg = bg, bold = true },
    TelescopeResultsComment = { fg = p.dim },
    TelescopeResultsLineNr = { fg = p.dim },
    TelescopeResultsDiffAdd = { fg = p.green },
    TelescopeResultsDiffChange = { fg = p.blue },
    TelescopeResultsDiffDelete = { fg = p.red },
    TelescopeResultsDiffUntracked = { fg = p.dim },
    TelescopePreviewNormal = { fg = p.fg_term, bg = bg },
    TelescopePreviewBorder = { fg = p.input, bg = bg },
    TelescopePreviewTitle = { fg = p.accent, bg = bg, bold = true },
    TelescopePreviewLine = { bg = p.bg_selected },
    TelescopePreviewMatch = { fg = p.bg, bg = p.yellow },
    TelescopePreviewMessage = { fg = p.muted },
    TelescopePreviewMessageFillchar = { fg = p.muted },

    -- indent-blankline.nvim
    IblIndent = { fg = p.bg_raised },
    IblWhitespace = { fg = p.bg_raised },
    IblScope = { fg = p.dim },

    -- mason.nvim
    MasonNormal = { fg = p.fg_term, bg = bg },
    MasonHeader = { fg = p.bg, bg = p.accent, bold = true },
    MasonHeaderSecondary = { fg = p.bg, bg = p.cyan, bold = true },
    MasonHighlight = { fg = p.accent },
    MasonHighlightBlock = { fg = p.bg, bg = p.accent },
    MasonHighlightBlockBold = { fg = p.bg, bg = p.accent, bold = true },
    MasonHighlightSecondary = { fg = p.yellow },
    MasonHighlightBlockSecondary = { fg = p.bg, bg = p.yellow },
    MasonHighlightBlockBoldSecondary = { fg = p.bg, bg = p.yellow, bold = true },
    MasonMuted = { fg = p.dim },
    MasonMutedBlock = { fg = p.muted, bg = p.bg_raised },
    MasonMutedBlockBold = { fg = p.muted, bg = p.bg_raised, bold = true },
    MasonError = { fg = p.blocked },
    MasonWarning = { fg = p.working },
    MasonHeading = { fg = p.fg, bold = true },
    MasonLink = { fg = p.accent, underline = true },

    -- lazygit.nvim (floating terminal)
    LazyGitFloat = { fg = p.fg_term, bg = bg },
    LazyGitBorder = { fg = p.input, bg = bg },

    -- nvim-cmp
    CmpItemAbbr = { fg = p.fg_term },
    CmpItemAbbrDeprecated = { fg = p.dim, strikethrough = true },
    CmpItemMenu = { fg = p.dim },
    CmpGhostText = { fg = p.dim },
    CmpItemKind = { fg = p.muted },

    -- nvim-tree (file/folder/diagnostic groups; the window groups are further down)
    NvimTreeFolderName = { fg = p.blue },
    NvimTreeOpenedFolderName = { fg = p.blue, bold = true },
    NvimTreeEmptyFolderName = { fg = p.dim },
    NvimTreeSymlinkFolderName = { fg = p.cyan },
    NvimTreeRootFolder = { fg = p.accent, bold = true },
    NvimTreeFolderIcon = { fg = p.blue },
    NvimTreeOpenedFolderIcon = { fg = p.blue },
    NvimTreeClosedFolderIcon = { fg = p.blue },
    NvimTreeFolderArrowOpen = { fg = p.dim },
    NvimTreeFolderArrowClosed = { fg = p.dim },
    NvimTreeFileIcon = { fg = p.fg_term },
    NvimTreeSymlink = { fg = p.cyan },
    NvimTreeSymlinkIcon = { fg = p.cyan },
    NvimTreeExecFile = { fg = p.green, bold = true },
    NvimTreeSpecialFile = { fg = p.yellow, underline = true },
    NvimTreeImageFile = { fg = p.magenta },
    NvimTreeOpenedFile = { fg = p.fg, bold = true },
    NvimTreeOpenedHL = { fg = p.fg, bold = true },
    NvimTreeModifiedFile = { fg = p.working },
    NvimTreeModifiedIcon = { fg = p.working },
    NvimTreeIndentMarker = { fg = p.bg_raised },
    NvimTreeCursorLine = { bg = p.bg_hover },
    NvimTreeBookmark = { fg = p.yellow },
    NvimTreeBookmarkIcon = { fg = p.yellow },
    NvimTreeCutHL = { fg = p.bg, bg = p.red },
    NvimTreeCopiedHL = { fg = p.bg, bg = p.green },
    NvimTreeLiveFilterPrefix = { fg = p.accent, bold = true },
    NvimTreeLiveFilterValue = { fg = p.yellow, bold = true },
    NvimTreeWindowPicker = { fg = p.bg, bg = p.accent, bold = true },
    NvimTreeDiagnosticErrorIcon = { link = "DiagnosticError" },
    NvimTreeDiagnosticWarnIcon = { link = "DiagnosticWarn" },
    NvimTreeDiagnosticInfoIcon = { link = "DiagnosticInfo" },
    NvimTreeDiagnosticHintIcon = { link = "DiagnosticHint" },
    NvimTreeGitDirtyIcon = { fg = p.working },
    NvimTreeGitNewIcon = { fg = p.green },
    NvimTreeGitStagedIcon = { fg = p.green },
    NvimTreeGitDeletedIcon = { fg = p.red },
    NvimTreeGitRenamedIcon = { fg = p.cyan },
    NvimTreeGitMergeIcon = { fg = p.magenta },
    NvimTreeGitIgnoredIcon = { fg = p.dim },
    NeoTreeNormal = { fg = p.fg_term, bg = bg_chrome },
    NeoTreeNormalNC = { fg = p.fg_term, bg = bg_chrome },
    -- nvim-tree runs in a float here, floats share the editor background, so focus changes cannot change it
    NvimTreeNormal = { fg = p.fg_term, bg = bg },
    NvimTreeNormalNC = { fg = p.fg_term, bg = bg },
    NvimTreeNormalFloat = { fg = p.fg_term, bg = bg },
    NvimTreeNormalFloatBorder = { fg = p.border, bg = bg },
    NvimTreeEndOfBuffer = { fg = bg, bg = bg },
    NvimTreeSignColumn = { fg = p.dim, bg = bg },
    NvimTreeLineNr = { fg = p.dim, bg = bg },
    NvimTreeCursorLineNr = { fg = p.fg, bg = p.bg_hover, bold = true },
    NvimTreeWinSeparator = { fg = bg, bg = bg },
    BlinkCmpMenu = { link = "Pmenu" },
    BlinkCmpMenuSelection = { link = "PmenuSel" },
    CmpItemAbbrMatch = { fg = p.accent, bold = true },
    CmpItemAbbrMatchFuzzy = { fg = p.accent, bold = true },
    WhichKeyFloat = { bg = p.bg_popover },
  }

  -- nvim-cmp completion-item kinds (CmpItemKindFunction etc.) ---------------
  local cmp_kinds = {
    Text = p.fg_term,
    Method = p.blue, Function = p.blue, Constructor = p.working,
    Field = p.red, Variable = p.red, Property = p.red,
    Class = p.working, Interface = p.working, Struct = p.working, Enum = p.working,
    TypeParameter = p.working, Module = p.working,
    Unit = p.yellow, Value = p.yellow, Constant = p.yellow, EnumMember = p.yellow,
    Keyword = p.magenta, Operator = p.cyan, Event = p.yellow,
    Snippet = p.green, Color = p.magenta, File = p.muted, Folder = p.blue, Reference = p.cyan,
  }
  for kind, color in pairs(cmp_kinds) do
    hl["CmpItemKind" .. kind] = { fg = color }
  end

  -- barbar.nvim tabline -------------------------------------------------------
  -- Current = focused buffer, Visible = shown in another window, Alternate = last
  -- visited, Inactive = the rest. Per-state: text (fg + bg), plus the pieces drawn on top.
  local barbar_states = {
    Current = { fg = p.fg, bg = bg, bold = true, dim = p.muted },
    Visible = { fg = p.fg_term, bg = bg, dim = p.dim },
    Alternate = { fg = p.muted, bg = bg_chrome, dim = p.dim },
    Inactive = { fg = p.muted, bg = bg_chrome, dim = p.dim },
  }
  for state, s in pairs(barbar_states) do
    local base = { fg = s.fg, bg = s.bg, bold = s.bold }
    local prefix = "Buffer" .. state
    hl[prefix] = base
    hl[prefix .. "Icon"] = { bg = s.bg }
    hl[prefix .. "Index"] = { fg = s.dim, bg = s.bg }
    hl[prefix .. "Number"] = { fg = s.dim, bg = s.bg }
    hl[prefix .. "Mod"] = { fg = p.working, bg = s.bg }
    hl[prefix .. "ModBtn"] = { fg = p.working, bg = s.bg }
    hl[prefix .. "Sign"] = { fg = state == "Current" and p.accent or s.bg, bg = s.bg }
    hl[prefix .. "SignRight"] = { fg = s.bg, bg = s.bg }
    hl[prefix .. "Target"] = { fg = p.red, bg = s.bg, bold = true }
    hl[prefix .. "Btn"] = { fg = s.dim, bg = s.bg }
    hl[prefix .. "Pin"] = { fg = s.dim, bg = s.bg }
    hl[prefix .. "PinBtn"] = { fg = s.dim, bg = s.bg }
    hl[prefix .. "ERROR"] = { fg = p.blocked, bg = s.bg }
    hl[prefix .. "WARN"] = { fg = p.working, bg = s.bg }
    hl[prefix .. "INFO"] = { fg = p.done, bg = s.bg }
    hl[prefix .. "HINT"] = { fg = p.cyan, bg = s.bg }
    hl[prefix .. "ADDED"] = { fg = p.green, bg = s.bg }
    hl[prefix .. "CHANGED"] = { fg = p.blue, bg = s.bg }
    hl[prefix .. "DELETED"] = { fg = p.red, bg = s.bg }
  end
  hl.BufferTabpageFill = { bg = bg_chrome }
  hl.BufferTabpages = { fg = p.accent, bg = bg_chrome, bold = true }
  hl.BufferTabpagesSep = { fg = p.dim, bg = bg_chrome }
  hl.BufferOffset = { fg = p.muted, bg = bg_chrome }
  hl.BufferScrollArrow = { fg = p.accent, bg = bg_chrome }

  return hl
end

return M
