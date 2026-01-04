--[[
    LOBY & ROYAL - KILL AURA EDITION V10
    Concept: Auto-Hit everyone while holding Brainrot
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local p = Players.LocalPlayer

-- تنظيف النسخ القديمة
if game:GetService("CoreGui"):FindFirstChild("RoyalNeonHub") then
    game:GetService("CoreGui").RoyalNeonHub:Destroy()
end

local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RoyalNeonHub"

-- القائمة الرئيسية (تصميم نيون فخم)
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 350, 0, 400)
main.Position = UDim2.new(0.5, -175, 0.4, -200)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(0, 255, 255)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)

-- شعار Lorns Links في الأعلى
local logo = Instance.new("ImageLabel", main)
logo.Size = UDim2.new(0, 200, 0, 100)
logo.Position = UDim2.new(0.5, -100, 0.02, 0)
logo.Image = "rbxassetid://16719572648"
logo.BackgroundTransparency = 1

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(0.9, 0, 0.65, 0)
scroll.Position = UDim2.new(0.05, 0, 0.3, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 0

local list = Instance.new("UIListLayout", scroll)
list.Padding = UDim.new(0, 15)
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

-- الأزرار الأساسية
local auraBtn = makeBtn("تفعيل وضع السفاح (ضرب تلقائي لكل الخريطة)", Color3.fromRGB(200, 0, 0))
local speedBtn = makeBtn("سرعة لاعب: 150", Color3.fromRGB(30, 30, 30))
local jumpBtn = makeBtn("قفزة عالية: 200", Color3.fromRGB(30, 30, 30))

--- البرمجة الخارقة ---
local auraActive, lastTool, spdOn, jmpOn = false, nil, false, false

-- وظيفة البحث عن الأداة قبل السرقة
p.Character.ChildAdded:Connect(function(child)
    if child:IsA("Tool") and child.Name ~= "Brainrot" then
        lastTool = child -- يحفظ المضرب أو الليزر الذي كنت تمسكه
    end
end)

-- نظام الـ Kill Aura (الضرب التلقائي)
RunService.RenderStepped:Connect(function()
    if auraActive and lastTool then
        -- إبقاء الأداة في اليد حتى لو سرقت شيئاً
        if p.Character and not p.Character:FindFirstChild(lastTool.Name) then
            lastTool.Parent = p.Character
        end
        
        -- ضرب جميع اللاعبين القريبين
        for _, enemy in pairs(Players:GetPlayers()) do
            if enemy ~= p and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (p.Character.HumanoidRootPart.Position - enemy.Character.HumanoidRootPart.Position).Magnitude
                if dist < 20 then -- المسافة 20 متر
                    lastTool:Activate() -- يضغط على المضرب تلقائياً
                    -- إرسال إشارة الضرب للسيرفر
                    local hitEvent = lastTool:FindFirstChildOfClass("RemoteEvent") or lastTool:FindFirstChild("Handle")
                    if hitEvent then
                        -- برمجة محاكاة الضرب لكل ماب (تلقائي)
                    end
                end
            end
        end
    end
    
    -- السرعة والقفز
    if p.Character and p.Character:FindFirstChild("Humanoid") then
        if spdOn then p.Character.Humanoid.WalkSpeed = 150 end
        if jmpOn then p.Character.Humanoid.JumpPower = 200 end
    end
end)

auraBtn.MouseButton1Click:Connect(function()
    auraActive = not auraActive
    auraBtn.Text = auraActive and "وضع السفاح: فعال ⚔️" or "تفعيل وضع السفاح (ضرب تلقائي لكل الخريطة)"
    auraBtn.BackgroundColor3 = auraActive and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(200, 0, 0)
end)

speedBtn.MouseButton1Click:Connect(function()
    spdOn = not spdOn
    speedBtn.BackgroundColor3 = spdOn and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(30, 30, 30)
end)

jumpBtn.MouseButton1Click:Connect(function()
    jmpOn = not jmpOn
    jumpBtn.BackgroundColor3 = jmpOn and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(30, 30, 30)
end)
