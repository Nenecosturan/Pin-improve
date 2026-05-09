-- ==========================================
-- 1. KÜTÜPHANE VE SERVİSLER
-- ==========================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local PlaceId = game.PlaceId 

-- ==========================================
-- 2. RAYFIELD ARAYÜZÜ
-- ==========================================
local Window = Rayfield:CreateWindow({
    Name = "•Ping Geliştirici• | -ZENITH-",
    LoadingTitle = "kaynaklar yükleniyor...",
    LoadingSubtitle = "Bölgeme En Yakın Sunucular bulunuyor...",
    ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("Sunucu ve İstatistik", 4483362458)

Tab:CreateParagraph({
    Title = "yönlendirildiğim sunucular ping düşüşü sağlarmı?", 
    Content = "Hem evet hem hayır, Roblox, sunucuların bulunduğu ülkeleri gizler. Bu yüzden proxy hatalarıyla uğraşmak yerine, sunucunun gerçek pingini analiz edip kıtasını tahmin ediyoruz ve eğer avrupa dışı ülkelerdeyseniz pinginizin artma ihtimali azalmasından daha fazladır."
})

-- ==========================================
-- 3. CANLI BÖLGE VE PİNG ANALİZİ
-- ==========================================
local StatusLabel = Tab:CreateLabel("Sunucu Bölgesi: Hesaplanıyor...")
local PingLabel = Tab:CreateLabel("Gerçek Ping: Hesaplanıyor...")

-- Arka planda saniyede bir pingi kontrol edip bölgeyi tahmin eden döngü
task.spawn(function()
    while task.wait(1) do
        local stats = game:GetService("Stats"):FindFirstChild("Network")
        if stats and stats:FindFirstChild("ServerStatsItem") then
            -- Gerçek pingi alıyoruz
            local ping = math.round(stats.ServerStatsItem["Data Ping"]:GetValue())
            PingLabel:Set("Canlı Ping: " .. tostring(ping) .. " ms")
            
            -- Ping değerine göre kıta tahmini (Fizik kurallarına dayanır)
            if ping < 90 then
                StatusLabel:Set("Bölge: •AVRUPA Sunucusu🟢")
            elseif ping >= 100 and ping < 160 then
                StatusLabel:Set("Bölge: -Ping dalgalanması-🟡")
            else
                StatusLabel:Set("Bölge: •Dalgalanma veya Çok Uzak Sunucu!🔴")
            end
        end
    end
end)

-- ==========================================
-- 4. KESİN GEÇİŞ BUTONU (PROXY YOK)
-- ==========================================
Tab:CreateButton({
    Name = "•Avrupa içi sunucuya atla•",
    Callback = function()
        -- Eğer durum kırmızıysa (Amerika vb.) bu butona basarak anında yeni bir sunucu zar atılır.
        Rayfield:Notify({Title = "Aranıyor...", Content = "Roblox motoruyla yeni bir sunucuya geçiliyor. Lütfen bekle...", Duration = 3})
        task.wait(1)
        TeleportService:Teleport(PlaceId, LocalPlayer)
    end
})
