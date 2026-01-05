--[[
    ╔════════════════════════════════════════════╗
    ║      LOBY & ROYAL - ULTIMATE V34           ║
    ║    (التحريك الكامل + الشبح + إبادة مليار)  ║
    ╚════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local p = Players.LocalPlayer

-- تنظيف السكربتات القديمة
if game:GetService("CoreGui"):FindFirstChild("LobyRoyalV34") then
    game:GetService("CoreGui").LobyRoyalV34:Destroy()
end

local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "LobyRoyalV34"

-- [[ نظام التحريك العالمي - يعمل على الجوال والكمبيوتر ]]
local function EnableDrag(frame, parent)
    parent = parent or frame
    local dragging, dragInput, dragStart, startPos
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = parent.Position
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            parent.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- القائمة الرئيسية
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 340, 0, 400)
main.Position = UDim2.new(0.5, -170, 0.4, -200)
main.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255, 0, 0)
stroke.Thickness = 3

-- الشريط العلوي (من هنا تسحب القائمة)
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 45)
topBar.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 15)
EnableDrag(topBar, main) -- تفعيل السحب للقائمة

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, 0, 1, 0)
title.Text = "LOBY & ROYAL V34"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBlack
title.BackgroundTransparency = 1

-- أيقونة الجمجمة (تسحبها لأي مكان عند التصغير)
local miniBtn = Instance.new("ImageButton", sg)
miniBtn.Size = UDim2.new(0, 70, 0, 70)
miniBtn.Position = UDim2.new(0, 10, 0.5, -35)
miniBtn.Image = "rbxassetid://12543180419" 
miniBtn.Visible = false
miniBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(1, 0)
EnableDrag(miniBtn) -- تفعيل السحب للجمجمة

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(0.95, 0, 0.85, 0)
scroll.Position = UDim2.new(0.025, 0, 0.12, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 0
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 10)

local function createToggle(name, callback)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(0.95, 0, 0, 50)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.Text = name .. " [OFF]"
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    
    local state = false
    b.MouseButton1Click:Connect(function()
        state = not state
        b.BackgroundColor3 = state and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(30, 30, 30)
        b.Text = name .. (state and " [ON]" or " [OFF]")
        callback(state)
    end)
end

-- [ الميزات ]
local killOn, ghostOn = false, false

createToggle("إبادة تلقائية (ضرب ليزري)", function(v) killOn = v end)

createToggle("نمط الشبح (إخفاء الجسم والاسم)", function(v)
    ghostOn = v
    if p.Character then
        for _, part in pairs(p.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = v and 1 or 0
                if part.Name ~= "HumanoidRootPart" then part.CanCollide = not v end
            end
            if part:IsA("BillboardGui") then part.Enabled = not v end
        end
    end
end)

createToggle("سرعة السفاح ⚡", function(v) p.Character.Humanoid.WalkSpeed = v and 150 or 16 end)

-- أزرار الإغلاق والفتح
local close = Instance.new("TextButton", topBar)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -40, 0.5, -15)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
close.MouseButton1Click:Connect(function() main.Visible = false miniBtn.Visible = true end)
miniBtn.MouseButton1Click:Connect(function() main.Visible = true miniBtn.Visible = false end)

-- حلقة الضرب (Kill Aura)
RunService.Heartbeat:Connect(function()
    if killOn then
        local tool = p.Character:FindFirstChildOfClass("Tool")
        if tool then
            for _, enemy in pairs(Players:GetPlayers()) do
                if enemy ~= p and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
                    if (p.Character.HumanoidRootPart.Position - enemy.Character.HumanoidRootPart.Position).Magnitude < 80 then
                        tool:Activate()
                        local h = tool:FindFirstChild("Handle") or tool:FindFirstChildOfClass("BasePart")
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
