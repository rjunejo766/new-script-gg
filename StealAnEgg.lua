--==============================================================--
--  ULTRA SCRIPT HUB - Made by Junejo
--  Game: Steal an Egg (Roblox)
--  Version: 3.5 (Anti-Kick & BAC Anti-Cheat Bypass Edition)
--==============================================================--

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

--==============================================================--
--  1. ANTI-KICK & CLIENT ANTI-CHEAT BYPASS
--==============================================================--
pcall(function()
    if hookmetamethod then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if not checkcaller() and (tostring(method):lower() == "kick" or tostring(method):lower() == "ban") then
                return nil
            end
            return oldNamecall(self, ...)
        end))
    end
end)

pcall(function()
    if hookfunction and LocalPlayer.Kick then
        hookfunction(LocalPlayer.Kick, newcclosure(function(...)
            return nil
        end))
    end
end)

local VirtualUser = nil
pcall(function() VirtualUser = game:GetService("VirtualUser") end)
local VirtualInputManager = nil
pcall(function() VirtualInputManager = game:GetService("VirtualInputManager") end)

-- Feature Toggle Variables (Exact 4 Features)
local AutoGrabEggs = false
local AutoTrainSpeed = false
local AutoCollectCash = false
local AutoRebirth = false

-- Base / Incubator Position Memory
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

-- Safe Smooth Movement (Bypasses BAC-1514 Server Teleport Checks)
local function safeMoveTo(targetCFrame, speed)
    local root = getRoot()
    local hum = getHum()
    if not root or not hum or hum.Health <= 0 then return false end
    
    speed = speed or 85
    local dist = (root.Position - targetCFrame.Position).Magnitude
    if dist <= 4 then return true end

    local travelTime = math.clamp(dist / speed, 0.2, 1.8)
    local tweenInfo = TweenInfo.new(travelTime, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame + Vector3.new(0, 2, 0)})
    
    tween:Play()
    tween.Completed:Wait()
    return true
end

-- Safe Proximity Prompt Trigger (Without breaking prompt properties)
local function triggerPrompt(prompt)
    if not prompt or not prompt.Parent then return end
    pcall(function()
        if fireproximityprompt then
            fireproximityprompt(prompt, 0)
        elseif prompt.InputHoldBegin and prompt.InputHoldEnd then
            prompt:InputHoldBegin()
            task.wait(0.02)
            prompt:InputHoldEnd()
        end
    end)
end

-- Safe Touch Simulation
local function safeTouch(part1, part2)
    if not part1 or not part2 then return end
    pcall(function()
        if firetouchinterest then
            firetouchinterest(part1, part2, 0)
            task.wait(0.02)
            firetouchinterest(part1, part2, 1)
        end
    end)
end

-- Screen Click Simulator for Tap/Train
local function simulateClick()
    pcall(function()
        if VirtualUser then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(999, 999))
        elseif VirtualInputManager then
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            task.wait(0.01)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end
    end)
end

-- Smart Base / Incubator Finder
local function getBaseLocation()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("Folder") then
            local ownerVal = obj:FindFirstChild("Owner") or obj:FindFirstChild("Player") or obj:FindFirstChild("UserId")
            if ownerVal and (tostring(ownerVal.Value) == LocalPlayer.Name or tostring(ownerVal.Value) == tostring(LocalPlayer.UserId)) then
                local inc = obj:FindFirstChild("Incubator", true) or obj:FindFirstChild("Fuse", true) or obj:FindFirstChild("Base", true) or obj:FindFirstChild("Nest", true)
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
--  1. AUTO GRAB EGGS (Safe Smooth Steal & Return to Incubator)
--==============================================================--
local isStealing = false

local function performEggStealCycle()
    if isStealing then return end
    isStealing = true

    local root = getRoot()
    local hum = getHum()
    if not root or not hum or hum.Health <= 0 then
        isStealing = false
        return
    end

    local baseCFrame = getBaseLocation()
    if not baseCFrame then
        baseCFrame = root.CFrame
        SavedBaseCFrame = baseCFrame
    end

    local candidateEggs = {}

    -- Scan Proximity Prompts on eggs
    for _, prompt in ipairs(Workspace:GetDescendants()) do
        if not AutoGrabEggs then break end
        if prompt:IsA("ProximityPrompt") and prompt.Enabled then
            local parent = prompt.Parent
            local pName = (parent and parent.Name or ""):lower()
            local actText = (prompt.ActionText or ""):lower()
            local objText = (prompt.ObjectText or ""):lower()

            if pName:find("egg") or actText:find("steal") or actText:find("grab") or actText:find("take") or objText:find("egg") then
                local part = parent:IsA("BasePart") and parent or (parent and parent:FindFirstChildWhichIsA("BasePart"))
                if part and (part.Position - baseCFrame.Position).Magnitude > 25 then
                    table.insert(candidateEggs, {part = part, prompt = prompt})
                end
            end
        end
    end

    if #candidateEggs == 0 then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if not AutoGrabEggs then break end
            if obj:IsA("BasePart") and not obj:IsDescendantOf(LocalPlayer.Character) then
                local name = obj.Name:lower()
                if (name:find("egg") or name:find("nest") or name:find("eggspawn")) and not name:find("incubator") and not name:find("fuse") then
                    if (obj.Position - baseCFrame.Position).Magnitude > 25 then
                        table.insert(candidateEggs, {part = obj, prompt = nil})
                    end
                end
            end
        end
    end

    if #candidateEggs > 0 then
        local target = candidateEggs[1]
        local eggPart = target.part
        local eggPrompt = target.prompt

        -- 1. Smoothly Travel to Egg (Safe from BAC Anti-Cheat)
        safeMoveTo(eggPart.CFrame, 90)
        task.wait(0.2)

        -- 2. Trigger Grab
        if eggPrompt then
            triggerPrompt(eggPrompt)
        end
        safeTouch(root, eggPart)

        task.wait(0.3)

        -- 3. Smoothly Return to Base / Incubator
        if baseCFrame then
            safeMoveTo(baseCFrame, 90)
            task.wait(0.25)

            -- 4. Trigger Incubator Prompts
            for _, prompt in ipairs(Workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                    local pName = (prompt.Parent and prompt.Parent.Name or ""):lower()
                    local act = (prompt.ActionText or ""):lower()
                    local objT = (prompt.ObjectText or ""):lower()
                    if pName:find("incubator") or pName:find("fuse") or pName:find("nest") or act:find("place") 
                       or act:find("deposit") or act:find("fuse") or act:find("hatch") or act:find("incubate") 
                       or objT:find("incubator") or objT:find("fuse") then
                        local pPart = prompt.Parent:IsA("BasePart") and prompt.Parent or prompt.Parent:FindFirstChildWhichIsA("BasePart")
                        if pPart and (pPart.Position - root.Position).Magnitude <= 30 then
                            triggerPrompt(prompt)
                        end
                    end
                end
            end
        end
    end

    task.wait(0.3)
    isStealing = false
end

CreateToggleRow("Auto Grab Eggs", function(enabled)
    AutoGrabEggs = enabled
    if enabled then
        local root = getRoot()
        if root then
            SavedBaseCFrame = root.CFrame
        end
        task.spawn(function()
            while AutoGrabEggs do
                pcall(performEggStealCycle)
                task.wait(0.2)
            end
        end)
    end
end)

--==============================================================--
--  2. AUTO TRAIN SPEED
--==============================================================--
local function runAutoTrain()
    local root = getRoot()
    if root then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if not AutoTrainSpeed then break end
            if obj:IsA("BasePart") then
                local name = obj.Name:lower()
                if (name:find("treadmill") or name:find("train") or name:find("speedpad") or name:find("speed_pad") or name:find("gym") or name:find("belt")) and (obj.Position - root.Position).Magnitude <= 30 then
                    safeTouch(root, obj)
                end
            elseif obj:IsA("ProximityPrompt") and obj.Enabled then
                local pName = (obj.Parent and obj.Parent.Name or ""):lower()
                local actText = (obj.ActionText or ""):lower()
                if pName:find("treadmill") or pName:find("train") or actText:find("train") or actText:find("speed") then
                    triggerPrompt(obj)
                end
            end
        end
    end

    simulateClick()
end

CreateToggleRow("Auto Train Speed", function(enabled)
    AutoTrainSpeed = enabled
    if enabled then
        task.spawn(function()
            while AutoTrainSpeed do
                pcall(runAutoTrain)
                task.wait(0.2)
            end
        end)
    end
end)

--==============================================================--
--  3. AUTO COLLECT CASH
--==============================================================--
local function runAutoCollectCash()
    local root = getRoot()
    if root then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if not AutoCollectCash then break end
            if obj:IsA("BasePart") then
                local name = obj.Name:lower()
                if (name:find("coin") or name:find("cash") or name:find("money") or name:find("reward") or name:find("income") or name:find("pad") or name:find("collector")) and (obj.Position - root.Position).Magnitude <= 50 then
                    safeTouch(root, obj)
                end
            elseif obj:IsA("ProximityPrompt") and obj.Enabled then
                local pName = (obj.Parent and obj.Parent.Name or ""):lower()
                local actText = (obj.ActionText or ""):lower()
                if pName:find("cash") or pName:find("coin") or pName:find("collect") or pName:find("claim") or actText:find("collect") or actText:find("claim") then
                    triggerPrompt(obj)
                end
            end
        end
    end
end

CreateToggleRow("Auto Collect Cash", function(enabled)
    AutoCollectCash = enabled
    if enabled then
        task.spawn(function()
            while AutoCollectCash do
                pcall(runAutoCollectCash)
                task.wait(0.3)
            end
        end)
    end
end)

--==============================================================--
--  4. AUTO REBIRTH
--==============================================================--
local function runAutoRebirth()
    for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
        if not AutoRebirth then break end
        if r:IsA("RemoteEvent") and (r.Name:lower():find("rebirth") or r.Name:lower():find("prestige") or r.Name:lower():find("ascend")) then
            pcall(function() r:FireServer() end)
        end
    end
end

CreateToggleRow("Auto Rebirth", function(enabled)
    AutoRebirth = enabled
    if enabled then
        task.spawn(function()
            while AutoRebirth do
                pcall(runAutoRebirth)
                task.wait(0.5)
            end
        end)
    end
end)
