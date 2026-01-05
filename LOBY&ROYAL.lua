--[[
    ╔════════════════════════════════════════════╗
    ║      LOBY & ROYAL - RED LOCK V42           ║
    ║    (استهداف أحمر حقيقي + ضرب سيرفر)        ║
    ╚════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local p = Players.LocalPlayer

-- تنظيف النسخ القديمة
if game:GetService("CoreGui"):FindFirstChild("LobyRoyalV42") then
    game:GetService("CoreGui").LobyRoyalV42:Destroy()
end

local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "LobyRoyalV42"

-- نظام التحريك الاحترافي
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

-- الواجهة
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 340, 0, 420)
main.Position = UDim2.new(0.5, -170, 0.4, -210)
main.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255, 0, 0)
stroke.Thickness = 3

local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 45)
topBar.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 15)
EnableDrag(topBar, main)

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, 0, 1, 0)
title.Text = "LOBY & ROYAL V42 [RED LOCK]"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBlack
title.BackgroundTransparency = 1

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(0.95, 0, 0.82, 0)
scroll.Position = UDim2.new(0.025, 0, 0.15, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 0
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 12)

local function createToggle(name, callback)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(0.95, 0, 0, 50)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    b.Text = name .. " [OFF]"
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 12)
    local state = false
    b.MouseButton1Click:Connect(function()
        state = not state
        b.BackgroundColor3 = state and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(25, 25, 25)
        b.Text = name .. (state and " [ON]" or " [OFF]")
        callback(state)
    end)
end

-- [ الأوامر القوية ]
local redAimOn, toolLockOn = false, false
local lockedToolName = ""

createToggle("تثبيت السلاح الحالي 🔒", function(v)
    toolLockOn = v
    if v then
        local tool = p.Character:FindFirstChildOfClass("Tool") or p.Backpack:FindFirstChildOfClass("Tool")
        if tool then lockedToolName = tool.Name end
    end
end)

createToggle("إيم بوت أحمر (Red Lock) 🎯", function(v)
    redAimOn = v
end)

createToggle("سرعة السفاح ⚡", function(v) p.Character.Humanoid.WalkSpeed = v and 180 or 16 end)

-- [ محرك الاستهداف والضرب الحقيقي ]
RunService.Heartbeat:Connect(function()
    local char = p.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    -- تثبيت السلاح
    if toolLockOn and lockedToolName ~= "" then
        local tool = p.Backpack:FindFirstChild(lockedToolName)
        if tool then tool.Parent = char end
    end

    -- نظام Red Lock Aura
    if redAimOn then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
            
            for _, enemy in pairs(Players:GetPlayers()) do
                if enemy ~= p and enemy.Character and enemy.Character:FindFirstChild("Humanoid") and enemy.Character.Humanoid.Health > 0 then
                    local enemyPart = enemy.Character:FindFirstChild("HumanoidRootPart")
                    if enemyPart then
                        local dist = (char.HumanoidRootPart.Position - enemyPart.Position).Magnitude
                        
                        if dist < 100 then -- نطاق الأورا
                            -- 1. محاكاة "الهدف الأحمر" للسيرفر
                            local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildOfClass("BasePart")
                            if handle then
                                -- إجبار السيرفر على رؤية "اللمس" بين السلاح والعدو
                                firetouchinterest(enemyPart, handle, 0)
                                firetouchinterest(enemyPart, handle, 1)
                                
                                -- 2. إرسال إشارة الليزر الحقيقية (التي تظهر اللون الأحمر في الماب)
                                local remote = tool:FindFirstChildOfClass("RemoteEvent") or tool:FindFirstChild("Remote") or tool:FindFirstChild("OnShoot")
                                if remote then
                                    -- نبعت للسيرفر إننا ضاربين في نص جسم العدو بالظبط
                                    remote:FireServer(enemyPart.Position)
                                    remote:FireServer(enemy.Character.Head.Position)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- أيقونة الجمجمة
local miniBtn = Instance.new("ImageButton", sg)
miniBtn.Size = UDim2.new(0, 70, 0, 70); miniBtn.Position = UDim2.new(0, 20, 0.4, 0)
miniBtn.Image = "rbxassetid://12543180419"; miniBtn.Visible = false
miniBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(1, 0)
EnableDrag(miniBtn)

local close = Instance.new("TextButton", topBar)
close.Size = UDim2.new(0, 30, 0, 30); close.Position = UDim2.new(1, -40, 0.5, -15)
close.Text = "X"; close.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
close.MouseButton1Click:Connect(function() main.Visible = false; miniBtn.Visible = true end)
miniBtn.MouseButton1Click:Connect(function() main.Visible = true; miniBtn.Visible = false end)
