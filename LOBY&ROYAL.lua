-- LOBY & ROYAL - ULTIMATE STEALER V3
local p = game:GetService("Players").LocalPlayer
local sg = Instance.new("ScreenGui", p:WaitForChild("PlayerGui"))
sg.Name = "LobyRoyalUltimate"
sg.ResetOnSpawn = false

-- القائمة الاحترافية
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 280, 0, 260)
main.Position = UDim2.new(0.5, -140, 0.4, -120)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.Active = true
main.Draggable = true 
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)

-- شريط العنوان
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1, 0, 0, 40)
top.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", top).CornerRadius = UDim.new(0, 15)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, 0, 1, 0)
title.Text = "LOBY & ROYAL - ULTIMATE"
title.TextColor3 = Color3.fromRGB(255, 200, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 14

-- أزرار التحكم
local close = Instance.new("TextButton", top)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0.1, 0)
close.Text = "X"
close.TextColor3 = Color3.new(1, 0, 0)
close.BackgroundTransparency = 1
close.MouseButton1Click:Connect(function() sg:Destroy() end)

-- حاوية الأزرار
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(0.9, 0, 0.75, 0)
scroll.Position = UDim2.new(0.05, 0, 0.2, 0)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 1.3, 0)
scroll.ScrollBarThickness = 2

local list = Instance.new("UIListLayout", scroll)
list.Padding = UDim.new(0, 10)
list.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createBtn(txt, clr)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(0.95, 0, 0, 45)
    b.BackgroundColor3 = clr
    b.Text = txt
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 13
    Instance.new("UICorner", b)
    return b
end

-- تعريف الأزرار
local ghostBtn = createBtn("وضع الشبح (نسخة وهمية + إخفاء)", Color3.fromRGB(100, 0, 150))
local tpBtn = createBtn("انتقال خارج المنزل (هروب)", Color3.fromRGB(0, 100, 200))
local speedBtn = createBtn("سرعة خارقة", Color3.fromRGB(50, 50, 50))

--- البرمجة ---
local isGhost, clone, spd = false, nil, false

-- 1. وظيفة وضع الشبح (النسخة الوهمية وإخفاء كل شيء)
ghostBtn.MouseButton1Click:Connect(function()
    local char = p.Character
    if not char then return end
    isGhost = not isGhost
    
    ghostBtn.Text = isGhost and "وضع الشبح: مفعل ✅" or "وضع الشبح (نسخة وهمية + إخفاء)"
    ghostBtn.BackgroundColor3 = isGhost and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(100, 0, 150)

    if isGhost then
        -- إنشاء النسخة الوهمية في المكان الحالي
        char.Archivable = true
        clone = char:Clone()
        clone.Parent = workspace
        -- تعطيل حركات النسخة لتبقى واقفة
        if clone:FindFirstChild("Animate") then clone.Animate:Destroy() end
        char.Archivable = false
        
        -- إخفاء الشخصية الحقيقية مع كل شيء تحمله (بما في ذلك البرين روت)
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                v.Transparency = 1
            end
        end
    else
        -- العودة للحالة الطبيعية
        if clone then clone:Destroy() clone = nil end
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                if v.Name ~= "HumanoidRootPart" then v.Transparency = 0 end
            end
        end
    end
end)

-- 2. وظيفة الانتقال خارج المنزل (Teleport)
tpBtn.MouseButton1Click:Connect(function()
    local char = p.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        -- إحداثيات تقريبية لخارج المنزل في الماب (يمكنك تعديل الأرقام حسب رغبتك)
        char.HumanoidRootPart.CFrame = CFrame.new(0, 10, 50) -- يرجى التأكد من الموقع المناسب في مابك
    end
end)

-- 3. وظيفة السرعة
speedBtn.MouseButton1Click:Connect(function()
    spd = not spd
    speedBtn.BackgroundColor3 = spd and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(50, 50, 50)
    p.Character.Humanoid.WalkSpeed = spd and 100 or 16
end)

-- ضمان استمرار الإخفاء حتى للأدوات الجديدة (البرين روت عند لمسه)
p.Character.ChildAdded:Connect(function(child)
    if isGhost then
        task.wait(0.1)
        for _, v in pairs(child:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 1 end
        end
    end
end)
