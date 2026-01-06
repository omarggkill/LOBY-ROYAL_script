-- CharacterStateFramework.lua
-- Single-file, server-authoritative Character Interaction Framework
-- Place this Script into ServerScriptService in a place you own.
-- On startup it creates RemoteEvents and injects a LocalScript into StarterPlayerScripts
-- The LocalScript contains the GUI, client-side scanning, highlighting, and requests to the server.

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

-- Configuration (tuneable)
local CONFIG = {
    ProximityRadius = 100,          -- studs
    ClientScanFrequency = 0.12,     -- seconds
    ServerProximityCooldown = 0.15, -- minimum seconds between server-side proximity processing per player
    ProxiesFolderName = "CharacterProxies",
    ToolsFolderName = "Tools",      -- ServerStorage.Tools should contain templates
    AllowPlayerTargets = false,     -- set true only if you want to allow PvP via this module
    DefaultToolDamage = 25,
    LockedToolEnforceInterval = 0.1, -- heartbeat interval for tool enforcement (seconds)
}

-- Ensure resource containers exist ------------------------------------------------
local function ensureFolder(parent, name)
    local f = parent:FindFirstChild(name)
    if not f then
        f = Instance.new("Folder")
        f.Name = name
        f.Parent = parent
    end
    return f
end

local charStateFolder = ensureFolder(ReplicatedStorage, "CharacterState")
local proxiesFolder = ensureFolder(Workspace, CONFIG.ProxiesFolderName)
local toolsFolder = ensureFolder(ServerStorage, CONFIG.ToolsFolderName)

-- Create RemoteEvents if missing
local function ensureRemote(name)
    local r = charStateFolder:FindFirstChild(name)
    if r and r:IsA("RemoteEvent") then return r end
    if r and not r:IsA("RemoteEvent") then r:Destroy() end
    r = Instance.new("RemoteEvent")
    r.Name = name
    r.Parent = charStateFolder
    return r
end

local Remote_ToggleGhost   = ensureRemote("ToggleGhost")     -- (player, boolean)
local Remote_SetLockedTool = ensureRemote("SetLockedTool")   -- (player, toolName:string)
local Remote_ProximityReq  = ensureRemote("ProximityRequest")-- (player, targets: {Model})

-- Utility: clone a visual-only proxy of a character (server-side)
local function makeVisualProxyFromCharacter(character)
    local proxy = Instance.new("Model")
    proxy.Name = character.Name .. "_Proxy"
    -- we'll clone parts & accessories; we will strip scripts
    for _, obj in ipairs(character:GetChildren()) do
        if obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("Accessory") or obj:IsA("Model") then
            local ok, cl = pcall(function() return obj:Clone() end)
            if ok and cl then
                -- Remove runtime scripts from clone
                for _, d in ipairs(cl:GetDescendants()) do
                    if d:IsA("Script") or d:IsA("LocalScript") then d:Destroy() end
                end
                -- Cosmetic: anchor and disable collision so proxy is visual only
                if cl:IsA("BasePart") or cl:IsA("MeshPart") then
                    cl.Anchored = true
                    cl.CanCollide = false
                end
                cl.Parent = proxy
            end
        end
    end
    -- add a Humanoid for proper appearance and animation compatibility
    local hum = Instance.new("Humanoid")
    hum.Name = "ProxyHumanoid"
    hum.Parent = proxy
    return proxy
end

-- Server-side proxy management map
local playerProxies = {}

-- Helper: set character fully transparent and store original transparency on attributes
local function makeCharacterTransparent(character)
    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            if descendant:GetAttribute("OriginalTransparency") == nil then
                descendant:SetAttribute("OriginalTransparency", descendant.Transparency)
            end
            descendant.Transparency = 1
        elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
            if descendant:GetAttribute("OriginalTransparency") == nil then
                descendant:SetAttribute("OriginalTransparency", descendant.Transparency or 0)
            end
            descendant.Transparency = 1
        end
    end
end

local function restoreCharacterTransparency(character)
    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            local orig = descendant:GetAttribute("OriginalTransparency")
            if orig ~= nil then
                descendant.Transparency = orig
                descendant:SetAttribute("OriginalTransparency", nil)
            else
                descendant.Transparency = 0
            end
        elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
            local orig = descendant:GetAttribute("OriginalTransparency")
            if orig ~= nil then
                descendant.Transparency = orig
                descendant:SetAttribute("OriginalTransparency", nil)
            else
                descendant.Transparency = 0
            end
        end
    end
end

-- Toggle Ghost (server authoritative)
Remote_ToggleGhost.OnServerEvent:Connect(function(player, enable)
    if typeof(enable) ~= "boolean" then return end
    local character = player.Character
    if not character or not character.Parent then return end
    -- simple permission check: ensure request originates from the player only
    if enable then
        -- avoid double proxies
        if playerProxies[player] and playerProxies[player].Parent then return end
        local proxy = makeVisualProxyFromCharacter(character)
        -- try to position proxy at HRP
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            -- pick a primary part inside proxy (prefer HumanoidRootPart clone)
            local primary
            for _, c in ipairs(proxy:GetChildren()) do
                if c.Name == "HumanoidRootPart" and c:IsA("BasePart") then
                    primary = c; break
                end
            end
            if primary then
                proxy.PrimaryPart = primary
                proxy:SetPrimaryPartCFrame(hrp.CFrame)
            else
                -- fallback: set part positions relative to HRP
                for _, part in ipairs(proxy:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CFrame = hrp.CFrame
                    end
                end
            end
        end
        proxy.Parent = proxiesFolder
        playerProxies[player] = proxy
        -- make real char transparent (physics remain)
        makeCharacterTransparent(character)
    else
        local proxy = playerProxies[player]
        if proxy and proxy.Parent then proxy:Destroy() end
        playerProxies[player] = nil
        restoreCharacterTransparency(character)
    end
end)

-- Hard-Lock Tool functionality (server authoritative)
-- Player attribute "LockedTool" will store the tool name to enforce.
local function giveLockedToolToCharacter(player, character)
    local wanted = player:GetAttribute("LockedTool") or ""
    if wanted == "" then return end
    local template = toolsFolder:FindFirstChild(wanted)
    if not template then return end
    -- If character already has the tool, ensure it's configured
    for _, v in ipairs(character:GetChildren()) do
        if v:IsA("Tool") and v.Name == wanted then
            pcall(function() v.CanBeDropped = false end)
            return
        end
    end
    local clone = template:Clone()
    clone.Parent = character
    pcall(function() clone.CanBeDropped = false end)
end

Remote_SetLockedTool.OnServerEvent:Connect(function(player, toolName)
    if toolName ~= "" and typeof(toolName) ~= "string" then return end
    if toolName ~= "" and not toolsFolder:FindFirstChild(toolName) then
        -- Reject unknown tools
        return
    end
    player:SetAttribute("LockedTool", toolName)
    if player.Character then
        giveLockedToolToCharacter(player, player.Character)
    end
end)

-- Enforce locked tools periodically (Heartbeat)
RunService.Heartbeat:Connect(function(dt)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and char.Parent then
            local wanted = player:GetAttribute("LockedTool") or ""
            if wanted ~= "" then
                local has = false
                for _, v in ipairs(char:GetChildren()) do
                    if v:IsA("Tool") and v.Name == wanted then
                        has = true
                        pcall(function() v.CanBeDropped = false end)
                        break
                    end
                end
                if not has then
                    giveLockedToolToCharacter(player, char)
                end
                -- Remove duplicates from Backpack to ensure the tool stays in character
                local backpack = player:FindFirstChildOfClass("Backpack")
                if backpack then
                    local btool = backpack:FindFirstChild(wanted)
                    if btool then btool:Destroy() end
                end
            end
        end
    end
end)

-- Proximity handling: server validates and applies effects
local lastProcessed = {} -- player -> time
local function isModelPlayerCharacter(model)
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character == model then return true end
    end
    return false
end

Remote_ProximityReq.OnServerEvent:Connect(function(player, targets)
    -- Expect a table of Instance references (Models). Server validates distance & target type.
    if typeof(targets) ~= "table" then return end
    local now = os.clock()
    if lastProcessed[player] and now - lastProcessed[player] < CONFIG.ServerProximityCooldown then
        return -- throttle
    end
    lastProcessed[player] = now

    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Find player's active tool: locked tool preferred, otherwise first Tool in Character
    local activeTool
    local lockedName = player:GetAttribute("LockedTool") or ""
    if lockedName ~= "" then
        activeTool = char:FindFirstChild(lockedName)
    end
    if not activeTool then
        activeTool = char:FindFirstChildOfClass("Tool")
    end
    local damage = CONFIG.DefaultToolDamage
    if activeTool and activeTool:GetAttribute("BaseDamage") then
        damage = activeTool:GetAttribute("BaseDamage")
    end

    for _, t in ipairs(targets) do
        if typeof(t) == "Instance" and t:IsA("Model") then
            local hum = t:FindFirstChildOfClass("Humanoid")
            local targetHRP = t:FindFirstChild("HumanoidRootPart")
            if hum and targetHRP then
                local dist = (hrp.Position - targetHRP.Position).Magnitude
                if dist <= CONFIG.ProximityRadius then
                    -- Validate target type
                    if isModelPlayerCharacter(t) and not CONFIG.AllowPlayerTargets then
                        -- skip players unless allowed
                    else
                        -- Apply server-side effect: damage the humanoid. This is a safe, server-validated action.
                        if hum.Health > 0 then
                            -- Use :TakeDamage to let Roblox handle death logic
                            hum:TakeDamage(damage)
                            -- Optionally play a server-side sound or spawn effect if the tool template contains them
                            -- This ensures "silent execution" from the client's perspective (no camera force) but server-authoritative effects.
                        end
                    end
                end
            end
        end
    end
end)

-- Clean up proxies when player leaves
Players.PlayerRemoving:Connect(function(player)
    local pproxy = playerProxies[player]
    if pproxy and pproxy.Parent then pproxy:Destroy() end
    playerProxies[player] = nil
end)

-- Ensure initial attributes and hook CharacterAdded so locked tool is restored on spawn
Players.PlayerAdded:Connect(function(player)
    if player:GetAttribute("LockedTool") == nil then
        player:SetAttribute("LockedTool", "")
    end
    player.CharacterAdded:Connect(function(char)
        -- give locked tool if set
        giveLockedToolToCharacter(player, char)
        -- if proxy exists, reposition it next to character
        local proxy = playerProxies[player]
        if proxy and proxy.Parent then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp and proxy.PrimaryPart then
                proxy:SetPrimaryPartCFrame(hrp.CFrame)
            end
        end
    end)
end)

-- Create a LocalScript into StarterPlayerScripts that contains the client GUI and scanning logic.
-- This keeps deployment "single-file": server creates client code for players who join.
local function createClientScriptIfMissing()
    local sps = StarterPlayer:FindFirstChild("StarterPlayerScripts")
    if not sps then
        sps = Instance.new("Folder")
        sps.Name = "StarterPlayerScripts"
        sps.Parent = StarterPlayer
    end

    -- Name chosen to avoid collisions
    local scriptName = "CharacterState_Client"
    local existing = sps:FindFirstChild(scriptName)
    if existing then
        -- If exists and is LocalScript, skip creation (do not overwrite)
        if existing:IsA("LocalScript") then return end
        existing:Destroy()
    end

    local clientSource = [[
-- CharacterState_Client (auto-generated)
-- This LocalScript is created by the server-side CharacterStateFramework.lua.
-- It provides a draggable GUI, local scanning (throttled), highlights, and sends validated requests to server.
-- Place: StarterPlayerScripts (auto-inserted by server Script)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Remote references (must match server)
local charState = ReplicatedStorage:WaitForChild("CharacterState")
local Remote_ToggleGhost = charState:WaitForChild("ToggleGhost")
local Remote_SetLockedTool = charState:WaitForChild("SetLockedTool")
local Remote_ProximityReq = charState:WaitForChild("ProximityRequest")

-- Settings (match server config for good UX)
local PROXIMITY_RADIUS = ]] .. tostring(CONFIG.ProximityRadius) .. [[
local SCAN_FREQUENCY = ]] .. tostring(CONFIG.ClientScanFrequency) .. [[
local HIGHLIGHT_FILL = Color3.fromRGB(255, 0, 0)

-- State
local ghostEnabled = false
local auraEnabled = false
local lockedToolName = ""
local walkSpeed = 16
local lastScan = 0
local highlighted = {}

-- Utility: create a sleek draggable GUI
local function createGUI()
    local screen = Instance.new("ScreenGui")
    screen.Name = "CharacterStateGUI"
    screen.ResetOnSpawn = false
    screen.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local main = Instance.new("Frame")
    main.Name = "MainFrame"
    main.Size = UDim2.new(0, 360, 0, 420)
    main.Position = UDim2.new(0.5, -180, 0.35, -210)
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    main.BorderSizePixel = 0
    main.Parent = screen
    local corner = Instance.new("UICorner", main)
    corner.CornerRadius = UDim.new(0, 12)

    local top = Instance.new("Frame", main)
    top.Name = "Top"
    top.Size = UDim2.new(1, 0, 0, 44)
    top.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    local topLabel = Instance.new("TextLabel", top)
    topLabel.Size = UDim2.new(1, -48, 1, 0)
    topLabel.Position = UDim2.new(0, 12, 0, 0)
    topLabel.BackgroundTransparency = 1
    topLabel.Text = "CharacterState - Framework"
    topLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    topLabel.Font = Enum.Font.GothamBold
    topLabel.TextSize = 16

    local closeBtn = Instance.new("TextButton", top)
    closeBtn.Size = UDim2.new(0, 36, 0, 28)
    closeBtn.Position = UDim2.new(1, -44, 0.5, -14)
    closeBtn.Text = "X"
    closeBtn.BackgroundColor3 = Color3.fromRGB(160, 40, 40)
    closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.TextSize = 14
    local closeCorner = Instance.new("UICorner", closeBtn); closeCorner.CornerRadius = UDim.new(0,8)

    -- Draggable
    local dragging, dragInput, dragStart, startPos
    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    top.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    top.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        main.Visible = false
    end)

    -- Content area
    local content = Instance.new("Frame", main)
    content.Name = "Content"
    content.Position = UDim2.new(0, 12, 0, 56)
    content.Size = UDim2.new(1, -24, 1, -68)
    content.BackgroundTransparency = 1

    local function makeButton(text, parent)
        local b = Instance.new("TextButton", parent)
        b.Size = UDim2.new(1, 0, 0, 40)
        b.BackgroundColor3 = Color3.fromRGB(36,36,36)
        b.TextColor3 = Color3.fromRGB(255,255,255)
        b.Font = Enum.Font.Gotham
        b.TextSize = 14
        b.Text = text
        local c = Instance.new("UICorner", b); c.CornerRadius = UDim.new(0,8)
        return b
    end

    local ghostBtn = makeButton("Ghost Mode: OFF", content)
    ghostBtn.Position = UDim2.new(0, 0, 0, 0)
    local lockBtn = makeButton("Tool Lock: OFF", content)
    lockBtn.Position = UDim2.new(0, 0, 0, 52)
    local auraBtn = makeButton("Smart Aura: OFF", content)
    auraBtn.Position = UDim2.new(0, 0, 0, 104)

    -- WalkSpeed slider
    local wsLabel = Instance.new("TextLabel", content)
    wsLabel.Position = UDim2.new(0, 0, 0, 160)
    wsLabel.Size = UDim2.new(1, 0, 0, 20)
    wsLabel.Text = "WalkSpeed: 16"
    wsLabel.BackgroundTransparency = 1
    wsLabel.TextColor3 = Color3.fromRGB(230,230,230)
    wsLabel.Font = Enum.Font.Gotham
    wsLabel.TextSize = 14

    local sliderBg = Instance.new("Frame", content)
    sliderBg.Position = UDim2.new(0, 0, 0, 184)
    sliderBg.Size = UDim2.new(1, 0, 0, 10)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60,60,60)
    local sliderFill = Instance.new("Frame", sliderBg)
    sliderFill.Size = UDim2.new(0.16, 0, 1, 0) -- default 16/100
    sliderFill.BackgroundColor3 = Color3.fromRGB(200,30,30)
    local sliderKnob = Instance.new("ImageButton", sliderBg)
    sliderKnob.Size = UDim2.new(0, 18, 1, 0)
    sliderKnob.Position = UDim2.new(0.16, -9, 0, 0)
    sliderKnob.Image = ""
    local knobCorner = Instance.new("UICorner", sliderKnob); knobCorner.CornerRadius = UDim.new(0, 9)
    sliderKnob.BackgroundColor3 = Color3.fromRGB(240,240,240)

    local function setWalkSpeedFromNormalized(n)
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then return end
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        -- normalized n from 0.1 to 3.0 multiplier roughly
        local ws = math.clamp(math.floor(16 * n + 0.5), 8, 240)
        hum.WalkSpeed = ws
        walkSpeed = ws
        wsLabel.Text = "WalkSpeed: " .. tostring(ws)
    end

    -- slider drag
    local draggingSlider = false
    sliderKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
            local absPos = input.Position
            local bgPos = sliderBg.AbsolutePosition
            local bgSize = sliderBg.AbsoluteSize
            local x = math.clamp(absPos.X - bgPos.X, 0, bgSize.X)
            local frac = x / bgSize.X
            sliderFill.Size = UDim2.new(frac, 0, 1, 0)
            sliderKnob.Position = UDim2.new(frac, -9, 0, 0)
            setWalkSpeedFromNormalized(frac * 3) -- scale to desired range
        end
    end)

    -- Button handlers
    ghostBtn.MouseButton1Click:Connect(function()
        ghostEnabled = not ghostEnabled
        Remote_ToggleGhost:FireServer(ghostEnabled)
        ghostBtn.Text = "Ghost Mode: " .. (ghostEnabled and "ON" or "OFF")
    end)

    lockBtn.MouseButton1Click:Connect(function()
        -- lock currently equipped tool
        local char = LocalPlayer.Character
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if not tool then
            -- toggle off if no tool
            lockedToolName = ""
            Remote_SetLockedTool:FireServer("")
            lockBtn.Text = "Tool Lock: OFF"
            return
        end
        if lockedToolName == tool.Name then
            -- unlock
            lockedToolName = ""
            Remote_SetLockedTool:FireServer("")
            lockBtn.Text = "Tool Lock: OFF"
        else
            -- lock this tool
            lockedToolName = tool.Name
            Remote_SetLockedTool:FireServer(lockedToolName)
            lockBtn.Text = "Tool Lock: ON (" .. lockedToolName .. ")"
        end
    end)

    auraBtn.MouseButton1Click:Connect(function()
        auraEnabled = not auraEnabled
        auraBtn.Text = "Smart Aura: " .. (auraEnabled and "ON" or "OFF")
        if not auraEnabled then
            -- clear highlights
            for m, hl in pairs(highlighted) do
                if hl and hl.Parent then hl:Destroy() end
            end
            highlighted = {}
        end
    end)

    return {
        Screen = screen,
        Main = main,
    }
end

-- Highlight helpers
local function ensureHighlightForModel(model)
    if highlighted[model] then return highlighted[model] end
    local hum = model:FindFirstChildOfClass("Humanoid")
    if not hum then return nil end
    local hl = Instance.new("Highlight")
    hl.Name = "SmartAuraHighlight"
    hl.FillColor = HIGHLIGHT_FILL
    hl.OutlineColor = Color3.new(1,1,1)
    hl.FillTransparency = 0.6
    hl.Parent = model
    highlighted[model] = hl
    return hl
end

local function clearHighlightsNotInSet(setOfModels)
    for model, hl in pairs(highlighted) do
        if not setOfModels[model] then
            if hl and hl.Parent then hl:Destroy() end
            highlighted[model] = nil
        end
    end
end

-- Efficient local scan (throttled): iterate Workspace descendants but skip heavy parts by heuristic
local function scanForTargets()
    local results = {}
    local char = LocalPlayer.Character
    if not char then return results end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return results end

    -- Prefer scanning under common containers if present (optimize for typical game structure)
    local toScan = {}
    if Workspace:FindFirstChild("NPCs") then
        table.insert(toScan, Workspace.NPCs)
    elseif Workspace:FindFirstChild("Enemies") then
        table.insert(toScan, Workspace.Enemies)
    else
        table.insert(toScan, Workspace)
    end

    for _, root in ipairs(toScan) do
        for _, model in ipairs(root:GetDescendants()) do
            if model:IsA("Model") and model ~= char then
                local hum = model:FindFirstChildOfClass("Humanoid")
                local targetHRP = model:FindFirstChild("HumanoidRootPart")
                if hum and targetHRP then
                    local dist = (hrp.Position - targetHRP.Position).Magnitude
                    if dist <= PROXIMITY_RADIUS then
                        table.insert(results, model)
                    end
                end
            end
        end
    end

    return results
end

-- Main RenderStepped: scanning and sending instances to server (throttled)
RunService.RenderStepped:Connect(function(dt)
    lastScan = lastScan + dt
    if auraEnabled and lastScan >= SCAN_FREQUENCY then
        lastScan = 0
        local targets = scanForTargets()
        local toSend = {}
        local set = {}
        for _, t in ipairs(targets) do
            set[t] = true
            ensureHighlightForModel(t)
            table.insert(toSend, t)
        end
        clearHighlightsNotInSet(set)
        if #toSend > 0 then
            -- Send detected models to server for validated processing
            -- Server will validate distance and target type before applying effects
            Remote_ProximityReq:FireServer(toSend)
        end
    end
end)

-- Cleanup highlights on respawn
LocalPlayer.CharacterAdded:Connect(function()
    for m, hl in pairs(highlighted) do
        if hl and hl.Parent then hl:Destroy() end
    end
    highlighted = {}
end)

-- Create GUI
createGUI()

-- Optional: helpful keybinds (G:ghost, H:aura, L:lock/unlock current tool)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.G then
        ghostEnabled = not ghostEnabled
        Remote_ToggleGhost:FireServer(ghostEnabled)
    elseif input.KeyCode == Enum.KeyCode.H then
        auraEnabled = not auraEnabled
    elseif input.KeyCode == Enum.KeyCode.L then
        -- toggle lock for current tool
        local c = LocalPlayer.Character
        if not c then return end
        local t = c:FindFirstChildOfClass("Tool")
        if not t then
            lockedToolName = ""
            Remote_SetLockedTool:FireServer("")
        else
            if lockedToolName == t.Name then
                lockedToolName = ""
                Remote_SetLockedTool:FireServer("")
            else
                lockedToolName = t.Name
                Remote_SetLockedTool:FireServer(lockedToolName)
            end
        end
    end
end)
]]

    -- create LocalScript instance and set Source
    local ls = Instance.new("LocalScript")
    ls.Name = "CharacterState_Client"
    ls.Source = clientSource
    ls.Parent = sps
end

-- Create client script if missing (only once)
createClientScriptIfMissing()

-- Final log
print("[CharacterStateFramework] Initialized. Client script injected into StarterPlayerScripts. Ensure ServerStorage." .. CONFIG.ToolsFolderName .. " contains your Tool templates if you intend to use Tool Locking.")
print("[CharacterStateFramework] This module is server-authoritative; use only in places you own.")

-- End of server script
