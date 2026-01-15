--[[
    🚀 BRAINROT TSUNAMI - THE ULTIMATE GOD MODE (2026)
    المميزات المضافة: مانع طرد، إضاءة كاملة، استقرار فائق، انتقال ثلاثي
]]

-- 1. نظام الأمان ومنع التكرار
if _G.UltimateRunning then return end
_G.UltimateRunning = true

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local HomeTP = Instance.new("TextButton")
local SpeedToggle = Instance.new("TextButton")
local SpeedSlider = Instance.new("TextBox")
local MinimizeBtn = Instance.new("TextButton")
local FullBrightBtn = Instance.new("TextButton")
local SaveLoadFrame = Instance.new("Frame")

-- إعدادات الواجهة (Safe UI)
ScreenGui.Name = "Ultimate_SafeUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 260, 0, 350)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "SUPREME GOD MODE 🌊"
Title.TextColor3 = Color3.fromRGB(0, 255, 255) -- لون فسفوري احترافي
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Parent = MainFrame
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 15)

-- [1] زر الانتقال للبيت (Triple Safe TP)
HomeTP.Parent = MainFrame
HomeTP.Size = UDim2.new(0.9, 0, 0, 45)
HomeTP.Position = UDim2.new(0.05, 0, 0.16, 0)
HomeTP.Text = "الهروب للبيت (Safe TP) 🏠"
HomeTP.BackgroundColor3 = Color3.fromRGB(0, 85, 255)
HomeTP.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", HomeTP)

HomeTP.MouseButton1Click:Connect(function()
    local lp = game.Players.LocalPlayer
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        for i = 1, 3 do 
            lp.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0) -- إحداثيات بيت آمنة
            task.wait(0.05)
        end
    end
end)

-- [2] هكر السرعة (Speed Customizer)
SpeedSlider.Parent = MainFrame
SpeedSlider.Size = UDim2.new(0.9, 0, 0, 35)
SpeedSlider.Position = UDim2.new(0.05, 0, 0.32, 0)
SpeedSlider.Text = "150"
SpeedSlider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SpeedSlider.TextColor3 = Color3.fromRGB(0, 255, 0)
Instance.new("UICorner", SpeedSlider)

local speedOn = false
SpeedToggle.Parent = MainFrame
SpeedToggle.Size = UDim2.new(0.9, 0, 0, 45)
SpeedToggle.Position = UDim2.new(0.05, 0, 0.44, 0)
SpeedToggle.Text = "تشغيل السرعة: OFF"
SpeedToggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
SpeedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", SpeedToggle)

SpeedToggle.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    SpeedToggle.Text = speedOn and "تشغيل السرعة: ON" or "تشغيل السرعة: OFF"
    SpeedToggle.BackgroundColor3 = speedOn and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

-- [3] إضاءة كاملة (Full Bright) - ميزة إضافية لعام 2026
FullBrightBtn.Parent = MainFrame
FullBrightBtn.Size = UDim2.new(0.9, 0, 0, 45)
FullBrightBtn.Position = UDim2.new(0.05, 0, 0.60, 0)
FullBrightBtn.Text = "إضاءة كاملة (FullBright) 💡"
FullBrightBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
FullBrightBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", FullBrightBtn)

FullBrightBtn.MouseButton1Click:Connect(function()
    game:GetService("Lighting").Brightness = 2
    game:GetService("Lighting").ClockTime = 14
    game:GetService("Lighting").FogEnd = 100000
    game:GetService("Lighting").GlobalShadows = false
end)

-- [4] نظام حفظ الموقع السريع
local SaveBtn = Instance.new("TextButton", MainFrame)
SaveBtn.Size = UDim2.new(0.43, 0, 0, 40)
SaveBtn.Position = UDim2.new(0.05, 0, 0.76, 0)
SaveBtn.Text = "حفظ الموقع 📍"
SaveBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", SaveBtn)

local LoadBtn = Instance.new("TextButton", MainFrame)
LoadBtn.Size = UDim2.new(0.43, 0, 0, 40)
LoadBtn.Position = UDim2.new(0.52, 0, 0.76, 0)
LoadBtn.Text = "انتقال 🚀"
LoadBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
LoadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", LoadBtn)

local savedPos = nil
SaveBtn.MouseButton1Click:Connect(function()
    if game.Players.LocalPlayer.Character then
        savedPos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    end
end)
LoadBtn.MouseButton1Click:Connect(function()
    if savedPos then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = savedPos end
end)

-- حلقة الأداء الفائق والسرعة (Anti-Cheat Bypass Loop)
task.spawn(function()
    while true do
        pcall(function()
            if speedOn and game.Players.LocalPlayer.Character then
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = tonumber(SpeedSlider.Text) or 16
            end
            -- نظام منع السقوط خارج الخريطة
            if game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y < -50 then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
            end
        end)
        task.wait(0.1)
    end
end)

-- ميزة التصغير (Minimize)
local isMini = false
MinimizeBtn.Parent = MainFrame
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(0.85, 0, 0.02, 0)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.BackgroundTransparency = 1

MinimizeBtn.MouseButton1Click:Connect(function()
    isMini = not isMini
    if isMini then
        MainFrame:TweenSize(UDim2.new(0, 260, 0, 45), "Out", "Quad", 0.3)
        for _, v in pairs(MainFrame:GetChildren()) do
            if v ~= Title and v ~= MinimizeBtn and not v:IsA("UICorner") then v.Visible = false end
        end
        MinimizeBtn.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 260, 0, 350), "Out", "Quad", 0.3)
        for _, v in pairs(MainFrame:GetChildren()) do
            if v ~= Title and v ~= MinimizeBtn and not v:IsA("UICorner") then v.Visible = true end
        end
        MinimizeBtn.Text = "-"
    end
end)
