--[[
    ╔════════════════════════════════════════════╗
    ║      LOBY & ROYAL - ULTIMATE GOD V38       ║
    ║    (MAX POWER - NO ERRORS - BYPASS)        ║
    ╚════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local p = Players.LocalPlayer
local Character = p.Character or p.CharacterAdded:Wait()

-- تنظيف السكربتات القديمة
if game:GetService("CoreGui"):FindFirstChild("LobyRoyalV38") then
    game:GetService("CoreGui").LobyRoyalV38:Destroy()
end

local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "LobyRoyalV38"

-- [ نظام التحريك العالمي المعزز ]
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

-- الواجهة (تصميم أحمر ناري)
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 350, 0, 430)
main.Position = UDim2.new(0.5, -175, 0.4, -215)
main.BackgroundColor3 = Color3.fromRGB(5, 0, 0)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255, 0, 0)
stroke.Thickness = 4

local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 45)
topBar.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 15)
EnableDrag(topBar, main)

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, 0, 1, 0)
title.Text = "LOBY & ROYAL [ULTIMATE GOD]"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBlack
title.TextSize = 18
title.BackgroundTransparency = 1

-- أيقونة الجمجمة (كبيرة وواضحة)
local miniBtn = Instance.new("ImageButton", sg)
miniBtn.Size = UDim2.new(0, 80, 0, 80)
miniBtn.Position = UDim2.new(0, 20, 0.4, 0)
miniBtn.Image = "rbxassetid://12543180419" 
miniBtn.Visible = false
miniBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", miniBtn).Color = Color3.new(1, 0, 0)
EnableDrag(miniBtn)

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(0.95, 0, 0.82, 0)
scroll.Position = UDim2.new(0.025, 0, 0.15, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 0
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 12)

local function createToggle(name, callback)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(0.95, 0, 0, 50)
    b.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
    b.Text = name .. " [OFF]"
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 12)
    
    local state = false
    b.MouseButton1Click:Connect(function()
        state = not state
        b.BackgroundColor3 = state and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(30, 0, 0)
        b.Text = name .. (state and " [ON]" or " [OFF]")
        callback(state)
    end)
end

-- [ المتغيرات المعززة ]
local killOn, toolLockOn = false, false
local lockedTool = nil
local walkSpeed, jumpPower = 16, 50

-- 1. تثبيت السلاح (النظام الخارق)
createToggle("تثبيت السلاح (قوة 100%)", function(v)
    toolLockOn = v
    if v then
        lockedTool = p.Character:FindFirstChildOfClass("Tool") or p.Backpack:FindFirstChildOfClass("Tool")
    else
        lockedTool = nil
    end
end)

-- 2. إيم بوت السفاح (Auto Kill & Aim)
createToggle("إبادة السفاح (إيم بوت + أوتو)", function(v)
    killOn = v
end)

-- 3. السرعة والقفز المعزز
createToggle("سرعة السفاح (Bypass)", function(v) walkSpeed = v and 200 or 16 end)
createToggle("قفزة خارقة (High)", function(v) jumpPower = v and 180 or 50 end)

-- [ القلب النابض للسكربت - سرعة 0 ملي ثانية ]
RunService.RenderStepped:Connect(function()
    local char = p.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = walkSpeed
        char.Humanoid.JumpPower = jumpPower
        char.Humanoid.UseJumpPower = true
    end

    -- تثبيت السلاح (Hard Lock)
    if toolLockOn and lockedTool then
        if lockedTool.Parent ~= char then
            lockedTool.Parent = char
        end
    end

    -- نظام القتل المدمر
    if killOn and lockedTool then
        lockedTool:Activate() -- كليكر بأقصى سرعة
        
        for _, enemy in pairs(Players:GetPlayers()) do
            if enemy ~= p and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
                local enemyRoot = enemy.Character.HumanoidRootPart
                local myRoot = char.HumanoidRootPart
                local dist = (myRoot.Position - enemyRoot.Position).Magnitude
                
                if dist < 95 then
                    -- إيم بوت ليزر (توجيه الكاميرا والسلاح)
                    local handle = lockedTool:FindFirstChild("Handle") or lockedTool:FindFirstChildOfClass("BasePart")
                    if handle then
                        -- نظام الضرر الفوري
                        firetouchinterest(enemyRoot, handle, 0)
                        firetouchinterest(enemyRoot, handle, 1)
                        
                        -- توجيه الليزر (في حال وجود ريموت)
                        local remote = lockedTool:FindFirstChildOfClass("RemoteEvent")
                        if remote then
                            remote:FireServer(enemyRoot.Position)
                        end
                    end
                end
            end
        end
    end
end)

-- أزرار التصغير
local close = Instance.new("TextButton", topBar)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -40, 0.5, -15)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
close.MouseButton1Click:Connect(function() main.Visible = false miniBtn.Visible = true end)
miniBtn.MouseButton1Click:Connect(function() main.Visible = true miniBtn.Visible = false end)
