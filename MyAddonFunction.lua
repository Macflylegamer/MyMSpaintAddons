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
    Text = 'Update 4.5!',
    Default = true, -- Default value (true / false)
    Tooltip = 'This is a tooltip', -- Information shown when you hover over the toggle

    Callback = function(Value)
        print('[cb] MyToggle changed to:', Value)
    end
})

local container = ClearItemsGroupBox.Container
for _, element in ipairs(container:GetChildren()) do
    print("element : " .. element.name);
    if element:IsA('Frame') or element:IsA('TextLabel') then
        for _, element1 in ipairs(element:GetChildren()) do
            print("element1 : " .. element1.name);
            if element:IsA('Frame') or element:IsA('TextLabel') then
                for _, element2 in ipairs(element1:GetChildren()) do
                    print("element2 : " .. element2.name);
                end
            end
        end
    end
end
