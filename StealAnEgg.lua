-- ULTRA SCRIPT HUB - Made by Junejo
-- Game: Steal an Egg (Roblox)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- State Variables
local AutoGrabEggs = false
local AutoTrainSpeed = false
local AutoCollectCash = false
local SpeedBoostEnabled = false
local FlyEnabled = false
local InfJumpEnabled = false

local NormalSpeed = 16
local BoostSpeed = 60
local FlySpeed = 70

-- Saved Base Position
local MyBaseCFrame = nil

-- Helper Functions
local function getChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getRoot()
    local char = LocalPlayer.Character
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
end

local function getHum()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

-- Save spawn/base position at start
task.spawn(function()
    task.wait(1)
    local root = getRoot()
    if root then
        MyBaseCFrame = root.CFrame
    end
end)

-- Respawn Handler
LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum and SpeedBoostEnabled then
        hum.WalkSpeed = BoostSpeed
    end
    task.wait(1)
    if not MyBaseCFrame then
        local root = getRoot()
        if root then
            MyBaseCFrame = root.CFrame
        end
    end
end)

----------------------------------------------------------------
-- GUI Creation (Pixel-Perfect ULTRA SCRIPT HUB Design)
----------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraScriptHub_StealAnEgg"
ScreenGui.ResetOnSpawn = false

-- Safe GUI Parent Resolution
local parentGui = nil
if gethui then
    pcall(function() parentGui = gethui() end)
end

if not parentGui then
    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(ScreenGui)
        end
        parentGui = CoreGui
    end)
end

if not parentGui then
    pcall(function()
        parentGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
    end)
end

-- Clean previous instance
pcall(function()
    if parentGui and parentGui:FindFirstChild("UltraScriptHub_StealAnEgg") then
        parentGui:FindFirstChild("UltraScriptHub_StealAnEgg"):Destroy()
    end
end)

ScreenGui.Parent = parentGui or LocalPlayer:FindFirstChildOfClass("PlayerGui")

-- Main Outer Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 360)
MainFrame.Position = UDim2.new(0.5, -160, 0.3, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Header Title
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

-- Close Button (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -34, 0, 10)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Parent = MainFrame

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Container for Toggles
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -32, 0, 220)
Container.Position = UDim2.new(0, 16, 0, 50)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.Parent = Container

-- Footer Branding
local FooterTitle = Instance.new("TextLabel")
FooterTitle.Size = UDim2.new(1, 0, 0, 22)
FooterTitle.Position = UDim2.new(0, 0, 1, -46)
FooterTitle.BackgroundTransparency = 1
FooterTitle.Text = "ULTRA SCRIPT HUB"
FooterTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
FooterTitle.TextSize = 17
FooterTitle.Font = Enum.Font.SourceSansBold
FooterTitle.Parent = MainFrame

local FooterSub = Instance.new("TextLabel")
FooterSub.Size = UDim2.new(1, 0, 0, 16)
FooterSub.Position = UDim2.new(0, 0, 1, -24)
FooterSub.BackgroundTransparency = 1
FooterSub.Text = "Made by Junejo"
FooterSub.TextColor3 = Color3.fromRGB(150, 150, 150)
FooterSub.TextSize = 13
FooterSub.Font = Enum.Font.SourceSans
FooterSub.Parent = MainFrame

-- Helper Function for Checkbox Row
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

-- Helper Function for Action Button
local function CreateActionButton(name, btnText, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 26)
    Row.BackgroundTransparency = 1
    Row.Parent = Container

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -95, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 220, 225)
    Label.TextSize = 13
    Label.Font = Enum.Font.SourceSansBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 90, 0, 23)
    Button.Position = UDim2.new(1, -90, 0.5, -11)
    Button.BackgroundColor3 = Color3.fromRGB(0, 140, 230)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Text = btnText
    Button.TextSize = 12
    Button.Font = Enum.Font.SourceSansBold
    Button.Parent = Row

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 4)
    BtnCorner.Parent = Button

    Button.MouseButton1Click:Connect(function()
        pcall(callback)
    end)

    return Row
end

----------------------------------------------------------------
-- 1. Auto Grab Eggs (Instant Prompts + Touch Steal)
----------------------------------------------------------------
local function firePrompt(prompt)
    if not prompt or not prompt.Parent then return end
    pcall(function()
        if fireproximityprompt then
            fireproximityprompt(prompt, 0)
        else
            prompt.HoldDuration = 0
            prompt:InputHoldBegin()
            task.wait(0.05)
            prompt:InputHoldEnd()
        end
    end)
end

local function scanAndGrabEggs()
    local root = getRoot()
    if not root then return end

    -- 1. Look for all ProximityPrompts related to eggs or steals
    for _, prompt in ipairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") and prompt.Enabled then
            local parentName = (prompt.Parent and prompt.Parent.Name or ""):lower()
            local objectText = (prompt.ObjectText or ""):lower()
            local actionText = (prompt.ActionText or ""):lower()

            if parentName:find("egg") or objectText:find("egg") or actionText:find("steal") or actionText:find("grab") or actionText:find("take") or actionText:find("pick") then
                -- Check distance
                local promptPart = prompt.Parent
                if promptPart:IsA("BasePart") then
                    local dist = (promptPart.Position - root.Position).Magnitude
                    if dist <= prompt.MaxActivationDistance + 25 then
                        firePrompt(prompt)
                    end
                else
                    firePrompt(prompt)
                end
            end
        end
    end

    -- 2. Look for touchable Egg parts
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("egg") and not obj:IsDescendantOf(LocalPlayer.Character) then
            local dist = (obj.Position - root.Position).Magnitude
            if dist <= 20 and firetouchinterest then
                pcall(function()
                    firetouchinterest(root, obj, 0)
                    task.wait(0.02)
                    firetouchinterest(root, obj, 1)
                end)
            end
        end
    end
end

CreateToggleRow("Auto Grab Eggs", function(enabled)
    AutoGrabEggs = enabled
    if enabled then
        task.spawn(function()
            while AutoGrabEggs do
                pcall(scanAndGrabEggs)
                task.wait(0.2)
            end
        end)
    end
end)

----------------------------------------------------------------
-- 2. Auto Train Speed (Treadmills / Training Pads)
----------------------------------------------------------------
local function runAutoTrain()
    local root = getRoot()
    if not root then return end

    -- Look for treadmills / training pads
    for _, obj in ipairs(workspace:GetDescendants()) do
        if not AutoTrainSpeed then break end
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name:find("treadmill") or name:find("train") or name:find("speedpad") or name:find("speed_pad") then
                pcall(function()
                    if firetouchinterest then
                        firetouchinterest(root, obj, 0)
                        task.wait(0.05)
                        firetouchinterest(root, obj, 1)
                    end
                end)
            end
        end
    end

    -- Also check for training Remotes in ReplicatedStorage
    for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
        if r:IsA("RemoteEvent") or r:IsA("RemoteFunction") then
            local rName = r.Name:lower()
            if rName:find("train") or rName:find("treadmill") or rName:find("addspeed") or rName:find("speedup") then
                pcall(function()
                    if r:IsA("RemoteEvent") then
                        r:FireServer()
                    end
                end)
            end
        end
    end
end

CreateToggleRow("Auto Train Speed", function(enabled)
    AutoTrainSpeed = enabled
    if enabled then
        task.spawn(function()
            while AutoTrainSpeed do
                pcall(runAutoTrain)
                task.wait(0.3)
            end
        end)
    end
end)

----------------------------------------------------------------
-- 3. Auto Collect Cash / Rewards
----------------------------------------------------------------
local function runAutoCollectCash()
    local root = getRoot()
    if not root then return end

    -- 1. Touch cash drops/coins/pens in workspace
    for _, obj in ipairs(workspace:GetDescendants()) do
        if not AutoCollectCash then break end
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name:find("coin") or name:find("cash") or name:find("money") or name:find("reward") or name:find("income") or name:find("pad") then
                local dist = (obj.Position - root.Position).Magnitude
                if dist <= 45 and firetouchinterest then
                    pcall(function()
                        firetouchinterest(root, obj, 0)
                        task.wait(0.02)
                        firetouchinterest(root, obj, 1)
                    end)
                end
            end
        elseif obj:IsA("ProximityPrompt") and obj.Enabled then
            local pName = (obj.Parent and obj.Parent.Name or ""):lower()
            local actText = (obj.ActionText or ""):lower()
            if pName:find("cash") or pName:find("coin") or pName:find("collect") or actText:find("collect") or actText:find("claim") then
                firePrompt(obj)
            end
        end
    end

    -- 2. Remotes for claiming
    for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
        if r:IsA("RemoteEvent") then
            local rName = r.Name:lower()
            if rName:find("collect") or rName:find("claimcash") or rName:find("claimincome") or rName:find("claimreward") then
                pcall(function()
                    r:FireServer()
                end)
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
                task.wait(0.5)
            end
        end)
    end
end)

----------------------------------------------------------------
-- 4. WalkSpeed Boost (60)
----------------------------------------------------------------
CreateToggleRow("WalkSpeed Boost (60)", function(enabled)
    SpeedBoostEnabled = enabled
    local hum = getHum()
    if hum then
        hum.WalkSpeed = enabled and BoostSpeed or NormalSpeed
    end
end)

-- Continuous Speed Enforcement
task.spawn(function()
    while true do
        task.wait(0.5)
        if SpeedBoostEnabled then
            local hum = getHum()
            if hum and hum.WalkSpeed ~= BoostSpeed then
                hum.WalkSpeed = BoostSpeed
            end
        end
    end
end)

----------------------------------------------------------------
-- 5. Fly Mode (WASD + Space controls)
----------------------------------------------------------------
local BodyGyro = nil
local BodyVelocity = nil

local function startFlying()
    local char = LocalPlayer.Character
    local root = getRoot()
    local hum = getHum()
    if not root or not hum then return end

    hum.PlatformStand = true

    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.P = 9e4
    BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.CFrame = root.CFrame
    BodyGyro.Parent = root

    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    BodyVelocity.Parent = root

    task.spawn(function()
        while FlyEnabled and root and BodyVelocity and BodyGyro do
            local moveDir = Vector3.new(0, 0, 0)

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveDir = moveDir - Vector3.new(0, 1, 0)
            end

            if moveDir.Magnitude > 0 then
                BodyVelocity.Velocity = moveDir.Unit * FlySpeed
            else
                BodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end

            BodyGyro.CFrame = Camera.CFrame
            RunService.RenderStepped:Wait()
        end

        if BodyGyro then BodyGyro:Destroy() end
        if BodyVelocity then BodyVelocity:Destroy() end
        local h = getHum()
        if h then h.PlatformStand = false end
    end)
end

CreateToggleRow("Fly Mode (Fly Over Guardians)", function(enabled)
    FlyEnabled = enabled
    if enabled then
        startFlying()
    else
        local root = getRoot()
        if root then
            local bg = root:FindFirstChildOfClass("BodyGyro")
            local bv = root:FindFirstChildOfClass("BodyVelocity")
            if bg then bg:Destroy() end
            if bv then bv:Destroy() end
        end
        local hum = getHum()
        if hum then hum.PlatformStand = false end
    end
end)

----------------------------------------------------------------
-- 6. Infinite Jump
----------------------------------------------------------------
CreateToggleRow("Infinite Jump", function(enabled)
    InfJumpEnabled = enabled
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
-- 7. Teleport to Base (Safe Return with Egg)
----------------------------------------------------------------
CreateActionButton("Set / Teleport Base", "Teleport Base", function()
    local root = getRoot()
    if not root then return end
    if MyBaseCFrame then
        root.CFrame = MyBaseCFrame + Vector3.new(0, 3, 0)
    else
        MyBaseCFrame = root.CFrame
    end
end)

CreateActionButton("Save Current as Base", "Save Base", function()
    local root = getRoot()
    if root then
        MyBaseCFrame = root.CFrame
    end
end)
