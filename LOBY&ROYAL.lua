--[[
    ╔════════════════════════════════════════════╗
    ║      LOBY & ROYAL - MASTER PHANTOM V47     ║
    ║    (Ghost Mode + Hard Lock + Red Aura)     ║
    ╚════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local p = Players.LocalPlayer

-- تنظيف النسخ القديمة
if game:GetService("CoreGui"):FindFirstChild("LobyRoyalV47") then
    game:GetService("CoreGui").LobyRoyalV47:Destroy()
end

local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "LobyRoyalV47"

-- [ نظام التحريك ]
local function EnableDrag(frame, parent)
    parent = parent or frame
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = parent.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            parent.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

-- [ الواجهة الرئيسية ]
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 350, 0, 460); main.Position = UDim2.new(0.5, -175, 0.4, -230)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)
local stroke = Instance.new("UIStroke", main); stroke.Color = Color3.fromRGB(255, 0, 0); stroke.Thickness = 3

local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 45); topBar.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 15)
EnableDrag(topBar, main)

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, 0, 1, 0); title.Text = "LOBY & ROYAL [PHANTOM V47]"; title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBlack; title.BackgroundTransparency = 1

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(0.95, 0, 0.85, 0); scroll.Position = UDim2.new(0.025, 0, 0.12, 0)
scroll.BackgroundTransparency = 1; scroll.ScrollBarThickness = 0
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 10)

-- [ الوظائف المدمجة ]
local ghostOn, auraOn, toolLockOn = false, false, false
local fakeChar = nil
local lockedToolName = ""

local function createToggle(name, callback)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(0.95, 0, 0, 45); b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.Text = name .. " [OFF]"; b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    local state = false
    b.MouseButton1Click:Connect(function()
        state = not state
        b.BackgroundColor3 = state and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(30, 30, 30)
        b.Text = name .. (state and " [ON]" or " [OFF]")
        callback(state)
    end)
end

-- 1. نظام الشبح (Ghost Mode) - نسخة مخفية ونسخة تسرق
createToggle("نمط الشبح (Ghost Mode) 👻", function(v)
    ghostOn = v
    local char = p.Character
    if v then
        char.Archivable = true
        fakeChar = char:Clone()
        fakeChar.Parent = workspace
        fakeChar.HumanoidRootPart.Anchored = true
        -- جعل الشخصية الحقيقية مخفية تماماً للناس
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = 1
            end
        end
    else
        if fakeChar then fakeChar:Destroy(); fakeChar = nil end
        for _, part in pairs(p.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = 0
            end
        end
    end
end)

-- 2. تثبيت السلاح (Hard Lock) - ميتشالش من إيدك أبداً
createToggle("تثبيت السلاح (Hard Lock) 🔒", function(v)
    toolLockOn = v
    if v then
        local tool = p.Character:FindFirstChildOfClass("Tool") or p.Backpack:FindFirstChildOfClass("Tool")
        if tool then lockedToolName = tool.Name end
    end
end)

-- 3. هالة الإبادة الحمراء (Red Aura)
createToggle("هالة الإبادة الحمراء 🔴", function(v)
    auraOn = v
end)

-- [ حلقة التشغيل القوية ]
RunService.Heartbeat:Connect(function()
    local char = p.Character
    if not char then return end

    -- تثبيت السلاح (Force Parenting)
    if toolLockOn and lockedToolName ~= "" then
        local tool = p.Backpack:FindFirstChild(lockedToolName) or char:FindFirstChild(lockedToolName)
        if tool and tool.Parent ~= char then
            tool.Parent = char
        end
    end

    -- نظام الأورا والضرب وتلوين الأعداء
    if auraOn then
        local currentTool = char:FindFirstChildOfClass("Tool")
        for _, enemy in pairs(Players:GetPlayers()) do
            if enemy ~= p and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
                local enemyChar = enemy.Character
                local dist = (char.HumanoidRootPart.Position - enemyChar.HumanoidRootPart.Position).Magnitude
                
                if dist < 100 then
                    -- تلوين العدو بالأحمر (Highlight)
                    if not enemyChar:FindFirstChild("AuraTarget") then
                        local hl = Instance.new("Highlight", enemyChar)
                        hl.Name = "AuraTarget"
                        hl.FillColor = Color3.fromRGB(255, 0, 0)
                        hl.FillTransparency = 0.5
                    end
                    
                    -- الضرب التلقائي (Remote + Touch)
                    if currentTool then
                        currentTool:Activate()
                        local handle = currentTool:FindFirstChild("Handle") or currentTool:FindFirstChildOfClass("BasePart")
                        if handle then
                            firetouchinterest(enemyChar.HumanoidRootPart, handle, 0)
                            firetouchinterest(enemyChar.HumanoidRootPart, handle, 1)
                        end
                        -- إرسال ريموت الليزر
                        local remote = currentTool:FindFirstChildOfClass("RemoteEvent")
                        if remote then remote:FireServer(enemyChar.HumanoidRootPart.Position) end
                    end
                else
                    if enemyChar:FindFirstChild("AuraTarget") then enemyChar.AuraTarget:Destroy() end
                end
            end
        end
    end
end)

-- تصغير الواجهة (الجمجمة)
local miniBtn = Instance.new("ImageButton", sg)
miniBtn.Size = UDim2.new(0, 75, 0, 75); miniBtn.Position = UDim2.new(0, 10, 0.4, 0)
miniBtn.Image = "rbxassetid://12543180419"; miniBtn.Visible = false
miniBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(1, 0)
EnableDrag(miniBtn)

local close = Instance.new("TextButton", topBar)
close.Size = UDim2.new(0, 30, 0, 30); close.Position = UDim2.new(1, -40, 0.5, -15)
close.Text = "X"; close.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
close.MouseButton1Click:Connect(function() main.Visible = false; miniBtn.Visible = true end)
miniBtn.MouseButton1Click:Connect(function() main.Visible = true; miniBtn.Visible = false end)
