local Options = getgenv().Linoria.Options
local Toggles = getgenv().Linoria.Toggles

local Addon = {
    Name = "ClearItemsManualSetup",
    Title = "Clear Items Manual Setup",
    Description = "The manual setup of my addon (cuz dropdown doesn't work without this)",

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
                    -- Load the script and call setupAddon with true and the window
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/Macflylegamer/MyMSpaintAddons/refs/heads/main/ClearItemsSetup.lua"))(true)
                end
            }
        }
    }
};

return Addon
