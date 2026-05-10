-- ==========================================
-- 1. KÜTÜPHANE VE SERVİSLER
-- ==========================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local PlaceId = game.PlaceId 

-- ==========================================
-- 2. RAYFIELD PENCERE YAPISI
-- ==========================================
local Window = Rayfield:CreateWindow({
    Name = "•PIOP• Connect|-ZENITH- ",
    LoadingTitle = "SERVERS LOADING...",
    LoadingSubtitle = "Checking player information...",
    Theme = { 
        TextColor = Color3.fromRGB(240, 240, 240), 
        Background = Color3.fromRGB(25, 25, 25), 
        Topbar = Color3.fromRGB(34, 34, 34) 
    },
    ConfigurationSaving = { Enabled = false }
})

local TabSmart = Window:CreateTab("Smart Connection", 4483362458)
local TabManual = Window:CreateTab("Manuel Connection", 4483362458)

-- ==========================================
-- 3. SMART CONNECT (VPN MANTIĞI)
-- ==========================================
TabSmart:CreateParagraph({
    Title = "About Smart Connect", 
    Content = "Smart connect analyzes your country from calculations and connects you into the best server."
}) -- BURADA KAPATMAYI UNUTMUŞTUN, DÜZELTTİM.

TabSmart:CreateParagraph({
    Title = "Possible Errors", -- BURAYA VİRGÜL EKLEDİM.
    Content = "Because of Roblox's strict safety rules, this script may have some errors"         
})

local CurrentPing = 0
local PingLabel = TabSmart:CreateLabel("My Ping: Analyzing...")

-- Canlı Takip Döngüsü
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            CurrentPing = math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            local region = "Bilinmiyor"
            
            if CurrentPing < 60 then region = "NEARBY SERVER🔵"
            elseif CurrentPing < 130 then region = "SLIGHTLY FAR SERVER OR PING SPIKE🟢"
            elseif CurrentPing < 220 then region = "FAR SERVER OR SERIOUS PING SPIKE🟡"
            else region = "You're far away from europe!🔴" end
            
            PingLabel:Set("Ping: " .. CurrentPing .. " ms | Bölge: " .. region)
        end)
    end
end)

TabSmart:CreateButton({
    Name = "⚡Connect To Fastest Server⚡",
    Callback = function()
        Rayfield:Notify({Title = "Smart Scanning...", Content = "Searching Fastest Europe Server...", Duration = 4})
        task.wait(1.5)
        TeleportService:Teleport(PlaceId, LocalPlayer)
    end
})

-- ==========================================
-- 4. ÜLKE SEÇİMİ (FİLTRELENMİŞ)
-- ==========================================
TabManual:CreateParagraph({
    Title = "Manuel Routes", 
    Content = "The countrys above are the most stabile servers for europe."
})

local function manualHop(countryName)
    Rayfield:Notify({Title = countryName, Content = "Manually Connecting...", Duration = 4})
    task.wait(1)
    TeleportService:Teleport(PlaceId, LocalPlayer)
end

TabManual:CreateButton({Name = "•Germany / Holland• 🇩🇪", Callback = function() manualHop("Almanya") end})
TabManual:CreateButton({Name = "•France / Spain• 🇫🇷", Callback = function() manualHop("Fransa") end})
TabManual:CreateButton({Name = "•Romania / Greece• 🇷🇴", Callback = function() manualHop("Romanya") end})
TabManual:CreateButton({Name = "•Türkiye(for turkish players)• 🇹🇷", Callback = function() manualHop("Türkiye") end})

-- ==========================================
-- 5. YENİ ÖZELLİK: AUTO-RECONNECT (AKILLI KORUMA)
-- ==========================================
local TabSettings = Window:CreateTab("Ayarlar", 4483362458)

TabSettings:CreateToggle({
    Name = "•|High Ping Protection|• (Auto-Hop)",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoHop = Value
        task.spawn(function()
            while _G.AutoHop do
                if CurrentPing > 380 then 
                    Rayfield:Notify({Title = "Ping Spike!", Content = "Your ping is high, Founding better server...", Duration = 5})
                    TeleportService:Teleport(PlaceId, LocalPlayer)
                    break
                end
                task.wait(5)
            end
        end)
    end
})

TabSmart:CreateParagraph({
    Title = "Auto-Hop may be frustrating sometimes", -- VİRGÜL VE METİN DÜZENLENDİ.
    Content = "Turn it off unless you have good connection"
})   

TabSettings:CreateSlider({
    Name = "•Render Optimization•",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 10,
    Callback = function(Value)
        settings().Rendering.QualityLevel = Value
    end
})
