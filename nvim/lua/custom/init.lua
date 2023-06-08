---for NVIM opts + commands
local g = vim.g
local opt = vim.opt
--local HOME = os.getenv("HOME")
-- local autocmd = vim.api.nvim_create_autocmd

-- opt.colorcolumn = "80"
-- opt.fileformat = "unix"
-- opt.fileformats = "unix,dos,mac"
-- opt.wildignore = "wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__,.DS_Store"

g.copilot_assume_mapped = true
-- g.tmux_navigator_save_on_switch = 2
--g.vimwiki_list = {
--  {
--    path = HOME .. "/Documents/vimwiki",
--    syntax = "markdown",
--    ext = ".md",
--    links_space_char = "_",
--  },
--}

vim.g.dap_virtual_text = true
