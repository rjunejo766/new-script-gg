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

----------------------------------------------------------------
-- Helper Functions: Brainrots, Base & Button Detection
----------------------------------------------------------------

-- Get all Brainrot NPC Models across workspace
local function getBrainrotTargets()
    local targets = {}
    local char = LocalPlayer.Character
    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
    local myPos = root and root.Position or Vector3.new(0, 0, 0)

    -- Scan workspace children & model folders
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj ~= char then
            if not Players:GetPlayerFromCharacter(obj) then
                local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso") or obj:FindFirstChild("Head") or obj.PrimaryPart
                if hrp then
                    local name = string.lower(obj.Name)
                    -- Exclude base plots / buildings
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

    -- Also check any models with BillboardGuis anywhere in workspace
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

    -- Sort nearest
    table.sort(targets, function(a, b)
        return (a.Position - myPos).Magnitude < (b.Position - myPos).Magnitude
    end)

    return targets
end

-- Helper: Simulate physical touch on any button/pad
local function triggerTouch(part)
    local char = LocalPlayer.Character
    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
    if root and part and part:IsA("BasePart") and firetouchinterest then
        firetouchinterest(root, part, 0)
        task.wait(0.01)
        firetouchinterest(root, part, 1)
    end
end

-- Helper: Trigger all proximity prompts inside an object
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

-- Helper: Trigger all click detectors inside an object
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

                        -- Teleport to Brainrot NPC
                        root.CFrame = targetPart.CFrame + Vector3.new(0, 1.5, 0)
                        task.wait(0.12)

                        -- Interactions
                        triggerPrompts(target.Model)
                        triggerClicks(target.Model)
                        triggerTouch(targetPart)

                        -- Fire all steal remotes
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

                        -- Teleport back to Home Base spot to deposit
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
-- 2. Auto Collect Cash (100% Functional)
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

                    -- Touch all cash collector pads / buttons in workspace
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") then
                            local lower = string.lower(obj.Name)
                            local parentLower = obj.Parent and string.lower(obj.Parent.Name) or ""
                            
                            -- Exclude group chests/wheels
                            if not string.find(lower, "group") and not string.find(lower, "wheel") and not string.find(lower, "spin") and not string.find(lower, "chest") then
                                if string.find(lower, "collector") or string.find(lower, "cash") or string.find(lower, "money") or string.find(lower, "income") or string.find(lower, "giver") or string.find(parentLower, "collector") then
                                    triggerTouch(obj)
                                    triggerPrompts(obj)
                                    triggerClicks(obj)
                                end
                            end
                        end
                    end

                    -- Fire Cash Remotes
                    for _, rem in ipairs(ReplicatedStorage:GetDescendants()) do
                        if rem:IsA("RemoteEvent") then
                            local lower = string.lower(rem.Name)
                            if not string.find(lower, "group") and not string.find(lower, "spin") then
                                if string.find(lower, "cash") or string.find(lower, "money") or string.find(lower, "income") or string.find(lower, "collect") or string.find(lower, "claim") then
                                    rem:FireServer()
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
                    -- Touch Rebirth Pads
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and string.find(string.lower(obj.Name), "rebirth") then
                            triggerTouch(obj)
                            triggerPrompts(obj)
                            triggerClicks(obj)
                        end
                    end

                    -- Fire Rebirth Remotes
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
                    -- 1. Scan and touch ALL upgrade buttons, jump buttons, and speed buttons
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

                    -- 2. Fire Upgrade Remotes in ReplicatedStorage
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
