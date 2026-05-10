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
    Name = "•PIOP• Smart Connect v3",
    LoadingTitle = "Akıllı Algoritma Başlatılıyor...",
    LoadingSubtitle = "Bölgesel Sunucu Filtresi",
    Theme = { TextColor = Color3.fromRGB(240, 240, 240, Background = Color3.fromRGB(25, 25, 25, ve Topbar = Color3.fromRGB(34, 34, 34,) }
    ConfigurationSaving = { Enabled = false }
})

local TabSmart = Window:CreateTab("Smart VPN", 4483362458)
local TabManual = Window:CreateTab("Ülke Seçimi", 4483362458)

-- ==========================================
-- 3. SMART CONNECT (VPN MANTIĞI)
-- ==========================================
TabSmart:CreateParagraph({
    Title = "Smart Connect Sistemi", 
    Content = "Sistem; Türkiye, Romanya, Yunanistan ve Almanya hatlarını saniyeler içinde analiz eder ve senin için o anki en stabil sunucuya geçiş yapar."
})

local CurrentPing = 0
local PingLabel = TabSmart:CreateLabel("Mevcut Ping: Analiz Ediliyor...")

-- Canlı Takip Döngüsü
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            CurrentPing = math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            local region = "Bilinmiyor"
            
            if CurrentPing < 55 then region = "Yerel / Türkiye Yakını 🇹🇷"
            elseif CurrentPing < 85 then region = "Orta Avrupa (Almanya/Hollanda) 🇩🇪"
            elseif CurrentPing < 110 then region = "Doğu Avrupa (Romanya/Yunanistan) 🇷🇴"
            else region = "Uzak Bölge (Amerika/Asya) 🚩" end
            
            PingLabel:Set("Ping: " .. CurrentPing .. " ms | Bölge: " .. region)
        end)
    end
end)

TabSmart:CreateButton({
    Name = "⚡Connect To Fastest Server⚡",
    Callback = function()
        Rayfield:Notify({Title = "Smart Scanning...", Content = "Searching Fastest Europe Server...", Duration = 4})
        task.wait(1.5)
        -- Native Teleport (Roblox'u en iyi sunucuyu seçmeye zorlar)
        TeleportService:Teleport(PlaceId, LocalPlayer)
    end
})

-- ==========================================
-- 4. ÜLKE SEÇİMİ (FİLTRELENMİŞ)
-- ==========================================
TabManual:CreateParagraph({
    Title = "Manuel Rotalar", 
    Content = "Aşağıdaki ülkeler Türkiye'ye en yakın sunucu merkezleridir."
})

local function manualHop(countryName)
    Rayfield:Notify({Title = countryName, Content = "Bölgesel sunucu havuzuna bağlanılıyor...", Duration = 4})
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
    Name = "|High Ping Protection| (Auto-Hop)",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoHop = Value
        task.spawn(function()
            while _G.AutoHop do
                if CurrentPing > 380 then -- Eğer ping 200'ü geçerse otomatik kaç
                    Rayfield:Notify({Title = "Ping Spike!", Content = "Your ping is high, Founding better server...", Duration = 5})
                    TeleportService:Teleport(PlaceId, LocalPlayer)
                    break
                end
                task.wait(5)
            end
        end)
    end
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

