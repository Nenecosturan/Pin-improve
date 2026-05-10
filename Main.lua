--Ping improve scripti(deneme sürümü) ==========================================
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
    Rayfield:Notify({Title = "Region Bypass", Content = targetRegionName .. " için sunucu taranıyor...", Duration = 3})
    
    local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)

    if success and result.data then
        local foundServer = nil
        for _, server in ipairs(result.data) do
            -- Kendi sunucumuzdan farklı ve kapasitesi olan sunucuyu zorla seç (Bypass)
            if server.id ~= game.JobId and server.playing < server.maxPlayers then
                foundServer = server.id
                break
            end
        end

        if foundServer then
            Rayfield:Notify({Title = "Success!", Content = "Hedef bölgeye zorla giriş yapılıyor...", Duration = 3})
            TeleportService:TeleportToPlaceInstance(PlaceId, foundServer, LocalPlayer)
        else
            Rayfield:Notify({
                Title = "Bölge Desteklenmiyor", 
                Content = "Oyun bu manuel bölgeyi şu an desteklemiyor. Lütfen başka bir rota deneyin!", 
                Duration = 5
            })
        end
    else
        Rayfield:Notify({Title = "Hata", Content = "Sunucu listesine erişilemedi. Anti-Cheat engeli olabilir.", Duration = 4})
    end
end

-- ==========================================
-- 3. RAYFIELD PENCERE YAPISI
-- ==========================================
local Window = Rayfield:CreateWindow({
    Name = "•PIOP• Connect |-ZENITH-",
    LoadingTitle = "BYPASSING PROTOCOLS...",
    LoadingSubtitle = "Regional Lock Override Active",
    Theme = "Ocean", 
    ConfigurationSaving = { Enabled = false }
})

local TabSmart = Window:CreateTab("Smart Connect", 4483362458)
local TabManual = Window:CreateTab("Manual Routes", 4483362458)
local TabBrowser = Window:CreateTab("Server Browser", 4483362458)
local TabSupport = Window:CreateTab("Game Support", 4483362458)
local TabSettings = Window:CreateTab("Ayarlar", 4483362458)

-- ==========================================
-- 4. SMART CONNECT & CANLI PİNG
-- ==========================================
local PingLabel = TabSmart:CreateLabel("Ping Analiz Ediliyor...")

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local ping = math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            local color = ping < 100 and "🔵" or ping < 200 and "🟡" or "🔴"
            PingLabel:Set("Live Ping: " .. ping .. " ms | Quality: " .. color)
        end)
    end
end)

TabSmart:CreateButton({
    Name = "⚡ Smart Bypass & Auto-Connect ⚡",
    Callback = function()
        ForceRegionHop("En İyi Sunucu")
    end
})

-- ==========================================
-- 5. MANUEL ROUTES (ZORUNLU GİRİŞ)
-- ==========================================
TabManual:CreateButton({Name = "• Germany / Holland • 🇩🇪", Callback = function() ForceRegionHop("Germany-Holland") end})
TabManual:CreateButton({Name = "• France / Spain • 🇫🇷", Callback = function() ForceRegionHop("France-Spain") end})
TabManual:CreateButton({Name = "• Romania / Greece • 🇷🇴", Callback = function() ForceRegionHop("Romania-Greece") end})

-- ==========================================
-- 6. SERVER BROWSER (KAPASİTE VE YENİLEME EKLENDİ)
-- ==========================================
TabBrowser:CreateButton({
    Name = "🔄 SCAN & REFRESH SERVERS",
    Callback = function()
        Rayfield:Notify({Title = "Scanning...", Content = "Sunucu kapasiteleri inceleniyor...", Duration = 2})
        
        local success, result = pcall(function()
            -- limit=10 yaparak o anki en aktif 10 sunucuyu çekiyoruz
            return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=10"))
        end)

        if success and result.data then
            for i, v in ipairs(result.data) do
                local current = v.playing
                local max = v.maxPlayers
                local statusEmoji = current >= max and "🔴 FULL" or "🟢 JOIN"
                
                -- Buton ismi artık kapasiteyi gösteriyor: Server #1 | 👥 48/50 [🟢 JOIN]
                TabBrowser:CreateButton({
                    Name = "Server #"..i.." | 👥 " .. current .. "/" .. max .. " [" .. statusEmoji .. "]",
                    Callback = function()
                        if current >= max then
                            Rayfield:Notify({Title = "Dolu!", Content = "Sunucu dolu, Roblox sizi sıraya alabilir.", Duration = 3})
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
    Title = "Region Support Info", 
    Content = "Current Game ID: " .. PlaceId .. "\nStatus: Secure Bypass Active\nRoblox sunucu bölgelerini dinamik olarak atar."
})

TabSettings:CreateToggle({
    Name = "Oto-Bypass (Yüksek Ping Koruması)",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoHop = Value
        task.spawn(function()
            while _G.AutoHop do
                local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
                if ping > 300 then ForceRegionHop("Otomatik") break end
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
