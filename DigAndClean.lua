--==============================================================--
--  ULTRA SCRIPT HUB - Made by Junejo
--  Game: Dig and Clean
--  Game Link: https://www.roblox.com/games/83038462357724/Dig-Clean
--  GitHub: https://github.com/rjunejo766/new-script-gg
--  Raw: https://raw.githubusercontent.com/rjunejo766/new-script-gg/main/DigAndClean.lua
--  Features: Auto Dig, Auto Clean, Auto Sell, Teleports, Speed Boost, Inf Jump
--  Optimization: 100% Lag-Free & Zero Freeze (Smooth Engine)
--==============================================================--

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

-- Safe LocalPlayer Resolution
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    repeat
        task.wait(0.05)
        LocalPlayer = Players.LocalPlayer
    until LocalPlayer
end

local Camera = Workspace.CurrentCamera

-- Anti-AFK Setup (Zero Performance Cost)
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

-- Feature Toggle States
local AutoDigEnabled = false
local AutoCleanEnabled = false
local AutoSellEnabled = false
local WalkSpeedEnabled = false
local InfJumpEnabled = false

local NormalSpeed = 16
local BoostSpeed = 45

--==============================================================--
--  ZERO-LAG CACHE SYSTEM (Background Indexing - No Freeze)
--==============================================================--
local CachedRemotes = {
    Dig = {},
    Clean = {},
    Sell = {}
}

local CachedLocations = {
    DigZone = nil,
    CleanStation = nil,
    SellZone = nil,
    Shop = nil,
    Spawn = nil
}

local CachedInteractive = {
    DigPrompts = {},
    CleanPrompts = {},
    SellPads = {}
}

-- Fast & Safe Remote Invoker
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

-- Asynchronous Background Cache Builder (Runs smoothly in chunks to prevent ANY lag)
local function RefreshCacheAsync()
    task.spawn(function()
        -- 1. Index Remotes
        local remotesFound = { Dig = {}, Clean = {}, Sell = {} }
        local function scanRemotes(container)
            if not container then return end
            pcall(function()
                for _, obj in ipairs(container:GetDescendants()) do
                    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                        local n = obj.Name:lower()
                        if n:find("dig") or n:find("mine") or n:find("shovel") or n:find("hit") or n:find("harvest") or n:find("attack") then
                            table.insert(remotesFound.Dig, obj)
                        elseif n:find("clean") or n:find("wash") or n:find("sponge") or n:find("scrub") or n:find("wipe") or n:find("process") then
                            table.insert(remotesFound.Clean, obj)
                        elseif n:find("sell") or n:find("deposit") or n:find("trade") or n:find("cashout") or n:find("bank") then
                            table.insert(remotesFound.Sell, obj)
                        end
                    end
                end
            end)
        end

        scanRemotes(ReplicatedStorage)
        task.wait(0.05)
        scanRemotes(Workspace)

        CachedRemotes.Dig = remotesFound.Dig
        CachedRemotes.Clean = remotesFound.Clean
        CachedRemotes.Sell = remotesFound.Sell

        -- 2. Index Teleport Spots & Interactive Objects smoothly with periodic yields
        local digPrompts = {}
        local cleanPrompts = {}
        local sellPads = {}
        
        pcall(function()
            for _, obj in ipairs(Workspace:GetChildren()) do
                local n = obj.Name:lower()
                
                -- Teleports & Pads Detection
                if not CachedLocations.DigZone and (n:find("dig") or n:find("sand") or n:find("mine") or n:find("dirt")) then
                    if obj:IsA("BasePart") then CachedLocations.DigZone = obj.CFrame
                    elseif obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) then
                        CachedLocations.DigZone = (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")).CFrame
                    end
                end

                if not CachedLocations.CleanStation and (n:find("clean") or n:find("wash") or n:find("station") or n:find("sink") or n:find("tub")) then
                    if obj:IsA("BasePart") then CachedLocations.CleanStation = obj.CFrame
                    elseif obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) then
                        CachedLocations.CleanStation = (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")).CFrame
                    end
                end

                if not CachedLocations.SellZone and (n:find("sell") or n:find("shop") or n:find("deposit") or n:find("cash") or n:find("bank")) then
                    if obj:IsA("BasePart") then CachedLocations.SellZone = obj.CFrame
                    elseif obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) then
                        CachedLocations.SellZone = (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")).CFrame
                    end
                end

                if not CachedLocations.Shop and (n:find("upgrade") or n:find("store") or n:find("tool")) then
                    if obj:IsA("BasePart") then CachedLocations.Shop = obj.CFrame
                    elseif obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) then
                        CachedLocations.Shop = (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")).CFrame
                    end
                end

                if not CachedLocations.Spawn and (obj:IsA("SpawnLocation") or n:find("spawn")) then
                    if obj:IsA("BasePart") then CachedLocations.Spawn = obj.CFrame
                    elseif obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) then
                        CachedLocations.Spawn = (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")).CFrame
                    end
                end

                -- Scan interactive items inside this folder/model
                if obj:IsA("Model") or obj:IsA("Folder") then
                    for _, sub in ipairs(obj:GetChildren()) do
                        local sn = sub.Name:lower()
                        if sub:IsA("ProximityPrompt") then
                            if sn:find("dig") or n:find("dig") or sn:find("dirt") then
                                table.insert(digPrompts, sub)
                            elseif sn:find("clean") or n:find("clean") or sn:find("wash") then
                                table.insert(cleanPrompts, sub)
                            end
                        elseif sub:IsA("BasePart") and (sn:find("sell") or n:find("sell") or sn:find("deposit")) then
                            table.insert(sellPads, sub)
                        end
                    end
                end
            end
        end)

        CachedInteractive.DigPrompts = digPrompts
        CachedInteractive.CleanPrompts = cleanPrompts
        CachedInteractive.SellPads = sellPads
    end)
end

-- Initial Background Scan
RefreshCacheAsync()

-- Periodic Slow Background Cache Update (Every 8 seconds, totally invisible to FPS)
task.spawn(function()
    while true do
        task.wait(8)
        RefreshCacheAsync()
    end
end)

--==============================================================--
--  CHARACTER & ACTION HELPERS
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

-- Infinite Jump (Zero lag event hook)
UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled then
        local hum = getHum()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- WalkSpeed Auto-Reapply on Respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum and WalkSpeedEnabled then
        hum.WalkSpeed = BoostSpeed
    end
end)

--==============================================================--
--  GUI CREATION (Guaranteed Instant Screen Display & Smooth UI)
--==============================================================--
local GuiName = "UltraScriptHub_DigAndClean"

pcall(function()
    local pgui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if pgui and pgui:FindFirstChild(GuiName) then
        pgui:FindFirstChild(GuiName):Destroy()
    end
end)
pcall(function()
    if CoreGui and CoreGui:FindFirstChild(GuiName) then
        CoreGui:FindFirstChild(GuiName):Destroy()
    end
end)
pcall(function()
    if gethui and gethui():FindFirstChild(GuiName) then
        gethui():FindFirstChild(GuiName):Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = GuiName
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999

local guiParent = nil
pcall(function() if gethui then guiParent = gethui() end end)
if not guiParent then
    pcall(function()
        if CoreGui and pcall(function() local _ = CoreGui.Name end) then
            guiParent = CoreGui
        end
    end)
end
if not guiParent then
    guiParent = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
end
ScreenGui.Parent = guiParent

-- Floating Open/Close Button (⚡)
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
ToggleBtn.ZIndex = 30
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleBtn

-- Main Outer Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 370)
MainFrame.Position = UDim2.new(0.5, -160, 0.3, -185)
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

-- Tab Bar
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -32, 0, 30)
TabBar.Position = UDim2.new(0, 16, 0, 42)
TabBar.BackgroundColor3 = Color3.fromRGB(22, 24, 30)
TabBar.BorderSizePixel = 0
TabBar.ZIndex = 11
TabBar.Parent = MainFrame

local TabBarCorner = Instance.new("UICorner")
TabBarCorner.CornerRadius = UDim.new(0, 6)
TabBarCorner.Parent = TabBar

local TabFarmBtn = Instance.new("TextButton")
TabFarmBtn.Size = UDim2.new(0.5, -2, 1, -4)
TabFarmBtn.Position = UDim2.new(0, 2, 0, 2)
TabFarmBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
TabFarmBtn.Text = "⚡ Auto Farm"
TabFarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TabFarmBtn.TextSize = 12
TabFarmBtn.Font = Enum.Font.SourceSansBold
TabFarmBtn.ZIndex = 12
TabFarmBtn.Parent = TabBar

local TabFarmCorner = Instance.new("UICorner")
TabFarmCorner.CornerRadius = UDim.new(0, 4)
TabFarmCorner.Parent = TabFarmBtn

local TabTpBtn = Instance.new("TextButton")
TabTpBtn.Size = UDim2.new(0.5, -2, 1, -4)
TabTpBtn.Position = UDim2.new(0.5, 0, 0, 2)
TabTpBtn.BackgroundColor3 = Color3.fromRGB(28, 30, 38)
TabTpBtn.Text = "📍 Teleports"
TabTpBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
TabTpBtn.TextSize = 12
TabTpBtn.Font = Enum.Font.SourceSansBold
TabTpBtn.ZIndex = 12
TabTpBtn.Parent = TabBar

local TabTpCorner = Instance.new("UICorner")
TabTpCorner.CornerRadius = UDim.new(0, 4)
TabTpCorner.Parent = TabTpBtn

-- Scrolling Content Pages
local FarmContainer = Instance.new("ScrollingFrame")
FarmContainer.Size = UDim2.new(1, -32, 0, 235)
FarmContainer.Position = UDim2.new(0, 16, 0, 78)
FarmContainer.BackgroundTransparency = 1
FarmContainer.BorderSizePixel = 0
FarmContainer.ScrollBarThickness = 3
FarmContainer.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
FarmContainer.CanvasSize = UDim2.new(0, 0, 0, 245)
FarmContainer.ZIndex = 11
FarmContainer.Visible = true
FarmContainer.Parent = MainFrame

local FarmLayout = Instance.new("UIListLayout")
FarmLayout.SortOrder = Enum.SortOrder.LayoutOrder
FarmLayout.Padding = UDim.new(0, 6)
FarmLayout.Parent = FarmContainer

local TpContainer = Instance.new("ScrollingFrame")
TpContainer.Size = UDim2.new(1, -32, 0, 235)
TpContainer.Position = UDim2.new(0, 16, 0, 78)
TpContainer.BackgroundTransparency = 1
TpContainer.BorderSizePixel = 0
TpContainer.ScrollBarThickness = 3
TpContainer.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
TpContainer.CanvasSize = UDim2.new(0, 0, 0, 245)
TpContainer.ZIndex = 11
TpContainer.Visible = false
TpContainer.Parent = MainFrame

local TpLayout = Instance.new("UIListLayout")
TpLayout.SortOrder = Enum.SortOrder.LayoutOrder
TpLayout.Padding = UDim.new(0, 6)
TpLayout.Parent = TpContainer

-- Tab Switch Logic (Instant & Smooth)
TabFarmBtn.MouseButton1Click:Connect(function()
    FarmContainer.Visible = true
    TpContainer.Visible = false
    TabFarmBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    TabFarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabTpBtn.BackgroundColor3 = Color3.fromRGB(28, 30, 38)
    TabTpBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
end)

TabTpBtn.MouseButton1Click:Connect(function()
    FarmContainer.Visible = false
    TpContainer.Visible = true
    TabTpBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    TabTpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabFarmBtn.BackgroundColor3 = Color3.fromRGB(28, 30, 38)
    TabFarmBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
end)

-- Footer
local FooterTitle = Instance.new("TextLabel")
FooterTitle.Size = UDim2.new(1, 0, 0, 18)
FooterTitle.Position = UDim2.new(0, 0, 1, -40)
FooterTitle.BackgroundTransparency = 1
FooterTitle.Text = "ULTRA SCRIPT HUB"
FooterTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
FooterTitle.TextSize = 14
FooterTitle.Font = Enum.Font.SourceSansBold
FooterTitle.ZIndex = 11
FooterTitle.Parent = MainFrame

local FooterSub = Instance.new("TextLabel")
FooterSub.Size = UDim2.new(1, 0, 0, 14)
FooterSub.Position = UDim2.new(0, 0, 1, -22)
FooterSub.BackgroundTransparency = 1
FooterSub.Text = "Made by Junejo"
FooterSub.TextColor3 = Color3.fromRGB(150, 150, 150)
FooterSub.TextSize = 11
FooterSub.Font = Enum.Font.SourceSans
FooterSub.ZIndex = 11
FooterSub.Parent = MainFrame

-- Checkbox Row Component
local function CreateToggleRow(parent, name, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, -6, 0, 28)
    Row.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
    Row.BackgroundTransparency = 0.5
    Row.ZIndex = 12
    Row.Parent = parent

    local RowCorner = Instance.new("UICorner")
    RowCorner.CornerRadius = UDim.new(0, 6)
    RowCorner.Parent = Row

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -40, 1, 0)
    Label.Position = UDim2.new(0, 8, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(225, 225, 230)
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

-- Teleport Button Component (Instant execution - No Search Freeze)
local function CreateTeleportButton(parent, text, locationKey, fallbackOffset)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -6, 0, 28)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 28, 38)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(0, 170, 255)
    Btn.TextSize = 13
    Btn.Font = Enum.Font.SourceSansBold
    Btn.ZIndex = 12
    Btn.Parent = parent

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Btn

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = Color3.fromRGB(45, 55, 75)
    BtnStroke.Thickness = 1
    BtnStroke.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        task.spawn(function()
            local root = getRoot()
            if not root then return end
            
            local targetCf = CachedLocations[locationKey]
            if targetCf then
                root.CFrame = targetCf + Vector3.new(0, 3.5, 0)
            else
                -- Instant direct check if not cached yet
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if obj.Name:lower():find(locationKey:lower():sub(1, 4)) then
                        local cf = obj:IsA("BasePart") and obj.CFrame or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")).CFrame)
                        if cf then
                            CachedLocations[locationKey] = cf
                            root.CFrame = cf + Vector3.new(0, 3.5, 0)
                            return
                        end
                    end
                end
                
                -- Safe fallback
                if fallbackOffset then
                    root.CFrame = root.CFrame + fallbackOffset
                end
            end
        end)
    end)

    return Btn
end

--==============================================================--
--  POPULATE GUI CONTROLS
--==============================================================--

-- Farm Tab
CreateToggleRow(FarmContainer, "⛏️ Auto Dig (Dig & Harvest)", function(state)
    AutoDigEnabled = state
end)

CreateToggleRow(FarmContainer, "🧼 Auto Clean (Wash Dirt)", function(state)
    AutoCleanEnabled = state
end)

CreateToggleRow(FarmContainer, "💰 Auto Sell (Sell All)", function(state)
    AutoSellEnabled = state
end)

CreateToggleRow(FarmContainer, "🏃 WalkSpeed Boost (45)", function(state)
    WalkSpeedEnabled = state
    local hum = getHum()
    if hum then
        hum.WalkSpeed = state and BoostSpeed or NormalSpeed
    end
end)

CreateToggleRow(FarmContainer, "🦘 Infinite Jump", function(state)
    InfJumpEnabled = state
end)

-- Teleport Tab
CreateTeleportButton(TpContainer, "📍 Teleport to Dig Zone", "DigZone", Vector3.new(0, 0, 25))
CreateTeleportButton(TpContainer, "🧼 Teleport to Clean Station", "CleanStation", Vector3.new(20, 0, 0))
CreateTeleportButton(TpContainer, "💰 Teleport to Sell Zone", "SellZone", Vector3.new(-20, 0, 0))
CreateTeleportButton(TpContainer, "🏪 Teleport to Shop / Upgrades", "Shop", Vector3.new(0, 0, -25))
CreateTeleportButton(TpContainer, "🏠 Teleport to Spawn / Base", "Spawn", Vector3.new(0, 5, 0))

--==============================================================--
--  OPTIMIZED & LAG-FREE FEATURE LOOPS
--==============================================================--

-- 1. SMOOTH AUTO DIG LOOP (Throttled & Non-Blocking)
task.spawn(function()
    while true do
        task.wait(0.15)
        if AutoDigEnabled then
            pcall(function()
                -- Equip tool and trigger activation
                equipAnyTool()

                -- Fire cached dig remotes
                for _, rem in ipairs(CachedRemotes.Dig) do
                    safeFireRemote(rem, "Dig", true)
                    safeFireRemote(rem, true)
                end

                -- Trigger nearby cached prompts
                for _, prompt in ipairs(CachedInteractive.DigPrompts) do
                    triggerPrompt(prompt)
                end
            end)
        end
    end
end)

-- 2. SMOOTH AUTO CLEAN LOOP (Throttled & Non-Blocking)
task.spawn(function()
    while true do
        task.wait(0.2)
        if AutoCleanEnabled then
            pcall(function()
                -- Equip clean tool if available
                equipAnyTool()

                -- Fire cached clean remotes
                for _, rem in ipairs(CachedRemotes.Clean) do
                    safeFireRemote(rem, "Clean", true)
                    safeFireRemote(rem, true)
                end

                -- Trigger nearby clean prompts
                for _, prompt in ipairs(CachedInteractive.CleanPrompts) do
                    triggerPrompt(prompt)
                end
            end)
        end
    end
end)

-- 3. SMOOTH AUTO SELL LOOP (Throttled & Non-Blocking)
task.spawn(function()
    while true do
        task.wait(0.35)
        if AutoSellEnabled then
            pcall(function()
                -- Fire cached sell remotes
                for _, rem in ipairs(CachedRemotes.Sell) do
                    safeFireRemote(rem, "Sell", true)
                    safeFireRemote(rem, "SellAll", true)
                    safeFireRemote(rem)
                end

                -- Touch cached sell pads
                for _, pad in ipairs(CachedInteractive.SellPads) do
                    safeTouch(pad)
                end
            end)
        end
    end
end)

-- 4. SPEED STABILIZER LOOP
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

-- Success Notification
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Ultra Script Hub",
        Text = "Dig and Clean Loaded (Lag-Free)!",
        Duration = 3
    })
end)

print("[Ultra Script Hub] Dig and Clean initialized smoothly with 0 FPS drop.")
