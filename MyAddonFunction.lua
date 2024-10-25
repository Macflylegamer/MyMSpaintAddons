local Tabs = {
    -- Creates a new tab titled Main
    AddonTab = shared.Window.Tabs["Addons [BETA]"],
}

local ClearItemsGroupBox = Tabs.AddonTab.Groupboxes["ClearItems"]

for name, groupbox in pairs(Tabs.AddonTab.Groupboxes) do
    print("Groupbox Name: " .. name, groupbox)
end

ClearItemsGroupBox:AddToggle('MyToggle', {
    Text = 'This is a toggle',
    Default = true, -- Default value (true / false)
    Tooltip = 'This is a tooltip', -- Information shown when you hover over the toggle

    Callback = function(Value)
        print('[cb] MyToggle changed to:', Value)
    end
})
