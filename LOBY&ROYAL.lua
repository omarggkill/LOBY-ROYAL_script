--[[
    LOBY & ROYAL - THE GOD VERSION V9
    The Most Powerful Script for Steal a Brainrot
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local p = Players.LocalPlayer

-- مسح أي نسخة قديمة
if game:GetService("CoreGui"):FindFirstChild("RoyalGodHub") then
    game:GetService("CoreGui").RoyalGodHub:Destroy()
end

local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RoyalGodHub"

-- القائمة الفخمة
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 340, 0, 480)
main.Position = UDim2.new(0.5, -170, 0.4, -240)
main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 20)

-- شعار Lorns Links
local logo = Instance.new("ImageLabel", main)
logo.Size = UDim2.new(0, 220, 0, 120)
logo.Position = UDim2.new(0.5, -110, 0.02, 0)
logo.Image = "rbxassetid://16719572648"
logo.BackgroundTransparency = 1

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(0.9, 0, 0.68, 0)
scroll.Position = UDim2.new(0.05, 0, 0.28, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 2
scroll.ScrollBarImageColor3 = Color3.fromRGB(150, 0, 255)

local list = Instance.new("UIListLayout", scroll)
list.Padding = UDim.new(0, 12)
list.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function addBtn(name, clr)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(0.95, 0, 0, 50)
    b.BackgroundColor3 = clr
    b.Text = name
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 12)
    return b
end

-- أزرار الميزات
local invBtn = addBtn("تفعيل الإخفاء المطلق 👻", Color3.fromRGB(180, 0, 0))
local setHomeBtn = addBtn("تثبيت موقع المنزل (نسخة) 🏠", Color3.fromRGB(0, 150, 255))
local backHomeBtn = addBtn("العودة للمنزل فوراً ⚡", Color3.fromRGB(100, 0, 255))
local speedBtn = addBtn("سرعة خارقة (200): إيقاف", Color3.fromRGB(30, 30, 30))
local jumpBtn = addBtn("قفز العمالقة (250): إيقاف", Color3.fromRGB(30, 30, 30))

--- البرمجة الخارقة ---
local invActive, homePos, spdOn, jmpOn = false, nil, false, false

-- 1. نظام الإخفاء الحقيقي (Ghost)
invBtn.MouseButton1Click:Connect(function()
    invActive = not invActive
    invBtn.Text = invActive and "الإخفاء: فعال ✅" or "تفعيل الإخفاء المطلق 👻"
    invBtn.BackgroundColor3 = invActive and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
    
    if invActive then
        for _, v in pairs(p.Character:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                v.Transparency = (v.Name == "HumanoidRootPart" and 1 or 0.7)
            end
        end
    else
        for _, v in pairs(p.Character:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 0 end
        end
    end
end)

-- 2. نظام المنزل والرجوع بالبرين روت
setHomeBtn.MouseButton1Click:Connect(function()
    homePos = p.Character.HumanoidRootPart.CFrame
    setHomeBtn.Text = "تم حفظ موقع البيت ✅"
    setHomeBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    -- إنشاء نسخة ثابتة عند البيت للتمويه
    local c = p.Character:Clone()
    c.Parent = workspace
    for _, v in pairs(c:GetDescendants()) do
        if v:IsA("BasePart") then v.Anchored = true end
    end
end)

backHomeBtn.MouseButton1Click:Connect(function()
    if homePos then
        p.Character.HumanoidRootPart.CFrame = homePos
    else
        backHomeBtn.Text = "احفظ البيت أولاً!"
        task.wait(1)
        backHomeBtn.Text = "العودة للمنزل فوراً ⚡"
    end
end)

-- 3. السرعة والقفز الماكس
speedBtn.MouseButton1Click:Connect(function()
    spdOn = not spdOn
    speedBtn.Text = spdOn and "السرعة: 200 ✅" or "سرعة خارقة (200): إيقاف"
    speedBtn.BackgroundColor3 = spdOn and Color3.fromRGB(150, 0, 255) or Color3.fromRGB(30, 30, 30)
end)

jumpBtn.MouseButton1Click:Connect(function()
    jmpOn = not jmpOn
    jumpBtn.Text = jmpOn and "القفز: 250 ✅" or "قفز العمالقة (250): إيقاف"
    jumpBtn.BackgroundColor3 = jmpOn and Color3.fromRGB(150, 0, 255) or Color3.fromRGB(30, 30, 30)
end)

RunService.Heartbeat:Connect(function()
    if p.Character and p.Character:FindFirstChild("Humanoid") then
        if spdOn then p.Character.Humanoid.WalkSpeed = 200 end
        if jmpOn then p.Character.Humanoid.JumpPower = 250 end
    end
end)
