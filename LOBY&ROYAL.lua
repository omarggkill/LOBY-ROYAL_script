--[[
    LOBY & ROYAL - ULTIMATE KENGER COPY
    Features: Real Invisible, Fixed TP, God Speed/Jump
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local p = Players.LocalPlayer
local char = p.Character or p.CharacterAdded:Wait()

-- تنظيف النسخ القديمة
if game:GetService("CoreGui"):FindFirstChild("RoyalUltimate") then
    game:GetService("CoreGui").RoyalUltimate:Destroy()
end

local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RoyalUltimate"

-- القائمة الرئيسية (تصميم الفيديو)
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 320, 0, 440)
main.Position = UDim2.new(0.5, -160, 0.4, -220)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)

-- شعار Lorns Links
local logo = Instance.new("ImageLabel", main)
logo.Size = UDim2.new(0, 220, 0, 110)
logo.Position = UDim2.new(0.5, -110, 0.05, 0)
logo.Image = "rbxassetid://16719572648"
logo.BackgroundTransparency = 1

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(0.9, 0, 0.65, 0)
scroll.Position = UDim2.new(0.05, 0, 0.32, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 0

local list = Instance.new("UIListLayout", scroll)
list.Padding = UDim.new(0, 10)
list.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function addBtn(name, clr)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(0.95, 0, 0, 50)
    b.BackgroundColor3 = clr
    b.Text = name
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    return b
end

-- أزرار الميزات (نفس الفيديو)
local invBtn = addBtn("تفعيل نظام التخفي (Anti-Hit) 👻", Color3.fromRGB(150, 0, 0))
local tpBtn = addBtn("هروب سريع: خارج المنزل 🏠", Color3.fromRGB(0, 100, 200))
local speedBtn = addBtn("سرعة خارقة: إيقاف ⚡", Color3.fromRGB(30, 30, 30))
local jumpBtn = addBtn("قفزة عالية: إيقاف 🚀", Color3.fromRGB(30, 30, 30))

--- البرمجة ---
local invActive, clone, speedOn, jumpOn = false, nil, false, false

-- 1. نظام التخفي الحقيقي (Invisible)
invBtn.MouseButton1Click:Connect(function()
    invActive = not invActive
    invBtn.Text = invActive and "التخفي: مفعل ✅" or "تفعيل نظام التخفي (Anti-Hit) 👻"
    invBtn.BackgroundColor3 = invActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    
    if invActive then
        p.Character.Archivable = true
        clone = p.Character:Clone()
        clone.Parent = workspace
        clone:MoveTo(p.Character.HumanoidRootPart.Position)
        for _, v in pairs(clone:GetDescendants()) do
            if v:IsA("BasePart") then v.Anchored = true end
        end
        -- إخفاء الحقيقي عن السيرفر (Client Only Visibility)
        for _, v in pairs(p.Character:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 0.5 end
        end
    else
        if clone then clone:Destroy() end
        for _, v in pairs(p.Character:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 0 end
        end
    end
end)

-- 2. زر الهروب (TP Outside)
tpBtn.MouseButton1Click:Connect(function()
    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        p.Character.HumanoidRootPart.CFrame = CFrame.new(-38, 15, 128)
    end
end)

-- 3. السرعة والقفز المستمر (لا يتوقفان)
speedBtn.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    speedBtn.Text = speedOn and "سرعة خارقة: 100" or "سرعة خارقة: إيقاف ⚡"
    speedBtn.BackgroundColor3 = speedOn and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 30, 30)
end)

jumpBtn.MouseButton1Click:Connect(function()
    jumpOn = not jumpOn
    jumpBtn.Text = jumpOn and "قفزة عالية: 150" or "قفزة عالية: إيقاف 🚀"
    jumpBtn.BackgroundColor3 = jumpOn and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 30, 30)
end)

RunService.Heartbeat:Connect(function()
    if p.Character and p.Character:FindFirstChild("Humanoid") then
        if speedOn then p.Character.Humanoid.WalkSpeed = 100 end
        if jumpOn then p.Character.Humanoid.JumpPower = 150 end
    end
end)
