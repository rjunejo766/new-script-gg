--==============================================================--
--  ULTRA SCRIPT HUB - Made by Junejo
--  Game: Dig and Clean
--  Game Link: https://www.roblox.com/games/83038462357724/Dig-Clean
--  GitHub: https://github.com/rjunejo766/new-script-gg
--  Raw: https://raw.githubusercontent.com/rjunejo766/new-script-gg/main/DigAndClean.lua
--  Features: Auto Dig, Auto Clean, Auto Sell, Teleports, Speed, Inf Jump
--==============================================================--

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

-- 100% Safe LocalPlayer Resolution
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    repeat
        task.wait(0.05)
        LocalPlayer = Players.LocalPlayer
    until LocalPlayer
end

local Camera = Workspace.CurrentCamera

-- Feature Toggle States
local AutoDigEnabled = false
local AutoCleanEnabled = false
local AutoSellEnabled = false
local WalkSpeedEnabled = false
local InfJumpEnabled = false

local NormalSpeed = 16
local BoostSpeed = 45

--==============================================================--
--  GUI CREATION (Guaranteed 100% Instant Screen Display)
--==============================================================--

-- Clean old instances
pcall(function()
    local pgui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if pgui and pgui:FindFirstChild("UltraScriptHub_DigAndClean") then
        pgui:FindFirstChild("UltraScriptHub_DigAndClean"):Destroy()
    end
end)
pcall(function()
    if CoreGui and CoreGui:FindFirstChild("UltraScriptHub_DigAndClean") then
        CoreGui:FindFirstChild("UltraScriptHub_DigAndClean"):Destroy()
    end
end)
pcall(function()
    if gethui and gethui():FindFirstChild("UltraScriptHub_DigAndClean") then
        gethui():FindFirstChild("UltraScriptHub_DigAndClean"):Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraScriptHub_DigAndClean"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999
ScreenGui.Enabled = true

-- Main Outer Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 395)
MainFrame.Position = UDim2.new(0.5, -160, 0.3, -190)
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

-- Floating Open/Close Button (⚡) for Mobile & PC
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "FloatingToggle"
ToggleBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleBtn.Position = UDim2.new(0, 15, 0.5, -20)
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
HeaderTitle.Position = UDim2.new(0, 16, 0, 8)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "DIG AND CLEAN"
HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitle.TextSize = 14
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
    MainFrame.Visible = false
end)

-- Content Scrolling Container
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -24, 0, 280)
Container.Position = UDim2.new(0, 12, 0, 45)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 3
Container.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
Container.CanvasSize = UDim2.new(0, 0, 0, 330)
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
FooterSub.Position = UDim2.new(0, 0, 1, -24)
FooterSub.BackgroundTransparency = 1
FooterSub.Text = "Made by Junejo"
FooterSub.TextColor3 = Color3.fromRGB(150, 150, 150)
FooterSub.TextSize = 12
FooterSub.Font = Enum.Font.SourceSans
FooterSub.ZIndex = 11
FooterSub.Parent = MainFrame

-- Checkbox Row Generator
local function CreateToggleRow(name, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 28)
    Row.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
    Row.BackgroundTransparency = 0.5
    Row.ZIndex = 12
    Row.Parent = Container

    local RowCorner = Instance.new("UICorner")
    RowCorner.CornerRadius = UDim.new(0, 6)
    RowCorner.Parent = Row

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -40, 1, 0)
    Label.Position = UDim2.new(0, 8, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 220, 225)
    Label.TextSize = 13
    Label.Font = Enum.Font.SourceSansBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 13
    Label.Parent = Row

    local Checkbox = Instance.new("TextButton")
    Checkbox.Size = UDim2.new(0, 20, 0, 20)
    Checkbox.Position = UDim2.new(1, -26, 0.5, -10)
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
            Row.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
        else
            Checkbox.BackgroundColor3 = Color3.fromRGB(25, 27, 35)
            Checkbox.BorderColor3 = Color3.fromRGB(45, 48, 60)
            Row.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
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

-- Action/Teleport Button Generator
local function CreateActionButton(text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 28)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 28, 38)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(0, 170, 255)
    Btn.TextSize = 13
    Btn.Font = Enum.Font.SourceSansBold
    Btn.ZIndex = 12
    Btn.Parent = Container

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Btn

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = Color3.fromRGB(45, 55, 75)
    BtnStroke.Thickness = 1
    BtnStroke.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        task.spawn(function()
            pcall(callback)
        end)
    end)

    return Btn
end

--==============================================================--
--  ADD ALL FEATURES TO GUI
--==============================================================--

CreateToggleRow("⛏️ Auto Dig", function(state)
    AutoDigEnabled = state
end)

CreateToggleRow("🧼 Auto Clean", function(state)
    AutoCleanEnabled = state
end)

CreateToggleRow("💰 Auto Sell", function(state)
    AutoSellEnabled = state
end)

CreateToggleRow("🏃 WalkSpeed Boost (45)", function(state)
    WalkSpeedEnabled = state
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = state and BoostSpeed or NormalSpeed
        end
    end)
end)

CreateToggleRow("🦘 Infinite Jump", function(state)
    InfJumpEnabled = state
end)

-- Teleport Buttons
local function getRoot()
    local char = LocalPlayer.Character
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char.PrimaryPart)
end

local function teleportTo(cf)
    local root = getRoot()
    if root and cf then
        root.CFrame = cf + Vector3.new(0, 3.5, 0)
    end
end

CreateActionButton("📍 Teleport to Dig Zone", function()
    local root = getRoot()
    if not root then return end
    for _, obj in ipairs(Workspace:GetChildren()) do
        local n = obj.Name:lower()
        if n:find("dig") or n:find("sand") or n:find("mine") or n:find("dirt") or n:find("zone") then
            local cf = obj:IsA("BasePart") and obj.CFrame or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")).CFrame)
            if cf then
                teleportTo(cf)
                return
            end
        end
    end
    teleportTo(root.CFrame + Vector3.new(0, 0, 25))
end)

CreateActionButton("🧼 Teleport to Clean Station", function()
    local root = getRoot()
    if not root then return end
    for _, obj in ipairs(Workspace:GetChildren()) do
        local n = obj.Name:lower()
        if n:find("clean") or n:find("wash") or n:find("station") or n:find("sink") or n:find("tub") then
            local cf = obj:IsA("BasePart") and obj.CFrame or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")).CFrame)
            if cf then
                teleportTo(cf)
                return
            end
        end
    end
    teleportTo(root.CFrame + Vector3.new(20, 0, 0))
end)

CreateActionButton("💰 Teleport to Sell Zone", function()
    local root = getRoot()
    if not root then return end
    for _, obj in ipairs(Workspace:GetChildren()) do
        local n = obj.Name:lower()
        if n:find("sell") or n:find("shop") or n:find("deposit") or n:find("cash") or n:find("bank") then
            local cf = obj:IsA("BasePart") and obj.CFrame or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")).CFrame)
            if cf then
                teleportTo(cf)
                return
            end
        end
    end
    teleportTo(root.CFrame + Vector3.new(-20, 0, 0))
end)

CreateActionButton("🏠 Teleport to Spawn / Base", function()
    local spawnObj = Workspace:FindFirstChild("SpawnLocation") or Workspace:FindFirstChildWhichIsA("SpawnLocation", true)
    if spawnObj and spawnObj:IsA("BasePart") then
        teleportTo(spawnObj.CFrame)
    else
        local root = getRoot()
        if root then teleportTo(root.CFrame + Vector3.new(0, 5, 0)) end
    end
end)

-- Safe Universal Parenting (Guaranteed Display)
local parented = false
pcall(function()
    if gethui then
        ScreenGui.Parent = gethui()
        parented = true
    end
end)
if not parented or not ScreenGui.Parent then
    pcall(function()
        local pgui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
        ScreenGui.Parent = pgui
        parented = true
    end)
end
if not parented or not ScreenGui.Parent then
    pcall(function()
        ScreenGui.Parent = CoreGui
    end)
end

-- Success Notification
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Ultra Script Hub",
        Text = "Dig and Clean Loaded!",
        Duration = 3
    })
end)

--==============================================================--
--  FEATURE ENGINES & REMOTES
--==============================================================--
local CachedRemotes = {
    Dig = {},
    Clean = {},
    Sell = {}
}

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

-- Background Remote Discovery
task.spawn(function()
    pcall(function()
        local function scan(container)
            if not container then return end
            for _, obj in ipairs(container:GetDescendants()) do
                if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                    local n = obj.Name:lower()
                    if n:find("dig") or n:find("mine") or n:find("shovel") or n:find("hit") or n:find("harvest") or n:find("attack") then
                        table.insert(CachedRemotes.Dig, obj)
                    elseif n:find("clean") or n:find("wash") or n:find("sponge") or n:find("scrub") or n:find("wipe") then
                        table.insert(CachedRemotes.Clean, obj)
                    elseif n:find("sell") or n:find("deposit") or n:find("trade") or n:find("cashout") then
                        table.insert(CachedRemotes.Sell, obj)
                    end
                end
            end
        end
        scan(ReplicatedStorage)
        task.wait(0.1)
        scan(Workspace)
    end)
end)

local function getHum()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
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

-- WalkSpeed Auto-Reapply
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum and WalkSpeedEnabled then
        hum.WalkSpeed = BoostSpeed
    end
end)

-- Anti-AFK
task.spawn(function()
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
end)

-- 1. AUTO DIG LOOP
task.spawn(function()
    while true do
        task.wait(0.15)
        if AutoDigEnabled then
            pcall(function()
                equipAnyTool()
                for _, rem in ipairs(CachedRemotes.Dig) do
                    safeFireRemote(rem, "Dig", true)
                    safeFireRemote(rem, true)
                end
            end)
        end
    end
end)

-- 2. AUTO CLEAN LOOP
task.spawn(function()
    while true do
        task.wait(0.2)
        if AutoCleanEnabled then
            pcall(function()
                equipAnyTool()
                for _, rem in ipairs(CachedRemotes.Clean) do
                    safeFireRemote(rem, "Clean", true)
                    safeFireRemote(rem, true)
                end
            end)
        end
    end
end)

-- 3. AUTO SELL LOOP
task.spawn(function()
    while true do
        task.wait(0.35)
        if AutoSellEnabled then
            pcall(function()
                for _, rem in ipairs(CachedRemotes.Sell) do
                    safeFireRemote(rem, "Sell", true)
                    safeFireRemote(rem, "SellAll", true)
                    safeFireRemote(rem)
                end
            end)
        end
    end
end)

-- 4. SPEED REGULATOR LOOP
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

print("[Ultra Script Hub] Dig and Clean script loaded successfully.")
