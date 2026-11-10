--==============================================================--
--  ULTRA SCRIPT HUB - Made by Junejo
--  Game: 99 Nights in the Forest
--  Game Link: https://www.roblox.com/games/79546208627805/99-Nights-in-the-Forest
--  Version: 2.0 (Full Overhaul - Campfire, Kill Aura, ESP, FullBright)
--==============================================================--

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    repeat
        task.wait()
        LocalPlayer = Players.LocalPlayer
    until LocalPlayer
end

-- Feature Toggle States (7 Powerful Survival Features)
local AutoCampfireEnabled = false   -- 1. Auto Feed Campfire & Wood
local KillAuraEnabled = false       -- 2. Kill Aura (Cultists & Monsters)
local AutoCollectEnabled = false    -- 3. Auto Collect Loot & Drops
local FullBrightEnabled = false     -- 4. FullBright (Night Vision)
local ESPEnabled = false            -- 5. Lost Children & Entity ESP
local SpeedBoostEnabled = false     -- 6. Speed Boost (35)
local InfJumpNoclipEnabled = false  -- 7. Infinite Jump & NoClip

-- Default Settings
local NormalSpeed = 16
local BoostedSpeed = 35

-- Anti-AFK Setup
pcall(function()
    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end)
end)

----------------------------------------------------------------
-- GUI CREATION (ULTRA SCRIPT HUB THEME - Made by Junejo)
----------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraScriptHub_99Nights"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999
ScreenGui.IgnoreGuiInset = true

-- Clean previous instances
pcall(function()
    if gethui and gethui():FindFirstChild("UltraScriptHub_99Nights") then
        gethui():FindFirstChild("UltraScriptHub_99Nights"):Destroy()
    end
end)
pcall(function()
    if CoreGui and CoreGui:FindFirstChild("UltraScriptHub_99Nights") then
        CoreGui:FindFirstChild("UltraScriptHub_99Nights"):Destroy()
    end
end)
pcall(function()
    local pgui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if pgui and pgui:FindFirstChild("UltraScriptHub_99Nights") then
        pgui:FindFirstChild("UltraScriptHub_99Nights"):Destroy()
    end
end)

-- Safe UI Parent Selection
local guiParent = nil
if gethui then
    pcall(function() guiParent = gethui() end)
end
if not guiParent then
    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(ScreenGui)
        end
        if CoreGui and pcall(function() return CoreGui.Name end) then
            guiParent = CoreGui
        end
    end)
end
if not guiParent then
    pcall(function()
        guiParent = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
    end)
end

pcall(function()
    ScreenGui.Parent = guiParent
end)
if not ScreenGui.Parent then
    pcall(function()
        ScreenGui.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
    end)
end

-- Main Outer Frame (Compact exact design)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 360)
MainFrame.Position = UDim2.new(0.5, -160, 0.4, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.ZIndex = 10
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(45, 48, 60)
UIStroke.Thickness = 1.2
UIStroke.Parent = MainFrame

-- Floating Open/Close Toggle Button (Mobile & Quick Access)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleUI_Btn"
ToggleButton.Size = UDim2.new(0, 42, 0, 42)
ToggleButton.Position = UDim2.new(0, 15, 0.5, -21)
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
ToggleButton.BorderColor3 = Color3.fromRGB(0, 170, 255)
ToggleButton.BorderSizePixel = 1
ToggleButton.Text = "🌲"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 22
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.ZIndex = 20
ToggleButton.Parent = ScreenGui

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 10)
BtnCorner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Header Title
local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -50, 0, 35)
HeaderTitle.Position = UDim2.new(0, 16, 0, 10)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "99 NIGHTS IN THE FOREST"
HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitle.TextSize = 13
HeaderTitle.Font = Enum.Font.SourceSansBold
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.ZIndex = 11
HeaderTitle.Parent = MainFrame

-- Close Button (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -34, 0, 10)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.ZIndex = 11
CloseBtn.Parent = MainFrame

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Content Container
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -32, 0, 245)
Container.Position = UDim2.new(0, 16, 0, 50)
Container.BackgroundTransparency = 1
Container.ZIndex = 11
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.Parent = Container

-- Footer Titles
local FooterTitle = Instance.new("TextLabel")
FooterTitle.Size = UDim2.new(1, 0, 0, 22)
FooterTitle.Position = UDim2.new(0, 0, 1, -44)
FooterTitle.BackgroundTransparency = 1
FooterTitle.Text = "ULTRA SCRIPT HUB"
FooterTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
FooterTitle.TextSize = 17
FooterTitle.Font = Enum.Font.SourceSansBold
FooterTitle.ZIndex = 11
FooterTitle.Parent = MainFrame

local FooterSub = Instance.new("TextLabel")
FooterSub.Size = UDim2.new(1, 0, 0, 16)
FooterSub.Position = UDim2.new(0, 0, 1, -22)
FooterSub.BackgroundTransparency = 1
FooterSub.Text = "Made by Junejo"
FooterSub.TextColor3 = Color3.fromRGB(150, 150, 150)
FooterSub.TextSize = 13
FooterSub.Font = Enum.Font.SourceSans
FooterSub.ZIndex = 11
FooterSub.Parent = MainFrame

-- Checkbox Row Generator
local function CreateToggleRow(name, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 28)
    Row.BackgroundTransparency = 1
    Row.ZIndex = 12
    Row.Parent = Container

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -35, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 220, 225)
    Label.TextSize = 13
    Label.Font = Enum.Font.SourceSansBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 13
    Label.Parent = Row

    local Checkbox = Instance.new("TextButton")
    Checkbox.Size = UDim2.new(0, 22, 0, 22)
    Checkbox.Position = UDim2.new(1, -24, 0.5, -11)
    Checkbox.BackgroundColor3 = Color3.fromRGB(25, 27, 35)
    Checkbox.BorderColor3 = Color3.fromRGB(45, 48, 60)
    Checkbox.Text = ""
    Checkbox.AutoButtonColor = false
    Checkbox.ZIndex = 13
    Checkbox.Parent = Row

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 4)
    BoxCorner.Parent = Checkbox

    local CheckIcon = Instance.new("Frame")
    CheckIcon.Size = UDim2.new(1, -6, 1, -6)
    CheckIcon.Position = UDim2.new(0, 3, 0, 3)
    CheckIcon.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    CheckIcon.Visible = false
    CheckIcon.ZIndex = 14
    CheckIcon.Parent = Checkbox

    local CheckIconCorner = Instance.new("UICorner")
    CheckIconCorner.CornerRadius = UDim.new(0, 2)
    CheckIconCorner.Parent = CheckIcon

    local toggled = false
    local function setToggle(state)
        toggled = state
        CheckIcon.Visible = toggled
        if toggled then
            Checkbox.BackgroundColor3 = Color3.fromRGB(30, 35, 48)
            Checkbox.BorderColor3 = Color3.fromRGB(0, 170, 255)
        else
            Checkbox.BackgroundColor3 = Color3.fromRGB(25, 27, 35)
            Checkbox.BorderColor3 = Color3.fromRGB(45, 48, 60)
        end
        pcall(callback, toggled)
    end

    Checkbox.MouseButton1Click:Connect(function()
        setToggle(not toggled)
    end)

    Row.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if input.Target == Row or input.Target == Label then
                setToggle(not toggled)
            end
        end
    end)

    return Row
end

----------------------------------------------------------------
-- REGISTER 7 EXACT FEATURES IN UI
----------------------------------------------------------------
CreateToggleRow("Auto Feed Campfire", function(state)
    AutoCampfireEnabled = state
end)

CreateToggleRow("Kill Aura (Monsters)", function(state)
    KillAuraEnabled = state
end)

CreateToggleRow("Auto Collect Loot", function(state)
    AutoCollectEnabled = state
end)

CreateToggleRow("FullBright (Night Vision)", function(state)
    FullBrightEnabled = state
end)

CreateToggleRow("Lost Children & Mob ESP", function(state)
    ESPEnabled = state
end)

CreateToggleRow("Speed Boost (35)", function(state)
    SpeedBoostEnabled = state
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = state and BoostedSpeed or NormalSpeed
    end
end)

CreateToggleRow("Inf Jump & NoClip", function(state)
    InfJumpNoclipEnabled = state
end)

----------------------------------------------------------------
-- HELPER FUNCTIONS (Character, Remotes, Prompts)
----------------------------------------------------------------
local function getChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getRoot()
    local char = LocalPlayer.Character
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char.PrimaryPart)
end

local function getHum()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function fireProximity(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") or not prompt.Enabled then return end
    pcall(function()
        prompt.HoldDuration = 0
        if fireproximityprompt then
            fireproximityprompt(prompt)
        else
            prompt:InputHoldBegin()
            task.wait(0.05)
            prompt:InputHoldEnd()
        end
    end)
end

local function safeFireRemote(remote, ...)
    if remote then
        pcall(function()
            if remote:IsA("RemoteEvent") then
                remote:FireServer(...)
            elseif remote:IsA("RemoteFunction") then
                remote:InvokeServer(...)
            end
        end)
    end
end

----------------------------------------------------------------
-- 1. FEATURE: AUTO FEED CAMPFIRE & LOGS
----------------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0.8)
        if AutoCampfireEnabled then
            pcall(function()
                local root = getRoot()
                local char = getChar()
                if not root or not char then return end

                -- 1. Equip wood, log, stick or fuel from backpack
                local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
                if bp then
                    for _, tool in ipairs(bp:GetChildren()) do
                        if tool:IsA("Tool") then
                            local n = tool.Name:lower()
                            if n:find("wood") or n:find("log") or n:find("stick") or n:find("fuel") or n:find("plank") then
                                char.Humanoid:EquipTool(tool)
                                break
                            end
                        end
                    end
                end

                -- 2. Find Campfire and trigger fuel prompts
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not AutoCampfireEnabled then break end
                    local n = obj.Name:lower()
                    if n:find("fire") or n:find("camp") or n:find("furnace") or n:find("bonfire") then
                        for _, p in ipairs(obj:GetDescendants()) do
                            if p:IsA("ProximityPrompt") then
                                local pName = (p.ActionText .. " " .. p.ObjectText):lower()
                                if pName:find("add") or pName:find("feed") or pName:find("fuel") or pName:find("fire") or pName:find("wood") or pName:find("ignite") or pName:find("light") then
                                    fireProximity(p)
                                end
                            end
                        end
                    end
                end

                -- 3. Trigger remote calls for campfire upgrade/feed
                for _, rName in ipairs({"UpgradeCampfire", "RequestUpgradeFire", "FeedFire", "AddWood", "InteractCampfire"}) do
                    local rem = ReplicatedStorage:FindFirstChild(rName, true)
                    if rem then safeFireRemote(rem) end
                end
            end)
        end
    end
end)

----------------------------------------------------------------
-- 2. FEATURE: KILL AURA (Cultists, Deer Monster, Mobs)
----------------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0.2)
        if KillAuraEnabled then
            pcall(function()
                local root = getRoot()
                local char = getChar()
                local hum = getHum()
                if not root or not char or not hum then return end

                -- Auto equip best weapon or tool
                local currentTool = char:FindFirstChildOfClass("Tool")
                if not currentTool then
                    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
                    if bp then
                        for _, t in ipairs(bp:GetChildren()) do
                            if t:IsA("Tool") then
                                local tn = t.Name:lower()
                                if tn:find("axe") or tn:find("sword") or tn:find("knife") or tn:find("gun") or tn:find("bow") or tn:find("weapon") or tn:find("spear") then
                                    hum:EquipTool(t)
                                    currentTool = t
                                    break
                                end
                            end
                        end
                        if not currentTool and bp:FindFirstChildOfClass("Tool") then
                            local t = bp:FindFirstChildOfClass("Tool")
                            hum:EquipTool(t)
                            currentTool = t
                        end
                    end
                end

                -- Scan Workspace for hostile entities
                for _, mob in ipairs(Workspace:GetDescendants()) do
                    if not KillAuraEnabled then break end
                    if mob:IsA("Model") and mob ~= char and mob:FindFirstChildOfClass("Humanoid") then
                        local mobHum = mob:FindFirstChildOfClass("Humanoid")
                        local mobRoot = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso") or mob.PrimaryPart
                        
                        local mName = mob.Name:lower()
                        local isHostile = mName:find("cultist") or mName:find("monster") or mName:find("deer") or mName:find("wolf") or mName:find("bear") or mName:find("owl") or mName:find("ram") or mName:find("enemy") or mName:find("zombie") or mob:FindFirstChild("Enemy")
                        
                        -- Avoid friendly players
                        if Players:GetPlayerFromCharacter(mob) then
                            isHostile = false
                        end

                        if isHostile and mobRoot and mobHum and mobHum.Health > 0 then
                            local dist = (mobRoot.Position - root.Position).Magnitude
                            if dist <= 30 then
                                if currentTool then
                                    pcall(function() currentTool:Activate() end)
                                    local handle = currentTool:FindFirstChild("Handle") or currentTool:FindFirstChildWhichIsA("BasePart")
                                    if handle and firetouchinterest then
                                        firetouchinterest(handle, mobRoot, 0)
                                        task.wait(0.01)
                                        firetouchinterest(handle, mobRoot, 1)
                                    end
                                end

                                -- Fire combat remotes
                                for _, remName in ipairs({"AttackMob", "HitEnemy", "DamageMob", "WeaponHit", "MeleeSwing"}) do
                                    local r = ReplicatedStorage:FindFirstChild(remName, true)
                                    if r then safeFireRemote(r, mob, mobRoot.Position) end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

----------------------------------------------------------------
-- 3. FEATURE: AUTO COLLECT LOOT & DROPS
----------------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0.4)
        if AutoCollectEnabled then
            pcall(function()
                local root = getRoot()
                if not root then return end

                for _, item in ipairs(Workspace:GetDescendants()) do
                    if not AutoCollectEnabled then break end
                    local n = item.Name:lower()
                    local isItem = n:find("stick") or n:find("wood") or n:find("log") or n:find("drop") or n:find("loot") or n:find("meat") or n:find("scrap") or n:find("bandage") or n:find("ammo") or n:find("coin") or n:find("chest") or n:find("crate") or n:find("item")
                    
                    if isItem then
                        if item:IsA("ProximityPrompt") then
                            fireProximity(item)
                        elseif item:IsA("BasePart") and not item.Anchored then
                            local dist = (item.Position - root.Position).Magnitude
                            if dist <= 40 then
                                if firetouchinterest then
                                    firetouchinterest(root, item, 0)
                                    task.wait(0.01)
                                    firetouchinterest(root, item, 1)
                                end
                            end
                        end
                    end
                end

                -- Remote loot collection
                local collectRemote = ReplicatedStorage:FindFirstChild("RequestCollectCandy", true) or ReplicatedStorage:FindFirstChild("CollectDrop", true)
                if collectRemote then safeFireRemote(collectRemote) end
            end)
        end
    end
end)

----------------------------------------------------------------
-- 4. FEATURE: FULLBRIGHT (NIGHT VISION)
----------------------------------------------------------------
local origBrightness = Lighting.Brightness
local origClockTime = Lighting.ClockTime
local origFogEnd = Lighting.FogEnd
local origGlobalShadows = Lighting.GlobalShadows
local origAmbient = Lighting.Ambient

task.spawn(function()
    while true do
        task.wait(0.5)
        if FullBrightEnabled then
            pcall(function()
                Lighting.Brightness = 2
                Lighting.ClockTime = 14
                Lighting.FogEnd = 100000
                Lighting.GlobalShadows = false
                Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            end)
        end
    end
end)

----------------------------------------------------------------
-- 5. FEATURE: LOST CHILDREN & ENTITY ESP
----------------------------------------------------------------
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "UltraHub_ESP"
pcall(function() ESPFolder.Parent = CoreGui end)
if not ESPFolder.Parent then ESPFolder.Parent = ScreenGui end

local function addESP(model, text, color)
    if not model or model:FindFirstChild("UltraESP_Highlight") then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "UltraESP_Highlight"
    highlight.FillColor = color
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0.1
    highlight.Adornee = model
    highlight.Parent = ESPFolder

    local head = model:FindFirstChild("Head") or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
    if head then
        local bb = Instance.new("BillboardGui")
        bb.Name = "UltraESP_Bill"
        bb.Adornee = head
        bb.Size = UDim2.new(0, 140, 0, 30)
        bb.StudsOffset = Vector3.new(0, 2.5, 0)
        bb.AlwaysOnTop = true
        bb.Parent = ESPFolder

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = color
        lbl.TextSize = 13
        lbl.Font = Enum.Font.SourceSansBold
        lbl.TextStrokeTransparency = 0
        lbl.Parent = bb
    end
end

task.spawn(function()
    while true do
        task.wait(1.5)
        if ESPEnabled then
            pcall(function()
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj ~= LocalPlayer.Character then
                        local n = obj.Name:lower()
                        if n:find("child") or n:find("kid") or n:find("lost") or n:find("missing") then
                            addESP(obj, "👶 LOST CHILD", Color3.fromRGB(0, 255, 170))
                        elseif n:find("cultist") or n:find("deer") or n:find("monster") or n:find("wolf") or n:find("bear") then
                            addESP(obj, "⚠️ " .. obj.Name:upper(), Color3.fromRGB(255, 60, 60))
                        elseif n:find("campfire") or n:find("fire pit") then
                            addESP(obj, "🔥 CAMPFIRE", Color3.fromRGB(255, 170, 0))
                        end
                    end
                end
            end)
        else
            pcall(function()
                ESPFolder:ClearAllChildren()
            end)
        end
    end
end)

----------------------------------------------------------------
-- 6. FEATURE: SPEED BOOST (35)
----------------------------------------------------------------
RunService.Stepped:Connect(function()
    if SpeedBoostEnabled then
        local hum = getHum()
        if hum then hum.WalkSpeed = BoostedSpeed end
    end
end)

----------------------------------------------------------------
-- 7. FEATURE: INFINITE JUMP & NOCLIP
----------------------------------------------------------------
UserInputService.JumpRequest:Connect(function()
    if InfJumpNoclipEnabled then
        local hum = getHum()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

RunService.Stepped:Connect(function()
    if InfJumpNoclipEnabled then
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Send loaded notification
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Ultra Script Hub",
        Text = "99 Nights in the Forest loaded successfully!",
        Duration = 3
    })
end)
