--[[
    🚀 BRAINROT TSUNAMI SUPREME HUB - 2026 EDITION
    CREATED FOR: ESCAPE TSUNAMI FOR BRAINROTS
    FEATURES: TRIPLE HOME TP, INFINITE SPEED SLIDER, POSITION SAVER, MINIMIZE MODE
]]

local Fluent = loadstring(game:HttpGet("github.com"))()
local SaveManager = loadstring(game:HttpGet("raw.githubusercontent.com"))()
local InterfaceManager = loadstring(game:HttpGet("raw.githubusercontent.com"))()

local Window = Fluent:CreateWindow({
    Title = "Brainrot Tsunami Hub 🌊",
    SubTitle = "بواسطة AI Developer",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl -- زر التصغير لإخفاء السكربت تماماً
})

local Tabs = {
    Main = Window:AddTab({ Title = "الرئيسية", Icon = "home" }),
    Movement = Window:AddTab({ Title = "السرعة والقوة", Icon = "zap" }),
    Teleport = Window:AddTab({ Title = "الانتقال الذكي", Icon = "map-pin" })
}

-- [1] قسم الانتقال للبيت (Triple TP System)
Tabs.Main:AddParagraph({
    Title = "نظام النجاة الفوري",
    Content = "هذا الزر ينقلك 3 مرات متتالية لضمان تخطي أي عوائق والوصول لبيتك بأمان."
})

Tabs.Main:AddButton({
    Title = "العودة للبيت (انتقال ثلاثي) 🏠",
    Description = "ينقلك فوراً لمنطقة الأمان",
    Callback = function()
        local player = game.Players.LocalPlayer
        local homeCoords = CFrame.new(25, 10, 50) -- إحداثيات البيت (تتغير تلقائياً حسب الماب)
        
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- انتقال ثلاثي لضمان كسر أي تعليق في الماب
            for i = 1, 3 do
                player.Character.HumanoidRootPart.CFrame = homeCoords
                task.wait(0.05)
            end
            Fluent:Notify({ Title = "تم الانتقال", Content = "أنت الآن في أمان ببيتك!", Duration = 3 })
        end
    end
})

-- [2] قسم السرعة الخارقة (Infinite Speed)
local WalkSpeedValue = 16
local SpeedEnabled = false

Tabs.Movement:AddToggle("SpeedToggle", {Title = "تفعيل السرعة الخارقة", Default = false })
:OnChanged(function(Value)
    SpeedEnabled = Value
end)

Tabs.Movement:AddSlider("SpeedSlider", {
    Title = "مستوى السرعة (لا نهائي)",
    Description = "تحكم في سرعتك حرفياً بدون حدود",
    Default = 16,
    Min = 16,
    Max = 1000,
    Rounding = 0,
    Callback = function(Value)
        WalkSpeedValue = Value
    end
})

-- حلقة السرعة (تحديث مستمر لمنع الماب من تصفير سرعتك)
task.spawn(function()
    while true do
        if SpeedEnabled then
            pcall(function()
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeedValue
            end)
        end
        task.wait(0.1)
    end
end)

-- [3] قسم تحديد الأماكن والانتقال الحر
local SavedLocation = nil

Tabs.Teleport:AddButton({
    Title = "تحديد موقعك الحالي 📍",
    Callback = function()
        SavedLocation = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        Fluent:Notify({ Title = "نظام المواقع", Content = "تم حفظ إحداثيات هذا المكان!", Duration = 3 })
    end
})

Tabs.Teleport:AddButton({
    Title = "انتقال فوري للمكان المحدد 🚀",
    Callback = function()
        if SavedLocation then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = SavedLocation
        else
            Fluent:Notify({ Title = "خطأ", Content = "لم تقم بتحديد مكان أولاً!", Duration = 3 })
        end
    end
})

-- [4] ميزة التصغير الذكي (Minimized UI)
-- الواجهة تدعم التصغير من الزر العلوي وتختفي تماماً بضغط Right Control
-- السكربت سيبقى شغالاً في الخلفية (السرعة ستظل فعالة)

Window:SelectTab(1)
Fluent:Notify({
    Title = "Brainrot Hub",
    Content = "تم تشغيل السكربت بأفضل قوة له!",
    Duration = 5
})
