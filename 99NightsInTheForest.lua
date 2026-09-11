--==============================================================--
--  ULTRA SCRIPT HUB - Made by Junejo
--  Game: 99 Nights in the Forest
--  Version: 1.0 (All 7 Main Features Supported)
--==============================================================--

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = nil
pcall(function() VirtualUser = game:GetService("VirtualUser") end)

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Anti-AFK Setup
LocalPlayer.Idled:Connect(function()
    if VirtualUser then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

-- Feature States (Exact 7 Main Features)
local AutoQuestsEnabled = false        -- 1. Auto Daily & Weekly Quests
local AutoTalentRerollEnabled = false  -- 2. Auto Talent & Class Progression
local AutoWaveCombatEnabled = false    -- 3. Cultist Wave Defense & Kill Aura
local AutoToolUpgradeEnabled = false   -- 4. Auto Tools & Fire Upgrades
local AutoCollectLootEnabled = false   -- 5. Auto Collect Items, Pets & Toys
local AutoClaimRewardsEnabled = false  -- 6. In-Game Shops & Supply Crates
local SkipCutscenesEnabled = false     -- 7. Skip Cutscenes & Instant Dialogue

-- Player Movement Settings
local WalkSpeedBoost = false
local SpeedValue = 32
local InfJumpEnabled = false
local NoclipEnabled = false

-- Helper Functions
local function getChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getRoot()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

local function getHum()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end

-- Universal Event Invoker (Finds remote regardless of nesting)
local function findRemote(name)
    local remote = ReplicatedStorage:FindFirstChild(name, true)
    return remote
end

local function fireGameRemote(remoteName, ...)
    local remote = findRemote(remoteName)
    if remote then
        pcall(function()
            if remote:IsA("RemoteEvent") then
                remote:FireServer(...)
            elseif remote:IsA("RemoteFunction") then
                remote:InvokeServer(...)
            end
        end)
        return true
    end
    return false
end

-- Universal ProximityPrompt Trigger
local function triggerAllPrompts(radius)
    local root = getRoot()
    if not root then return end
    for _, prompt in ipairs(Workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") and prompt.Enabled then
            local parent = prompt.Parent
            local pos = nil
            if parent:IsA("BasePart") then
                pos = parent.Position
            elseif parent:IsA("Model") and parent.PrimaryPart then
                pos = parent.PrimaryPart.Position
            end
            if pos and (pos - root.Position).Magnitude <= (radius or 35) then
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
        end
    end
end

----------------------------------------------------------------
-- 1. DAILY & WEEKLY QUESTS SYSTEM
----------------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(1.5)
        if AutoQuestsEnabled then
            pcall(function()
                -- Claim Daily Quest Rewards
                fireGameRemote("RequestClaimDailyRequestReward")
                fireGameRemote("RequestClaimEventPrize")
                
                -- Check for Quest Boards or Prompts in Workspace
                local questFolder = Workspace:FindFirstChild("Quests") or Workspace:FindFirstChild("QuestBoard")
                if questFolder then
                    for _, item in ipairs(questFolder:GetDescendants()) do
                        if item:IsA("ProximityPrompt") then
                            item.HoldDuration = 0
                            if fireproximityprompt then fireproximityprompt(item) end
                        end
                    end
                end
            end)
        end
    end
end)

----------------------------------------------------------------
-- 2. TALENT & CLASS PROGRESSION (REROLL & UPGRADE)
----------------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(2)
        if AutoTalentRerollEnabled then
            pcall(function()
                fireGameRemote("RequestUnlockTalent")
                fireGameRemote("RequestLevelUpClass")
                fireGameRemote("RequestPurchaseClass")
                fireGameRemote("RequestRerollTalent")
            end)
        end
    end
end)

----------------------------------------------------------------
-- 3. CULTIST WAVE DEFENSE & KILL AURA
----------------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0.2)
        if AutoWaveCombatEnabled then
            pcall(function()
                local root = getRoot()
                local char = getChar()
                if not root or not char then return end

                -- Trigger Wave benefits
                fireGameRemote("PlayWaveClientReady")
                fireGameRemote("PlayWaveBenefit")

                -- Auto Attack Nearby Monsters / Cultists
                local equippedTool = char:FindFirstChildOfClass("Tool")
                if not equippedTool then
                    local backpackTool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
                    if backpackTool then
                        getHum():EquipTool(backpackTool)
                        equippedTool = backpackTool
                    end
                end

                for _, mob in ipairs(Workspace:GetChildren()) do
                    if mob:IsA("Model") and mob ~= char and (mob:FindFirstChild("Humanoid") or mob:FindFirstChild("Enemy") or mob.Name:lower():find("cultist") or mob.Name:lower():find("monster")) then
                        local mobRoot = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso") or mob.PrimaryPart
                        local mobHum = mob:FindFirstChildOfClass("Humanoid")
                        if mobRoot and mobHum and mobHum.Health > 0 then
                            local dist = (mobRoot.Position - root.Position).Magnitude
                            if dist <= 25 then
                                if equippedTool then
                                    pcall(function() equippedTool:Activate() end)
                                end
                                -- Touch handle damage simulation
                                local handle = equippedTool and equippedTool:FindFirstChild("Handle")
                                if handle and firetouchinterest then
                                    firetouchinterest(handle, mobRoot, 0)
                                    task.wait()
                                    firetouchinterest(handle, mobRoot, 1)
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
-- 4. TOOLS & FIRE UPGRADES SYSTEM
----------------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(1)
        if AutoToolUpgradeEnabled then
            pcall(function()
                -- Upgrade Campfire / Fire Upgrades
                fireGameRemote("UpgradeCampfire")
                fireGameRemote("RequestUpgradeFire")
                
                -- Collect logs/sticks or trigger fire prompts
                local fireObj = Workspace:FindFirstChild("Campfire", true) or Workspace:FindFirstChild("Fire", true)
                if fireObj then
                    for _, p in ipairs(fireObj:GetDescendants()) do
                        if p:IsA("ProximityPrompt") then
                            p.HoldDuration = 0
                            if fireproximityprompt then fireproximityprompt(p) end
                        end
                    end
                end
            end)
        end
    end
end)

----------------------------------------------------------------
-- 5. COLLECT ITEMS, CANDIES, PETS & TOYS
----------------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0.5)
        if AutoCollectLootEnabled then
            pcall(function()
                local root = getRoot()
                if not root then return end

                -- Trigger Candy / Seasonal Collects
                fireGameRemote("RequestCollectCandy")

                -- Magnet nearby collectible items / drops
                for _, item in ipairs(Workspace:GetChildren()) do
                    if item:IsA("BasePart") or item:IsA("Model") then
                        local itemName = item.Name:lower()
                        if itemName:find("wood") or itemName:find("stick") or itemName:find("candy") or itemName:find("coin") or itemName:find("diamond") or itemName:find("egg") or itemName:find("toy") or itemName:find("drop") then
                            local part = item:IsA("BasePart") and item or item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")
                            if part and (part.Position - root.Position).Magnitude <= 40 then
                                if firetouchinterest then
                                    firetouchinterest(root, part, 0)
                                    task.wait()
                                    firetouchinterest(root, part, 1)
                                else
                                    part.CFrame = root.CFrame
                                end
                            end
                        end
                    end
                end

                -- Auto interact with collectible prompts
                triggerAllPrompts(30)
            end)
        end
    end
end)

----------------------------------------------------------------
-- 6. IN-GAME SHOPS & SUPPLY CRATES
----------------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(2)
        if AutoClaimRewardsEnabled then
            pcall(function()
                fireGameRemote("RequestClaimBadgeDiamonds")
                fireGameRemote("RequestOpenPresent")
                fireGameRemote("SetSupplyCrateEquipped", true)
                fireGameRemote("RequestPurchaseChristmasItem")
                fireGameRemote("RequestPurchaseHalloweenItem")
                fireGameRemote("RequestPurchaseEasterItem")
            end)
        end
    end
end)

----------------------------------------------------------------
-- 7. SKIP CUTSCENES & FAST DIALOGUE
----------------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0.3)
        if SkipCutscenesEnabled then
            pcall(function()
                -- Instantly disable / fire completion for active cutscenes
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                if playerGui then
                    local cutsceneGui = playerGui:FindFirstChild("Flashback_Cutscene") or playerGui:FindFirstChild("CutsceneGui") or playerGui:FindFirstChild("DialogueGui")
                    if cutsceneGui then
                        for _, elem in ipairs(cutsceneGui:GetDescendants()) do
                            if elem:IsA("TextButton") or elem:IsA("ImageButton") then
                                if elem.Name:lower():find("skip") or elem.Name:lower():find("next") or elem.Name:lower():find("close") then
                                    elem.Position = UDim2.new(0, 0, 0, 0)
                                    if getconnections then
                                        for _, conn in ipairs(getconnections(elem.MouseButton1Click)) do
                                            conn:Fire()
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                
                -- Instant Dialogue trigger
                fireGameRemote("SetDialogue", "End")
                fireGameRemote("SkipCutscene")
            end)
        end
    end
end)

----------------------------------------------------------------
-- Movement & Physics Tweaks (Speed & Noclip)
----------------------------------------------------------------
RunService.Stepped:Connect(function()
    if NoclipEnabled then
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
    if WalkSpeedBoost then
        local hum = getHum()
        if hum then
            hum.WalkSpeed = SpeedValue
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled then
        local hum = getHum()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

----------------------------------------------------------------
-- GUI CREATION (ULTRA SCRIPT HUB THEME)
----------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraScriptHub_99NightsInTheForest"
ScreenGui.ResetOnSpawn = false

local parentGui = LocalPlayer:WaitForChild("PlayerGui")
if gethui then
    parentGui = gethui()
elseif CoreGui then
    parentGui = CoreGui
end
ScreenGui.Parent = parentGui

-- Main Outer Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 360, 0, 480)
MainFrame.Position = UDim2.new(0.5, -180, 0.4, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 55, 75)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(22, 26, 36)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -50, 1, 0)
HeaderTitle.Position = UDim2.new(0, 16, 0, 0)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "99 NIGHTS IN THE FOREST"
HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitle.TextSize = 14
HeaderTitle.Font = Enum.Font.GothamBold
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0, 7.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 40, 55)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Scroll Container for Features
local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(1, -24, 1, -110)
ScrollContainer.Position = UDim2.new(0, 12, 0, 55)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.BorderSizePixel = 0
ScrollContainer.ScrollBarThickness = 4
ScrollContainer.ScrollBarImageColor3 = Color3.fromRGB(70, 80, 110)
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 420)
ScrollContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = ScrollContainer

-- Toggle Creator Utility
local function createToggle(title, defaultState, callback)
    local state = defaultState
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = state and Color3.fromRGB(30, 70, 45) or Color3.fromRGB(25, 28, 38)
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = ScrollContainer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = state and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(40, 45, 60)
    stroke.Thickness = 1
    stroke.Parent = btn

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Color3.fromRGB(240, 240, 240)
    label.TextSize = 12
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = btn

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(0, 50, 1, 0)
    status.Position = UDim2.new(1, -55, 0, 0)
    status.BackgroundTransparency = 1
    status.Text = state and "ON" or "OFF"
    status.TextColor3 = state and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(150, 150, 160)
    status.TextSize = 12
    status.Font = Enum.Font.GothamBold
    status.Parent = btn

    btn.MouseButton1Click:Connect(function()
        state = not state
        status.Text = state and "ON" or "OFF"
        status.TextColor3 = state and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(150, 150, 160)
        btn.BackgroundColor3 = state and Color3.fromRGB(30, 70, 45) or Color3.fromRGB(25, 28, 38)
        stroke.Color = state and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(40, 45, 60)
        callback(state)
    end)
    return btn
end

-- 7 Exact Main Feature Toggles
createToggle("1. Auto Daily & Weekly Quests", AutoQuestsEnabled, function(val)
    AutoQuestsEnabled = val
end)

createToggle("2. Auto Talent & Class Progression", AutoTalentRerollEnabled, function(val)
    AutoTalentRerollEnabled = val
end)

createToggle("3. Cultist Wave Defense & Kill Aura", AutoWaveCombatEnabled, function(val)
    AutoWaveCombatEnabled = val
end)

createToggle("4. Auto Tools & Fire Upgrades", AutoToolUpgradeEnabled, function(val)
    AutoToolUpgradeEnabled = val
end)

createToggle("5. Auto Collect Items, Pets & Candies", AutoCollectLootEnabled, function(val)
    AutoCollectLootEnabled = val
end)

createToggle("6. In-Game Shops & Supply Crates", AutoClaimRewardsEnabled, function(val)
    AutoClaimRewardsEnabled = val
end)

createToggle("7. Skip Cutscenes & Instant Dialogue", SkipCutscenesEnabled, function(val)
    SkipCutscenesEnabled = val
end)

-- Extra Movement Utilities
createToggle("Speed Boost (32)", WalkSpeedBoost, function(val)
    WalkSpeedBoost = val
    local hum = getHum()
    if hum then hum.WalkSpeed = val and SpeedValue or 16 end
end)

createToggle("Infinite Jump", InfJumpEnabled, function(val)
    InfJumpEnabled = val
end)

createToggle("Noclip Mode", NoclipEnabled, function(val)
    NoclipEnabled = val
end)

-- Footer
local Footer = Instance.new("Frame")
Footer.Size = UDim2.new(1, 0, 0, 45)
Footer.Position = UDim2.new(0, 0, 1, -45)
Footer.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
Footer.BorderSizePixel = 0
Footer.Parent = MainFrame

local FooterCorner = Instance.new("UICorner")
FooterCorner.CornerRadius = UDim.new(0, 10)
FooterCorner.Parent = Footer

local FooterTitle = Instance.new("TextLabel")
FooterTitle.Size = UDim2.new(1, 0, 0, 18)
FooterTitle.Position = UDim2.new(0, 0, 0, 6)
FooterTitle.BackgroundTransparency = 1
FooterTitle.Text = "ULTRA SCRIPT HUB"
FooterTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
FooterTitle.TextSize = 13
FooterTitle.Font = Enum.Font.GothamBold
FooterTitle.Parent = Footer

local FooterSub = Instance.new("TextLabel")
FooterSub.Size = UDim2.new(1, 0, 0, 14)
FooterSub.Position = UDim2.new(0, 0, 0, 24)
FooterSub.BackgroundTransparency = 1
FooterSub.Text = "Made by Junejo"
FooterSub.TextColor3 = Color3.fromRGB(130, 140, 160)
FooterSub.TextSize = 11
FooterSub.Font = Enum.Font.Gotham
FooterSub.Parent = Footer

print("[ULTRA SCRIPT HUB] 99 Nights in the Forest loaded successfully!")
