local lasttis = 0 
local JoinedGame = tick() 
_G.MeleeWait = ''
getgenv().SetContent = function(v1,delayticks)
    if not v1 then v1 = '' end 
    if tick()-lasttis > 0 then
        if not _G.CurrentTask then 
            _G.CurrentTask = ''
        end 
        if not _G.MeleeWait then 
            _G.MeleeWait = '' 
        end 
        local aSet1 = _G.CurrentTask
        if _G.MeleeTask and _G.MeleeTask ~= '' and _G.MeleeTask ~='None' then 
            aSet1 = _G.MeleeTask
        end
        if ContentSet then ContentSet(v1,tostring(aSet1),tostring(_G.MeleeWait)) else print('Not content set') end
    end 
    if delayticks then 
        lasttis = tick()+delayticks
    end
end  
getgenv().SetMeleeWait = function(v1Name,v1Value)
    _G.MeleeWait = " | Waiting "..tostring(v1Name).." hit "..tostring(v1Value).." mastery." 
end
_G.ServerData = {} 
function Join(v2) 
    v2 = tostring(v2) or "Pirates"
    v2 = string.find(v2,"Marine") and "Marines" or "Pirates"
    for i, v in pairs(
        getconnections(
            game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Container[v2].Frame.TextButton.Activated
        )
    ) do
        v.Function()
    end
end
if not game.Players.LocalPlayer.Team then 
    repeat
        pcall(
            function()
                task.wait()
                if game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("Main"):FindFirstChild("ChooseTeam") then 
                    Join(_G.Team)
                end
            end
        )
    until game.Players.LocalPlayer.Team ~= nil 
end
print('Loaded Team')
local RunService= game:GetService("RunService")
function RemoveLevelTitle(v)
    return tostring(tostring(v):gsub(" %pLv. %d+%p", ""):gsub(" %pRaid Boss%p", ""):gsub(" %pBoss%p", ""))
end 
if game.Workspace:FindFirstChild("MobSpawns") then
    for i, v in pairs(game.Workspace:GetChildren()) do
        if v.Name == "MobSpawns" then
            v:Destroy()
        end
    end
end
_G.SavedConfig = type(_G.SavedConfig) == 'table' and _G.SavedConfig or {}
--loadstring(game:HttpGet('https://raw.githubusercontent.com/memaybeohub/NewPage/main/FastAttackLoading.lua'))()
loadstring(game:HttpGet('https://raw.githubusercontent.com/memaybeohub/NewPage/main/HopLoader.lua'))()
function GetDistance(target1, taget2)
    if not taget2 then
        pcall(function()
            taget2 = game.Players.LocalPlayer.Character.HumanoidRootPart
        end)
    end
    local bbos, bbos2 =
        pcall(
        function()
            a = target1.Position
            a2 = taget2.Position
        end
    )
    if bbos then
        return (a - a2).Magnitude
    end
end 

local MobSpawnsFolder = Instance.new("Folder")
MobSpawnsFolder.Parent = game.Workspace
MobSpawnsFolder.Name = "MobSpawns"
MobSpawnsFolder.ChildAdded:Connect(function(v)
    wait(1)
    v.Name = RemoveLevelTitle(v.Name)
end)
function getBlueGear()
    if game.workspace.Map:FindFirstChild("MysticIsland") then
        for i, v in pairs(game.workspace.Map.MysticIsland:GetChildren()) do
            if v:IsA("MeshPart") and v.MeshId == "rbxassetid://10153114969" then --and not v.CanCollide then
                return v
            end
        end
    end
end 
function getHighestPoint()
    if not game.workspace.Map:FindFirstChild("MysticIsland") then
        return nil
    end
    for i, v in pairs(game:GetService("Workspace").Map.MysticIsland:GetDescendants()) do
        if v:IsA("MeshPart") then
            if v.MeshId == "rbxassetid://6745037796" then
                return v
            end
        end
    end
end
local AllMobInGame = {}
for i, v in next, require(game:GetService("ReplicatedStorage").Quests) do
    for i1, v1 in next, v do
        for i2, v2 in next, v1.Task do
            if v2 > 1 then
                table.insert(AllMobInGame, i2)
            end
        end
    end
end
local MobOutFolder = {}
for i, v in pairs(game:GetService("Workspace")["_WorldOrigin"].EnemySpawns:GetChildren()) do
    v.Name = RemoveLevelTitle(v.Name)
    table.insert(MobOutFolder, v)
end
for i, v in pairs(getnilinstances()) do
    if table.find(AllMobInGame, RemoveLevelTitle(v.Name)) then
        table.insert(MobOutFolder, v)
    end
end
local l1 = {}
function ReCreateMobFolder()
    local MobNew
    l1 = {}
    for i,v in pairs(MobOutFolder) do 
        if v then
            pcall(function()
                if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
                    MobNew = Instance.new("Part")
                    MobNew.CFrame = v.PrimaryPart.CFrame
                    MobNew.Name = v.Name
                    MobNew.Parent = game.Workspace.MobSpawns
                elseif v:IsA("Part") then
                    MobNew = v:Clone()
                    MobNew.Parent = game.Workspace.MobSpawns
                    MobNew.Transparency = 1
                end
                if not table.find(l1,v.Name) then 
                    table.insert(l1,tostring(v.Name))
                end 
            end)
        end
    end
end
task.spawn(ReCreateMobFolder)
local MobSpawnClone = {}
local function getMid(vName,gg)
    local total = 0
    local allplus 
    for i,v in pairs(gg) do
        if v.Name == vName then 
            if not allplus then 
                allplus = v.Position
            else
                allplus = allplus+v.Position 
            end
            total = total+1
        end
    end
    if allplus then return allplus/total end 
end
local lss = 0
for i,v in pairs(game.Workspace.MobSpawns:GetChildren()) do 
    if not MobSpawnClone[v.Name] then 
        MobSpawnClone[RemoveLevelTitle(v.Name)] = CFrame.new(getMid(v.Name,game.Workspace.MobSpawns:GetChildren()))
        lss = lss +1
    end 
end
_G.MobSpawnClone = MobSpawnClone
function GetMobSpawnList(a)
    local a = RemoveLevelTitle(a)
    k = {}  
    for i, v in pairs(game.Workspace.MobSpawns:GetChildren()) do
        if v.Name == a then
            table.insert(k, v)
        end
    end
    return k
end

local BlackListLocation = {}
function CheckNearestTeleporter(vcs)
    vcspos = vcs.Position
    min = math.huge
    min2 = math.huge
    local placeId = game.PlaceId
    if placeId == 2753915549 then
        OldWorld = true
    elseif placeId == 4442272183 then
        NewWorld = true
    elseif placeId == 7449423635 then
        ThreeWorld = true
    end
    local chooseis
    if ThreeWorld then
        TableLocations = {
            ["Caslte On The Sea"] = Vector3.new(-5058.77490234375, 314.5155029296875, -3155.88330078125),
            ["Hydra"] = Vector3.new(5756.83740234375, 610.4240112304688, -253.9253692626953),
            ["Mansion"] = Vector3.new(-12463.8740234375, 374.9144592285156, -7523.77392578125),
            ["Great Tree"] = Vector3.new(28282.5703125, 14896.8505859375, 105.1042709350586),
            ["Ngu1"] = Vector3.new(-11993.580078125, 334.7812805175781, -8844.1826171875),
            ["ngu2"] = Vector3.new(5314.58203125, 25.419387817382812, -125.94227600097656),
            ["Temple Of Time"] = Vector3.new(2957.833740234375, 2286.495361328125, -7217.05078125)
        }
    elseif NewWorld then
        TableLocations = {
            ["Mansion"] = Vector3.new(-288.46246337890625, 306.130615234375, 597.9988403320312),
            ["Flamingo"] = Vector3.new(2284.912109375, 15.152046203613281, 905.48291015625),
            ["122"] = Vector3.new(923.21252441406, 126.9760055542, 32852.83203125),
            ["3032"] = Vector3.new(-6508.5581054688, 89.034996032715, -132.83953857422)
        }
    elseif OldWorld then
        TableLocations = {
            ["1"] = Vector3.new(-7894.6201171875, 5545.49169921875, -380.2467346191406),
            ["2"] = Vector3.new(-4607.82275390625, 872.5422973632812, -1667.556884765625),
            ["3"] = Vector3.new(61163.8515625, 11.759522438049316, 1819.7841796875),
            ["4"] = Vector3.new(3876.280517578125, 35.10614013671875, -1939.3201904296875)
        }
    end
    local mmbb = {}
    for i2, v2 in pairs(TableLocations) do
        if not table.find(BlackListLocation, i2) then
            mmbb[i2] = v2
        end
    end
    local TableLocations = mmbb
    local TableLocations2 = {}
    for i, v in pairs(TableLocations) do
        if typeof(v) ~= "table" then
            TableLocations2[i] = (v - vcspos).Magnitude
        else
            TableLocations2[i] = (v["POS"] - vcspos).Magnitude
        end
    end
    for i, v in pairs(TableLocations2) do
        if v < min then
            min = v
            min2 = v
            choose = TableLocations[i]
            chooseis = i
        end
    end
    min3 = (vcspos - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if min2 + 100 <= min3 then
        return choose, chooseis
    end
end
function requestEntrance(vector3, fr)
    if not fr or fr ~= "Temple Of Time" and fr ~= "Dismension" then
        args = {
            "requestEntrance",
            vector3
        }
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
        oldcframe = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        char = game.Players.LocalPlayer.Character.HumanoidRootPart
        char.CFrame = CFrame.new(oldcframe.X, oldcframe.Y + 50, oldcframe.Z)
        task.wait(0.5)
    else
        pcall(
            function()
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
                    "requestEntrance",
                    Vector3.new(28282.5703125, 14896.8505859375, 105.1042709350586)
                )
                if GetDistance(CFrame.new(28282.5703125, 14896.8505859375, 105.1042709350586)) > 10 then
                    return
                end
                game.Players.LocalPlayer.Character:MoveTo(
                    CFrame.new(
                        28390.7812,
                        14895.8574,
                        106.534714,
                        0.0683786646,
                        1.44424162e-08,
                        -0.997659445,
                        7.52342522e-10,
                        1,
                        1.45278642e-08,
                        0.997659445,
                        -1.74397752e-09,
                        0.0683786646
                    ).Position
                )
                AllNPCS = getnilinstances()
                for i, v in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
                    table.insert(AllNPCS, v)
                end
                for i, v in pairs(AllNPCS) do
                    if v.Name == "Mysterious Force" then
                        TempleMysteriousNPC1 = v
                    end
                    if v.Name == "Mysterious Force3" then
                        TempleMysteriousNPC2 = v
                    end
                end
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                    TempleMysteriousNPC2.HumanoidRootPart.CFrame
                wait(0.3)
                if
                    (TempleMysteriousNPC2.HumanoidRootPart.Position -
                        game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 15
                 then
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "TeleportBack")
                end
                wait(0.75)
            end
        )
    end
end
function AntiLowHealth(NewY)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
        CFrame.new(
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X,
        NewY,
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z
    )
    wait()
end
function GetMidPoint(MobName, b2)
    if MobName == "Ship Officer [Lv. 1325]" then
        return b2.CFrame
    end
    if 1 > 1 then
        return b2.CFrame
    end
    local totalpos
    allid = 0
    for i, v in pairs(game.workspace.Enemies:GetChildren()) do
        if
            v.Name == MobName and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") and
                (b2 and GetDistance(v.HumanoidRootPart, b2) <= 475)
         then
            if not totalpos then
                totalpos = v.HumanoidRootPart.Position
            elseif totalpos then
                totalpos = totalpos + v.HumanoidRootPart.Position
            end
            allid = allid + 1
        end
    end
    if totalpos then
        return totalpos / allid
    end
end 
function TweenObject(TweenCFrame,obj,ts)
    if not ts then ts = 350 end
    local tween_s = game:service "TweenService"
    local info =
        TweenInfo.new(
        (TweenCFrame.Position -
            obj.Position).Magnitude /
            ts,
        Enum.EasingStyle.Linear
    )
    _G.TweenObject =
        tween_s:Create(
            obj,
        info,
        {CFrame = TweenCFrame}
    )
    _G.TweenObject:Play() 
end
function IsPlayerAlive(player)
    if not player then
        player = game.Players.LocalPlayer
    end

    -- Kiểm tra xem đối tượng player có tồn tại và là một người chơi hợp lệ không
    if not player or not player:IsA("Player") then
        return false -- Trả về false nếu không phải là người chơi
    end

    -- Kiểm tra trạng thái nhân vật của người chơi
    local character = player.Character or player:FindFirstChild('Character')
    if not character then
        return false -- Trả về false nếu không có nhân vật
    end

    -- Kiểm tra thanh máu của nhân vật (Humanoid)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        return false -- Trả về false nếu không có Humanoid hoặc máu bằng 0
    end

    -- Nếu tất cả các điều kiện trên đều thỏa mãn, người chơi còn sống
    return true 
end
function CheckPlayerAlive()
    local a2,b2 = pcall(function() return game:GetService("Players").LocalPlayer.Character.Humanoid.Health > 0 end)
    task.wait()
    if a2 then return b2 end 
end   
local FruitStocks = {}
for i,v in pairs(game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
    "GetFruits",
    game:GetService("Players").LocalPlayer.PlayerGui.Main.FruitShop:GetAttribute("Shop2")
)) do 
    if v.OnSale then 
        table.insert(FruitStocks,v.Name)
    end
end
function SnipeFruit(fruitsSnipes)
    if _G.ServerData['PlayerData'].DevilFruit == '' then 
        for i = #fruitsSnipes,1,1 do 
            local f = fruitsSnipes[i]
            if FruitStocks[f] then 
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("PurchaseRawFruit", f, game:GetService("Players").LocalPlayer.PlayerGui.Main.FruitShop:GetAttribute("Shop2"))
                return 
            end
        end  
    end
end   
function sortSwordsByRarity(swords)
    table.sort(swords, function(a, b)
        return a.Rarity > b.Rarity
    end) 
    return swords[1]
end

function getNextSwordToFarm()
    local Swords = {}
    for _, itemData in pairs(_G.ServerData["Inventory Items"]) do 
        if itemData.Type == 'Sword' and itemData.Mastery < itemData.MasteryRequirements.X then 
            table.insert(Swords, itemData)  -- Chèn đúng vào bảng Swords
        end 
    end
    if #Swords > 0 then 
        local NNN = sortSwordsByRarity(Swords) 
        return NNN,NNN.MasteryRequirements.X
    end
    Swords = {}
    for _, itemData in pairs(game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("getInventory")) do 
        if itemData.Type == 'Sword' and itemData.Mastery < 600 then 
            table.insert(Swords, itemData)  -- Chèn đúng vào bảng Swords
        end 
    end
    if #Swords > 0 then 
        local NNN = sortSwordsByRarity(Swords) 
        return NNN,600
    end
    return nil,0
end  

function checkFruit1MWS()
    for i,v in pairs(game.workspace:GetChildren()) do 
        if v.Name:find('Fruit') and getPriceFruit(ReturnFruitNameWithId(v)) >= 1000000 and getPriceFruit(ReturnFruitNameWithId(v)) < 2500000 then 
            return v 
        end 
    end
end
function checkFruit1M(in5)
    local function fruitsea3bp()
        local n3
        for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do 
            if v.Name:find('Fruit') and getPriceFruit(ReturnFruitNameWithId(v)) >= 1000000 and getPriceFruit(ReturnFruitNameWithId(v)) < 2500000 then 
                n3 = v 
            end 
        end 
        for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do 
            if v.Name:find('Fruit') and getPriceFruit(ReturnFruitNameWithId(v)) >= 1000000 and getPriceFruit(ReturnFruitNameWithId(v)) < 2500000 then 
                n3 = v 
            end 
        end 
        return n3 
    end 
    if fruitsea3bp() then return fruitsea3bp() end
    if in5 then  
        local FOUNDDF 
        local MaxValue = math.huge 
        for i,v in pairs(_G.ServerData["Inventory Items"]) do 
            if v.Value and (v.Value >= 1000000 and v.Value < 2500000 ) and v.Value < MaxValue then   
                MaxValue = v.Value 
                FOUNDDF = v.Name
            end
        end 
        if FOUNDDF then 
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadFruit", FOUNDDF) 
            wait(.5)
            if fruitsea3bp() then return fruitsea3bp() end
        end
    end 
end
function checkFruittoEat(fruitsSnipes,includedInventory)
    for i,v in pairs(fruitsSnipes) do 
        for index,Inst in _G.ServerData['PlayerBackpack'] do 
            if index:find('Fruit') and Inst then 
                if Inst:GetAttribute("OriginalName") and tostring(Inst:GetAttribute("OriginalName")) == v then 
                    return Inst 
                end
            end
        end
    end 
    if includedInventory then 
        for i,v in pairs(fruitsSnipes) do 
            if _G.ServerData["Inventory Items"][v] then 
                return true
            end
        end
    end
end 
function eatFruit(fruitsSnipes,includedInventory) 
    function l4432()
        for i,v in pairs(fruitsSnipes) do
            for Ind,Inst in _G.ServerData['PlayerBackpack'] do 
                if Ind:find('Fruit') and Inst then 
                    if Inst:GetAttribute("OriginalName") and tostring(Inst:GetAttribute("OriginalName")) == v then 
                        task.spawn(function()
                            Tweento(CFrame.new(game.Players.LocalPlayer.Character.PrimaryPart.CFrame.X,game.Players.LocalPlayer.Character.PrimaryPart.CFrame.Y +2000,game.Players.LocalPlayer.Character.PrimaryPart.CFrame.Z))
                        end)
                        repeat 
                            task.wait()
                            EquipWeaponName(Ind)
                        until game.Players.LocalPlayer.Character:FindFirstChild("EatRemote")
                        print('Eating Fruit')
                        game.Players.LocalPlayer.Character:FindFirstChild("EatRemote", true):InvokeServer()
                        _G.CurrentTask = ''
                        print('Changed Task.')
                    end
                end
            end
        end 
    end
    l4432()
    if includedInventory then 
        for i,v in pairs(fruitsSnipes) do 
            if _G.ServerData["Inventory Items"][v] then 
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadFruit", v) 
                l4432()
            end
        end
    end
end 
function Storef(v) 
    if _G.CurrentTask ~= 'Eat Fruit' and _G.CurrentTask ~= 'Auto Sea 3' then 
        return game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
            "StoreFruit",
            tostring(v:GetAttribute("OriginalName")),
            v
        )
    end
end 
function NearestMob(distanc)
    for i,v in game.workspace.Enemies:GetChildren() do 
        local vhum = v:FindFirstChildOfClass('Humanoid') or v:WaitForChild('Humanoid')
        if vhum and vhum.Parent and vhum.ClassName == 'Humanoid' and vhum.Health >= 0 and vhum.Parent.PrimaryPart and (vhum.Parent.PrimaryPart.Position-game.Players.LocalPlayer.Character.PrimaryPart.Position).Magnitude <= distanc then 
            return v 
        end
    end
end
function CheckMessage(v1)
    local v1 = tostring(v1)
    local RaidCheck = "Island #%d cleared!" 
    if v1:find('Earned') or v1:find('LEVEL') then 
        return false
    end
    if v1:find('Island') and v1:find('cleared') then 
        print("Found next island:",tonumber(string.match(v1,'%d'))+1)
        _G.NextRaidIslandId = tonumber(string.match(v1,'%d'))+1
        return false
    end 

    if v1:find('spotted') then  
        print('Pirate raid FOUND!')
        _G.PirateRaidTick = tick()
        return v1
    elseif v1:find('factory') then 
        return v1
    elseif v1 == "Loading..." then 
        print('Dimension Loading ⚠️⚠️⚠️|',v1,v1 == "Loading...")
        _G.DimensionLoading = true
    elseif v1:find('Good job') then 
        print('Pirate raid Cancelled!')
        _G.PirateRaidTick = 0 
    elseif v1:find('attack') then 
        _G.AttackedSafe = true 
    elseif v1:find('rare item') then 
        _G.Config.FireEssencePassed = typeof(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyDragonTalon", true))~= 'string'  
    elseif v1:find('unleashed') then 
        _G.RaidBossEvent = true  
    elseif v1:find('barrier') then 
        _G.RaidBossEvent = true 
    elseif v1:find('dimension') then 
        _G.CakePrince = true 
    elseif v1:find('disappeared') then 
        _G.CakePrince = false
    elseif v1:find('legendary item') then  
        _G.HallowEssence = true
    elseif v1:find("entered this world") then 
        _G.SoulReaper = true
    else
        return false;
    end 
end
function LoadMessage(v)
    if v and not v:FindFirstChild('InstanceUsed') then 
        local InstanceUsed = Instance.new("IntValue",v)
        InstanceUsed.Name = 'InstanceUsed'
        v:GetPropertyChangedSignal('Value'):Connect(function()
            local mmb = CheckMessage(v.Value)
            if _G.CheckM5 and mmb and typeof(mmb) == 'string' then 
                _G.CheckM5(mmb)
            end 
        end) 
    end
end
localaaaabx = {}
local function LoadPlayer() 
    if not IsPlayerAlive() then repeat task.wait(.1) until IsPlayerAlive() end
    if IsPlayerAlive() then
        _G.ServerData["PlayerBackpackFruits"] = {}
        _G.ServerData["PlayerBackpack"] = {} 
        task.spawn(function()
            while not loadSkills do -- Wait until loadSkills is defined
                task.wait() 
            end
            task.wait(1) -- Wait for 1 second
            loadSkills()
        end)
        for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do  
            if v.ClassName =='StringValue' then 
                LoadMessage(v)
            end
            if not _G.ServerData["PlayerBackpack"][v.Name] then 
                _G.ServerData["PlayerBackpack"][v.Name] = v  
                if v.Name:find('Fruit') then  
                    if v.Name:find('Fruit') then  
                        if not Storef(v) then 
                            local nextid = #_G.ServerData["PlayerBackpackFruits"]
                            _G.ServerData["PlayerBackpackFruits"][nextid] = v 
                            v:GetPropertyChangedSignal('Parent'):Connect(function() 
                                if not v.Parent then _G.ServerData["PlayerBackpackFruits"][nextid]=nil end
                            end) 
                        end
                    end 
                end 
                task.spawn(function()
                    if v:IsA('Tool') and v.ToolTip == 'Melee' then 
                        repeat task.wait() until _G.Config and _G.Config['Melee Level Values'] _G.Config["Melee Level Values"][v.Name] = v:WaitForChild('Level').Value 
                    end
                end)
            end
        end 
        for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do 
            if not _G.ServerData["PlayerBackpack"][v.Name] then 
                _G.ServerData["PlayerBackpack"][v.Name] = v  
                if v.Name:find('Fruit') then  
                    if not Storef(v) then 
                        local nextid = #_G.ServerData["PlayerBackpackFruits"]
                        _G.ServerData["PlayerBackpackFruits"][nextid] = v 
                        v:GetPropertyChangedSignal('Parent'):Connect(function() 
                            if not v.Parent then _G.ServerData["PlayerBackpackFruits"][nextid]=nil end
                        end) 
                    end
                end 
                task.spawn(function()
                    if v:IsA('Tool') and v.ToolTip == 'Melee' then 
                        repeat task.wait() until _G.Config and _G.Config['Melee Level Values'] _G.Config["Melee Level Values"][v.Name] = v:WaitForChild('Level').Value 
                    end
                end)
                if v.ClassName == 'Tool' and table.find({'Sword','Blox Fruit',"Melee","Gun"},v.ToolTip) and not game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Skills:FindFirstChild(v.Name) then 
                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
                end
            end
        end  
        if not _G.ServerData['PlayerData'] then _G.ServerData['PlayerData'] = {} end
        for i,v in pairs(game.Players.LocalPlayer.Data:GetChildren()) do 
            if tostring(v.ClassName):find('Value') then 
                if not _G.ServerData['PlayerData'][v.Name] then 
                    _G.ServerData['PlayerData'][v.Name] = v.Value 
                    v:GetPropertyChangedSignal('Value'):Connect(function() 
                        _G.ServerData['PlayerData'][v.Name] = v.Value 
                    end)
                end
            end
        end  
        if not game.Players.LocalPlayer.Character:FindFirstChild("Teleport Access") then 
            if not game.Players.LocalPlayer.Character:FindFirstChild("Teleport Access") then
                local TweenAccess = Instance.new("IntValue")
                TweenAccess.Name = "Teleport Access"
                TweenAccess.Parent = game.Players.LocalPlayer.Character 
                game.Players.LocalPlayer.Backpack.ChildAdded:Connect(function(v)
                    _G.ServerData["PlayerBackpack"][v.Name] = v 
                    if v.Name == 'Holy Torch' then 
                        for i,v in game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("TushitaProgress").Torches do 
                            if not v then 
                                task.spawn(function()
                                    game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("TushitaProgress", "Torch", i)
                                end)
                            end
                        end
                    end
                    if v.Name == 'Flower 3' then 
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Alchemist", "3")
                    end
                    task.delay(0.75,function()
                        if v.Name == 'Red Key' then 
                            print('DOugh chip unlocked: ',game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CakeScientist", "Check"))
                        end
                        if v.Name:find('Fruit') then  
                            if not Storef(v) then 
                                local nextid = #_G.ServerData["PlayerBackpackFruits"]
                                _G.ServerData["PlayerBackpackFruits"][nextid] = v 
                                v:GetPropertyChangedSignal('Parent'):Connect(function() 
                                    if not v.Parent then _G.ServerData["PlayerBackpackFruits"][nextid]=nil end
                                end) 
                            end
                        end
                    end) 
                    task.spawn(function()
                        if v:IsA('Tool') and v.ToolTip == 'Melee' then 
                            repeat task.wait() until _G.Config and _G.Config['Melee Level Values'] _G.Config["Melee Level Values"][v.Name] = v:WaitForChild('Level').Value 
                        end
                    end)
                    for newids,v2 in pairs(_G.ServerData["PlayerBackpack"]) do 
                        
                        if not game.Players.LocalPlayer.Character:FindFirstChild(newids) and not game.Players.LocalPlayer.Backpack:FindFirstChild(newids) then 
                            _G.ServerData["PlayerBackpack"][newids] = nil 
         
                        end
                    end 

                end)
                game.Players.LocalPlayer.Character.ChildAdded:Connect(function(newchild) 
                    if newchild.ClassName =='StringValue' then 
                        LoadMessage(newchild)
                    end
                    if newchild.Name:find('Fruit') then  
                        if not Storef(newchild) then 
                            local nextid = #_G.ServerData["PlayerBackpackFruits"]
                            _G.ServerData["PlayerBackpackFruits"][nextid] = newchild 
                            newchild:GetPropertyChangedSignal('Parent'):Connect(function() 
                                if not newchild.Parent then _G.ServerData["PlayerBackpackFruits"][nextid]=nil end
                            end) 
                        end
                    end 
                end)
                game.Players.LocalPlayer.Character.PrimaryPart:GetPropertyChangedSignal("Position"):Connect(function()
                    _G.PlayerLastMoveTick = tick()
                end)
            end
            task.delay(3,function()
                for i,v in _G.ServerData['PlayerBackpack'] do 
                    if v.ClassName == 'Tool' and table.find({'Sword','Blox Fruit',"Melee","Gun"},v.ToolTip) and not game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Skills:FindFirstChild(v.Name) then 
                        game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
                    end
                end
            end)
        end
        
    end
end
function AddNoknockback(enemy)
    local humanoid = enemy.PrimaryPart or enemy:WaitForChild('HumanoidRootPart',3)
    if not humanoid then return end  -- Nếu enemy không có Humanoid, thoát hàm

    humanoid.ChildAdded:Connect(function(child)
        if child.ClassName == 'BodyVelocity' then 
            child.Velocity = Vector3.new(0, 0, 0)
            return
        end
        if child.ClassName == 'BodyVelocity' or child.ClassName == "BodyPosition" then
            child.MaxForce = Vector3.new(0, 0, 0)
            child.P = 0 
        elseif child.ClassName == "BodyGyro" then 
            child.P = 0 
            child.MaxTorque = Vector3.new(0, 0, 0) -- Sửa thành MaxTorque
        end
    end)
end 
task.spawn(function()
    wait(3)
    _G.Ticktp = tick() 
    getgenv().TushitaQuest = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("TushitaProgress")
    repeat task.wait(1) until CheckEnabling
    if game.PlaceId == 7449423635 and CheckEnabling and CheckEnabling('Tushita Hopping') and TushitaQuest and not TushitaQuest.OpenedDoor and _G.ServerData['PlayerData'].Level >= 2000 then 
        print('PRo')
        task.spawn(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/memaybeohub/NewPage/main/FinderServerLoading.lua'))()
            if AutoRipIndraHop then  
                for i = 1,120 do 
                    if game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("TushitaProgress") and game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("TushitaProgress").OpenedDoor then
                        break
                    end
                    if _G.Config.OwnedItems['Tushita'] then 
                        break
                    end
                    print('Finding Rip india sv...')
                    AutoRipIndraHop()
                    task.wait(1)
                end
                print('Didint found any rip indra server in 100s')
            else
                loadstring(game:HttpGet('https://raw.githubusercontent.com/memaybeohub/NewPage/main/FinderServerLoading.lua'))()
            end
        end)
    end
    for i2 = 1,3 do 
        if game.PlaceId == 7449423635 and CheckEnabling('Rip Indra Hopping') and not _G.Config.OwnedItems['Valkyrie Helm'] and not _G.ServerData['Server Bosses']['rip_indra True Form'] and _G.ServerData['PlayerData'].Level >= 2000 then 
            task.spawn(function()
                repeat 
                    task.wait()
                until not _G.ServerData['Server Bosses']['rip_indra True Form'] and _G.CurrentTask and _G.CurrentTask == ''
                loadstring(game:HttpGet('https://raw.githubusercontent.com/memaybeohub/NewPage/main/FinderServerLoading.lua'))()
                if AutoRipIndraHop then  
                    for i = 1,240 do 
                        repeat 
                            task.wait()
                        until _G.CurrentTask and _G.CurrentTask == ''
                        print('Finding Rip india sv...')
                        AutoRipIndraHop()
                        task.wait(1)
                    end
                    print('Didint found any rip indra server in 100s')
                else
                    loadstring(game:HttpGet('https://raw.githubusercontent.com/memaybeohub/NewPage/main/FinderServerLoading.lua'))()
                end
            end)
        end
    end
end)
task.spawn(function()
    wait(10)
    repeat task.wait(10) until CheckEnabling
    for i2 = 1,5 do 
        if game.PlaceId == 7449423635 and CheckEnabling('Mirage Hopping') and _G.ServerData['PlayerData'].RaceVer == "V3" and _G.Config.OwnedItems['Mirror Fractal'] and _G.Config.OwnedItems['Valkyrie Helm'] and (game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "Check") < 4 or (not game:GetService("Workspace").Map:FindFirstChild("MysticIsland") and not game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CheckTempleDoor"))) then 
            task.spawn(function()
                loadstring(game:HttpGet('https://raw.githubusercontent.com/memaybeohub/NewPage/main/FinderServerLoading.lua'))()
                if AutoMirageIslandHop then  
                    for i = 1,240 do 
                        print('Finding mirage sv')
                        AutoMirageIslandHop()
                        task.wait(.5)
                    end
                    print('Didint found any mirage server in 100s')
                else
                    loadstring(game:HttpGet('https://raw.githubusercontent.com/memaybeohub/NewPage/main/FinderServerLoading.lua'))()
                end
            end)
        end
        wait(10)
    end
end)
game.workspace.Characters.ChildAdded:Connect(LoadPlayer)
local tween_s = game:service "TweenService"
function Tweento(targetCFrame,dontmove)
    if CheckPlayerAlive() then
        if not game.Players.LocalPlayer.Character:FindFirstChild("Teleport Access") then
            return warn('I cant tween right now: Teleport Perm Missing')
        end
        if not TweenSpeed or type(TweenSpeed) ~= "number" then
            TweenSpeed = 325
        end
        if _G.SavedConfig and _G.SavedConfig["Tween Speed"] and typeof(_G.SavedConfig["Tween Speed"]) == 'number' then 
            TweenSpeed = _G.SavedConfig["Tween Speed"]
        end
        local targetPos = targetCFrame.Position
        local Distance =
            (targetPos -
            game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).Magnitude
        if Distance <= 300 and tick() - _G.Ticktp >= 0.01 then
            _G.Ticktp = tick()
            if not dontmove then 
                game.Players.LocalPlayer.Character:MoveTo(targetCFrame.Position)
                return
            else
                game.Players.LocalPlayer.Character.PrimaryPart.CFrame = CFrame.new(targetCFrame.Position)
            end
        end
        local bmg, bmg2 = CheckNearestTeleporter(targetCFrame)
        if bmg then
            local timetry = 0
            repeat
                pcall(
                    function()
                        _G.tween:Cancel()
                    end
                )
                wait()
                requestEntrance(bmg, bmg2)
                timetry = timetry + 1
            until not CheckNearestTeleporter(targetCFrame) or timetry >= 10
            if timetry >= 10 and CheckNearestTeleporter(targetCFrame) then
                if bmg2 == "Temple Of Time" then
                    table.insert(BlackListLocation, bmg2)
                end
                game.Players.LocalPlayer.Character.Humanoid.Health = 0
            end
        end
        task.spawn(function()
            if not _G.SavedConfig['Same Y Tween'] then return end
            if (game.Players.LocalPlayer.Character.PrimaryPart.CFrame.Y < targetCFrame.Y-1 or game.Players.LocalPlayer.Character.PrimaryPart.CFrame.Y > targetCFrame.Y+1)  then 
                if _G.tween then 
                    _G.tween:Cancel()
                    _G.tween = nil 
                end
                game.Players.LocalPlayer.Character.PrimaryPart.CFrame = CFrame.new(game.Players.LocalPlayer.Character.PrimaryPart.CFrame.X,(targetCFrame.Y > 20 and targetCFrame.Y or targetCFrame.Y+30),game.Players.LocalPlayer.Character.PrimaryPart.CFrame.Z)
            end
        end)
        local tweenfunc = {}
        local info =
            TweenInfo.new(
                (targetPos -
                game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).Magnitude /
                TweenSpeed,
            Enum.EasingStyle.Linear
        )
        _G.tween =
            tween_s:Create(
            game:GetService("Players").LocalPlayer.Character["HumanoidRootPart"],
            info,
            {CFrame = targetCFrame}
        )
        _G.tween:Play()
        function tweenfunc:Stop()
            _G.tween:Cancel()
        end
        _G.TweenStats = _G.tween.PlaybackState
        _G.tween.Completed:Wait()
        _G.TweenStats = _G.tween.PlaybackState
        return tweenfunc 
    end
end  
function GetCFrameADD(v2)
    task.wait()
    if game.Players.LocalPlayer.Character.Humanoid.Sit then 
        SendKey('Space',.5) 
    end
    return CFrame.new(0,40,0)
end 
local TweenK
local function TweenKill(v)
    if not CheckPlayerAlive() then return end
    if v and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then  
        local DISCC = GetDistance(v.HumanoidRootPart)
        if DISCC > 1000 then 
            Tweento(v.HumanoidRootPart.CFrame * GetCFrameADD())
        elseif DISCC > 3 then
            local tweenfunc = {}
            local tween_s = game:service "TweenService"
            local info =
                TweenInfo.new(
                GetDistance(v.HumanoidRootPart) /
                    300,
                Enum.EasingStyle.Linear
            )
            if GetDistance(v.HumanoidRootPart) < 200 then 
                if _G.tween then 
                    _G.tween:Cancel()
                    _G.tween = nil 
                end
                game.Players.LocalPlayer.Character:MoveTo((v.HumanoidRootPart.CFrame * GetCFrameADD()).Position)
            else 
                _G.tween =
                    tween_s:Create(
                    game:GetService("Players").LocalPlayer.Character["HumanoidRootPart"],
                    info,
                    {CFrame = v.HumanoidRootPart.CFrame * GetCFrameADD()}
                )
                _G.tween:Play() 
            end
        end
    end
    task.wait()
end
function IsBoss(nv,raidb)
    if typeof(nv) == "string" then 
        nv = CheckBoss(nv).Name
        if nv:find("Friend") then 
            return true 
        end
    end
    if nv then 
        local Bossb = raidb and "Raid Boss" or not raidb and "Boss"
        local a,b = pcall(function()
            if nv.Humanoid.DisplayName and string.find(nv.Humanoid.DisplayName,Bossb)  then 
                return true 
            end 
            return false
        end)
        if a then return b end
    end
end
function GetMidPointPart(tbpart)
    local pascal
    local allpas = 0
    for i, v in pairs(tbpart) do
        pcall(
            function()
                if not pascal then
                    pascal = v.Position
                else
                    pascal = pascal + v.Position
                end
                allpas = allpas + 1
            end
        )
    end
    return pascal / allpas
end
function EnableBuso()
    if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
        local args = {
            [1] = "Buso"
        }
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
    end
end  
function GetWeapon(wptype)
    local s 
    for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v:IsA("Tool") and v.ToolTip == wptype then
            s=v
        end
    end
    for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
        if v:IsA("Tool") and v.ToolTip == wptype then
            s = v
        end
    end
    return s
end 
function LoadItem(d)
    if _G.ServerData["PlayerBackpack"][d] then
        return
    end
    print('Loaditem',d)
    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadItem", d)
end 
function EquipWeapon(ToolSe)
    if _G.WeaponType == "" or _G.WeaponType == nil then
        _G.WeaponType = "Melee"
    end
    if not ToolSe then 
        if _G.CurrentTask ~='Getting Cursed Dual Katana' or _G.CDKQuest == 'Soul Reaper' then 
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(GetWeapon(_G.WeaponType))
        else
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(GetWeapon('Sword'))
        end
    else
        local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)
        game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
    end
end 
function AddBodyVelocity(enable)
    if not enable then  
        if game.Players.LocalPlayer.Character.Head:FindFirstChildOfClass("BodyVelocity") then 
            game.Players.LocalPlayer.Character.Head:FindFirstChildOfClass("BodyVelocity"):Destroy()
        end
        return
    end
    for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do 
        if v:IsA("BasePart") or v:IsA("Part") then 
            v.CanCollide = false 
        end
    end
    if not game.Players.LocalPlayer.Character.Head:FindFirstChild("NEWQL") then 
        local OV = Instance.new("BodyVelocity",game.Players.LocalPlayer.Character.Head)
        OV.Velocity = Vector3.new(0, 0, 0)
        OV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        OV.P = 15000
        OV.Name = "NEWQL"
    end
end
local Elites = {
    "Deandre",
    "Urban",
    "Diablo"
}
local KillingBoss
local KillingMobTick = tick()-10
local MobUsingSkill = false 
function CanMasteryFarm(v)
    if v and v.Humanoid and v.Humanoid.Health < (v.Humanoid.MaxHealth * 40/100) then 
        return true 
    end
end 
function CheckSkill(skillstable,blacklistedskills)
    if not blacklistedskills then 
        blacklistedskills = {}
    end 
    if skillstable['Z'] then 
        return "Z"
    elseif skillstable['X'] then 
        return "X"
    elseif skillstable["C"] then 
        return "C"
    end
end 
function addCheckSkill(v)
    if v:FindFirstChildOfClass('Humanoid') and v:FindFirstChildOfClass('Humanoid').MaxHealth < 500000 and GetDistance(v.PrimaryPart,CFrame.new(-5543.5327148438, 313.80062866211, -2964.2585449219)) > 1500 then
        local animator = v:FindFirstChildOfClass('Humanoid'):FindFirstChildOfClass('Animator')
        if animator then
            animator.AnimationPlayed:Connect(function(anitrack) 
                if anitrack.Animation.AnimationId ~= 'rbxassetid://9802959564' and anitrack.Animation.AnimationId ~= 'rbxassetid://507766388' and anitrack.Animation.AnimationId ~='http://www.roblox.com/asset/?id=9884584522' then  
                    local realTimePos = anitrack.TimePosition
                    if realTimePos <= 0 then 
                        realTimePos = 1.5
                    end
                    if _G.DogdeUntil and tick() < _G.DogdeUntil then  
                        _G.DogdeUntil = _G.DogdeUntil+math.floor(realTimePos)
                    else 
                        _G.DogdeUntil = tick()+math.floor(realTimePos)
                    end
                    if _G.tween then 
                        _G.tween:Cancel()
                        _G.tween = nil 
                    end
                    --game.Players.LocalPlayer.Character.PrimaryPart.CFrame = game.Players.LocalPlayer.Character.PrimaryPart.CFrame * CFrame.new(0,300,0)
                    warn('Dogde Skill Please sirrrr',anitrack.TimePosition,math.floor(realTimePos)+1,anitrack.Animation.AnimationId)
                end
            end)
        end
    end
end
getgenv().GetPing = function()
    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
    ping = ping:gsub("CV", "")
    ping = ping:gsub("%%d", "")
    ping = ping:gsub(" ", "")
    ping = ping:gsub("(%d%)", "")
    ping = ping:split("(")[1]
    return tonumber(ping)
end
function KillNigga(MobInstance) 
    local LS,LS2 = pcall(function()
        if IsPlayerAlive() and
        MobInstance and MobInstance:FindFirstChild("Humanoid") and
        MobInstance.Humanoid.Health > 0
        then
            local mmas = GetMidPoint(MobInstance.Name, MobInstance.HumanoidRootPart)
            local LockCFrame
            local KillingBoss
            if mmas and not string.find(MobInstance:FindFirstChildOfClass('Humanoid').DisplayName, "Boss") and MobInstance.Humanoid.MaxHealth < 130000 then
                LockCFrame = CFrame.new(mmas)
            else
                LockCFrame = MobInstance.HumanoidRootPart.CFrame
                KillingBoss = true
            end 
            local N_Name = MobInstance.Name
            SetContent('Killing '..tostring(N_Name))
            
            task.spawn(function()
                if not KillingBoss and CheckEnabling and (CheckEnabling('High Ping Hop') or CheckEnabling("Player Nearing Hop")) then 
                    if MobInstance.Humanoid.MaxHealth < 100000 and not _G.ServerData["PlayerBackpack"]['Sweet Chalice'] and not _G.ServerData["PlayerBackpack"]["God's Chalice"] and not _G.PirateRaidTick or tick()-_G.PirateRaidTick >= 90 then 
                        if CheckEnabling('High Ping Hop') and GetPing and GetPing() >= 1000 then 
                            print('High Ping')
                            wait(10)
                            if GetPing and GetPing() >= 650 then 
                                HopServer(10,true,'Ping is too high.')
                            end
                        end 
                        local bbxz 
                        if CheckEnabling("Player Nearing Hop") and Exploiters then 
                            for name__,v in Exploiters  do 
                                bbxz = workspace.Characters:FindFirstChild(name__)  
                                if bbxz then 
                                    if GetDistance(bbxz.PrimaryPart) < 500 then 
                                        HopServer(10,true,'Cheater nearing:'..tostring(bbxz.Name).." "..tostring(math.floor(GetDistance(bbxz.PrimaryPart))))
                                    end
                                end
                            end
                        else 
                            print(' not ',Exploiters)
                        end
                    end
                end
            end)
            local BringMobSuccess
            task.delay(7.5,function() 
                BringMobSuccess = true
            end)
            task.delay(.01 ,function()
                repeat task.wait() until MobInstance.PrimaryPart and GetDistance(MobInstance.PrimaryPart) < 150 
                addCheckSkill(MobInstance)
                wait()
                sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", 3000+300)
                if BringMob(MobInstance, LockCFrame) then 
                    task.wait(.275)
                    BringMobSuccess = true 
                else    
                    BringMobSuccess =true 
                end 
                if game.ReplicatedStorage.Remotes.CommF_:InvokeServer("KenTalk", "TeusHubt") == 0 then 
                    if not game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui:FindFirstChildOfClass("ImageLabel") then 
                        SendKey('E',.5)
                    end
                end
            end)             
            if _G.KillAuraConnection then 
                _G.KillAuraConnection:Disconnect()
                _G.KillAuraConnection = nil 
            end 
            local CurrentPlrHum = game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
            repeat
                if CurrentPlrHum and CurrentPlrHum.Health > 0 then 
                    if not (_G.ServerData["PlayerBackpack"]['Sweet Chalice'] or _G.ServerData["PlayerBackpack"]["God's Chalice"]) or ((_G.ServerData["PlayerBackpack"]['Sweet Chalice'] or _G.ServerData["PlayerBackpack"]["God's Chalice"]) and CurrentPlrHum.Health >(CurrentPlrHum.MaxHealth*31)/100) then
                        KillingMob = true
                        EquipWeapon()
                        TweenKill(MobInstance)  
                        if BringMobSuccess then 
                            MobInstance.Humanoid.AutoRotate = false
                            _G.UseFAttack = true 
                        end  
                    elseif (_G.ServerData["PlayerBackpack"]['Sweet Chalice'] or _G.ServerData["PlayerBackpack"]["God's Chalice"]) and CurrentPlrHum.Health <= (CurrentPlrHum.MaxHealth*30)/100 then 
                        local OldCFrame = game.Players.LocalPlayer.Character.PrimaryPart.CFrame
                        repeat 
                            task.wait()
                            _G.UseFAttack = false 
                            game.Players.LocalPlayer.Character.PrimaryPart.CFrame = CFrame.new(game.Players.LocalPlayer.Character.PrimaryPart.CFrame.X,math.random(1000,10000),game.Players.LocalPlayer.Character.PrimaryPart.CFrame.Z+30)
                        until not CurrentPlrHum or not CurrentPlrHum.Parent or CurrentPlrHum.Health >=(CurrentPlrHum.MaxHealth*70)/100 or not MobInstance or not MobInstance:FindFirstChildOfClass("Humanoid") or not MobInstance:FindFirstChild("HumanoidRootPart") or
                        MobInstance.Humanoid.Health <= 0 or not IsPlayerAlive()
                        Tweento(OldCFrame)
                    end
                else 
                    _G.UseFAttack = false
                    wait(1)
                    pcall(function()
                        CurrentPlrHum = game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
                    end)
                end 
                task.wait()
            until not MobInstance or not MobInstance:FindFirstChildOfClass("Humanoid") or not MobInstance:FindFirstChild("HumanoidRootPart") or
            MobInstance.Humanoid.Health <= 0
            SetContent('Kill success')
            KillingMob = false
            _G.UseFAttack = false  
        end
    end)
    if not LS then print('ls',LS2) end
end  
function CheckMob(mobormoblist,rep)
    if typeof(mobormoblist) == 'table' then 
        for i,v in pairs(mobormoblist) do 
            for __,v2 in pairs(game.workspace.Enemies:GetChildren()) do 
                if RemoveLevelTitle(v) == RemoveLevelTitle(v2.Name) and v2:FindFirstChild('Humanoid') and v2.Humanoid.Health > 0 then 
                    return v2
                end
            end
        end
        if rep then 
            for i,v in pairs(mobormoblist) do 
                for __,v2 in pairs(game.ReplicatedStorage:GetChildren()) do 
                    if RemoveLevelTitle(v) == RemoveLevelTitle(v2.Name) and v2:FindFirstChild('Humanoid') and v2.Humanoid.Health > 0 then 
                        return v2
                    end
                end
            end
        end
    else
        for i,v in pairs(game.workspace.Enemies:GetChildren()) do 
            if RemoveLevelTitle(v.Name) == RemoveLevelTitle(mobormoblist) and v:FindFirstChild('Humanoid') and v.Humanoid.Health > 0 then 
                return v
            end
        end
        if rep then 
            for i,v in pairs(game.ReplicatedStorage:GetChildren()) do 
                if RemoveLevelTitle(v.Name) == RemoveLevelTitle(mobormoblist) and v:FindFirstChild('Humanoid') and v.Humanoid.Health > 0 then 
                    return v
                end
            end
        end
    end
end
_G.MobFarest = {}
function getMobSpawnExtra()
    for i2,v2 in pairs(game.Workspace.MobSpawns:GetChildren()) do 
        if GetDistance(v2,MobSpawnClone[v2]) > 350 then 
            local indexg = 0
            if not _G.MobFarest[v2.Name] then 
                _G.MobFarest[v2.Name] = {} 
            else
                indexg = #_G.MobFarest[v2.Name]
            end
            local dist = GetDistance(_G.MobFarest[v2.Name][indexg],v2.CFrame)
            if indexg == 0 or (dist and dist > 350) then 
                table.insert(_G.MobFarest[v2.Name],v2.CFrame)
            end
        end 
    end
end 
task.spawn(getMobSpawnExtra)
function getMobSpawnbyList(MobList)
    local Returner = {}
    for i,v in pairs(MobList) do 
        if MobSpawnClone[v] then 
            table.insert(Returner,MobSpawnClone[v]) 
            if _G.MobFarest[v] and #_G.MobFarest[v] > 0 then 
                for i2,v2 in _G.MobFarest[v] do 
                    table.insert(Returner,v2) 
                end
            end
        end
    end
    return Returner  
end
function KillMobList(MobList)
    for i,v in pairs(MobList) do 
        MobList[i] = RemoveLevelTitle(v)
    end
    local NM = CheckMob(MobList)
    if NM then 
        KillNigga(NM)
    else
        local MS = getMobSpawnbyList(MobList) 
        if MS then 
            for i,v in pairs(MS) do 
                local isV = CheckMob(MobList)
                if not isV and v then 
                    SetContent('Waiting mobs...')
                    Tweento(v * CFrame.new(0,50,0))
                    wait(1)
                elseif isV then 
                    break
                end
            end
        end
    end
end
function KillBoss(BossInstance)
    if not BossInstance or not BossInstance:FindFirstChildOfClass('Humanoid') or BossInstance:FindFirstChildOfClass('Humanoid').Health <= 0 then
        task.wait(.1)
        return 
    end 
    warn('Killing boss:',BossInstance.Name)
    if not game.Workspace.Enemies:FindFirstChild(BossInstance.Name) then  
        SetContent('Moving to '..BossInstance.Name)
        Tweento(BossInstance.PrimaryPart.CFrame * CFrame.new(0,50,0))
    end
    KillNigga(BossInstance)
end
function BringMob(TAR,V5)
    if not TAR then 
        return
    end
    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", 3000+300)
    if not TAR:FindFirstChild("Bringed") then 
        local Bringed = Instance.new("IntValue",TAR)
        Bringed.Name = "Bringed" 
    else
        return
    end
    V6 = V5 or TAR.HumanoidRootPart.CFrame
    for i, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == TAR.Name and v.PrimaryPart and
                (V6.Position - v.HumanoidRootPart.Position).Magnitude < 340 and
                (isnetworkowner(v.HumanoidRootPart)) and
                v:FindFirstChildOfClass('Humanoid').MaxHealth < 100000
        then
            v.PrimaryPart.CanCollide = false
            v.Head.CanCollide = false
            v.Humanoid.WalkSpeed = 0
            v.Humanoid.JumpPower = 0 
            v.Humanoid.AutoRotate = false 
            v:MoveTo(V6.Position)
        end
    end 
    return true
end  
function GetNearestPlayer(pos)
    local ner = math.huge
    local ner2
    for i, v in pairs(game.Players:GetChildren()) do
        if
            v.Character and v.Character.PrimaryPart and
                (v.Character.PrimaryPart.Position - pos).Magnitude < ner
         then
            ner = (v.Character.PrimaryPart.Position - pos).Magnitude 
            ner2 = v.Name
        end
    end
    if game.Players.LocalPlayer.Name == ner2 then
        return true
    end
end
if not isnetworkowner or identifyexecutor() == 'Delta' then 
    function isnetworkowner2(p1)
        local A = gethiddenproperty(game.Players.LocalPlayer, "SimulationRadius")
        local B = game.Players.LocalPlayer.Character or Wait(game.Players.LocalPlayer.CharacterAdded)
        local C = game.WaitForChild(B, "HumanoidRootPart", 300)
        if C then
            if p1.Anchored then
                return false
            end
            if game.IsDescendantOf(p1, B) or (C.Position - p1.Position).Magnitude <= A and GetNearestPlayer(p1.Position) then
                return true
            end
        end
    end  
    isnetworkowner = function(part)
        if isnetworkowner2(part) then
            return isnetworkowner2(part)
        end
        return part.ReceiveAge == 0 and GetNearestPlayer(part.Position)
    end
else
    isnetworkowner2 = isnetworkowner
    warn("already isnetworkowner 😎😎😎") -- bruh
end
function Click()
    local VirtualUser = game:GetService("VirtualUser")
    VirtualUser:CaptureController()
    VirtualUser:ClickButton1(Vector2.new(851, 158), game:GetService("Workspace").Camera.CFrame)
end
local cancelKill = false  
_G.AttackedSafe = false 
function CancelKillPlayer()
    cancelKill = true 
end 
function CheckSafeZone(p)
    --[[
        for i, v in pairs(game:GetService("Workspace")["_WorldOrigin"].SafeZones:GetChildren()) do
        if v:IsA("Part") then
            if
                GetDistance(v,p.PrimaryPart) <= 200 and
                    p.Humanoid.Health / p.Humanoid.MaxHealth >= 90 / 100
             then
                return true
            end
        end
    end
    ]]
    if _G.AttackedSafe then 
        _G.AttackedSafe = false 
        return true 
    end
end
function KillPlayer(PlayerName)
    warn('KillPlayer',PlayerName) 
    SetContent('TeusHubt killing '..tostring(PlayerName))
    local t = game:GetService("Workspace").Characters:FindFirstChild(PlayerName)
    local tRoot = t.PrimaryPart or t:FindFirstChild('HumanoidRootPart')
    local tHumanoid = t:FindFirstChild('Humanoid')
    local getNeartick = tick()-5555
    local totRoot = GetDistance(tRoot)
    local TeusHubtKillTick = tick()
    local IsSafeZone = false
    repeat 
        task.wait()
        if IsPlayerAlive() then
            EquipWeapon() 
            IsSafeZone = CheckSafeZone(t)
            if game.Players.LocalPlayer.PlayerGui.Main.PvpDisabled.Visible then 
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("EnablePvp")
            end
            totRoot = GetDistance(tRoot)
            game.Players.LocalPlayer.Character.PrimaryPart.CFrame = CFrame.new(game.Players.LocalPlayer.Character.PrimaryPart.CFrame.X,tRoot.CFrame.Y,game.Players.LocalPlayer.Character.PrimaryPart.CFrame.Z)
            if totRoot < 50 then 
                if tick()-getNeartick > 100 then 
                    getNeartick = tick()
                    repeat  
                        SetContent('Bypassing Anti-Killing')
                        task.wait()
                        game.Players.LocalPlayer.Character.PrimaryPart.CFrame = tRoot.CFrame * CFrame.new(0,100,10)
                        _G.UseFAttack = false
                    until tick()-getNeartick > 1 and tick()-getNeartick < 100
                    game.Players.LocalPlayer.Character.PrimaryPart.CFrame = tRoot.CFrame * CFrame.new(0,0,10)
                elseif tick()-getNeartick > 1 and tick()-getNeartick < 100 then 
                    KillingMob = true
                    EquipWeapon() 
                    FastMob = false
                    if t:FindFirstChildOfClass('Tool') and t:FindFirstChildOfClass('Tool'):FindFirstChild('Holding') and t:FindFirstChildOfClass('Tool'):FindFirstChild('Holding').Value then 
                        SetContent(PlayerName..' holding skill...')
                        game.Players.LocalPlayer.Character.PrimaryPart.CFrame = tRoot.CFrame * CFrame.new(0,50,15)
                        SendKey('Z')
                        SendKey('X')
                        
                    else
                        task.spawn(function()
                            game.Players.LocalPlayer.Character.PrimaryPart.CFrame = tRoot.CFrame * CFrame.new(0,2,2.5)
                            getgenv().AimPos = tRoot.CFrame
                        end)
                        task.spawn(function()
                            for i,v in game.workspace.Enemies:GetChildren() do v.Humanoid.Health = 0 end
                        end)
                        Click()
                        _G.UseFAttack = true
                        SendKey('Z')
                        SendKey('X')
                    end
                end
            else
                Tweento(tRoot.CFrame * CFrame.new(0,30,0))
            end 
        else
            getNeartick = tick()-5555
        end
    until cancelKill or IsSafeZone or CheckSafeZone(t) or tick()-TeusHubtKillTick > 80 or not t or not t.Parent or not game:GetService("Workspace").Characters:FindFirstChild(PlayerName) or not tRoot or not tRoot.Parent or not tHumanoid or tHumanoid.Health <= 0 
    cancelKill = false 
    KillingMob = false
    getgenv().AimPos = nil
    TeusHubtKillTick = tick()
    _G.UseFAttack = false
    if IsSafeZone or tick()-TeusHubtKillTick > 80 then 
        warn('Kill Failed:',PlayerName) 
        SetContent('Kill Failed: '..tostring(PlayerName))
        return false 
    else 
        warn('Kill Success:',PlayerName) 
        SetContent('Kill Success: '..tostring(PlayerName))
        return true 
    end
end 
function getNearestRaidIsland()
    local function GetI(vId)  
        local Nears = math.huge 
        local ChildSet 
        for i,v in pairs(game:GetService("Workspace")["_WorldOrigin"].Locations:GetChildren()) do
            if v.Name == 'Island '..vId and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-v.Position).Magnitude <= 4500 then 
                ChildSet = v 
                Nears = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-v.Position).Magnitude 
            end 
        end 
        return ChildSet
    end 
    if _G.NextRaidIslandId then
        return GetI(_G.NextRaidIslandId)
    end 
    local nextg
    for i = 5,1,-1 do   
        nextg = GetI(i)          
        if nextg then
            return nextg 
        end 
    end
end 
function CheckIsRaiding() 
    return _G.ServerData['Nearest Raid Island'] and _G.ServerData['Nearest Raid Island'].Parent
end
local lplr = game.Players.LocalPlayer
function FlyBoat(e,b,h)
    if not b then return end 
    if not h then h = 200 end 
    local fakevh = b.Engine
    local vh = b:FindFirstChildOfClass('VehicleSeat')
    if e then 
        vh.Name = 'L'
        local bodyV = vh:WaitForChild('BodyVelocity',.1)
        if bodyV then 
            bodyV.Parent = fakevh 
        end
        local bodyP = vh:WaitForChild('BodyPosition')
        bodyP.Position = Vector3.new(0,h,0)
        vh:GetPropertyChangedSignal('Position'):Connect(function()
            bodyP.Position = Vector3.new(0,h,0)
        end)
    else 
        local bodyV = fakevh:WaitForChild('BodyVelocity',.1)
        if bodyV then 
            bodyV.Parent = vh 
        end
        vh.Name = 'VehicleSeat'
        local bodyP = vh:WaitForChild('BodyPosition')
        bodyP.Position = Vector3.new(0,b.WaterOrigin.Value ,0)
    end
end

function EquipWeaponName(fff)
    if not fff then
        return
    end
    NoClip = true
    local ToolSe = fff
    if game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe) then
        local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)
        wait(.4)
        game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
    end
end
function IsWpSKillLoaded(ki)
    if game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Skills:FindFirstChild(ki) then
        return true
    end
end
function EquipAllWeapon()
    print('EquipAllWeapon')
    local u3 = {
        "Melee",
        "Blox Fruit",
        "Sword",
        "Gun"
    }
    local u3_2 = {}
    for i, v in pairs(u3) do
        u3_3 = GetWeapon(v)
        if u3_3 and u3_3 ~= "" then table.insert(u3_2, u3_3) end
    end
    for i, v in pairs(u3_2) do
        if not IsWpSKillLoaded(v) then
            EquipWeaponName(v)
        end
    end
end
wait()
local GuideModule = require(game:GetService("ReplicatedStorage").GuideModule)
local Quest = require(game:GetService("ReplicatedStorage").Quests) 
local v17 = require(game.ReplicatedStorage:WaitForChild("GuideModule"))
local CFrameByLevelQuest = {} 
local UselessQuest = {
    "BartiloQuest",
    "Trainees",
    "MarineQuest",
    "CitizenQuest"
}
for i,v in pairs(GuideModule["Data"].NPCList) do
	for i1,v1 in pairs(v["Levels"]) do
		CFrameByLevelQuest[v1] = i.CFrame
        if v1 == 0 then 
            CFrameByLevelQuest[v1] = CFrame.new(1059.37195, 15.4495068, 1550.4231, 0.939700544, -0, -0.341998369, 0, 1, -0, 0.341998369, 0, 0.939700544)
        end 
	end
end
function IsHavingQuest()
    for i, v in next, v17.Data do
        if i == "QuestData" then
            return true
        end
    end
    return false
end 
function CheckCurrentQuestMob()
    local a
    if IsHavingQuest() then
        for i, v in next, v17.Data.QuestData.Task do
            a = i
        end
    end
    return a
end
function CheckQuestByLevel(cq)
    local cq = cq or {} 
    local lvlPl = cq.Level or game.Players.LocalPlayer.Data.Level.Value 
    local LevelMaxReq = 99999
    local DoubleQuest = cq.DoubleQuest or false 
    local Returner = {
        ["LevelReq"] = 0,
        ["Mob"] = "",
        ["QuestName"] = "",
        ["QuestId"] = 0,
    }
    if game.PlaceId == 2753915549 then 
        LevelMaxReq = 699
    elseif game.PlaceId ==4442272183 then 
        LevelMaxReq = 1475
    end
    for i, v in pairs(Quest) do
        for i1, v1 in pairs(v) do
            local lvlreq = v1.LevelReq
            for i2, v2 in pairs(v1.Task) do
                if
                    lvlPl >= lvlreq and lvlreq >= Returner["LevelReq"] and lvlreq <= LevelMaxReq and v1.Task[i2] > 1 and
                        not table.find(UselessQuest, tostring(i))
                then
                    Returner["LevelReq"] = lvlreq 
                    Returner["Mob"] = tostring(i2) 
                    Returner["QuestName"] = i 
                    Returner["QuestId"] = i1
                end
            end
        end
    end
    if DoubleQuest and IsHavingQuest() then 
        local CurrentMob = Returner["Mob"]
        if
        lvlPl >= 10 and IsHavingQuest() and
            CheckCurrentQuestMob() == Returner["Mob"]
        then
            for i, v in pairs(Quest) do
                for i1, v1 in pairs(v) do
                    for i2, v2 in pairs(v1.Task) do
                        if tostring(i2) == tostring(CurrentMob) then
                            for quest1, quest2 in next, v do
                                for quest3, quest4 in next, quest2.Task do
                                    if tostring(quest3) ~= tostring(CurrentMob) and quest4 > 1 then
                                        if quest2.LevelReq <= lvlPl then
                                            Returner["Mob"]  = tostring(quest3)
                                            Returner["QuestName"]  = i
                                            Returner["QuestId"] = quest1 
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    Returner["QuestCFrame"] = CFrameByLevelQuest[Returner["LevelReq"]]
    return Returner
end
local function TweenKillInstant(POS) 
    local tweenfunc = {}
    local tween_s = game:service "TweenService"
    local info =
        TweenInfo.new(
        GetDistance(POS) /
            300,
        Enum.EasingStyle.Linear
    )
    if GetDistance(POS) < 200 then 
        if _G.tween then 
            _G.tween:Cancel()
            _G.tween = nil 
        end
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = POS 
    else 
        _G.tween =
            tween_s:Create(
            game:GetService("Players").LocalPlayer.Character["HumanoidRootPart"],
            info,
            {CFrame = POS}
        )
        _G.tween:Play() 
    end
end
function GetQuest(QuestTables) 
    if game.Players.LocalPlayer.PlayerGui.Main:FindFirstChild("Quest").Visible then
        return
    end 
    SetContent('Getting quest...')
    if not QuestTables or not QuestTables["Mob"] or not QuestTables["QuestName"] or not QuestTables["LevelReq"] or not QuestTables["QuestId"] or not QuestTables["QuestCFrame"] then 
        QuestTables = CheckQuestByLevel()
    end
    if QuestTables.QuestCFrame and GetDistance(QuestTables.QuestCFrame) <= 8 then  
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("TeusHubtQuest", tostring(QuestTables["QuestName"]), QuestTables["QuestId"])
        task.wait(.75)
    else
        if GetDistance(QuestTables["QuestCFrame"] * CFrame.new(0,0,-2)) < 1000 then 
            TweenKillInstant(QuestTables["QuestCFrame"] * CFrame.new(0,0,-2))
        else 
            Tweento(QuestTables["QuestCFrame"] * CFrame.new(0,0,-2))
        end
        task.wait(1) 
        GetQuest(QuestTables)
    end
end    
local AllNPCS = getnilinstances()
for i, v in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
    table.insert(AllNPCS, v)
end
function GetNPC(npc)
    for i, v in pairs(AllNPCS) do
        if v.Name == npc then
            return v
        end
    end
end  
local function FireAddPoint(PointName,num) 
    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint",PointName,num)
end
function autoStats() 
    if IsPlayerAlive() and game:GetService("Players").LocalPlayer.Data.Points.Value > 0 then
        local MaxLevel = 2550 
        local Stats_Melee = game:GetService("Players").LocalPlayer.Data.Stats.Melee.Level.Value  
        local Stats_Def = game:GetService("Players").LocalPlayer.Data.Stats['Defense'].Level.Value
        local Stats_DF = game:GetService("Players").LocalPlayer.Data.Stats["Demon Fruit"].Level.Value 
        local Stats_Gun = game:GetService("Players").LocalPlayer.Data.Stats.Gun.Level.Value 
        local Stats_Sword = game:GetService("Players").LocalPlayer.Data.Stats.Sword.Level.Value   
        if Stats_Melee < MaxLevel then 
            FireAddPoint('Melee',MaxLevel-Stats_Melee)
            autoStats()
        elseif Stats_Def < 2600 then 
            FireAddPoint('Defense',MaxLevel-Stats_Def)
            autoStats()
        else 
            FireAddPoint('Sword',MaxLevel-Stats_Sword)
            autoStats()
        end
    end
end
function PushData(tab,newdata)
    for i = 1, #tab - 1 do
        tab[i] = tab[i + 1]  -- Gán giá trị ở vị trí i + 1 vào vị trí i
    end

    tab[#tab] = newdata -- Xóa phần tử cuối cùng (hoặc gán giá trị mới nếu cần)
    return tab
end
function FarmMobByLevel(level)
    if not level then  
        level = game.Players.LocalPlayer.Data.Level.Value 
    end 
    if Sea1 and level >= 700 then  
        level = 650 
        if game.ReplicatedStorage.Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Dressrosa") == 0 then 
            TeleportWorld(2)
        end
    elseif Sea2 and level >= 1500 then  
        level = 1450
        if game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ZQuestProgress", "Zou") == 0 then 
            TeleportWorld(3)
        end
         
    end
    if _G.KillAuraConnection then 
        _G.KillAuraConnection:Disconnect()
        _G.KillAuraConnection = nil 
    end
    local CurrentQuestMob = CheckCurrentQuestMob()
    if level <= game.Players.LocalPlayer.Data.Level.Value and not game.Players.LocalPlayer.PlayerGui.Main:FindFirstChild("Quest").Visible then 
        local NewQuest = CheckQuestByLevel({
            Level = level,
            DoubleQuest = true 
        }) 
        GetQuest(NewQuest)
    elseif CheckMob(CurrentQuestMob) then 
        KillNigga(CheckMob(CurrentQuestMob))
    elseif _G.MobSpawnClone and _G.MobSpawnClone[CurrentQuestMob] then 
        SetContent('Waiting mob... | '..tostring(CurrentQuestMob))
        Tweento(_G.MobSpawnClone[CurrentQuestMob] * CFrame.new(0,60,0))
        for i,v in next,(game.workspace.MobSpawns:GetChildren()) do 
            if v.Name == CurrentQuestMob and GetDistance(v,_G.MobSpawnClone[CurrentQuestMob]) > 350 and not CheckMob(CurrentQuestMob) then  
                Tweento(v.CFrame* CFrame.new(0,30,0))
            end
        end
    end
end
task.spawn(function()
    getgenv().FruitsID = loadstring(game:HttpGet("https://raw.githubusercontent.com/memaybeohub/NewPage/main/Magnetism.lua"))()
end)
function ReturnFruitNameWithId(v) 
    if not v then return end 
    local SH = v:WaitForChild("Fruit",15):WaitForChild("Fruit",1)
    if not SH then 
        SH = v:WaitForChild("Fruit",15):WaitForChild("Retopo_Cube.001",1) 
    end
    for i,v in pairs(FruitsID) do 
        if v == SH.MeshId then 
            return i 
        end
    end   
    return v.Name
end
local function mmb(v)  
    local OC = tostring(v):split('-')
    if #OC >= 3 then 
        local OC2 = {} 
        for i,v in pairs(OC) do 
            table.insert(OC2,v)
            if #OC2 >= #OC/2 then break end 
        end
        return tostring(unpack(OC2))
    else
        print(OC[1])
        return tostring(OC[1])
    end
end
function ReturnToShowFruit(v)
    local OC = ReturnFruitNameWithId(v):split('-')
    if #OC >= 3 then 
        local OC2 = {} 
        for i,v in pairs(OC) do 
            table.insert(OC2,v)
            if #OC2 >= #OC/2 then break end 
        end
        return unpack(OC2)
    else
        return OC[1]
    end
end
function CheckNatural(v)
    return v and not v:GetAttribute("OriginalName")
end
function getPriceFruit(z5)
    for i,v in pairs(game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
        "GetFruits",
        game:GetService("Players").LocalPlayer.PlayerGui.Main.FruitShop:GetAttribute("Shop2")
    )) do 
        if v.Name == z5 then 
            return v.Price 
        end
    end
    return 0 
end
function getRealFruit(v)
    local kf = CheckNatural(v) and " (Spawned)" or ""
    return ReturnFruitNameWithId(v) .. " ("..tostring(getPriceFruit(ReturnFruitNameWithId(v))).."$) ".. tostring(kf)
end 
function SendKey(key, holdtime,mmb)
    if key and (not mmb or (mmb)) then
        if not holdtime then
            game:service("VirtualInputManager"):SendKeyEvent(true, key, false, game)
            task.wait()
            game:service("VirtualInputManager"):SendKeyEvent(false, key, false, game)
        elseif holdtime then
            game:service("VirtualInputManager"):SendKeyEvent(true, key, false, game)
            task.wait(holdtime)
            game:service("VirtualInputManager"):SendKeyEvent(false, key, false, game)
        end
    end
end
function collectAllFruit_Store()
    if _G.ServerData['Workspace Fruits'] then 
        for i,v in pairs(_G.ServerData['Workspace Fruits']) do 
            if v and not _G.ServerData['Inventory Items'][ReturnFruitNameWithId(v)] then 
                SetContent('Picking up '..getRealFruit(v))
                Tweento(v.Handle.CFrame)
                task.wait(.1) 
                task.delay(3,function()
                    if _G.CurrentTask == 'Collect Fruit' then 
                        _G.CurrentTask = ''
                    end
                end)
            elseif _G.ServerData['Inventory Items'][ReturnFruitNameWithId(v)] then 
                _G.ServerData['Workspace Fruits'][i] = nil
            end
        end
    end
end 
_G.CurrentElite = false
function LoadBoss(v)  
    if not v or v.ClassName ~= 'Model' then return end
    local CastleCFrame = CFrame.new(-5543.5327148438, 313.80062866211, -2964.2585449219)
    local Root = v.PrimaryPart or v:WaitForChild('HumanoidRootPart',3)
    local Hum = v:WaitForChild('Humanoid',3)
    local IsElite = table.find(Elites,RemoveLevelTitle(v.Name))
    task.spawn(function()
        if Hum and Root and v:FindFirstChildOfClass('Humanoid') and v.Humanoid.Health > 0 and (v.Humanoid.DisplayName:find('Boss') or RemoveLevelTitle(v.Name) == 'Core' or IsElite) and not _G.ServerData['Server Bosses'][v.Name] then 
            if not IsElite then 
                _G.ServerData['Server Bosses'][v.Name] = v  
            end
        else
            return
        end 
    end)
    task.spawn(function()
        AddNoknockback(v)
        if Sea3 and Hum and Root and v:FindFirstChildOfClass('Humanoid') and v:FindFirstChildOfClass('Humanoid').Health > 0 and GetDistance(v.PrimaryPart,CastleCFrame) <= 1500 and (RemoveLevelTitle(v.Name) ~='rip_indra True Form' and not v.Name:find('Friend') and not v.Name:find("Player")) then  
            _G.PirateRaidTick = tick() 
        end
    end)
    task.spawn(function()
        if RemoveLevelTitle(v.Name) == 'rip_indra True Form' then 
            getgenv().TushitaQuest = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("TushitaProgress");
            repeat task.wait() until _G.ServerData['PlayerData'] and _G.ServerData['PlayerData'].Level
            if TushitaQuest and not TushitaQuest.OpenedDoor then 
                repeat 
                    game.Players.LocalPlayer.Character.PrimaryPart.CFrame = game:GetService("Workspace").Map.Waterfall.SecretRoom.Room.Door.Door.Hitbox.CFrame
                    task.wait()
                until game.Players.LocalPlayer.Backpack:FindFirstChild('Holy Torch') or not v or not v.Parent or not v.Humanoid or v.Humanoid.Health <= 0 or _G.ServerData['PlayerData'].Level < 2000
                game.Players.LocalPlayer.Character.PrimaryPart.Anchored= false
                task.spawn(function()
                    for i,v in game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("TushitaProgress").Torches do 
                        if not v then 
                            task.spawn(function()
                                game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("TushitaProgress", "Torch", i)
                            end)
                        end
                    end
                end)
            end
            if _G.ServerData['PlayerData'].Level >= 2000 and not _G.ServerData["Inventory Items"]["Tushita"] then 
                _G.CurrentTask = 'Getting Tushita'
            end
        end
    end)
    if table.find(Elites,RemoveLevelTitle(v.Name)) then 
        print("Found elite:",tostring(v.Name))
        _G.CurrentElite = v 
    end 
    if Hum then 
        v.Humanoid:GetPropertyChangedSignal('Health'):Connect(function()
            if v.Humanoid.Health <= 0 and IsElite or _G.ServerData['Server Bosses'][v.Name] then  
                print('Removing boss:',v.Name)
                if _G.CurrentElite == v then 
                    _G.CurrentElite = nil 
                end
                if table.find(Elites,RemoveLevelTitle(v.Name)) then 
                    _G.CurrentElite = nil
                end
                local index = _G.ServerData['Server Bosses'][v.Name]
                if index then
                    _G.ServerData['Server Bosses'][v.Name] = nil
                end            
            end
        end)
    end
end  
function TeleportWorld(world)
    if typeof(world) == "string" then
        world = world:gsub(" ", ""):gsub("Sea", "")
        world = tonumber(world)
    end
    if world == 1 then
        local args = {
            [1] = "TravelMain"
        }
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
    elseif world == 2 then
        local args = {
            [1] = "TravelDressrosa"
        }
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
    elseif world == 3 then
        local args = {
            [1] = "TravelZou"
        }
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
    end
end
_G.ServerData["Inventory Items"] = {}
_G.ServerData['Skill Loaded'] = {}
_G.ServerData['Workspace Fruits'] = {}
_G.ServerData['Server Bosses'] = {}
_G.ServerData["PlayerBackpack"] = {}
for i,v in pairs(game.workspace.Enemies:GetChildren()) do 
    task.spawn(LoadBoss,v)
end
for i,v in pairs(game.ReplicatedStorage:GetChildren()) do 
    task.spawn(LoadBoss,v)
end 
function CheckRaceVer()
    local v113 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "1")
    local v111 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Alchemist", "1")
    if game.Players.LocalPlayer.Character:FindFirstChild("RaceTransformed") then
        return "V4"
    end
    if v113 == -2 then
        return "V3"
    end
    if v111 == -2 then
        return "V2"
    end
    return "V1"
end 
workspace.Enemies.ChildAdded:Connect(LoadBoss)
game.ReplicatedStorage.ChildAdded:Connect(LoadBoss) 
local FreeFallTime = {}
getgenv().Exploiters = {}
function checkExploiting(playerInstance)
    if not playerInstance or playerInstance.Name == game.Players.LocalPlayer.Character.Name then return end 
    local humanoid = playerInstance.Character and playerInstance.Character:WaitForChild("Humanoid")
    if humanoid and humanoid:GetState() == Enum.HumanoidStateType.Freefall then            
        if not FreeFallTime[playerInstance.Name] then 
            FreeFallTime[playerInstance.Name] = tick()
            repeat
                task.wait()
            until humanoid:GetState() ~= Enum.HumanoidStateType.Freefall or tick()-FreeFallTime[playerInstance.Name] >= 20 
            if tick()-FreeFallTime[playerInstance.Name] >= 20 then 
                Exploiters[playerInstance.Name] = true 
            end
        end 
    elseif FreeFallTime[playerInstance.Name] then 
        if tick()-FreeFallTime[playerInstance.Name] > 20 then 
            Exploiters[playerInstance.Name] = true 
        end
    end
    if humanoid then 
        humanoid.StateChanged:Connect(function(_oldState, newState)
            if humanoid:GetState() == Enum.HumanoidStateType.Freefall then            
                if not FreeFallTime[playerInstance.Name] then 
                    FreeFallTime[playerInstance.Name] = tick()
                end 
            elseif FreeFallTime[playerInstance.Name] then 
                if tick()-FreeFallTime[playerInstance.Name] > 20 then 
                    Exploiters[playerInstance.Name] = true 
                    FreeFallTime[playerInstance.Name] = nil
                else
                    FreeFallTime[playerInstance.Name] = tick()
                end
            end
        end)  
    end  
end
for i,v in game.Players:GetChildren() do 
    task.spawn(checkExploiting,v)
end
game.Players.ChildAdded:Connect(checkExploiting)
local Melee_and_Price = {
    ["Black Leg"] = {Beli = 150000, Fragment = 0},
    ["Fishman Karate"] = {Beli = 750000, Fragment = 0},
    ["Electro"] = {Beli = 500000, Fragment = 0},
    ["Dragon Claw"] = {Beli = 0, Fragment = 1500},
    ["Superhuman"] = {Beli = 3000000, Fragment = 0},
    ["Sharkman Karate"] = {Beli = 2500000, Fragment = 5000},
    ["Death Step"] = {Beli = 2500000, Fragment = 5000},
    ["Dragon Talon"] = {Beli = 3000000, Fragment = 5000},
    ["Godhuman"] = {Beli = 5000000, Fragment = 5000},
    ["Electric Claw"] = {Beli = 3000000, Fragment = 5000},
    ["Sanguine Art"] = {Beli = 5000000, Fragment = 5000},
}
local Melee_and_RemoteBuy = {
    ["Black Leg"] = "BuyBlackLeg",
    ["Fishman Karate"] = "BuyFishmanKarate",
    ["Electro"] = "BuyElectro",
    ["Dragon Claw"] = function()
        local OwnDragonClaw = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "1") == 1
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "2")
        return OwnDragonClaw
    end,
    ["Superhuman"] = "BuySuperhuman",
    ["Sharkman Karate"] = "BuySharkmanKarate",
    ["Death Step"] = "BuyDeathStep",
    ["Dragon Talon"] = "BuyDragonTalon",
    ["Godhuman"] = "BuyGodhuman",
    ["Electric Claw"] = "BuyElectricClaw",
    ["Sanguine Art"] = "BuySanguineArt"
} 
local Melee_in_game = {}
for i,v in pairs(Melee_and_RemoteBuy) do 
    table.insert(Melee_in_game,i)
end
table.sort(Melee_in_game)
function BuyMelee(MeleeN)
    if IsPlayerAlive() and not KillingMob then 
        if _G.ServerData["PlayerBackpack"][MeleeN] then 
            task.spawn(function()
                _G.Config["Melee Level Values"][MeleeN] = _G.ServerData["PlayerBackpack"][MeleeN].Level.Value 
            end) 
            return
        end
        local RemoteArg = Melee_and_RemoteBuy[MeleeN]
        if type(RemoteArg) == "string" then
            local Loser = game.ReplicatedStorage.Remotes.CommF_:InvokeServer(RemoteArg, true) 
            local BeliPassed = _G.ServerData['PlayerData'].Beli >= Melee_and_Price[MeleeN].Beli 
            local FragmentPassed = _G.ServerData['PlayerData'].Fragments >= Melee_and_Price[MeleeN].Fragment   
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer(RemoteArg) 
            --if Loser then
                --[[

                and (Loser ~= 3 and (Loser ~= 0 or (Loser == 0 and FragmentPassed and BeliPassed ))) 
and (MeleeN == 'Godhuman' or (MeleeN == 'Godhuman' and CheckMaterialCount('Fish Tail') >= 20 and CheckMaterialCount('Magma Ore') >= 20 and CheckMaterialCount('Mystic Droplet') >= 10 and  CheckMaterialCount('Dragon Scale') >= 10)) then  
                ]]

            --end
        else
            pcall(
                function()
                    game.Players.LocalPlayer.Character.Humanoid:UnequipTools()
                    RemoteArg()
                end
            )
        end 
    end
end
function getMeleeLevelValues()
    SetContent('Checking all melee')
    task.spawn(function()
        if not _G.Config then repeat task.wait() until _G.Config end
        repeat 
            if identifyexecutor() == 'Wave' or not _G.Config["Melee Level Values"] then _G.Config["Melee Level Values"] = {} end
            task.wait()
        until _G.Config["Melee Level Values"]
        for i,v in pairs(Melee_and_RemoteBuy) do 
            if not _G.Config["Melee Level Values"][i] then 
                _G.Config["Melee Level Values"][i] = 0 
            end
            if _G.Config["Melee Level Values"][i] == 0 then 
                BuyMelee(i)
            end
            if _G.ServerData["PlayerBackpack"][i] then 
                _G.Config["Melee Level Values"][i] = _G.ServerData["PlayerBackpack"][i].Level.Value 
            end 
        end
    end) 
end 
function getFruitBelow1M()
    local minValue = 1000000
    local fruitName 
    for i,v in pairs(_G.ServerData["Inventory Items"]) do 
        if v.Value and v.Value < minValue then 
            fruitName = v.Name 
            minValue = v.Value  
        end 
    end
    return fruitName 
end
getMeleeLevelValues() 
_G.CheckAllMelee = true
function ReloadFrutis()    
    SetContent('Checking Server Fruits...')
    task.spawn(function()
        for i,v in pairs(game.workspace:GetChildren()) do 
            if v.Name:find('Fruit') and not table.find(_G.ServerData['Workspace Fruits'],v) then 
                pcall(function()
                    local vN = ReturnFruitNameWithId(v)
                    if not _G.ServerData['Inventory Items'][vN] then
                        print(vN,'new fruit')
                        table.insert(_G.ServerData['Workspace Fruits'],v)  
                        local selfs 
                        selfs = v:GetPropertyChangedSignal('Parent'):Connect(function()
                            if v.Parent ~= game.workspace then 
                                _G.ServerData['Workspace Fruits'] = {}
                                selfs:Disconnect()
                                ReloadFrutis()
                            end
                        end)
                    else
                        print("Skipped "..tostring(vN).." because already stored.")
                    end
                end)
            end 
        end
    end)
end  
function CheckAnyPlayersInCFrame(CFrameCheck, MinDistance)
    local CurrentFound
    for i, v in pairs(game.Players:GetChildren()) do
        pcall(
            function()
                if
                    v.Name ~= game.Players.LocalPlayer.Name and
                        GetDistance(v.Character.HumanoidRootPart, CFrameCheck) < MinDistance
                 then
                    CurrentFound = GetDistance(v.Character.HumanoidRootPart, gggggggggggggg)
                end
            end
        )
    end
    return CurrentFound
end 
ReloadFrutis() 
game:GetService("Workspace")["_WorldOrigin"].Locations.ChildAdded:Connect(function(v)
    local AddedTick = tick() 
    if not _G.ServerData then _G.ServerData = {} end
    if v.Name == 'Island 1' then 
        repeat 
            task.wait()
        until tick()-AddedTick > 60 or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-v.Position).Magnitude <= 1000 
        if tick()-AddedTick > 60 then 
            return  
        end
    end 
    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-v.Position).Magnitude <= 4500 then  
        if v.Name:find('Island') then 
            v:GetPropertyChangedSignal('Parent'):Connect(function()
                if not v.Parent or v.Parent ~= game:GetService("Workspace")["_WorldOrigin"].Locations then  
                    if _G.CurrentTask == 'Auto Raid' and _G.ServerData['Nearest Raid Island'] then 
                        repeat task.wait(1) until not game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible
                        _G.CurrentTask = '' 
                        print('Clearing',_G.ServerData['Nearest Raid Island'])   
                        if not _G.ServerData['Nearest Raid Island'] then 
                            _G.CurrentTask = ''
                        end
                        if _G.DimensionLoading then 
                            _G.DimensionLoading = false 
                        end
                        _G.NextRaidIslandId = 1 
                        _G.ServerData['Nearest Raid Island'] = nil
                        _G.tween:Cancel()   
                        if _G.KillAuraConnection then 
                            _G.KillAuraConnection:Disconnect()
                            _G.KillAuraConnection = nil 
                        end
                        local v302 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Awakener", "Check")
                        if not v302 or v302 == 0 or v302 == 1 then
                            wait()
                        else
                            if v302.Cost <= _G.ServerData['PlayerData'].Fragments and _G.Config.OwnedItems["Soul Guitar"] then
                                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Awakener", "Awaken")
                            end
                        end
                        
                    end
                end
            end)  
        end 
        _G.ServerData['Nearest Raid Island'] = getNearestRaidIsland()
    end
end)  
function CheckX2Exp()
    local a2, b2 =
        pcall(
        function()
            if _G.ServerData['PlayerData'].Level < 2450 then
                if string.find(game.Players.LocalPlayer.PlayerGui.Main.Level.Exp.Text, "ends in") then
                    return true
                end
            end
        end
    )
    if a2 then
        return b2
    end
end 
function PickChest(Chest)
    if not _G.ChestCollect or typeof(_G.ChestCollect) ~= 'number' then 
        _G.ChestCollect = 0 
    end
    if not Chest then 
        return 
    elseif not _G.ChestConnection then 
        SetContent('Picking up chest | '..tostring(_G.ChestCollect))
        _G.ChestConnection = Chest:GetPropertyChangedSignal('Parent'):Connect(function()
            _G.ChestCollect =_G.ChestCollect+1 
            _G.ChestConnection:Disconnect()
            _G.ChestConnection = nil
            SortChest()
        end) 
        local TeusHubtPick = tick()
        local TouchTrans 
        local OldChestCollect = _G.ChestCollect
        repeat 
            local PickChest1,PickChest2 = pcall(function()
                Tweento(Chest.CFrame,true)
                if GetDistance(Chest) <= 10 then
                    task.spawn(function()
                        firetouchinterest(Chest, game.Players.LocalPlayer.Character.HumanoidRootPart, 0)
                        firetouchinterest(Chest, game.Players.LocalPlayer.Character.HumanoidRootPart, 1)
                    end)
                    --firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, TouchTrans, 0)
                    --firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, TouchTrans, 1)
                end
            end)
        until not Chest or not Chest.Parent or tick()-TeusHubtPick >= 60 
        if Chest and Chest.Parent then 
            Chest:Destroy() 
        elseif _G.ChestCollect == OldChestCollect then 
            _G.ChestCollect=_G.ChestCollect+1
        end
    end
end
local RealRaid = {}
task.spawn(function()
    local Raids = require(game:GetService("ReplicatedStorage").Raids).raids
    local AdvancedRaids = require(game:GetService("ReplicatedStorage").Raids).advancedRaids
    for i, v in pairs(Raids) do 
        if v ~= " " and v ~= "" then 
            table.insert(RealRaid, v) 
        end
    end
    for i, v in pairs(AdvancedRaids) do
        if v ~= " " and v ~= "" then 
            table.insert(RealRaid, v) 
        end
    end 
end)
function CheckMaterialCount(MM) 
    local Count = 0 
    repeat 
        task.wait()
    until _G.LoadedTimes and _G.LoadedTimes >= 5
    if _G.ServerData['Inventory Items'][MM] and _G.ServerData['Inventory Items'][MM].Count then 
        Count = _G.ServerData['Inventory Items'][MM].Count 
    end 
    return Count
end
_G.SuccessBoughtTick = 0
_G.LastBuyChipTick = 0
function buyRaidingChip() 
    if _G.EnLoaded and _G.TaskUpdateTick and (Sea2 or Sea3) and tick()-JoinedGame > 60 and tick()-_G.SuccessBoughtTick > 60 and _G.ServerData['PlayerData'].Level >= 1100 and not _G.ServerData["PlayerBackpack"]['Special Microchip'] and not CheckIsRaiding() then 
        if (((_G.CurrentTask == '' or _G.MeleeTask == 'None') and _G.CurrentTask ~= 'Auto Sea 3') or _G.FragmentNeeded) and not checkFruit1M() and (_G.FragmentNeeded or (not CheckX2Exp() and ((_G.ServerData['PlayerData'].Fragments < 7500 or (_G.ServerData['PlayerData'].Level >= 2550 and _G.ServerData['PlayerData'].Fragments < 25000)) or #_G.ServerData["PlayerBackpackFruits"] > 0))) then 
            wait(1)
            local SelRaid = "Flame"
            if table.find(RealRaid,mmb(_G.ServerData['PlayerData'].DevilFruit)) then  
                SelRaid = mmb(_G.ServerData['PlayerData'].DevilFruit)
            end
            local bought = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaidsNpc","Select",SelRaid) == 1 
            if bought then 
                _G.SuccessBoughtTick = tick() 
            else
                local below1MFruit = getFruitBelow1M()
                if below1MFruit then 
                    SetContent('Getting '..tostring(below1MFruit)..' from inventory to buy chips...')
                    if game.ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadFruit", below1MFruit) then 
                        buyRaidingChip() 
                        _G.ServerData['Inventory Items'][below1MFruit] = nil 
                    else 
                        SetContent('Removing...')
                        if _G.ServerData['Inventory Items'][below1MFruit] then 
                            _G.ServerData['Inventory Items'][below1MFruit] = nil 
                        end
                    end
                end
            end 
        end
    end 
    _G.LastBuyChipTick = tick()
end 
_G.ServerData['Chest'] = {}
_G.ChestsConnection = {}
function SortChest()
    local LOROOT = game.Players.LocalPlayer.Character.PrimaryPart or game.Players.LocalPlayer.Character:WaitForChild('HumanoidRootPart')
    if LOROOT then
        table.sort(_G.ServerData['Chest'], function(chestA, chestB)  
            local distanceA
            local distanceB
            if chestA:IsA('Model') then 
                distanceA = (Vector3.new(chestA:GetModelCFrame()) - LOROOT.Position).Magnitude
            end 
            if chestB:IsA('Model') then 
                distanceB = (Vector3.new(chestB:GetModelCFrame()) - LOROOT.Position).Magnitude 
            end
            if not distanceA then  distanceA = (chestA.Position - LOROOT.Position).Magnitude end
            if not distanceB then  distanceB = (chestB.Position - LOROOT.Position).Magnitude end
            return distanceA < distanceB -- Sắp xếp giảm dần
        end)
    end
end
function AddChest(chest)
    wait()
    if table.find(_G.ServerData['Chest'], chest) or not chest.Parent then return end 
    if not string.find(chest.Name,'Chest') or not (chest.ClassName == ('Part') or chest.ClassName == ('BasePart')) then return end
    if (chest.Position-CFrame.new(-1.4128437, 0.292379826, -6.53605461, 0.999743819, -1.41806034e-09, -0.0226347167, 4.24517754e-09, 1, 1.2485377e-07, 0.0226347167, -1.24917875e-07, 0.999743819).Position).Magnitude <= 10 then 
        return 
    end 
    local CallSuccess,Returned = pcall(function()
        return GetDistance(chest)
    end)
    if not CallSuccess or not Returned then return end
    table.insert(_G.ServerData['Chest'], chest)  
    local parentChangedConnection
    parentChangedConnection = chest:GetPropertyChangedSignal('Parent'):Connect(function()
        local index = table.find(_G.ServerData['Chest'], chest)
        table.remove(_G.ServerData['Chest'], index)
        parentChangedConnection:Disconnect()
        SortChest()
    end)
end

function LoadChest()
    for _, v in pairs(workspace:GetDescendants()) do
        if string.find(v.Name, 'Chest') and v.Parent then
            task.spawn(function()
                AddChest(v)
                local parentFullName = v and v.Parent and tostring(v.Parent:GetFullName())
                if parentFullName and not _G.ChestsConnection[parentFullName] then
                    _G.ChestsConnection[parentFullName] = v.Parent.ChildAdded:Connect(AddChest)
                end
            end)
        end
    end 
    task.delay(3,function()
        print('Loaded total',#_G.ServerData['Chest'],'chests')
        SortChest()
    end)
end

task.spawn(LoadChest) 
function getNearestChest()
    for i,v in pairs(_G.ServerData['Chest']) do
        return v 
    end
end 
function advancedSkills(v2) 
    if v2:IsA("Frame") then 
        if v2.Name ~= 'Template' then 
            v2.Cooldown:GetPropertyChangedSignal('Size'):Connect(function()
                if v2.Name ~= "Template" and v2.Title.TextColor3 == Color3.new(1, 1, 1) and (v2.Cooldown.Size == UDim2.new(0, 0, 1, -1) or v2.Cooldown.Size == UDim2.new(1, 0, 1, -1)) then
                    _G.ServerData['Skill Loaded'][v2.Parent.Name][v2.Name] = true 
                elseif v2.Name ~= 'Template' then 
                    _G.ServerData['Skill Loaded'][v2.Parent.Name][v2.Name] = false 
                end 
            end) 
        end

        -- Check the Cooldown.Size immediately after connecting the signal
        if v2.Name ~= "Template" and v2.Title.TextColor3 == Color3.new(1, 1, 1) and (v2.Cooldown.Size == UDim2.new(0, 0, 1, -1) or v2.Cooldown.Size == UDim2.new(1, 0, 1, -1)) then
            _G.ServerData['Skill Loaded'][v2.Parent.Name][v2.Name] = true
        end
    end
end
function addSkills(v) 
    wait()
    if not table.find({'Title','Container','Level','TeusHubContainer','Rage'},v.Name) then 
        if not _G.ServerData['Skill Loaded'][v.Name] then 
            _G.ServerData['Skill Loaded'][v.Name] = {}
        end 
        table.foreach(v:GetChildren(),function(i,v2)
            advancedSkills(v2)
        end)
        v.ChildAdded:Connect(advancedSkills)
    end
end
function getSkillLoaded()
    for i,v in pairs(_G.ServerData['Skill Loaded']) do 
        if _G.ServerData['PlayerBackpack'][i] then 
            for i2,v2 in pairs(v) do 
                if v2 then 
                    return i,i2 
                end 
            end
        end 
    end
end
function loadSkills()
    game:GetService("Players").LocalPlayer.PlayerGui.Main.Skills.ChildAdded:Connect(addSkills) 
    for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Main.Skills:GetChildren()) do 
        addSkills(v)
    end
end    
function CheckTorchDimension(DimensionName) 
    DimensionName = DimensionName == "Yama" and "HellDimension" or "HeavenlyDimension" 
    if game.workspace.Map:FindFirstChild(DimensionName) then 
        v3 = game.workspace.Map:FindFirstChild(DimensionName):GetChildren()
        for i, v in pairs(v3) do
            if string.find(v.Name, "Torch") then
                if v.ProximityPrompt.Enabled == true then
                    return v
                end
            end
        end
    end
end  
function CheckQuestCDK() 
    if not Sea3 then return end
    local CDK_LevelQuest = {
        Good = 666,
        Evil = 666
    }
    Check,CheckValue = pcall(function()
        for i,v in pairs(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CDKQuest", "Progress", "Good")) do 
            CDK_LevelQuest[i] = v 
        end
    end)
    if CDK_LevelQuest.Good == -2 or CDK_LevelQuest.Good == 4 then 
        _G.CDK_Yama = true 
    end   
    task.spawn(function()
        if CDK_LevelQuest.Good ~= -2 and CDK_LevelQuest.Evil ~= -2 then 
            if not _G.CDK_Yama then 
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CDKQuest", "TeusHubtTrial", "Good")
            else
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CDKQuest", "TeusHubtTrial", "Evil")
            end
        end
    end) 
    if game.Players.LocalPlayer.PlayerGui.Main.Dialogue.Visible then
        game:GetService("VirtualUser"):Button1Down(Vector2.new(0, 0))
        game:GetService("VirtualUser"):Button1Down(Vector2.new(0, 0))
    end
    if CDK_LevelQuest.Good == 4 and CDK_LevelQuest.Evil == 3 then
        return "Pedestal2"
    elseif CDK_LevelQuest.Good == 3 and CDK_LevelQuest.Evil == 4 then
        return "Pedestal1"
    end
    if CDK_LevelQuest.Evil == 4 and CDK_LevelQuest.Good == 4 then
        return "The Final Boss"
    end  
    if CDK_LevelQuest.Good ~= -2 then 
        if GetDistance(game:GetService("Workspace")["_WorldOrigin"].Locations["Heavenly Dimension"]) < 2000 then 
            return "Tushita Dimension"
        end
        if CDK_LevelQuest.Good == -3 or CDK_LevelQuest.Good == -4 then 
            return "Tushita Quest "..tostring(CDK_LevelQuest.Good)
        end 
        if CDK_LevelQuest.Good == -5 then 
            return "Cake Queen"
        end
    else 
        if GetDistance(game:GetService("Workspace")["_WorldOrigin"].Locations["Hell Dimension"]) <= 2000 then 
            return "Yama Dimension"
        end
        if CDK_LevelQuest.Evil == -3 or CDK_LevelQuest.Evil == -4 then 
            return "Yama Quest "..tostring(CDK_LevelQuest.Evil)
        end  
        return "Soul Reaper"
    end
end  
function CheckHazeMob()
    for i, v in pairs(game.workspace.Enemies:GetChildren()) do
        if
            RemoveLevelTitle(v.Name) == NearestHazeMob() and v:IsA("Model") and
                v:FindFirstChild("HumanoidRootPart") and
                v:FindFirstChild("Humanoid") and
                v.Humanoid.Health > 0
         then
            return v
        end
    end
end 
function CheckMobHaki(mb)
    if mb:FindFirstChild("Humanoid") then
        for i, v in pairs(mb:WaitForChild("Humanoid"):GetChildren()) do
            if string.find(v.Name, "Buso") then
                return v
            end
        end
    end
end
function FindMobHasHaki(IncludedStorage)
    for i, v in pairs(game.workspace.Enemies:GetChildren()) do
        if v:FindFirstChildOfClass('Humanoid') and v:FindFirstChildOfClass('Humanoid').Health > 0 and CheckMobHaki(v) then
            return v
        end
    end
    if IncludedStorage then
        if v:FindFirstChildOfClass('Humanoid') and v:FindFirstChildOfClass('Humanoid').Health > 0 and CheckMobHaki(v) then
            if CheckMobHaki(v) then
                return v
            end
        end
    end
end
function NearestHazeMob()
    local AllHazeMobs = {}
    if not game:GetService("Players").LocalPlayer:FindFirstChild('QuestHaze') then 
        return ""
    end
    for i, v in pairs(game:GetService("Players").LocalPlayer.QuestHaze:GetChildren()) do
        if v.Value > 0 then
            table.insert(AllHazeMobs, RemoveLevelTitle(v.Name))
        end
    end
    local MobF = ""
    local maxDis = math.huge
    for i, v in pairs(AllHazeMobs) do
        if MobSpawnClone[v] then
            if GetDistance(MobSpawnClone[v]) < maxDis then
                maxDis = GetDistance(MobSpawnClone[v]) 
                MobF = v 
            end
        end
    end
    return MobF
end 
function GetSeaBeast() 
    for i,v in pairs(game:GetService("Workspace").SeaBeasts:GetChildren()) do 
        if v.Name:find("SeaBeast") and v:FindFirstChild('Health') then
            MaxHealth = v.HealthBBG.Frame.TextLabel.Text:gsub(',',''):gsub('%d+/','')
            MaxHealth = tonumber(MaxHealth)     
            if MaxHealth >= 75000 then 
                return v 
            end   
        end 
    end
end
function CheckPirateBoat()
    local PirateBoats = {
        "PirateBasic",
        "PirateBrigade",
    }
    for i, v in next, game:GetService("Workspace").Enemies:GetChildren() do
        if table.find(PirateBoats, v.Name) and v:FindFirstChild("Health") and v.Health.Value > 0 then
            return v
        end
    end
end 
function TeleportWorldbeast(x)
    local hrpPos = x.PrimaryPart.Position
    local waterPosY = game:GetService("Workspace").Map["WaterBase-Plane"].Position.Y

    if math.abs(hrpPos.Y - waterPosY) <= 175 then
        Tweento(CFrame.new(hrpPos) * CFrame.new(0, 300, 50))
    else
        Tweento(CFrame.new(hrpPos.X, waterPosY + 200, hrpPos.Z))
    end
end

function AutoSeaBeast()
    local CFrameSB1 = CFrame.new(-13.488054275512695, 10.311711311340332, 2927.69287109375)
    local CFrameSB2 = CFrame.new(28.4108, 1.2327, 3679.99)
    if Sea3 then
        CFrameSB1 = CFrame.new(-6044.32031, 15.1150599, -2040.65674)
        CFrameSB2 =
            CFrame.new(
            -6737.10742,
            6.33979416,
            -1870.81787,
            -0.393565148,
            5.29488897e-09,
            0.919296741,
            1.58969673e-08,
            1,
            1.04602116e-09,
            -0.919296741,
            1.50257087e-08,
            -0.393565148
        )
    end 
    local newTar = GetSeaBeast() or CheckPirateBoat()
    if newTar then
        print('new tar',newTar.Name)
        local OldSeat = getgenv().MySeatPart
        local SkillAb,SkillBb
        local tickUseSkill = 0 
        if game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuySharkmanKarate", true) == 1 then 
            BuyMelee("Sharkman Karate") 
        else
            local args = {
                [1] = "BlackbeardReward",
                [2] = "DragonClaw",
                [3] = "2"
            }
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        end
        if newTar.Name:find('SeaBeast') then 
            print('print(v.PrimaryPart)',newTar.PrimaryPart)
            repeat 
                task.wait()
                getgenv().MySeatPart = nil 
                TeleportWorldbeast(newTar)
                getgenv().AimPos = newTar.PrimaryPart.CFrame 
                if tick()-tickUseSkill >= 1 then 
                    SkillAb,SkillBb = getSkillLoaded()
                    tickUseSkill = tick()
                    task.spawn(function()
                        if SkillAb and SkillBb then 
                            EquipWeaponName(SkillAb)
                            SendKey(SkillBb,.5)
                        else 
                            for i,v in pairs(_G.ServerData['PlayerBackpack']) do 
                                if v.ClassName == 'Tool' and table.find({"Melee","Sword","Gun","Blox Fruit"},v.ToolTip) then 
                                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
                                    task.wait()
                                end  
                            end
                        end
                    end)
                end
            until not newTar or not newTar.PrimaryPart or not newTar:FindFirstChildOfClass('IntValue') or newTar:FindFirstChildOfClass('IntValue').Value <= 0
            getgenv().MySeatPart = OldSeat 
            getgenv().AimPos = nil
        else 
            print('print(v.PrimaryPart)',newTar.PrimaryPart)
            repeat 
                task.wait()
                getgenv().MySeatPart = nil 
                pcall(Tweento,newTar.PrimaryPart.CFrame * CFrame.new(0,30,0))
                getgenv().AimPos = newTar.PrimaryPart.CFrame 
                if tick()-tickUseSkill >= 1 then 
                    SkillAb,SkillBb = getSkillLoaded()
                    tickUseSkill = tick()
                    task.spawn(function()
                        if SkillAb and SkillBb then 
                            EquipWeaponName(SkillAb)
                            SendKey(SkillBb,.5)
                        end
                    end)
                end
            until not newTar or not newTar.PrimaryPart or not newTar:WaitForChild('Humanoid') or newTar.Health.Value <= 0
            print(newTar.PrimaryPart)
            getgenv().MySeatPart = OldSeat 
            getgenv().AimPos = nil
        end
    elseif not getgenv().MyBoat then 
        print('Buying Boat')
        if GetDistance(CFrameSB1) > 8 then
            Tweento(CFrameSB1)
        else
            repeat 
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBoat", "MarineBrigade")
                task.wait(2)
            until getgenv().MyBoat
        end
    else
        if GetDistance(getgenv().MySeatPart, CFrameSB2) > 50 then 
            getgenv().MySeatPart.CFrame = CFrameSB2 * CFrame.new(20, 10, 20)
        else
            _G.PlayerLastMoveTick = tick()
            if not game:GetService("Players").LocalPlayer.Character.Humanoid.Sit or game:GetService("Players").LocalPlayer.Character.Humanoid.SeatPart ~= getgenv().MySeatPart then 
                print('Tweening to boat')
                game:GetService("Players").LocalPlayer.Character.Humanoid.Sit = false 
                Tweento(getgenv().MySeatPart.CFrame,true)
            end
        end
    end
end
if not _G.ServerData['PlayerData'] then _G.ServerData['PlayerData'] = {} end

_G.ServerData['PlayerData']['Colors'] = {} 
function UnCompleteColor()
    for i, v in next, game:GetService("Workspace").Map["Boat Castle"].Summoner.Circle:GetChildren() do
        if v:IsA("Part") and v:FindFirstChild("Part") and v.Part.BrickColor.Name == "Dark stone grey" then
            return v
        end
    end
end    
function HasColor(BrickColorName) 
    local BricksWithColors = {
        ["Hot pink"] = "Winter Sky",
        ["Really red"] = "Pure Red",
        ["Oyster"] = "Snow White"
    }
    local RealColorName = BricksWithColors[BrickColorName]
    if not _G.ServerData['PlayerData']['Colors'][RealColorName] then
        return false 
    else
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("activateColor", RealColorName) 
        return true
    end
end     
local Item_Bosses = {
    ["Chief Warden1"] = "Wardens Sword",
    ["Swan2"] = "Pink Coat",
    ["Magma Admiral3"] = "Refined Musket",
    ["Fishman Lord4"] = "Trident",
    ["Wysper5"] = "Bazooka",
    ["Thunder God6"] = " Pole (1st Form)",
    ["Cyborg7"] = "Cool Shades",

    ["Diamond8"] = "Longsword",
    ["Jeremy9"] = "Black Spikey Coat",
    ["Fajita10"] = "Gravity Cane",
    --["Don Swan11"] = "Swan Glasses",
    ["Smoke Admiral12"] = "Jitte",
    ["Tide Keeper13"] = "Dragon Trident",
    
    ["Stone14"] = "Pilot Helmet",
    ["Island Empress15"] = "Serpent Bow",
    ["Kilo Admiral17"] = "Lei",
    ["Captain Elephant18"] = "Twin Hooks",
    ["Beautiful Pirate16"] = "Canvander",
    ["Cake Queen19"] = "Buddy Sword",
}
function getNextBossDropParent()
    if not _G.DropIndex then 
        _G.DropIndex =1
    end
    local function findDrop(DropIndex) 
        local currentindex = 0
        for index,drop in Item_Bosses do 
            currentindex = tonumber(index:match('%d+'))
            if currentindex == DropIndex then 
                return drop,index:gsub(currentindex,'')
            end
        end
    end
    local currentDrop,dropParent = findDrop(_G.DropIndex)
    while not currentDrop or _G.ServerData["Inventory Items"][currentDrop] do 
        _G.DropIndex =_G.DropIndex+1 
        currentDrop,dropParent = findDrop(_G.DropIndex) 
    end
    return currentDrop,dropParent
end
function UpdateBossDropTable()
    if not _G.BossDropTable then _G.BossDropTable = {} end 
    for i,v in (Item_Bosses) do 
        if not _G.ServerData["Inventory Items"][v] then 
            if not table.find(_G.BossDropTable,i:gsub('%d+','')) then 
                table.insert(_G.BossDropTable,tostring(i:gsub('%d+','')))
            end 
        else
            if table.find(_G.BossDropTable,i:gsub('%d+','')) then 
                table.remove(_G.BossDropTable,table.find(_G.BossDropTable,i:gsub('%d+','')))
            end 
        end
    end 
    return _G.BossDropTable
end
local TOIKHONGBIET = 0
local CheckFruitStockTick = 0
local LastCheckTickFruit = 0
for i,v in pairs(game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("getInventory")) do 
    if v and typeof(v) == 'table' and v.Name and v.Name ~= '' then 
        _G.ServerData["Inventory Items"][v.Name] = v  
    end
    if _G.Config and v.Type ~= 'Fruit' and not v.Value then 
        if not _G.Config then 
            _G.Config = {}
        end
        if not _G.Config.OwnedItems then 
            _G.Config.OwnedItems = {}
        end
        _G.Config.OwnedItems[v.Name] = true 
    end
end
game:GetService("Workspace").Boats.ChildAdded:Connect(function(v)
    wait()
    local Owner = v and v:WaitForChild('Owner')
    local Hum = v and v:WaitForChild('Humanoid')
    print('New boat added')
    if tostring(Owner.Value) == game:GetService("Players").LocalPlayer.Name then
        getgenv().MyBoat = v
        print('My boat',getgenv().MyBoat) 
        getgenv().MySeatPart = v:WaitForChild('VehicleSeat')
        Hum:GetPropertyChangedSignal('Value'):Connect(function()
            if Hum.Value <= 0 then 
                if getgenv().MyBoat == v then 
                    getgenv().MyBoat = nil 
                end
                if getgenv().MySeatPart == v.VehicleSeat then 
                    getgenv().MySeatPart = nil 
                end
            end
        end)
    end
end)
_G.ServerData["Fruits Stock"] = {}
local ThisiSW  
_G.Ticktp = 0
_G.LoadedTimes = 0 
_G.ReloadTime = _G.ReloadTime or 3
ThisiSW = RunService.Heartbeat:Connect(function()
    if game.PlaceId == 2753915549 then
        Sea1 = true
        Sea2 = false
        Sea3 = false 
        MySea = "Sea 1"
    elseif game.PlaceId == 4442272183 then
        Sea2 = true
        Sea1 = false
        Sea3 = false
        MySea = "Sea 2"
    elseif game.PlaceId == 7449423635 then
        Sea3 = true
        Sea1 = false
        Sea2 = false
        MySea = "Sea 3"
    end
    if IsPlayerAlive() then 
        game.Players.LocalPlayer.Character.PrimaryPart.Velocity = Vector3.new(0,0,0)

        if game.Players.LocalPlayer.Character.Humanoid.Sit and not (getgenv().MySeatPart and game.Players.LocalPlayer.Character.Humanoid.SeatPart == getgenv().MySeatPart) then 
            game.Players.LocalPlayer.Character.Humanoid.Sit = false
        end
        if Sea3 and not _G.ServerData["Inventory Items"]['Cursed Dual Katana'] and _G.ServerData["Inventory Items"]['Tushita'] and _G.ServerData["Inventory Items"]['Yama'] and _G.ServerData["Inventory Items"]['Tushita'].Mastery >= 350 and _G.ServerData["Inventory Items"]['Yama'].Mastery then 
            _G.CDKQuest = CheckQuestCDK()  
        end  
        if game.Players.LocalPlayer.Character:FindFirstChild("RaceEnergy") and game.Players.LocalPlayer.Character.RaceEnergy.Value >= 1 and not game.Players.LocalPlayer.Character.RaceTransformed.Value then 
            SendKey('Y',.5)
        end
        EnableBuso()
        if tick() - _G.LastBuyChipTick > 5 then 
            _G.LastBuyChipTick = tick();
            buyRaidingChip() 
        end
        if tick()-_G.Ticktp < 0.5 or KillingMob or (_G.tween and _G.tween.PlaybackState and tostring(string.gsub(tostring(_G.tween.PlaybackState), "Enum.PlaybackState.", "")) == 'Playing') or (_G.TweenStats and tostring(string.gsub(tostring(_G.TweenStats), "Enum.PlaybackState.", "")) == 'Playing') then 
            AddBodyVelocity(true)
            for i,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do 
                if v:IsA("BasePart") or v:IsA("Part") then 
                    v.CanCollide = false 
                end
            end
        else
            AddBodyVelocity(false)
        end 
        if _G.PlayerLastMoveTick and tick()-_G.PlayerLastMoveTick >= 5*60 then 
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)  
        end
        local SetText = ""
        if _G.LocalPlayerStatusParagraph then 
            SetText = "Level: "..tostring(_G.ServerData['PlayerData'].Level)..
                    "\nBeli: "..tostring(_G.ServerData['PlayerData'].Beli)..
                    "\nFragment: "..tostring(_G.ServerData['PlayerData'].Fragments)..
                    "\nRace: "..tostring(_G.ServerData['PlayerData'].Race).." "..tostring(_G.ServerData['PlayerData'].RaceVer)..
                    "\nElite Hunted: "..tostring(_G.ServerData['PlayerData']["Elite Hunted"])..
                    "\nDevil Fruit: "..tostring((_G.ServerData['PlayerData'].DevilFruit ~= '' and _G.ServerData['PlayerData'].DevilFruit or "None"))
            _G.LocalPlayerStatusParagraph:Set({
                Title = "Local Player Status",
                Content = SetText
            })
        end
        if _G.ServerStatusParagraph then
            local MoonPhase = game:GetService("Lighting"):GetAttribute("MoonPhase") 
            SetText = "Moon: "..tostring((MoonPhase == 5 and "Full Moon" or MoonPhase == 4 and "Gibbous Moon" or "Bad moon"))..
                "\nMirage Island: "..tostring(game:GetService("Workspace").Map:FindFirstChild("MysticIsland") and "✅" or "❌")..
                "\nElite Spawned: "..tostring(_G.CurrentElite and "✅" or "❌")
            _G.ServerStatusParagraph:Set({
                Title = 'Server Status',
                Content = SetText
            })
        end
        if _G.ItemOwnedParagraph then 
            SetText = ""
            local ItemsOwned = {}
            for itemName,itemTab in _G.ServerData["Inventory Items"] do 
                if itemTab and (itemTab.Type ~= "Blox Fruit" and itemTab.Type ~= 'Material') then 
                    table.insert(ItemsOwned,itemTab)
                end
            end
            table.sort(ItemsOwned,function(a,b)
                if a.Type == b.Type then 
                    if a.Rarity == b.Rarity then 
                        return a.Name < b.Name
                    else
                        return a.Rarity > b.Rarity
                    end    
                else
                    return a.Type < b.Type 
                end  
            end)
            for i,v in ItemsOwned do 
                SetText = SetText.."\n"..tostring(v.Name)..": ✅"
            end
            _G.ItemOwnedParagraph:Set({
                Title = 'Item Owned',
                Content = SetText
            })
        end
        if not _G.ReloadTime or _G.ReloadTime < 3 then 
            _G.ReloadTime = 3 
        end
        if KillingMob or tick()-TOIKHONGBIET < _G.ReloadTime then return end   
        TOIKHONGBIET = tick() 
        if not _G.Config then 
            _G.Config = {}
        end
        if not _G.Config.OwnedItems then 
            _G.Config.OwnedItems = {}
        end
        for i,v in pairs(game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("getInventory")) do 
            if v and typeof(v) == 'table' and v.Name and v.Name ~= '' then 
                _G.ServerData["Inventory Items"][v.Name] = v  
            end
            if _G.Config and v.Type ~= 'Fruit' and not v.Value then 
                _G.Config.OwnedItems[v.Name] = true 
            end
        end
        _G.LoadedTimes =_G.LoadedTimes+1
        _G.Config.OwnedItems.LoadedFr = true
        _G.HavingX2 =CheckX2Exp()
        UpdateBossDropTable()
        _G.NextDrop,_G.NextDropParent = getNextBossDropParent()
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CakePrinceSpawner")
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("SetSpawnPoint")
        if _G.FruitSniping and _G.SnipeFruit and _G.ServerData['PlayerData'].DevilFruit == '' and tick()-LastCheckTickFruit >= 3 then 
            LastCheckTickFruit = tick()
            if tick()-CheckFruitStockTick >= 15*60 then 
                CheckFruitStockTick = tick()
                _G.ServerData["Fruits Stock"][1] = (function() 
                    local returnTable = {}
                    for i,v in game.ReplicatedStorage.Remotes.CommF_:InvokeServer("GetFruits", false) do 
                        if v.OnSale then 
                            table.insert(returnTable,v.Name)
                        end
                    end
                    return returnTable
                end)() 
                _G.ServerData["Fruits Stock"][2] = (function() 
                    local returnTable = {}
                    for i,v in game.ReplicatedStorage.Remotes.CommF_:InvokeServer("GetFruits", true) do 
                        if v.OnSale then 
                            table.insert(returnTable,v.Name)
                        end
                    end
                    return returnTable
                end)()
            end
            for i,v in pairs(_G.FruitSniping) do 
                if table.find(_G.ServerData["Fruits Stock"][1],v) then 
                    print("Buying: "..tostring(v))
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("PurchaseRawFruit",v, 1==2)
                    break
                elseif table.find(_G.ServerData["Fruits Stock"][2],v) then 
                    print("Buying: "..tostring(v))
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("PurchaseRawFruit",v, 2==2)
                    break
                end
            end
            _G.CanEatFruit = checkFruittoEat(_G.FruitSniping,_G.IncludeStored)
        end
        if _G.ServerData["Inventory Items"]['Cursed Dual Katana'] and _G.CDKQuest then 
            _G.CDKQuest = nil 
        end
        if not _G.RaceV4Progress or (_G.RaceV4Progress ~= 4 and _G.RaceV4Progress ~= 5) then 
            _G.RaceV4Progress = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "Check") 
        end
        if _G.ServerData["PlayerData"].Beli >= 5500000 then 
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyHaki","Geppo")
            -- Buy Buso Haki
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyHaki","Buso")
            -- Buy Soru
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyHaki","Soru")  
            -- Buy Ken 
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("KenTalk", "Buy")
        end
        if not _G.ServerData['PlayerData']["Elite Hunted"] or _G.ServerData['PlayerData']["Elite Hunted"] < 30 then 
            _G.ServerData['PlayerData']["Elite Hunted"] = tonumber(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("EliteHunter", "Progress")) or 0 
        end
        _G.ServerData['PlayerData']["RaceVer"] = CheckRaceVer()  
        for i, v in pairs(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("getColors")) do
            if v["Unlocked"] then
                _G.ServerData['PlayerData']['Colors'][v.HiddenName] = v
            end
        end
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy") 
        local v141, v142 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ColorsDealer", "1")
        if v141 and v142 and v142 > 5000 then 
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ColorsDealer", "2")
        end
        if _G.SwitchingServer and ThisiSW then 
            task.delay(3,function()
                if _G.SwitchingServer then 
                    if ThisiSW then 
                        ThisiSW:Disconnect()
                        ThisiSW = nil 
                    end
                end
            end)
        end
    end
end) 
local GC = getconnections or get_signal_cons
if GC then
    game.Players.LocalPlayer.Idled:Connect(
        function()
            for i, v in pairs(GC(game.Players.LocalPlayer.Idled)) do
                v:Disable()
            end
        end
    )
end 
local MT = getrawmetatable(game)
local OldNameCall = MT.__namecall
setreadonly(MT, false)
MT.__namecall = newcclosure(function(self, ...)
    local Method = getnamecallmethod()
    local Args = {...}
    if Method == 'FireServer' and self.Name == 'RemoteEvent' and AimPos 
    and tostring(AimPos.X) ~= "nan" then
        if  #Args == 1 and typeof(Args[1]) == "Vector3" then
            Args[1] = AimPos.Position
        end
        if #Args == 1 and typeof(Args[1]) == "CFrame" then
            Args[1] = AimPos
        end
    end
    return OldNameCall(self, unpack(Args))
end)
LoadPlayer()
task.spawn(SetContent,"😇")
print('Loaded Success Full!')
_G.EnLoaded = true   

local ScreenGui = Instance.new("ScreenGui");
local DropShadowHolder = Instance.new("Frame");
local DropShadow = Instance.new("ImageLabel");
local Main = Instance.new("Frame");
local UICorner = Instance.new("UICorner");
local UIStroke = Instance.new("UIStroke");
local UIGradient = Instance.new("UIGradient");
local Top = Instance.new("TextLabel");
local UIGradient1 = Instance.new("UIGradient");
local Under = Instance.new("TextLabel");
local UIGradient2 = Instance.new("UIGradient");
local JoinTextBox = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextBox = Instance.new("TextBox")

for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetChildren()) do 
    if v.Name == 'CoinCard' then 
        v:Destroy() 
    end
end

ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("Players").LocalPlayer.PlayerGui
ScreenGui.Name = 'CoinCard'


local DiscordUrlTextLabel = Instance.new("TextLabel", ScreenGui);
DiscordUrlTextLabel["BorderSizePixel"] = 0;
DiscordUrlTextLabel["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
DiscordUrlTextLabel["TextSize"] = 16;
DiscordUrlTextLabel["FontFace"] = Font.new([[rbxasset://fonts/families/RobotoMono.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
DiscordUrlTextLabel["TextColor3"] = Color3.fromRGB(223, 115, 255);
DiscordUrlTextLabel["BackgroundTransparency"] = 1;
DiscordUrlTextLabel["AnchorPoint"] = Vector2.new(0.5, 0.5);
DiscordUrlTextLabel["Size"] = UDim2.new(0, 200, 0, 50);
DiscordUrlTextLabel["BorderColor3"] = Color3.fromRGB(142, 66, 133);
DiscordUrlTextLabel["Text"] = [[dsc.gg/teusscripts]];
DiscordUrlTextLabel["Position"] = UDim2.new(0.5, 0, -0.025, 0);

local DiscordUrlUiStroke = Instance.new("UIStroke", DiscordUrlTextLabel);
DiscordUrlUiStroke["Color"] = Color3.fromRGB(255, 255, 255);

local DiscordUrlUiGradient = Instance.new("UIGradient", DiscordUrlUiStroke);
GDiscordUrlUiGradient = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(225, 164, 194 )),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(142, 66, 133))
};



DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
DropShadowHolder.BackgroundTransparency = 1
DropShadowHolder.BorderSizePixel = 0
DropShadowHolder.Position = UDim2.new(0.5, 0, 0.1, 0)
DropShadowHolder.Size = UDim2.new(0, 500, 0, 68)
DropShadowHolder.ZIndex = 0
DropShadowHolder.Name = "DropShadowHolder"
DropShadowHolder.Parent = ScreenGui

DropShadow.Image = "rbxassetid://6015897843"
DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
DropShadow.ImageTransparency = 0.5
DropShadow.ScaleType = Enum.ScaleType.Slice
DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
DropShadow.BackgroundTransparency = 1
DropShadow.BorderSizePixel = 0
DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
DropShadow.Size = UDim2.new(1, 47, 1, 47)
DropShadow.ZIndex = 0
DropShadow.Name = "DropShadow"
DropShadow.Parent = DropShadowHolder

Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Main.BackgroundTransparency = 0.5
Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.Size = UDim2.new(1, -47, 1, -47)
Main.Name = "Main"
Main.Parent = DropShadow

UICorner.CornerRadius = UDim.new(0, 5)
UICorner.Parent = Main

UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Thickness = 2.5
UIStroke.Parent = Main

UIGradient.Color = ColorSequence.new{
ColorSequenceKeypoint.new(0, Color3.fromRGB(153, 102, 204)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(223, 115, 255))
}
UIGradient.Parent = UIStroke

Top.Font = Enum.Font.GothamBold
Top.Text = "Let the music play"
Top.TextColor3 = Color3.fromRGB(255, 255, 255)
Top.TextSize = 16.5
Top.TextYAlignment = Enum.TextYAlignment.Bottom
Top.AnchorPoint = Vector2.new(0.5, 0)
Top.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Top.BackgroundTransparency = 0.9990000128746033
Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
Top.BorderSizePixel = 0
Top.Position = UDim2.new(0.5, 0, 0, 15)
Top.Size = UDim2.new(0, 500, 0, 18)
Top.Name = "Top"
Top.Parent = Main

UIGradient1.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(153, 102, 204)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(223, 115, 255))
}
UIGradient1.Parent = Top

Under.Font = Enum.Font.GothamBold
Under.Text = "Script started!"
Under.TextColor3 = Color3.fromRGB(255, 255, 255)
Under.TextSize = 18
Under.TextYAlignment = Enum.TextYAlignment.Bottom
Under.AnchorPoint = Vector2.new(0.5, 0)
Under.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Under.BackgroundTransparency = 0.9990000128746033
Under.BorderColor3 = Color3.fromRGB(0, 0, 0)
Under.BorderSizePixel = 0
Under.Position = UDim2.new(0.5, 0, 0, 35)
Under.Size = UDim2.new(0, 500, 0, 18)
Under.Name = "Under"
Under.Parent = Main

UIGradient2.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(153, 102, 204)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(223, 115, 255))
}
UIGradient2.Parent = Under
Top.Size = UDim2.new(0, Top.TextBounds.X, 0, 18)
Under.Size = UDim2.new(0, Under.TextBounds.X, 0, 18)
if Top.Size.X.Offset > Under.Size.X.Offset then
    DropShadowHolder.Size = UDim2.new(0, Top.TextBounds.X + 50, 0, 68)
else
    DropShadowHolder.Size = UDim2.new(0, Under.TextBounds.X + 50, 0, 68)
end
Top:GetPropertyChangedSignal("Text"):Connect(function()
    Top.Size = UDim2.new(0, Top.TextBounds.X, 0, 18)
    if Top.Size.X.Offset > Under.Size.X.Offset then
        DropShadowHolder.Size = UDim2.new(0, Top.TextBounds.X + 50, 0, 68)
    else
        DropShadowHolder.Size = UDim2.new(0, Under.TextBounds.X + 50, 0, 68)
    end
end)
Under:GetPropertyChangedSignal("Text"):Connect(function()
    Under.Size = UDim2.new(0, Under.TextBounds.X, 0, 18)
    if Top.Size.X.Offset > Under.Size.X.Offset then
        DropShadowHolder.Size = UDim2.new(0, Top.TextBounds.X + 50, 0, 68)
    else
        DropShadowHolder.Size = UDim2.new(0, Under.TextBounds.X + 50, 0, 68)
    end
end)

Top.Text = 'Auto Farm: None'
Under.Text = "Task: None" 
getgenv().ContentSet = function(Content1, Content2,Content3)
	if not Content1 then Content1 = 'None (Not Found)' end 
	if not Content2 or Content2 == '' then Content2 = 'Farming Level (or None)' end 
	Top.Text = "Auto Farm: "..Content1
	Under.Text = "Task: "..Content2 .. Content3
end

Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Parent = JoinTextBox
    Frame.BackgroundColor3 = Color3.new(255, 255, 255)
    Frame.BackgroundTransparency = 0.4
    Frame.BorderMode = 'Middle'
    Frame.BorderColor3 = Color3.new(250, 250, 250)
    Frame.BorderSizePixel = 5
    Frame.Position = UDim2.new(0.5, 0, 0.7, 0)
    Frame.Size = UDim2.new(0, 400, 0, 50)
    local UIStroke = Instance.new("UIStroke");
    
    
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Thickness = 2.5
    UIStroke.Parent = Frame
    
    
    local TextLabel = Instance.new("TextLabel")
     
    TextLabel.Parent = Frame
    TextLabel.BackgroundColor3 = Color3.new(0.623529, 0.623529, 0.623529)
    TextLabel.BackgroundTransparency = 1
    TextLabel.BorderColor3 = Color3.new(0, 0, 0)
    TextLabel.BorderSizePixel = 0
    TextLabel.AnchorPoint = Vector2.new(0, 0)
    TextLabel.Size = UDim2.new(0, 400, 0, 50)
    TextLabel.Font = Enum.Font.Highway
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.TextSize = 20
    TextLabel.Text = 'Enter a Job Id or join Job Id script right here.'
    TextLabel.TextWrapped = true
    --TextLabel.TextScaled = true
    TextLabel.ZIndex = 0
    local gadient = Instance.new("UIGradient");
    gadient.Parent = UIStroke
    gadient.Color = ColorSequence.new(TextBoxGradientColorTable)
    
    local gadient = Instance.new("UIGradient");
    gadient.Parent = TextLabel
    gadient.Color = ColorSequence.new(TextBoxGradientColorTable)
    
    gadient = Instance.new("UIGradient");
    gadient.Parent = Frame
    gadient.Color = ColorSequence.new(TextBoxGradientColorTable)
    
    
    
    TextBox.Parent = Frame
    TextBox.BackgroundColor3 = Color3.new(255, 255, 255)
    TextBox.BackgroundTransparency = 1
    TextBox.BorderColor3 = Color3.new(0, 0, 0)
    TextBox.BorderSizePixel = 0
    TextBox.Size = UDim2.new(0, 400, 0, 50)
    TextBox.Font = Enum.Font.Highway
    TextBox.Text = ""
    TextBox.TextColor3 = Color3.new(1, 1, 1)
    TextBox.TextSize = 14
    TextBox.ZIndex = 1
    
    -- Sự kiện khi ô nhập liệu được click vào
    TextBox.Focused:Connect(function()
        TextLabel.Visible = false
    end)
    
    -- Sự kiện khi ô nhập liệu bị bỏ chọn hoặc người dùng nhấn Enter
    TextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            if TextBoxJoinCallback then 
                TextBoxJoinCallback(TextBox.Text)
            end
            TextLabel.Text = TextBox.Text
        else
            TextLabel.Text = "Press Enter Please."
        end
        TextBox.Visible = false
        TextLabel.Visible = true
        task.delay(5,function()
            TextBox.Visible = true 
            TextLabel.Visible = false
        end)
    end)

local namequest
local BlackListedKillPlayers = {}
IsBossDrop = function()
    if _G.HavingX2 then return end 
    if CheckEnabling and CheckEnabling('Farming Boss Drops When X2 Expired') then     
        if _G.BossDropTable then 
            for i,v in _G.BossDropTable do 
                if _G.ServerData['Server Bosses'][v] then 
                    return _G.ServerData['Server Bosses'][v]
                end
            end
        end
    end
end

getgenv().AutoL = function()
    if _G.QuestKillPlayer and not game:GetService("Players").LocalPlayer.PlayerGui.Main:FindFirstChild("Quest").Visible then 
        _G.QuestKillPlayer = false 
    end 
    local BOSSCP =  _G.ServerData['Server Bosses']['Dark Beard'] or _G.ServerData['Server Bosses']['Cake Prince'] or _G.ServerData['Server Bosses']['Dough King'] 
    if Sea3 and (not game:GetService("Workspace").Map.Turtle:FindFirstChild("TushitaGate") or _G.ServerData['PlayerData'].Level < 2000 )and not BOSSCP and _G.ServerData['Server Bosses']['rip_indra True Form'] then 
        BOSSCP = _G.ServerData['Server Bosses']['rip_indra True Form'] 
    end
    if not BOSSCP then 
        BOSSCP = IsBossDrop()
    end
    if game.PlaceId == 2753915549 and not _G.QuestKillPlayer and game.Players.LocalPlayer.Data.Level.Value >= 50 and game.ReplicatedStorage.Remotes["CommF_"]:InvokeServer("PlayerHunter") ~="I don't have anything for you right now. Come back later." then 
        namequest =
            string.gsub(
            game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,
            "Defeat ",
            ""
        )
        namequest = string.gsub(namequest, " %p(0/1)%p", "") 
        if
            game:GetService("Players").LocalPlayer.PlayerGui.Main:FindFirstChild("Quest").Visible and
                namequest and
                game:GetService("Workspace").Characters:FindFirstChild(namequest)
            then
                _G.QuestKillPlayer = true
        end
    elseif game.PlaceId == 2753915549 and game:GetService("Players").LocalPlayer.PlayerGui.Main:FindFirstChild("Quest").Visible and _G.QuestKillPlayer then 
        namequest =
            string.gsub(
            game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,
            "Defeat ",
            ""
        )
        namequest = string.gsub(namequest, " %p(0/1)%p", "") 
        if #BlackListedKillPlayers >= 8 then 
            repeat 
                warn('TeusHubt Hop Server')
                HopServer(10,false,'Player Hunter Quest') 
                CancelKillPlayer() 
                task.wait(5) 
            until 5 > 6
        end
        if game.Players.LocalPlayer.PlayerGui.Main.PvpDisabled.Visible then 
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EnablePvp")
        else
            if
            game:GetService("Players").LocalPlayer.PlayerGui.Main:FindFirstChild("Quest").Visible and
                not game:GetService("Workspace").Characters:FindFirstChild(namequest)
            then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                warn('Cancel: not found')
            end
            if
                game.Players[namequest].Data.Level.Value < 20 or
                    game.Players[namequest].Data.Level.Value > game.Players.LocalPlayer.Data.Level.Value +300
            then
                table.insert(BlackListedKillPlayers, namequest)
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                _G.QuestKillPlayer = false 
                warn('Cancel: not enough requirements |',namequest)
            end 
            if game:GetService("Players").LocalPlayer.PlayerGui.Main:FindFirstChild("Quest").Visible then
                if KillPlayer(namequest) then 
                    _G.QuestKillPlayer = false 
                    table.insert(BlackListedKillPlayers, namequest)
                    return;
                else
                    table.insert(BlackListedKillPlayers, namequest)
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                    _G.QuestKillPlayer = false
                end
            end
        end
    elseif not _G.QuestKillPlayer and game.PlaceId == 2753915549 and game.Players.LocalPlayer.Data.Level.Value < 120 and game.Players.LocalPlayer.Data.Level.Value >= 15 then 
        KillMobList({"Royal Squad [Lv. 525]", "Shanda [Lv. 475]"}) 
    elseif Sea2 and _G.ServerData["PlayerBackpack"]['Hidden Key'] and not _G.ServerData["Inventory Items"]["Rengoku"] then 
        if game.ReplicatedStorage.Remotes.CommF_:InvokeServer("OpenRengoku") then 
            return 
        end
        EquipWeaponName('Hidden Key')
        Tweento(CFrame.new(6571.1201171875, 299.23028564453, -6967.841796875)) 
    elseif Sea2 and (_G.ServerData["PlayerBackpack"]['Library Key'] and not _G.Config.IceCastleDoorPassed) or _G.ServerData["PlayerBackpack"]['Water Key'] then 
        if _G.ServerData["PlayerBackpack"]['Library Key'] then 
            EquipWeaponName('Library Key')
            Tweento(CFrame.new(
                6375.9126,
                296.634583,
                -6843.14062,
                -0.849467814,
                1.5493983e-08,
                -0.527640462,
                3.70608895e-08,
                1,
                -3.0301031e-08,
                0.527640462,
                -4.5294577e-08,
                -0.849467814
            ))
        else 
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuySharkmanKarate", true) 
        end
    elseif Sea2 and _G.ServerData['PlayerData'].Level >= 1350 and not _G.Config.IceCastleDoorPassed and _G.ServerData['PlayerData'].Level < 1425 and _G.ServerData['Server Bosses']['Awakened Ice Admiral'] then
        KillBoss(_G.ServerData['Server Bosses']['Awakened Ice Admiral']) 
    elseif Sea2 and _G.ServerData['PlayerData'].Level >= 1425 and not _G.Config.WaterkeyPassed and _G.ServerData['Server Bosses']['Tide Keeper'] then 
        KillBoss(_G.ServerData['Server Bosses']['Tide Keeper'])
    elseif _G.ServerData['PlayerData'].Level >= 200 and BOSSCP then 
        task.spawn(function()
            if Sea3 and not _G.LGBTCOLORQUEST then 
                local faired = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("HornedMan")
                _G.LGBTCOLORQUEST = typeof(faired) ~= 'string'
                if not _G.LGBTCOLORQUEST and faired:find(BOSSCP.Name) then 
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("HornedMan", "Bet")
                end
            end
        end)
        KillBoss(BOSSCP)
    elseif not _G.QuestKillPlayer and (_G.ServerData['PlayerData'].Level < 2550 or game.PlaceId ~= 7449423635 ) then
        FarmMobByLevel()
    else 
        if not game.Players.LocalPlayer.PlayerGui.Main:FindFirstChild("Quest").Visible then 
            FarmMobByLevel((function()
                local a = {2200,2250}
                return a[math.random(1,2)]
            end)())
        else 
            KillMobList({
                "Cookie Crafter",
                "Cake Guard",
                "Head Baker",
                "Baking Staff"
            })
        end
    end
end

repeat task.wait() until _G.EnLoaded 
_G.CurrentTask = ""  
_G.TaskUpdateTick = tick()  
_G.PirateRaidTick = 0
getgenv().CheckEnabling = function(taskName)
    return _G.SavedConfig and _G.SavedConfig['Actions Allowed'] and (_G.SavedConfig['Actions Allowed'][taskName] or _G.SavedConfig[taskName])
end
getgenv().refreshTask = function() 
    if tick()-_G.TaskUpdateTick >= 60 then 
        _G.CurrentTask = ''
    end
    if not SaberQuest or not SaberQuest.KilledShanks then 
        getgenv().SaberQuest = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ProQuestProgress")
    end
    if not _G.Config then 
        _G.Config = {}
    end
    if not _G.Config.OwnedItems then 
        _G.Config.OwnedItems = {}
    end
    if _G.CurrentTask == '' and _G.Config.OwnedItems.LoadedFr then  
        if _G.ServerData["PlayerBackpack"]['Special Microchip'] or CheckIsRaiding() then 
            _G.CurrentTask = 'Auto Raid'
        elseif _G.ServerData['PlayerData'].DevilFruit == '' and _G.SnipeFruit and _G.FruitSniping and _G.CanEatFruit then 
            _G.CurrentTask = 'Eat Fruit'
        elseif #_G.ServerData['Workspace Fruits'] > 0 then 
            _G.CurrentTask = 'Collect Fruit' 
        elseif Sea3 and _G.CurrentElite and (not _G.Config.OwnedItems["Yama"] and not _G.ServerData['Server Bosses']['rip_indra True Form'])  then 
            _G.CurrentTask = 'Hunting Elite'  
        elseif Sea3 and CheckEnabling('Cursed Dual Katana') and _G.ServerData['PlayerData'].Level >= 2000 and not _G.Config.OwnedItems["Tushita"] and (_G.ServerData['Server Bosses']['rip_indra True Form'] or (getgenv().TushitaQuest and getgenv().TushitaQuest.OpenedDoor)) then 
            _G.CurrentTask = 'Getting Tushita'
        elseif Sea3 and CheckEnabling('Cursed Dual Katana') and not _G.Config.OwnedItems["Yama"] and (_G.ServerData['PlayerData']["Elite Hunted"] >= 30 or _G.ServerData['PlayerData'].Level >= 2200) then 
            _G.CurrentTask = 'Getting Yama' 
        elseif Sea3 and CheckEnabling('Cursed Dual Katana') and _G.CDKQuest and _G.CDKQuest ~= '' then 
            _G.CurrentTask = 'Getting Cursed Dual Katana' 
        elseif Sea3 and CheckEnabling('Mirage Puzzle') and _G.RaceV4Progress and _G.ServerData['PlayerData'].RaceVer == "V3" and _G.Config.OwnedItems['Mirror Fractal'] and _G.Config.OwnedItems['Valkyrie Helm'] and (_G.RaceV4Progress < 4 or (game:GetService("Workspace").Map:FindFirstChild("MysticIsland") and not game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CheckTempleDoor"))) then 
            _G.CurrentTask = 'Unlocking Mirage Puzzle'
        elseif (Sea2 or Sea3) and CheckEnabling('Upgrading Race') and _G.ServerData['PlayerData'].Beli >= 2000000 and _G.ServerData['PlayerData'].Level >= 2550 and not table.find({"Ghoul"},_G.ServerData['PlayerData'].Race) and (_G.ServerData['PlayerData'].RaceVer == 'V2') then 
            _G.CurrentTask = 'Auto Race V3'
        elseif _G.ServerData['PlayerData'].Level > 200 and CheckEnabling('Saber') and not (_G.Config.OwnedItems["Saber"]) and ((SaberQuest and not SaberQuest.UsedRelic) or _G.ServerData['PlayerData'].Level >= 550) then 
            _G.CurrentTask = 'Saber Quest'
        elseif _G.Config and CheckEnabling('Soul Guitar') and _G.Config["Melee Level Values"] and (_G.Config["Melee Level Values"]['Godhuman'] > 0 or _G.ServerData['PlayerData'].Level >= 2400) and _G.ServerData['PlayerData'].Level >= 2300 and not _G.Config.OwnedItems["Soul Guitar"] then 
            _G.CurrentTask = 'Getting Soul Guitar'
        elseif Sea3 and (_G.ServerData['Server Bosses']['Soul Reaper'] or _G.ServerData["PlayerBackpack"]['Hallow Essence']) and (not _G.ServerData["Inventory Items"]["Alucard Fragment"] or _G.ServerData["Inventory Items"]["Alucard Fragment"].Count ~= 5) then 
            _G.CurrentTask = 'Getting Hallow Scythe'
        elseif Sea3 and CheckEnabling('Mirror Fractal') and ((_G.ServerData['PlayerBackpack']["God's Chalice"] or _G.ServerData['PlayerBackpack']["Sweet Chalice"] ) or _G.ServerData['PlayerData'].Level >= 2550) and not _G.Config.OwnedItems["Mirror Fractal"] then
            _G.CurrentTask = 'Auto Dough King'
        elseif _G.ServerData['PlayerData'].Level > 150 
        and CheckEnabling('Pole (1st Form)') and not _G.Config.OwnedItems["Pole (1st Form)"] 
        and (_G.ServerData['Server Bosses']['Thunder God']) then 
            _G.CurrentTask = 'Pole Quest'
        elseif game.PlaceId == 2753915549 and _G.ServerData['PlayerData'].Level >= 700 and game.ReplicatedStorage.Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Dressrosa") ~= 0 then 
            _G.CurrentTask = 'Sea 2 Quest'
            print('Sea 1',Sea1)
            print('Sea2',Sea2)
            print('Sea 3',Sea3)
        elseif Sea3 and (_G.CakePrince or (_G.ServerData['Server Bosses']['Cake Prince'] or _G.ServerData['Server Bosses']['Dough King'] ))  then 
            _G.CurrentTask = 'Cake Prince Raid Boss Event'
        elseif (Sea2 or Sea3) and (_G.ServerData['Server Bosses']['Core'] or (Sea3 and _G.PirateRaidTick and tick()-_G.PirateRaidTick < 60)) then 
            _G.CurrentTask = '3rd Sea Event'
        elseif Sea2 and _G.ServerData['PlayerData'].Level >= 850 and game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") ~= 3 then
            _G.CurrentTask = 'Bartilo Quest'
        elseif Sea2 and _G.ServerData['PlayerData'].Level >= 1500 and game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ZQuestProgress", "Zou") ~= 0 then 
            _G.CurrentTask = 'Auto Sea 3' 
        elseif (Sea2 or Sea3) and (_G.RaidBossEvent or _G.ServerData['Server Bosses']['Darkbeard'] or _G.ServerData['Server Bosses']['rip_indra True Form']) then 
            _G.CurrentTask = 'Auto Raid Boss' 
        elseif Sea3 and (_G.ServerData['PlayerBackpack']["God's Chalice"] and (not UnCompleteColor() or HasColor(UnCompleteColor().BrickColor.Name))) then 
            _G.CurrentTask = "Using God's Chalice"
        elseif CheckEnabling('Upgrading Race') and _G.ServerData['PlayerData'].Beli >= 500000 and _G.Config.OwnedItems["Warrior Helmet"] and _G.ServerData['PlayerData'].RaceVer == 'V1' then 
            _G.CurrentTask = 'Race V2 Quest' 
        end  
        _G.TaskUpdateTick = tick()
    end
end 
local rF1,rF2 
task.spawn(function()
    while task.wait(.5) do 
        rF1,rF2  = pcall(function()
            refreshTask() 
        end)
        if not rF1 then 
            warn('Refreshing task error:',rF2)
        end
    end
end)    
if hookfunction then  
    task.spawn(function()
        local gameNgu = {}
        if game.PlaceId == 2753915549 then  
            gameNgu = {
                Workspace.Map.SkyArea1.PathwayTemple.Entrance,
                Workspace.Map.TeleportSpawn.Entrance,
                Workspace.Map.TeleportSpawn.Exit,
                Workspace.Map.SkyArea2.PathwayHouse.Exit,
            }
            
        elseif game.PlaceId == 4442272183 then 
            gameNgu = {
                Workspace.Map.Dressrosa.FlamingoExit,
                Workspace.Map.Dressrosa.FlamingoEntrance,
                Workspace.Map.GhostShip.Teleport,
                Workspace.Map.GhostShipInterior.Teleport,
            }
        else
            gameNgu = {
                Workspace.Map.Turtle.Entrance.Door.BossDoor.Hitbox,
                Workspace.Map.Turtle.MapTeleportB.Hitbox,
                Workspace.Map.Turtle.Cursed.EntranceTouch,
                Workspace.Map.Waterfall.MapTeleportA.Hitbox,
                Workspace.Map.Waterfall.BossRoom.Door.BossDoor.Hitbox,
                Workspace.Map['Boat Castle'].MapTeleportB.Hitbox,
                Workspace.Map['Boat Castle'].MapTeleportA.Hitbox,
                Workspace.Map['Temple of Time'].ClockRoomExit,
            }  
        end
        table.foreach(gameNgu,function(i,v)
            for i2,v2 in getconnections(v.Touched) do 
                v2:Disable()
            end
        end)
    end)
    task.delay(2,function()
        require(game.ReplicatedStorage.Notification).new = function(v1,v2) 
            v1 = tostring(v1):gsub("<Color=[^>]+>", "") 
            local Nof = game.Players.LocalPlayer.Character:FindFirstChild('Notify') or (function() 
                if not game.Players.LocalPlayer.Character:FindFirstChild('Notify') then 
                    local nof = Instance.new('StringValue',game.Players.LocalPlayer.Character)
                    nof.Name = 'Notify'
                    nof.Value = ''
                    return nof
                end 
            end)()
            Nof.Value = v1 
            local FakeLOL = {}
            function FakeLOL.Display(p18)
                return true;
            end; 
            function FakeLOL.Dead()
            end
            return FakeLOL
        end
        task.delay(3,function() 
            warn('Disabling effects') 
            if hookfunction and not islclosure(hookfunction) then 
                for i,v in pairs(game.ReplicatedStorage.Assets.GUI:GetChildren()) do 
                    v.Enabled = false 
                end
                hookfunction(require(game:GetService("ReplicatedStorage").Effect.Container.Death), function()end)
                hookfunction(require(game:GetService("ReplicatedStorage").Effect.Container.Respawn), function()end)
                hookfunction(require(game:GetService("ReplicatedStorage"):WaitForChild("GuideModule")).ChangeDisplayedNPC,function() end) 
            end
        end)
    end)
end
if getgenv().AutoRejoin or AutoRejoin then 
    print('adding auto rejoin')
    _G.rejoin = game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(
        child)
        if not _G.SwitchingServer and child.Name == 'ErrorPrompt' and child:FindFirstChild('MessageArea') and child.MessageArea:FindFirstChild("ErrorFrame") then
            wait()
            print('not _G.SwitchingServer',not _G.SwitchingServer)
            local CurrentErrorTitle = child.TitleFrame.ErrorTitle.Text
            local CurrentErrorMessage = child.MessageArea.ErrorFrame.ErrorMessage.Text 
            if CurrentErrorTitle ~= 'Teleport Failed' and not Hopping then 
                Hopping = true 
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)  
            end
        end
    end)
end
local Tiers = {
    "Soul Guitar",  
    'Cursed Dual Katana',
    'Mirror Fractal',
    'Upgrading Race',
    'Mirage Puzzle',
    --'Rainbown Haki'
}
local Skypieaniggalist = {}
getSkypieas = function()
    local reutrner = {}
    local Race
    for i,v in game.Players:GetChildren() do 
        Race = v:WaitForChild('Data'):WaitForChild('Race').Value 
        if Race == 'Skypiea' and not table.find(Skypieaniggalist,v.Name) then 
            table.insert(reutrner,v.Name)
        end 
    end
    return reutrner
end
getSkypiea = function()
    local skys = getSkypieas()
    if #skys > 0 then
        local choss
        local maxva = 2550 
        for i,v in pairs(skys) do 
            if game.Players[v].Data.Level.Value < maxva then 
                maxva = game.Players[v].Data.Level.Value 
                choss = v 
            end 
        end
        return choss
    end
end
AutoMiragePuzzle = function()
    if _G.ServerData['PlayerData'].RaceVer == "V3" and _G.Config.OwnedItems['Mirror Fractal'] and _G.Config.OwnedItems['Valkyrie Helm'] then 
        if not Sea3 then 
            TeleportWorld(3)
        else
            _G.RaceV4Progress = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "Check")
            if _G.RaceV4Progress==1 then 
                SetContent(tostring(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "Begin")))
            elseif _G.RaceV4Progress == 2 then 
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
                    "requestEntrance",
                    Vector3.new(28282.5703125, 14896.8505859375, 105.1042709350586)
                )
                local AllNPCS = getnilinstances()
                for i, v in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
                    table.insert(AllNPCS, v)
                end
                for i, v in pairs(AllNPCS) do
                    if v.Name == "Mysterious Force" then
                        TempleMysteriousNPC1 = v
                    end
                    if v.Name == "Mysterious Force3" then
                        TempleMysteriousNPC2 = v
                    end
                end
                Tweento(TempleMysteriousNPC2.HumanoidRootPart.CFrame)
                wait(0.5)
                if
                    (TempleMysteriousNPC2.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <
                        15
                 then
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "TeleportBack")
                end
                if
                    (TempleMysteriousNPC1.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <
                        15
                 then
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "Teleport")
                end
            elseif _G.RaceV4Progress == 3 then 
                SetContent(tostring(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "Continue")))
            elseif _G.RaceV4Progress == 4 then
                if game.workspace.Map:FindFirstChild("MysticIsland") and not game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CheckTempleDoor") then
                    if IsPlayerAlive() then 
                        local BlueGear = getBlueGear()
                        local HighestPoint = getHighestPoint() and getHighestPoint().CFrame * CFrame.new(0, 211.88, 0)
                        if BlueGear and BlueGear.Transparency ~= 1 then 
                            repeat 
                                task.wait()
                                if IsPlayerAlive() then 
                                    local BlueGearCaller,BlueGearCaller2 = pcall(function()
                                        for i,v in BlueGear:GetDescendants() do 
                                            if v.ClassName == 'TouchTransmitter' then 
                                                firetouchinterest(v.Parent, game.Players.LocalPlayer.Character.HumanoidRootPart, 0)
                                                firetouchinterest(v.Parent, game.Players.LocalPlayer.Character.HumanoidRootPart, 1)
                                            end
                                        end
                                    end)
                                    SetContent('Getting Blue Gear...')
                                    if not BlueGearCaller then 
                                        print('BlueGearCaller2',BlueGearCaller2)
                                    end
                                    Tweento(BlueGear.CFrame)
                                end
                            until not BlueGear or not BlueGear.Parent or BlueGear.Transparency == 1 
                        elseif BlueGear and BlueGear.Transparency == 1 then 
                            if HighestPoint then 
                                Tweento(HighestPoint)
                                if GetDistance(HighestPoint) < 10 then 
                                    SetContent('Looking at moon...')
                                    workspace.CurrentCamera.CFrame =
                                        CFrame.new(
                                        workspace.CurrentCamera.CFrame.Position,
                                        game:GetService("Lighting"):GetMoonDirection() + workspace.CurrentCamera.CFrame.Position
                                    )
                                    wait()
                                    SendKey("T",.5)
                                end
                            end
                        elseif HighestPoint then 
                            if game.Lighting.ClockTime < 18 and game.Lighting.ClockTime > 5 then
                                TimetoNight = (18 - game.Lighting.ClockTime)*60 
                                TimeInS = math.floor(TimetoNight%60)
                                TimeInM = TimetoNight/60
                                if TimeInM <= 0 then 
                                    SetContent('Waiting '..tostring(TimeInS).."s to night.")
                                else 
                                    SetContent("Waiting "..tostring(TimeInM)..":"..tostring(TimeInS).." to night.")
                                end
                            end
                            Tweento(HighestPoint)
                        end
                    end
                end
            else
                _G.CurrentTask = ''
            end
        end
    end
end
FindNextTaskTier = function()
    if _G.Config["Melee Level Values"]['Godhuman'] then 
        for __,taskK in Tiers do 
            if table.find(_G.GUIConfig["Allowed Actions"],taskK) then 
                if __ < 4 then 
                    if _G.Config.OwnedItems[taskK] then 
                        table.remove(Tiers,__)
                    end
                elseif taskK == 'Upgrading Race' then 
                    if _G.ServerData['PlayerData'].RaceVer ~= "V3" and _G.ServerData['PlayerData'].RaceVer ~= 'V4' then 
                        return taskK 
                    else
                        table.remove(Tiers,__)
                    end
                elseif taskK == 'Mirage Puzzle' then 
                    if not game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CheckTempleDoor") then 
                        return taskK
                    else
                        table.remove(Tiers,__)
                    end
                elseif taskK == 'Rainbown Haki' then 

                end
            end
        end
    end 
end
AutoDoughKing = function()
    local CP = _G.ServerData['Server Bosses']['Dough King'] or _G.ServerData['Server Bosses']['Cake Prince']
    if CP then 
        if _G.SpamSpawnCakePrince then 
            _G.SpamSpawnCakePrince:Disconnect()
            _G.SpamSpawnCakePrince = nil 
        end
        KillBoss(CP)
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
            "RaidsNpc",
            "Select",
            "Dough"
        )
    elseif _G.ServerData["PlayerBackpack"]['Sweet Chalice'] then 
        local MobLeft = tonumber(string.match(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CakePrinceSpawner", true),'%d+')) or 0
        task.spawn(function()
            if MobLeft <= 8 then
                if not _G.SpamSpawnCakePrince then 
                    _G.SpamSpawnCakePrince = game.RunService.Heartbeat:Connect(function()
                        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CakePrinceSpawner") 
                    end)
                end
            elseif MobLeft >= 400 then 
                if _G.SpamSpawnCakePrince then 
                    _G.SpamSpawnCakePrince:Disconnect()
                    _G.SpamSpawnCakePrince = nil 
                end
            end
        end)
        if MobLeft > 0 then 
            KillMobList({
                "Cookie Crafter",
                "Cake Guard",
                "Head Baker",
                "Baking Staff"
            })
        end
    elseif _G.ServerData["PlayerBackpack"]["God's Chalice"] then 
        if CheckMaterialCount('Conjured Cocoa') >= 10 then 
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("SweetChaliceNpc")
        else
            KillMobList({
                "Cocoa Warrior",
                "Chocolate Bar Battler"
            })
        end
    elseif CheckMaterialCount('Conjured Cocoa') < 10 then 
        KillMobList({
            "Cocoa Warrior",
            "Chocolate Bar Battler"
        })
    else
        if _G.CurrentElite then  
            if
                not string.find(
                    game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,
                    _G.CurrentElite.Name
                ) or
                    not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible
                then
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
                    "AbandonQuest"
                )
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
                    "EliteHunter"
                )
            end
            KillBoss(_G.CurrentElite)
        else
            HopServer(10,true,'Elite (Auto Dough King)')
        end
    end
end
AutoV3 = function()  
    if _G.ServerData['PlayerData'].RaceVer == "V3" then 
        _G.CurrentTask = ''
        return 
    elseif _G.ServerData['PlayerData'].Beli <2000000 then 
        _G.CurrentTask = ''
        return 
    elseif not Sea2 then 
        TeleportWorld(2)
    else 
        local CurrentR = _G.ServerData['PlayerData'].Race  
        local v113 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "1")
        if v113 == 0 then
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "2")
        end
        if CurrentR == 'Human' then  
            if _G.ServerData['Server Bosses']['Diamond'] and _G.ServerData['Server Bosses']['Jeremy'] and _G.ServerData['Server Bosses']['Fajita'] then 
                repeat 
                    task.wait() 
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "3")
                    if _G.ServerData['Server Bosses']['Diamond'] then 
                        KillBoss(_G.ServerData['Server Bosses']['Diamond'])
                    elseif _G.ServerData['Server Bosses']['Jeremy'] then 
                        KillBoss(_G.ServerData['Server Bosses']['Jeremy'])
                    elseif _G.ServerData['Server Bosses']['Fajita'] then 
                        KillBoss(_G.ServerData['Server Bosses']['Fajita']) 
                    end
                    task.wait()
                until not _G.ServerData['Server Bosses']['Diamond'] and not _G.ServerData['Server Bosses']['Jeremy'] and not _G.ServerData['Server Bosses']['Fajita'] 
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "3")
                SetContent('NIGGA ON FIRE 🔥🔥🔥')
                TeleportWorld(3)
            else
                HopServer(10,true,"Find 3 bosses to get Human V3")
            end 
        elseif CurrentR == 'Cyborg' then  
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "3") 
            local CheckAgain = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "1")
            if CheckAgain and CheckAgain == 1 then 
                local FruitBelow1M = getFruitBelow1M()
                if FruitBelow1M then 
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadFruit", FruitBelow1M) 
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "3") 
                end 
            end 
        elseif CurrentR == 'Mink' then 
            repeat 
                local NearestChest = getNearestChest()
                if NearestChest then 
                    PickChest(NearestChest) 
                else
                    warn('Not Chest')
                end 
                task.wait(.1)
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "3") 
            until game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "1") ~= 1
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "3") 
        elseif CurrentR == 'Fishman' then 
            repeat 
                task.wait()
                AutoSeaBeast()
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "3") 
            until _G.ServerData['PlayerData'].RaceVer == "V3"
            print('nqu')
        elseif CurrentR == 'Skypiea' then 
            if #getSkypieas() > 0 then
                local Skypiea = getSkypiea()
                if Skypiea then
                    if not KillPlayer(Skypiea) then 
                        table.insert(Skypieaniggalist,Skypiea)
                    end
                end
            else
                HopServer(10,false,'Finding skypieas players')
            end
        end
    end
end
AutoCDK = function(questTitle) 
    SetContent(questTitle)
    if questTitle ~= 'Soul Reaper' and _G.WeaponType ~= 'Sword' then 
        _G.WeaponType = 'Sword'
    end
    LoadItem('Tushita')
    if questTitle == 'The Final Boss' then  
        repeat 
            task.wait()
            if GetDistance(game:GetService("Workspace").Map.Turtle.Cursed.Pedestal3) > 10 and game:GetService("Workspace").Map.Turtle.Cursed.PlacedGem.Transparency ~= 0 then
                Tweento(game:GetService("Workspace").Map.Turtle.Cursed.Pedestal3.CFrame * CFrame.new(0, 0, -2)) 
            end 
            if game:GetService("Workspace").Map.Turtle.Cursed.PlacedGem.Transparency == 0 then 
                if not _G.ServerData['Server Bosses']['Cursed Skeleton Boss'] then
                    Tweento(CFrame.new(-12341.66796875, 603.3455810546875, -6550.6064453125),true)
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CDKQuest", "SpawnBoss")
                else
                    KillBoss(_G.ServerData['Server Bosses']['Cursed Skeleton Boss'])
                    _G.CurrentTask = ''
                end
            else 
                if GetDistance(game:GetService("Workspace").Map.Turtle.Cursed.Pedestal3) < 10 and game:GetService("Workspace").Map.Turtle.Cursed.Pedestal3.ProximityPrompt.Enabled then 
                    fireproximityprompt(game:GetService("Workspace").Map.Turtle.Cursed.Pedestal3.ProximityPrompt) 
                    task.wait(1)
                    for i,v in pairs(game.workspace.Enemies:GetChildren()) do 
                        pcall(function()
                            if v and v.PrimaryPart and GetDistance(v.PrimaryPart) <= 1000 and v:FindFirstChildOfClass('Humanoid') and v:FindFirstChildOfClass('Humanoid').Health > 0 then 
                                v:FindFirstChildOfClass('Humanoid').Health = 0 
                            end
                        end)
                    end
                end
            end 
        until _G.Config.OwnedItems["Cursed Dual Katana"]
        _G.CurrentTask = ''
        _G.CDKQuest = ''
    elseif questTitle == 'Pedestal1' then 
        if GetDistance(game:GetService("Workspace").Map.Turtle.Cursed["Pedestal1"]) < 10 then
            fireproximityprompt(game:GetService("Workspace").Map.Turtle.Cursed['Pedestal1'].ProximityPrompt)
        else
            Tweento(game:GetService("Workspace").Map.Turtle.Cursed['Pedestal1'].CFrame * CFrame.new(0, 0, -2))
        end
    elseif questTitle == 'Pedestal2' then  
        if GetDistance(game:GetService("Workspace").Map.Turtle.Cursed["Pedestal2"]) < 10 then
            fireproximityprompt(game:GetService("Workspace").Map.Turtle.Cursed['Pedestal2'].ProximityPrompt)
        else
            Tweento(game:GetService("Workspace").Map.Turtle.Cursed['Pedestal2'].CFrame * CFrame.new(0, 0, -2))
        end
    elseif questTitle == 'Tushita Dimension' then 
        local Torch
        local CurrentCFrame
        local TickTorch
        repeat task.wait()
            if game:GetService("Workspace").Map.HeavenlyDimension.Exit.BrickColor == BrickColor.new("Cloudy grey") then 
                if _G.KillAuraConnection then 
                    _G.KillAuraConnection:Disconnect()
                    _G.KillAuraConnection = nil 
                end
                Tweento(game:GetService("Workspace").Map.HeavenlyDimension.Exit.CFrame)
                wait(2) 
            else
                if CheckTorchDimension("Tushita") then 
                    Torch = CheckTorchDimension("Tushita")
                    Tweento(Torch.CFrame)  
                    wait(.5)
                    fireproximityprompt(Torch.ProximityPrompt)  
                    CurrentCFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame 
                    TickTorch = tick()
                    if not _G.KillAuraConnection then 
                        _G.KillAuraConnection = workspace.Enemies.ChildAdded:Connect(function(v)  
                            sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", 3000+300)   
                            local V5Hum = v:FindFirstChildOfClass('Humanoid') or v:WaitForChild('Humanoid')
                            if V5Hum then 
                                V5Hum.Health = 0 
                                repeat 
                                    V5Hum.Health = 0 
                                    task.wait(1)
                                until not V5Hum or not V5Hum.Parent or not V5Hum.Parent.Parent
                
                            end
                        end) 
                    end
                    repeat task.wait()
                        for i,v in pairs(workspace.Enemies:GetChildren()) do 
                            pcall(function()
                                if v:FindFirstChildOfClass('Humanoid') then 
                                    v:FindFirstChildOfClass('Humanoid').Health = 0 
                                end
                            end) 
                        end
                        Tweento(CurrentCFrame * CFrame.new(0,250,0))
                    until not NearestMob(1500) or tick()-TickTorch >= 5
                    Tweento(CurrentCFrame)
                    if _G.KillAuraConnection then 
                        _G.KillAuraConnection:Disconnect()
                        _G.KillAuraConnection = nil 
                    end
                end
            end
            task.wait()
        until not IsPlayerAlive() or GetDistance(game:GetService("Workspace")["_WorldOrigin"].Locations["Heavenly Dimension"]) > 2000
    elseif questTitle == 'Cake Queen' then 
        if _G.ServerData['Server Bosses']['Cake Queen'] then 
            CDKTICK = tick()
            repeat task.wait()
                KillBoss(_G.ServerData['Server Bosses']['Cake Queen'])  
                wait(1)
                CDKTICK = tick()
            until GetDistance(game:GetService("Workspace")["_WorldOrigin"].Locations["Heavenly Dimension"]) <= 2000 or tick()-CDKTICK >= 30
        elseif not _G.DimensionLoading then
            wait(1)
            if _G.DimensionLoading then return end
            SetContent('Hopping for Cake Quen',5)
            HopServer(10,true,"Cake Queen")
        end 
    elseif questTitle == 'Tushita Quest -4' then 
        if _G.PirateRaidTick and tick()-_G.PirateRaidTick < 60 then 
            Auto3rdEvent() 
        else
            if FindAndJoinServer then  
                FindAndJoinServer('seaevent','spot',function(v,rt)
                    return rt-v.FoundOn < 20
                end)
            else
                loadstring(game:HttpGet('https://raw.githubusercontent.com/memaybeohub/NewPage/main/FinderServerLoading.lua'))()
            end
            AutoL()
        end
    elseif questTitle == 'Tushita Quest -3' then 
        for v50, v51 in pairs(getnilinstances()) do
            if v51.Name:match("Luxury Boat Dealer") then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v51.HumanoidRootPart.CFrame
                local args = {
                    [1] = "CDKQuest",
                    [2] = "BoatQuest",
                    [3] = workspace.NPCs:FindFirstChild("Luxury Boat Dealer")
                }
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
            end
        end
    elseif questTitle == 'Yama Dimension' then 
        local Torch
        local CurrentCFrame
        local TickTorch
        repeat task.wait()
            if not _G.DoneHell then 
                if game:GetService("Workspace").Map.HellDimension.Exit.BrickColor == BrickColor.new("Olivine") then 
                    repeat 
                        if GetDistance(game:GetService("Workspace")["_WorldOrigin"].Locations["Hell Dimension"]) < 2000 then 
                            Tweento(game:GetService("Workspace").Map.HellDimension.Exit.CFrame)
                        end
                        if _G.KillAuraConnection then 
                            _G.KillAuraConnection:Disconnect()
                            _G.KillAuraConnection = nil 
                        end
                        _G.DoneHell = true
                        wait(2) 
                    until GetDistance(game:GetService("Workspace")["_WorldOrigin"].Locations["Hell Dimension"]) > 2000 
                    _G.CDKQuest = CheckQuestCDK()  
                else 
                    if CheckTorchDimension("Yama") then 
                        Torch = CheckTorchDimension("Yama")
                        task.spawn(SetContent,'Touching torch.')
                        Tweento(Torch.CFrame)  
                        wait(.5)
                        fireproximityprompt(Torch.ProximityPrompt)  
                        CurrentCFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame 
                        TickTorch = tick()
                        if not _G.KillAuraConnection then 
                            _G.KillAuraConnection = workspace.Enemies.ChildAdded:Connect(function(v)  
                                sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", 3000+300)   
                                local V5Hum = v:FindFirstChildOfClass('Humanoid') or v:WaitForChild('Humanoid')
                                if V5Hum then 
                                    V5Hum.Health = 0 
                                    repeat 
                                        V5Hum.Health = 0 
                                        task.wait(1)
                                    until not V5Hum or not V5Hum.Parent or not V5Hum.Parent.Parent
                    
                                end
                            end) 
                        end
                        repeat task.wait()
                            for i,v in pairs(workspace.Enemies:GetChildren()) do 
                                pcall(function()
                                    if v:FindFirstChildOfClass('Humanoid') then 
                                        v:FindFirstChildOfClass('Humanoid').Health = 0 
                                    end
                                end) 
                            end
                            Tweento(CurrentCFrame * CFrame.new(0,250,0))
                            task.wait()
                        until not NearestMob(1500) or tick()-TickTorch >= 5
                        Tweento(CurrentCFrame)
                    else
                        print('Not Torch Dimension yama')
                    end
                end
            end
        until GetDistance(game:GetService("Workspace")["_WorldOrigin"].Locations["Hell Dimension"]) > 2000 
    elseif questTitle == 'Soul Reaper' then 
        if _G.ServerData['Server Bosses']['Soul Reaper'] then 
            print('Soul Reaper Found')
            repeat 
                task.wait()
                if not _G.DimensionLoading then --and not (game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild('Hell Dimension') or GetDistance(game:GetService("Workspace")["_WorldOrigin"].Locations["Hell Dimension"]) < 1001) then 
                    if GetDistance(_G.ServerData['Server Bosses']['Soul Reaper'].PrimaryPart) > 300 then  
                        Tweento(_G.ServerData['Server Bosses']['Soul Reaper'].PrimaryPart.CFrame * CFrame.new(0,1.5,-1.5)) 
                        wait(3)
                    else
                        game.Players.LocalPlayer.Character.PrimaryPart.CFrame = _G.ServerData['Server Bosses']['Soul Reaper'].PrimaryPart.CFrame * CFrame.new(0,1.5,-1.5) 
                    end  
                end
            until _G.DimensionLoading or (game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild('Hell Dimension') and GetDistance(game:GetService("Workspace")["_WorldOrigin"].Locations["Hell Dimension"]) <= 1001) 
            if _G.DimensionLoading then 
                _G.DimensionLoading = false 
                wait(5)
            end
        elseif _G.ServerData["PlayerBackpack"]['Hallow Essence'] then 
            EquipWeapon("Hallow Essence")
            Tweento(game:GetService("Workspace").Map["Haunted Castle"].Summoner.Detection.CFrame)
            task.wait(1)
        else
            local v316, v317, v318, v319 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Bones", "Check")
            if v318 and v318 > 0 then 
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1) 
                if _G.ServerData['PlayerData'].Level >= 2000 then  
                    if not game.Players.LocalPlayer.PlayerGui.Main:FindFirstChild("Quest").Visible then 
                        FarmMobByLevel(2000)
                    else 
                        KillMobList({
                            "Reborn Skeleton [Lv. 1975]",
                            "Living Zombie [Lv. 2000]",
                            "Demonic Soul [Lv. 2025]",
                            "Posessed Mummy [Lv. 2050]"
                        })
                    end
                else 
                    KillMobList({
                        "Reborn Skeleton [Lv. 1975]",
                        "Living Zombie [Lv. 2000]",
                        "Demonic Soul [Lv. 2025]",
                        "Posessed Mummy [Lv. 2050]"
                    })
                end
            elseif v316 and v316 < 5000 then 
                if _G.ServerData['PlayerData'].Level >= 2000 then  
                    if not game.Players.LocalPlayer.PlayerGui.Main:FindFirstChild("Quest").Visible then 
                        FarmMobByLevel(2000)
                    else 
                        KillMobList({
                            "Reborn Skeleton [Lv. 1975]",
                            "Living Zombie [Lv. 2000]",
                            "Demonic Soul [Lv. 2025]",
                            "Posessed Mummy [Lv. 2050]"
                        })
                    end
                else 
                    KillMobList({
                        "Reborn Skeleton [Lv. 1975]",
                        "Living Zombie [Lv. 2000]",
                        "Demonic Soul [Lv. 2025]",
                        "Posessed Mummy [Lv. 2050]"
                    })
                end
            else
                AutoL()
            end  
        end
    elseif questTitle == 'Yama Quest -4' then 
        local MobSP = NearestHazeMob()
        if MobSP then 
            KillMobList({MobSP})
        end
        repeat 
            MobSP = NearestHazeMob()
            if MobSP then 
                KillMobList({MobSP})
            end
            task.wait()
        until _G.CDKQuest ~= 'Yama Quest -4'
    elseif questTitle == 'Yama Quest -3' then 
        if FindMobHasHaki() then 
            repeat 
                pcall(function()
                    task.wait()
                    Tweento(FindMobHasHaki().PrimaryPart.CFrame * CFrame.new(0,0,-2))
                end)
            until not IsPlayerAlive()
        else 
            print('not mob haki')
        end
    end        
end
AutoUseGodChalice = function()
    local UnCompleteColorr = UnCompleteColor()
    if not UnCompleteColorr then 
        EquipWeapon("God's Chalice") 
        Tweento(game:GetService("Workspace").Map["Boat Castle"].Summoner.Detection.CFrame)
        _G.CurrentTask = ''
    elseif HasColor(UnCompleteColorr.BrickColor.Name) then
        if UnCompleteColorr then 
            Tweento(UnCompleteColorr.CFrame)
        end
    end
end
AutoRaidBoss = function()
    local RaidBoss = _G.ServerData['Server Bosses']['Darkbeard'] or _G.ServerData['Server Bosses']['rip_indra True Form']
    if RaidBoss then 
        KillBoss(RaidBoss)
    else
        _G.RaidBossEvent =false
        _G.CurrentTask = ''
    end
end
AutoCakePrinceEvent = function()
    local CPB = _G.ServerData['Server Bosses']['Cake Prince'] or _G.ServerData['Server Bosses']['Dough King'] 
    if not CPB or not CPB:FindFirstChildOfClass('Humanoid') then 
        _G.CakePrince = false 
        _G.CurrentTask =''  
    else  
        KillBoss(CPB)
        _G.CurrentTask ='' 
    end
end
AutoHallowScythe = function()
    if _G.ServerData['Server Bosses']['Soul Reaper'] then 
        KillBoss(_G.ServerData['Server Bosses']['Soul Reaper'])
        _G.CurrentTask = ''
    elseif _G.ServerData["PlayerBackpack"]['Hallow Essence'] then
        EquipWeapon('Hallow Essence') 
        Tweento(game:GetService("Workspace").Map["Haunted Castle"].Summoner.Detection.CFrame)
        wait(1)
    end
end
AutoSoulGuitar = function() 
    if Sea1 then 
        TeleportWorld(3)
        return
    end
    local BlankTablets = {
        "Segment6",
        "Segment2",
        "Segment8",
        "Segment9",
        "Segment5"
    }
    local Trophy = {
        ["Segment1"] = "Trophy1",
        ["Segment3"] = "Trophy2",
        ["Segment4"] = "Trophy3",
        ["Segment7"] = "Trophy4",
        ["Segment10"] = "Trophy5",
    }
    local Pipes = {
        ["Part1"] = "Really black",
        ["Part2"] = "Really black",
        ["Part3"] = "Dusty Rose",
        ["Part4"] = "Storm blue",
        ["Part5"] = "Really black",
        ["Part6"] = "Parsley green",
        ["Part7"] = "Really black",
        ["Part8"] = "Dusty Rose",
        ["Part9"] = "Really black",
        ["Part10"] = "Storm blue",
    }
    local CurrnetPuzzle = game.ReplicatedStorage.Remotes["CommF_"]:InvokeServer("GuitarPuzzleProgress", "Check")
    if not _G.SoulGuitarPuzzlePassed then 
        _G.SoulGuitarPuzzlePassed = (function()
            local LLL = CurrnetPuzzle
            return LLL and LLL.Trophies and LLL.Ghost and LLL.Gravestones and LLL.Swamp and LLL.Pipes 
        end)()
    end 
    if not _G.SoulGuitarPuzzlePassed then 
        if not CurrnetPuzzle then  
            moonPhase = game:GetService("Lighting"):GetAttribute("MoonPhase")
            SetContent("Unlocking Soul Guitar's Puzzle (Praying Grave Stone)",5)
            if not Sea3 then 
                TeleportWorld(3)
            elseif (moonPhase == 5 or moonPhase == 4) and (moonPhase == 4 or (moonPhase == 5 and (game.Lighting.ClockTime > 12 or game.Lighting.ClockTime < 5))) then   
                if moonPhase == 5 and (game.Lighting.ClockTime >= 18 or game.Lighting.ClockTime < 5) then
                    Tweento(CFrame.new(-8654.314453125, 140.9499053955078, 6167.5283203125)) 
                    if GetDistance(CFrame.new(-8654.314453125, 140.9499053955078, 6167.5283203125)) < 10 then
                        CheckRemote = game.ReplicatedStorage.Remotes["CommF_"]:InvokeServer("gravestoneEvent", 2) 
                        if CheckRemote ~= true then return end 
                        require(game.ReplicatedStorage.Effect).new("BlindCam"):replicate({
                            Color = Color3.new(0.03, 0.03, 0.03), 
                            Duration = 2, 
                            Fade = 0.25, 
                            ZIndex = -10
                        });
                        require(game.ReplicatedStorage.Util.Sound):Play("Thunder", workspace.CurrentCamera.CFrame.p); 
                        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("gravestoneEvent", 2, true)
                        SetContent('Completed')  
                        return
                    end  
                else
                    AutoL()
                end
            else 
                print('Auto fm')
                if not AutoFullMoon then 
                    loadstring(game:HttpGet('https://raw.githubusercontent.com/memaybeohub/NewPage/main/AutoFullMoon.lua'))()
                else
                    AutoFullMoon()
                end
            end 
        elseif not CurrnetPuzzle.Swamp then  
            SetContent("Unlocking Soul Guitar's Puzzle (Swamp: Kill 6 Zombie at same time)",5)
            if not Sea3 then 
                TeleportWorld(3)
            elseif GetDistance(CFrame.new(-10171.7607421875, 138.62667846679688, 6008.0654296875)) > 300 then
                Tweento(CFrame.new(-10171.7607421875, 138.62667846679688, 6008.0654296875) * CFrame.new(0,25,-20))
            else
                if CheckAnyPlayersInCFrame(CFrame.new(-10171.7607421875, 138.62667846679688, 6008.0654296875), 500) then
                    SetContent('Players In Area | Hopping for peace',5)
                    HopServer(10,true,"Peace Area")
                else
                    if (function() 
                        local Cos = 0   
                        for i ,v in pairs(game.workspace.Enemies:GetChildren()) do 
                            if RemoveLevelTitle(v.Name) == "Living Zombie" and v.Humanoid.Health > 0 then
                                if GetDistance(CFrame.new(-10171.7607421875, 138.62667846679688, 6008.0654296875),v.HumanoidRootPart) <= 20 then 
                                    Cos = 1
                                end
                            end
                        end
                        return Cos
                    end)() == 6 then
                        warn('Zombie Near')
                        for i, v in pairs(game.workspace.Enemies:GetChildren()) do
                            if
                                RemoveLevelTitle(v.Name) == "Living Zombie" and v:FindFirstChild("HumanoidRootPart") and
                                    v:FindFirstChild("Humanoid") and
                                    v.Humanoid.Health > 0
                            then
                                repeat
                                    wait()
                                    KillNigga(v)
                                until v.Humanoid.Health <= 0 or not v.Parent
                            end
                        end
                    else
                        warn('Not 6 Zombie');
                        (function()
                            for i, v in pairs(game.workspace.Enemies:GetChildren()) do
                                if RemoveLevelTitle(v.Name) == "Living Zombie" and v:FindFirstChild("Humanoid") and
                                        v:FindFirstChild("HumanoidRootPart") --and isnetworkowner(v.HumanoidRootPart)
                                    then
                                    v.HumanoidRootPart.CFrame = CFrame.new(-10171.7607421875, 138.62667846679688, 6008.0654296875)
                                    v.Humanoid:ChangeState(14)
                                    v.PrimaryPart.CanCollide = false
                                    v.Head.CanCollide = false
                                    v.Humanoid.WalkSpeed = 0
                                    v.Humanoid.JumpPower = 0
                                    if v.Humanoid:FindFirstChild("Animator") then
                                        v.Humanoid.Animator:Destroy()
                                    end
                                end
                            end
                        end)()
                    end
                end
            end
        elseif not CurrnetPuzzle.Gravestones then 
            print(game.ReplicatedStorage.Remotes["CommF_"]:InvokeServer("GuitarPuzzleProgress", "Gravestones"))
            SetContent("Unlocking Soul Guitar's Puzzle (Grave Stones: Clicking Signs)")
            if not Sea3 then 
                TeleportWorld(3)
            elseif GetDistance(CFrame.new(-8761.4765625, 142.10487365722656, 6086.07861328125)) > 50 then
                Tweento(CFrame.new(-8761.4765625, 142.10487365722656, 6086.07861328125))
            else
                local ClickSigns = {
                    game.workspace.Map["Haunted Castle"].Placard1.Right.ClickDetector,
                    game.workspace.Map["Haunted Castle"].Placard2.Right.ClickDetector,
                    game.workspace.Map["Haunted Castle"].Placard3.Left.ClickDetector,
                    game.workspace.Map["Haunted Castle"].Placard4.Right.ClickDetector,
                    game.workspace.Map["Haunted Castle"].Placard5.Left.ClickDetector,
                    game.workspace.Map["Haunted Castle"].Placard6.Left.ClickDetector,
                    game.workspace.Map["Haunted Castle"].Placard7.Left.ClickDetector
                }
                for i, v in pairs(ClickSigns) do
                    fireclickdetector(v)
                end
            end  
        elseif not CurrnetPuzzle.Ghost then 
            print(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Ghost"))
            SetContent("Unlocking Soul Guitar's Puzzle (Ghost: Talking to the ghost)") 
            if not Sea3 then 
                TeleportWorld(3)
            elseif GetDistance(CFrame.new(-9755.6591796875, 271.0661315917969, 6290.61474609375)) > 7 then
                Tweento(CFrame.new(-9755.6591796875, 271.0661315917969, 6290.61474609375))
                game.ReplicatedStorage.Remotes["CommF_"]:InvokeServer("GuitarPuzzleProgress", "Ghost") 
                wait(3)
            end 
        elseif not CurrnetPuzzle.Trophies then 
            print(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Trophies"))
            SetContent("Unlocking Soul Guitar's Puzzle (Trophies: Unlock the Trophies's Puzzle)") 
            if not Sea3 then 
                TeleportWorld(3)
            elseif GetDistance(CFrame.new(-9530.0126953125, 6.104853630065918, 6054.83349609375)) > 30 then
                Tweento(CFrame.new(-9530.0126953125, 6.104853630065918, 6054.83349609375)) 
            else 
                local DepTraiv4 = game.workspace.Map["Haunted Castle"].Tablet
                for i, v in pairs(BlankTablets) do
                    local x = DepTraiv4[v]
                    if x.Line.Position.X ~= 0 then
                        repeat
                            wait()
                            fireclickdetector(x.ClickDetector)
                        until x.Line.Position.X == 0
                    end
                end
                for i, v in pairs(Trophy) do
                    local x = game.workspace.Map["Haunted Castle"].Trophies.Quest[v].Handle.CFrame
                    x = tostring(x)
                    x = x:split(", ")[4]
                    local c = "180"
                    if x == "1" or x == "-1" then
                        c = "90"
                    end
                    if not string.find(tostring(DepTraiv4[i].Line.Rotation.Z), c) then
                        repeat
                            wait()
                            fireclickdetector(DepTraiv4[i].ClickDetector)
                        until string.find(tostring(DepTraiv4[i].Line.Rotation.Z), c)
                    end
                end
            end 
        elseif not CurrnetPuzzle.Pipes then 
            print(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Pipes"))
            SetContent("Unlocking Soul Guitar's Puzzle (Pipes)") 
            if not Sea3 then 
                TeleportWorld(3)
            else
                for i, v in pairs(Pipes) do
                    pcall(function()
                        local x = game.workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model[i]
                        if x.BrickColor.Name ~= v then
                            repeat
                                wait()
                                fireclickdetector(x.ClickDetector)
                            until x.BrickColor.Name == v
                        end
                    end) 
                end
            end 
        end 
    elseif CheckMaterialCount('Bones') < 500 then  
        SetContent('Farming Bones for soul guitar',5)
        if not Sea3 then 
            TeleportWorld(3) 
        else
            KillMobList({
                "Reborn Skeleton [Lv. 1975]",
                "Living Zombie [Lv. 2000]",
                "Demonic Soul [Lv. 2025]",
                "Posessed Mummy [Lv. 2050]"
            })
        end
    elseif CheckMaterialCount('Ectoplasm') < 250 then 
        SetContent('Farming ecotplasm for soul guitar',5)
        if not Sea2 then 
            TeleportWorld(2)
        else
            KillMobList({
                "Ship Deckhand [Lv. 1250]",
                "Ship Engineer [Lv. 1275]",
                "Ship Steward [Lv. 1300]",
                'Ship Officer'
            }) 
        end
    elseif CheckMaterialCount('Dark Fragment') < 1  then   
        if not _G.ChestCollect then _G.ChestCollect = 0 end
        if not Sea2 then 
            TeleportWorld(2)
        else
            if _G.ServerData['Server Bosses']['Darkbeard'] then
                KillBoss(_G.ServerData['Server Bosses']['Darkbeard'])
                TeleportWorld(3)
            elseif _G.ServerData["PlayerBackpack"]['Fist of Darkness'] then 
                if GetDistance(game:GetService("Workspace").Map.DarkbeardArena.Summoner.Detection) <= 5 then 
                    EquipWeaponName("Fist of Darkness")
                    pcall(
                        function()
                            firetouchinterest(
                                game:GetService("Workspace").Map.DarkbeardArena.Summoner.Detection,
                                game.Players.LocalPlayer.Character["Fist of Darkness"].Handle,
                                0
                            )
                            firetouchinterest(
                                game:GetService("Workspace").Map.DarkbeardArena.Summoner.Detection,
                                game.Players.LocalPlayer.Character["Fist of Darkness"].Handle,
                                1
                            )
                        end
                    )
                else 
                    Tweento(game:GetService("Workspace").Map.DarkbeardArena.Summoner.Detection.CFrame)
                end
            elseif _G.ChestCollect >= 20 then 
                HopServer(9,true,"Find new server for Fist of Darkness")
            else 
                local NearestChest = getNearestChest()
                if not NearestChest then 
                    SetContent('Ngu')
                end 
                if NearestChest then 
                    PickChest(NearestChest) 
                elseif #_G.ServerData['Chest'] <= 0 then 
                    HopServer(9,true,"Find Chest") 
                end
            end
        end
    elseif _G.ServerData['PlayerData'].Fragments < 5000 then  
        print('Frag < 5000')
        repeat 
            if not Sea3 then 
                TeleportWorld(3)
            else
                if _G.ServerData["PlayerBackpack"]['Special Microchip'] or _G.ServerData['Nearest Raid Island'] then
                    AutoRaid() 
                else
                    _G.FragmentNeeded =true 
                    buyRaidingChip()
                    AutoL()
                end
            end
            task.wait() 
        until _G.ServerData['PlayerData'].Fragments >= 5000
        print('req: ',_G.ServerData['PlayerData'].Fragments >= 5000)
        _G.FragmentNeeded =false 
    else
        if not Sea3 then 
            TeleportWorld(3)
        else
            game.ReplicatedStorage.Remotes["CommF_"]:InvokeServer("soulGuitarBuy", true)
            SetContent(tostring(game.ReplicatedStorage.Remotes["CommF_"]:InvokeServer("soulGuitarBuy")))
            wait(10)
            _G.CurrentTask = ''
        end
    end
end
AutoTushita = function()
    if not _G.Config.OwnedItems["Tushita"] then 
        task.spawn(function()
            getgenv().TushitaQuest = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("TushitaProgress");
        end)
        if _G.ServerData['Server Bosses']['rip_indra True Form'] then
            print('Rip India')
            if TushitaQuest.OpenedDoor then 
                if _G.ServerData['Server Bosses']['Longma'] then 
                    KillBoss(_G.ServerData['Server Bosses']['Longma'])
                    _G.CurrentTask = '' 
                else
                    HopServer(9,true,"Find Long Ma")
                end
            elseif not TushitaQuest.OpenedDoor then 
                TushitaTeusHubtQuestTick = tick()
                SetContent('Getting Holy Torch...')
                repeat 
                    game.Players.LocalPlayer.Character.PrimaryPart.CFrame = game:GetService("Workspace").Map.Waterfall.SecretRoom.Room.Door.Door.Hitbox.CFrame
                    task.wait()
                until _G.ServerData["PlayerBackpack"]['Holy Torch']
                SetContent('Got Holy Torch.')
                game.Players.LocalPlayer.Character.PrimaryPart.Anchored = false 
                task.spawn(function()
                    for i,v in TushitaQuest.Torches do 
                        if not v then 
                            task.spawn(function()
                                game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("TushitaProgress", "Torch", i)
                            end)
                        end
                    end
                end)
                task.wait()
                print('Tushita Door Opened:',TushitaQuest.OpenedDoor)
                if TushitaTeusHubtQuestTick then 
                    print('Done tushita in',tick() - (TushitaTeusHubtQuestTick or 0))
                end
                task.wait()
                repeat 
                    task.wait()
                    if _G.ServerData['Server Bosses']['rip_indra True Form'] then 
                        KillBoss(_G.ServerData['Server Bosses']['rip_indra True Form'])
                    end
                    task.wait()
                until not _G.ServerData['Server Bosses']['rip_indra True Form']
                wait()
            else
                KillBoss(_G.ServerData['Server Bosses']['rip_indra True Form'])
            end
        elseif TushitaQuest.OpenedDoor then 
            if _G.ServerData['Server Bosses']['Longma'] then 
                KillBoss(_G.ServerData['Server Bosses']['Longma'])
                _G.CurrentTask = '' 
            elseif not _G.Config.OwnedItems["Tushita"] then
                HopServer(9,true,"Find Long Ma")
            end
        end
    else 
        print('Already Tushita')
        _G.CurrentTask = '' 
    end
end
AutoYama = function()
    if Sea3 then 
        if _G.ServerData['PlayerData']["Elite Hunted"] >= 30 then  
            if GetDistance(game.Workspace.Map.Waterfall.SealedKatana.Handle.CFrame) > 50 then 
                SetContent('Tweening to temple to get yama...')
                Tweento(game.Workspace.Map.Waterfall.SealedKatana.Handle.CFrame * CFrame.new(0, 20, 0))
            else
                repeat 
                    task.wait()
                    repeat 
                        task.wait()
                        for i,v in pairs(workspace.Enemies:GetChildren()) do 
                            if v:FindFirstChildOfClass('Humanoid') then 
                                v:FindFirstChildOfClass('Humanoid').Health = 0 
                            end 
                        end  
                    until not game.Workspace.Enemies:FindFirstChild("Ghost [Lv. 1500]")
                    if not game.Workspace.Enemies:FindFirstChild("Ghost [Lv. 1500]") then
                        SetContent('Getting Yama')
                        fireclickdetector(game.Workspace.Map.Waterfall.SealedKatana.Handle.ClickDetector)
                    end
                until _G.Config.OwnedItems["Yama"] 
                _G.CurrentTask = '' 
            end 
        elseif _G.CurrentElite then 
            if
                not string.find(
                    game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,
                    _G.CurrentElite.Name
                ) or
                    not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible
                then
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
                    "AbandonQuest"
                )
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
                    "EliteHunter"
                )
            end
            KillBoss(_G.CurrentElite)
        else 
            print(Sea3 and _G.CurrentElite and not (_G.ServerData['PlayerData']["Elite Hunted"] or _G.ServerData['PlayerData']["Elite Hunted"] >= 30 or _G.ServerData['Server Bosses']['rip_indra True Form']))
            HopServer(9,true,'Elite, getting yama | Total Killed Elites: '..tostring(tonumber(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("EliteHunter", "Progress")) or 0))
        end
    end
end
AutoElite = function() 
    if _G.CurrentElite and _G.CurrentElite.Parent then  
        if
            not string.find(
                game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,
                _G.CurrentElite.Name
            ) or
                not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible
            then
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
                "AbandonQuest"
            )
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
                "EliteHunter"
            )
        else
            KillBoss(_G.CurrentElite)
            _G.CurrentTask = ''
        end
    else
        print('Not Elite')
        _G.CurrentElite = nil
        _G.CurrentTask = ''
    end
end
AutoSea3 = function()
    if Sea2 and _G.ServerData['PlayerData'].Level >= 1000 then  
        local v135 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("TalkTrevor", "1")
        if v135 and v135 ~= 0 then  
            if checkFruit1M() then 
                EquipWeaponName(checkFruit1M().Name)
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("TalkTrevor", "1")
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("TalkTrevor", "2")
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("TalkTrevor", "3")  
                return 
            end
            local v136666 = checkFruit1M(true) 
            if v136666 then 
                EquipWeaponName(v136666.Name)
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("TalkTrevor", "1")
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("TalkTrevor", "2")
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("TalkTrevor", "3")  
            elseif checkFruit1MWS() then  
                SetContent('Picking up '..getRealFruit(checkFruit1MWS()))
                Tweento(checkFruit1MWS().Handle.CFrame)
                task.wait(.1) 
                _G.CurrentTask = ''
            else 
                SetContent('Dont Have Fruit So We Must Farm')
                if _G.HopFruit1M then 
                    SetContent('Hoping for 1M Fruit',5)
                    HopServer(9,math.random(1,2) == 1)  
                end
                if _G.ServerData['Server Bosses']['Core'] then 
                    KillBoss(_G.ServerData['Server Bosses']['Core']) 
                elseif #_G.ServerData['Workspace Fruits'] > 0 then 
                    collectAllFruit_Store()
                else
                    AutoL()
                end
            end
        elseif v135 == 0 then
            local ZQuestProgress = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ZQuestProgress", "Check")
            if not ZQuestProgress then 
                if _G.ServerData['Server Bosses']['Don Swan'] then 
                    KillBoss(_G.ServerData['Server Bosses']['Don Swan'])
                else 
                    SetContent('Hopping for Don Swan',5)
                    HopServer(9,true,"Don Swan")
                end
            elseif ZQuestProgress == 0 and GetDistance(game:GetService("Workspace").Map.IndraIsland.Part) > 1000 then
                local RedHeadCFrame =
                    CFrame.new(
                    -1926.78772,
                    12.1678171,
                    1739.80884,
                    0.956294656,
                    -0,
                    -0.292404652,
                    0,
                    1,
                    -0,
                    0.292404652,
                    0,
                    0.956294656
                )
                if GetDistance(RedHeadCFrame) <= 50 then
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ZQuestProgress", "Begin")
                else
                    Tweento(RedHeadCFrame)
                end
            elseif _G.ServerData['Server Bosses']['rip_indra'] then 
                task.spawn(function()
                    while task.wait(0.1) do 
                        local timetry = 0 
                        if timetry > 500 then break end 
                        timetry=1 
                        local args = {
                            [1] = "TravelZou"
                        }
                        game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
                    end
                end)
                repeat 
                    KillBoss(_G.ServerData['Server Bosses']['rip_indra'])
                until not _G.ServerData['Server Bosses']['rip_indra']
            end 
        end
    end
end














AutoRaid = function()
    if _G.ServerData['Nearest Raid Island'] then 
        local RaidDis = GetDistance(_G.ServerData['Nearest Raid Island'])
        if RaidDis < 250 then
            game.Players.LocalPlayer.Character.PrimaryPart.CFrame = _G.ServerData['Nearest Raid Island'].CFrame  *CFrame.new(0,60,0) 
            _G.Ticktp = tick()
        elseif RaidDis < 4550 then
            Tweento(_G.ServerData['Nearest Raid Island'].CFrame  *CFrame.new(0,60,0)) 
        end
    elseif _G.ServerData["PlayerBackpack"]['Special Microchip'] then
        SetContent('Firing raid remote...',3)
        _G.NextRaidIslandId = 1
        if Sea2 then 
            --Tweento(CFrame.new(-12463.8740234375, 374.9144592285156, -7523.77392578125))
            fireclickdetector(Workspace.Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)  
        elseif Sea3 then 
            --Tweento(CFrame.new(923.21252441406, 126.9760055542, 32852.83203125))
            fireclickdetector(Workspace.Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector) 
        end
        if _G.ServerData["PlayerBackpack"]['Special Microchip'] then 
            _G.ServerData["PlayerBackpack"]['Special Microchip'] = nil 
        end
        wait(12) 
    end
    SetContent('Doing raid')   
    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", 3000+300)     
    if not _G.KillAuraConnection then 
        _G.KillAuraConnection = workspace.Enemies.ChildAdded:Connect(function(v)  
            sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", 3000+300)   
            local V5Hum = v:FindFirstChildOfClass('Humanoid') or v:WaitForChild('Humanoid',3)
            if V5Hum then 
                repeat 
                    V5Hum.Health = 0 
                    task.wait(1)
                until not V5Hum or not V5Hum.Parent or not V5Hum.Parent.Parent
            end
        end) 
    end
end
Auto3rdEvent = function() 
    if Sea2 then
        KillBoss(_G.ServerData['Server Bosses']['Core']) 
        _G.CurrentTask = ''
    else  
        if _G.PirateRaidTick <= 0 then 
            _G.CurrentTask = ''
            return 
        end 
        local CastleCFrame = CFrame.new(-5543.5327148438, 313.80062866211, -2964.2585449219)
        if GetDistance(CastleCFrame) > 1500 then 
            Tweento(CastleCFrame * CFrame.new(0,-100,0))
        else
            for i,v in pairs(game.workspace.Enemies:GetChildren()) do 
                if v:FindFirstChildOfClass("Humanoid") and v.Humanoid.Health > 0 and GetDistance(v.PrimaryPart,CastleCFrame) <= 1500 then 
                    KillNigga(v)
                end
            end
        end
    end
end
AutoMeleeFunc = function()
    if _G.MeleeTask == 'Find Library Key' then
        if not Sea2 then TeleportWorld(2) end  
        if _G.ServerData["PlayerBackpack"]['Library Key'] then 
            EquipWeaponName('Library Key')
            Tweento(CFrame.new(
                6375.9126,
                296.634583,
                -6843.14062,
                -0.849467814,
                1.5493983e-08,
                -0.527640462,
                3.70608895e-08,
                1,
                -3.0301031e-08,
                0.527640462,
                -4.5294577e-08,
                -0.849467814
            ))
        elseif _G.ServerData['Server Bosses']['Awakened Ice Admiral'] then 
            KillBoss(_G.ServerData['Server Bosses']['Awakened Ice Admiral'])  
            if not game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("OpenLibrary") and _G.ServerData['PlayerData'].Level >= 1450 then
                SetContent('Hopping for Ice Admiral',5)
                HopServer(10,true,"Ice Admiral")
            elseif _G.ServerData['PlayerData'].Level < 1450 then 
                _G.MeleeTask = '' 
            end
        elseif _G.ServerData['PlayerData'].Level >= 1450 and not game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("OpenLibrary") then
            SetContent('Hopping for Ice Admiral',5)
            HopServer(10,true,"Ice Admiral")
        end
    elseif _G.MeleeTask == 'Find Waterkey' then  
        if not Sea2 then TeleportWorld(2) end  
        if _G.ServerData["PlayerBackpack"]['Water Key'] then 
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuySharkmanKarate", true) 
        elseif _G.ServerData['Server Bosses']['Tide Keeper'] then 
            KillBoss(_G.ServerData['Server Bosses']['Tide Keeper']) 
            if (not _G.ServerData['Server Bosses']['Tide Keeper'] or _G.ServerData['Server Bosses']['Tide Keeper']:FindFirstChildOfClass('Humanoid').Health <= 0) and (type(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuySharkmanKarate", true)) ~='string' or _G.ServerData['PlayerData'].Level < 1450) then   
                _G.MeleeTask = '' 
                _G.MeleeTask=''
                _G.MeleeTask=''
                _G.MeleeTask=''
                _G.MeleeTask=''
                _G.MeleeTask=''
                _G.MeleeTask=''
                _G.MeleeTask=''

            end
        elseif _G.ServerData['PlayerData'].Level >= 1450 and type(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuySharkmanKarate", true)) =='string' then
            SetContent('Hopping for Tide Keeper',5)
            HopServer(10,true,"Tide Keeper")
        else
            _G.MeleeTask= ''
        end 
    elseif _G.MeleeTask == 'Previous Hero Puzzle' then   
        if not Sea3 then TeleportWorld(3) end
        Tweento(GetNPC('Previous Hero').PrimaryPart.CFrame * CFrame.new(0,0,-2.5))
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyElectricClaw", "TeusHubt")
        Tweento(CFrame.new(-12548.8, 332.378, -7617.77)) 
        _G.MeleeTask = '' 
    elseif _G.MeleeTask == 'Find Fire Essence' then  
        if #_G.ServerData['Workspace Fruits'] > 0 then
            collectAllFruit_Store()
        elseif _G.ServerData['Server Bosses']['Soul Reaper'] then
            KillBoss(_G.ServerData['Server Bosses']['Soul Reaper'] )
        elseif _G.ServerData["PlayerBackpack"]['Hallow Essence'] then 
            EquipWeapon('Hallow Essence') 
            Tweento(game:GetService("Workspace").Map["Haunted Castle"].Summoner.Detection.CFrame) 
        elseif _G.ServerData['PlayerData'].Level >= 2000 then  
            if not game.Players.LocalPlayer.PlayerGui.Main:FindFirstChild("Quest").Visible then 
                FarmMobByLevel(2000)
            else 
                KillMobList({
                    "Reborn Skeleton [Lv. 1975]",
                    "Living Zombie [Lv. 2000]",
                    "Demonic Soul [Lv. 2025]",
                    "Posessed Mummy [Lv. 2050]"
                })
            end
        else 
            KillMobList({
                "Reborn Skeleton [Lv. 1975]",
                "Living Zombie [Lv. 2000]",
                "Demonic Soul [Lv. 2025]",
                "Posessed Mummy [Lv. 2050]"
            })
        end
    elseif _G.MeleeTask == 'Farm Godhuman' or _G.Config.FarmmingForGodhuman then 
        local FishTails = CheckMaterialCount('Fish Tail')
        local MagmaOre = CheckMaterialCount('Magma Ore')
        local MysticDroplet = CheckMaterialCount('Mystic Droplet') 
        local DragonScale = CheckMaterialCount('Dragon Scale') 
        if FishTails < 20 then 
            if not Sea1 then 
                TeleportWorld(1)
            else
                KillMobList({"Fishman Warrior","Fishman Commando"})
            end
        elseif MagmaOre < 20 then 
            if not Sea1 then 
                TeleportWorld(1)
            else
                KillMobList({"Military Spy","Military Soldier"})
            end
        elseif MysticDroplet < 10 then 
            if not Sea2 then 
                TeleportWorld(2)
            else
                KillMobList({"Sea Soldier","Water Fighter"})
            end
        elseif DragonScale < 10 then 
            if not Sea3 then 
                TeleportWorld(3)
            else
                KillMobList({"Dragon Crew Archer","Dragon Crew Warrior"})
            end 
        else
            _G.Config.GodhumanMaterialPassed = true
            TeleportWorld(3) 
        end
    end
end    
AutoMeleeMasteryCheck = function() 
    task.spawn(function()
        _G.FragmentNeeded = false
        _G.MeleeTask = 'None' 
        _G.MeleeWait = ''
        repeat task.wait() until _G.CheckAllMelee and _G.Config and _G.Config["Melee Level Values"]
        print('Hub: Loaded Melee') 
        while task.wait(1) do 
            local MLLV = _G.Config["Melee Level Values"]
            pcall(function()
                if MLLV["Superhuman"] == 0 then 
                    BuyMelee('Superhuman')
                    if MLLV["Black Leg"] < 300 then 
                        BuyMelee('Black Leg') 
                        SetMeleeWait('Black Leg',300)  
                    elseif MLLV["Electro"] < 300 then 
                        BuyMelee('Electro')    
                        SetMeleeWait('Electro',300)
                    elseif MLLV["Fishman Karate"] < 300 then 
                        BuyMelee('Fishman Karate')  
                        SetMeleeWait('Fishman Karate',300)
                    elseif MLLV["Dragon Claw"] < 300 then 
                        if MLLV['Dragon Claw'] == 0 then 
                            if _G.ServerData['PlayerData'].Fragments < 1500 then 
                                _G.FragmentNeeded = true 
                            else 
                                BuyMelee('Dragon Claw') 
                                _G.FragmentNeeded = false 
                            end
                        else 
                            BuyMelee('Dragon Claw') 
                            SetMeleeWait('Dragon Claw',300)
                        end 
                    else
                        BuyMelee('Superhuman')
                    end 
                elseif MLLV['Sharkman Karate'] == 0 or MLLV['Death Step'] == 0 or MLLV['Electric Claw'] == 0 or MLLV['Dragon Talon'] == 0 then 
                    if MLLV['Fishman Karate'] < 400 then 
                        BuyMelee('Fishman Karate')   
                        SetMeleeWait('Fishman Karate',400)
                    elseif MLLV['Black Leg'] < 400 then 
                        BuyMelee('Black Leg') 
                        SetMeleeWait('Black Leg',400)
                    elseif MLLV['Electro'] < 400 then 
                        BuyMelee('Electro') 
                        SetMeleeWait('Electro',400)
                    elseif MLLV['Dragon Claw'] < 400 then 
                        BuyMelee('Dragon Claw')  
                        SetMeleeWait('Dragon Claw',400)  
                    elseif MLLV['Superhuman'] < 400 then
                        BuyMelee('Superhuman')
                        SetMeleeWait('Superhuman',400)
                    elseif MLLV['Sharkman Karate'] > 0 and MLLV['Sharkman Karate'] < 400 then 
                        BuyMelee('Sharkman Karate')  
                        SetMeleeWait('Sharkman Karate',400)
                    elseif MLLV['Death Step'] > 0 and MLLV['Death Step'] < 400 then 
                        BuyMelee('Death Step')  
                        SetMeleeWait('Death Step',400)
                    elseif MLLV['Electric Claw'] > 0 and MLLV['Electric Claw'] < 400 then 
                        BuyMelee('Electric Claw')  
                        SetMeleeWait('Electric Claw',400)
                    elseif MLLV['Dragon Talon'] > 0 and MLLV['Dragon Talon'] < 400 then 
                        SetMeleeWait('Dragon Talon',400)
                        BuyMelee('Dragon Talon')
                    elseif MLLV['Electric Claw'] >= 400 and MLLV['Sharkman Karate'] >= 400 and MLLV['Death Step'] >= 400 and MLLV['Superhuman'] >= 400 and MLLV['Dragon Talon'] == 0 then 
                        if (_G.ServerData["Inventory Items"]['Yama'] and _G.ServerData["Inventory Items"]['Yama'].Mastery < 350) or (_G.ServerData["Inventory Items"]['Tushita'] and _G.ServerData["Inventory Items"]['Tushita'].Mastery < 350) then 
                            _G.WeaponType = 'Sword'
                            if _G.ServerData["Inventory Items"]['Yama'] and _G.ServerData["Inventory Items"]['Yama'].Mastery < 350 then 
                                LoadItem('Yama')
                            elseif _G.ServerData["Inventory Items"]['Tushita'] and _G.ServerData["Inventory Items"]['Tushita'].Mastery < 350 then 
                                LoadItem('Tushita')
                            end
                        end
                    end   
                    if MLLV['Sharkman Karate'] == 0 then 
                        BuyMelee('Sharkman Karate')  
                    elseif MLLV['Death Step'] == 0 then 
                        BuyMelee('Death Step')  
                    elseif MLLV['Electric Claw'] == 0 then 
                        BuyMelee('Electric Claw')  
                    elseif MLLV['Dragon Talon'] == 0 then 
                        BuyMelee('Dragon Talon')   
                    end  
                elseif MLLV['Superhuman'] < 400 then
                    BuyMelee('Superhuman')
                    SetMeleeWait('Superhuman',400)
                elseif MLLV['Sharkman Karate'] < 400 then 
                    BuyMelee('Sharkman Karate')  
                    SetMeleeWait('Sharkman Karate',400)
                elseif MLLV['Death Step'] < 400 then 
                    BuyMelee('Death Step')  
                    SetMeleeWait('Death Step',400)
                elseif MLLV['Electric Claw'] < 400 then 
                    BuyMelee('Electric Claw')  
                    SetMeleeWait('Electric Claw',400)
                elseif MLLV['Dragon Talon'] < 400 then 
                    if MLLV['Dragon Talon'] > 0 then
                        SetMeleeWait('Dragon Talon',400)
                        BuyMelee('Dragon Talon') 
                    end
                elseif MLLV['Godhuman'] == 0 then 
                    if not _G.Config.AllV2MeleeStyles400Mastery then 
                        _G.Config.AllV2MeleeStyles400Mastery = true 
                    end 
                    if (_G.ServerData["Inventory Items"]['Yama'] and _G.ServerData["Inventory Items"]['Yama'].Mastery < 350) or (_G.ServerData["Inventory Items"]['Tushita'] and _G.ServerData["Inventory Items"]['Tushita'].Mastery < 350) then 
                        _G.WeaponType = 'Sword'
                        if _G.ServerData["Inventory Items"]['Yama'] and _G.ServerData["Inventory Items"]['Yama'].Mastery < 350 then 
                            LoadItem('Yama')
                        elseif _G.ServerData["Inventory Items"]['Tushita'] and _G.ServerData["Inventory Items"]['Tushita'].Mastery < 350 then 
                            LoadItem('Tushita')
                        end
                    end
                    if _G.Config.GodhumanMaterialPassed and _G.ServerData['PlayerData'].Fragments >= 5000 and _G.ServerData['PlayerData'].Beli >= 5000000 then 
                        BuyMelee('Godhuman')
                    end 
                else
                    if _G.ServerData["Inventory Items"]['Yama'] and _G.ServerData["Inventory Items"]['Yama'].Mastery < 350 then 
                        _G.WeaponType = 'Sword'
                        LoadItem('Yama')
                        SetMeleeWait('Yama',350)
                    elseif _G.ServerData["Inventory Items"]['Tushita'] and _G.ServerData["Inventory Items"]['Tushita'].Mastery < 350 then  
                        LoadItem('Tushita')
                        SetMeleeWait('Tushita',350)
                        _G.WeaponType = 'Sword'
                    elseif CheckEnabling('Auto Switch Melee') and MLLV['Godhuman'] < 600 then 
                        BuyMelee('Godhuman') 
                        _G.WeaponType = "Melee"
                        SetMeleeWait('Godhuman',600)
                    elseif CheckEnabling('Auto Switch Melee') and MLLV['Sharkman Karate'] < 450 then 
                        BuyMelee('Sharkman Karate')
                        _G.WeaponType = "Melee"
                        SetMeleeWait('Sharkman Karate',450)
                    elseif CheckEnabling('Auto Switch Melee') and MLLV['Death Step'] < 450 then 
                        BuyMelee('Death Step')
                        _G.WeaponType = "Melee"
                        SetMeleeWait('Death Step',450)
                    elseif CheckEnabling('Auto Switch Melee') and MLLV['Electric Claw'] < 450 then 
                        BuyMelee('Electric Claw')
                        _G.WeaponType = "Melee"
                        SetMeleeWait('Electric Claw',450)
                    elseif CheckEnabling('Auto Switch Melee') and MLLV['Dragon Talon'] < 450 then 
                        BuyMelee('Dragon Talon')
                        _G.WeaponType = "Melee"
                        SetMeleeWait('Dragon Talon',450)
                    elseif CheckEnabling('Auto Switch Melee') and    MLLV['Superhuman'] < 450 then 
                        BuyMelee('Superhuman')
                        _G.WeaponType = "Melee"
                        SetMeleeWait('Superhuman',450)
                    elseif _G.CurrentTask ~='Getting Cursed Dual Katana' and _G.CurrentTask ~= 'Auto Race V3' then
                        _G.MasteryFarm = false
                        local SwordMasteryFarm,SwordMasteryFarm2 = getNextSwordToFarm()
                        if SwordMasteryFarm and not SwordMasteryFarm.Equipped then 
                            LoadItem(SwordMasteryFarm.Name) 
                        elseif SwordMasteryFarm and SwordMasteryFarm.Equipped then 
                            _G.WeaponType = 'Sword'   
                            SetMeleeWait(SwordMasteryFarm.Name,tonumber(SwordMasteryFarm2))
                        else
                            _G.WeaponType = 'Melee'
                        end
                    end
                end  
            end)
        end
    end)
end 
AutoMeleeMasteryCheck()
AutoMeleeCheck = function()
    task.spawn(function()
        _G.FragmentNeeded = false
        _G.MeleeTask = 'None'
        repeat task.wait() until _G.CheckAllMelee and _G.Config and _G.Config["Melee Level Values"]  
        local PreviousHeroRemoteFired = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyElectricClaw", true)  
        local MonkRemote = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyGodhuman", true)

        _G.Config.PreviousHeroPassed = typeof(PreviousHeroRemoteFired) ~= 'string' 
        _G.Config.PreviousHeroPassed2 =  PreviousHeroRemoteFired ~= 4  
        _G.Config.WaterkeyPassed = typeof(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuySharkmanKarate", true)) ~= 'string';   
        _G.Config.FireEssencePassed = typeof(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyDragonTalon", true))~= 'string'   
        _G.Config.IceCastleDoorPassed = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("OpenLibrary")
        _G.Config.GodhumanMaterialPassed = typeof(MonkRemote) ~= 'string' and MonkRemote ~= 3        
        while task.wait() do 
            local MLLV = _G.Config["Melee Level Values"] 
            local v316, v317, v318, v319 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Bones", "Check")  
            if MLLV['Sharkman Karate'] == 0 or MLLV['Death Step'] == 0 or MLLV['Electric Claw'] == 0 or MLLV['Dragon Talon'] == 0  then 
                pcall(function()   
                    if not _G.Config.GodhumanMaterialPassed then 
                        local MonkRemote = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyGodhuman", true)
                        _G.Config.GodhumanMaterialPassed = typeof(MonkRemote) ~= 'string' and MonkRemote ~= 3
                    end
                    if not _G.Config.WaterkeyPassed then 
                        _G.Config.WaterkeyPassed = typeof(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuySharkmanKarate", true)) ~= 'string'; 
                    end  
                    
                    if not _G.Config.PreviousHeroPassed2 then  
                        local PreviousHeroRemoteFired = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyElectricClaw", true) 
                        _G.Config.PreviousHeroPassed = typeof(PreviousHeroRemoteFired) ~= 'string' 
                        _G.Config.PreviousHeroPassed2 =  PreviousHeroRemoteFired ~= 4  
                    end                    
                    if not _G.Config.FireEssencePassed then 
                        _G.Config.FireEssencePassed = typeof(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyDragonTalon", true))~= 'string' 
                    end     
                    if not _G.Config.IceCastleDoorPassed then 
                        _G.Config.IceCastleDoorPassed = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("OpenLibrary")   
                    end 
                end) 
                if (not _G.Config.IceCastleDoorPassed) and (_G.ServerData["PlayerBackpack"]['Library Key'] or _G.ServerData['Server Bosses']['Awakened Ice Admiral'] or _G.ServerData['PlayerData'].Level >= 1450) then 
                    _G.MeleeTask = 'Find Library Key'
                elseif not _G.Config.WaterkeyPassed and (_G.ServerData['Server Bosses']['Tide Keeper'] or _G.ServerData['PlayerData'].Level >= 1450) then 
                    _G.MeleeTask = 'Find Waterkey' 
                elseif _G.ServerData['PlayerData'].Level >= 1650 and _G.Config.PreviousHeroPassed and not _G.Config.PreviousHeroPassed2 then  
                    if not Sea3 then 
                        TeleportWorld(3) 
                    else
                        _G.MeleeTask = 'Previous Hero Puzzle' 
                    end
                elseif not _G.HavingX2 and ((Sea3 and v318 and v318 > 0) or _G.ServerData['PlayerData'].Level >= 1650) and not _G.Config.FireEssencePassed then   
                    if not Sea3 then 
                        TeleportWorld(3) 
                    else 
                        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
                        if v316 and v316 < v318*50 then 
                            _G.MeleeTask = 'Find Fire Essence' 
                        else
                            print(v316,'v316')
                            _G.MeleeTask = ''
                        end
                    end
                else
                    _G.MeleeTask = ''
                end  
            elseif _G.Config.AllV2MeleeStyles400Mastery and MLLV['Godhuman'] == 0 then 
                if not _G.Config.GodhumanMaterialPassed then 
                    local MonkRemote = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyGodhuman", true)
                    _G.Config.GodhumanMaterialPassed = typeof(MonkRemote) ~= 'string' and MonkRemote ~= 3
                end
                if not _G.Config.GodhumanMaterialPassed then 
                    _G.MeleeTask = 'Farm Godhuman' 
                else  
                    _G.MeleeTask = ''    
                end
            else   
                _G.Config.FarmmingForGodhuman = false
                _G.MeleeTask = ''
            end 
            task.wait(3)
        end
    end)
end
AutoMeleeCheck()
AutoRaceV2 = function()
    if not Sea2 then 
        repeat 
            TeleportWorld(2)
            task.wait(3)
        until Sea2 
    end
    if _G.ServerData["PlayerBackpack"]['Flower 1'] and _G.ServerData["PlayerBackpack"]['Flower 2'] and _G.ServerData["PlayerBackpack"]['Flower 3'] then 
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Alchemist", "3")
        wait(5)
        _G.CurrentTask = '' 
        SetContent('Upgraded V2 Race | Returning task...')
        return
    else
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Alchemist", "1")
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Alchemist", "2") 
        if not _G.ServerData["PlayerBackpack"]['Flower 1'] then 
            SetContent('Getting Blue Flower (Flower 1)')
            if workspace.Flower1.Transparency ~= 1 then
                Tweento(workspace.Flower1.CFrame)   
            else  
                SetContent('Hopping for Blue Flower',5)
                HopServer(10,true,"Blue Flower")
            end
        elseif not _G.ServerData["PlayerBackpack"]['Flower 2'] then 
            SetContent('Getting Red Flower (Flower 2)')
            Tweento(workspace.Flower2.CFrame)
        else 
            repeat 
                SetContent('Getting Yellow Flower (Flower 3)')
                KillMobList({"Swan Pirate"})
                task.wait()
            until _G.ServerData["PlayerBackpack"]['Flower 3'] or not IsPlayerAlive() 

        end
    end
end

AutoBartiloQuest = function()
    local QuestBartiloId = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo")
    if QuestBartiloId == 0 then 
        SetContent('First Bartilo task...')
        if game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text:find("Swan Pirate") and game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text:find("50") and game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible then 
            KillMobList({"Swan Pirate"})
            repeat 
                KillMobList({"Swan Pirate"})
            until not (game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text:find("Swan Pirate") and game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text:find("50") and game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible)
        else
            Tweento(CFrame.new(-456.28952, 73.0200958, 299.895966))
            if GetDistance(CFrame.new(-456.28952, 73.0200958, 299.895966)) < 10 then 
                local args = {
                    [1] = "TeusHubtQuest",
                    [2] = "BartiloQuest",
                    [3] = 1
                }
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
            end
        end 
    elseif QuestBartiloId == 1 then 
        SetContent('Finding Jeremy...')
        if _G.ServerData['Server Bosses']['Jeremy'] then 
            KillBoss(_G.ServerData['Server Bosses']['Jeremy'])
            _G.CurrentTask = ''
        elseif _G.ServerData['PlayerData'].Level > 500 then  
            SetContent('Hopping for Bartilo',5)
            HopServer(9,true,"Jeremy Boss")
        end
    elseif QuestBartiloId == 2 then 
        local TeusHubtCFrame =
        CFrame.new(
        -1837.46155,
        44.2921753,
        1656.19873,
        0.999881566,
        -1.03885048e-22,
        -0.0153914848,
        1.07805858e-22,
        1,
        2.53909284e-22,
        0.0153914848,
        -2.55538502e-22,
        0.999881566
    )
        if GetDistance(TeusHubtCFrame) > 400 then 
            SetContent('TeusHubting templates puzzle...')
            Tweento(TeusHubtCFrame)
        else
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(-1836, 11, 1714)
                task.wait(.5)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(-1850.49329, 13.1789551, 1750.89685)
                task.wait(.5)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(-1858.87305, 19.3777466, 1712.01807)
            task.wait(.5)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(-1803.94324, 16.5789185, 1750.89685)
                task.wait(.5)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(-1858.55835, 16.8604317, 1724.79541)
                task.wait(.5)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(-1869.54224, 15.987854, 1681.00659)
                task.wait(.5)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(-1800.0979, 16.4978027, 1684.52368)
                task.wait(.5)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(-1819.26343, 14.795166, 1717.90625)
                task.wait(.5)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(-1813.51843, 14.8604736, 1724.79541)
                _G.CurrentTask = ''
                SetContent('Done task | Returning task...')
        end
    end
end 

AutoSea2 = function()  
    if game.Workspace.Map.Ice.Door.CanCollide then
        if not _G.ServerData["PlayerBackpack"]['Key'] then  
            SetContent('Getting key to pass the door...')
            Tweento(CFrame.new(4852.2895507813, 5.651451587677, 718.53070068359))
            if GetDistance(CFrame.new(4852.2895507813, 5.651451587677, 718.53070068359)) < 5 then
                game.ReplicatedStorage.Remotes["CommF_"]:InvokeServer("DressrosaQuestProgress", "Detective")
                if _G.ServerData["PlayerBackpack"]['Key'] then EquipWeaponName("Key") end
            end 
        else 
            SetContent('Opening door...')
            EquipWeaponName("Key")
            if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Key") then
                Tweento(game.Workspace.Map.Ice.Door.CFrame)
            end
        end
    else 
        SetContent('Finding Ice Admiral...')
        if _G.ServerData['Server Bosses']['Ice Admiral'] then 
            KillBoss(_G.ServerData['Server Bosses']['Ice Admiral']) 
            refreshTask()
            task.delay(5,function()
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelDressrosa") 
            end)
            _G.CurrentTask = ''
        elseif _G.ServerData['PlayerData'].Level >= 700 then
            if GetDistance(CFrame.new(4852.2895507813, 5.651451587677, 718.53070068359)) < 1000 then   
                SetContent('Hopping for Ice Admiral',5)
                HopServer(9,true,"Ice Admiral")
            else
                Tweento(CFrame.new(4852.2895507813, 5.651451587677, 718.53070068359))
            end
        end
    end
end
AutoPole = function()
    if not Sea1 then 
        --TeleportWorld(1)
    end
    if _G.Config.OwnedItems["Pole (1st Form)"] then 
        refreshTask()
        return
    end 
        if _G.ServerData['Server Bosses']['Thunder God'] then 
            KillBoss(_G.ServerData['Server Bosses']['Thunder God'])
            _G.CurrentTask = ''
        elseif _G.ServerData['PlayerData'].Level > 500 then  
            SetContent('Hopping for Thunder God',5)
            HopServer(9,true,'Thunder God')
        end
end
local function IsUnlockedSaberDoor()
    for i, v in next, game:GetService("Workspace").Map.Jungle.Final:GetChildren() do
        if v:IsA("Part") and not v.CanCollide then
            return true
        end
    end
end  
local function SaberTouchTemplate()
    for i, v in next, game:GetService("Workspace").Map.Jungle.QuestPlates:GetChildren() do
        if v:IsA("Model") then
            if v.Button:FindFirstChild("TouchInterest") then
                return v
            end
        end
    end
end 
local function CupDoor()
    return workspace.Map.Desert.Burn.Part.CanCollide == false
end
AutoSaber = loadstring(game:HttpGet('https://raw.githubusercontent.com/memaybeohub/NewPage/main/AutoSaber.lua'))()--[[function()
    if not Sea1 then 
        --TeleportWorld(1)
        return;
    end
    task.wait()
    local RichSonProgress = -999
    if _G.Config.OwnedItems["Saber"] then 
        _G.CurrentTask = ''
        return
    end
    if IsUnlockedSaberDoor() then 
        SetContent('Finding Saber Expert...')
        if _G.ServerData['Server Bosses']['Saber Expert'] then 
            KillBoss(_G.ServerData['Server Bosses']['Saber Expert'])  
            if not _G.ServerData['Server Bosses']['Saber Expert'] or not _G.ServerData['Server Bosses']['Saber Expert']:FindFirstChildOfClass('Humanoid') or _G.ServerData['Server Bosses']['Saber Expert']:FindFirstChildOfClass('Humanoid').Health <= 0 then 
                _G.CurrentTask = ''
            end
        elseif _G.ServerData['PlayerData'].Level > 200 then  
            SetContent('Hopping for Shanks',5)
            HopServer(9,true,"Shanks")
        end 
    elseif game:GetService("Workspace").Map.Jungle.QuestPlates.Door.CanCollide then 
        SetContent('Touching templates in jungle...')
        local Template = SaberTouchTemplate()
        if Template then 
            Tweento(Template.Part.CFrame)
        end
    elseif CupDoor() then 
        RichSonProgress = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")
        if RichSonProgress ~= 0 and RichSonProgress ~= 1 then
            if not _G.ServerData["PlayerBackpack"]['Cup'] then 
                Tweento(CFrame.new(1113.66992,7.5484705,4365.27832,-0.78613919,-2.19578524e-08,-0.618049502,1.02977182e-09,1,-3.68374984e-08,0.618049502,-2.95958493e-08,-0.78613919)) 
                SetContent('Getting cup')
            else
                EquipWeaponName('Cup')
                if _G.ServerData["PlayerBackpack"]['Cup'].Handle:FindFirstChild('TouchInterest') then 
                    SetContent('Filling cup with water...')
                    Tweento(CFrame.new(1395.77307,37.4733238,-1324.34631,-0.999978602,-6.53588605e-09,0.00654155109,-6.57083277e-09,1,-5.32077493e-09,-0.00654155109,-5.3636442e-09,-0.999978602))  
                else 
                    SetContent('Feeding sick man...')
                    Tweento(CFrame.new(1457.8768310547, 88.377502441406, -1390.6892089844))
                    if GetDistance(CFrame.new(1457.8768310547, 88.377502441406, -1390.6892089844)) < 10 then 
                        game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
                            "ProQuestProgress",
                            "SickMan"
                        )
                    end
                end
            end
        elseif RichSonProgress == 0 then
            SetContent('Finding Mob Leader...')
            if _G.ServerData['Server Bosses']['Mob Leader'] then 
                KillBoss(_G.ServerData['Server Bosses']['Mob Leader']) 
            elseif _G.ServerData['PlayerData'].Level > 500 then  
                SetContent('Hopping for Mob Leader',5)
                HopServer(9,true,"Mob Leader")  
            end
        elseif RichSonProgress == 1 then
            if _G.ServerData["PlayerBackpack"]['Relic'] then 
                EquipWeaponName("Relic") 
                Tweento(CFrame.new(-1405.3677978516, 29.977333068848, 4.5685839653015))
            else
                Tweento(CFrame.new(-1404.07996,29.8520069,5.26677656,0.888123989,-4.0340602e-09,0.459603906,7.5884703e-09,1,-5.8864642e-09,-0.459603906,8.71560069e-09,0.888123989))
                if GetDistance(CFrame.new(-1404.07996,29.8520069,5.26677656,0.888123989,-4.0340602e-09,0.459603906,7.5884703e-09,1,-5.8864642e-09,-0.459603906,8.71560069e-09,0.888123989)) < 10 then 
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")
                end
            end
        end
    else 
        SetContent('Getting torch...')
        if not _G.ServerData["PlayerBackpack"]['Torch'] then  
            Tweento(game:GetService("Workspace").Map.Jungle.Torch.CFrame)
        else  
            EquipWeaponName("Torch") 
            Tweento(CFrame.new(1115.23499,4.92147732,4349.36963,-0.670654476,-2.18307523e-08,0.74176991,-9.06980624e-09,1,2.1230365e-08,-0.74176991,7.51052998e-09,-0.670654476))
        end  
    end
end]]

local Settings2 = {}
local SaveFileName2 = "!Blacklist_Servers.json"

local HopGuiCreation = loadstring(game:HttpGet('https://raw.githubusercontent.com/memaybeohub/NewPage/main/HopGui.lua'))()
function SaveSettings2()
    local HttpService = game:GetService("HttpService")
    if not isfolder("TeusHub") then
        makefolder("TeusHub")
    end
    writefile(SaveFileName2, HttpService:JSONEncode(Settings2))
end

function ReadSetting2()
    local s, e =
        pcall(
        function()
            local HttpService = game:GetService("HttpService")
            if not isfolder("TeusHub") then
                makefolder("TeusHub")
            end
            return HttpService:JSONDecode(readfile(SaveFileName2))
        end
    )
    if s then
        return e
    else
        SaveSettings2()
        return ReadSetting2()
    end
end
function CheckX2Exp()
    a2, b2 =
        pcall(
        function()
            if LocalPlayerLevelValue < 2600 then
                if string.find(game.Players.LocalPlayer.PlayerGui.Main.Level.Exp.Text, "ends in") then
                    return true
                end
            end
        end
    )
    if a2 then
        return b2
    end
end
local lessfoundAnything = ""
getgenv().HopLow = function()
    if lessfoundAnything == "" then
        SiteHopServerLess =
            game.HttpService:JSONDecode(
            game:HttpGet(
                "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            )
        )
    else
        SiteHopServerLess =
            game.HttpService:JSONDecode(
            game:HttpGet(
                "https://games.roblox.com/v1/games/" ..
                    game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. lessfoundAnything
            )
        )
    end
    if
        SiteHopServerLess.nextPageCursor and SiteHopServerLess.nextPageCursor ~= "null" and
            SiteHopServerLess.nextPageCursor ~= nil
     then
        lessfoundAnything = SiteHopServerLess.nextPageCursor
    end
    for i, v in pairs(SiteHopServerLess.data) do
        if v.playing and tonumber(v.playing) <= 4 and v.id ~= game.JobId then
            game:GetService("TeleportService"):TeleportToPlaceInstance(
                game.PlaceId,
                tostring(v.id),
                game.Players.LocalPlayer
            )
        end
    end
end
local Settings2 = ReadSetting2()
_G.TimeTryHopLow = 0  
local function fetchServerData()
    local HttpService = game:GetService("HttpService")
    local data = {} 
    local success, response = pcall(function()
        return request({
            Url = 'http://103.238.234.228:10000/get_server/' .. game.PlaceId,
            Method = "POST",
            Body = HttpService:JSONEncode(data),
            Headers = {
                ["Content-Type"] = "application/json"
            }
        })
    end)
    table.foreach(response,print)
    if success and response.StatusCode == 200 then
        local result = HttpService:JSONDecode(response.Body)
        return result
    end
end
function HopLowV2()
    local placeId = tostring(game.PlaceId)
    local serverData = fetchServerData()
    if serverData then
        print("joinin:")
        table.foreach(serverData,print)
        game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport",
            serverData.id)
    end
end
getgenv().HopServer = function(CountTarget, hoplowallow,reasontohop)
    SetContent(reasontohop)
    delay = 3 
    if not reasontohop then 
        reasontohop = 'None'
    end
    HopGuiCreation(reasontohop,delay)
    local timeplased = tick()+delay
    task.spawn(function()
        if hoplowallow and _G.TimeTryHopLow < 3 then
            for i = 1, 3 - _G.TimeTryHopLow do
                if _G.TimeTryHopLow < 3 then
                    local a2,b2 = pcall(function()
                        HopLowV2()
                    end)
                    if not a2 then print('hop fail',b2) end
                    _G.TimeTryHopLow = _G.TimeTryHopLow + 1
                    warn('Hop low times: ',_G.TimeTryHopLow)
                    SetContent('Low Server hopping times: '..tostring(_G.TimeTryHopLow))
                    wait(delay/2)
                end
            end
        end
    end)
    if not CountTarget then
        CountTarget = 10
    end
    wait(delay)
    local function Hop()
        for i = 1, 100 do
            if ChooseRegion == nil or ChooseRegion == "" then
                ChooseRegion = "Singapore"
            else
                game:GetService("Players").LocalPlayer.PlayerGui.ServerBrowser.Frame.Filters.SearchRegion.TextBox.Text =
                    ChooseRegion
            end
            local huhu = game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer(i)
            for k, v in pairs(huhu) do
                if k ~= game.JobId and v["Count"] <= CountTarget-1 then
                    if not Settings2[k] or tick() - Settings2[k].Time > 60 * 10 then
                        SetContent('Hopping normal server...')
                        Settings2[k] = {
                            Time = tick()
                        }
                        SaveSettings2()
                        game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", k)
                        getgenv().SwitchingServer = true
                        task.wait(10)
                    elseif tick() - Settings2[k].Time > 60 * 60 then
                        Settings2[k] = nil
                    end
                end
            end
        end
        return false
    end 
    while not Hop() do 
        task.wait()
    end
    SaveSettings2()
end
print('Hub: Loaded Hop.')
