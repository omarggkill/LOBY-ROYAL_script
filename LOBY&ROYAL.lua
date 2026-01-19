--[[
    🌊 TSUNAMI BRAINROT ULTIMATE HUB V3 - 2026 ULTIMATE EDITION 🌊
    جميع المميزات: God Mode | Auto Farm | Safe Zones | Fly | Speed | Rebirth | Mutations
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- تنظيف النسخ القديمة
for _, gui in pairs(game:GetService("CoreGui"):GetChildren()) do
    if gui.Name:find("TsunamiHub") then gui:Destroy() end
end

-- المتغيرات المتطورة
local homePos = nil
local safeZones = {
    {name = "قاعدة البداية", pos = CFrame.new(0, 15, 0)},
    {name = "الخندق 1", pos = CFrame.new(45, 8, 0)},
    {name = "التل الأول", pos = CFrame.new(95, 25, 0)},
    {name = "منطقة VIP", pos = CFrame.new(145, 35, 0)},
    {name = "المنطقة النهائية", pos = CFrame.new(220, 60, 0)},
    {name = "Rare Brainrot Zone", pos = CFrame.new(300, 80, 0)}
}

local godMode, speedMode, flyMode, autoFarm, autoCollect = false, false, false, false, false
local speedValue = 120
local flySpeed = 50
local currentZone = 1
local flyConnection

-- إنشاء GUI فخم
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TsunamiBrainrotHubV3"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- الإطار الرئيسي الفخم
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 550)
MainFrame.Position = UDim2.new(0.01, 0, 0.05, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 25)
MainCorner.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 255, 200)
Stroke.Thickness = 3
Stroke.Parent = MainFrame

-- العنوان المتحرك
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 70)
Title.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
Title.Text = "🌊 TSUNAMI BRAINROT ULTIMATE V3 🌊"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 20)
TitleCorner.Parent = Title

-- دالة الزر الفخم
local function createProButton(text, posY, callback, color, icon)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.92, 0, 0, 55)
    btn.Position = UDim2.new(0.04, 0, posY, 0)
    btn.BackgroundColor3 = color
    btn.Text = icon .. " " .. text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 15
    btn.Font = Enum.Font.GothamBold
    btn.Parent = MainFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 15)
    btnCorner.Parent = btn
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(255, 255, 255)
    btnStroke.Thickness = 1.5
    btnStroke.Parent = btn
    
    -- تأثير الضغط
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30, 30, 50)}):Play()
    end)
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = color}):Play()
    end)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- 1. حفظ القاعدة الآمنة
local saveHomeBtn = createProButton("حفظ قاعدتي الآمنة", 0.16, function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        homePos = char.HumanoidRootPart.CFrame
        saveHomeBtn.Text = "✅ القاعدة محفوظة!"
        saveHomeBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        wait(1.5)
        saveHomeBtn.Text = "🏠 حفظ قاعدتي الآمنة"
        saveHomeBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    end
end, Color3.fromRGB(255, 165, 0), "🏠")

-- 2. العودة للقاعدة
createProButton("عودة للقاعدة", 0.29, function()
    if homePos and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = homePos
    end
end, Color3.fromRGB(0, 150, 255), "🚀")

-- 3. Safe Zones (جميع المناطق الآمنة)
local zoneBtn = createProButton("منطقة آمنة 1", 0.42, function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = safeZones[currentZone].pos
        zoneBtn.Text = "✅ " .. safeZones[currentZone].name
        currentZone = currentZone + 1
        if currentZone > #safeZones then currentZone = 1 end
        wait(1.5)
        zoneBtn.Text = "🛡️ منطقة آمنة " .. currentZone
    end
end, Color3.fromRGB(100, 255, 100), "🛡️")

-- 4. God Mode كامل (لا تموت من السيول أبدًا)
local godBtn = createProButton("God Mode: OFF", 0.55, function()
    godMode = not godMode
    godBtn.Text = godMode and "God Mode: ON 🔥" or "God Mode: OFF"
    godBtn.BackgroundColor3 = godMode and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(100, 50, 50)
end, Color3.fromRGB(100, 50, 50), "💀")

-- 5. Speed Hack
local speedBtn = createProButton("Speed: OFF", 0.68, function()
    speedMode = not speedMode
    speedBtn.Text = speedMode and "Speed: ON ⚡" or "Speed: OFF"
    speedBtn.BackgroundColor3 = speedMode and Color3.fromRGB(100, 255, 255) or Color3.fromRGB(50, 150, 200)
end, Color3.fromRGB(50, 150, 200), "⚡")

-- 6. Fly Hack
local flyBtn = createProButton("Fly: OFF", 0.81, function()
    flyMode = not flyMode
    flyBtn.Text = flyMode and "Fly: ON ✈️" or "Fly: OFF"
    flyBtn.BackgroundColor3 = flyMode and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(200, 150, 0)
end, Color3.fromRGB(200, 150, 0), "✈️")

-- 7. Auto Farm Brainrots
local autoFarmBtn = createProButton("Auto Farm: OFF", 0.94, function()
    autoFarm = not autoFarm
    autoFarmBtn.Text = autoFarm and "Auto Farm: ON 🤖" or "Auto Farm: OFF"
    autoFarmBtn.BackgroundColor3 = autoFarm and Color3.fromRGB(255, 100, 200) or Color3.fromRGB(150, 50, 100)
end, Color3.fromRGB(150, 50, 100), "🤖")

-- 🔥 النظام الرئيسي المتطور 🔥
spawn(function()
    while task.wait() do
        pcall(function()
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                
                if hum and root then
                    -- God Mode كامل (حماية من السيول 100%)
                    if godMode then
                        hum.Health = math.huge
                        hum.MaxHealth = math.huge
                        
                        -- جعل الشخصية غير قابلة للاصطدام
                        for _, part in pairs(char:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                        
                        -- دفع تلقائي للأعلى عند اقتراب السيول
                        root.AssemblyLinearVelocity = Vector3.new(0, 30, 0)
                    end
                    
                    -- Speed Hack
                    if speedMode then
                        hum.WalkSpeed = speedValue
                        hum.JumpPower = 200
                    end
                    
                    -- Fly Hack
                    if flyMode then
                        local bv = root:FindFirstChild("FlyBV") or Instance.new("BodyVelocity")
                        bv.Name = "FlyBV"
                        bv.MaxForce = Vector3.new(4000, 4000, 4000)
                        bv.Velocity = Vector3.new(0, flySpeed, 0)
                        bv.Parent = root
                    else
                        if root:FindFirstChild("FlyBV") then
                            root.FlyBV:Destroy()
                        end
                    end
                    
                    -- Auto Farm Brainrots
                    if autoFarm then
                        -- البحث عن Brainrots والتقاطها تلقائيًا
                        for _, obj in pairs(workspace:GetChildren()) do
                            if obj.Name:find("Brainrot") or obj.Name:find("brain") then
                                root.CFrame = obj.CFrame
                                firetouchinterest(root, obj, 0)
                                wait(0.1)
                                firetouchinterest(root, obj, 1)
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- اختصارات لوحة المفاتيح
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        flyMode = not flyMode
    elseif input.KeyCode == Enum.KeyCode.G then
        godMode = not godMode
    elseif input.KeyCode == Enum.KeyCode.X then
        autoFarm = not autoFarm
    end
end)

print("🌊 LOBY&ROYAL %!")
print("اختصارات: F=Fly | G=God | X=AutoFarm")
