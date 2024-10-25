local Options = getgenv().Linoria.Options;
local Toggles = getgenv().Linoria.Toggles;

local Addon = {
	Name = "FunItegrrgh",
	Title = "Fun Itemsgrrg",
	Description = "Fun items, addon by upio",
	Game = {
		"doors/doors",
		"doors/lobby"
	},

	Elements = {
		{
			Type = "Button",
			Name = "ScannerScript",
			Arguments = {
				Text = 'Scanner Script',
				Tooltip = 'Made by lsplash and refactored by upio',

				Func = function(value)
					_G.scanner_fps = _G.scanner_fps or 30
					_G.disable_static = _G.disable_static or false
					loadstring(game:HttpGet("https://raw.githubusercontent.com/notpoiu/Scripts/main/Scanner.lua"))()
				end
			},

			Elements = { -- This is optional, again look in the Linoria Example.lua file to see how this works for the elements.
				{
					Type = "Button",
					Name = "SeekGun",
					Arguments = {
						Text = 'Seek Gun',
						Tooltip = 'Made by upio',
						Func = function(value)
							loadstring(game:HttpGet("https://raw.githubusercontent.com/Macflylegamer/MyMSpaintAddons/refs/heads/main/SeekGunMobile.lua"))()
						end
					}
				}
			}
		},

		{
			Type = "Divider"
		},

        {
            Type = "Input",
            Name = "ScannerFPS",
            Arguments = {
                Default = '30',
                Numeric = true,
                Finished = true,
                ClearTextOnFocus = true,
                    
                Text = 'Scanner FPS',
                Tooltip = 'Changes the FPS of the scanner',

                Placeholder = '30',

                Callback = function(Value)
                    _G.scanner_fps = tonumber(Value)
                end
            }
        },

		{
			Type = "Toggle",
			Name = "DisableStatic",
			Arguments = {
				Text = 'Disable Static',
				Tooltip = 'Disables static in the scanner',

				Enabled = false,

				Callback = function(value)
					_G.disable_static = value
				end
			}
		}
	}
};

return Addon;
