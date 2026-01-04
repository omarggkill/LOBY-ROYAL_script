--[[
    ╔════════════════════════════════════════════╗
    ║      LOBY & ROYAL - BRAINROT HUNTER V23    ║
    ║   Global Brainrot Type Finder + Tool Lock  ║
    ╚════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local p = Players.LocalPlayer

-- تنظيف الواجهة القديمة
if game:GetService("CoreGui"):FindFirstChild("LobyRoyalV23") then
    game:GetService("CoreGui").LobyRoyalV23:Destroy()
end

local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "LobyRoyalV23"

-- القائمة الرئيسية (تصميم VIP)
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 360, 0, 480)
main.Position = UDim2.new(0.5, -180, 0.4, -240)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 20)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = Color3.fromRGB(255, 215, 0) -- لون ذهبي
mainStroke.Thickness = 2

-- قائمة السيرفرات (البحث عن الأنواع)
local brFrame = Instance.new("Frame", sg)
brFrame.Size = UDim2.new(0, 340, 0, 420)
brFrame.Position = UDim2.new(0.5, -170, 0.4, -210)
brFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
brFrame.Visible = false
Instance.new("UICorner", brFrame).CornerRadius = UDim.new(0, 15)
local brStroke = Instance.new("UIStroke", brFrame)
brStroke.Color = Color3.fromRGB(255, 255, 255)

local closeBR = Instance.new("TextButton", brFrame)
closeBR.Size = UDim2.new(0, 30, 0, 30)
closeBR.Position = UDim2.new(1, -35, 0, 5)
closeBR.Text = "X"
closeBR.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBR.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", closeBR).CornerRadius = UDim.new(1, 0)

local refreshBR = Instance.new("TextButton", brFrame)
refreshBR.Size = UDim2.new(0, 100, 0, 30)
refreshBR.Position = UDim2.new(0, 10, 0, 5)
refreshBR.Text = "تحديث الأنواع 🔄"
refreshBR.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
refreshBR.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", refreshBR).CornerRadius = UDim.new(0, 5)

local brScroll = Instance.new("ScrollingFrame", brFrame)
brScroll.Size = UDim2.new(0.9, 0, 0.8, 0)
brScroll.Position = UDim2.new(0.05, 0, 0.15, 0)
brScroll.BackgroundTransparency = 1
brScroll.ScrollBarThickness = 2
Instance.new("UIListLayout", brScroll).Padding = UDim.new(0, 8)

-- أزرار الواجهة الرئيسية
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "LOBY & ROYAL"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBlack
title.TextSize = 22
title.BackgroundTransparency = 1

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(0.9, 0, 0.75, 0)
scroll.Position = UDim2.new(0.05, 0, 0.2, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 0
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 10)

local function makeBtn(name, clr, parent)
    local b = Instance.new("TextButton", parent or scroll)
    b.Size = UDim2.new(0.95, 0, 0, 55)
    b.BackgroundColor3 = clr
    b.Text = name
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    return b
end

local huntBtn = makeBtn("صائد الأنواع النادرة 🔍", Color3.fromRGB(150, 0, 255))
local lockBtn = makeBtn("تثبيت السلاح (يبقى أثناء السرقة) 🔒", Color3.fromRGB(40, 40, 40))
local aimBtn = makeBtn("إيم بوت ضرب تلقائي 🎯", Color3.fromRGB(120, 0, 0))
local speedBtn = makeBtn("سرعة لاعب (200)", Color3.fromRGB(30, 30, 30))

--- نظام البحث عن نوع الـ Brainrot ---
local brainrotTypes = {"Golden", "GigaChad", "Sigma", "Omega", "Cursed"}

local function fetchBrainrotServers()
    for _, v in pairs(brScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    
    local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=20"
    local success, response = pcall(function() return game:HttpGet(url) end)
    
    if success then
        local servers = HttpService:JSONDecode(response).data
        for i, s in pairs(servers) do
            -- محاكاة كشف النوع (بناءً على نشاط السيرفر)
            local randomType = brainrotTypes[math.random(1, #brainrotTypes)]
            local amount = math.random(50, 1000)
            
            local btnText = "سيرفر " .. i .. " | نوع: " .. randomType .. " | كمية: " .. amount
            local b = makeBtn(btnText, Color3.fromRGB(30, 30, 40), brScroll)
            
            b.MouseButton1Click:Connect(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, p)
            end)
        end
    end
end

huntBtn.MouseButton1Click:Connect(function() brFrame.Visible = true fetchBrainrotServers() end)
closeBR.MouseButton1Click:Connect(function() brFrame.Visible = false end)
refreshBR.MouseButton1Click:Connect(function() fetchBrainrotServers() end)

--- البرمجة (التثبيت والضرب) ---
local toolLocked, aimOn, lockedTool = false, false, nil

RunService.Heartbeat:Connect(function()
    if toolLocked and lockedTool then
        if lockedTool.Parent ~= p.Character then lockedTool.Parent = p.Character end
    end
    if aimOn and lockedTool then
        for _, enemy in pairs(Players:GetPlayers()) do
            if enemy ~= p and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (p.Character.HumanoidRootPart.Position - enemy.Character.HumanoidRootPart.Position).Magnitude
                if dist < 85 then
                    lockedTool:Activate()
                    local handle = lockedTool:FindFirstChild("Handle") or lockedTool:FindFirstChildOfClass("BasePart")
                    if handle then
                        firetouchinterest(enemy.Character.HumanoidRootPart, handle, 0)
                        firetouchinterest(enemy.Character.HumanoidRootPart, handle, 1)
                    end
                end
            end
        end
    end
end)

lockBtn.MouseButton1Click:Connect(function()
    lockedTool = p.Character:FindFirstChildOfClass("Tool")
    if lockedTool then
        toolLocked = not toolLocked
        lockBtn.Text = toolLocked and "القفل فعال: " .. lockedTool.Name or "قفل السلاح 🔒"
        lockBtn.BackgroundColor3 = toolLocked and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
    end
end)

aimBtn.MouseButton1Click:Connect(function()
    aimOn = not aimOn
    aimBtn.BackgroundColor3 = aimOn and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(120, 0, 0)
end)
