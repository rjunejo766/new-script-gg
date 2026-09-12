--==============================================================--
--  ULTRA SCRIPT HUB - Made by Junejo
--  Game: Grow Beanstalk To Steal An Egg (Roblox)
--  Version: 8.0 (Guaranteed UI Visibility & Centered Layout)
--==============================================================--

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    repeat task.wait() LocalPlayer = Players.LocalPlayer until LocalPlayer
end

-- Anti-AFK
pcall(function()
    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end)
    end)
end)

--==============================================================--
--  100% GUARANTEED SCREEN GUI CREATION
--==============================================================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraScriptHub_StealAnEgg"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999
ScreenGui.IgnoreGuiInset = true

-- Multi-Tier Safe Parenting (Works everywhere: Delta, Fluxus, Codex, Arceus, Solara, Studio)
local parentTarget = nil
if gethui then
    pcall(function() parentTarget = gethui() end)
end

if not parentTarget then
    pcall(function()
        parentTarget = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 4)
    end)
end

if not parentTarget then
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
        parentTarget = CoreGui
    end)
end

-- Remove older UI copies
pcall(function()
    local places = {parentTarget, CoreGui, LocalPlayer:FindFirstChildOfClass("PlayerGui")}
    for _, pl in ipairs(places) do
        if pl then
            local old = pl:FindFirstChild("UltraScriptHub_StealAnEgg")
            if old and old ~= ScreenGui then old:Destroy() end
        end
    end
end)

ScreenGui.Parent = parentTarget or LocalPlayer:FindFirstChildOfClass("PlayerGui") or CoreGui

--==============================================================--
--  MAIN UI FRAME (AnchorPoint Centered - 100% Visible on PC & Mobile)
--==============================================================--
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 330, 0, 370)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(45, 48, 60)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- Floating Toggle Button (To reopen if minimized)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenHubButton"
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 15, 0.5, -22)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
OpenBtn.BorderSizePixel = 0
OpenBtn.Text = "🥚"
OpenBtn.TextSize = 22
OpenBtn.Visible = false
OpenBtn.Active = true
OpenBtn.Draggable = true
OpenBtn.Parent = ScreenGui

local OpenBtnCorner = Instance.new("UICorner")
OpenBtnCorner.CornerRadius = UDim.new(0, 10)
OpenBtnCorner.Parent = OpenBtn

local OpenBtnStroke = Instance.new("UIStroke")
OpenBtnStroke.Color = Color3.fromRGB(0, 170, 255)
OpenBtnStroke.Thickness = 1.5
OpenBtnStroke.Parent = OpenBtn

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- Header Bar
local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -75, 0, 35)
HeaderTitle.Position = UDim2.new(0, 16, 0, 8)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "GROW BEANSTALK & STEAL EGG"
HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitle.TextSize = 13
HeaderTitle.Font = Enum.Font.SourceSansBold
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.Parent = MainFrame

-- Minimize Button (-)
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 26, 0, 26)
MinBtn.Position = UDim2.new(1, -58, 0, 12)
MinBtn.BackgroundColor3 = Color3.fromRGB(25, 27, 35)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinBtn.TextSize = 16
MinBtn.Font = Enum.Font.SourceSansBold
MinBtn.Parent = MainFrame

local MinBtnCorner = Instance.new("UICorner")
MinBtnCorner.CornerRadius = UDim.new(0, 5)
MinBtnCorner.Parent = MinBtn

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

-- Close Button (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -28, 0, 12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 20, 25)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Parent = MainFrame

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 5)
CloseBtnCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Container for Toggles
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -32, 0, 245)
Container.Position = UDim2.new(0, 16, 0, 48)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 7)
UIListLayout.Parent = Container

-- Footer Branding
local FooterTitle = Instance.new("TextLabel")
FooterTitle.Size = UDim2.new(1, 0, 0, 20)
FooterTitle.Position = UDim2.new(0, 0, 1, -44)
FooterTitle.BackgroundTransparency = 1
FooterTitle.Text = "ULTRA SCRIPT HUB"
FooterTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
FooterTitle.TextSize = 16
FooterTitle.Font = Enum.Font.SourceSansBold
FooterTitle.Parent = MainFrame

local FooterSub = Instance.new("TextLabel")
FooterSub.Size = UDim2.new(1, 0, 0, 16)
FooterSub.Position = UDim2.new(0, 0, 1, -22)
FooterSub.BackgroundTransparency = 1
FooterSub.Text = "Made by Junejo"
FooterSub.TextColor3 = Color3.fromRGB(150, 150, 150)
FooterSub.TextSize = 12
FooterSub.Font = Enum.Font.SourceSans
FooterSub.Parent = MainFrame

-- Helper to Create Toggle Rows
local function CreateToggleRow(name, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 27)
    Row.BackgroundTransparency = 1
    Row.Parent = Container

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -35, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 220, 225)
    Label.TextSize = 13
    Label.Font = Enum.Font.SourceSansBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local Checkbox = Instance.new("TextButton")
    Checkbox.Size = UDim2.new(0, 21, 0, 21)
    Checkbox.Position = UDim2.new(1, -23, 0.5, -10)
    Checkbox.BackgroundColor3 = Color3.fromRGB(25, 27, 35)
    Checkbox.BorderColor3 = Color3.fromRGB(45, 48, 60)
    Checkbox.Text = ""
    Checkbox.AutoButtonColor = false
    Checkbox.Parent = Row

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 4)
    BoxCorner.Parent = Checkbox

    local CheckIcon = Instance.new("Frame")
    CheckIcon.Size = UDim2.new(1, -6, 1, -6)
    CheckIcon.Position = UDim2.new(0, 3, 0, 3)
    CheckIcon.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    CheckIcon.Visible = false
    CheckIcon.Parent = Checkbox

    local CheckIconCorner = Instance.new("UICorner")
    CheckIconCorner.CornerRadius = UDim.new(0, 2)
    CheckIconCorner.Parent = CheckIcon

    local toggled = false
    Checkbox.MouseButton1Click:Connect(function()
        toggled = not toggled
        CheckIcon.Visible = toggled
        if toggled then
            Checkbox.BackgroundColor3 = Color3.fromRGB(30, 35, 48)
            Checkbox.BorderColor3 = Color3.fromRGB(0, 170, 255)
        else
            Checkbox.BackgroundColor3 = Color3.fromRGB(25, 27, 35)
            Checkbox.BorderColor3 = Color3.fromRGB(45, 48, 60)
        end
        pcall(callback, toggled)
    end)
    return Row
end

--==============================================================--
--  FEATURE VARIABLES & CORE LOGIC
--==============================================================--
local AutoStealAndDeposit = false
local AutoGrowBeanstalk = false
local EggESPEnabled = false
local AutoHatchIncubate = false
local AutoCollectDrops = false
local NoclipEnabled = false
local MovementBoost = false

local NormalSpeed = 16
local BoostSpeed = 60
local SavedBaseCFrame = nil

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

local function isHoldingEgg()
    local char = LocalPlayer.Character
    if not char then return false end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") or child.Name:lower():find("egg") then
            return true
        end
    end
    return false
end

task.spawn(function()
    local root = getRoot()
    if root then SavedBaseCFrame = root.CFrame end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    local root = getRoot()
    if root and not SavedBaseCFrame then
        SavedBaseCFrame = root.CFrame
    end
    local hum = getHum()
    if hum and MovementBoost then
        hum.WalkSpeed = BoostSpeed
    end
end)

local function fireGameRemote(remoteName, ...)
    local remote = ReplicatedStorage:FindFirstChild(remoteName, true)
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

local function triggerPrompt(prompt)
    if not prompt or not prompt.Parent then return end
    pcall(function()
        prompt.HoldDuration = 0
        if fireproximityprompt then
            fireproximityprompt(prompt, 0)
        elseif prompt.InputHoldBegin and prompt.InputHoldEnd then
            prompt:InputHoldBegin()
            task.wait(0.02)
            prompt:InputHoldEnd()
        end
    end)
end

local function safeTouch(part1, part2)
    if not part1 or not part2 then return end
    pcall(function()
        if firetouchinterest then
            firetouchinterest(part1, part2, 0)
            task.wait(0.01)
            firetouchinterest(part1, part2, 1)
        end
    end)
end

local function getIncubatorCFrame()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("Folder") then
            local owner = obj:FindFirstChild("Owner") or obj:FindFirstChild("Player") or obj:FindFirstChild("UserId")
            if owner and (tostring(owner.Value) == LocalPlayer.Name or tostring(owner.Value) == tostring(LocalPlayer.UserId)) then
                local inc = obj:FindFirstChild("Incubator", true) or obj:FindFirstChild("Fuse", true) or obj:FindFirstChild("Base", true)
                if inc and inc:IsA("BasePart") then return inc.CFrame end
            end
        end
    end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name:find("incubator") or name:find("fuse") or name:find("egg machine") then
                if SavedBaseCFrame and (obj.Position - SavedBaseCFrame.Position).Magnitude <= 120 then
                    return obj.CFrame
                end
            end
        end
    end
    return SavedBaseCFrame or (getRoot() and getRoot().CFrame)
end

-- 1. Auto Steal & Deposit Egg
local isStealingCycle = false
local function returnAndDepositAtBase(baseCFrame)
    local root = getRoot()
    local hum = getHum()
    if not root or not hum or not baseCFrame then return end

    hum:MoveTo(baseCFrame.Position)
    local timeout = tick() + 7
    while AutoStealAndDeposit and tick() < timeout and (root.Position - baseCFrame.Position).Magnitude > 8 do
        task.wait(0.1)
    end

    for _, p in ipairs(Workspace:GetDescendants()) do
        if p:IsA("ProximityPrompt") and p.Enabled then
            local pName = (p.Parent and p.Parent.Name or ""):lower()
            local act = (p.ActionText or ""):lower()
            if pName:find("incubator") or pName:find("fuse") or act:find("fuse") or act:find("place") or act:find("hatch") or act:find("deposit") then
                if (p.Parent.Position - root.Position).Magnitude <= 25 then
                    triggerPrompt(p)
                end
            end
        end
    end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name:find("incubator") or name:find("fuse") or name:find("deposit") then
                if (obj.Position - root.Position).Magnitude <= 20 then
                    safeTouch(root, obj)
                end
            end
        end
    end
end

local function runAutoStealCycle()
    if isStealingCycle then return end
    isStealingCycle = true

    local root = getRoot()
    local hum = getHum()
    if not root or not hum or hum.Health <= 0 then
        isStealingCycle = false
        return
    end

    local baseCFrame = getIncubatorCFrame()

    if isHoldingEgg() then
        returnAndDepositAtBase(baseCFrame)
        task.wait(0.3)
        isStealingCycle = false
        return
    end

    local targetEgg = nil
    local targetPrompt = nil
    local closestDist = math.huge

    for _, prompt in ipairs(Workspace:GetDescendants()) do
        if not AutoStealAndDeposit then break end
        if prompt:IsA("ProximityPrompt") and prompt.Enabled then
            local parent = prompt.Parent
            local pName = (parent and parent.Name or ""):lower()
            local act = (prompt.ActionText or ""):lower()
            local objT = (prompt.ObjectText or ""):lower()

            if pName:find("egg") or act:find("steal") or act:find("grab") or act:find("take") or objT:find("egg") then
                local part = parent:IsA("BasePart") and parent or (parent and parent:FindFirstChildWhichIsA("BasePart"))
                if part and baseCFrame and (part.Position - baseCFrame.Position).Magnitude > 25 then
                    local d = (part.Position - root.Position).Magnitude
                    if d < closestDist then
                        closestDist = d
                        targetEgg = part
                        targetPrompt = prompt
                    end
                end
            end
        end
    end

    if targetEgg then
        hum:MoveTo(targetEgg.Position)
        local timeout = tick() + 7
        while AutoStealAndDeposit and tick() < timeout and (root.Position - targetEgg.Position).Magnitude > 8 do
            task.wait(0.1)
        end

        if targetPrompt then
            triggerPrompt(targetPrompt)
        end
        safeTouch(root, targetEgg)
        task.wait(0.3)

        returnAndDepositAtBase(baseCFrame)
    end

    task.wait(0.3)
    isStealingCycle = false
end

task.spawn(function()
    while true do
        task.wait(0.2)
        if AutoStealAndDeposit then
            pcall(runAutoStealCycle)
        end
    end
end)

-- 2. Auto Grow Beanstalk
task.spawn(function()
    while true do
        task.wait(0.5)
        if AutoGrowBeanstalk then
            pcall(function()
                fireGameRemote("WaterBeanstalk")
                fireGameRemote("UpgradeBeanstalk")
                fireGameRemote("ApplyFertilizer")
                fireGameRemote("ClaimHeightReward")
                fireGameRemote("GrowPlant")

                local root = getRoot()
                if root then
                    for _, p in ipairs(Workspace:GetDescendants()) do
                        if p:IsA("ProximityPrompt") and p.Enabled then
                            local act = (p.ActionText or ""):lower()
                            local name = (p.Parent and p.Parent.Name or ""):lower()
                            if act:find("water") or act:find("grow") or act:find("fertiliz") or act:find("upgrade") or name:find("beanstalk") or name:find("plant") or name:find("sprout") then
                                local part = p.Parent:IsA("BasePart") and p.Parent or (p.Parent and p.Parent:FindFirstChildWhichIsA("BasePart"))
                                if part and (part.Position - root.Position).Magnitude <= 30 then
                                    triggerPrompt(p)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- 3. Egg & Beanstalk ESP
local activeESP = {}
local function clearAllESP()
    for _, esp in pairs(activeESP) do
        if esp.Highlight then pcall(function() esp.Highlight:Destroy() end) end
        if esp.Billboard then pcall(function() esp.Billboard:Destroy() end) end
    end
    activeESP = {}
end

local function refreshESP()
    clearAllESP()
    if not EggESPEnabled then return end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if not EggESPEnabled then break end
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local name = obj.Name:lower()
            if (name:find("egg") or name:find("nest") or name:find("beanstalk") or name:find("incubator")) and not obj:IsDescendantOf(LocalPlayer.Character) then
                local part = obj:IsA("BasePart") and obj or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
                if part then
                    local isEgg = name:find("egg")
                    local isBeanstalk = name:find("beanstalk")
                    local col = isEgg and Color3.fromRGB(0, 255, 170) or (isBeanstalk and Color3.fromRGB(85, 255, 0) or Color3.fromRGB(255, 170, 0))

                    local hl = Instance.new("Highlight")
                    hl.Name = "ESP_HL"
                    hl.FillColor = col
                    hl.FillTransparency = 0.5
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.OutlineTransparency = 0
                    hl.Adornee = obj
                    hl.Parent = obj

                    local bb = Instance.new("BillboardGui")
                    bb.Name = "ESP_BB"
                    bb.Adornee = part
                    bb.Size = UDim2.new(0, 140, 0, 40)
                    bb.StudsOffset = Vector3.new(0, 3, 0)
                    bb.AlwaysOnTop = true
                    bb.Parent = part

                    local textLabel = Instance.new("TextLabel")
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundTransparency = 1
                    local prefix = isEgg and "🥚 " or (isBeanstalk and "🌱 " or "📦 ")
                    textLabel.Text = prefix .. obj.Name
                    textLabel.TextColor3 = col
                    textLabel.TextStrokeTransparency = 0
                    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    textLabel.TextSize = 13
                    textLabel.Font = Enum.Font.SourceSansBold
                    textLabel.Parent = bb

                    table.insert(activeESP, {Highlight = hl, Billboard = bb, Part = part, Label = textLabel, Name = obj.Name, Prefix = prefix})
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        task.wait(1)
        if EggESPEnabled then
            local root = getRoot()
            for _, esp in ipairs(activeESP) do
                if esp.Part and esp.Label and root then
                    local dist = math.floor((esp.Part.Position - root.Position).Magnitude)
                    esp.Label.Text = esp.Prefix .. esp.Name .. " [" .. tostring(dist) .. "m]"
                end
            end
        end
    end
end)

-- 4. Auto Hatch & Incubate
task.spawn(function()
    while true do
        task.wait(0.8)
        if AutoHatchIncubate then
            pcall(function()
                fireGameRemote("HatchEgg")
                fireGameRemote("OpenEgg")
                fireGameRemote("IncubateEgg")
                fireGameRemote("ClaimHatchedPet")
                fireGameRemote("FuseEggs")

                local root = getRoot()
                if root then
                    for _, p in ipairs(Workspace:GetDescendants()) do
                        if p:IsA("ProximityPrompt") and p.Enabled then
                            local act = (p.ActionText or ""):lower()
                            local name = (p.Parent and p.Parent.Name or ""):lower()
                            if act:find("hatch") or act:find("open") or act:find("claim") or name:find("hatch") or name:find("incubator") then
                                if (p.Parent.Position - root.Position).Magnitude <= 25 then
                                    triggerPrompt(p)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- 5. Auto Collect Drops & Coins
task.spawn(function()
    while true do
        task.wait(0.4)
        if AutoCollectDrops then
            pcall(function()
                local root = getRoot()
                if not root then return end
                for _, item in ipairs(Workspace:GetDescendants()) do
                    if item:IsA("BasePart") then
                        local n = item.Name:lower()
                        if n:find("coin") or n:find("gem") or n:find("drop") or n:find("star") or n:find("seed") or n:find("fertilizer") then
                            if (item.Position - root.Position).Magnitude <= 60 then
                                item.CFrame = root.CFrame
                                safeTouch(root, item)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- 6. NoClip
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
end)

-- 7. Movement Boost & Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if MovementBoost then
        local hum = getHum()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.3)
        if MovementBoost then
            local hum = getHum()
            if hum and hum.WalkSpeed ~= BoostSpeed then
                hum.WalkSpeed = BoostSpeed
            end
        end
    end
end)

-- Register 7 Toggles
CreateToggleRow("Auto Steal & Deposit Egg", function(enabled)
    AutoStealAndDeposit = enabled
    if enabled then
        local root = getRoot()
        if root then SavedBaseCFrame = root.CFrame end
    end
end)

CreateToggleRow("Auto Grow Beanstalk", function(enabled)
    AutoGrowBeanstalk = enabled
end)

CreateToggleRow("Egg & Beanstalk ESP", function(enabled)
    EggESPEnabled = enabled
    if enabled then refreshESP() else clearAllESP() end
end)

CreateToggleRow("Auto Hatch & Incubate", function(enabled)
    AutoHatchIncubate = enabled
end)

CreateToggleRow("Auto Collect Drops & Coins", function(enabled)
    AutoCollectDrops = enabled
end)

CreateToggleRow("NoClip (Pass Walls)", function(enabled)
    NoclipEnabled = enabled
end)

CreateToggleRow("Speed Boost & Inf Jump", function(enabled)
    MovementBoost = enabled
    local hum = getHum()
    if hum then
        hum.WalkSpeed = enabled and BoostSpeed or NormalSpeed
    end
end)
