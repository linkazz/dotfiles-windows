local wezterm = require("wezterm")

return {
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