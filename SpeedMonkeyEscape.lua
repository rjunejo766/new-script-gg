--==============================================================--
--  ULTRA SCRIPT HUB - Made by Junejo
--  Game: +1 Speed Monkey Escape
--  Game Link: https://www.roblox.com/games/114697347887839/1-Speed-Monkey-Escape
--  GitHub: https://github.com/rjunejo766/new-script-gg
--  Raw: https://raw.githubusercontent.com/rjunejo766/new-script-gg/main/SpeedMonkeyEscape.lua
--  Features: Auto Train, Auto Win, Auto Rebirth, Speed Boost, Inf Jump
--==============================================================--

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    repeat
        task.wait(0.05)
        LocalPlayer = Players.LocalPlayer
    until LocalPlayer
end

local Camera = Workspace.CurrentCamera

-- Feature Toggle States
local AutoTrainEnabled = false
local AutoWinEnabled = false
local AutoRebirthEnabled = false
local WalkSpeedEnabled = false
local InfJumpEnabled = false

local NormalSpeed = 16
local BoostSpeed = 60

-- Anti-AFK Setup
pcall(function()
    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        pcall(function()
            if VirtualUser then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0, 0))
            end
        end)
    end)
end)

--==============================================================--
--  GUI CREATION (Guaranteed 100% Instant Screen Display)
--==============================================================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraScriptHub_SpeedMonkeyEscape"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999

-- Universal Safe GUI Parent Resolution
local parentGui = nil
pcall(function()
    if gethui then parentGui = gethui() end
end)
if not parentGui then
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
        parentGui = CoreGui
    end)
end
if not parentGui then
    pcall(function()
        parentGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
    end)
end

-- Clean old instances
pcall(function()
    if parentGui and parentGui:FindFirstChild("UltraScriptHub_SpeedMonkeyEscape") then
        parentGui:FindFirstChild("UltraScriptHub_SpeedMonkeyEscape"):Destroy()
    end
    if CoreGui and CoreGui:FindFirstChild("UltraScriptHub_SpeedMonkeyEscape") then
        CoreGui:FindFirstChild("UltraScriptHub_SpeedMonkeyEscape"):Destroy()
    end
    local lpGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if lpGui and lpGui:FindFirstChild("UltraScriptHub_SpeedMonkeyEscape") then
        lpGui:FindFirstChild("UltraScriptHub_SpeedMonkeyEscape"):Destroy()
    end
end)

pcall(function() ScreenGui.Parent = parentGui end)
if not ScreenGui.Parent then
    pcall(function()
        ScreenGui.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui") or CoreGui
    end)
end

-- Main Outer Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 275)
MainFrame.Position = UDim2.new(0.5, -160, 0.35, -137)
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
UIStroke.Thickness = 1.2
UIStroke.Parent = MainFrame

-- Floating Open/Close Button (⚡) for Mobile & PC
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "FloatingToggle"
ToggleBtn.Size = UDim2.new(0, 42, 0, 42)
ToggleBtn.Position = UDim2.new(0, 15, 0.5, -21)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
ToggleBtn.BorderColor3 = Color3.fromRGB(0, 170, 255)
ToggleBtn.BorderSizePixel = 1
ToggleBtn.Text = "⚡"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
ToggleBtn.TextSize = 20
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.ZIndex = 20
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Header Title
local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -50, 0, 35)
HeaderTitle.Position = UDim2.new(0, 16, 0, 10)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "+1 SPEED MONKEY ESCAPE"
HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitle.TextSize = 14
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
    MainFrame.Visible = false
end)

-- Content Container
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -32, 0, 155)
Container.Position = UDim2.new(0, 16, 0, 50)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 7)
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

-- Checkbox Row Generator
local function CreateToggleRow(name, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 28)
    Row.BackgroundTransparency = 1
    Row.Parent = Container

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -35, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 220, 225)
    Label.TextSize = 14
    Label.Font = Enum.Font.SourceSansBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local Checkbox = Instance.new("TextButton")
    Checkbox.Size = UDim2.new(0, 22, 0, 22)
    Checkbox.Position = UDim2.new(1, -24, 0.5, -11)
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

--==============================================================--
--  ADD EXACT REQUESTED FEATURES TO GUI
--==============================================================--
CreateToggleRow("⚡ Auto Train (Speed)", function(state)
    AutoTrainEnabled = state
end)

CreateToggleRow("🏆 Auto Win (Escape Track)", function(state)
    AutoWinEnabled = state
end)

CreateToggleRow("🔄 Auto Rebirth", function(state)
    AutoRebirthEnabled = state
end)

CreateToggleRow("🏃 WalkSpeed Boost (60)", function(state)
    WalkSpeedEnabled = state
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = state and BoostSpeed or NormalSpeed
        end
    end)
end)

-- Notification
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Ultra Script Hub",
        Text = "+1 Speed Monkey Escape Loaded!",
        Duration = 3
    })
end)

--==============================================================--
--  HELPER FUNCTIONS & FEATURE ENGINES
--==============================================================--
local function getRoot()
    local char = LocalPlayer.Character
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char.PrimaryPart)
end

local function getHum()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function safeTouch(part)
    if not part or not part:IsA("BasePart") then return end
    local root = getRoot()
    if not root then return end
    pcall(function()
        if firetouchinterest then
            firetouchinterest(root, part, 0)
            task.wait()
            firetouchinterest(root, part, 1)
        end
    end)
end

local function triggerPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return end
    pcall(function()
        prompt.HoldDuration = 0
        if fireproximityprompt then
            fireproximityprompt(prompt, 0)
        else
            prompt:InputHoldBegin()
            task.wait(0.02)
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

local function equipAnyTool()
    pcall(function()
        local char = LocalPlayer.Character
        local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        if not char or not backpack then return end

        if not char:FindFirstChildOfClass("Tool") then
            local tool = backpack:FindFirstChildOfClass("Tool")
            if tool and getHum() then
                getHum():EquipTool(tool)
            end
        end

        local equipped = char:FindFirstChildOfClass("Tool")
        if equipped then
            equipped:Activate()
        end
    end)
end

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled then
        local hum = getHum()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Respawn & WalkSpeed Persistence
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum and WalkSpeedEnabled then
        hum.WalkSpeed = BoostSpeed
    end
end)

-- Remote Cache
local CachedRemotes = {
    Train = {},
    Win = {},
    Rebirth = {}
}

task.spawn(function()
    pcall(function()
        local function scan(container)
            if not container then return end
            for _, obj in ipairs(container:GetDescendants()) do
                if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                    local n = obj.Name:lower()
                    if n:find("train") or n:find("speed") or n:find("step") or n:find("click") or n:find("power") or n:find("run") then
                        table.insert(CachedRemotes.Train, obj)
                    elseif n:find("win") or n:find("finish") or n:find("claim") or n:find("reward") or n:find("stage") or n:find("escape") then
                        table.insert(CachedRemotes.Win, obj)
                    elseif n:find("rebirth") or n:find("prestige") or n:find("rankup") or n:find("evolve") then
                        table.insert(CachedRemotes.Rebirth, obj)
                    end
                end
            end
        end
        scan(ReplicatedStorage)
        task.wait(0.1)
        scan(Workspace)
    end)
end)

--==============================================================--
--  BACKGROUND LOOPS (0-Lag & High Speed Farming)
--==============================================================--

-- 1. AUTO TRAIN LOOP
task.spawn(function()
    while true do
        task.wait(0.1)
        if AutoTrainEnabled then
            pcall(function()
                -- Equip training items/shoes/energy drinks
                equipAnyTool()

                -- Fire training remotes
                for _, rem in ipairs(CachedRemotes.Train) do
                    safeFireRemote(rem)
                    safeFireRemote(rem, "Train")
                    safeFireRemote(rem, 1)
                    safeFireRemote(rem, true)
                end
            end)
        end
    end
end)

-- 2. AUTO WIN (ESCAPE TRACK) LOOP
task.spawn(function()
    while true do
        task.wait(0.2)
        if AutoWinEnabled then
            pcall(function()
                local root = getRoot()
                if not root then return end

                -- 1. Fire Win Remotes
                for _, rem in ipairs(CachedRemotes.Win) do
                    safeFireRemote(rem)
                    safeFireRemote(rem, "Win")
                    safeFireRemote(rem, "Claim")
                    safeFireRemote(rem, 1)
                    safeFireRemote(rem, true)
                end

                -- 2. Scan for Win Pads, Finish Lines, Trophies & Touch them
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if not AutoWinEnabled then break end
                    local n = obj.Name:lower()
                    if n:find("win") or n:find("finish") or n:find("end") or n:find("trophy") or n:find("goal") or n:find("claim") then
                        if obj:IsA("BasePart") then
                            safeTouch(obj)
                        elseif obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) then
                            safeTouch(obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart"))
                        end
                    end
                end
            end)
        end
    end
end)

-- 3. AUTO REBIRTH LOOP
task.spawn(function()
    while true do
        task.wait(0.5)
        if AutoRebirthEnabled then
            pcall(function()
                -- Fire Rebirth Remotes
                for _, rem in ipairs(CachedRemotes.Rebirth) do
                    safeFireRemote(rem)
                    safeFireRemote(rem, "Rebirth")
                    safeFireRemote(rem, 1)
                    safeFireRemote(rem, true)
                end

                -- Touch Rebirth Pads if present
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if not AutoRebirthEnabled then break end
                    local n = obj.Name:lower()
                    if n:find("rebirth") then
                        if obj:IsA("BasePart") then
                            safeTouch(obj)
                        elseif obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) then
                            safeTouch(obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart"))
                        end
                    end
                end
            end)
        end
    end
end)

-- 4. SPEED STABILIZER
task.spawn(function()
    while true do
        task.wait(0.8)
        if WalkSpeedEnabled then
            local hum = getHum()
            if hum and hum.WalkSpeed ~= BoostSpeed then
                hum.WalkSpeed = BoostSpeed
            end
        end
    end
end)

print("[Ultra Script Hub] +1 Speed Monkey Escape loaded successfully.")
