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
    Text = 'This is a toggle',
    Default = true, -- Default value (true / false)
    Tooltip = 'This is a tooltip', -- Information shown when you hover over the toggle

    Callback = function(Value)
        print('[cb] MyToggle changed to:', Value)
    end
})

for _, child in ipairs(ClearItemsGroupBox.Container:GetChildren()) do
        if child:IsA("Frame") and child:FindFirstChild("Label") then
            local label = child.Label
            print(label.Text);
        end
end

for _, child in ipairs(ClearItemsGroupBox.Container:GetChildren()) do
        if child:IsA("Frame") and child:FindFirstChild("Label") then
            local label = child.Label
            if label.Text == "Setup Clear Items" then
                child:Destroy() -- Remove the button
                break -- Exit the loop after removing the button
            end
        end
end
