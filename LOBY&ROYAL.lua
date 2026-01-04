--[[
    ╔════════════════════════════════════════════╗
    ║        LOBY & ROYAL - GOD MODE V16         ║
    ║   Fixed Aura Targeting & Correct Escape    ║
    ╚════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local p = Players.LocalPlayer

-- مسح أي واجهة قديمة لضمان التحديث
if game:GetService("CoreGui"):FindFirstChild("LobyRoyalFinal") then
    game:GetService("CoreGui").LobyRoyalFinal:Destroy()
end

local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "LobyRoyalFinal"

-- تصميم الواجهة (نفس الشكل في صورك)
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 350, 0, 450)
main.Position = UDim2.new(0.5, -175, 0.4, -225)
main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255, 0, 0)
stroke.Thickness = 3

-- اسم السكربت LOBY&ROYAL
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0.02, 0)
title.Text = "LOBY & ROYAL PREMIUM"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.BackgroundTransparency = 1

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(0.9, 0, 0.7, 0)
scroll.Position = UDim2.new(0.05, 0, 0.25, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 0

local list = Instance.new("UIListLayout", scroll)
list.Padding = UDim.new(0, 10)
list.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function makeBtn(name, clr)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(0.95, 0, 0, 60)
    b.BackgroundColor3 = clr
    b.Text = name
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 12)
    return b
end

-- الأزرار كما في الصورة
local auraBtn = makeBtn("نظام السفاح: يحصد الجميع 🔥", Color3.fromRGB(0, 120, 0))
local speedBtn = makeBtn("السرعة (200): إيقاف", Color3.fromRGB(30, 30, 30))
local jumpBtn = makeBtn("القفز (250): إيقاف", Color3.fromRGB(30, 30, 30))
local escapeBtn = makeBtn("هروب سريع للشارع 🏠", Color3.fromRGB(0, 100, 200))

--- البرمجة (إصلاح الاستهداف والهروب) ---
local auraOn, spdOn, jmpOn = false, false, false

-- وظيفة الضرب المركز (Targeted Hit)
local function targetedAttack(targetChar, tool)
    local targetPart = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("Torso")
    if tool and targetPart then
        tool:Activate()
        -- توجيه الهجوم مباشرة للخصم (Bypass)
        local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildOfClass("Part")
        if handle then
            firetouchinterest(targetPart, handle, 0)
            task.wait()
            firetouchinterest(targetPart, handle, 1)
        end
    end
end

RunService.RenderStepped:Connect(function()
    if auraOn then
        local tool = p.Character:FindFirstChildOfClass("Tool") or p.Backpack:FindFirstChildOfClass("Tool")
        if tool and tool.Name ~= "Brainrot" then
            if tool.Parent == p.Backpack then tool.Parent = p.Character end
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= p and player.Character and player.Character:FindFirstChild("Humanoid") then
                    local root = player.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        local distance = (p.Character.HumanoidRootPart.Position - root.Position).Magnitude
                        if distance < 80 then -- مسافة ضرب مفتوحة وكبيرة (80 متر)
                            targetedAttack(player.Character, tool)
                        end
                    end
                end
            end
        end
    end
    
    -- السرعة والقفز
    if p.Character and p.Character:FindFirstChild("Humanoid") then
        if spdOn then p.Character.Humanoid.WalkSpeed = 200 end
        if jmpOn then p.Character.Humanoid.JumpPower = 250 end
    end
end)

-- تشغيل الأزرار
auraBtn.MouseButton1Click:Connect(function()
    auraOn = not auraOn
    auraBtn.Text = auraOn and "نظام السفاح: مفعل ✅" or "نظام السفاح: يحصد الجميع 🔥"
    auraBtn.BackgroundColor3 = auraOn and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(0, 120, 0)
end)

speedBtn.MouseButton1Click:Connect(function()
    spdOn = not spdOn
    speedBtn.BackgroundColor3 = spdOn and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(30, 30, 30)
end)

jumpBtn.MouseButton1Click:Connect(function()
    jmpOn = not jmpOn
    jumpBtn.BackgroundColor3 = jmpOn and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(30, 30, 30)
end)

escapeBtn.MouseButton1Click:Connect(function()
    -- إحداثيات مصححة للهروب بعيداً عن المنازل (منطقة التجميع الرئيسية)
    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        p.Character.HumanoidRootPart.CFrame = CFrame.new(-40, 12, 135) 
    end
end)
