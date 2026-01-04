-- LOBY & ROYAL SCRIPT
local player = game:GetService("Players").LocalPlayer
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "LobyRoyalHub"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 160, 0, 70)
frame.Position = UDim2.new(0.5, -80, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = ToolUnit.new(0, 8)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0.4, 0)
title.Text = "LOBY & ROYAL"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.TextSize = 14

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(0.9, 0, 0.4, 0)
btn.Position = UDim2.new(0.05, 0, 0.5, 0)
btn.Text = "تفعيل الاختفاء"
btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
btn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", btn)

local inv, clone = false, nil

btn.MouseButton1Click:Connect(function()
    local char = player.Character
    if not char then return end
    inv = not inv
    btn.Text = inv and "مفعل (مخفي)" or "تفعيل الاختفاء"
    btn.BackgroundColor3 = inv and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)

    if inv then
        char.Archivable = true
        clone = char:Clone()
        clone.Parent = workspace
        char.Archivable = false
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 1 end
        end
    else
        if clone then clone:Destroy() end
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                if v.Name ~= "HumanoidRootPart" then v.Transparency = 0 end
            end
        end
    end
end)
