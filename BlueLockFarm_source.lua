--==============================================================--
--  ULTRA SCRIPT HUB - Made by Junejo
--  Game: Blue Lock Farm
--  Game Link: https://www.roblox.com/games/132767904294856/Blue-Lock-Farm
--  Version: 1.0 (Auto Collect, Auto Roll Lockers, Auto Upgrade, Auto Redeem, Speed & Jump)
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

-- Feature Toggle States (5 Selected Features)
local AutoCollectCashEnabled = false
local AutoRollLockersEnabled = false
local AutoUpgradeEnabled = false
local AutoRedeemEnabled = false
local SpeedJumpEnabled = false

local NormalSpeed = 16
local BoostSpeed = 50

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
-- GUI CREATION (Ultra Script Hub Signature Dark/Neon UI)
----------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraScriptHub_BlueLockFarm"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999
ScreenGui.IgnoreGuiInset = true

-- Clean previous instances
pcall(function()
    if gethui and gethui():FindFirstChild("UltraScriptHub_BlueLockFarm") then
        gethui():FindFirstChild("UltraScriptHub_BlueLockFarm"):Destroy()
    end
end)
pcall(function()
    if CoreGui and CoreGui:FindFirstChild("UltraScriptHub_BlueLockFarm") then
        CoreGui:FindFirstChild("UltraScriptHub_BlueLockFarm"):Destroy()
    end
end)
pcall(function()
    local pgui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if pgui and pgui:FindFirstChild("UltraScriptHub_BlueLockFarm") then
        pgui:FindFirstChild("UltraScriptHub_BlueLockFarm"):Destroy()
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

-- Main Outer Frame (Sized for 5 Features)
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
UIStroke.Color = Color3.fromRGB(0, 160, 255)
UIStroke.Thickness = 1.2
UIStroke.Parent = MainFrame

-- Header Title
local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -50, 0, 35)
HeaderTitle.Position = UDim2.new(0, 16, 0, 8)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "BLUE LOCK FARM"
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
    CheckIcon.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
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
            Checkbox.BorderColor3 = Color3.fromRGB(0, 170, 255)
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
-- HELPER FUNCTIONS & EXPLOIT WRAPPERS
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

-- Fire Touch Interest compatibility wrapper
local function touch(targetPart)
    local root = getRoot()
    if not root or not targetPart then return end
    pcall(function()
        if firetouchinterest then
            firetouchinterest(root, targetPart, 0)
            task.wait()
            firetouchinterest(root, targetPart, 1)
        else
            -- Fallback teleport method
            targetPart.CFrame = root.CFrame
        end
    end)
end

-- Fire Proximity Prompt compatibility wrapper
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

-- Safe Remote caller
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

-- Respawn hook for Speed
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
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

-- 1. Auto Collect Cash & Balls (Instant Magnet)
CreateToggleRow("Auto Collect Cash / Balls", function(state)
    AutoCollectCashEnabled = state
    if AutoCollectCashEnabled then
        task.spawn(function()
            while AutoCollectCashEnabled do
                pcall(function()
                    local root = getRoot()
                    if not root then return end

                    -- Touch and collect dropped cash / coins / balls in Workspace
                    for _, item in ipairs(Workspace:GetDescendants()) do
                        if not AutoCollectCashEnabled then break end
                        if item:IsA("BasePart") then
                            local name = item.Name:lower()
                            if name:find("cash") or name:find("coin") or name:find("money") or name:find("drop") or name:find("ball") or name:find("token") or name:find("yen") then
                                touch(item)
                            end
                        elseif item:IsA("TouchTransmitter") and item.Parent and item.Parent:IsA("BasePart") then
                            local parentName = item.Parent.Name:lower()
                            if parentName:find("collect") or parentName:find("cash") or parentName:find("money") or parentName:find("drop") or parentName:find("deposit") then
                                touch(item.Parent)
                            end
                        end
                    end

                    -- Fire collect remotes if present
                    local collectRemotes = findRemotes({"collect", "claimcash", "pickup", "deposit", "claimdrop"})
                    for _, rem in ipairs(collectRemotes) do
                        safeFireRemote(rem)
                    end
                end)
                task.wait(0.4)
            end
        end)
    end
end)

-- 2. Auto Roll / Open Lockers
CreateToggleRow("Auto Roll Lockers (Gacha)", function(state)
    AutoRollLockersEnabled = state
    if AutoRollLockersEnabled then
        task.spawn(function()
            while AutoRollLockersEnabled do
                pcall(function()
                    -- Method A: Trigger Locker ProximityPrompts
                    for _, prompt in ipairs(Workspace:GetDescendants()) do
                        if not AutoRollLockersEnabled then break end
                        if prompt:IsA("ProximityPrompt") then
                            local pName = prompt.Name:lower()
                            local parName = prompt.Parent and prompt.Parent.Name:lower() or ""
                            if pName:find("roll") or pName:find("open") or pName:find("locker") or pName:find("gacha") or parName:find("locker") or parName:find("roll") then
                                activatePrompt(prompt)
                            end
                        end
                    end

                    -- Method B: Fire Roll / Locker Remotes
                    local rollRemotes = findRemotes({"roll", "openlocker", "buylocker", "spin", "draw", "summon", "openbox"})
                    for _, rem in ipairs(rollRemotes) do
                        safeFireRemote(rem, 1)
                        safeFireRemote(rem, "Basic")
                        safeFireRemote(rem, "Locker")
                    end
                end)
                task.wait(0.6)
            end
        end)
    end
end)

-- 3. Auto Upgrade Multipliers / Field
CreateToggleRow("Auto Upgrade Multipliers", function(state)
    AutoUpgradeEnabled = state
    if AutoUpgradeEnabled then
        task.spawn(function()
            while AutoUpgradeEnabled do
                pcall(function()
                    local root = getRoot()

                    -- Trigger upgrade buttons in plot/workspace
                    for _, item in ipairs(Workspace:GetDescendants()) do
                        if not AutoUpgradeEnabled then break end
                        if item:IsA("ProximityPrompt") then
                            local pName = item.Name:lower()
                            local parName = item.Parent and item.Parent.Name:lower() or ""
                            if pName:find("upgrade") or pName:find("buy") or parName:find("upgrade") or parName:find("multiplier") or parName:find("converter") then
                                activatePrompt(item)
                            end
                        elseif item:IsA("TouchTransmitter") and item.Parent and item.Parent:IsA("BasePart") then
                            local parName = item.Parent.Name:lower()
                            if parName:find("upgrade") or parName:find("multiplier") or parName:find("converter") or parName:find("speed") or parName:find("boost") then
                                touch(item.Parent)
                            end
                        end
                    end

                    -- Trigger Upgrade Remotes
                    local upgradeRemotes = findRemotes({"upgrade", "buymultiplier", "levelmultiplier", "buystat", "upgradeconverter"})
                    for _, rem in ipairs(upgradeRemotes) do
                        safeFireRemote(rem)
                        safeFireRemote(rem, "Multiplier")
                        safeFireRemote(rem, 1)
                    end
                end)
                task.wait(0.8)
            end
        end)
    end
end)

-- 4. Auto Redeem Codes & Free Gifts
CreateToggleRow("Auto Redeem Codes & Gifts", function(state)
    AutoRedeemEnabled = state
    if AutoRedeemEnabled then
        task.spawn(function()
            local activeCodes = {
                "WEATHER",
                "COMMUNITY",
                "RELEASE",
                "BLUELOCK",
                "UPDATE1",
                "SOCCER",
                "GOAL",
                "FREE"
            }

            pcall(function()
                -- Code Remotes
                local codeRemotes = findRemotes({"code", "redeem", "redeemcode", "claimcode"})
                for _, rem in ipairs(codeRemotes) do
                    for _, code in ipairs(activeCodes) do
                        safeFireRemote(rem, code)
                        task.wait(0.1)
                    end
                end

                -- Claim Playtime / Daily Gift Remotes
                local giftRemotes = findRemotes({"claimdaily", "claimgift", "playtimereward", "freegift", "claimplaytime"})
                for _, rem in ipairs(giftRemotes) do
                    for i = 1, 12 do
                        safeFireRemote(rem, i)
                        safeFireRemote(rem, tostring(i))
                    end
                end
            end)
        end)
    end
end)

-- 5. Speed Boost (50) & Infinite Jump
CreateToggleRow("Speed (50) + Infinite Jump", function(state)
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

