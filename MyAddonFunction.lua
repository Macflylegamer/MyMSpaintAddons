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

ClearItemsGroupBox:AddToggle('MyToggle', {
    Text = 'Update 6.75!',
    Default = true, -- Default value (true / false)
    Tooltip = 'This is a tooltip', -- Information shown when you hover over the toggle

    Callback = function(Value)
        print('[cb] MyToggle changed to:', Value)
    end
})

for _, outerFrame in ipairs(ClearItemsGroupBox.Container:GetChildren()) do
    local label = outerFrame:FindFirstChildOfClass('Frame') and outerFrame:FindFirstChildOfClass('Frame'):FindFirstChildWhichIsA('TextLabel')
    if label and label.Text == "Setup Clear Items" then
        outerFrame:Destroy()
        ClearItemsGroupBox:Resize()
        break
    end
end
