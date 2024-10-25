local Options = getgenv().Linoria.Options;
local Toggles = getgenv().Linoria.Toggles;

local Addon = {
	Name = "ClearItems",
	Title = "Clear Items",
	Description = "This addon allows you to clear selected items from your backpack or hand with a single click.",

	Game = {
		"doors/doors",
		"doors/lobby"
	},

	Elements = {
		{
			Type = "Dropdown",
			Name = "ItemsToDelete",
			Arguments = {
				Values = {},  -- Will be populated dynamically
				Default = 1,
				Multi = true, -- Allows multiple choices to be selected

				Text = 'Items to Delete',
				Tooltip = 'Select the items you want to delete from your backpack or hand',

				Callback = function(SelectedItems)
					print('[cb] Items selected for deletion:', SelectedItems)
				end
			}
		},
		{
			Type = "Button",
			Name = "ClearItemsButton",
			Arguments = {
				Text = 'Clear items',
				Tooltip = 'Removes the selected items from the player\'s backpack and/or hand',

				Func = function()
					local player = game.Players.LocalPlayer
					local backpack = player:FindFirstChild("Backpack")
					local character = player.Character
					local selectedItems = Options.ItemsToDelete.Values  -- Selected items in dropdown

					-- Remove selected items from backpack
					if backpack then
						for _, item in ipairs(backpack:GetChildren()) do
							-- Match using instance ID
							if table.find(selectedItems, item.Name .. " [" .. item:GetDebugId() .. "]") then
								item:Destroy()
							end
						end
					end

					-- Remove the selected item in hand (if any)
					if character then
						local tool = character:FindFirstChildOfClass("Tool")
						if tool and table.find(selectedItems, tool.Name .. " [" .. tool:GetDebugId() .. "]") then
							tool:Destroy()
						end
					end

					-- Update dropdown list after deletion
					UpdateDropdown()
				end
			}
		}
	}
};

-- Function to update the dropdown list
function UpdateDropdown()
	local player = game.Players.LocalPlayer
	local backpack = player:FindFirstChild("Backpack")
	local character = player.Character

	local itemNames = {}

	-- Add items from backpack
	if backpack then
		for _, item in ipairs(backpack:GetChildren()) do
			-- Append instance ID to differentiate between identical names
			table.insert(itemNames, item.Name .. " [" .. item:GetDebugId() .. "]")
		end
	end

	-- Add item in hand (if any)
	if character then
		local tool = character:FindFirstChildOfClass("Tool")
		if tool then
			-- Append instance ID to differentiate between identical names
			table.insert(itemNames, tool.Name .. " [" .. tool:GetDebugId() .. "]")
		end
	end

	-- Update the dropdown values
	Options.ItemsToDelete.Values = itemNames
end

-- Initial dropdown population
UpdateDropdown()

-- Monitor changes in the backpack and hand
player.Backpack.ChildAdded:Connect(UpdateDropdown)
player.Backpack.ChildRemoved:Connect(UpdateDropdown)
player.Character.ChildAdded:Connect(UpdateDropdown)
player.Character.ChildRemoved:Connect(UpdateDropdown)

return Addon;
