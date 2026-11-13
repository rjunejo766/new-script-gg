--==============================================================--
--  ULTRA SCRIPT HUB - Made by Junejo
--  Game: Depth Egg Chase
--  Game Link: https://www.roblox.com/games/132670444232795/Depth-Egg-Chase
--  Version: 1.0 (Auto Train, Auto Catch Eggs, Auto Return, Auto Hatch, Speed & Jump)
--==============================================================--

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    repeat
        task.wait()
        LocalPlayer = Players.LocalPlayer
    until LocalPlayer
end

-- Feature Toggle States
local AutoTrainEnabled = false
local AutoCatchEggsEnabled = false
local AutoReturnEnabled = false
local AutoHatchEnabled = false
local SpeedJumpEnabled = false

local NormalSpeed = 16
local BoostSpeed = 60
local SafeBaseCFrame = nil

-- Built-in Anti-AFK
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
-- GUI CREATION (Ultra Script Hub Cyan / Deep Sea Theme)
----------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraScriptHub_DepthEggChase"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999
ScreenGui.IgnoreGuiInset = true

-- Clean previous instances
pcall(function()
    if gethui and gethui():FindFirstChild("UltraScriptHub_DepthEggChase") then
        gethui():FindFirstChild("UltraScriptHub_DepthEggChase"):Destroy()
    end
end)
pcall(function()
    if CoreGui and CoreGui:FindFirstChild("UltraScriptHub_DepthEggChase") then
        CoreGui:FindFirstChild("UltraScriptHub_DepthEggChase"):Destroy()
    end
end)
pcall(function()
    local pgui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if pgui and pgui:FindFirstChild("UltraScriptHub_DepthEggChase") then
        pgui:FindFirstChild("UltraScriptHub_DepthEggChase"):Destroy()
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

-- Main Outer Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 325, 0, 310)
MainFrame.Position = UDim2.new(0.5, -162, 0.4, -155)
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
UIStroke.Color = Color3.fromRGB(0, 180, 240)
UIStroke.Thickness = 1.2
UIStroke.Parent = MainFrame

-- Header Title
local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -50, 0, 35)
HeaderTitle.Position = UDim2.new(0, 16, 0, 8)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "DEPTH EGG CHASE"
HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitle.TextSize = 15
HeaderTitle.Font = Enum.Font.SourceSansBold
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.ZIndex = 11
HeaderTitle.Parent = MainFrame

-- Close Button (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -34, 0, 8)
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
Container.Size = UDim2.new(1, -32, 0, 190)
Container.Position = UDim2.new(0, 16, 0, 46)
Container.BackgroundTransparency = 1
Container.ZIndex = 11
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.Parent = Container

-- Footer Titles
local FooterTitle = Instance.new("TextLabel")
FooterTitle.Size = UDim2.new(1, 0, 0, 20)
FooterTitle.Position = UDim2.new(0, 0, 1, -44)
FooterTitle.BackgroundTransparency = 1
FooterTitle.Text = "ULTRA SCRIPT HUB"
FooterTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
FooterTitle.TextSize = 15
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
    Label.TextColor3 = Color3.fromRGB(225, 225, 230)
    Label.TextSize = 14
    Label.Font = Enum.Font.SourceSansBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 12
    Label.Parent = Row

    local Checkbox = Instance.new("TextButton")
    Checkbox.Size = UDim2.new(0, 22, 0, 22)
    Checkbox.Position = UDim2.new(1, -24, 0.5, -11)
    Checkbox.BackgroundColor3 = Color3.fromRGB(25, 27, 35)
    Checkbox.BorderColor3 = Color3.fromRGB(50, 55, 70)
    Checkbox.Text = ""
    Checkbox.AutoButtonColor = false
    Checkbox.ZIndex = 12
    Checkbox.Parent = Row

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 5)
    BoxCorner.Parent = Checkbox

    local CheckIcon = Instance.new("Frame")
    CheckIcon.Size = UDim2.new(1, -6, 1, -6)
    CheckIcon.Position = UDim2.new(0, 3, 0, 3)
    CheckIcon.BackgroundColor3 = Color3.fromRGB(0, 180, 240)
    CheckIcon.Visible = false
    CheckIcon.ZIndex = 13
    CheckIcon.Parent = Checkbox

    local CheckIconCorner = Instance.new("UICorner")
    CheckIconCorner.CornerRadius = UDim.new(0, 3)
    CheckIconCorner.Parent = CheckIcon

    local toggled = false
    local function setToggle(val)
        toggled = val
        CheckIcon.Visible = toggled
        if toggled then
            Checkbox.BorderColor3 = Color3.fromRGB(0, 180, 240)
        else
            Checkbox.BorderColor3 = Color3.fromRGB(50, 55, 70)
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
-- HELPER FUNCTIONS & COMPATIBILITY
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

-- Save initial spawn / base safety location
task.spawn(function()
    task.wait(1)
    local root = getRoot()
    if root then
        SafeBaseCFrame = root.CFrame
    end
end)

local function touch(targetPart)
    local root = getRoot()
    if not root or not targetPart then return end
    pcall(function()
        if firetouchinterest then
            firetouchinterest(root, targetPart, 0)
            task.wait()
            firetouchinterest(root, targetPart, 1)
        else
            targetPart.CFrame = root.CFrame
        end
    end)
end

local function activatePrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return end
    pcall(function()
        if fireproximityprompt then
            fireproximityprompt(prompt)
        else
            prompt:InputHoldBegin()
            task.wait(prompt.HoldDuration + 0.05)
            prompt:InputHoldEnd()
        end
    end)
end

local function safeFireRemote(remote, ...)
    if not remote then return end
    pcall(function()
        if remote:IsA("RemoteEvent") then
            remote:FireServer(...)
        elseif remote:IsA("RemoteFunction") then
            remote:InvokeServer(...)
        end
    end)
end

local function findRemotes(keywords)
    local results = {}
    local function scan(parent)
        if not parent then return end
        for _, obj in ipairs(parent:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                local n = obj.Name:lower()
                for _, kw in ipairs(keywords) do
                    if n:find(kw:lower()) then
                        table.insert(results, obj)
                        break
                    end
                end
            end
        end
    end
    scan(ReplicatedStorage)
    return results
end

-- Respawn & Speed Hook
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local root = char:WaitForChild("HumanoidRootPart", 5)
    if root and not SafeBaseCFrame then
        SafeBaseCFrame = root.CFrame
    end
    if SpeedJumpEnabled then
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then
            hum.WalkSpeed = BoostSpeed
        end
    end
end)

-- Infinite Jump Hook
UserInputService.JumpRequest:Connect(function()
    if SpeedJumpEnabled then
        local hum = getHum()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

----------------------------------------------------------------
-- 5 TOP FEATURES IMPLEMENTATION
----------------------------------------------------------------

-- 1. Auto Train (Rowing Speed Farm)
CreateToggleRow("Auto Train (Rowing Speed)", function(state)
    AutoTrainEnabled = state
    if AutoTrainEnabled then
        task.spawn(function()
            while AutoTrainEnabled do
                pcall(function()
                    -- Method A: Fire proximity prompts on rowing machines
                    for _, prompt in ipairs(Workspace:GetDescendants()) do
                        if not AutoTrainEnabled then break end
                        if prompt:IsA("ProximityPrompt") then
                            local pName = prompt.Name:lower()
                            local parName = prompt.Parent and prompt.Parent.Name:lower() or ""
                            if pName:find("train") or pName:find("row") or pName:find("machine") or parName:find("row") or parName:find("train") or parName:find("gym") then
                                activatePrompt(prompt)
                            end
                        end
                    end

                    -- Method B: Fire training remotes
                    local trainRemotes = findRemotes({"train", "row", "gainspeed", "workout", "exercisespeed", "giverowing"})
                    for _, rem in ipairs(trainRemotes) do
                        safeFireRemote(rem)
                        safeFireRemote(rem, 1)
                        safeFireRemote(rem, "Train")
                    end
                end)
                task.wait(0.25)
            end
        end)
    end
end)

-- 2. Auto Catch Deep Sea Eggs
CreateToggleRow("Auto Catch Deep Sea Eggs", function(state)
    AutoCatchEggsEnabled = state
    if AutoCatchEggsEnabled then
        task.spawn(function()
            while AutoCatchEggsEnabled do
                pcall(function()
                    local root = getRoot()

                    -- Method A: Fire claw/drop remotes
                    local clawRemotes = findRemotes({"claw", "dropclaw", "plunge", "catchegg", "reel", "pulley", "fish", "grabegg"})
                    for _, rem in ipairs(clawRemotes) do
                        safeFireRemote(rem)
                        safeFireRemote(rem, "Deep")
                        safeFireRemote(rem, 100)
                    end

                    -- Method B: Touch / Collect floating fish eggs in sea zones
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if not AutoCatchEggsEnabled then break end
                        if obj:IsA("BasePart") then
                            local n = obj.Name:lower()
                            if n:find("egg") or n:find("depth") or n:find("rare") or n:find("fishegg") then
                                touch(obj)
                            end
                        elseif obj:IsA("ProximityPrompt") then
                            local pn = obj.Name:lower()
                            local parn = obj.Parent and obj.Parent.Name:lower() or ""
                            if pn:find("egg") or pn:find("catch") or parn:find("egg") then
                                activatePrompt(obj)
                            end
                        end
                    end
                end)
                task.wait(0.4)
            end
        end)
    end
end)

-- 3. Auto Return / Escape to Base
CreateToggleRow("Auto Escape to Base (Safety)", function(state)
    AutoReturnEnabled = state
    if AutoReturnEnabled then
        task.spawn(function()
            while AutoReturnEnabled do
                pcall(function()
                    local root = getRoot()
                    local hum = getHum()

                    -- If in danger or holding egg, return to safety
                    if root and SafeBaseCFrame then
                        -- Check for safety zones or base locations in workspace
                        local targetCFrame = SafeBaseCFrame
                        for _, obj in ipairs(Workspace:GetDescendants()) do
                            if obj:IsA("BasePart") then
                                local name = obj.Name:lower()
                                if name:find("safetyzone") or name:find("safezone") or name:find("safeline") then
                                    targetCFrame = obj.CFrame + Vector3.new(0, 3, 0)
                                    break
                                end
                            end
                        end

                        -- Teleport to safety
                        root.CFrame = targetCFrame
                    end
                end)
                task.wait(1.5)
            end
        end)
    end
end)

-- 4. Auto Hatch & Deposit Eggs
CreateToggleRow("Auto Hatch & Deposit Eggs", function(state)
    AutoHatchEnabled = state
    if AutoHatchEnabled then
        task.spawn(function()
            while AutoHatchEnabled do
                pcall(function()
                    -- Method A: Trigger Incubator Prompts / Pads
                    for _, prompt in ipairs(Workspace:GetDescendants()) do
                        if not AutoHatchEnabled then break end
                        if prompt:IsA("ProximityPrompt") then
                            local pn = prompt.Name:lower()
                            local parn = prompt.Parent and prompt.Parent.Name:lower() or ""
                            if pn:find("hatch") or pn:find("incubator") or pn:find("deposit") or parn:find("incubator") or parn:find("nest") then
                                activatePrompt(prompt)
                            end
                        end
                    end

                    -- Method B: Fire Hatch Remotes
                    local hatchRemotes = findRemotes({"hatch", "openegg", "depositegg", "claimpet", "claimanimal", "hatchall"})
                    for _, rem in ipairs(hatchRemotes) do
                        safeFireRemote(rem)
                        safeFireRemote(rem, 1)
                        safeFireRemote(rem, "All")
                    end
                end)
                task.wait(0.6)
            end
        end)
    end
end)

-- 5. Speed (60) + Infinite Jump
CreateToggleRow("Speed (60) + Infinite Jump", function(state)
    SpeedJumpEnabled = state
    local hum = getHum()
    if hum then
        if SpeedJumpEnabled then
            hum.WalkSpeed = BoostSpeed
        else
            hum.WalkSpeed = NormalSpeed
        end
    end
end)
