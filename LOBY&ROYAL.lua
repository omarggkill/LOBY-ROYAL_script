--[[
    ╔════════════════════════════════════════════╗
    ║        LOBY & ROYAL - ULTIMATE V19         ║
    ║     Absolute Tool Lock + Precision Aim     ║
    ╚════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local p = Players.LocalPlayer

-- مسح الواجهات القديمة لضمان الظهور
if game:GetService("CoreGui"):FindFirstChild("LobyRoyalV19") then
    game:GetService("CoreGui").LobyRoyalV19:Destroy()
end

local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "LobyRoyalV19"

-- تصميم الواجهة الاحترافي
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 360, 0, 480)
main.Position = UDim2.new(0.5, -180, 0.4, -240)
main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 20)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(0, 255, 150)
stroke.Thickness = 2

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "LOBY & ROYAL"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBlack
title.TextSize = 22
title.BackgroundTransparency = 1

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(0.9, 0, 0.7, 0)
scroll.Position = UDim2.new(0.05, 0, 0.2, 0)
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

-- الأزرار
local lockBtn = makeBtn("قفل السلاح (لا يختفي عند السرقة) 🔒", Color3.fromRGB(40, 40, 40))
local aimBtn = makeBtn("تفعيل الإيم بوت (ضرب دقيق) 🎯", Color3.fromRGB(120, 0, 0))
local speedBtn = makeBtn("سرعة لاعب (200)", Color3.fromRGB(30, 30, 30))
local tpBtn = makeBtn("هروب سريع للشارع 🏠", Color3.fromRGB(0, 100, 200))

--- البرمجة المتطورة ---
local toolLocked, aimbotOn, spdOn = false, false, false
local lockedTool = nil

local function getClosest()
    local target, dist = nil, 100
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= p and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local d = (p.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then
                target = player
                dist = d
            end
        end
    end
    return target
end

RunService.Heartbeat:Connect(function()
    -- تثبيت السلاح في اليد غصباً عن اللعبة
    if toolLocked and lockedTool then
        if lockedTool.Parent ~= p.Character then
            lockedTool.Parent = p.Character
        end
    end

    -- الضرب التلقائي
    if aimbotOn and lockedTool then
        local target = getClosest()
        if target then
            lockedTool:Activate()
            local handle = lockedTool:FindFirstChild("Handle") or lockedTool:FindFirstChildOfClass("BasePart")
            if handle then
                firetouchinterest(target.Character.HumanoidRootPart, handle, 0)
                firetouchinterest(target.Character.HumanoidRootPart, handle, 1)
            end
        end
    end

    if spdOn and p.Character and p.Character:FindFirstChild("Humanoid") then
        p.Character.Humanoid.WalkSpeed = 200
    end
end)

lockBtn.MouseButton1Click:Connect(function()
    local current = p.Character:FindFirstChildOfClass("Tool")
    if current then
        lockedTool = current
        toolLocked = not toolLocked
        lockBtn.Text = toolLocked and "القفل مفعل: " .. lockedTool.Name or "قفل السلاح 🔒"
        lockBtn.BackgroundColor3 = toolLocked and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
    end
end)

aimBtn.MouseButton1Click:Connect(function()
    aimbotOn = not aimbotOn
    aimBtn.BackgroundColor3 = aimbotOn and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(120, 0, 0)
end)

speedBtn.MouseButton1Click:Connect(function()
    spdOn = not spdOn
    speedBtn.BackgroundColor3 = spdOn and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(30, 30, 30)
end)

tpBtn.MouseButton1Click:Connect(function()
    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        p.Character.HumanoidRootPart.CFrame = CFrame.new(-40, 12, 135)
    end
end)
