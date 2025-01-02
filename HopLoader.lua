local Settings2 = {}
local SaveFileName2 = "!Blacklist_Servers.json"

local HopGuiCreation = loadstring(game:HttpGet('https://raw.githubusercontent.com/memaybeohub/NewPage/main/HopGui.lua'))()
function SaveSettings2()
    local HttpService = game:GetService("HttpService")
    if not isfolder("Star Hub") then
        makefolder("Star Hub")
    end
    writefile(SaveFileName2, HttpService:JSONEncode(Settings2))
end

function ReadSetting2()
    local s, e =
        pcall(
        function()
            local HttpService = game:GetService("HttpService")
            if not isfolder("Star Hub") then
                makefolder("Star Hub")
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
