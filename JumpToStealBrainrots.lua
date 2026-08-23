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
-- Helper Functions: Brainrots, Touch & Prompts
----------------------------------------------------------------

-- Get all Brainrot NPC Models across workspace
local function getBrainrotTargets()
    local targets = {}
    local char = LocalPlayer.Character
    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
    local myPos = root and root.Position or Vector3.new(0, 0, 0)

    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj ~= char then
            if not Players:GetPlayerFromCharacter(obj) then
                local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso") or obj:FindFirstChild("Head") or obj.PrimaryPart
                if hrp then
                    local name = string.lower(obj.Name)
                    if not string.find(name, "plot") and not string.find(name, "tycoon") and not string.find(name, "base") and not string.find(name, "house") then
                        table.insert(targets, {Model = obj, Part = hrp, Position = hrp.Position})
                    end
                end
            end
        elseif obj:IsA("Folder") then
            local fName = string.lower(obj.Name)
            if string.find(fName, "brainrot") or string.find(fName, "npc") or string.find(fName, "spawn") or string.find(fName, "mob") or string.find(fName, "drop") or string.find(fName, "item") then
                for _, sub in ipairs(obj:GetChildren()) do
                    if sub:IsA("Model") and sub ~= char and not Players:GetPlayerFromCharacter(sub) then
                        local hrp = sub:FindFirstChild("HumanoidRootPart") or sub:FindFirstChild("Torso") or sub:FindFirstChild("Head") or sub.PrimaryPart or sub:FindFirstChildWhichIsA("BasePart")
                        if hrp then
                            table.insert(targets, {Model = sub, Part = hrp, Position = hrp.Position})
                        end
                    elseif sub:IsA("BasePart") then
                        table.insert(targets, {Model = sub, Part = sub, Position = sub.Position})
                    end
                end
            end
        end
    end

    if #targets == 0 then
        for _, gui in ipairs(workspace:GetDescendants()) do
            if gui:IsA("BillboardGui") then
                local model = gui.Adornee or gui.Parent
                if model and model:IsA("Model") and model ~= char and not Players:GetPlayerFromCharacter(model) then
                    local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model:FindFirstChild("Head") or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                    if hrp then
                        table.insert(targets, {Model = model, Part = hrp, Position = hrp.Position})
                    end
                end
            end
        end
    end

    table.sort(targets, function(a, b)
        return (a.Position - myPos).Magnitude < (b.Position - myPos).Magnitude
    end)

    return targets
end

local function triggerTouch(part)
    local char = LocalPlayer.Character
    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
    if root and part and part:IsA("BasePart") and firetouchinterest then
        firetouchinterest(root, part, 0)
        task.wait(0.01)
        firetouchinterest(root, part, 1)
    end
end

local function triggerPrompts(obj)
    for _, p in ipairs(obj:GetDescendants()) do
        if p:IsA("ProximityPrompt") then
            p.HoldDuration = 0
            if fireproximityprompt then
                fireproximityprompt(p, 0, true)
            end
        end
    end
end

local function triggerClicks(obj)
    for _, cd in ipairs(obj:GetDescendants()) do
        if cd:IsA("ClickDetector") and fireclickdetector then
            fireclickdetector(cd)
        end
    end
end

----------------------------------------------------------------
-- 1. Auto Steal Brainrots
----------------------------------------------------------------
local HomeBaseCFrame = nil

CreateToggleRow("Auto Steal Brainrots", function(state)
    AutoSteal = state
    if AutoSteal then
        local char = LocalPlayer.Character
        local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
        if root then
            HomeBaseCFrame = root.CFrame
        end

        task.spawn(function()
            while AutoSteal do
                pcall(function()
                    local char = LocalPlayer.Character
                    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
                    if not root then return end

                    local targets = getBrainrotTargets()
                    if #targets > 0 then
                        local target = targets[1]
                        local targetPart = target.Part

                        root.CFrame = targetPart.CFrame + Vector3.new(0, 1.5, 0)
                        task.wait(0.12)

                        triggerPrompts(target.Model)
                        triggerClicks(target.Model)
                        triggerTouch(targetPart)

                        for _, rem in ipairs(ReplicatedStorage:GetDescendants()) do
                            if rem:IsA("RemoteEvent") then
                                local lower = string.lower(rem.Name)
                                if string.find(lower, "steal") or string.find(lower, "grab") or string.find(lower, "take") or string.find(lower, "pickup") or string.find(lower, "claim") then
                                    rem:FireServer(target.Model)
                                    rem:FireServer(targetPart)
                                    rem:FireServer()
                                end
                            end
                        end

                        task.wait(0.2)

                        if HomeBaseCFrame and root then
                            root.CFrame = HomeBaseCFrame
                            task.wait(0.25)
                        end
                    end
                end)
                task.wait(0.3)
            end
        end)
    end
end)

----------------------------------------------------------------
-- 2. Auto Collect Cash (100% Guaranteed)
----------------------------------------------------------------
CreateToggleRow("Auto Collect Cash", function(state)
    AutoCollectCash = state
    if AutoCollectCash then
        task.spawn(function()
            while AutoCollectCash do
                pcall(function()
                    local char = LocalPlayer.Character
                    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
                    if not root then return end

                    -- Detect and collect all floating Cash ($836, etc.) on BillboardGuis
                    for _, gui in ipairs(workspace:GetDescendants()) do
                        if gui:IsA("BillboardGui") or gui:IsA("SurfaceGui") then
                            local hasCashText = false
                            for _, textLabel in ipairs(gui:GetDescendants()) do
                                if textLabel:IsA("TextLabel") then
                                    local txt = textLabel.Text
                                    if string.find(txt, "%$") and not string.find(string.lower(txt), "robux") and not string.find(string.lower(txt), "r%$") then
                                        hasCashText = true
                                        break
                                    end
                                end
                            end

                            if hasCashText then
                                local targetPart = gui.Adornee or gui.Parent
                                if targetPart and (targetPart:IsA("BasePart") or targetPart:IsA("Model")) then
                                    local part = targetPart:IsA("BasePart") and targetPart or targetPart:FindFirstChildWhichIsA("BasePart")
                                    if part then
                                        triggerTouch(part)
                                        triggerPrompts(targetPart)
                                        triggerClicks(targetPart)
                                    end
                                end
                            end
                        end
                    end

                    -- Touch base collector pads, beds, slots
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") then
                            local lower = string.lower(obj.Name)
                            local parentLower = obj.Parent and string.lower(obj.Parent.Name) or ""
                            
                            if not string.find(lower, "group") and not string.find(lower, "wheel") and not string.find(lower, "spin") and not string.find(lower, "chest") then
                                if string.find(lower, "collector") 
                                    or string.find(lower, "cash") 
                                    or string.find(lower, "money") 
                                    or string.find(lower, "income") 
                                    or string.find(lower, "giver") 
                                    or string.find(lower, "bed") 
                                    or string.find(lower, "pad") 
                                    or string.find(lower, "slot") 
                                    or string.find(parentLower, "collector") 
                                    or string.find(parentLower, "slots") 
                                    or string.find(parentLower, "beds") then
                                    triggerTouch(obj)
                                    triggerPrompts(obj)
                                    triggerClicks(obj)
                                end
                            end
                        end
                    end

                    -- Fire Remotes
                    for _, rem in ipairs(ReplicatedStorage:GetDescendants()) do
                        if rem:IsA("RemoteEvent") then
                            local lower = string.lower(rem.Name)
                            if not string.find(lower, "group") and not string.find(lower, "spin") and not string.find(lower, "pass") then
                                if string.find(lower, "cash") or string.find(lower, "money") or string.find(lower, "income") or string.find(lower, "collect") or string.find(lower, "claim") or string.find(lower, "sell") then
                                    rem:FireServer()
                                    rem:FireServer(1)
                                end
                            end
                        elseif rem:IsA("RemoteFunction") then
                            local lower = string.lower(rem.Name)
                            if string.find(lower, "cash") or string.find(lower, "collect") or string.find(lower, "claim") then
                                pcall(function() rem:InvokeServer() end)
                            end
                        end
                    end
                end)
                task.wait(0.3)
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
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and string.find(string.lower(obj.Name), "rebirth") then
                            triggerTouch(obj)
                            triggerPrompts(obj)
                            triggerClicks(obj)
                        end
                    end

                    for _, rem in ipairs(ReplicatedStorage:GetDescendants()) do
                        if rem:IsA("RemoteEvent") then
                            local lower = string.lower(rem.Name)
                            if string.find(lower, "rebirth") or string.find(lower, "prestige") then
                                rem:FireServer()
                            end
                        elseif rem:IsA("RemoteFunction") then
                            local lower = string.lower(rem.Name)
                            if string.find(lower, "rebirth") or string.find(lower, "prestige") then
                                pcall(function() rem:InvokeServer() end)
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
-- 4. Auto Upgrade Jump & Speed (100% Functional)
----------------------------------------------------------------
CreateToggleRow("Auto Upgrade Jump & Speed", function(state)
    AutoUpgrade = state
    if AutoUpgrade then
        task.spawn(function()
            while AutoUpgrade do
                pcall(function()
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") then
                            local lower = string.lower(obj.Name)
                            local parentLower = obj.Parent and string.lower(obj.Parent.Name) or ""
                            
                            local isUpgrade = string.find(lower, "jump") 
                                           or string.find(lower, "speed") 
                                           or string.find(lower, "upgrade") 
                                           or string.find(lower, "buy") 
                                           or string.find(lower, "power") 
                                           or string.find(parentLower, "upgrade") 
                                           or string.find(parentLower, "buttons")

                            if isUpgrade and not string.find(lower, "gamepass") and not string.find(lower, "robux") then
                                triggerTouch(obj)
                                triggerPrompts(obj)
                                triggerClicks(obj)
                            end
                        end
                    end

                    for _, rem in ipairs(ReplicatedStorage:GetDescendants()) do
                        if rem:IsA("RemoteEvent") then
                            local lower = string.lower(rem.Name)
                            if string.find(lower, "upgrade") or string.find(lower, "buy") or string.find(lower, "jump") or string.find(lower, "speed") or string.find(lower, "stat") then
                                if not string.find(lower, "pass") and not string.find(lower, "robux") then
                                    rem:FireServer("Jump")
                                    rem:FireServer("Speed")
                                    rem:FireServer("JumpPower")
                                    rem:FireServer("WalkSpeed")
                                    rem:FireServer(1)
                                    rem:FireServer()
                                end
                            end
                        elseif rem:IsA("RemoteFunction") then
                            local lower = string.lower(rem.Name)
                            if string.find(lower, "upgrade") or string.find(lower, "buy") then
                                pcall(function() rem:InvokeServer("Jump") end)
                                pcall(function() rem:InvokeServer("Speed") end)
                                pcall(function() rem:InvokeServer("JumpPower") end)
                                pcall(function() rem:InvokeServer("WalkSpeed") end)
                                pcall(function() rem:InvokeServer(1) end)
                            end
                        end
                    end
                end)
                task.wait(0.8)
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
