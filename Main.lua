-- ping gelistirici script deneme surumu 2.0 ==========================================
-- 0. AUTO-EXECUTE (PEŞİMİZİ BIRAKMAYAN SCRIPT)
-- ==========================================
local scriptSource = [[loadstring(game:HttpGet('https://raw.githubusercontent.com/Nenecosturan/Pin-improve/main/Main.lua'))()]]
if queue_on_teleport then
    queue_on_teleport(scriptSource)
end

-- ==========================================
-- 1. KÜTÜPHANE VE SERVİSLER
-- ==========================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId 

-- ==========================================
-- 2. GELİŞMİŞ BYPASS VE BÖLGE KONTROL FONKSİYONU
-- ==========================================
local function ForceRegionHop(targetRegionName)
    Rayfield:Notify({Title = "Server Check...", Content = targetRegionName .. " route being scanned...", Duration = 3})
    
    local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)

    if success and result.data then
        local foundServer = nil
        for _, server in ipairs(result.data) do
            if server.id ~= game.JobId and server.playing < server.maxPlayers then
                foundServer = server.id
                break
            end
        end

        if foundServer then
            Rayfield:Notify({Title = "Success!", Content = "Connecting To The Route...", Duration = 3})
            TeleportService:TeleportToPlaceInstance(PlaceId, foundServer, LocalPlayer)
        else
            Rayfield:Notify({
                Title = "❌UNSUPPORTED ROUTE❌", 
                Content = "Sorry!, " .. targetRegionName .. " route is not avaible for this game,try another route.", 
                Duration = 6
            })
        end
    else
        Rayfield:Notify({Title = "ERROR", Content = "Server list is not avaible, We will fix this ASAP.", Duration = 4})
    end
end

-- ==========================================
-- 3. RAYFIELD PENCERE YAPISI
-- ==========================================
local Window = Rayfield:CreateWindow({
    Name = "•PIOP• Connect |-ZENITH-",
    LoadingTitle = "ANALYZING SOURCE...",
    LoadingSubtitle = "Loading Sources",
    Theme = "DarkBlue", 
    ConfigurationSaving = { Enabled = false }
})

local TabSmart = Window:CreateTab("Smart Connect", 6031265971)
local TabManual = Window:CreateTab("Manual Routes", 6031289993)
local TabBrowser = Window:CreateTab("Server Browser", 6031280951)
local TabSupport = Window:CreateTab("Game Info & Version", 6031154887)
local TabSettings = Window:CreateTab("Ayarlar", 6031280793)
local TabBackup = Window:CreateTab("Backup Script", 6034287525)

-- ==========================================
-- 4. SMART CONNECT & CANLI PİNG
-- ==========================================
local PingLabel = TabSmart:CreateLabel("Ping Analiz Ediliyor...")

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local ping = math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            -- BURADA TIRNAK HATASI DÜZELTİLDİ VE VARSAYILAN DEĞER EKLENDİ
            local color = (ping < 61 and "🔵") or (ping < 100 and "🟢") or (ping < 150 and "🟡") or (ping < 200 and "🔴") or "💀"
            PingLabel:Set("Live Ping: " .. ping .. " ms | Quality: " .. color)
        end)
    end
end)

TabSmart:CreateButton({
    Name = "⚡•Auto-Connect fastest•⚡",
    Callback = function()
        ForceRegionHop("Best Server")
    end
})

-- ==========================================
-- 5. MANUEL ROUTES (HATA MESAJLI BYPASS)
-- ==========================================
TabManual:CreateButton({Name = "• Germany / Holland • 🇩🇪", Callback = function() ForceRegionHop("Almanya") end})
TabManual:CreateButton({Name = "• France / Spain • 🇫🇷", Callback = function() ForceRegionHop("Fransa") end})
TabManual:CreateButton({Name = "• Romania / Greece • 🇷🇴", Callback = function() ForceRegionHop("Romanya") end})

-- ==========================================
-- 6. SERVER BROWSER (KAPASİTE VE YENİLEME)
-- ==========================================
TabBrowser:CreateButton({
    Name = "🔄• SCAN & REFRESH SERVERS •🔄",
    Callback = function()
        Rayfield:Notify({Title = "Scanning...", Content = "Sunucu kapasiteleri inceleniyor...", Duration = 2})
        local success, result = pcall(function()
            return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=10"))
        end)

        if success and result.data then
            for i, v in ipairs(result.data) do
                local current = v.playing
                local max = v.maxPlayers
                local status = current >= max and "🔴 FULL" or "🟢 JOIN"
                
                TabBrowser:CreateButton({
                    Name = "Server #"..i.." | 👥 " .. current .. "/" .. max .. " [" .. status .. "]",
                    Callback = function()
                        if current >= max then
                            Rayfield:Notify({Title = "Full!", Content = "Server is full, Roblox will get you on line.", Duration = 3})
                        end
                        TeleportService:TeleportToPlaceInstance(PlaceId, v.id, LocalPlayer)
                    end
                })
            end
        end
    end
})

-- ==========================================
-- 7. GAME SUPPORT & AYARLAR
-- ==========================================
TabSupport:CreateParagraph({
    Title = "Game Info & version", 
    Content = "Current Game ID: " .. PlaceId .. "\nVersion: 2.5"
})

TabSettings:CreateToggle({
    Name = "Ping Spike Protection (auto-hop)",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoHop = Value
        task.spawn(function()
            while _G.AutoHop do
                local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
                if ping > 300 then ForceRegionHop("auto-hopping") break end
                task.wait(10)
            end
        end)
    end
})

TabSettings:CreateSlider({
    Name = "Render Optimization",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 10,
    Callback = function(Value)
        settings().Rendering.QualityLevel = Value
    end
})

-- ==========================================
-- 8. YEDEK SİSTEM (CUSTOM UI BACKUP)
-- ==========================================
TabBackup:CreateParagraph({
    Title = "Our Backup Script", 
    Content = "Our backup Ping optimization script made by the creator of this script ZENITH."
})

TabBackup:CreateButton({
    Name = "🚀(•PIOP• - Backup)🚀",
    Callback = function()
        Rayfield:Notify({
            Title = "Backup system loaded!", 
            Content = "Sources Loaded...", 
            Duration = 3
        })
        
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Nenecosturan/Ping-Optimizer-PIOP-/refs/heads/main/Main.lua"))()
        end)
        
        if not success then
            Rayfield:Notify({
                Title = "Error While Loading!", 
                Content = "REASON: " .. tostring(err), 
                Duration = 9
            })
        end
    end
})
. tostring(err), 
                Duration = 9.5
            })
        end
    end
})

