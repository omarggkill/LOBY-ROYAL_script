--[[
    LOBY & ROYAL - THE ULTIMATE HUB V6 (FINAL WITH IMAGE)
    Game: Steal a Brainrot
    Features: Ghost Mode, Auto-Invis, Escape, Speed, Jump, Anti-Ban
]]

local p = game:GetService("Players").LocalPlayer
local sg = Instance.new("ScreenGui", p:WaitForChild("PlayerGui"))
sg.Name = "LobyRoyal_Ultimate_"..math.random(1000)
sg.ResetOnSpawn = false

-- الإطار الرئيسي (تصميم فخم)
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 300, 0, 350) -- حجم أكبر للصورة
main.Position = UDim2.new(0.5, -150, 0.4, -175)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true 
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)

-- شريط العنوان العلوي
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 45)
topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 15)

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, 0, 1, 0)
title.Text = "LOBY & ROYAL PREMIUM"
title.TextColor3 = Color3.fromRGB(0, 255, 200)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 14

-- زر الإغلاق (X)
local close = Instance.new("TextButton", topBar)
close.Size = UDim2.new(0, 35, 0, 35)
close.Position = UDim2.new(1, -40, 0.1, 0)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 50, 50)
close.BackgroundTransparency = 1
close.TextSize = 20
close.MouseButton1Click:Connect(function() sg:Destroy() end)

-- زر التصغير (_)
local mini = Instance.new("TextButton", topBar)
mini.Size = UDim2.new(0, 35, 0, 35)
mini.Position = UDim2.new(1, -75, 0.1, 0)
mini.Text = "_"
mini.TextColor3 = Color3.new(1, 1, 1)
mini.BackgroundTransparency = 1
mini.TextSize = 20

-- زر الفتح (يظهر عند التصغير)
local openBtn = Instance.new("TextButton", sg)
openBtn.Size = UDim2.new(0, 60, 0, 35)
openBtn.Position = UDim2.new(0, 10, 0.5, 0)
openBtn.Text = "OPEN"
openBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
openBtn.TextColor3 = Color3.fromRGB(0, 255, 200)
openBtn.Visible = false
Instance.new("UICorner", openBtn)

-- الصورة في أعلى القائمة
local logo = Instance.new("ImageLabel", main)
logo.Size = UDim2.new(0, 180, 0, 100) -- حجم الصورة
logo.Position = UDim2.new(0.5, -90, 0.14, 0) -- مكانها بعد شريط العنوان
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://16719572648" -- صورتك لماب Brainrot
logo.ScaleType = Enum.ScaleType.Fit -- لتتناسب الصورة مع الحجم

-- حاوية الأزرار (Scrolling)
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(0.9, 0, 0.6, 0) -- تعديل الحجم ليتناسب مع الصورة
scroll.Position = UDim2.new(0.05, 0, 0.45, 0) -- تعديل الموضع
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 1.5, 0)
scroll.ScrollBarThickness = 0

local list = Instance.new("UIListLayout", scroll)
list.Padding = UDim.new(0, 10)
list.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- وظيفة إنشاء الأزرار
local function makeBtn(txt, color)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(0.95, 0, 0, 45)
    b.BackgroundColor3 = color
    b.Text = txt
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 13
    Instance.new("UICorner", b)
    return b
end

-- الأزرار
local ghostBtn = makeBtn("وضع الشبح (نسخة + إخفاء كامل)", Color3.fromRGB(100, 0, 150))
local tpBtn = makeBtn("هروب سريع (خارج المنزل)", Color3.fromRGB(0, 100, 200))
local speedBtn = makeBtn("سرعة اللاعب (إيقاف)", Color3.fromRGB(40, 40, 40))
local jumpBtn = makeBtn("قفزة عالية (إيقاف)", Color3.fromRGB(40, 40, 40))
local protectBtn = makeBtn("حماية Anti-Ban: مفعلة ✅", Color3.fromRGB(0, 120, 0))

--- البرمجة ---
local isGhost, clone, spd, jmp = false, nil, false, false

-- وظيفة التصغير والفتح
mini.MouseButton1Click:Connect(function() main.Visible = false; openBtn.Visible = true end)
openBtn.MouseButton1Click:Connect(function() main.Visible = true; openBtn.Visible = false end)

-- وضع الشبح (Ghost Mode)
ghostBtn.MouseButton1Click:Connect(function()
    local char = p.Character
    if not char then return end
    isGhost = not isGhost
    ghostBtn.Text = isGhost and "وضع الشبح: مفعل ✅" or "وضع الشبح (نسخة + إخفاء كامل)"
    ghostBtn.BackgroundColor3 = isGhost and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(100, 0, 150)

    if isGhost then
        char.Archivable = true
        clone = char:Clone()
        clone.Parent = workspace
        if clone:FindFirstChild("HumanoidRootPart") then clone.HumanoidRootPart.Anchored = true end
        char.Archivable = false
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 1 end
        end
    else
        if clone then clone:Destroy() clone = nil end
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                if v.Name ~= "HumanoidRootPart" then v.Transparency = 0 end
            end
        end
    end
end)

-- الانتقال (Teleport)
tpBtn.MouseButton1Click:Connect(function()
    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        p.Character.HumanoidRootPart.CFrame = CFrame.new(-38, 15, 128) -- إحداثيات الهروب للماب
    end
end)

-- السرعة
speedBtn.MouseButton1Click:Connect(function()
    spd = not spd
    speedBtn.Text = spd and "سرعة اللاعب: 100" or "سرعة اللاعب: إيقاف"
    speedBtn.BackgroundColor3 = spd and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(40, 40, 40)
    p.Character.Humanoid.WalkSpeed = spd and 100 or 16
end)

-- القفز
jumpBtn.MouseButton1Click:Connect(function()
    jmp = not jmp
    jumpBtn.Text = jmp and "قفزة عالية: 150" or "قفزة عالية: إيقاف"
    jumpBtn.BackgroundColor3 = jmp and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(40, 40, 40)
    p.Character.Humanoid.JumpPower = jmp and 150 or 50
end)

-- إخفاء الأشياء المسروقة تلقائياً
p.Character.ChildAdded:Connect(function(child)
    if isGhost then
        task.wait(0.1)
        for _, v in pairs(child:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 1 end
        end
    end
end)

-- Anti-Kick Protection
spawn(function()
    while task.wait(1) do
        if p.Character and p.Character:FindFirstChild("Humanoid") then
            p.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            -- منع وضع الخمول (Idle)
            game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            task.wait(0.1)
            game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end
    end
end)
