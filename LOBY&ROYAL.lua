--[[
    🚀 BRAINROT TSUNAMI SUPREME - FIXED VERSION 2026
    هذا الكود مبرمج ليعمل مباشرة بدون مكتبات خارجية لضمان عدم التعطل
]]

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local HomeTP = Instance.new("TextButton")
local SpeedToggle = Instance.new("TextButton")
local SpeedSlider = Instance.new("TextBox")
local MinimizeBtn = Instance.new("TextButton")
local SavePosBtn = Instance.new("TextButton")
local LoadPosBtn = Instance.new("TextButton")

-- إعدادات الواجهة الرئيسية
ScreenGui.Parent = game.CoreGui
MainFrame.Name = "BrainrotHub"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true -- تحريك السكربت

UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "BRAINROT HUB 🌊"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Parent = MainFrame
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 15)

-- 1. خيار الانتقال للبيت (Triple TP)
HomeTP.Name = "HomeTP"
HomeTP.Parent = MainFrame
HomeTP.Size = UDim2.new(0.9, 0, 0, 45)
HomeTP.Position = UDim2.new(0.05, 0, 0.18, 0)
HomeTP.Text = "العودة للبيت (انتقال ثلاثي) 🏠"
HomeTP.BackgroundColor3 = Color3.fromRGB(0, 140, 70)
HomeTP.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", HomeTP)

HomeTP.MouseButton1Click:Connect(function()
    local lp = game.Players.LocalPlayer
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        for i = 1, 3 do
            lp.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0) -- إحداثيات البيت
            task.wait(0.05)
        end
    end
end)

-- 2. هكر السرعة (Speed)
SpeedSlider.Parent = MainFrame
SpeedSlider.Size = UDim2.new(0.9, 0, 0, 35)
SpeedSlider.Position = UDim2.new(0.05, 0, 0.38, 0)
SpeedSlider.Text = "100" -- السرعة
SpeedSlider.PlaceholderText = "اكتب السرعة هنا"
SpeedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", SpeedSlider)

local speedOn = false
SpeedToggle.Parent = MainFrame
SpeedToggle.Size = UDim2.new(0.9, 0, 0, 40)
SpeedToggle.Position = UDim2.new(0.05, 0, 0.52, 0)
SpeedToggle.Text = "تفعيل السرعة: OFF"
SpeedToggle.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
SpeedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", SpeedToggle)

SpeedToggle.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    if speedOn then
        SpeedToggle.Text = "تفعيل السرعة: ON"
        SpeedToggle.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    else
        SpeedToggle.Text = "تفعيل السرعة: OFF"
        SpeedToggle.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

-- 3. تحديد مكان والانتقال له
local savedCFrame = nil
SavePosBtn.Parent = MainFrame
SavePosBtn.Size = UDim2.new(0.43, 0, 0, 35)
SavePosBtn.Position = UDim2.new(0.05, 0, 0.70, 0)
SavePosBtn.Text = "حفظ الموقع 📍"
SavePosBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SavePosBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", SavePosBtn)

LoadPosBtn.Parent = MainFrame
LoadPosBtn.Size = UDim2.new(0.43, 0, 0, 35)
LoadPosBtn.Position = UDim2.new(0.52, 0, 0.70, 0)
LoadPosBtn.Text = "انتقال للموقع 🚀"
LoadPosBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
LoadPosBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", LoadPosBtn)

SavePosBtn.MouseButton1Click:Connect(function()
    savedCFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
end)

LoadPosBtn.MouseButton1Click:Connect(function()
    if savedCFrame then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = savedCFrame
    end
end)

-- 4. ميزة التصغير (Minimize)
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
        MainFrame:TweenSize(UDim2.new(0, 250, 0, 40), "Out", "Quad", 0.3)
        for _, v in pairs(MainFrame:GetChildren()) do
            if v ~= Title and v ~= MinimizeBtn and not v:IsA("UICorner") then v.Visible = false end
        end
        MinimizeBtn.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 250, 0, 300), "Out", "Quad", 0.3)
        for _, v in pairs(MainFrame:GetChildren()) do
            if v ~= Title and v ~= MinimizeBtn and not v:IsA("UICorner") then v.Visible = true end
        end
        MinimizeBtn.Text = "-"
    end
end)

-- Loop لتشغيل السرعة
game:GetService("RunService").RenderStepped:Connect(function()
    if speedOn then
        local s = tonumber(SpeedSlider.Text) or 16
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
        end)
    end
end)
