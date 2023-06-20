local wezterm = require("wezterm")
-- local right_status = require('config.right-status')
local launch_menu = {}
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	table.insert(launch_menu, {
		label = "PowerShell",
		args = { "pwsh.exe", "-NoLogo" },
	})

	-- Find installed visual studio version(s) and add their compilation
	-- environment command prompts to the menu
	for _, vsvers in ipairs(wezterm.glob("Microsoft Visual Studio/20*", "C:/Program Files (x86)")) do
		local year = vsvers:gsub("Microsoft Visual Studio/", "")
		table.insert(launch_menu, {
			label = "x64 Native Tools VS " .. year,
			args = {
				"cmd.exe",
				"/k",
				"C:/Program Files (x86)/" .. vsvers .. "/BuildTools/VC/Auxiliary/Build/vcvars64.bat",
			},
		})
	end

	-- Enumerate any WSL distributions that are installed and add those to the menu
	local success, wsl_list, wsl_err = wezterm.run_child_process({ "wsl.exe", "-l" })
	if success then
		-- `wsl.exe -l` has a bug where it always outputs utf16:
		-- https://github.com/microsoft/WSL/issues/4607
		-- So we get to convert it
		wsl_list = wezterm.utf16_to_utf8(wsl_list)

		for idx, line in ipairs(wezterm.split_by_newlines(wsl_list)) do
			-- Skip the first line of output; it's just a header
			if idx > 1 then
				-- Remove the "(Default)" marker from the default line to arrive
				-- at the distribution name on its own
				local distro = line:gsub(" %(Default%)", "")

				-- Add an entry that will spawn into the distro with the default shell
				table.insert(launch_menu, {
					label = distro .. " (WSL default shell)",
					args = { "wsl.exe", "--distribution", distro },
				})

				-- Here's how to jump directly into some other program; in this example
				-- its a shell that probably isn't the default, but it could also be
				-- any other program that you want to run in that environment
				table.insert(launch_menu, {
					label = distro .. " (WSL zsh login shell)",
					args = {
						"wsl.exe",
						"--distribution",
						distro,
						"--exec",
						"/bin/zsh",
						"-l",
					},
				})
			end
		end
	end
end

local config = {
	debug_key_events = true,
	max_fps = 60,
	color_scheme = "Ayu Mirage (Gogh)",
	font = wezterm.font_with_fallback({
		"JetBrainsMono Nerd Font",
		{ family = "Symbols NFM", scale = 0.5 },
		"Noto Color Emoji",
	}),
	default_prog = { "pwsh" },

	font_size = 9,
	window_background_opacity = 0.95,
	text_background_opacity = 1,

	initial_cols = 200,
	initial_rows = 50,
	scrollback_lines = 3500,
	enable_scroll_bar = false,

	warn_about_missing_glyphs = true,

	tab_bar_at_bottom = true,
	use_fancy_tab_bar = true,
	tab_max_width = 15,

	enable_kitty_graphics = true,
	enable_kitty_keyboard = true,

	default_cursor_style = "BlinkingBlock",
	cursor_blink_rate = 400,
	animation_fps = 60,

	window_frame = {
		font_size = 9,
		inactive_titlebar_bg = "#353535",
		active_titlebar_bg = "#2b2042",
		inactive_titlebar_fg = "#cccccc",
		active_titlebar_fg = "#ffffff",
		inactive_titlebar_border_bottom = "#2b2042",
		active_titlebar_border_bottom = "#2b2042",
		button_fg = "#cccccc",
		button_bg = "#2b2042",
		button_hover_fg = "#ffffff",
		button_hover_bg = "#3b3052",
	},

	window_padding = {
		left = 3,
		right = 3,
		top = 1,
		bottom = 1,
	},

	hyperlink_rules = {
		-- Linkify things that look like URLs and the host has a TLD name.
		-- Compiled-in default. Used if you don't specify any hyperlink_rules.
		{ regex = "\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b", format = "$0" },

		-- linkify email addresses
		-- Compiled-in default. Used if you don't specify any hyperlink_rules.
		{ regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]], format = "mailto:$0" },
		-- file:// URI
		-- Compiled-in default. Used if you don't specify any hyperlink_rules.
		{ regex = [[\bfile://\S*\b]], format = "$0" },
		-- Make task numbers clickable
		-- The first matched regex group is captured in $1.
		{ regex = [[\b[tT](\d+)\b]], format = "https://example.com/tasks/?t=$1" },

		-- Make username/project paths clickable. This implies paths like the following are for GitHub.
		-- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wez/wezterm | "wez/wezterm.git" )
		-- As long as a full URL hyperlink regex exists above this it should not match a full URL to
		-- GitHub or GitLab / BitBucket (i.e. https://gitlab.com/user/project.git is still a whole clickable URL)
		{ regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]], format = "https://www.github.com/$1/$3" },
	},

	leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1500 },

	-- send_composed_key_when_left_alt_is_pressed = true,
	-- send_composed_key_when_right_alt_is_pressed = false,

	keys = {
		--- multiplex keybindings
		{
			key = "/",
			mods = "LEADER",
			action = wezterm.action({
				SplitHorizontal = { domain = "CurrentPaneDomain" },
			}),
		},
		{
			key = "-",
			mods = "LEADER",
			action = wezterm.action({
				SplitVertical = { domain = "CurrentPaneDomain" },
			}),
		},
		{
			key = "LeftArrow",
			mods = "LEADER",
			action = wezterm.action({ ActivatePaneDirection = "Left" }),
		},
		{
			key = "DownArrow",
			mods = "LEADER",
			action = wezterm.action({ ActivatePaneDirection = "Down" }),
		},
		{
			key = "UpArrow",
			mods = "LEADER",
			action = wezterm.action({ ActivatePaneDirection = "Up" }),
		},
		{
			key = "RightArrow",
			mods = "LEADER",
			action = wezterm.action({ ActivatePaneDirection = "Right" }),
		},
		{
			key = "x",
			mods = "LEADER",
			action = wezterm.action({ CloseCurrentPane = { confirm = false } }),
		},
		{
			key = "Enter",
			mods = "LEADER",
			action = "TogglePaneZoomState",
		},

		--- tab keybindings
		{
			key = "t",
			mods = "LEADER",
			action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }),
		},
		{
			key = "w",
			mods = "LEADER",
			action = wezterm.action({ CloseCurrentTab = { confirm = true } }),
		},
		{
			key = "]",
			mods = "LEADER",
			action = wezterm.action({ ActivateTabRelative = 1 }),
		},
		{
			key = "[",
			mods = "LEADER",
			action = wezterm.action({ ActivateTabRelative = -1 }),
		},
	},
}

--     -- Each element holds the text for a cell in a "powerline" style << fade
--   local cells = {}

--     -- local greetings = "hello world"
--     -- table.insert(cells, greetings)

--   -- Figure out the cwd and host of the current pane.
--   -- This will pick up the hostname for the remote host if your
--   -- shell is using OSC 7 on the remote host.
--   local cwd_uri = pane:get_current_working_dir()
--   if cwd_uri then
--     cwd_uri = cwd_uri:sub(8)
--     local slash = cwd_uri:find '/'
--     local cwd = ''
--     local hostname = ''
--     if slash then
--       hostname = cwd_uri:sub(1, slash - 1)
--       -- Remove the domain name portion of the hostname
--       local dot = hostname:find '[.]'
--       if dot then
--         hostname = hostname:sub(1, dot - 1)
--       end
--       -- and extract the cwd from the uri
--       cwd = cwd_uri:sub(slash)

--       table.insert(cells, cwd)
--       table.insert(cells, hostname)
--     end
--   end

--   -- I like my date/time in this style: "Wed Mar 3 08:14"
--   local date = wezterm.strftime '%a %b %-d %H:%M'
--   table.insert(cells, date)

--   -- An entry for each battery (typically 0 or 1 battery)
--   for _, b in ipairs(wezterm.battery_info()) do
--     table.insert(cells, string.format('%.0f%%', b.state_of_charge * 100))
--   end

--   -- The powerline < symbol
--   local LEFT_ARROW = utf8.char(0xe0b3)
--   -- The filled in variant of the < symbol
--   local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

--   -- Color palette for the backgrounds of each cell
--   local colors = {
--     '#3c1361',
--     '#52307c',
--     '#663a82',
--     '#7c5295',
--     '#b491c8',
--   }

--   -- Foreground color for the text across the fade
--   local text_fg = '#c0c0c0'

--   -- The elements to be formatted
--   local elements = {}
--   -- How many cells have been formatted
--   local num_cells = 0

--   -- Translate a cell into elements
--   function push(text, is_last)
--     local cell_no = num_cells + 1
--     table.insert(elements, { Foreground = { Color = text_fg } })
--     table.insert(elements, { Background = { Color = colors[cell_no] } })
--     table.insert(elements, { Text = ' ' .. text .. ' ' })
--     if not is_last then
--       table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
--       table.insert(elements, { Text = SOLID_LEFT_ARROW })
--     end
--     num_cells = num_cells + 1
--   end

--   while #cells > 0 do
--     local cell = table.remove(cells, 1)
--     push(cell, #cells == 0)
--   end

--   window:set_right_status(wezterm.format(elements))
-- end)

-- local wttr = 'ttr.in/Bukit-Antarabangsa?format="%l:+%c+%t+|+%f+%m&period=60\\n"
-- local cmd = "curl " .. wttr
-- table.insert(cells, os.exeute(cmd))
-- local handle = io.popen(cmd)
-- local result = handle:read("*a")
-- handle:close()
-- print(result)
-- local weather = curl wttr.in/Bukit-Antarabangsa?format="%l:+%c+%t+|+%f+%m&period=60\n"
-- }

return config
