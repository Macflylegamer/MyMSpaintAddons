local Options = getgenv().Linoria.Options;
local Toggles = getgenv().Linoria.Toggles;

local Addon = {
	Name = "ClearItems",
	Title = "Clear Items",
	Description = "This addon allows you to clear all items from your backpack and the item you're holding with a single click.",

	Game = {
		"doors/doors",
		"doors/lobby"
	},

	Elements = {
		{
			Type = "Button",
			Name = "SetupButton",
			Arguments = {
				Text = 'Setup Clear Items',
				Tooltip = 'Setup the Clear Items addon (because dropdown is broken using the normal thing)',

				Func = function()
					loadstring(game:HttpGet("https://raw.githubusercontent.com/Macflylegamer/MyMSpaintAddons/refs/heads/main/MyAddonFunction.lua"))()
				end
			}
		}
	}
};

return Addon;
