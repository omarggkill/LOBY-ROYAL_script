--[[
    ╔════════════════════════════════════════════╗
    ║      LOBY & ROYAL - THE GHOST GOD V33          ║
    ║    (DEAD GHOST + INSTANT KILL + AIM)       ║
    ╚════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local p = Players.LocalPlayer

-- تنظيف النسخ القديمة
if game:GetService("CoreGui"):FindFirstChild("LobyRoyalV33") then
    game:GetService("CoreGui").LobyRoyalV33:Destroy()
end

local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "LobyRoyalV33"

-- نظام السحب (Draggable)
local function makeDraggable(frame, parent)
    parent = parent or frame
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = parent.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            parent.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

-- الواجهة الرئيسية
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 350, 0, 430)
main.Position = UDim2.new(0.5, -175, 0.4, -215)
main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = Color3.fromRGB(255, 0, 0)
mainStroke.Thickness = 3

local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 45)
topBar.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 15)
makeDraggable(topBar, main)

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, 0, 1, 0)
title.Text = "LOBY & ROYAL V33 [PHANTOM]"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBlack
title.BackgroundTransparency = 1

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(0.95, 0, 0.85, 0)
scroll.Position = UDim2.new(0.025, 0, 0.12, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 0
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 10)

local function createToggle(name, callback)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(0.95, 0, 0, 50)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    b.Text = name .. " [OFF]"
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    
    local state = false
    b.MouseButton1Click:Connect(function()
        state = not state
        b.BackgroundColor3 = state and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(25, 25, 25)
        b.Text = name .. (state and " [ON]" or " [OFF]")
        callback(state)
    end)
end

-- [ المتغيرات ]
local killAuraOn, ghostModeOn = false, false
local selectedTool = nil

-- 1. الايم بوت + الاوتو كليكر الملي ثانية
createToggle("إبادة تلقائية + إيم بوت (مليار/10)", function(v)
    killAuraOn = v
    if v then
        selectedTool = p.Character:FindFirstChildOfClass("Tool")
    end
end)

-- 2. الشبح الميت (Dead Ghost Mode)
createToggle("نمط الشبح (النسخة المخفية)", function(v)
    ghostModeOn = v
    if v and p.Character then
        -- تكنيك الاختفاء المطلق: قتل الشخصية برمجياً مع ابقاء الكاميرا
        p.Character.Archivable = true
        local clone = p.Character:Clone()
        clone.Parent = workspace
        
        for _, part in pairs(p.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = 1
                if part.Name ~= "HumanoidRootPart" then part.CanCollide = false end
            end
            if part:IsA("BillboardGui") or part.Name == "Head" then
                if part:FindFirstChildOfClass("BillboardGui") then part:FindFirstChildOfClass("BillboardGui").Enabled = false end
            end
        end
        -- إخفاء الاسم والـ UI فوق الرأس
        p.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    else
        p.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
        -- إعادة الرؤية (تحتاج ريسبون للعودة للحالة الطبيعية)
    end
end)

-- 3. السرعة والنط (عشان التحكم)
createToggle("سرعة السفاح ⚡", function(v) p.Character.Humanoid.WalkSpeed = v and 150 or 16 end)
createToggle("نطة الأرنب 🚀", function(v) p.Character.Humanoid.JumpPower = v and 150 or 50 end)

-- [ حلقة التشغيل الفورية ]
RunService.RenderStepped:Connect(function()
    if killAuraOn then
        selectedTool = p.Character:FindFirstChildOfClass("Tool")
        if selectedTool then
            for _, enemy in pairs(Players:GetPlayers()) do
                if enemy ~= p and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (p.Character.HumanoidRootPart.Position - enemy.Character.HumanoidRootPart.Position).Magnitude
                    if dist < 80 then
                        -- الضرب بسرعة الملي ثانية
                        selectedTool:Activate()
                        local h = selectedTool:FindFirstChild("Handle") or selectedTool:FindFirstChildOfClass("BasePart")
                        if h then
                            firetouchinterest(enemy.Character.HumanoidRootPart, h, 0)
                            firetouchinterest(enemy.Character.HumanoidRootPart, h, 1)
                        end
                    end
                end
            end
        end
    end
end)

-- زر التصغير (أيقونة الجمجمة)
local miniBtn = Instance.new("ImageButton", sg)
miniBtn.Size = UDim2.new(0, 70, 0, 70)
miniBtn.Position = UDim2.new(0, 10, 0.4, 0)
miniBtn.Image = "rbxassetid://12543180419"
miniBtn.Visible = false
miniBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(1, 0)
makeDraggable(miniBtn)

local close = Instance.new("TextButton", topBar)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0.5, -15)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
close.MouseButton1Click:Connect(function() main.Visible = false miniBtn.Visible = true end)
miniBtn.MouseButton1Click:Connect(function() main.Visible = true miniBtn.Visible = false end)ظم
