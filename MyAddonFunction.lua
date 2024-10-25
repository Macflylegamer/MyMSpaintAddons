local Tabs = {
    -- Creates a new tab titled Main
    AddonTab = shared.Window.Tabs["Addons [BETA]"],
}

local ClearItemsGroupBox

for groupName, groupbox in pairs(Tabs.AddonTab.Groupboxes) do
    print(groupName)
    if groupName == "Clear Items" then
        print("Found It!");
        ClearItemsGroupBox = groupbox
    end
end

print(ClearItemsGroupBox)

ClearItemsGroupBox:AddToggle('MyToggle', {
    Text = 'Update 6.5!',
    Default = true, -- Default value (true / false)
    Tooltip = 'This is a tooltip', -- Information shown when you hover over the toggle

    Callback = function(Value)
        print('[cb] MyToggle changed to:', Value)
    end
})

local container = ClearItemsGroupBox.Container
for _, outerFrame in ipairs(container:GetChildren()) do
    if outerFrame:IsA('Frame') then
        local innerFrame = outerFrame:FindFirstChildOfClass('Frame')
        if innerFrame then
            local label = innerFrame:FindFirstChildWhichIsA('TextLabel')
            if label and label.Text == "Setup Clear Items" then
                outerFrame:Destroy()  -- Destroy the button's outer frame along with all children
                ClearItemsGroupBox:Resize()     -- Optional: Resize the groupbox if needed
                break
             end
         end
    end
end
