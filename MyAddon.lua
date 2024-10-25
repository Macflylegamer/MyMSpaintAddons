local Options = getgenv().Linoria.Options;
local Toggles = getgenv().Linoria.Toggles;

local Addon = {
	Name = "ClearItems",
	Title = "Clear Items",
	Description = "This addon allows you to clear individual items from your backpack or hand with a single click.",

	Game = {
		"doors/doors",
		"doors/lobby"
	},

	Elements = {},  -- This will be populated dynamically with buttons
};

-- Function to update the item buttons
local function UpdateItemButtons()
	local player = game.Players.LocalPlayer
	local backpack = player:FindFirstChild("Backpack")
	local character = player.Character

	-- Clear previous buttons
	table.clear(Addon.Elements)

	-- Add buttons for each item in backpack
	if backpack then
		for _, item in ipairs(backpack:GetChildren()) do
			table.insert(Addon.Elements, {
				Type = "Button",
				Name = item.Name .. " [" .. item:GetDebugId() .. "]",
				Arguments = {
					Text = item.Name .. " (Backpack)",
					Tooltip = 'Removes ' .. item.Name .. ' from your backpack',

					Func = function()
						item:Destroy()
						UpdateItemButtons()  -- Update buttons after deletion
					end
				}
			})
		end
	end

	-- Add button for the item in hand (if any)
	if character then
		local tool = character:FindFirstChildOfClass("Tool")
		if tool then
			table.insert(Addon.Elements, {
				Type = "Button",
				Name = tool.Name .. " [" .. tool:GetDebugId() .. "]",
				Arguments = {
					Text = tool.Name .. " (Hand)",
					Tooltip = 'Removes ' .. tool.Name .. ' from your hand',

					Func = function()
						tool:Destroy()
						UpdateItemButtons()  -- Update buttons after deletion
					end
				}
			})
		end
	end
end

-- Initial button population
UpdateItemButtons()

-- Monitor changes in the backpack and hand
local player = game.Players.LocalPlayer
player.Backpack.ChildAdded:Connect(UpdateItemButtons)
player.Backpack.ChildRemoved:Connect(UpdateItemButtons)
player.Character.ChildAdded:Connect(UpdateItemButtons)
player.Character.ChildRemoved:Connect(UpdateItemButtons)

return Addon;
