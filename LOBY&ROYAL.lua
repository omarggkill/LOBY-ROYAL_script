--[[
    LOBY & ROYAL - THE FINAL GOD VERSION
    Designed for: Steal a Brainrot
    Features: Anti-Hit (Kenger Style), Outside TP, Pro UI
]]

local p = game:GetService("Players").LocalPlayer
local sg = Instance.new("ScreenGui", p:WaitForChild("PlayerGui"))
sg.Name = "RoyalGodHub_"..math.random(9999)
sg.ResetOnSpawn = false

-- الإطار الرئيسي (تصميم ملكي فخم)
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 320, 0, 460)
frame.Position = UDim2.new(0.5, -160, 0.4, -230)
frame.BackgroundColor3 = Color3.fromRGB(15, 0, 30)
frame.Active = true
frame.Draggable = true 
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 20)

-- شعار Lorns Links
local img = Instance.new("ImageLabel", frame)
img.Size = UDim2.new(0, 200, 0, 110)
img.Position = UDim2.new(0.5, -100, 0.05, 0)
img.Image = "rbxassetid://16719572648"
img.BackgroundTransparency = 1

-- حاوية الأزرار
local holder = Instance.new("ScrollingFrame", frame)
holder.Size = UDim2.new(0.9, 0, 0.65, 0)
holder.Position = UDim2.new(0.05, 0, 0.32, 0)
holder.BackgroundTransparency = 1
holder.CanvasSize = UDim2.new(0, 0, 1.5, 0)
holder.ScrollBarThickness = 0

local layout = Instance.new("UIListLayout", holder)
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function addBtn(name, color)
    local btn = Instance.new("TextButton", holder)
    btn.Size = UDim2.new(0.95, 0, 0, 50)
    btn.BackgroundColor3 = color
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    return btn
end

-- الأزرار
local antiHit = addBtn("نظام الشبح (إخفاء + نسخة ثابتة) 👑", Color3.fromRGB(80, 0, 160))
local escape = addBtn("هروب سريع: خارج المنزل 🏃‍♂️", Color3.fromRGB(0, 100, 200))
local speed = addBtn("سرعة البرق (Fix)", Color3.fromRGB(40, 40, 40))
local jump = addBtn("قفزة العمالقة (Fix)", Color3.fromRGB(40, 40, 40))

--- البرمجة المتقدمة ---
local isGhost, clone, spdActive, jmpActive = false, nil, false, false

-- نظام الشبح (Anti-Hit)
antiHit.MouseButton1Click:Connect(function()
    local char = p.Character
    if not char then return end
    isGhost = not isGhost
    antiHit.Text = isGhost and "وضع الشبح: فعال ✅" or "نظام الشبح (إخفاء + نسخة ثابتة) 👑"
    antiHit.BackgroundColor3 = isGhost and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(80, 0, 160)

    if isGhost then
        char.Archivable = true
        clone = char:Clone()
        clone.Parent = workspace
        for _, v in pairs(clone:GetDescendants()) do
            if v:IsA("BasePart") then v.Anchored = true end
        end
        char.Archivable = false
        -- أنت ترى نفسك شبحاً للتحكم بينما الآخرون لا يرونك
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 0.5 end
        end
    else
        if clone then clone:Destroy() clone = nil end
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 0 end
        end
    end
end)

-- زر الهروب
escape.MouseButton1Click:Connect(function()
    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        p.Character.HumanoidRootPart.CFrame = CFrame.new(-38, 15, 128) -- إحداثيات الساحة الخارجية
    end
end)

-- السرعة والقفز المستمر
game:GetService("RunService").Heartbeat:Connect(function()
    if p.Character and p.Character:FindFirstChild("Humanoid") then
        if spdActive then p.Character.Humanoid.WalkSpeed = 100 end
        if jmpActive then p.Character.Humanoid.JumpPower = 150 end
    end
end)

speed.MouseButton1Click:Connect(function()
    spdActive = not spdActive
    speed.BackgroundColor3 = spdActive and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(40, 40, 40)
end)

jump.MouseButton1Click:Connect(function()
    jmpActive = not jmpActive
    jump.BackgroundColor3 = jmpActive and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(40, 40, 40)
end)
