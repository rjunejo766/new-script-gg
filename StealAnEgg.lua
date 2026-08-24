--==============================================================--
--  ULTRA SCRIPT HUB - Made by Junejo
--  Game: Steal an Egg (Roblox)
--  Version: 4.0 (Anti-Cheat Proof Edition)
--==============================================================--

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local PathfindingService = game:GetService("PathfindingService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

--==============================================================--
--  Feature States (Exact 4 Features)
--==============================================================--
local AutoStealEgg = false
local GodMode = false
local InstantStealEgg = false
local EggPrediction = false

-- Base / Incubator Location
local SavedBaseCFrame = nil

-- Helper Functions
local function getRoot()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
end

local function getHum()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end

-- Save Base CFrame on Spawn
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
end)

--==============================================================--
--  GUI CREATION (Pixel-Perfect ULTRA SCRIPT HUB Design)
--==============================================================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraScriptHub_StealAnEgg"
ScreenGui.ResetOnSpawn = false

local parentGui = nil
if gethui then pcall(function() parentGui = gethui() end) end
if not parentGui then parentGui = CoreGui end
if not parentGui then parentGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") end

pcall(function()
    if parentGui and parentGui:FindFirstChild("UltraScriptHub_StealAnEgg") then
        parentGui:FindFirstChild("UltraScriptHub_StealAnEgg"):Destroy()
    end
end)

ScreenGui.Parent = parentGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 255)
MainFrame.Position = UDim2.new(0.5, -160, 0.35, -127)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -50, 0, 35)
HeaderTitle.Position = UDim2.new(0, 16, 0, 10)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "STEAL AN EGG"
HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitle.TextSize = 16
HeaderTitle.Font = Enum.Font.SourceSansBold
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -34, 0, 10)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -32, 0, 135)
Container.Position = UDim2.new(0, 16, 0, 50)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 7)
UIListLayout.Parent = Container

local FooterTitle = Instance.new("TextLabel")
FooterTitle.Size = UDim2.new(1, 0, 0, 22)
FooterTitle.Position = UDim2.new(0, 0, 1, -44)
FooterTitle.BackgroundTransparency = 1
FooterTitle.Text = "ULTRA SCRIPT HUB"
FooterTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
FooterTitle.TextSize = 17
FooterTitle.Font = Enum.Font.SourceSansBold
FooterTitle.Parent = MainFrame

local FooterSub = Instance.new("TextLabel")
FooterSub.Size = UDim2.new(1, 0, 0, 16)
FooterSub.Position = UDim2.new(0, 0, 1, -22)
FooterSub.BackgroundTransparency = 1
FooterSub.Text = "Made by Junejo"
FooterSub.TextColor3 = Color3.fromRGB(150, 150, 150)
FooterSub.TextSize = 13
FooterSub.Font = Enum.Font.SourceSans
FooterSub.Parent = MainFrame

local function CreateToggleRow(name, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 26)
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
--  1. AUTO STEAL EGG (Natural Path & Safe Auto Return)
--==============================================================--
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
                if SavedBaseCFrame and (obj.Position - SavedBaseCFrame.Position).Magnitude <= 100 then
                    return obj.CFrame
                end
            end
        end
    end
    return SavedBaseCFrame or (getRoot() and getRoot().CFrame)
end

local isAutoStealing = false
local function runAutoStealCycle()
    if isAutoStealing then return end
    isAutoStealing = true

    local root = getRoot()
    local hum = getHum()
    if not root or not hum or hum.Health <= 0 then isAutoStealing = false return end

    local baseCFrame = getIncubatorCFrame()
    local targetEgg = nil
    local targetPrompt = nil
    local closestDist = math.huge

    for _, prompt in ipairs(Workspace:GetDescendants()) do
        if not AutoStealEgg then break end
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
        -- Safe Walk to Egg using MoveTo
        hum:MoveTo(targetEgg.Position)
        local arrived = false
        local timeout = tick() + 6
        while not arrived and tick() < timeout and AutoStealEgg do
            if (root.Position - targetEgg.Position).Magnitude <= 10 then
                arrived = true
            end
            task.wait(0.1)
        end

        -- Trigger Prompt
        if targetPrompt then
            pcall(function()
                if fireproximityprompt then
                    fireproximityprompt(targetPrompt, 0)
                else
                    targetPrompt:InputHoldBegin()
                    task.wait(0.05)
                    targetPrompt:InputHoldEnd()
                end
            end)
        end

        task.wait(0.4)

        -- Walk back to base / incubator
        if baseCFrame then
            hum:MoveTo(baseCFrame.Position)
            local backTimeout = tick() + 6
            while (root.Position - baseCFrame.Position).Magnitude > 12 and tick() < backTimeout and AutoStealEgg do
                task.wait(0.1)
            end

            -- Deposit into incubator
            for _, p in ipairs(Workspace:GetDescendants()) do
                if p:IsA("ProximityPrompt") and p.Enabled then
                    local pName = (p.Parent and p.Parent.Name or ""):lower()
                    local act = (p.ActionText or ""):lower()
                    if pName:find("incubator") or pName:find("fuse") or act:find("fuse") or act:find("place") or act:find("hatch") then
                        if (p.Parent.Position - root.Position).Magnitude <= 20 then
                            pcall(function()
                                if fireproximityprompt then fireproximityprompt(p, 0) end
                            end)
                        end
                    end
                end
            end
        end
    end

    task.wait(0.3)
    isAutoStealing = false
end

CreateToggleRow("Auto Steal Egg", function(enabled)
    AutoStealEgg = enabled
    if enabled then
        local root = getRoot()
        if root then SavedBaseCFrame = root.CFrame end
        task.spawn(function()
            while AutoStealEgg do
                pcall(runAutoStealCycle)
                task.wait(0.2)
            end
        end)
    end
end)

--==============================================================--
--  2. GOD MODE (Invincibility & Damage Prevention)
--==============================================================--
local godConnection = nil
CreateToggleRow("God Mode", function(enabled)
    GodMode = enabled
    if enabled then
        local hum = getHum()
        local char = LocalPlayer.Character
        if hum and char then
            pcall(function()
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                if not char:FindFirstChildOfClass("ForceField") then
                    local ff = Instance.new("ForceField")
                    ff.Visible = false
                    ff.Parent = char
                end
            end)
        end

        godConnection = RunService.Stepped:Connect(function()
            if GodMode then
                local h = getHum()
                if h then
                    h.Health = h.MaxHealth
                end
            end
        end)
    else
        if godConnection then
            godConnection:Disconnect()
            godConnection = nil
        end
        local char = LocalPlayer.Character
        if char then
            local ff = char:FindFirstChildOfClass("ForceField")
            if ff then ff:Destroy() end
        end
    end
end)

--==============================================================--
--  3. INSTANT STEAL EGG (0.00s Instant Hold Time Prompt Bypass)
--==============================================================--
CreateToggleRow("Instant Steal Egg", function(enabled)
    InstantStealEgg = enabled
    if enabled then
        task.spawn(function()
            while InstantStealEgg do
                local root = getRoot()
                if root then
                    for _, prompt in ipairs(Workspace:GetDescendants()) do
                        if not InstantStealEgg then break end
                        if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                            local parent = prompt.Parent
                            local pName = (parent and parent.Name or ""):lower()
                            local act = (prompt.ActionText or ""):lower()
                            local objT = (prompt.ObjectText or ""):lower()
                            if pName:find("egg") or act:find("steal") or act:find("grab") or objT:find("egg") then
                                prompt.HoldDuration = 0
                                local part = parent:IsA("BasePart") and parent or (parent and parent:FindFirstChildWhichIsA("BasePart"))
                                if part and (part.Position - root.Position).Magnitude <= (prompt.MaxActivationDistance + 10) then
                                    pcall(function()
                                        if fireproximityprompt then
                                            fireproximityprompt(prompt, 0)
                                        end
                                    end)
                                end
                            end
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)

--==============================================================--
--  4. EGG PREDICTION (ESP & Visual Highlights for All Eggs)
--==============================================================--
local activeESP = {}

local function clearAllESP()
    for _, esp in pairs(activeESP) do
        if esp.Highlight then pcall(function() esp.Highlight:Destroy() end) end
        if esp.Billboard then pcall(function() esp.Billboard:Destroy() end) end
    end
    activeESP = {}
end

local function updateEggPrediction()
    clearAllESP()
    if not EggPrediction then return end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if not EggPrediction then break end
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local name = obj.Name:lower()
            if (name:find("egg") or name:find("nest") or name:find("eggspawn")) and not name:find("incubator") and not name:find("fuse") then
                local part = obj:IsA("BasePart") and obj or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
                if part and not part:IsDescendantOf(LocalPlayer.Character) then
                    -- 1. Highlight / Chams
                    local hl = Instance.new("Highlight")
                    hl.Name = "EggESP_HL"
                    hl.FillColor = Color3.fromRGB(0, 255, 170)
                    hl.FillTransparency = 0.5
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.OutlineTransparency = 0
                    hl.Adornee = obj
                    hl.Parent = obj

                    -- 2. Billboard Text (Name & Distance)
                    local bb = Instance.new("BillboardGui")
                    bb.Name = "EggESP_BB"
                    bb.Adornee = part
                    bb.Size = UDim2.new(0, 140, 0, 40)
                    bb.StudsOffset = Vector3.new(0, 3, 0)
                    bb.AlwaysOnTop = true
                    bb.Parent = part

                    local textLabel = Instance.new("TextLabel")
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.Text = "🥚 " .. obj.Name
                    textLabel.TextColor3 = Color3.fromRGB(0, 255, 170)
                    textLabel.TextStrokeTransparency = 0
                    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    textLabel.TextSize = 14
                    textLabel.Font = Enum.Font.SourceSansBold
                    textLabel.Parent = bb

                    table.insert(activeESP, {Highlight = hl, Billboard = bb, Part = part, Label = textLabel})
                end
            end
        end
    end
end

CreateToggleRow("Egg Prediction", function(enabled)
    EggPrediction = enabled
    if enabled then
        updateEggPrediction()
        task.spawn(function()
            while EggPrediction do
                local root = getRoot()
                for _, esp in ipairs(activeESP) do
                    if esp.Part and esp.Label and root then
                        local dist = math.floor((esp.Part.Position - root.Position).Magnitude)
                        esp.Label.Text = "🥚 " .. esp.Part.Name .. " [" .. tostring(dist) .. "m]"
                    end
                end
                task.wait(0.5)
            end
            clearAllESP()
        end)
    else
        clearAllESP()
    end
end)
