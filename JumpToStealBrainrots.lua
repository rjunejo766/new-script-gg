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

-- Memory of Player Spawn / Base Position
local SpawnBasePosition = nil
task.spawn(function()
    task.wait(1)
    if RootPart then
        SpawnBasePosition = RootPart.Position
    end
end)

-- Find the Local Player's Personal Base / Plot
local function getMyBase()
    local playerName = string.lower(LocalPlayer.Name)
    local displayName = string.lower(LocalPlayer.DisplayName)
    local userId = tostring(LocalPlayer.UserId)

    -- 1. Search common tycoon / plot folders
    for _, container in ipairs({workspace:FindFirstChild("Plots"), workspace:FindFirstChild("Bases"), workspace:FindFirstChild("Tycoons"), workspace:FindFirstChild("Houses")}) do
        if container then
            for _, plot in ipairs(container:GetChildren()) do
                -- Check Owner value
                for _, child in ipairs(plot:GetDescendants()) do
                    if child:IsA("StringValue") or child:IsA("ObjectValue") then
                        local valStr = string.lower(tostring(child.Value))
                        if valStr == playerName or valStr == displayName or valStr == userId or (child.Value == LocalPlayer) then
                            return plot
                        end
                    end
                    -- Check BillboardGui Signs on Plot
                    if child:IsA("TextLabel") or child:IsA("TextButton") then
                        local text = string.lower(child.Text)
                        if string.find(text, playerName) or string.find(text, displayName) then
                            return plot
                        end
                    end
                end
                -- Check attributes
                if plot:GetAttribute("Owner") == LocalPlayer.Name or tostring(plot:GetAttribute("OwnerId")) == userId then
                    return plot
                end
            end
        end
    end

    -- 2. Search entire workspace for any plot with player's name
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") or obj:IsA("Folder") then
            local objName = string.lower(obj.Name)
            if string.find(objName, "plot") or string.find(objName, "base") or string.find(objName, "tycoon") then
                for _, desc in ipairs(obj:GetDescendants()) do
                    if (desc:IsA("TextLabel") or desc:IsA("TextButton")) and (string.find(string.lower(desc.Text), playerName) or string.find(string.lower(desc.Text), displayName)) then
                        return obj
                    end
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
        for _, obj in ipairs(myBase:GetDescendants()) do
            if obj:IsA("BasePart") then
                local lower = string.lower(obj.Name)
                if string.find(lower, "deposit") or string.find(lower, "drop") or string.find(lower, "delivery") or string.find(lower, "place") or string.find(lower, "spawn") or string.find(lower, "pad") then
                    return obj.Position + Vector3.new(0, 3, 0)
                end
            end
        end
        if myBase.PrimaryPart then
            return myBase.PrimaryPart.Position + Vector3.new(0, 4, 0)
        end
    end

    -- Fallback to starting spawn position
    if SpawnBasePosition then
        return SpawnBasePosition + Vector3.new(0, 2, 0)
    end
    return nil
end

-- Find all Brainrot NPCs / Items across the map (Universal Detection)
local function getAllBrainrots()
    local brainrots = {}
    local char = LocalPlayer.Character
    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
    local myPos = root and root.Position or Vector3.new(0, 0, 0)

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and not obj:IsDescendantOf(char) then
            -- Make sure it is NOT another real player
            local isRealPlayer = Players:GetPlayerFromCharacter(obj) ~= nil

            if not isRealPlayer then
                local hum = obj:FindFirstChildOfClass("Humanoid")
                local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso") or obj:FindFirstChild("Head") or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                local hasBillboard = obj:FindFirstChildWhichIsA("BillboardGui", true)
                local hasPrompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)

                -- Check if it's a Brainrot NPC (moving character with stats, tags, or prompts)
                local isBrainrot = false
                local objName = string.lower(obj.Name)

                -- 1. Check BillboardGui text (e.g. "$23/s", "Common", "Rare", "Pipi", meme names)
                if hasBillboard then
                    for _, label in ipairs(obj:GetDescendants()) do
                        if label:IsA("TextLabel") then
                            local txt = string.lower(label.Text)
                            if string.find(txt, "$") or string.find(txt, "/s") or string.find(txt, "common") or string.find(txt, "rare") or string.find(txt, "epic") or string.find(txt, "legendary") or string.find(txt, "secret") or string.find(txt, "brainrot") then
                                isBrainrot = true
                                break
                            end
                        end
                    end
                end

                -- 2. Check ProximityPrompt action text
                if hasPrompt and not isBrainrot then
                    local action = string.lower(hasPrompt.ActionText .. " " .. hasPrompt.ObjectText)
                    if string.find(action, "steal") or string.find(action, "grab") or string.find(action, "take") or string.find(action, "pick") or string.find(action, "claim") then
                        isBrainrot = true
                    end
                end

                -- 3. Check general keywords
                if not isBrainrot and (string.find(objName, "brainrot") or string.find(objName, "spawner") or string.find(objName, "npc") or (hum and hrp)) then
                    -- Exclude base structures and tycoon models
                    if not string.find(objName, "plot") and not string.find(objName, "tycoon") and not string.find(objName, "base") and not string.find(objName, "door") and not string.find(objName, "wall") then
                        isBrainrot = true
                    end
                end

                if isBrainrot and hrp then
                    table.insert(brainrots, {Instance = obj, Part = hrp, Position = hrp.Position})
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
local SavedBaseCFrame = nil

CreateToggleRow("Auto Steal Brainrots", function(state)
    AutoSteal = state
    if AutoSteal then
        -- Save player's current base spot when turning on
        local char = LocalPlayer.Character
        local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
        if root then
            SavedBaseCFrame = root.CFrame
        end

        task.spawn(function()
            while AutoSteal do
                pcall(function()
                    local char = LocalPlayer.Character
                    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
                    if not root then return end

                    -- Refresh base spot if available
                    local depositPos = getBaseDepositPoint() or (SavedBaseCFrame and SavedBaseCFrame.Position)

                    local brainrots = getAllBrainrots()
                    if #brainrots > 0 then
                        local target = brainrots[1]
                        local targetPart = target.Part

                        -- Step 1: Teleport to Brainrot / NPC
                        root.CFrame = targetPart.CFrame + Vector3.new(0, 1.5, 0)
                        task.wait(0.12)

                        -- Step 2: Grab / Steal Interactions
                        -- Trigger Proximity Prompts
                        for _, prompt in ipairs(target.Instance:GetDescendants()) do
                            if prompt:IsA("ProximityPrompt") then
                                prompt.HoldDuration = 0
                                if fireproximityprompt then
                                    fireproximityprompt(prompt, 0, true)
                                end
                            end
                        end

                        -- Trigger ClickDetectors
                        for _, cd in ipairs(target.Instance:GetDescendants()) do
                            if cd:IsA("ClickDetector") and fireclickdetector then
                                fireclickdetector(cd)
                            end
                        end

                        -- Touch Interest
                        if firetouchinterest then
                            firetouchinterest(root, targetPart, 0)
                            firetouchinterest(root, targetPart, 1)
                        end

                        -- Fire Steal Remotes
                        for _, rem in ipairs(ReplicatedStorage:GetDescendants()) do
                            if rem:IsA("RemoteEvent") then
                                local lower = string.lower(rem.Name)
                                if string.find(lower, "steal") or string.find(lower, "grab") or string.find(lower, "take") or string.find(lower, "pickup") or string.find(lower, "claim") then
                                    rem:FireServer(target.Instance)
                                    rem:FireServer(targetPart)
                                    rem:FireServer()
                                end
                            end
                        end

                        task.wait(0.2)

                        -- Step 3: Teleport back to Base Deposit Spot
                        if depositPos and root then
                            root.CFrame = CFrame.new(depositPos)
                            task.wait(0.25)
                        elseif SavedBaseCFrame and root then
                            root.CFrame = SavedBaseCFrame
                            task.wait(0.25)
                        end
                    end
                end)
                task.wait(0.25)
            end
        end)
    end
end)

----------------------------------------------------------------
-- 2. Auto Collect Cash (Filters out Group Rewards)
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

                    -- Method 1: Collect from Base Cash Pad / Collector (Exclude group chests / wheel)
                    local baseToCheck = myBase or workspace
                    if root then
                        for _, obj in ipairs(baseToCheck:GetDescendants()) do
                            if obj:IsA("BasePart") then
                                local lower = string.lower(obj.Name)
                                -- STRICT: Only match collectors, exclude group rewards/chests/spins
                                if not string.find(lower, "group") and not string.find(lower, "wheel") and not string.find(lower, "spin") and not string.find(lower, "chest") and not string.find(lower, "daily") then
                                    if string.find(lower, "collector") or string.find(lower, "cash") or string.find(lower, "money") or string.find(lower, "income") or string.find(lower, "giver") then
                                        if firetouchinterest then
                                            firetouchinterest(root, obj, 0)
                                            firetouchinterest(root, obj, 1)
                                        end
                                    end
                                end
                            end
                        end
                    end

                    -- Method 2: Fire Cash Collection Remotes
                    for _, rem in ipairs(ReplicatedStorage:GetDescendants()) do
                        if rem:IsA("RemoteEvent") then
                            local lower = string.lower(rem.Name)
                            if not string.find(lower, "group") and not string.find(lower, "spin") then
                                if string.find(lower, "collectcash") or string.find(lower, "claimcash") or string.find(lower, "collectmoney") or string.find(lower, "getcash") or string.find(lower, "collectincome") or string.find(lower, "collect") then
                                    rem:FireServer()
                                    if myBase then rem:FireServer(myBase) end
                                end
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
                    local baseToCheck = myBase or workspace
                    if root then
                        for _, obj in ipairs(baseToCheck:GetDescendants()) do
                            if obj:IsA("BasePart") then
                                local lower = string.lower(obj.Name)
                                if string.find(lower, "upgrade") or string.find(lower, "buy") then
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
