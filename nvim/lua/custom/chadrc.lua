---@type ChadrcConfig 
local M = {}

-- path to overriding themes and highlight files 
local highlights = require "custom.highlights"

M.ui = {
  theme = "tokyonight",
  theme_toggle = {
    "catppuccin",
    "tokyonight",
  },
  hl_override = highlights.override,
  hl_add = highlights.add,
  tabufline = {
    enable = true,
    lazyload = false,
  },
}

M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

return M
