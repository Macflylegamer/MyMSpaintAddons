local Tabs = {
    -- Creates a new tab titled Main
    AddonTab = shared.Window.Tabs["Addons [BETA]"],
}

-- Function to check if auto setup is requested and return the appropriate string
local function autoSetupRequested()
    return arg[1] and arg[1] == true and "Auto" or "Manual"
end

-- Use the returned string to determine the setup type
local setupType = autoSetupRequested()

print(setupType);

local ClearItemsGroupBox

for groupName, groupbox in pairs(Tabs.AddonTab.Groupboxes) do
    print(groupName)
    if groupName == "Clear Items " .. setupType .. " Setup" then
        ClearItemsGroupBox = groupbox
    end
end

print(ClearItemsGroupBox)

ClearItemsGroupBox:AddToggle('MyToggle', {
    Text = 'Update 8!',
    Default = true, -- Default value (true / false)
    Tooltip = 'This is a tooltip', -- Information shown when you hover over the toggle

    Callback = function(Value)
        print('[cb] MyToggle changed to:', Value)
    end
})

if setupType == "Manual" then
    -- Delete Button if auto setup is requested
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
