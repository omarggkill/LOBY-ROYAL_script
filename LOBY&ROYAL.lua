--[[
    ╔════════════════════════════════════════════╗
    ║      LOBY & ROYAL - GHOST GOD V31          ║
    ║    Invisible Phantom - God Aimbot 10B/10   ║
    ╚════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local p = Players.LocalPlayer

-- تنظيف النسخ القديمة
if game:GetService("CoreGui"):FindFirstChild("LobyRoyalV31") then
    game:GetService("CoreGui").LobyRoyalV31:Destroy()
end

local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "LobyRoyalV31"

-- نظام تحريك القوائم الاحترافي
local function makeDraggable(frame, parent)
    parent = parent or frame
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = parent.Position
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

-- القائمة الرئيسية (تصميم فخم جداً)
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 360, 0, 420)
main.Position = UDim2.new(0.5, -180, 0.4, -210)
main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = Color3.fromRGB(255, 0, 50)
mainStroke.Thickness = 3

local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 45)
topBar.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 15)
makeDraggable(topBar, main)

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, 0, 1, 0)
title.Text = "LOBY & ROYAL V31 [GOD MODE]"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBlack
title.TextSize = 18
title.BackgroundTransparency = 1

-- أيقونة الجمجمة المتحركة
local miniBtn = Instance.new("ImageButton", sg)
miniBtn.Size = UDim2.new(0, 70, 0, 70)
miniBtn.Position = UDim2.new(0, 15, 0.4, 0)
miniBtn.Image = "rbxassetid://12543180419" -- أيقونة جمجمة مرعبة
miniBtn.Visible = false
miniBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", miniBtn).Color = Color3.new(1, 0, 0)
makeDraggable(miniBtn)

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(0.95, 0, 0.85, 0)
scroll.Position = UDim2.new(0.025, 0, 0.12, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 0
local list = Instance.new("UIListLayout", scroll)
list.Padding = UDim.new(0, 12)
list.HorizontalAlignment = Enum.HorizontalAlignment.Center

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

--- البرمجة الخارقة (V31) ---
local selectedTool, lockActive, ghostActive, aimbotOn = nil, false, false, false
local walkSpeed, jumpPower = 16, 50

-- 1. تثبيت السلاح (بما في ذلك الليزر أو المضرب)
createToggle("قفل السلاح المختار 🔒", function(v)
    if v then
        selectedTool = p.Character:FindFirstChildOfClass("Tool")
        lockActive = true
    else
        lockActive = false
    end
end)

-- 2. الضرب التلقائي (الذكاء الاصطناعي - مليار/10)
createToggle("إبادة البشر (God Aimbot) ⚔️", function(v) aimbotOn = v end)

-- 3. الاختفاء المطلق (Phantom Mode)
createToggle("نمط الشبح المستنسخ (Invisible) 👻", function(v)
    ghostActive = v
    if p.Character then
        for _, part in pairs(p.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = v and 1 or 0
                if part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = not v
                end
            end
            if part:IsA("TextLabel") or part:IsA("BillboardGui") then -- إخفاء الاسم
                part.Enabled = not v
            end
        end
    end
end)

-- 4. السرعة الفائقة
createToggle("سرعة السفاح ⚡", function(v) walkSpeed = v and 200 or 16 end)

-- 5. القفز العالي
createToggle("نطة الأرنب 🚀", function(v) jumpPower = v and 180 or 50 end)

-- تصغير وفتح
local close = Instance.new("TextButton", topBar)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -40, 0.5, -15)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
close.MouseButton1Click:Connect(function() main.Visible = false miniBtn.Visible = true end)
miniBtn.MouseButton1Click:Connect(function() main.Visible = true miniBtn.Visible = false end)

-- الـ Loop الأساسي المحسن
RunService.RenderStepped:Connect(function()
    if p.Character and p.Character:FindFirstChild("Humanoid") then
        p.Character.Humanoid.WalkSpeed = walkSpeed
        p.Character.Humanoid.JumpPower = jumpPower
    end

    if lockActive and selectedTool then
        selectedTool.Parent = p.Character
    end

    if aimbotOn and selectedTool then
        for _, enemy in pairs(Players:GetPlayers()) do
            if enemy ~= p and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (p.Character.HumanoidRootPart.Position - enemy.Character.HumanoidRootPart.Position).Magnitude
                if dist < 90 then
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
    
    -- تثبيت الاختفاء ومنع ظهور الـ Brainrot عليك
    if ghostActive and p.Character then
        if p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChildOfClass("BillboardGui") then
            p.Character.Head:FindFirstChildOfClass("BillboardGui").Enabled = false
        end
    end
end)
