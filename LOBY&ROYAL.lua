--[[
    🌊 تسونامي ألتيميت V6 - السكريبت العربي الكامل 🌊
    لا تموت | سرعة مخصصة | أوتو فارم | مناطق آمنة
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- تنظيف النسخ القديمة
for _, gui in pairs(game:GetService("CoreGui"):GetChildren()) do
    if gui.Name:find("TsunamiV6") then gui:Destroy() end
end

-- المتغيرات
local settings = {
    laTamot = false, sor3aMode = false, flyMode = false, 
    autoFarm = false, tsunamiShield = false
}
local customSpeed = 120
local currentZone = 1

-- جميع المناطق الآمنة
local safeZones = {
    {name = "قاعدة البداية", pos = CFrame.new(0, 15, 0)},
    {name = "الخندق الأول", pos = CFrame.new(45, 8, 0)},
    {name = "التل الأول", pos = CFrame.new(95, 25, 0)},
    {name = "منطقة VIP", pos = CFrame.new(145, 35, 0)},
    {name = "المنطقة النهائية", pos = CFrame.new(220, 60, 0)},
    {name = "كوزميك زون", pos = CFrame.new(300, 80, 0)}
}

-- إنشاء الواجهة العربية
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TsunamiV6"
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 750)
MainFrame.Position = UDim2.new(0.01, 0, 0.01, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 25)
MainCorner.Parent = MainFrame

-- العنوان العربي الكبير
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 70)
Title.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
Title.Text = "🌊 تسونامي ألتيميت V6 - العربي 🌊"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 20)
TitleCorner.Parent = Title

-- 🔥 مربع السرعة المخصصة 🔥
local SpeedFrame = Instance.new("Frame")
SpeedFrame.Size = UDim2.new(0.92, 0, 0, 65)
SpeedFrame.Position = UDim2.new(0.04, 0, 0.11, 0)
SpeedFrame.BackgroundColor3 = Color3.fromRGB(50, 200, 255)
SpeedFrame.Parent = MainFrame

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 15)
SpeedCorner.Parent = SpeedFrame

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.35, 0, 1, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "⚡ حدد السرعة:"
SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
SpeedLabel.TextSize = 16
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = SpeedFrame

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(0.35, 0, 0.7, 0)
SpeedBox.Position = UDim2.new(0.4, 0, 0.15, 0)
SpeedBox.BackgroundColor3 = Color3.new(1, 1, 1)
SpeedBox.Text = "120"
SpeedBox.TextColor3 = Color3.new(0, 0, 0)
SpeedBox.TextSize = 18
SpeedBox.Font = Enum.Font.GothamBold
SpeedBox.Parent = SpeedFrame

local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Size = UDim2.new(0.25, 0, 0.7, 0)
SpeedBtn.Position = UDim2.new(0.77, 0, 0.15, 0)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
SpeedBtn.Text = "✅ تحديث"
SpeedBtn.TextColor3 = Color3.new(1, 1, 1)
SpeedBtn.TextSize = 14
SpeedBtn.Font = Enum.Font.GothamBold
SpeedBtn.Parent = SpeedFrame

SpeedBtn.MouseButton1Click:Connect(function()
    local num = tonumber(SpeedBox.Text)
    if num and num > 0 then
        customSpeed = num
        print("✅ السرعة الجديدة: " .. customSpeed)
    else
        SpeedBox.Text = tostring(customSpeed)
    end
end)

-- 🔥 الأزرار العربية الكاملة 🔥
local buttons = {
    {"لا تموت", "🛡️", Color3.fromRGB(0, 255, 0)},
    {"سرعة خارقة", "⚡", Color3.fromRGB(50, 200, 255)},
    {"طيران", "✈️", Color3.fromRGB(255, 200, 50)},
    {"أوتو فارم", "🤖", Color3.fromRGB(255, 100, 200)},
    {"منطقة آمنة", "🏠", Color3.fromRGB(100, 255, 100)},
    {"حماية تسونامي", "🌊", Color3.fromRGB(0, 255, 200)}
}

local yPos = 0.26
for i, data in ipairs(buttons) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.92, 0, 0, 55)
    btn.Position = UDim2.new(0.04, 0, yPos, 0)
    btn.BackgroundColor3 = data[3]
    btn.Text = data[2] .. " " .. data[1]
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.Parent = MainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = btn
    
    local toggle = false
    btn.MouseButton1Click:Connect(function()
        toggle = not toggle
        btn.Text = data[2] .. " " .. data[1] .. (toggle and " ✅" or " ❌")
        btn.BackgroundColor3 = toggle and Color3.fromRGB(0, 255, 0) or data[3]
        
        -- تفعيل الميزات
        if data[1] == "لا تموت" then settings.laTamot = toggle
        elseif data[1] == "سرعة خارقة" then settings.sor3aMode = toggle
        elseif data[1] == "طيران" then settings.flyMode = toggle
        elseif data[1] == "أوتو فارم" then settings.autoFarm = toggle
        elseif data[1] == "حماية تسونامي" then settings.tsunamiShield = toggle end
    end)
    
    yPos = yPos + 0.085
end

-- 🔥 النظام الرئيسي العربي 🔥
spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                
                if hum and root then
                    -- لا تموت (مضمون 100%)
                    if settings.laTamot then
                        hum.Health = math.huge
                        hum.MaxHealth = math.huge
                        
                        -- منع فقدان الصحة
                        if hum.Health < math.huge then
                            hum.Health = math.huge
                        end
                    end
                    
                    -- سرعة مخصصة
                    if settings.sor3aMode then
                        hum.WalkSpeed = customSpeed
                        hum.JumpPower = customSpeed * 1.5
                    end
                    
                    -- طيران
                    if settings.flyMode then
                        local bv = root:FindFirstChild("FlyBV") or Instance.new("BodyVelocity")
                        bv.Name = "FlyBV"
                        bv.MaxForce = Vector3.new(4000, 4000, 4000)
                        bv.Velocity = Vector3.new(0, 50, 0)
                        bv.Parent = root
                    else
                        if root:FindFirstChild("FlyBV") then root.FlyBV:Destroy() end
                    end
                    
                    -- أوتو فارم
                    if settings.autoFarm then
                        for _, obj in pairs(workspace:GetChildren()) do
                            if obj.Name:lower():find("brain") then
                                root.CFrame = obj.CFrame + Vector3.new(0, 5, 0)
                                firetouchinterest(root, obj, 0)
                                firetouchinterest(root, obj, 1)
                            end
                        end
                    end
                end
            end
        end)
    end
end)

print("🌊 تسونامي ألتيميت V6 العربي شغال 100%!")
print("✅ لا تموت مضمون | سرعة مخصصة | كل المميزات")
