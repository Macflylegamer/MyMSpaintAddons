-- Accepting the isManualSetup argument 
local function setupAddon(isManualSetup)
    local Tabs = {
        -- Creates a new tab titled Main
        AddonTab = shared.Window.Tabs["Addons [BETA]"],
    }

    print(isManualSetup)

    local mode = isManualSetup and "Manual" or "Auto"
    local ClearItemsGroupBox

    for groupName, groupbox in pairs(Tabs.AddonTab.Groupboxes) do
        if groupName == "Clear Items " .. mode .. " Setup" then
            ClearItemsGroupBox = groupbox
        end
    end
    
    -- Delete button if in manual setup
    if isManualSetup then
        for _, outerFrame in ipairs(ClearItemsGroupBox.Container:GetChildren()) do
            local label = outerFrame:FindFirstChildOfClass('Frame') and outerFrame:FindFirstChildOfClass('Frame'):FindFirstChildWhichIsA('TextLabel')
            if label and label.Text == "Setup Clear Items" then
                outerFrame:Destroy()
                break
            end
        end
    end

    ClearItemsGroupBox:AddToggle('MyToggle', {
        Text = 'Update 8.65!',
        Default = true,
        Tooltip = 'This is a tooltip',

        Callback = function(Value)
            print('[cb] MyToggle changed to:', Value)
        end
    })

    -- Function to update the dropdown list
    local function UpdateDropdown()
        local player = game.Players.LocalPlayer
        local backpack = player:FindFirstChild("Backpack")
        local character = player.Character

        local itemNames = {}

        -- Add items from backpack
        if backpack then
            for _, item in ipairs(backpack:GetChildren()) do
                table.insert(itemNames, item.Name .. " [" .. item:GetDebugId() .. "]")
            end
        end

        -- Add item in hand (if any)
        if character then
            local tool = character:FindFirstChildOfClass("Tool")
            if tool then
                table.insert(itemNames, tool.Name .. " [" .. tool:GetDebugId() .. "]")
            end
        end

        -- Print the itemNames table before updating
        print("Current Items in itemNames table:", itemNames)

        -- Update the dropdown values
        Options.MyMultiDropdown.Values = itemNames
    end

    -- Multi dropdown for item deletion
    ClearItemsGroupBox:AddDropdown('MyMultiDropdown', {
        Values = {},  -- Populated dynamically
        Default = 1,
        Multi = true,
        Text = 'Items to Delete',
        Tooltip = 'Select items to delete',

        Callback = function(SelectedItems)
            print('[cb] Items selected for deletion:', SelectedItems)
        end
    })

    -- Update dropdown initially
    UpdateDropdown()

    -- Monitor backpack and character changes
    local player = game.Players.LocalPlayer
    player.Backpack.ChildAdded:Connect(UpdateDropdown)
    player.Backpack.ChildRemoved:Connect(UpdateDropdown)
    player.Character.ChildAdded:Connect(UpdateDropdown)
    player.Character.ChildRemoved:Connect(UpdateDropdown)
end

-- Return the function to be called later
return setupAddon
