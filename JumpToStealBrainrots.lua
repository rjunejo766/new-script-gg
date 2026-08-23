-- ULTRA SCRIPT HUB - Made by Junejo
-- Game: Jump to Steal Brainrots

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- State Variables
local AutoSteal = false
local AutoCollectCash = false
local AutoRebirth = false
local AutoUpgrade = false
local SpeedBoostEnabled = false
local InfJumpEnabled = false

local NormalSpeed = 16
local BoostSpeed = 50

-- Respawn Handler
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
    if SpeedBoostEnabled then
        Humanoid.WalkSpeed = BoostSpeed
    end
end)

----------------------------------------------------------------
-- Helper Functions: Player Base & Brainrot Detection
----------------------------------------------------------------

-- Find the Local Player's Personal Base / Plot
local function getMyBase()
    local playerName = LocalPlayer.Name
    local userId = LocalPlayer.UserId

    -- Common Base folder names
    local baseContainers = {
        workspace:FindFirstChild("Plots"),
        workspace:FindFirstChild("Bases"),
        workspace:FindFirstChild("Tycoons"),
        workspace:FindFirstChild("Houses"),
        workspace:FindFirstChild("Islands")
    }

    for _, container in ipairs(baseContainers) do
        if container then
            for _, plot in ipairs(container:GetChildren()) do
                local owner = plot:FindFirstChild("Owner") or plot:FindFirstChild("OwnerValue") or plot:FindFirstChild("Player")
                if owner then
                    if owner.Value == LocalPlayer or owner.Value == playerName or tostring(owner.Value) == tostring(userId) or string.find(string.lower(tostring(owner.Value)), string.lower(playerName)) then
                        return plot
                    end
                end
                -- Check attribute
                if plot:GetAttribute("Owner") == playerName or plot:GetAttribute("OwnerId") == userId then
                    return plot
                end
                -- Check plot name
                if string.find(string.lower(plot.Name), string.lower(playerName)) then
                    return plot
                end
            end
        end
    end

    return nil
end

-- Find the Deposit / Delivery Spot inside My Base
local function getBaseDepositPoint()
    local myBase = getMyBase()
    if myBase then
        -- Search for deposit / drop pad inside base
        for _, obj in ipairs(myBase:GetDescendants()) do
            if obj:IsA("BasePart") then
                local lower = string.lower(obj.Name)
                if string.find(lower, "deposit") or string.find(lower, "drop") or string.find(lower, "delivery") or string.find(lower, "place") or string.find(lower, "spawn") then
                    return obj.Position + Vector3.new(0, 3, 0)
                end
            end
        end
        -- Fallback to base primary part or center
        if myBase.PrimaryPart then
            return myBase.PrimaryPart.Position + Vector3.new(0, 4, 0)
        end
        local centerPart = myBase:FindFirstChildWhichIsA("BasePart")
        if centerPart then
            return centerPart.Position + Vector3.new(0, 4, 0)
        end
    end
    return nil
end

-- Find all Brainrot Spawn Items on the Map
local function getAllBrainrots()
    local brainrots = {}
    local char = LocalPlayer.Character
    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
    local myPos = root and root.Position or Vector3.new(0, 0, 0)

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            if not obj:IsDescendantOf(char) then
                local name = string.lower(obj.Name)
                local parentName = obj.Parent and string.lower(obj.Parent.Name) or ""
                
                -- Check if it's a Brainrot / Item / LuckyBlock
                local isBrainrot = string.find(name, "brainrot") 
                                or string.find(name, "sigma") 
                                or string.find(name, "gigachad") 
                                or string.find(name, "skibidi") 
                                or string.find(name, "item") 
                                or string.find(name, "steal") 
                                or string.find(name, "lucky") 
                                or string.find(name, "block") 
                                or string.find(parentName, "brainrot") 
                                or string.find(parentName, "spawner") 
                                or string.find(parentName, "drops")

                -- Ignore base structures, walls, pads
                if isBrainrot and not string.find(name, "pad") and not string.find(name, "collector") and not string.find(name, "wall") and not string.find(name, "floor") then
                    local targetPart = obj:IsA("BasePart") and obj or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                    if targetPart then
                        table.insert(brainrots, {Instance = obj, Part = targetPart, Position = targetPart.Position})
                    end
                end
            end
        end
    end

    -- Sort by nearest
    table.sort(brainrots, function(a, b)
        return (a.Position - myPos).Magnitude < (b.Position - myPos).Magnitude
    end)

    return brainrots
end

----------------------------------------------------------------
-- GUI Creation (ULTRA SCRIPT HUB Theme)
----------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraScriptHub_Brainrots"
ScreenGui.ResetOnSpawn = false

local parentGui = LocalPlayer:WaitForChild("PlayerGui")
if gethui then
    parentGui = gethui()
elseif game:GetService("CoreGui") then
    parentGui = game:GetService("CoreGui")
end
ScreenGui.Parent = parentGui

-- Main Outer Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 330, 0, 290)
MainFrame.Position = UDim2.new(0.5, -165, 0.35, -145)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Header Title
local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -40, 0, 35)
HeaderTitle.Position = UDim2.new(0, 15, 0, 8)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "JUMP TO STEAL BRAINROTS"
HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitle.TextSize = 13
HeaderTitle.Font = Enum.Font.SourceSansBold
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.Parent = MainFrame

-- Close Button (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 8)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Parent = MainFrame

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Container for Toggles
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -30, 0, 185)
Container.Position = UDim2.new(0, 15, 0, 45)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.Parent = Container

-- Footer Branding
local FooterTitle = Instance.new("TextLabel")
FooterTitle.Size = UDim2.new(1, 0, 0, 18)
FooterTitle.Position = UDim2.new(0, 0, 1, -38)
FooterTitle.BackgroundTransparency = 1
FooterTitle.Text = "ULTRA SCRIPT HUB"
FooterTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
FooterTitle.TextSize = 14
FooterTitle.Font = Enum.Font.SourceSansBold
FooterTitle.Parent = MainFrame

local FooterSub = Instance.new("TextLabel")
FooterSub.Size = UDim2.new(1, 0, 0, 16)
FooterSub.Position = UDim2.new(0, 0, 1, -20)
FooterSub.BackgroundTransparency = 1
FooterSub.Text = "Made by Junejo"
FooterSub.TextColor3 = Color3.fromRGB(150, 150, 150)
FooterSub.TextSize = 12
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
    Label.TextColor3 = Color3.fromRGB(240, 240, 240)
    Label.TextSize = 13
    Label.Font = Enum.Font.SourceSansBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local Checkbox = Instance.new("TextButton")
    Checkbox.Size = UDim2.new(0, 20, 0, 20)
    Checkbox.Position = UDim2.new(1, -23, 0.5, -10)
    Checkbox.BackgroundColor3 = Color3.fromRGB(25, 27, 35)
    Checkbox.BorderColor3 = Color3.fromRGB(50, 55, 70)
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
        callback(toggled)
    end)
end

----------------------------------------------------------------
-- 1. Auto Steal Brainrots
----------------------------------------------------------------
CreateToggleRow("Auto Steal Brainrots", function(state)
    AutoSteal = state
    if AutoSteal then
        task.spawn(function()
            while AutoSteal do
                pcall(function()
                    local char = LocalPlayer.Character
                    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
                    if not root then return end

                    local brainrots = getAllBrainrots()
                    local depositPos = getBaseDepositPoint()

                    if #brainrots > 0 then
                        local target = brainrots[1]
                        local targetPart = target.Part

                        -- Step 1: Teleport to Brainrot / Item
                        root.CFrame = targetPart.CFrame + Vector3.new(0, 2, 0)
                        task.wait(0.1)

                        -- Step 2: Grab / Interact
                        -- Trigger Proximity Prompts
                        for _, prompt in ipairs(target.Instance:GetDescendants()) do
                            if prompt:IsA("ProximityPrompt") then
                                prompt.HoldDuration = 0
                                if fireproximityprompt then
                                    fireproximityprompt(prompt, 0, true)
                                end
                            end
                        end

                        -- Trigger Touch Interest / Collision
                        if firetouchinterest then
                            firetouchinterest(root, targetPart, 0)
                            firetouchinterest(root, targetPart, 1)
                        end

                        -- Fire Steal / Grab Remotes
                        for _, rem in ipairs(ReplicatedStorage:GetDescendants()) do
                            if rem:IsA("RemoteEvent") then
                                local lower = string.lower(rem.Name)
                                if string.find(lower, "steal") or string.find(lower, "grab") or string.find(lower, "pickup") or string.find(lower, "take") or string.find(lower, "collect") then
                                    rem:FireServer(target.Instance)
                                    rem:FireServer(targetPart)
                                end
                            end
                        end

                        task.wait(0.15)

                        -- Step 3: Teleport back to My Base to deposit
                        if depositPos and root then
                            root.CFrame = CFrame.new(depositPos)
                            task.wait(0.2)
                        end
                    end
                end)
                task.wait(0.3)
            end
        end)
    end
end)

----------------------------------------------------------------
-- 2. Auto Collect Cash
----------------------------------------------------------------
CreateToggleRow("Auto Collect Cash", function(state)
    AutoCollectCash = state
    if AutoCollectCash then
        task.spawn(function()
            while AutoCollectCash do
                pcall(function()
                    local char = LocalPlayer.Character
                    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
                    local myBase = getMyBase()

                    -- Method 1: Collect from Base Cash Pad / Collector
                    if myBase and root then
                        for _, obj in ipairs(myBase:GetDescendants()) do
                            if obj:IsA("BasePart") then
                                local lower = string.lower(obj.Name)
                                if string.find(lower, "collector") or string.find(lower, "cash") or string.find(lower, "money") or string.find(lower, "giver") or string.find(lower, "claim") then
                                    if firetouchinterest then
                                        firetouchinterest(root, obj, 0)
                                        firetouchinterest(root, obj, 1)
                                    end
                                end
                            end
                        end
                    end

                    -- Method 2: Fire Cash Collection Remotes
                    for _, rem in ipairs(ReplicatedStorage:GetDescendants()) do
                        if rem:IsA("RemoteEvent") then
                            local lower = string.lower(rem.Name)
                            if string.find(lower, "collectcash") or string.find(lower, "claimcash") or string.find(lower, "collectmoney") or string.find(lower, "getcash") or string.find(lower, "collectincome") then
                                rem:FireServer()
                                if myBase then rem:FireServer(myBase) end
                            end
                        elseif rem:IsA("RemoteFunction") then
                            local lower = string.lower(rem.Name)
                            if string.find(lower, "collectcash") or string.find(lower, "claimcash") then
                                pcall(function() rem:InvokeServer() end)
                            end
                        end
                    end
                end)
                task.wait(0.5)
            end
        end)
    end
end)

----------------------------------------------------------------
-- 3. Auto Rebirth
----------------------------------------------------------------
CreateToggleRow("Auto Rebirth", function(state)
    AutoRebirth = state
    if AutoRebirth then
        task.spawn(function()
            while AutoRebirth do
                pcall(function()
                    local char = LocalPlayer.Character
                    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))

                    -- Method 1: Fire Rebirth Remotes
                    for _, rem in ipairs(ReplicatedStorage:GetDescendants()) do
                        if rem:IsA("RemoteEvent") then
                            local lower = string.lower(rem.Name)
                            if string.find(lower, "rebirth") or string.find(lower, "prestige") or string.find(lower, "buyrebirth") then
                                rem:FireServer()
                            end
                        elseif rem:IsA("RemoteFunction") then
                            local lower = string.lower(rem.Name)
                            if string.find(lower, "rebirth") or string.find(lower, "prestige") then
                                pcall(function() rem:InvokeServer() end)
                            end
                        end
                    end

                    -- Method 2: Touch Rebirth Pad if available
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and string.find(string.lower(obj.Name), "rebirth") then
                            if firetouchinterest and root then
                                firetouchinterest(root, obj, 0)
                                firetouchinterest(root, obj, 1)
                            end
                        end
                    end
                end)
                task.wait(2)
            end
        end)
    end
end)

----------------------------------------------------------------
-- 4. Auto Upgrade Jump & Speed
----------------------------------------------------------------
CreateToggleRow("Auto Upgrade Jump & Speed", function(state)
    AutoUpgrade = state
    if AutoUpgrade then
        task.spawn(function()
            while AutoUpgrade do
                pcall(function()
                    local char = LocalPlayer.Character
                    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
                    local myBase = getMyBase()

                    -- Method 1: Fire Upgrade Remotes
                    for _, rem in ipairs(ReplicatedStorage:GetDescendants()) do
                        if rem:IsA("RemoteEvent") then
                            local lower = string.lower(rem.Name)
                            if string.find(lower, "upgrade") or string.find(lower, "buyupgrade") or string.find(lower, "buyjump") or string.find(lower, "buyspeed") or string.find(lower, "upgradejump") or string.find(lower, "upgradespeed") then
                                rem:FireServer("Jump")
                                rem:FireServer("Speed")
                                rem:FireServer("JumpPower")
                                rem:FireServer("WalkSpeed")
                                rem:FireServer(1)
                            end
                        elseif rem:IsA("RemoteFunction") then
                            local lower = string.lower(rem.Name)
                            if string.find(lower, "upgrade") then
                                pcall(function() rem:InvokeServer("Jump") end)
                                pcall(function() rem:InvokeServer("Speed") end)
                            end
                        end
                    end

                    -- Method 2: Touch Upgrade Pads in Base
                    if myBase and root then
                        for _, obj in ipairs(myBase:GetDescendants()) do
                            if obj:IsA("BasePart") then
                                local lower = string.lower(obj.Name)
                                if string.find(lower, "upgrade") or string.find(lower, "button") or string.find(lower, "buy") then
                                    if firetouchinterest then
                                        firetouchinterest(root, obj, 0)
                                        firetouchinterest(root, obj, 1)
                                    end
                                end
                            end
                        end
                    end
                end)
                task.wait(1)
            end
        end)
    end
end)

----------------------------------------------------------------
-- 5. WalkSpeed Boost & Infinite Jump
----------------------------------------------------------------
CreateToggleRow("WalkSpeed Boost (50)", function(state)
    SpeedBoostEnabled = state
    if Humanoid then
        if SpeedBoostEnabled then
            Humanoid.WalkSpeed = BoostSpeed
        else
            Humanoid.WalkSpeed = NormalSpeed
        end
    end
end)

CreateToggleRow("Infinite Jump", function(state)
    InfJumpEnabled = state
end)

UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)
