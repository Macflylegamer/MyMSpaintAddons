local function setupAddon(isManualSetup)
    local Tabs = {
        -- Creates a new tab titled Main
        AddonTab = shared.Window.Tabs["Addons [BETA]"],
    }

    print(isManualSetup)

    local mode = isManualSetup and "Manual" or "Auto"
    local RemoveItemsGroupBox

    for groupName, groupbox in pairs(Tabs.AddonTab.Groupboxes) do
        if groupName == "Remove Items " .. mode .. " Setup" then
            RemoveItemsGroupBox = groupbox
        end
    end

    -- Generalized function to update text, resize, and optionally delete elements
    local function updateLabel(groupbox, targetText, newText, options)
        -- Determine the search scope based on whether it's the GroupBox label or a regular label
        local searchContainer = options.isGroupboxLabel and groupbox.Container.Parent or groupbox.Container
    
        for _, child in ipairs(searchContainer:GetChildren()) do
            if child:IsA("TextLabel") then
                local matchesTarget = options.isGroupboxLabel and child.TextSize == 14 and child.Position == UDim2.new(0, 4, 0, 2)
                                    or (not options.isGroupboxLabel and child.Text == targetText)
            
                if matchesTarget then
                    -- Update label text if a new one is provided
                    if newText and newText ~= "" then
                        child.Text = newText
                        print("Label text changed to:", newText)
                    
                        -- Resize label dynamically if specified
                        if options.resize then
                            local textSizeY = select(2, Library:GetTextBounds(newText, Library.Font, 14, Vector2.new(child.AbsoluteSize.X, math.huge)))
                            child.Size = UDim2.new(1, -4, 0, textSizeY)
                            groupbox:Resize()
                        end
                    end
                
                    -- Delete the label's parent frame if deletion is requested
                    if options.delete then
                        child.Parent:Destroy()
                    end
                    break
                end
            end
        end
    end

    -- Usage:
    updateLabel(RemoveItemsGroupBox, nil, "Remove Items", { isGroupboxLabel = true, resize = false })  -- Rename GroupBox label
    updateLabel(RemoveItemsGroupBox, "The manual setup of my addon (cuz dropdown doesn't work without this)", 
                "This addon removes the selected items from your inventory", 
                { isGroupboxLabel = false, resize = true })  -- Change specific label text and resize
    updateLabel(RemoveItemsGroupBox, "Setup Remove Items", "", { isGroupboxLabel = false, delete = true })  -- Delete specific button


    RemoveItemsGroupBox:AddToggle('MyToggle', {
        Text = 'Update 9.666.665975!',
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
    RemoveItemsGroupBox:AddDropdown('MyMultiDropdown', {
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
    local DeleteSelectedItemsButton = RemoveItemsGroupBox:AddButton({
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
