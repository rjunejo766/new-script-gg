--==============================================================--
--  ULTRA SCRIPT HUB - Made by Junejo
--  Game: Grow Beanstalk To Steal An Egg (Roblox)
--  Version: 9.0 (Guaranteed Instant UI & 7 Best Features)
--==============================================================--

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    repeat task.wait() LocalPlayer = Players.LocalPlayer until LocalPlayer
end

-- Notification on Execution
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "ULTRA SCRIPT HUB",
        Text = "Grow Beanstalk & Steal Egg v9.0 Loaded!",
        Duration = 4
    })
end)

-- Anti-AFK Setup
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
--  GUI CREATION (100% Guaranteed Visible on ALL Devices/Executors)
--==============================================================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraScriptHub_StealAnEgg"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999
ScreenGui.IgnoreGuiInset = true
ScreenGui.Enabled = true

-- Find Safe Parent (PlayerGui + gethui fallback)
local targetParent = nil
pcall(function()
    if gethui then
        targetParent = gethui()
    end
end)
if not targetParent then
    pcall(function()
        targetParent = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
    end)
end
if not targetParent then
    pcall(function()
        targetParent = CoreGui
    end)
end

-- Clean old instances
pcall(function()
    local containers = {targetParent, CoreGui, LocalPlayer:FindFirstChildOfClass("PlayerGui")}
    for _, c in ipairs(containers) do
        if c then
            for _, child in ipairs(c:GetChildren()) do
                if child.Name == "UltraScriptHub_StealAnEgg" and child ~= ScreenGui then
                    child:Destroy()
                end
            end
        end
    end
end)

ScreenGui.Parent = targetParent or LocalPlayer:WaitForChild("PlayerGui")

-- Floating Open/Close Button (Always on Screen)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleUI_Btn"
ToggleButton.Size = UDim2.new(0, 42, 0, 42)
ToggleButton.Position = UDim2.new(0, 15, 0.5, -21)
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
ToggleButton.BorderColor3 = Color3.fromRGB(0, 170, 255)
ToggleButton.BorderSizePixel = 1
ToggleButton.Text = "🥚"
ToggleButton.TextSize = 20
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.ZIndex = 25
ToggleButton.Parent = ScreenGui

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 10)
BtnCorner.Parent = ToggleButton

-- Main UI Frame (Centered with AnchorPoint)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Size = UDim2.new(0, 320, 0, 335)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.ZIndex = 10
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 48, 60)
MainStroke.Thickness = 1.2
MainStroke.Parent = MainFrame

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Header Bar
local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -70, 0, 35)
HeaderTitle.Position = UDim2.new(0, 16, 0, 8)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "STEAL AN EGG & BEANSTALK"
HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitle.TextSize = 13
HeaderTitle.Font = Enum.Font.SourceSansBold
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.ZIndex = 11
HeaderTitle.Parent = MainFrame

-- Minimize Button (-)
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 24, 0, 24)
MinBtn.Position = UDim2.new(1, -54, 0, 12)
MinBtn.BackgroundColor3 = Color3.fromRGB(25, 27, 35)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinBtn.TextSize = 16
MinBtn.Font = Enum.Font.SourceSansBold
MinBtn.ZIndex = 11
MinBtn.Parent = MainFrame

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 5)
MinCorner.Parent = MinBtn

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Close Button (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -27, 0, 12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 20, 25)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.ZIndex = 11
CloseBtn.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Container for Feature Toggles
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -28, 0, 220)
Container.Position = UDim2.new(0, 14, 0, 44)
Container.BackgroundTransparency = 1
Container.ZIndex = 11
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = Container

-- Footer
local FooterTitle = Instance.new("TextLabel")
FooterTitle.Size = UDim2.new(1, 0, 0, 18)
FooterTitle.Position = UDim2.new(0, 0, 1, -40)
FooterTitle.BackgroundTransparency = 1
FooterTitle.Text = "ULTRA SCRIPT HUB"
FooterTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
FooterTitle.TextSize = 15
FooterTitle.Font = Enum.Font.SourceSansBold
FooterTitle.ZIndex = 11
FooterTitle.Parent = MainFrame

local FooterSub = Instance.new("TextLabel")
FooterSub.Size = UDim2.new(1, 0, 0, 14)
FooterSub.Position = UDim2.new(0, 0, 1, -20)
FooterSub.BackgroundTransparency = 1
FooterSub.Text = "Made by Junejo"
FooterSub.TextColor3 = Color3.fromRGB(150, 150, 150)
FooterSub.TextSize = 11
FooterSub.Font = Enum.Font.SourceSans
FooterSub.ZIndex = 11
FooterSub.Parent = MainFrame

-- Helper to Create Toggle Rows
local function CreateToggleRow(name, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 25)
    Row.BackgroundTransparency = 1
    Row.ZIndex = 12
    Row.Parent = Container

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -35, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 220, 225)
    Label.TextSize = 12
    Label.Font = Enum.Font.SourceSansBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 13
    Label.Parent = Row

    local Checkbox = Instance.new("TextButton")
    Checkbox.Size = UDim2.new(0, 20, 0, 20)
    Checkbox.Position = UDim2.new(1, -22, 0.5, -10)
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
--  FEATURE STATES & VARIABLES
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

--==============================================================--
--  REGISTER ALL 7 TOGGLES
--==============================================================--
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
