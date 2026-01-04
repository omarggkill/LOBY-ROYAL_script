--[[
    LOBY & ROYAL - ULTIMATE SLAYER V14
    Link: https://github.com/omarggkill/LOBY-ROYAL_script
    Update: Smart Tool Detection + Ultra Fast Hit
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local p = Players.LocalPlayer

-- تنظيف الواجهات القديمة
if game:GetService("CoreGui"):FindFirstChild("RoyalFinalHub") then
    game:GetService("CoreGui").RoyalFinalHub:Destroy()
end

local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "RoyalFinalHub"

-- التصميم (Dark Neon Red)
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 350, 0, 460)
main.Position = UDim2.new(0.5, -175, 0.4, -230)
main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255, 0, 0)
stroke.Thickness = 3

-- شعار Lorns Links
local logo = Instance.new("ImageLabel", main)
logo.Size = UDim2.new(0, 200, 0, 110)
logo.Position = UDim2.new(0.5, -100, 0.02, 0)
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

local function makeBtn(name, clr)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(0.95, 0, 0, 55)
    b.BackgroundColor3 = clr
    b.Text = name
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 12)
    return b
end

-- الأزرار
local auraBtn = makeBtn("تفعيل نظام السفاح (ضرب فتاك) 💀", Color3.fromRGB(120, 0, 0))
local speedBtn = makeBtn("السرعة (200): إيقاف", Color3.fromRGB(30, 30, 30))
local jumpBtn = makeBtn("القفز (250): إيقاف", Color3.fromRGB(30, 30, 30))
local tpBtn = makeBtn("هروب سريع للشارع 🏠", Color3.fromRGB(0, 100, 200))

--- البرمجة الخارقة (الضرب الذكي) ---
local auraOn, spdOn, jmpOn = false, false, false

-- وظيفة الضرب التي تضمن التأثير
local function dealDamage(target, tool)
    if tool and target:FindFirstChild("HumanoidRootPart") then
        tool:Activate() -- يضغط المضرب
        -- محاكاة اللمس لضمان الضرب (Kill Aura Bypass)
        local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildOfClass("Part")
        if handle then
            firetouchinterest(target.HumanoidRootPart, handle, 0)
            firetouchinterest(target.HumanoidRootPart, handle, 1)
        end
    end
end

RunService.Heartbeat:Connect(function()
    if auraOn then
        -- التأكد من إمساك الأداة (لو في الشنطة يسحبها، ولو في اليد يضرب بها)
        local tool = p.Character:FindFirstChildOfClass("Tool") or p.Backpack:FindFirstChildOfClass("Tool")
        
        if tool and tool.Name ~= "Brainrot" then
            if tool.Parent == p.Backpack then tool.Parent = p.Character end
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= p and player.Character and player.Character:FindFirstChild("Humanoid") then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local distance = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                        if distance < 60 then -- مسافة الأبادة (60 متر)
                            dealDamage(player.Character, tool)
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

-- تفعيل الأزرار
auraBtn.MouseButton1Click:Connect(function()
    auraOn = not auraOn
    auraBtn.Text = auraOn and "نظام السفاح: يحصد الجميع 🔥" or "تفعيل نظام السفاح (ضرب فتاك) 💀"
    auraBtn.BackgroundColor3 = auraOn and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(120, 0, 0)
end)

speedBtn.MouseButton1Click:Connect(function()
    spdOn = not spdOn
    speedBtn.BackgroundColor3 = spdOn and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(30, 30, 30)
end)

jumpBtn.MouseButton1Click:Connect(function()
    jmpOn = not jmpOn
    jumpBtn.BackgroundColor3 = jmpOn and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(30, 30, 30)
end)

tpBtn.MouseButton1Click:Connect(function()
    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        p.Character.HumanoidRootPart.CFrame = CFrame.new(-38, 15, 128)
    end
end)
