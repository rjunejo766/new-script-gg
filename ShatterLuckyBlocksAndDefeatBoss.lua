--==============================================================--
--  ULTRA SCRIPT HUB - Made by Junejo
--  Game: Shatter Lucky Blocks And Defeat Boss
--  Version: 1.0 (Full Auto Hit, Cash, Rebirth & Zone Edition)
--==============================================================--

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local VirtualUser = nil
pcall(function() VirtualUser = game:GetService("VirtualUser") end)

-- Feature States (Exact 4 Features)
local AutoHitEnabled = false
local AutoCollectCash = false
local AutoRebirth = false
local AutoUnlockZone = false

-- Helper Functions
local function getRoot()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
end

local function getHum()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end

-- Universal Proximity Prompt Trigger
local function triggerPrompt(prompt)
    if not prompt or not prompt.Parent then return end
    pcall(function()
        prompt.HoldDuration = 0
        if fireproximityprompt then
            fireproximityprompt(prompt, 0)
        elseif prompt.InputHoldBegin and prompt.InputHoldEnd then
            prompt:InputHoldBegin()
            task.wait(0.02)
            prompt:InputHoldEnd()
        end
    end)
end

-- Universal Touch Simulation
local function safeTouch(part1, part2)
    if not part1 or not part2 then return end
    pcall(function()
        if firetouchinterest then
            firetouchinterest(part1, part2, 0)
            task.wait(0.01)
            firetouchinterest(part1, part2, 1)
        end
    end)
end

-- Universal ClickDetector Simulation
local function safeClick(detector)
    if not detector then return end
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
    return found
end

-- Equip Best Weapon / Tool
local function equipTool()
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if not char or not backpack then return nil end
    
    local toolInChar = char:FindFirstChildOfClass("Tool")
    if toolInChar then return toolInChar end
    
    local tool = backpack:FindFirstChildOfClass("Tool")
    if tool and getHum() then
        getHum():EquipTool(tool)
        return tool
    end
    return nil
end

--==============================================================--
--  GUI CREATION (Pixel-Perfect ULTRA SCRIPT HUB Design)
--==============================================================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraScriptHub_ShatterLuckyBlocks"
ScreenGui.ResetOnSpawn = false

local parentGui = nil
if gethui then pcall(function() parentGui = gethui() end) end
if not parentGui then parentGui = CoreGui end
if not parentGui then parentGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") end

pcall(function()
    if parentGui and parentGui:FindFirstChild("UltraScriptHub_ShatterLuckyBlocks") then
        parentGui:FindFirstChild("UltraScriptHub_ShatterLuckyBlocks"):Destroy()
    end
end)

ScreenGui.Parent = parentGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 275)
MainFrame.Position = UDim2.new(0.5, -160, 0.35, -137)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Header Title
local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -50, 0, 35)
HeaderTitle.Position = UDim2.new(0, 16, 0, 10)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "SHATTER LUCKY BLOCKS"
HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitle.TextSize = 16
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
Container.Size = UDim2.new(1, -32, 0, 155)
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

-- Checkbox Row Generator (Standard Ultra Script Hub Component)
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
--  ADD 4 FEATURES TO GUI
--==============================================================--
CreateToggleRow("Auto Hit / Shatter Blocks", function(state)
    AutoHitEnabled = state
end)

CreateToggleRow("Auto Collect Cash", function(state)
    AutoCollectCash = state
end)

CreateToggleRow("Auto Rebirth", function(state)
    AutoRebirth = state
end)

CreateToggleRow("Unlock Next Zone", function(state)
    AutoUnlockZone = state
end)

--==============================================================--
--  1. AUTO HIT / SHATTER BLOCKS LOOP
--==============================================================--
task.spawn(function()
    while true do
        if AutoHitEnabled then
            pcall(function()
                local root = getRoot()
                if not root then return end

                -- Equip & swing weapon
                local tool = equipTool()
                if tool then
                    tool:Activate()
                end

                -- Virtual click
                if VirtualUser then
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton1(Vector2.new(999, 999))
                    end)
                end

                -- Hit remotes
                local hitRemotes = findRemotes({"hit", "attack", "damage", "punch", "swing", "click", "shatter", "break", "mine", "boss"})
                for _, remote in ipairs(hitRemotes) do
                    if not AutoHitEnabled then break end
                    pcall(function()
                        if remote:IsA("RemoteEvent") then
                            remote:FireServer()
                            remote:FireServer(true)
                            remote:FireServer("Hit")
                            remote:FireServer(1)
                        elseif remote:IsA("RemoteFunction") then
                            remote:InvokeServer()
                        end
                    end)
                end

                -- Nearby click detectors and prompts on blocks
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not AutoHitEnabled then break end
                    if obj:IsA("ClickDetector") and obj.Parent then
                        local p = obj.Parent
                        if p:IsA("BasePart") and (p.Position - root.Position).Magnitude <= 45 then
                            safeClick(obj)
                        end
                    elseif obj:IsA("ProximityPrompt") and obj.Parent then
                        local p = obj.Parent
                        local pos = p:IsA("BasePart") and p.Position or (p:IsA("Model") and p:GetPivot().Position)
                        if pos and (pos - root.Position).Magnitude <= 45 then
                            local txt = (obj.ActionText .. " " .. obj.ObjectText):lower()
                            if txt:find("hit") or txt:find("shatter") or txt:find("break") or txt:find("attack") or txt:find("open") then
                                triggerPrompt(obj)
                            end
                        end
                    end
                end
            end)
            task.wait(0.08)
        else
            task.wait(0.3)
        end
    end
end)

--==============================================================--
--  2. AUTO COLLECT CASH LOOP
--==============================================================--
task.spawn(function()
    while true do
        if AutoCollectCash then
            pcall(function()
                local root = getRoot()
                if not root then return end

                -- Remotes
                local collectRemotes = findRemotes({"collect", "pickup", "claim", "claimcash", "claimcoin", "claimdrop", "cash", "coins"})
                for _, remote in ipairs(collectRemotes) do
                    if not AutoCollectCash then break end
                    pcall(function()
                        if remote:IsA("RemoteEvent") then
                            remote:FireServer()
                            remote:FireServer("All")
                        elseif remote:IsA("RemoteFunction") then
                            remote:InvokeServer()
                        end
                    end)
                end

                -- Touch Cash & Coins in Workspace
                local dropKeywords = {"cash", "coin", "gem", "drop", "money", "reward", "orb", "token"}
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not AutoCollectCash then break end
                    if obj:IsA("BasePart") and obj.CanTouch and not obj.Anchored and obj.Transparency < 1 then
                        local nameLower = obj.Name:lower()
                        local parentLower = obj.Parent and obj.Parent.Name:lower() or ""
                        local isDrop = false
                        for _, kw in ipairs(dropKeywords) do
                            if nameLower:find(kw) or parentLower:find(kw) then
                                isDrop = true
                                break
                            end
                        end
                        if isDrop then
                            safeTouch(root, obj)
                            local prompt = obj:FindFirstChildOfClass("ProximityPrompt") or (obj.Parent and obj.Parent:FindFirstChildOfClass("ProximityPrompt"))
                            if prompt then triggerPrompt(prompt) end
                        end
                    end
                end

                -- Drop folders
                for _, folderName in ipairs({"Drops", "Coins", "Cash", "Pickups", "Debris", "Rewards", "SpawnedCash"}) do
                    local folder = Workspace:FindFirstChild(folderName)
                    if folder then
                        for _, item in ipairs(folder:GetChildren()) do
                            if not AutoCollectCash then break end
                            local part = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart")
                            if part then safeTouch(root, part) end
                        end
                    end
                end
            end)
            task.wait(0.12)
        else
            task.wait(0.4)
        end
    end
end)

--==============================================================--
--  3. AUTO REBIRTH LOOP
--==============================================================--
task.spawn(function()
    while true do
        if AutoRebirth then
            pcall(function()
                local root = getRoot()

                -- Rebirth Remotes
                local rebirthRemotes = findRemotes({"rebirth", "ascend", "prestige", "dorebirth", "buyrebirth"})
                for _, remote in ipairs(rebirthRemotes) do
                    if not AutoRebirth then break end
                    pcall(function()
                        if remote:IsA("RemoteEvent") then
                            remote:FireServer()
                            remote:FireServer(1)
                        elseif remote:IsA("RemoteFunction") then
                            remote:InvokeServer()
                            remote:InvokeServer(1)
                        end
                    end)
                end

                -- Rebirth pads / prompts in workspace
                if root then
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if not AutoRebirth then break end
                        local name = obj.Name:lower()
                        if name:find("rebirth") then
                            if obj:IsA("BasePart") then
                                safeTouch(root, obj)
                            elseif obj:IsA("ProximityPrompt") then
                                triggerPrompt(obj)
                            elseif obj:IsA("ClickDetector") then
                                safeClick(obj)
                            end
                        end
                    end
                end
            end)
            task.wait(0.7)
        else
            task.wait(0.5)
        end
    end
end)

--==============================================================--
--  4. UNLOCK NEXT ZONE LOOP
--==============================================================--
task.spawn(function()
    while true do
        if AutoUnlockZone then
            pcall(function()
                local root = getRoot()

                -- Zone remotes
                local zoneRemotes = findRemotes({"unlockzone", "buyzone", "unlockarea", "buyarea", "unlockworld", "buyworld", "unlockgate", "buygate"})
                for _, remote in ipairs(zoneRemotes) do
                    if not AutoUnlockZone then break end
                    for zoneId = 1, 20 do
                        pcall(function()
                            if remote:IsA("RemoteEvent") then
                                remote:FireServer(zoneId)
                                remote:FireServer("Zone" .. tostring(zoneId))
                            elseif remote:IsA("RemoteFunction") then
                                remote:InvokeServer(zoneId)
                            end
                        end)
                    end
                end

                -- Zone doors & gates
                if root then
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if not AutoUnlockZone then break end
                        local name = obj.Name:lower()
                        if name:find("zone") or name:find("gate") or name:find("door") or name:find("barrier") or name:find("area") then
                            if obj:IsA("BasePart") and obj.CanTouch then
                                safeTouch(root, obj)
                            elseif obj:IsA("ProximityPrompt") then
                                local pText = (obj.ActionText .. " " .. obj.ObjectText):lower()
                                if pText:find("unlock") or pText:find("buy") or pText:find("open") then
                                    triggerPrompt(obj)
                                end
                            elseif obj:IsA("ClickDetector") then
                                safeClick(obj)
                            end
                        end
                    end
                end
            end)
            task.wait(1.0)
        else
            task.wait(0.5)
        end
    end
end)

--==============================================================--
--  LOAD CONFIRMATION
--==============================================================--
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ULTRA SCRIPT HUB",
        Text = "Shatter Lucky Blocks loaded!",
        Duration = 3
    })
end)
