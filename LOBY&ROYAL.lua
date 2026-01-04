--[[
    ╔════════════════════════════════════════════╗
    ║      LOBY & ROYAL - THE GHOST GOD V31          ║
    ║    (تعديل شامل: اختفاء مطلق + إيم بوت مليار)  ║
    ╚════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local p = Players.LocalPlayer

-- تنظيف النسخ القديمة لعدم حدوث تعليق
if game:GetService("CoreGui"):FindFirstChild("LobyRoyalV31") then
    game:GetService("CoreGui").LobyRoyalV31:Destroy()
end

local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "LobyRoyalV31"

-- دالة التحريك الاحترافية (تسمح لك بسحب القائمة والجمجمة في أي مكان)
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

-- القائمة الرئيسية (تصميم Redz الجديد)
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 350, 0, 420)
main.Position = UDim2.new(0.5, -175, 0.4, -210)
main.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = Color3.fromRGB(255, 0, 0)
mainStroke.Thickness = 3

local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 45)
topBar.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 15)
makeDraggable(topBar, main) -- القائمة الآن قابلة للسحب!

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, 0, 1, 0)
title.Text = "LOBY & ROYAL V31 [GOD]"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBlack
title.TextSize = 16
title.BackgroundTransparency = 1

-- أيقونة الجمجمة (تظهر عند التصغير وقابلة للسحب)
local miniBtn = Instance.new("ImageButton", sg)
miniBtn.Size = UDim2.new(0, 70, 0, 70)
miniBtn.Position = UDim2.new(0, 10, 0.5, -35)
miniBtn.Image = "rbxassetid://12543180419" -- أيقونة جمجمة فخمة
miniBtn.Visible = false
miniBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", miniBtn).Color = Color3.new(1, 0, 0)
makeDraggable(miniBtn) -- الجمجمة الآن قابلة للسحب!

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, 0, 0.85, 0)
scroll.Position = UDim2.new(0, 0, 0.12, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 0
local list = Instance.new("UIListLayout", scroll)
list.Padding = UDim.new(0, 10)
list.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createToggle(name, callback)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(0.9, 0, 0, 50)
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    b.Text = name .. " [OFF]"
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    
    local state = false
    b.MouseButton1Click:Connect(function()
        state = not state
        b.BackgroundColor3 = state and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(35, 35, 35)
        b.Text = name .. (state and " [ON]" or " [OFF]")
        callback(state)
    end)
end

-- المتغيرات
local selectedTool, lockActive, ghostActive, aimbotOn = nil, false, false, false
local walkSpeed, jumpPower = 16, 50

-- 1. تثبيت السلاح
createToggle("تثبيت السلاح المختار", function(v)
    if v then
        selectedTool = p.Character:FindFirstChildOfClass("Tool")
        lockActive = true
    else
        lockActive = false
        selectedTool = nil
    end
end)

-- 2. إيم بوت جبار
createToggle("إيم بوت مليار/10 ⚔️", function(v) aimbotOn = v end)

-- 3. الاختفاء المطلق (الشبح)
createToggle("وضع الشبح المستنسخ 👻", function(v)
    ghostActive = v
    if p.Character then
        for _, part in pairs(p.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = v and 1 or 0
                if part.Name ~= "HumanoidRootPart" then part.CanCollide = not v end
            end
            if part:IsA("BillboardGui") or part:IsA("TextLabel") then
                part.Enabled = not v -- إخفاء الاسم والبرين روت
            end
        end
    end
end)

-- 4. السرعة والنط
createToggle("سرعة السفاح ⚡", function(v) walkSpeed = v and 180 or 16 end)
createToggle("نطة الأرنب 🚀", function(v) jumpPower = v and 160 or 50 end)

-- أزرار التحكم
local close = Instance.new("TextButton", topBar)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0.5, -15)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
close.MouseButton1Click:Connect(function() main.Visible = false miniBtn.Visible = true end)
miniBtn.MouseButton1Click:Connect(function() main.Visible = true miniBtn.Visible = false end)

-- التكرار البرمجي لضمان العمل
RunService.Heartbeat:Connect(function()
    if p.Character and p.Character:FindFirstChild("Humanoid") then
        p.Character.Humanoid.WalkSpeed = walkSpeed
        p.Character.Humanoid.JumpPower = jumpPower
    end
    if lockActive and selectedTool then selectedTool.Parent = p.Character end
    if aimbotOn and selectedTool then
        for _, enemy in pairs(Players:GetPlayers()) do
            if enemy ~= p and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
                if (p.Character.HumanoidRootPart.Position - enemy.Character.HumanoidRootPart.Position).Magnitude < 80 then
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
end)
