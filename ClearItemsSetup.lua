local Tabs = {
    -- Creates a new tab titled Main
    AddonTab = shared.Window.Tabs["Addons [BETA]"],
}

local ClearItemsGroupBox

for groupName, groupbox in pairs(Tabs.AddonTab.Groupboxes) do
    print(groupName)
    if groupName == "Clear Items" then
        ClearItemsGroupBox = groupbox
    end
end

print(ClearItemsGroupBox)

-- Check if manual setup is requested
local function manualSetupRequested()
    return arg[1] and arg[1] == true -- Check if the first argument is true
end

ClearItemsGroupBox:AddToggle('MyToggle', {
    Text = 'Update 7!',
    Default = true, -- Default value (true / false)
    Tooltip = 'This is a tooltip', -- Information shown when you hover over the toggle

    Callback = function(Value)
        print('[cb] MyToggle changed to:', Value)
    end
})

-- Delete Button based on the manual setup value
if manualSetupRequested() then
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
