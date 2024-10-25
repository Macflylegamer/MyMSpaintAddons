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

    -- Recursive function to print names of all children and their descendants
    local function printChildrenNames(parent)
        for _, child in ipairs(parent:GetChildren()) do
            print(child.Name)  -- Print the name of the current child

            printChildrenNames(child)

            if child:IsA("TextLabel") then
                print(child.Text);
            end
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

        -- Call the function on the ClearItemsGroupBox.Container
        printChildrenNames(ClearItemsGroupBox.Container)
    end
    
    ClearItemsGroupBox:AddToggle('MyToggle', {
        Text = 'Update 9.666.66385!',
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

        -- Print all items in one line
        print("Current Items in itemNames table: " .. table.concat(itemNames, ", "))

        -- Update the dropdown values
        Options.MyMultiDropdown.Values = itemNames  -- Update existing dropdown values
        Options.MyMultiDropdown:BuildDropdownList()  -- Refresh the dropdown display
        Options.MyMultiDropdown:Display()  -- Update the display
    end

    local selectedItems = {}

    -- Multi dropdown for item deletion
    ClearItemsGroupBox:AddDropdown('MyMultiDropdown', {
        Values = {},  -- Populated dynamically
        Default = 1,
        Multi = true,
        Text = 'Items to Delete',
        Tooltip = 'Select items to delete',

        Callback = function(Value)
            Options.MyMultiDropdown.Value = Value
            print('Multi dropdown got changed')
            for key, value in next, Options.MyMultiDropdown.Value do
                print(key, value) -- should print something like This, true
            end
        end
    })

    Options.MyMultiDropdown:OnChanged(function()
        -- print('Dropdown got changed. New value:', )
        print('Multi dropdown got changed2:')
        for key, value in next, Options.MyMultiDropdown.Value do
            print(key, value) -- should print something like This, true
        end
    end)
    
    -- Button to delete selected items
    local DeleteSelectedItemsButton = ClearItemsGroupBox:AddButton({
        Text = 'Delete Selected Items', 
        Func = function()
            local player = game.Players.LocalPlayer
            local backpack = player:FindFirstChild("Backpack")
            local character = player.Character

            print("Current Items in selectedItems table: ")
            for key, value in next, Options.MyMultiDropdown.Value do
                print(key, value) -- should print something like This, true
            end
    
            for key, isSelected in next, Options.MyMultiDropdown.Value do
                if isSelected then
                    print(key .. " Is Selected!");
                    -- Extract the item name and DebugId from the key
                    local itemName, itemDebugId = key:match("(.+)%s%[(.+)%]")
                    
                    if itemName and itemDebugId then
                        print(itemDebugId);
                        
                        -- Check backpack for the item
                        if backpack then
                            for _, item in ipairs(backpack:GetChildren()) do
                                if item:GetDebugId() == itemDebugId then
                                    item:Destroy()
                                    print('Deleted item from backpack:', itemName)
                                    break
                                end
                            end
                        end

                        -- Check character's tool in hand for the item
                        if character then
                            local tool = character:FindFirstChild(itemName)
                            if tool and tool:GetDebugId() == itemDebugId then
                                tool:Destroy()
                                print('Deleted item from hand:', itemName)
                                break
                            end
                        end
                    end
                end
            end

            -- Update dropdown after deletion
            UpdateDropdown()
        end,
        DoubleClick = false,
        Tooltip = 'This will delete the selected items'
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
