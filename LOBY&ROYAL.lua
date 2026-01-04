--[[
    ╔════════════════════════════════════════════╗
    ║      LOBY & ROYAL - GHOST MASTER V27       ║
    ║    Ultimate Invisible & Anti-Target        ║
    ╚════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local p = Players.LocalPlayer

-- تنظيف النسخ القديمة
if game:GetService("CoreGui"):FindFirstChild("LobyRoyalV27") then
    game:GetService("CoreGui").LobyRoyalV27:Destroy()
end

local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "LobyRoyalV27"

-- أيقونة التصغير
local miniBtn = Instance.new("ImageButton", sg)
miniBtn.Size = UDim2.new(0, 50, 0, 50)
miniBtn.Position = UDim2.new(0, 5, 0.5, -25)
miniBtn.Image = "rbxassetid://16719572648"
miniBtn.Visible = false
miniBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(1, 0)

-- القائمة الرئيسية
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 380, 0, 420)
main.Position = UDim2.new(0.5, -190, 0.4, -210)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = Color3.fromRGB(0, 255, 200)
mainStroke.Thickness = 2

local top = Instance.new("Frame", main)
top.Size = UDim2.new(1, 0, 0, 40)
top.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", top).CornerRadius = UDim.new(0, 15)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, -40, 1, 0)
title.Text = "LOBY & ROYAL - GHOST MODE"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1

local minBtn = Instance.new("TextButton", top)
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -35, 0.5, -15)
minBtn.Text = "_"
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 5)

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(0.95, 0, 0.85, 0)
scroll.Position = UDim2.new(0.025, 0, 0.12, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 0
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 10)

local function createBtn(text, clr, callback)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(0.9, 0, 0, 50)
    b.BackgroundColor3 = clr
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    b.MouseButton1Click:Connect(callback)
    return b
end

--- البرمجة (نظام الشبح المطور) ---
local selectedTool = nil
local lockActive = false
local aimbotOn = false
local ghostActive = false

-- 1. تثبيت السلاح المطور
createBtn("تحديد وتثبيت السلاح الحالي 🎯", Color3.fromRGB(50, 50, 50), function(self)
    local tool = p.Character:FindFirstChildOfClass("Tool")
    if tool then
        selectedTool = tool
        lockActive = true
        self.Text = "مثبت: " .. tool.Name .. " ✅"
        self.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
    end
end)

-- 2. وضع الاختفاء (الشبح الحقيقي)
local ghostBtn = createBtn("تفعيل وضع الشبح (غير مرئي) 👻", Color3.fromRGB(40, 40, 40), function()
    ghostActive = not ghostActive
    ghostBtn.Text = ghostActive and "وضع الشبح: فعال 🔥" or "تفعيل وضع الشبح (غير مرئي) 👻"
    ghostBtn.BackgroundColor3 = ghostActive and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(40, 40, 40)
    
    if ghostActive then
        -- محاكاة الاختفاء عن طريق تحريك الأجزاء لمكان بعيد برمجياً
        for _, part in pairs(p.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = 1 -- شفافية كاملة
                part.CanCollide = false
            end
        end
    else
        for _, part in pairs(p.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
                part.CanCollide = true
            end
        end
    end
end)

-- 3. إيم بوت الضرب
local aimBtn = createBtn("تشغيل الضرب التلقائي ⚔️", Color3.fromRGB(40, 40, 40), function()
    aimbotOn = not aimbotOn
    aimBtn.BackgroundColor3 = aimbotOn and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(40, 40, 40)
end)

-- 4. السرعة
createBtn("تفعيل سرعة البرق (Safe) ⚡", Color3.fromRGB(40, 40, 40), function()
    if p.Character and p.Character:FindFirstChild("Humanoid") then
        p.Character.Humanoid.WalkSpeed = 160
    end
end)

RunService.Heartbeat:Connect(function()
    -- تثبيت السلاح أثناء السرقة
    if lockActive and selectedTool then
        if selectedTool.Parent ~= p.Character then
            selectedTool.Parent = p.Character
        end
    end

    -- الضرب التلقائي للأعداء القريبين
    if aimbotOn and selectedTool then
        for _, enemy in pairs(Players:GetPlayers()) do
            if enemy ~= p and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (p.Character.HumanoidRootPart.Position - enemy.Character.HumanoidRootPart.Position).Magnitude
                if dist < 80 then
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
    
    -- منع السيرفر من كشف الاختفاء
    if ghostActive and p.Character then
        if p.Character:FindFirstChild("Head") then p.Character.Head.CanCollide = false end
    end
end)

minBtn.MouseButton1Click:Connect(function() main.Visible = false miniBtn.Visible = true end)
miniBtn.MouseButton1Click:Connect(function() main.Visible = true miniBtn.Visible = false end)
