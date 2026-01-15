-- سكريبت Escape Tsunami المطور مع خاصية الإخفاء (Minimize)
local Library = loadstring(game:HttpGet("raw.githubusercontent.com"))()

-- إنشاء النافذة الرئيسية مع مفتاح تشغيل (مثلاً مفتاح الـ "RightControl" أو الضغط على الأيقونة)
local Window = Library.CreateLib("Brainrot Tsunami OP - 2026", "DarkTheme")

-- إنشاء زر التصغير (الأيقونة العائمة)
local OpenBtn = Instance.new("ScreenGui")
local MainButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

OpenBtn.Name = "OpenBtn"
OpenBtn.Parent = game.CoreGui
OpenBtn.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainButton.Name = "MainButton"
MainButton.Parent = OpenBtn
MainButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainButton.Position = UDim2.new(0.02, 0, 0.45, 0)
MainButton.Size = UDim2.new(0, 50, 0, 50)
MainButton.Font = Enum.Font.SourceSansBold
MainButton.Text = "B" -- اختصار Brainrot
MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainButton.TextSize = 30.000
MainButton.Draggable = true -- يمكنك تحريك الأيقونة في أي مكان بالجانب

UICorner.CornerRadius = UDim.new(0, 50)
UICorner.Parent = MainButton

-- وظيفة زر التصغير والتكبير
MainButton.MouseButton1Click:Connect(function()
    local target = game.CoreGui:FindFirstChild("Brainrot Tsunami OP - 2026") or game.CoreGui:FindFirstChild("Library")
    if target then
        target.Enabled = not target.Enabled
    end
end)

-- [ الأقسام والميزات ] --

-- 1. قسم الانتقال (Teleport)
local Tab1 = Window:NewTab("الهروب والانتقال")
local Section1 = Tab1:NewSection("المواقع الآمنة")

Section1:NewButton("العودة للبيت (Spawn)", "ينقلك للبداية", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(15, 5, 10) -- إحداثيات تقريبية للسباون
end)

Section1:NewButton("حفظ موقع الحالي", "يحفظ مكانك", function()
    _G.SavedPos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
end)

Section1:NewButton("انتقال للموقع المحفوظ", "TP للمكان المختار", function()
    if _G.SavedPos then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = _G.SavedPos
    end
end)

-- 2. قسم السرعة OP (Speed Control)
local Tab2 = Window:NewTab("السرعة")
local Section2 = Tab2:NewSection("هكر السرعة اللانهائي")

local SpeedActive = false
Section2:NewToggle("تفعيل السرعة", "شغل أو اطفي الهكر", function(state)
    SpeedActive = state
end)

Section2:NewSlider("قيمة السرعة (Speed)", "تحكم في القوة", 1000, 16, function(s)
    _G.TargetSpeed = s
end)

-- كود تفعيل السرعة المستمر (Anti-Reset)
game:GetService("RunService").Heartbeat:Connect(function()
    if SpeedActive then
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = _G.TargetSpeed or 16
        end)
    end
end)

-- 3. إضافات الماب
local Tab3 = Window:NewTab("إضافات")
Section3 = Tab3:NewSection("تعديلات العالم")

Section3:NewButton("تخفيف الجاذبية (نط عالي)", "يساعدك تنط فوق الموجة", function()
    workspace.Gravity = 50
end)

Section3:NewButton("إلغاء الضباب ورؤية واضحة", "Full Bright", function()
    game.Lighting.Brightness = 2
    game.Lighting.ClockTime = 14
    game.Lighting.FogEnd = 100000
end)

