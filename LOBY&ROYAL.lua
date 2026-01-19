--[[
    🚀 BRAINROT SUPREME HUB - GOD MODE EDITION 2026
    المميزات الجديدة: God Mode (لا تموت/لا تضرب)، تحديد بيتك، نقل للمراحل
]]

-- تنظيف النسخ القديمة
local old = game:GetService("CoreGui"):FindFirstChild("BrainrotExpertHub")
if old then old:Destroy() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local HomeBtn = Instance.new("TextButton")
local SetHomeBtn = Instance.new("TextButton") -- جديد: حفظ بيتك
local StageBtn = Instance.new("TextButton") -- جديد: نقل للمراحل
local GodToggle = Instance.new("TextButton") -- جديد: God Mode
local SaveBtn = Instance.new("TextButton")
local LoadBtn = Instance.new("TextButton")
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
MainFrame.Size = UDim2.new(0, 230, 0, 450) -- مساحة أكبر
MainFrame.Active = true
MainFrame.Draggable = true
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = "BRAINROT GOD MODE 🌊 2026"
Title.TextColor3 = Color3.fromRGB(255, 0, 150)
Title.TextSize = 16
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 12)

local homeLocation = nil -- مكان البيت الخاص
local savedLocation = nil
local godEnabled = false

-- 1. حفظ مكان البيت الخاص
SetHomeBtn.Parent = MainFrame
SetHomeBtn.Size = UDim2.new(0.9, 0, 0, 40)
SetHomeBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
SetHomeBtn.Text = "حفظ بيتي الخاص 🏠"
SetHomeBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
SetHomeBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", SetHomeBtn)

SetHomeBtn.MouseButton1Click:Connect(function()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if root then
        homeLocation = root.CFrame
        SetHomeBtn.Text = "✅ بيتك محفوظ!"
        task.wait(1)
        SetHomeBtn.Text = "حفظ بيتي الخاص 🏠"
    end
end)

-- 2. زر العودة لبيتك
HomeBtn.Parent = MainFrame
HomeBtn.Size = UDim2.new(0.9, 0, 0, 40)
HomeBtn.Position = UDim2.new(0.05, 0, 0.27, 0)
HomeBtn.Text = "نقل لبيتي 🏠"
HomeBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
HomeBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", HomeBtn)

HomeBtn.MouseButton1Click:Connect(function()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if root and homeLocation then
        root.CFrame = homeLocation
    else
        HomeBtn.Text = "⚠️ احفظ بيتك أول!"
        task.wait(1)
        HomeBtn.Text = "نقل لبيتي 🏠"
    end
end)

-- 3. نقل للمراحل (Stages)
StageBtn.Parent = MainFrame
StageBtn.Size = UDim2.new(0.9, 0, 0, 40)
StageBtn.Position = UDim2.new(0.05, 0, 0.40, 0)
StageBtn.Text = "نقل للمرحلة 1 (اضغط لتغيير)"
StageBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
StageBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", StageBtn)

local stageNum = 1
local stagePositions = { -- أمثلة إحداثيات مراحل (عدلها حسب اللعبة)
    CFrame.new(0, 50, 0), -- stage 1
    CFrame.new(100, 50, 0), -- stage 2
    CFrame.new(200, 50, 0), -- stage 3
    -- أضف المزيد
}

StageBtn.MouseButton1Click:Connect(function()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if root and stagePositions[stageNum] then
        root.CFrame = stagePositions[stageNum]
        stageNum = stageNum + 1
        if stageNum > #stagePositions then stageNum = 1 end
        StageBtn.Text = "نقل للمرحلة " .. stageNum
    end
end)

-- 4. God Mode كامل
GodToggle.Parent = MainFrame
GodToggle.Size = UDim2.new(0.9, 0, 0, 45)
GodToggle.Position = UDim2.new(0.05, 0, 0.53, 0)
GodToggle.Text = "God Mode: OFF (لا تموت/لا تضرب)"
GodToggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
GodToggle.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", GodToggle)

GodToggle.MouseButton1Click:Connect(function()
    godEnabled = not godEnabled
    GodToggle.Text = godEnabled and "God Mode: ON 🔥" or "God Mode: OFF"
    GodToggle.BackgroundColor3 = godEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(150, 0, 0)
end)

-- باقي الأزرار (Save/Load/Speed) كما هي، بس نقلتها
-- ... (انسخ باقي الكود من سكريبتك الأصلي هنا للسpeed/save/load/mini)

-- حلقة God Mode + Speed
RunService.RenderStepped:Connect(function()
    pcall(function()
        local char = player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")
            
            if godEnabled then
                -- لا تموت أبدًا
                hum.Health = hum.MaxHealth
                -- لا تضرب (حماية من الـhits)
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                -- حماية من touch kills
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("TouchTransmitter") or obj.Name:find("Kill") then
                        obj.Parent = nil
                    end
                end
            end
            
            if speedEnabled then
                hum.WalkSpeed = tonumber(SpeedInput.Text) or 200
            end
        end
    end)
end)

print("🚀 Brainrot God Hub جاهز!")
