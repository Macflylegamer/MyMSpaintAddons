-- Accepting the isManualSetup argument
local function setupAddon(isManualSetup, window)
    local Tabs = {
        -- Creates a new tab titled Main
        AddonTab = window.Tabs["Addons [BETA]"],
    }

    if AddonTab ~= nil then print("Found Tab!")

    local ClearItemsGroupBox

    for groupName, groupbox in pairs(Tabs.AddonTab.Groupboxes) do
        print(groupName)
        if groupName == "Clear Items" then
            print("Found GroupBox!")
            ClearItemsGroupBox = groupbox
        end
    end

    print(ClearItemsGroupBox)

    ClearItemsGroupBox:AddToggle('MyToggle', {
        Text = 'Update 9!',
        Default = true, -- Default value (true / false)
        Tooltip = 'This is a tooltip', -- Information shown when you hover over the toggle

        Callback = function(Value)
            print('[cb] MyToggle changed to:', Value)
        end
    })

    -- Delete Button only if isAutoSetup is true
    if isManualSetup then
        for _, outerFrame in ipairs(ClearItemsGroupBox.Container:GetChildren()) do
            local label = outerFrame:FindFirstChildOfClass('Frame') and outerFrame:FindFirstChildOfClass('Frame'):FindFirstChildWhichIsA('TextLabel')
            if label and label.Text == "Setup Clear Items" then
                outerFrame:Destroy()
                ClearItemsGroupBox:Resize()
                break
            end
        end
    end

    -- Multi dropdowns
    ClearItemsGroupBox:AddDropdown('MyMultiDropdown', {
        -- Default is the numeric index (e.g. "This" would be 1 since it is first in the values list)
        -- Default also accepts a string as well

        -- Currently, you cannot set multiple values with a dropdown

        Values = { 'This', 'is', 'a', 'dropdown' },
        Default = 1,
        Multi = true, -- true / false, allows multiple choices to be selected

        Text = 'A dropdown',
        Tooltip = 'This is a tooltip', -- Information shown when you hover over the dropdown

        Callback = function(Value)
            print('[cb] Multi dropdown got changed:', Value)
        end
    })
end

-- Call the setupAddon function, passing the value from the loadstring
return setupAddon
