--[[
    🚀 BRAINROT SUPREME HUB - EXPERT EDITION 2026
    المميزات: 
    1. زر انتقال ثابت لبيتك (Home TP)
    2. زر حفظ موقع مخصص (Save Position)
    3. زر انتقال للموقع اللي حفظته (TP to Saved)
    4. سرعة خرافية (Speed Hack) مع شريط تحكم
    5. ميزة التصغير لأيقونة جانبية (Minimize)
]]

-- تنظيف النسخ القديمة
local old = game:GetService("CoreGui"):FindFirstChild("BrainrotExpertHub")
if old then old:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local HomeBtn = Instance.new("TextButton") -- زر البيت الثابت
local SaveBtn = Instance.new("TextButton") -- زر حفظ المكان
local LoadBtn = Instance.new("TextButton") -- زر الانتقال للمكان المحفوظ
local SpeedToggle = Instance.new("TextButton")
local SpeedInput = Instance.new("TextBox")
local MiniBtn = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "BrainrotExpertHub"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 230, 0, 350) -- مساحة كافية لكل الأزرار
MainFrame.Active = true
MainFrame.Draggable = true
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = "BRAINROT GOD MODE 🌊"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.TextSize = 16
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 12)

-- 1. زر العودة للبيت (ثابت)
HomeBtn.Parent = MainFrame
HomeBtn.Size = UDim2.new(0.9, 0, 0, 45)
HomeBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
HomeBtn.Text = "العودة للبيت فورا 🏠"
HomeBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
HomeBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", HomeBtn)

HomeBtn.MouseButton1Click:Connect(function()
    local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        -- إحداثيات البيت الافتراضية (يمكنك تعديلها)
        root.CFrame = CFrame.new(0, 50, 0) 
    end
end)

-- 2. زر حفظ الموقع (مخصص)
local savedLocation = nil
SaveBtn.Parent = MainFrame
SaveBtn.Size = UDim2.new(0.9, 0, 0, 40)
SaveBtn.Position = UDim2.new(0.05, 0, 0.30, 0)
SaveBtn.Text = "حفظ الموقع الحالي 📍"
SaveBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SaveBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", SaveBtn)

SaveBtn.MouseButton1Click:Connect(function()
    local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        savedLocation = root.CFrame
        SaveBtn.Text = "✅ تم حفظ الموقع!"
        task.wait(1)
        SaveBtn.Text = "حفظ الموقع الحالي 📍"
    end
end)

-- 3. زر الانتقال للموقع المحفوظ
LoadBtn.Parent = MainFrame
LoadBtn.Size = UDim2.new(0.9, 0, 0, 40)
LoadBtn.Position = UDim2.new(0.05, 0, 0.43, 0)
LoadBtn.Text = "انتقال للموقع المحفوظ 🚀"
LoadBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
LoadBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", LoadBtn)

LoadBtn.MouseButton1Click:Connect(function()
    local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root and savedLocation then
        root.CFrame = savedLocation
    else
        LoadBtn.Text = "⚠️ لم تحفظ موقعا بعد!"
        task.wait(1)
        LoadBtn.Text = "انتقال للموقع المحفوظ 🚀"
    end
end)

-- 4. سرعة Brainrot الخرافية
SpeedInput.Parent = MainFrame
SpeedInput.Size = UDim2.new(0.9, 0, 0, 35)
SpeedInput.Position = UDim2.new(0.05, 0, 0.58, 0)
SpeedInput.Text = "200"
SpeedInput.PlaceholderText = "السرعة..."
SpeedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedInput.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", SpeedInput)

local speedEnabled = false
SpeedToggle.Parent = MainFrame
SpeedToggle.Size = UDim2.new(0.9, 0, 0, 45)
SpeedToggle.Position = UDim2.new(0.05, 0, 0.72, 0)
SpeedToggle.Text = "تفعيل السرعة: OFF"
SpeedToggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
SpeedToggle.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", SpeedToggle)

SpeedToggle.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    SpeedToggle.Text = speedEnabled and "تفعيل السرعة: ON" or "تفعيل السرعة: OFF"
    SpeedToggle.BackgroundColor3 = speedEnabled and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(150, 0, 0)
end)

-- 5. ميزة التصغير (Minimize)
local isMini = false
MiniBtn.Parent = MainFrame
MiniBtn.Size = UDim2.new(0, 30, 0, 30)
MiniBtn.Position = UDim2.new(0.85, 0, 0, 0)
MiniBtn.Text = "-"
MiniBtn.BackgroundTransparency = 1
MiniBtn.TextColor3 = Color3.new(1, 1, 1)

MiniBtn.MouseButton1Click:Connect(function()
    isMini = not isMini
    if isMini then
        MainFrame:TweenSize(UDim2.new(0, 230, 0, 40), "Out", "Quad", 0.3)
        for _, v in pairs(MainFrame:GetChildren()) do
            if v ~= Title and v ~= MiniBtn and not v:IsA("UICorner") then v.Visible = false end
        end
        MiniBtn.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 230, 0, 350), "Out", "Quad", 0.3)
        for _, v in pairs(MainFrame:GetChildren()) do
            if v ~= Title and v ~= MiniBtn and not v:IsA("UICorner") then v.Visible = true end
        end
        MiniBtn.Text = "-"
    end
end)

-- حلقة السرعة الدائمة
game:GetService("RunService").RenderStepped:Connect(function()
    if speedEnabled then
        pcall(function()
            local hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = tonumber(SpeedInput.Text) or 16
            end
        end)
    end
end)
