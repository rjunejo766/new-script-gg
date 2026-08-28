--==============================================================--
--  ULTRA SCRIPT HUB - Made by Junejo
--  Game: Clean all the leaves
--  GitHub: https://github.com/rjunejo766/new-script-gg
--  Raw: https://raw.githubusercontent.com/rjunejo766/new-script-gg/main/CleanAllTheLeaves.lua
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

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10) or LocalPlayer:FindFirstChildOfClass("PlayerGui")

-- Feature Toggle States
local AutoFarmEnabled = false
local InstantPickupEnabled = false
local AutoSellEscapeEnabled = false
local InfJumpEnabled = false
local SpeedBoostEnabled = false

--==============================================================--
--  GUI CREATION (Instant Priority Render in PlayerGui & CoreGui)
--==============================================================--

-- Clean old instances
pcall(function()
    if PlayerGui and PlayerGui:FindFirstChild("UltraScriptHub_CleanAllTheLeaves") then
        PlayerGui:FindFirstChild("UltraScriptHub_CleanAllTheLeaves"):Destroy()
    end
end)
pcall(function()
    if CoreGui and CoreGui:FindFirstChild("UltraScriptHub_CleanAllTheLeaves") then
        CoreGui:FindFirstChild("UltraScriptHub_CleanAllTheLeaves"):Destroy()
    end
end)
pcall(function()
    if gethui and gethui():FindFirstChild("UltraScriptHub_CleanAllTheLeaves") then
        gethui():FindFirstChild("UltraScriptHub_CleanAllTheLeaves"):Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraScriptHub_CleanAllTheLeaves"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999
ScreenGui.Enabled = true

-- Main Outer Frame (Exact Screenshot Styling)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 310, 0, 270)
MainFrame.Position = UDim2.new(0.5, -155, 0.35, -135)
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

-- Floating Open/Close Button (⚡)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "FloatingToggle"
ToggleBtn.Size = UDim2.new(0, 38, 0, 38)
ToggleBtn.Position = UDim2.new(0, 15, 0.5, -19)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
ToggleBtn.BorderColor3 = Color3.fromRGB(0, 170, 255)
ToggleBtn.BorderSizePixel = 1
ToggleBtn.Text = "⚡"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
ToggleBtn.TextSize = 18
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
HeaderTitle.Text = "CLEAN ALL THE LEAVES"
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

-- Content Container
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -32, 0, 155)
Container.Position = UDim2.new(0, 16, 0, 45)
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
FooterTitle.Position = UDim2.new(0, 0, 1, -42)
FooterTitle.BackgroundTransparency = 1
FooterTitle.Text = "ULTRA SCRIPT HUB"
FooterTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
FooterTitle.TextSize = 16
FooterTitle.Font = Enum.Font.SourceSansBold
FooterTitle.ZIndex = 11
FooterTitle.Parent = MainFrame

local FooterSub = Instance.new("TextLabel")
FooterSub.Size = UDim2.new(1, 0, 0, 16)
FooterSub.Position = UDim2.new(0, 0, 1, -22)
FooterSub.BackgroundTransparency = 1
FooterSub.Text = "Made by Junejo"
FooterSub.TextColor3 = Color3.fromRGB(150, 150, 150)
FooterSub.TextSize = 12
FooterSub.Font = Enum.Font.SourceSans
FooterSub.ZIndex = 11
FooterSub.Parent = MainFrame

-- Checkbox Row Generator (Exact visual match with user's design)
local function CreateToggleRow(name, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 26)
    Row.BackgroundTransparency = 1
    Row.ZIndex = 12
    Row.Parent = Container

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -35, 1, 0)
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
-- ADD ALL 5 FEATURES TO GUI
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
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = state and 50 or 16
        end
    end)
end)

-- Safe Parenting (Guarantees visible rendering on ALL mobile and PC executors)
local parented = false
pcall(function()
    if gethui then
        ScreenGui.Parent = gethui()
        parented = true
    end
end)
if not parented or not ScreenGui.Parent then
    pcall(function()
        ScreenGui.Parent = PlayerGui
        parented = true
    end)
end
if not parented or not ScreenGui.Parent then
    pcall(function()
        ScreenGui.Parent = CoreGui
    end)
end

-- Notify user on screen
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Ultra Script Hub",
        Text = "Clean All The Leaves Loaded!",
        Duration = 3
    })
end)

--==============================================================--
--  BACKGROUND FEATURES ENGINE
--==============================================================--

-- Anti-AFK Setup
task.spawn(function()
    pcall(function()
        local VirtualUser = game:GetService("VirtualUser")
        LocalPlayer.Idled:Connect(function()
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end)
    end)
end)

-- Infinite Jump Listener
UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled then
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)

-- Speed Boost Character Handler
LocalPlayer.CharacterAdded:Connect(function(char)
    pcall(function()
        local hum = char:WaitForChild("Humanoid", 5)
        if hum and SpeedBoostEnabled then
            hum.WalkSpeed = 50
        end
    end)
end)

local function getRoot()
    local char = LocalPlayer.Character
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char.PrimaryPart)
end

local function getHum()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function equipTool()
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

-- Dynamic Remote Search
local function findRemotes(keywords)
    local results = {}
    pcall(function()
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
    end)
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

-- 1. FEATURE: AUTO FARM
task.spawn(function()
    while true do
        task.wait(0.15)
        if AutoFarmEnabled then
            pcall(function()
                equipTool()
                local root = getRoot()
                local char = LocalPlayer.Character

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

                for _, rem in ipairs(CleanRemotes) do
                    safeFireRemote(rem, "Clean", true)
                    safeFireRemote(rem, root and root.Position or Vector3.new())
                end

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

-- 2. FEATURE: INSTANT PICKUP
task.spawn(function()
    while true do
        task.wait(0.05)
        if InstantPickupEnabled then
            pcall(function()
                local root = getRoot()

                for _, rem in ipairs(PickupRemotes) do
                    safeFireRemote(rem, true)
                end

                for _, prompt in ipairs(Workspace:GetDescendants()) do
                    if not InstantPickupEnabled then break end
                    if prompt:IsA("ProximityPrompt") then
                        prompt.HoldDuration = 0
                        if fireproximityprompt then
                            fireproximityprompt(prompt, 0)
                        end
                    end
                end

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

-- 3. FEATURE: AUTO SELL & ESCAPE
task.spawn(function()
    while true do
        task.wait(0.8)
        if AutoSellEscapeEnabled then
            pcall(function()
                local root = getRoot()

                for _, rem in ipairs(SellRemotes) do
                    safeFireRemote(rem, "Sell")
                    safeFireRemote(rem, "Deposit")
                    safeFireRemote(rem, "Escape")
                    safeFireRemote(rem, true)
                end

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

                if PlayerGui then
                    for _, btn in ipairs(PlayerGui:GetDescendants()) do
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
