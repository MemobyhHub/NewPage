local HubName = _G.HubNameFr or "Star Hub"
local HubGame = "Blox_FruitKaitun"
local ConfigName = HubName .. game.Players.LocalPlayer.Name .. "-" .. HubGame .. ".json" 
local HttpService = game:GetService("HttpService")
_G.SavedConfig = _G.KaitunConfig or typeof(_G.SavedConfig) == 'table' and _G.SavedConfig or {}
local function SaveConfig(cFtab)
    if not cFtab then cFtab = _G.SavedConfig end
    writefile(ConfigName,HttpService:JSONEncode(cFtab))
end
if _G.KaitunConfig then 
    print('Found kaitun config...')
    SaveConfig(_G.KaitunConfig)
end
local function LoadConfig()
    local IsFile,Data = pcall(function()
        return HttpService:JSONDecode(readfile(ConfigName))
    end)
    if IsFile then 
        if not Data or typeof(Data) ~='table' then 
            SaveConfig()
            LoadConfig()
        end
        _G.SavedConfig = Data 
        print('Readed data:',_G.SavedConfig)
        return Data 
    else
        print('You doesnt have a data file, creating new one...')
        SaveConfig()
        LoadConfig()
    end
end
LoadConfig()
local setidentity = syn and syn.set_thread_identity or set_thread_identity or setidentity or setthreadidentity or function() end
setidentity(8) --hope this fking works
getgenv().Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({
    Title = HubName,
    SubTitle = (_G.HubNameFr2 and "- ".._G.HubNameFr2) or "- discord.gg/Star",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 290),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})
function CreateUiNotify(NotifyConfig)
    NotifyConfig = NotifyConfig or {}
    NotifyConfig.Title = NotifyConfig.Title or "Notify Title"
    NotifyConfig.Content = NotifyConfig.Content or "Notify Content"
    NotifyConfig.SubContent = NotifyConfig.SubContent or ""
    NotifyConfig.Duration = NotifyConfig.Duration or 5
    return Fluent:Notify(NotifyConfig)
end
function Window:NewTab(TabConfig)
    TabConfig = TabConfig or {}
    TabConfig.Title = TabConfig.Title or "Title"
    TabConfig.Icon = TabConfig.Icon or "Icon"
    local AddedTab = Window:AddTab(TabConfig)
    function AddedTab:NewParagraph(ParagraphConfig)
        ParagraphConfig = ParagraphConfig or {}
        ParagraphConfig.Title = ParagraphConfig.Title or "Paragraph Title"
        ParagraphConfig.Content = ParagraphConfig.Content or "Paragraph Content"
        local AddedParagraph = AddedTab:AddParagraph(ParagraphConfig)
        function AddedParagraph:Set(RefreshData)
            RefreshData = RefreshData or {}
            RefreshData.Title = RefreshData.Title or "Title"
            RefreshData.Content = RefreshData.Content or "Content"
            AddedParagraph:SetTitle(RefreshData.Title)
            AddedParagraph:SetDesc(RefreshData.Content)
            return AddParagraph;
        end
        return AddedParagraph
    end
    function AddedTab:NewButton(ButtonConfig)
        ButtonConfig = ButtonConfig or {}
        ButtonConfig.Title = ButtonConfig.Title or "Title"
        ButtonConfig.Description = ButtonConfig.Description or ""
        ButtonConfig.Callback = ButtonConfig.Callback or function() end 
        local AddedButton = AddedTab:AddButton(ButtonConfig)
        return AddedButton
    end  
    function AddedTab:NewToggle(ToggleTitle,ToggleConfig)
        ToggleTitle = ToggleTitle or "Toggle Title"
        ToggleConfig =ToggleConfig or {}
        ToggleConfig.Title = ToggleConfig.Title or "Toggle Title 2"
        ToggleConfig.Description = ToggleConfig.Description or ""
        ToggleConfig.Default = _G.SavedConfig[ToggleTitle] or ToggleConfig.Default or false 
        ToggleConfig.Callback = ToggleConfig.Callback or function() end 
        local AddedToggle = AddedTab:AddToggle(ToggleTitle,ToggleConfig)
        local CallbackCaller = function(ChangedValue)
            _G.SavedConfig[ToggleTitle] = AddedToggle.Value or ChangedValue
            SaveConfig()
            ToggleConfig.Callback(ChangedValue)
        end
        AddedToggle:OnChanged(CallbackCaller)
        function AddedToggle:Set(NewValue)
            return AddedToggle:SetValue(NewValue)
        end
        return AddedToggle
    end
    function AddedTab:NewSlider(SliderTitle,SliderConfig)
        SliderTitle = SliderTitle or "Slider Title"
        SliderConfig = SliderConfig or {}
        SliderConfig.Title = SliderConfig.Title or "Slider Title 2"
        SliderConfig.Description = SliderConfig.Description or "Slider Description"
        SliderConfig.Min = SliderConfig.Min or 1
        SliderConfig.Max = SliderConfig.Max or 100
        SliderConfig.Default = _G.SavedConfig[SliderTitle] or SliderConfig.Default or 50
        SliderConfig.Rounding = SliderConfig.Rounding or 1 
        SliderConfig.Callback = SliderConfig.Callback or function() end
        local AddedSlider = AddedTab:AddSlider(SliderTitle, SliderConfig)
        local CallbackCaller = function(ChangedValue)
            _G.SavedConfig[SliderTitle] = AddedSlider.Value or ChangedValue
            SaveConfig()
            SliderConfig.Callback(ChangedValue)
        end
        AddedSlider:OnChanged(CallbackCaller)
        function AddedSlider:Set(NewValue) 
            return AddSlider:SetValue(NewValue)
        end 
        return AddedSlider
    end
    function AddedTab:NewDropdown(DropdownTitle, DropdownConfig)
        DropdownTitle = DropdownTitle or "Dropdown title"
        DropdownConfig = DropdownConfig or {}
        DropdownConfig.Title = DropdownConfig.Title or "Dropdown Title 2"
        DropdownConfig.Description = DropdownConfig.Description or ""
        DropdownConfig.Values = DropdownConfig.Values or {}
        DropdownConfig.Multi = DropdownConfig.Multi or false
        if DropdownConfig.Multi then 
            DropdownConfig.Default = _G.SavedConfig[DropdownTitle] or DropdownConfig.Default or {}
        else
            DropdownConfig.Default = _G.SavedConfig[DropdownTitle] or DropdownConfig.Default or 0
        end
        DropdownConfig.Callback = DropdownConfig.Callback or function()end
        local AddedDropdown = AddedTab:AddDropdown(DropdownTitle, DropdownConfig)
        local CallbackCaller = function(ChangedValue)
            _G.SavedConfig[DropdownTitle] = AddedDropdown.Value
            SaveConfig()
            AddedDropdown.Callback(ChangedValue)
        end
        function AddedDropdown:Set(NewValue)
            return AddedDropdown:SetValue(NewValue)
        end
        AddedDropdown:OnChanged(CallbackCaller)
    end
    function AddedTab:NewInput(InputTitle,InputConfig)
        InputTitle =InputTitle or "Input Config"
        InputConfig = InputConfig or {}
        InputConfig.Title = InputConfig.Title or "Input Title"
        InputConfig.Default = InputConfig.Default or "Default"
        InputConfig.Finished = InputConfig.Finished or false
        InputConfig.Numeric = InputConfig.Numeric or false
        InputConfig.Callback = InputConfig.Callback or function() end
        local AddedInput = AddedTab:AddInput(InputTitle, InputConfig)
        local CallbackCaller = function(ChangedValue)
            _G.SavedConfig[InputTitle] = AddedInput.Value
            SaveConfig()
            AddedInput.Callback(ChangedValue)
        end
        function AddedInput:Set(NewValue)
            return AddedInput:SetValue(NewValue)
        end
        AddedInput:OnChanged(CallbackCaller)
        return AddedInput
    end
    return AddedTab
end
function Window:NewDialog(DialogConfig)
    DialogConfig = DialogConfig or {}
    DialogConfig.Title = DialogConfig.Title or "Dialog Title"
    DialogConfig.Content = DialogConfig.Content or "Dialog Content"
    DialogConfig.Buttons = DialogConfig.Buttons or {
        {
            Title = "Confirm",
            Callback = function()
                print("Confirmed the dialog.")
            end
        },
        {
            Title = "Cancel",
            Callback = function()
                print("Cancelled the dialog.")
            end
        }
    }
    return Window:Dialog(DialogConfig)
end
--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional

local KaitunSettings = Window:NewTab({Title = "Kaitun Settings"})
KaitunSettings:AddSection("Optional Functions")
KaitunSettings:NewButton({
    ["Title"] = "Hop Server(s)",
    Description = "Press to hop server.",
    ["Callback"] = function()
        if HopServer then HopServer(10,false,"Player requested to hop.") else print('No Hop Server Function') end
    end
})
KaitunSettings:NewButton({
    ["Title"] = "Hop Low Server(s)",
    Description = "Still press to hop LOW server.",
    ["Callback"] = function()
        if HopLow then HopLow() else print('No Hop Server Function') end
    end
})
KaitunSettings:NewSlider('Tween Speed',{
    Title = 'Tweening Speed',
    Min = 100,
    Max = 350,
    Default = 300,
    Rounding = 0,
})
KaitunSettings:NewToggle("Same Y Tween",{
    Title = 'Same Y Tweening',
    Description = 'Always tween the same Y with the target to decrease tween time.',
    Default =true
})
local NearPlayerHopToggle = KaitunSettings:NewToggle('Player Nearing Hop',{
    ["Title"]= "Player Nearing Hop",
    ["Description"] = "Hopping when the player(s) are nearing the distance.",
    ["Callback"] = function(Value) 
        _G.PlayerNearHop = Value
    end
})
local HighPingHopToggle = KaitunSettings:NewToggle('High Ping Hop',{
    ["Title"]= "High Ping Hop",
    ["Description"] = "Hopping while ping get highs for a seconds.",
    ["Callback"] = function(Value) 
        _G.HighPingHop = Value
    end
})
KaitunSettings:NewToggle('Fps Boosting',{
    ["Title"]= "Fps Boosting",
    ["Description"] = "Reduce CPU & Memory to boost FPS.",
    ["Callback"] = function(Value) 
        _G.FPSBOOST = Value
    end
})
KaitunSettings:AddSection("Items Unlocking")
local unlockingItemDropdown = KaitunSettings:NewDropdown("Actions Allowed",{
    ["Title"] = "Choose actions to do",
    ["Multi"] = true,
    ["Values"] = {
        "Awakening Fruit",
        "Soul Guitar",
        "Cursed Dual Katana",
        "Mirror Fractal",
        "Upgrading Race",
        "Rainbown Haki",
        "Buy Swords",
        "Buy accessories",
        "Buy Guns",
        "Buy Hakis",
        "Mirage Puzzle",
        "Upgrade Weapons",
        "Farming Boss Drops When X2 Expired",
        "Farming Boss Drop When Maxed Level",
        "Saber",
        "Pole (1st Form)"
    },
    ["Description"] = "Choose what things you want to do.",
    ["Callback"] = function(Value)
        _G.AllowedActions = Value
    end
})
KaitunSettings:NewDropdown("Race Choosen",{
    ["Title"] = "Race Choosing",
    Description = 'Choose race to roll.',
    ["Multi"] = true,
    ["Values"] = {
        "Human",
        "Fishman",
        "Mink",
        "Skypiea"
    },
    ["Place Holder Text"] = "Select Options",
})
local FruitSnipping = KaitunSettings:NewToggle('Race Snipping',{
    ["Title"]= "Race Snipping",
    Description = "Snipping Race choosen.",
})
KaitunSettings:AddSection("Items Unlocking")
KaitunSettings:NewDropdown("Fruit Choosen",{
    ["Title"] = "Fruit(s) Choosing",
    Description = 'Choose Fruits to do actions.',
    ["Multi"] = true,
    ["Values"] = {
        "Kitsune-Kitsune",
        "Leopard-Leopard",
        "Dragon-Dragon",
        "Spirit-Spirit",
        "Control-Control",
        "Venom-Venom",
        "Shadow-Shadow",
        "Dough-Dough",
        "T-Rex-T-Rex",
        "Mammoth-Mammoth",
        "Gravity-Gravity",
        "Blizzard-Blizzard",
        "Pain-Pain",
        "Rumble-Rumble",
        "Portal-Portal",
        "Phoenix-Phoenix",
        "Sound-Sound",
        "Spider-Spider",
        "Love-Love",
        "Buddha-Buddha",
        "Quake-Quake",
        "Magma-Magma",
        "Ghost-Ghost",
        "Barrier-Barrier",
        "Rubber-Rubber",
        "Light-Light",
        "Diamond-Diamond",
        "Dark-Dark",
        "Sand-Sand",
        "Ice-Ice",
        "Falcon-Falcon",
        "Flame-Flame",
        "Spike-Spike",
        "Smoke-Smoke",
        "Bomb-Bomb",
        "Spring-Spring",
        "Chop-Chop",
        "Spin-Spin",
        "Rocket-Rocket",
    },
    ["Place Holder Text"] = "Select Options",
    ["Callback"] = function(Value)
        _G.FruitSniping = {}
        for i,v in pairs(Value) do 
            if v then 
                table.insert(_G.FruitSniping,i)
            end
        end
    end
})

local FruitSnipping = KaitunSettings:NewToggle('Fruit Snipping',{
    ["Title"]= "Fruit Snipping",
    Description = "Snipping fruit(s) choosen.",
    ["Callback"] = function(Value) 
        _G.SnipeFruit = Value
    end
})
local FruitEating = KaitunSettings:NewToggle("Fruit Eating",{
    ["Title"]= "Fruit Eating",
    Description = "Eating fruit(s) choosen.",
    ["Callback"] = function(Value) 
        _G.IncludeStored = Value
    end
})
local IncludedStorageToggle = KaitunSettings:NewToggle("Allow Stored",{
    ["Title"]= "Including Storeds",
    Description = "Getting stored fruit(s) to eat.",
    ["Callback"] = function(Value) 
        _G.IncludeStored = _G.IncludeStored and Value
    end
})
local StatsTab = Window:NewTab({Title = "Status Tab"}) 
_G.LocalPlayerStatusParagraph = StatsTab:NewParagraph({
    Title = "Local Player Status",
    Content = "None"
})
_G.ServerStatusParagraph = StatsTab:NewParagraph({
    Title = "Server Status",
    Content = "None"
})
_G.ItemOwnedParagraph = StatsTab:NewParagraph({
    Title = "Item Owned",
    Content = "None"
})
local guv = getupvalues or debug.getupvalues or getupvalue or debug.getupvalue
local hok = hookfunction or debug.hookfunction
local req = require or debug.require
Window:SelectTab(1)
Fluent:Notify({
    Title = _G.HubNameFr or "Star",
    Content = "The script has been loaded.",
    Duration = 8
})
