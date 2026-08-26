--==============================================================--
--  ULTRA SCRIPT HUB - Made by Junejo
--  Game: Melt The Ice
--  Game Link: https://www.roblox.com/games/124317063595994/Melt-The-Ice
--  Version: 3.0 (Exact 2 Features: Medal Farm & Auto Stage)
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

-- Feature Toggle States (Exact 2 Features)
local MedalFarmEnabled = false
local AutoStageEnabled = false

-- Anti-AFK Setup
LocalPlayer.Idled:Connect(function()
    if VirtualUser then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

-- Character Helper Functions
local function getChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getRoot()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

local function getHum()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end

-- Universal Touch Simulation
local function safeTouch(part)
    if not part or not part:IsA("BasePart") then return end
    local char = LocalPlayer.Character
    if not char then return end
    local root = getRoot()
    local rLeg = char:FindFirstChild("Right Leg") or char:FindFirstChild("RightFoot") or root
    local lLeg = char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftFoot") or root

    pcall(function()
        if firetouchinterest then
            if root then
                firetouchinterest(root, part, 0)
                task.wait()
                firetouchinterest(root, part, 1)
            end
            if rLeg and rLeg ~= root then
                firetouchinterest(rLeg, part, 0)
                task.wait()
                firetouchinterest(rLeg, part, 1)
            end
            if lLeg and lLeg ~= root then
                firetouchinterest(lLeg, part, 0)
                task.wait()
                firetouchinterest(lLeg, part, 1)
            end
        end
    end)
end

-- Universal ProximityPrompt Trigger
local function triggerPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return end
    pcall(function()
        prompt.HoldDuration = 0
        if fireproximityprompt then
            fireproximityprompt(prompt, 0)
        else
            prompt:InputHoldBegin()
            task.wait(0.01)
            prompt:InputHoldEnd()
        end
    end)
end

-- Universal ClickDetector Simulation
local function safeClick(detector)
    if not detector or not detector:IsA("ClickDetector") then return end
    pcall(function()
        if fireclickdetector then
            fireclickdetector(detector)
        end
    end)
end

-- Dynamic Remote Search
local function findRemotes(keywords)
    local found = {}
    local function search(parent)
        if not parent then return end
        for _, obj in ipairs(parent:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                local name = obj.Name:lower()
                for _, kw in ipairs(keywords) do
                    if name:find(kw:lower()) then
                        table.insert(found, obj)
                        break
                    end
                end
            end
        end
    end
    search(ReplicatedStorage)
    search(Workspace)
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if playerGui then search(playerGui) end
    return found
end

-- Auto Equip & Attack Helper (for breaking obstacles/ice)
local function autoMeltAttack()
    local char = LocalPlayer.Character
    if not char then return end

    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then
        local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        if backpack then
            local bTool = backpack:FindFirstChildOfClass("Tool")
            if bTool then
                bTool.Parent = char
                tool = bTool
            end
        end
    end

    if tool then
        pcall(function() tool:Activate() end)
    end

    if VirtualUser then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(500, 500))
        end)
    end
    if VirtualInputManager then
        pcall(function()
            VirtualInputManager:SendMouseButtonEvent(500, 500, 0, true, game, 0)
            task.wait(0.01)
            VirtualInputManager:SendMouseButtonEvent(500, 500, 0, false, game, 0)
        end)
    end
end

--==============================================================--
--  GUI CREATION (Pixel-Perfect ULTRA SCRIPT HUB Design)
--==============================================================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraScriptHub_MeltTheIce"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999

-- Clean previous instances
pcall(function()
    if CoreGui and CoreGui:FindFirstChild("UltraScriptHub_MeltTheIce") then
        CoreGui:FindFirstChild("UltraScriptHub_MeltTheIce"):Destroy()
    end
    local lpGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if lpGui and lpGui:FindFirstChild("UltraScriptHub_MeltTheIce") then
        lpGui:FindFirstChild("UltraScriptHub_MeltTheIce"):Destroy()
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
MainFrame.Size = UDim2.new(0, 320, 0, 215)
MainFrame.Position = UDim2.new(0.5, -160, 0.35, -107)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Header Title
local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -50, 0, 35)
HeaderTitle.Position = UDim2.new(0, 16, 0, 10)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "MELT THE ICE"
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
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Content Container
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -32, 0, 95)
Container.Position = UDim2.new(0, 16, 0, 50)
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

-- Checkbox Row Generator
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

--==============================================================--
--  ADD EXACT 2 REQUESTED FEATURES TO GUI
--==============================================================--
CreateToggleRow("Medal Farm", function(state)
    MedalFarmEnabled = state
end)

CreateToggleRow("Auto Stage", function(state)
    AutoStageEnabled = state
end)

--==============================================================--
--  1. SUPERCHARGED MEDAL FARM (Collects Medals, Drops & Fires Remotes)
--==============================================================--
task.spawn(function()
    while true do
        if MedalFarmEnabled then
            pcall(function()
                local root = getRoot()

                -- A. Fast auto attack for breaking ice/spawning medals
                autoMeltAttack()

                -- B. Sweep and Collect All Medals, Ice Medals, Drops & Coins in Workspace
                if root then
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if not MedalFarmEnabled then break end
                        if obj:IsA("BasePart") then
                            local n = obj.Name:lower()
                            local p = obj.Parent and obj.Parent.Name:lower() or ""
                            if n:find("medal") or n:find("drop") or n:find("water") or n:find("coin") or 
                               n:find("cash") or n:find("reward") or n:find("collect") or n:find("token") or
                               p:find("medal") or p:find("drops") or p:find("rewards") or p:find("coins") then
                                safeTouch(obj)
                            end
                        elseif obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
                            local adornee = obj.Adornee or obj.Parent
                            if adornee and adornee:IsA("BasePart") then
                                for _, txt in ipairs(obj:GetDescendants()) do
                                    if txt:IsA("TextLabel") and txt.Text:lower():find("medal") then
                                        safeTouch(adornee)
                                    end
                                end
                            end
                        elseif obj:IsA("ProximityPrompt") then
                            local act = (obj.ActionText .. " " .. obj.ObjectText):lower()
                            if act:find("medal") or act:find("collect") or act:find("claim") or act:find("reward") then
                                triggerPrompt(obj)
                            end
                        elseif obj:IsA("ClickDetector") then
                            safeClick(obj)
                        end
                    end
                end

                -- C. Fire All Medal, Reward & Claim Remotes
                local medalRemotes = findRemotes({
                    "medal", "medals", "givemedal", "addmedal", "claimmedal", "collectmedal",
                    "drop", "reward", "water", "collect", "claim", "farm", "melt"
                })
                for _, remote in ipairs(medalRemotes) do
                    pcall(function()
                        if remote:IsA("RemoteEvent") then
                            remote:FireServer()
                            remote:FireServer(1)
                            remote:FireServer(999999)
                            remote:FireServer(true)
                            remote:FireServer("Medal")
                        elseif remote:IsA("RemoteFunction") then
                            remote:InvokeServer()
                            remote:InvokeServer(1)
                            remote:InvokeServer(999999)
                            remote:InvokeServer(true)
                        end
                    end)
                end
            end)
            task.wait(0.05)
        else
            task.wait(0.3)
        end
    end
end)

--==============================================================--
--  2. SUPERCHARGED AUTO STAGE (Completes Stages & Advances Door/Gate)
--==============================================================--
task.spawn(function()
    while true do
        if AutoStageEnabled then
            pcall(function()
                local root = getRoot()
                if not root then return end

                local savedPos = root.CFrame

                -- A. Discover Stage Doors, Gates, Finish Lines & Next Stage Pads
                local stageParts = {}
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not AutoStageEnabled then break end

                    -- Check BillboardGui / SurfaceGui (e.g. "Stage 1", "Stage 2", "Next Stage", "Door")
                    if obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
                        for _, txt in ipairs(obj:GetDescendants()) do
                            if txt:IsA("TextLabel") and txt.Text ~= "" then
                                local textLower = txt.Text:lower()
                                if textLower:find("stage") or textLower:find("door") or textLower:find("gate") or 
                                   textLower:find("next") or textLower:find("portal") or textLower:find("finish") then
                                    local part = obj.Adornee or obj.Parent
                                    if part and part:IsA("BasePart") then
                                        table.insert(stageParts, part)
                                    elseif part and part:IsA("Model") and part.PrimaryPart then
                                        table.insert(stageParts, part.PrimaryPart)
                                    end
                                end
                            end
                        end
                    -- Check BasePart names
                    elseif obj:IsA("BasePart") then
                        local n = obj.Name:lower()
                        local p = obj.Parent and obj.Parent.Name:lower() or ""
                        if n:find("stage") or n:find("door") or n:find("gate") or n:find("nextstage") or 
                           n:find("portal") or n:find("finish") or n:find("checkpoint") or 
                           p:find("stage") or p:find("doors") or p:find("gates") or p:find("levels") then
                            table.insert(stageParts, obj)
                        end
                    -- Check Prompts
                    elseif obj:IsA("ProximityPrompt") then
                        local act = (obj.ActionText .. " " .. obj.ObjectText):lower()
                        if act:find("stage") or act:find("door") or act:find("enter") or act:find("next") or act:find("pass") then
                            triggerPrompt(obj)
                        end
                    end
                end

                -- Sort by distance
                local currentPos = root.Position
                table.sort(stageParts, function(a, b)
                    return (a.Position - currentPos).Magnitude < (b.Position - currentPos).Magnitude
                end)

                -- B. Step on each Stage Pad / Door / Portal
                for _, sPart in ipairs(stageParts) do
                    if not AutoStageEnabled then break end
                    if sPart and sPart.Parent and sPart:IsA("BasePart") then
                        safeTouch(sPart)
                        root.CFrame = CFrame.new(sPart.Position + Vector3.new(0, 2.2, 0))

                        local prompt = sPart:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if prompt then triggerPrompt(prompt) end

                        local click = sPart:FindFirstChildWhichIsA("ClickDetector", true)
                        if click then safeClick(click) end

                        task.wait(0.09)
                    end
                end

                -- C. Fire Stage Progression Remotes
                local stageRemotes = findRemotes({
                    "stage", "nextstage", "advance", "claimstage", "completestage", "enterstage", "door", "passstage"
                })
                for _, remote in ipairs(stageRemotes) do
                    pcall(function()
                        if remote:IsA("RemoteEvent") then
                            remote:FireServer()
                            remote:FireServer(1)
                            remote:FireServer(true)
                        elseif remote:IsA("RemoteFunction") then
                            remote:InvokeServer()
                            remote:InvokeServer(1)
                            remote:InvokeServer(true)
                        end
                    end)
                end

                -- Return to original position
                if AutoStageEnabled and savedPos and root then
                    root.CFrame = savedPos
                end
            end)
            task.wait(0.3)
        else
            task.wait(0.5)
        end
    end
end)

print("[ULTRA SCRIPT HUB] Melt The Ice Loaded Successfully!")

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ULTRA SCRIPT HUB",
        Text = "Melt The Ice Ready (Medal Farm + Auto Stage)!",
        Duration = 5
    })
end)
