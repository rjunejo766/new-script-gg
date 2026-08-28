--==============================================================--
--  ULTRA SCRIPT HUB - Made by Junejo
--  Game: Clean all the leaves
--  Game Link: https://www.roblox.com/games/92637789841354/Clean-all-the-leaves
--  Version: 2.0 (Pixel-Perfect Ultra Script Hub UI & Guaranteed Functions)
--==============================================================--

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local VirtualUser = nil
pcall(function() VirtualUser = game:GetService("VirtualUser") end)

local VirtualInputManager = nil
pcall(function() VirtualInputManager = game:GetService("VirtualInputManager") end)

-- Feature Toggle States
local AutoFarmEnabled = false
local InstantPickupEnabled = false
local AutoSellEscapeEnabled = false
local InfJumpEnabled = false
local SpeedBoostEnabled = false

-- Anti-AFK Setup
pcall(function()
    LocalPlayer.Idled:Connect(function()
        if VirtualUser then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end)
end)

-- Infinite Jump Listener
UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Speed Boost Character Handler
LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum and SpeedBoostEnabled then
        hum.WalkSpeed = 50
    end
end)

--==============================================================--
--  GUI CREATION (Pixel-Perfect ULTRA SCRIPT HUB Design)
--==============================================================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraScriptHub_CleanAllTheLeaves"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999

-- Clean previous instances
pcall(function()
    if CoreGui and CoreGui:FindFirstChild("UltraScriptHub_CleanAllTheLeaves") then
        CoreGui:FindFirstChild("UltraScriptHub_CleanAllTheLeaves"):Destroy()
    end
    local lpGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if lpGui and lpGui:FindFirstChild("UltraScriptHub_CleanAllTheLeaves") then
        lpGui:FindFirstChild("UltraScriptHub_CleanAllTheLeaves"):Destroy()
    end
end)

local parentGui = nil
if gethui then 
    pcall(function() parentGui = gethui() end) 
end
if not parentGui then 
    pcall(function() parentGui = CoreGui end) 
end
if not parentGui then 
    pcall(function()
        parentGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
    end) 
end

pcall(function()
    ScreenGui.Parent = parentGui or CoreGui
end)
if not ScreenGui.Parent then
    pcall(function()
        ScreenGui.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    end)
end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 270)
MainFrame.Position = UDim2.new(0.5, -160, 0.35, -135)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Floating Toggle Button (⚡) for Mobile & Easy Minimize/Open
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
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Header Title
local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -50, 0, 35)
HeaderTitle.Position = UDim2.new(0, 16, 0, 10)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "CLEAN ALL THE LEAVES"
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
Container.Position = UDim2.new(0, 16, 0, 48)
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

-- Checkbox Row Generator (Exact visual match with screenshot)
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

----------------------------------------------------------------
-- ADD EXACT REQUESTED FEATURES TO GUI
----------------------------------------------------------------
CreateToggleRow("Auto Farm", function(state)
    AutoFarmEnabled = state
end)

CreateToggleRow("Instant Pickup", function(state)
    InstantPickupEnabled = state
end)

CreateToggleRow("Auto Sell & Escape", function(state)
    AutoSellEscapeEnabled = state
end)

CreateToggleRow("Infinite Jump", function(state)
    InfJumpEnabled = state
end)

CreateToggleRow("Speed Boost (50)", function(state)
    SpeedBoostEnabled = state
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = state and 50 or 16
    end
end)

----------------------------------------------------------------
-- HELPER FUNCTIONS (Character, Remotes, Prompts)
----------------------------------------------------------------
local function getChar()
    return LocalPlayer.Character
end

local function getRoot()
    local char = LocalPlayer.Character
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char.PrimaryPart)
end

local function getHum()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function equipTool()
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if not char or not backpack then return end
    if not char:FindFirstChildOfClass("Tool") then
        local tool = backpack:FindFirstChildOfClass("Tool")
        if tool and getHum() then
            getHum():EquipTool(tool)
        end
    end
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

-- Dynamic Remote Search
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
    scan(Workspace)
    return results
end

local CleanRemotes = {}
local PickupRemotes = {}
local SellRemotes = {}

local function refreshRemotes()
    CleanRemotes = findRemotes({"clean", "rake", "sweep", "blow", "vacuum", "destroy", "cut", "leaf", "leaves", "farm"})
    PickupRemotes = findRemotes({"pickup", "pick", "collect", "grab", "item", "take", "bag", "drop"})
    SellRemotes = findRemotes({"sell", "cash", "deposit", "convert", "exchange", "escape", "exit", "door", "finish", "teleport"})
end
pcall(refreshRemotes)

----------------------------------------------------------------
-- 1. FEATURE: AUTO FARM (Leaves Rake / Vacuum / Sweep)
----------------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0.15)
        if AutoFarmEnabled then
            pcall(function()
                equipTool()
                local root = getRoot()
                local char = getChar()

                -- 1. Activate equipped tool
                if char then
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                        for _, child in ipairs(tool:GetDescendants()) do
                            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                                safeFireRemote(child, root and root.Position or Vector3.new())
                            end
                        end
                    end
                end

                -- 2. Fire clean/leaf game remotes
                for _, rem in ipairs(CleanRemotes) do
                    safeFireRemote(rem, "Clean", true)
                    safeFireRemote(rem, root and root.Position or Vector3.new())
                end

                -- 3. Search and clean nearby leaf objects / piles in Workspace
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not AutoFarmEnabled then break end
                    local n = obj.Name:lower()
                    if n:find("leaf") or n:find("leaves") or n:find("pile") or n:find("dirt") or n:find("trash") or n:find("grass") then
                        if obj:IsA("BasePart") and root then
                            if (obj.Position - root.Position).Magnitude < 45 then
                                if firetouchinterest then
                                    firetouchinterest(root, obj, 0)
                                    task.wait(0.01)
                                    firetouchinterest(root, obj, 1)
                                end
                            end
                        elseif obj:IsA("Model") then
                            local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                            if part and root and (part.Position - root.Position).Magnitude < 45 then
                                if firetouchinterest then
                                    firetouchinterest(root, part, 0)
                                    task.wait(0.01)
                                    firetouchinterest(root, part, 1)
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
-- 2. FEATURE: INSTANT PICKUP (Fast ProximityPrompts & TouchDrops)
----------------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0.05)
        if InstantPickupEnabled then
            pcall(function()
                local root = getRoot()

                -- 1. Fire pickup remotes
                for _, rem in ipairs(PickupRemotes) do
                    safeFireRemote(rem, true)
                end

                -- 2. Sweep all ProximityPrompts (Instant trigger)
                for _, prompt in ipairs(Workspace:GetDescendants()) do
                    if not InstantPickupEnabled then break end
                    if prompt:IsA("ProximityPrompt") then
                        prompt.HoldDuration = 0
                        if fireproximityprompt then
                            fireproximityprompt(prompt, 0)
                        end
                    end
                end

                -- 3. Instant Touch items / Drops / Coins / Leaves
                for _, drop in ipairs(Workspace:GetDescendants()) do
                    if not InstantPickupEnabled then break end
                    if drop:IsA("TouchTransmitter") and drop.Parent and drop.Parent:IsA("BasePart") and root then
                        local part = drop.Parent
                        if firetouchinterest then
                            firetouchinterest(root, part, 0)
                            firetouchinterest(root, part, 1)
                        end
                    end
                end
            end)
        end
    end
end)

----------------------------------------------------------------
-- 3. FEATURE: AUTO SELL & ESCAPE (Auto Deposit, Sell & Escape)
----------------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0.8)
        if AutoSellEscapeEnabled then
            pcall(function()
                local root = getRoot()

                -- 1. Fire all sell & escape remotes
                for _, rem in ipairs(SellRemotes) do
                    safeFireRemote(rem, "Sell")
                    safeFireRemote(rem, "Deposit")
                    safeFireRemote(rem, "Escape")
                    safeFireRemote(rem, true)
                end

                -- 2. Locate Sell Zones, Deposit Bins, Escape / Exit Doors
                for _, zone in ipairs(Workspace:GetDescendants()) do
                    if not AutoSellEscapeEnabled then break end
                    local n = zone.Name:lower()
                    if n:find("sell") or n:find("deposit") or n:find("bin") or n:find("dropoff") or n:find("truck") or n:find("escape") or n:find("exit") or n:find("portal") or n:find("finish") then
                        if zone:IsA("BasePart") and root then
                            if firetouchinterest then
                                firetouchinterest(root, zone, 0)
                                task.wait(0.02)
                                firetouchinterest(root, zone, 1)
                            end
                        elseif zone:IsA("Model") then
                            local part = zone.PrimaryPart or zone:FindFirstChildWhichIsA("BasePart")
                            if part and root and firetouchinterest then
                                firetouchinterest(root, part, 0)
                                task.wait(0.02)
                                firetouchinterest(root, part, 1)
                            end
                        end
                    end
                end

                -- 3. Auto click sell / cash buttons in PlayerGui
                local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                if pGui then
                    for _, btn in ipairs(pGui:GetDescendants()) do
                        if btn:IsA("TextButton") or btn:IsA("ImageButton") then
                            local txt = btn.Name:lower() .. " " .. (btn:IsA("TextButton") and btn.Text:lower() or "")
                            if txt:find("sell") or txt:find("deposit") or txt:find("escape") then
                                pcall(function()
                                    if getconnections then
                                        for _, conn in ipairs(getconnections(btn.MouseButton1Click)) do
                                            conn:Fire()
                                        end
                                    end
                                end)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Send loaded notification
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Ultra Script Hub",
        Text = "Clean All The Leaves loaded successfully!",
        Duration = 3
    })
end)
