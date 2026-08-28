--==============================================================--
--  ULTRA SCRIPT HUB - Made by Junejo
--  Game: Throw an Anime Coin
--  Game Link: https://www.roblox.com/games/105198923939638/Throw-an-Anime-Coin
--  Version: 1.0 (Auto Upgrade, Fast Throw, Collect Cash, Auto Sell)
--==============================================================--

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()


-- Feature Toggle States (Exact 4 Features)
local AutoUpgradeEnabled = false
local FastThrowEnabled = false
local CollectCashEnabled = false
local AutoSellEnabled = false

-- Anti-AFK Setup
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
-- GUI CREATION (100% Guaranteed Screen Display)
----------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraScriptHub_ThrowAnAnimeCoin"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999
ScreenGui.IgnoreGuiInset = true

-- Clean previous instances
pcall(function()
    if gethui and gethui():FindFirstChild("UltraScriptHub_ThrowAnAnimeCoin") then
        gethui():FindFirstChild("UltraScriptHub_ThrowAnAnimeCoin"):Destroy()
    end
end)
pcall(function()
    if CoreGui and CoreGui:FindFirstChild("UltraScriptHub_ThrowAnAnimeCoin") then
        CoreGui:FindFirstChild("UltraScriptHub_ThrowAnAnimeCoin"):Destroy()
    end
end)
pcall(function()
    local pgui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if pgui and pgui:FindFirstChild("UltraScriptHub_ThrowAnAnimeCoin") then
        pgui:FindFirstChild("UltraScriptHub_ThrowAnAnimeCoin"):Destroy()
    end
end)

-- Safe UI Parent Selection
local guiParent = nil
if gethui then
    pcall(function() guiParent = gethui() end)
end
if not guiParent then
    pcall(function()
        guiParent = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
    end)
end
if not guiParent then
    pcall(function() guiParent = CoreGui end)
end

ScreenGui.Parent = guiParent

-- Main Outer Frame (Compact & Centered for 4 Features)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 275)
MainFrame.Position = UDim2.new(0.5, -160, 0.4, -137)
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

-- Header Title
local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -50, 0, 35)
HeaderTitle.Position = UDim2.new(0, 16, 0, 10)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "THROW AN ANIME COIN"
HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitle.TextSize = 14
HeaderTitle.Font = Enum.Font.SourceSansBold
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.ZIndex = 11
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
CloseBtn.ZIndex = 11
CloseBtn.Parent = MainFrame

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Content Container
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -32, 0, 155)
Container.Position = UDim2.new(0, 16, 0, 50)
Container.BackgroundTransparency = 1
Container.ZIndex = 11
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
    Label.TextColor3 = Color3.fromRGB(220, 220, 225)
    Label.TextSize = 14
    Label.Font = Enum.Font.SourceSansBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 13
    Label.Parent = Row

    local Checkbox = Instance.new("TextButton")
    Checkbox.Size = UDim2.new(0, 22, 0, 22)
    Checkbox.Position = UDim2.new(1, -24, 0.5, -11)
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
-- ADD EXACT 4 REQUESTED FEATURES TO GUI
----------------------------------------------------------------
CreateToggleRow("Auto Upgrade", function(state)
    AutoUpgradeEnabled = state
end)

CreateToggleRow("Fast Throw", function(state)
    FastThrowEnabled = state
end)

CreateToggleRow("Collect Cash", function(state)
    CollectCashEnabled = state
end)

CreateToggleRow("Auto Sell", function(state)
    AutoSellEnabled = state
end)

----------------------------------------------------------------
-- HELPER FUNCTIONS (Character, Tools, Remotes)
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

local function equipCoinTool()
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if not char or not backpack then return end
    
    if not char:FindFirstChildOfClass("Tool") then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local hum = getHum()
                if hum then
                    hum:EquipTool(tool)
                    break
                end
            end
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

local UpgradeRemotes = {}
local ThrowRemotes = {}
local CashRemotes = {}
local SellRemotes = {}

local function refreshRemotes()
    UpgradeRemotes = findRemotes({"upgrade", "buy", "luck", "power", "speed", "stat", "multiplier", "fountain"})
    ThrowRemotes = findRemotes({"throw", "toss", "fountain", "coin", "drop", "cast", "shoot", "flip"})
    CashRemotes = findRemotes({"collect", "claim", "cash", "money", "reward", "coin", "token", "drop", "pickup"})
    SellRemotes = findRemotes({"sell", "sellall", "cashout", "exchange", "deposit", "convert"})
end
pcall(refreshRemotes)

----------------------------------------------------------------
-- 1. FEATURE: AUTO UPGRADE
----------------------------------------------------------------
task.spawn(function()
    local upgradeTypes = {
        "Luck", "CoinPower", "ThrowSpeed", "CoinCapacity",
        "Multiplier", "FountainLuck", "Magnet", "MoreCash",
        "1", "2", "3", "4", "5"
    }

    while true do
        task.wait(0.8)
        if AutoUpgradeEnabled then
            pcall(function()
                -- 1. Fire detected upgrade remotes
                for _, rem in ipairs(UpgradeRemotes) do
                    for _, upg in ipairs(upgradeTypes) do
                        safeFireRemote(rem, upg)
                        safeFireRemote(rem, "Upgrade", upg)
                        safeFireRemote(rem, "Buy", upg)
                    end
                end

                -- 2. Trigger in-game Upgrade buttons / Shop GUIs
                local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                if pGui then
                    for _, btn in ipairs(pGui:GetDescendants()) do
                        if btn:IsA("TextButton") or btn:IsA("ImageButton") then
                            local txt = btn.Name:lower() .. " " .. (btn:IsA("TextButton") and btn.Text:lower() or "")
                            if txt:find("upgrade") or txt:find("buy") or txt:find("luck") or txt:find("level up") then
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

----------------------------------------------------------------
-- 2. FEATURE: FAST THROW (Auto Coin Throwing into Fountain)
----------------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0.08)
        if FastThrowEnabled then
            pcall(function()
                equipCoinTool()
                local char = LocalPlayer.Character
                local root = getRoot()

                -- 1. Activate equipped tool
                if char then
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                        for _, child in ipairs(tool:GetDescendants()) do
                            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                                safeFireRemote(child, root and root.Position or Vector3.new(), 100)
                            end
                        end
                    end
                end

                -- 2. Fire throw remotes with max power (100%)
                for _, rem in ipairs(ThrowRemotes) do
                    safeFireRemote(rem, 100, true)
                    safeFireRemote(rem, "Throw", 100)
                    safeFireRemote(rem, root and root.Position or Vector3.new())
                end

                -- 3. Trigger Fountain ProximityPrompts
                for _, fountain in ipairs(Workspace:GetDescendants()) do
                    if not FastThrowEnabled then break end
                    local n = fountain.Name:lower()
                    if n:find("fountain") or n:find("well") or n:find("throw") or n:find("pool") or n:find("coin") then
                        if fountain:IsA("ProximityPrompt") then
                            fountain.HoldDuration = 0
                            if fireproximityprompt then
                                fireproximityprompt(fountain, 0)
                            end
                        elseif fountain:IsA("BasePart") and root then
                            if firetouchinterest and (fountain.Position - root.Position).Magnitude < 35 then
                                firetouchinterest(root, fountain, 0)
                                task.wait(0.01)
                                firetouchinterest(root, fountain, 1)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

----------------------------------------------------------------
-- 3. FEATURE: COLLECT CASH (Vacuum Floating Cash & Plot Drops)
----------------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0.15)
        if CollectCashEnabled then
            pcall(function()
                local root = getRoot()

                -- 1. Fire collect remotes
                for _, rem in ipairs(CashRemotes) do
                    safeFireRemote(rem, true)
                    safeFireRemote(rem, "Collect")
                    safeFireRemote(rem, "ClaimAll")
                end

                -- 2. Sweep all cash drops / plot figure earnings map-wide
                for _, drop in ipairs(Workspace:GetDescendants()) do
                    if not CollectCashEnabled then break end
                    local n = drop.Name:lower()
                    if n:find("cash") or n:find("coin") or n:find("money") or n:find("gem") or n:find("dollar") or n:find("reward") or n:find("drop") then
                        if drop:IsA("BasePart") and root then
                            if firetouchinterest then
                                firetouchinterest(root, drop, 0)
                                firetouchinterest(root, drop, 1)
                            end
                        elseif drop:IsA("Model") then
                            local part = drop.PrimaryPart or drop:FindFirstChildWhichIsA("BasePart")
                            if part and root and firetouchinterest then
                                firetouchinterest(root, part, 0)
                                firetouchinterest(root, part, 1)
                            end
                        elseif drop:IsA("ProximityPrompt") then
                            drop.HoldDuration = 0
                            if fireproximityprompt then
                                fireproximityprompt(drop, 0)
                            end
                        end
                    elseif drop:IsA("TouchTransmitter") and drop.Parent and drop.Parent:IsA("BasePart") and root then
                        if firetouchinterest then
                            firetouchinterest(root, drop.Parent, 0)
                            firetouchinterest(root, drop.Parent, 1)
                        end
                    end
                end
            end)
        end
    end
end)

----------------------------------------------------------------
-- 4. FEATURE: AUTO SELL (Figures / Inventory / Coins)
----------------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(1.0)
        if AutoSellEnabled then
            pcall(function()
                local root = getRoot()

                -- 1. Fire sell remotes
                for _, rem in ipairs(SellRemotes) do
                    safeFireRemote(rem, "SellAll")
                    safeFireRemote(rem, "Sell")
                    safeFireRemote(rem, true)
                end

                -- 2. Touch Sell pads / Merchant / Cashout zones
                for _, zone in ipairs(Workspace:GetDescendants()) do
                    if not AutoSellEnabled then break end
                    local n = zone.Name:lower()
                    if n:find("sell") or n:find("merchant") or n:find("shop") or n:find("cashout") then
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

                -- 3. Click GUI Sell buttons
                local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                if pGui then
                    for _, btn in ipairs(pGui:GetDescendants()) do
                        if btn:IsA("TextButton") or btn:IsA("ImageButton") then
                            local txt = btn.Name:lower() .. " " .. (btn:IsA("TextButton") and btn.Text:lower() or "")
                            if txt:find("sell") or txt:find("sell all") then
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
