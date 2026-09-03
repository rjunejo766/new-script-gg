--==============================================================--
--  ULTRA SCRIPT HUB - Made by Junejo
--  Game: Clean the WORLD! [PRESTIGE!]
--  Game Link: https://www.roblox.com/games/105767799784652/Clean-the-WORLD
--  Version: 3.0 (100% Working Sweep Magnet, Auto Sell & Upgrade)
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

-- Feature Toggle States (Exact 7 Features)
local AutoCleanAuraEnabled = false
local AutoSellEnabled = false
local AutoPrestigeEnabled = false
local AutoUpgradeEnabled = false
local AutoUnlockZonesEnabled = false
local TrashESPEnabled = false
local FlyEnabled = false

-- Movement Settings
local DefaultSpeed = 16
local FlySpeed = 50

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

-- Universal Touch Simulation (Multi-Part & Tool Handle)
local function safeTouch(part)
    if not part or not part:IsA("BasePart") then return end
    local char = LocalPlayer.Character
    if not char then return end
    local root = getRoot()
    if not root then return end

    local tool = char:FindFirstChildOfClass("Tool")
    local toolHandle = tool and (tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart"))

    local partsToTouch = {
        root,
        toolHandle,
        char:FindFirstChild("Right Leg") or char:FindFirstChild("RightFoot"),
        char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftFoot"),
        char:FindFirstChild("Right Arm") or char:FindFirstChild("RightHand")
    }

    pcall(function()
        if firetouchinterest then
            for _, p in ipairs(partsToTouch) do
                if p and p:IsA("BasePart") then
                    firetouchinterest(p, part, 0)
                    task.wait()
                    firetouchinterest(p, part, 1)
                end
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
            fireclickdetector(detector, 1)
        end
    end)
end

-- Universal GUI Button Click
local function clickGuiButton(btn)
    if not btn or not btn:IsA("GuiButton") then return end
    pcall(function()
        if getconnections then
            for _, conn in ipairs(getconnections(btn.MouseButton1Click)) do conn:Fire() end
            for _, conn in ipairs(getconnections(btn.Activated)) do conn:Fire() end
            for _, conn in ipairs(getconnections(btn.MouseButton1Down)) do conn:Fire() end
        end
    end)
end

-- Comprehensive Remote Finder
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

-- Fast Auto Broom / Attack Action
local function autoBroomAttack()
    local char = LocalPlayer.Character
    if not char then return end

    -- Auto-Equip Broom or Vacuum
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then
        local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        if backpack then
            for _, bTool in ipairs(backpack:GetChildren()) do
                if bTool:IsA("Tool") then
                    bTool.Parent = char
                    tool = bTool
                    break
                end
            end
        end
    end

    if tool then
        pcall(function() tool:Activate() end)
        for _, sub in ipairs(tool:GetDescendants()) do
            if sub:IsA("RemoteEvent") then
                pcall(function() sub:FireServer() end)
            elseif sub:IsA("RemoteFunction") then
                pcall(function() sub:InvokeServer() end)
            end
        end
    end

    -- Trigger Click simulation for tool swinging
    if VirtualUser then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(400, 400))
        end)
    end
    if VirtualInputManager then
        pcall(function()
            VirtualInputManager:SendMouseButtonEvent(400, 400, 0, true, game, 0)
            task.wait(0.01)
            VirtualInputManager:SendMouseButtonEvent(400, 400, 0, false, game, 0)
        end)
    end
end

-- Scan workspace for all garbage/trash items on the lawn
local function getAllTrashObjects()
    local list = {}
    local char = LocalPlayer.Character

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if char and obj:IsDescendantOf(char) then
            continue
        end

        local name = obj.Name:lower()
        local parentName = obj.Parent and obj.Parent.Name:lower() or ""

        -- Skip players, terrain, cameras
        if obj:IsA("Terrain") or obj:IsA("Camera") or obj.Parent:FindFirstChildOfClass("Humanoid") then
            continue
        end

        local isTrashCandidate = false

        -- 1. Keyword check
        local kwList = {
            "trash", "garbage", "debris", "dirt", "waste", "clean", "sludge", "paper",
            "can", "bottle", "plastic", "toxic", "barrel", "leaf", "leaves", "drop", "item", "spawn", "spot"
        }
        for _, kw in ipairs(kwList) do
            if name:find(kw) or parentName:find(kw) then
                isTrashCandidate = true
                break
            end
        end

        -- 2. Check parts placed on ground with small sizes (white trash balls, grey cans, etc.)
        if not isTrashCandidate and obj:IsA("BasePart") and not obj.Anchored and obj.CanCollide == false then
            isTrashCandidate = true
        elseif not isTrashCandidate and obj:IsA("BasePart") and obj.Size.Magnitude < 10 and obj.Size.Magnitude > 0.4 then
            if not parentName:find("map") and not parentName:find("fence") and not parentName:find("road") and not parentName:find("house") then
                isTrashCandidate = true
            end
        elseif not isTrashCandidate and (obj:IsA("SpecialMesh") or obj:IsA("MeshPart")) then
            if not parentName:find("map") and not parentName:find("building") and not parentName:find("road") then
                isTrashCandidate = true
            end
        end

        -- 3. Check ProximityPrompt
        local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
        if prompt then
            local act = (prompt.ActionText .. " " .. prompt.ObjectText):lower()
            if act:find("clean") or act:find("sweep") or act:find("pick") or act:find("collect") or act:find("suck") then
                isTrashCandidate = true
            end
        end

        if isTrashCandidate then
            local part = nil
            if obj:IsA("BasePart") then
                part = obj
            elseif obj:IsA("Model") then
                part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)
            end

            if part and part:IsA("BasePart") and part.Parent then
                table.insert(list, {part = part, rootObj = obj})
            end
        end
    end

    return list
end

-- Find Sell Zone / Dumpster / Bin
local function getSellZones()
    local zones = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local n = obj.Name:lower()
            local p = obj.Parent and obj.Parent.Name:lower() or ""
            if n:find("sell") or n:find("bin") or n:find("dump") or n:find("deposit") or n:find("drop") or
               p:find("sell") or p:find("bin") or p:find("dumpster") or p:find("trashcan") then
                table.insert(zones, obj)
            end
        end
    end
    return zones
end

--==============================================================--
--  GUI CREATION (Exact Saved ULTRA SCRIPT HUB Design)
--==============================================================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraScriptHub_CleanTheWorld"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999

-- Clean previous instances
pcall(function()
    if CoreGui and CoreGui:FindFirstChild("UltraScriptHub_CleanTheWorld") then
        CoreGui:FindFirstChild("UltraScriptHub_CleanTheWorld"):Destroy()
    end
    local lpGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if lpGui and lpGui:FindFirstChild("UltraScriptHub_CleanTheWorld") then
        lpGui:FindFirstChild("UltraScriptHub_CleanTheWorld"):Destroy()
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
MainFrame.Size = UDim2.new(0, 330, 0, 365)
MainFrame.Position = UDim2.new(0.5, -165, 0.35, -182)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 1
UIStroke.Color = Color3.fromRGB(40, 40, 48)
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

-- Floating Toggle Button (Open/Close GUI)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleHubBtn"
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0, 15, 0.5, -22)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Text = "🧹"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 22
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleBtn

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Thickness = 1
ToggleStroke.Color = Color3.fromRGB(55, 55, 65)
ToggleStroke.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Header Title
local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -50, 0, 32)
HeaderTitle.Position = UDim2.new(0, 16, 0, 12)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "CLEAN THE WORLD"
HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitle.TextSize = 13
HeaderTitle.Font = Enum.Font.SourceSansBold
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.Parent = MainFrame

-- Close Button (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -34, 0, 12)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
CloseBtn.TextSize = 15
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Parent = MainFrame

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Features Container
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -32, 0, 265)
Container.Position = UDim2.new(0, 16, 0, 48)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 0)
UIListLayout.Parent = Container

-- Footer Branding
local FooterTitle = Instance.new("TextLabel")
FooterTitle.Size = UDim2.new(1, 0, 0, 18)
FooterTitle.Position = UDim2.new(0, 0, 1, -40)
FooterTitle.BackgroundTransparency = 1
FooterTitle.Text = "ULTRA SCRIPT HUB"
FooterTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
FooterTitle.TextSize = 14
FooterTitle.Font = Enum.Font.SourceSansBold
FooterTitle.Parent = MainFrame

local FooterSub = Instance.new("TextLabel")
FooterSub.Size = UDim2.new(1, 0, 0, 16)
FooterSub.Position = UDim2.new(0, 0, 1, -22)
FooterSub.BackgroundTransparency = 1
FooterSub.Text = "Made by Junejo"
FooterSub.TextColor3 = Color3.fromRGB(150, 150, 150)
FooterSub.TextSize = 12
FooterSub.Font = Enum.Font.SourceSans
FooterSub.Parent = MainFrame

-- Checkbox Row Generator
local function CreateToggleRow(name, callback, isLast)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 36)
    Row.BackgroundTransparency = 1
    Row.Parent = Container

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -45, 1, 0)
    Label.Position = UDim2.new(0, 4, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 13
    Label.Font = Enum.Font.SourceSansBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local Checkbox = Instance.new("TextButton")
    Checkbox.Size = UDim2.new(0, 20, 0, 20)
    Checkbox.Position = UDim2.new(1, -24, 0.5, -10)
    Checkbox.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    Checkbox.BorderColor3 = Color3.fromRGB(75, 80, 95)
    Checkbox.BorderSizePixel = 1
    Checkbox.Text = ""
    Checkbox.TextColor3 = Color3.fromRGB(255, 255, 255)
    Checkbox.TextSize = 14
    Checkbox.Font = Enum.Font.SourceSansBold
    Checkbox.Parent = Row

    local CheckCorner = Instance.new("UICorner")
    CheckCorner.CornerRadius = UDim.new(0, 4)
    CheckCorner.Parent = Checkbox

    local isChecked = false
    Checkbox.MouseButton1Click:Connect(function()
        isChecked = not isChecked
        if isChecked then
            Checkbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Checkbox.TextColor3 = Color3.fromRGB(0, 0, 0)
            Checkbox.Text = "✓"
        else
            Checkbox.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
            Checkbox.TextColor3 = Color3.fromRGB(255, 255, 255)
            Checkbox.Text = ""
        end
        callback(isChecked)
    end)

    if not isLast then
        local Divider = Instance.new("Frame")
        Divider.Size = UDim2.new(1, 0, 0, 1)
        Divider.Position = UDim2.new(0, 0, 1, -1)
        Divider.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        Divider.BorderSizePixel = 0
        Divider.Parent = Row
    end

    return Checkbox
end

-- Exact 7 Feature Toggle Rows
CreateToggleRow("Auto Clean / Vacuum Aura", function(state)
    AutoCleanAuraEnabled = state
end, false)

CreateToggleRow("Auto Sell Waste", function(state)
    AutoSellEnabled = state
end, false)

CreateToggleRow("Auto Prestige", function(state)
    AutoPrestigeEnabled = state
end, false)

CreateToggleRow("Auto Upgrade", function(state)
    AutoUpgradeEnabled = state
end, false)

CreateToggleRow("Auto Unlock Zones", function(state)
    AutoUnlockZonesEnabled = state
end, false)

CreateToggleRow("Trash ESP / Rare Chams", function(state)
    TrashESPEnabled = state
end, false)

CreateToggleRow("Fly Mode", function(state)
    FlyEnabled = state
end, true)

--==============================================================--
--  1. AUTO CLEAN / VACUUM AURA (High-Speed Sweep & Broom Magnet)
--==============================================================--
task.spawn(function()
    while true do
        if AutoCleanAuraEnabled then
            pcall(function()
                local root = getRoot()
                if not root then return end

                -- Trigger broom / attack
                autoBroomAttack()

                -- Scan all trash objects on ground
                local trashItems = getAllTrashObjects()

                -- Sort by nearest
                local curPos = root.Position
                table.sort(trashItems, function(a, b)
                    return (a.part.Position - curPos).Magnitude < (b.part.Position - curPos).Magnitude
                end)

                -- Sweep through the nearest trash items
                for i = 1, math.min(10, #trashItems) do
                    if not AutoCleanAuraEnabled then break end
                    local item = trashItems[i]
                    if item and item.part and item.part.Parent then
                        -- Prevent fling
                        pcall(function()
                            root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        end)

                        -- Step right next to / on top of trash
                        root.CFrame = CFrame.new(item.part.Position + Vector3.new(0, 1.2, 0))

                        -- Pulse touch with Character + Broom
                        safeTouch(item.part)

                        -- Trigger Proximity Prompts
                        local prompt = item.part:FindFirstChildWhichIsA("ProximityPrompt", true) or item.rootObj:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if prompt then triggerPrompt(prompt) end

                        -- Click detectors
                        local click = item.part:FindFirstChildWhichIsA("ClickDetector", true) or item.rootObj:FindFirstChildWhichIsA("ClickDetector", true)
                        if click then safeClick(click) end

                        autoBroomAttack()
                        task.wait(0.04)
                    end
                end

                -- Fire all cleaning and vacuum remotes
                local cleanRemotes = findRemotes({
                    "clean", "vacuum", "sweep", "suck", "collect", "trash", "pickup", "absorb", "damage", "hit", "waste", "debris", "attack"
                })
                for _, rem in ipairs(cleanRemotes) do
                    pcall(function()
                        if rem:IsA("RemoteEvent") then
                            rem:FireServer()
                            rem:FireServer("Trash")
                            rem:FireServer(1)
                            rem:FireServer(true)
                        elseif rem:IsA("RemoteFunction") then
                            rem:InvokeServer()
                            rem:InvokeServer("Trash")
                            rem:InvokeServer(1)
                        end
                    end)
                end
            end)
            task.wait(0.02)
        else
            task.wait(0.3)
        end
    end
end)

--==============================================================--
--  2. AUTO SELL WASTE (Instant Dumpster / Base Deposit)
--==============================================================--
task.spawn(function()
    while true do
        if AutoSellEnabled then
            pcall(function()
                local root = getRoot()
                if not root then return end

                local sellZones = getSellZones()

                -- If sell zones found, touch and interact with them
                for _, zone in ipairs(sellZones) do
                    if not AutoSellEnabled then break end
                    if zone and zone.Parent then
                        safeTouch(zone)
                        local prompt = zone:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if prompt then triggerPrompt(prompt) end
                    end
                end

                -- Click Sell / Dump UI buttons in PlayerGui
                local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                if playerGui then
                    for _, btn in ipairs(playerGui:GetDescendants()) do
                        if btn:IsA("GuiButton") and btn.Visible then
                            local bName = btn.Name:lower()
                            local bText = (btn:IsA("TextButton") and btn.Text:lower()) or ""
                            if bName:find("sell") or bName:find("deposit") or bName:find("dump") or bName:find("dropoff") or
                               bText:find("sell") or bText:find("deposit") or bText:find("dump") then
                                clickGuiButton(btn)
                            end
                        end
                    end
                end

                -- Fire Sell Remotes
                local sellRemotes = findRemotes({
                    "sell", "deposit", "convert", "empty", "dropoff", "dump", "bin", "sellwaste", "selltrash"
                })
                for _, rem in ipairs(sellRemotes) do
                    pcall(function()
                        if rem:IsA("RemoteEvent") then
                            rem:FireServer()
                            rem:FireServer(true)
                            rem:FireServer("All")
                        elseif rem:IsA("RemoteFunction") then
                            rem:InvokeServer()
                            rem:InvokeServer(true)
                        end
                    end)
                end
            end)
            task.wait(0.3)
        else
            task.wait(0.5)
        end
    end
end)

--==============================================================--
--  3. AUTO PRESTIGE (GUI & Remotes)
--==============================================================--
task.spawn(function()
    while true do
        if AutoPrestigeEnabled then
            pcall(function()
                -- Check and click Prestige GUI Buttons
                local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                if playerGui then
                    for _, btn in ipairs(playerGui:GetDescendants()) do
                        if btn:IsA("GuiButton") and btn.Visible then
                            local bName = btn.Name:lower()
                            local bText = (btn:IsA("TextButton") and btn.Text:lower()) or ""
                            if bName:find("prestige") or bName:find("rebirth") or bText:find("prestige") or bText:find("rebirth") then
                                clickGuiButton(btn)
                            end
                        end
                    end
                end

                -- Fire Prestige Remotes
                local prestigeRemotes = findRemotes({
                    "prestige", "rebirth", "ascend", "resetworld", "cleanprestige", "rankup"
                })
                for _, rem in ipairs(prestigeRemotes) do
                    pcall(function()
                        if rem:IsA("RemoteEvent") then
                            rem:FireServer()
                            rem:FireServer(1)
                            rem:FireServer(true)
                        elseif rem:IsA("RemoteFunction") then
                            rem:InvokeServer()
                            rem:InvokeServer(1)
                        end
                    end)
                end
            end)
            task.wait(0.8)
        else
            task.wait(0.8)
        end
    end
end)

--==============================================================--
--  4. AUTO UPGRADE (Skill Tree & Stats Purchase)
--==============================================================--
task.spawn(function()
    while true do
        if AutoUpgradeEnabled then
            pcall(function()
                -- Click Skill Tree and Upgrade buttons in PlayerGui
                local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                if playerGui then
                    for _, btn in ipairs(playerGui:GetDescendants()) do
                        if btn:IsA("GuiButton") and btn.Visible then
                            local bName = btn.Name:lower()
                            local bText = (btn:IsA("TextButton") and btn.Text:lower()) or ""
                            if bName:find("upgrade") or bName:find("buy") or bName:find("skill") or bName:find("level") or
                               bText:find("upgrade") or bText:find("buy") or bText:find("max") or bText:find("lvl") then
                                clickGuiButton(btn)
                            end
                        end
                    end
                end

                -- Fire Upgrade Remotes
                local upgradeRemotes = findRemotes({
                    "upgrade", "buyupgrade", "purchase", "buystat", "speedupgrade", "capacity", "power", "range", "skilltree", "buyskill"
                })
                for _, rem in ipairs(upgradeRemotes) do
                    pcall(function()
                        if rem:IsA("RemoteEvent") then
                            rem:FireServer("Speed")
                            rem:FireServer("Capacity")
                            rem:FireServer("Power")
                            rem:FireServer("Range")
                            rem:FireServer(1)
                        elseif rem:IsA("RemoteFunction") then
                            rem:InvokeServer("Speed")
                            rem:InvokeServer("Capacity")
                            rem:InvokeServer("Power")
                        end
                    end)
                end
            end)
            task.wait(0.6)
        else
            task.wait(0.8)
        end
    end
end)

--==============================================================--
--  5. AUTO UNLOCK ZONES / WORLDS
--==============================================================--
task.spawn(function()
    while true do
        if AutoUnlockZonesEnabled then
            pcall(function()
                local root = getRoot()
                if not root then return end

                -- Find zone gates, doors, unlock pads
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not AutoUnlockZonesEnabled then break end
                    if obj:IsA("BasePart") then
                        local n = obj.Name:lower()
                        local p = obj.Parent and obj.Parent.Name:lower() or ""
                        if n:find("zone") or n:find("gate") or n:find("unlock") or n:find("portal") or n:find("door") or
                           p:find("zones") or p:find("gates") or p:find("worlds") then
                            safeTouch(obj)
                            local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if prompt then triggerPrompt(prompt) end
                        end
                    end
                end

                -- Fire Zone Remotes
                local zoneRemotes = findRemotes({
                    "zone", "unlockzone", "buyzone", "unlockworld", "portal", "gate", "nextzone"
                })
                for _, rem in ipairs(zoneRemotes) do
                    pcall(function()
                        if rem:IsA("RemoteEvent") then
                            rem:FireServer(1)
                            rem:FireServer(2)
                            rem:FireServer(3)
                            rem:FireServer(true)
                        elseif rem:IsA("RemoteFunction") then
                            rem:InvokeServer(1)
                        end
                    end)
                end
            end)
            task.wait(1.5)
        else
            task.wait(1)
        end
    end
end)

--==============================================================--
--  6. TRASH ESP / RARE CHAMS
--==============================================================--
local activeESP = {}

local function clearESP()
    for _, obj in pairs(activeESP) do
        if obj.highlight then pcall(function() obj.highlight:Destroy() end) end
        if obj.billboard then pcall(function() obj.billboard:Destroy() end) end
    end
    table.clear(activeESP)
end

task.spawn(function()
    while true do
        if TrashESPEnabled then
            pcall(function()
                local root = getRoot()
                local foundKeys = {}
                local trashItems = getAllTrashObjects()

                for _, item in ipairs(trashItems) do
                    if not TrashESPEnabled then break end
                    local part = item.part
                    local obj = item.rootObj

                    if part and part.Parent and part:IsA("BasePart") then
                        local key = part:GetDebugId() or tostring(part:GetFullName())
                        foundKeys[key] = true

                        if not activeESP[key] then
                            -- Create Glowing Highlight
                            local hl = Instance.new("Highlight")
                            hl.Name = "TrashESP_HL"
                            hl.FillColor = Color3.fromRGB(0, 255, 170)
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            hl.FillTransparency = 0.3
                            hl.OutlineTransparency = 0
                            hl.Adornee = obj:IsA("Model") and obj or part
                            hl.Parent = ScreenGui

                            -- Create BillboardGui
                            local bb = Instance.new("BillboardGui")
                            bb.Name = "TrashESP_BB"
                            bb.Size = UDim2.new(0, 130, 0, 30)
                            bb.AlwaysOnTop = true
                            bb.Adornee = part
                            bb.Parent = ScreenGui

                            local txt = Instance.new("TextLabel")
                            txt.Name = "DistLabel"
                            txt.Size = UDim2.new(1, 0, 1, 0)
                            txt.BackgroundTransparency = 1
                            txt.TextColor3 = Color3.fromRGB(80, 255, 200)
                            txt.TextStrokeTransparency = 0
                            txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                            txt.TextSize = 13
                            txt.Font = Enum.Font.SourceSansBold
                            txt.Parent = bb

                            activeESP[key] = {highlight = hl, billboard = bb, label = txt, part = part, name = obj.Name}
                        end

                        -- Update Distance
                        if activeESP[key] and activeESP[key].label and root then
                            local dist = math.floor((part.Position - root.Position).Magnitude)
                            activeESP[key].label.Text = "🗑️ " .. activeESP[key].name .. " [" .. tostring(dist) .. "m]"
                        end
                    end
                end

                -- Clean dead items
                for key, data in pairs(activeESP) do
                    if not foundKeys[key] or not data.part or not data.part.Parent then
                        if data.highlight then pcall(function() data.highlight:Destroy() end) end
                        if data.billboard then pcall(function() data.billboard:Destroy() end) end
                        activeESP[key] = nil
                    end
                end
            end)
            task.wait(0.3)
        else
            clearESP()
            task.wait(0.5)
        end
    end
end)

--==============================================================--
--  7. FLY MODE & MOVEMENT UTILITY
--==============================================================--
local bodyGyro, bodyVelocity
RunService.RenderStepped:Connect(function()
    if FlyEnabled then
        local root = getRoot()
        local hum = getHum()
        if root and hum then
            if not bodyGyro or not bodyGyro.Parent then
                bodyGyro = Instance.new("BodyGyro")
                bodyGyro.P = 9e4
                bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                bodyGyro.CFrame = root.CFrame
                bodyGyro.Parent = root
            end
            if not bodyVelocity or not bodyVelocity.Parent then
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                bodyVelocity.Parent = root
            end

            hum.PlatformStand = true
            bodyGyro.CFrame = Camera.CFrame

            local moveDir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + (Camera.CFrame.LookVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - (Camera.CFrame.LookVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - (Camera.CFrame.RightVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + (Camera.CFrame.RightVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDir = moveDir - Vector3.new(0, 1, 0)
            end

            -- Mobile joystick support
            if hum.MoveDirection.Magnitude > 0 and moveDir.Magnitude == 0 then
                moveDir = (Camera.CFrame.LookVector * (hum.MoveDirection.Z * -1)) + (Camera.CFrame.RightVector * (hum.MoveDirection.X * 1))
            end

            if moveDir.Magnitude > 0 then
                bodyVelocity.Velocity = moveDir.Unit * FlySpeed
            else
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
        end
    else
        if bodyGyro then bodyGyro:Destroy(); bodyGyro = nil end
        if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
        local hum = getHum()
        if hum and hum.PlatformStand then
            hum.PlatformStand = false
        end
    end
end)

print("[ULTRA SCRIPT HUB] Clean the WORLD! v3.0 Loaded Successfully!")

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ULTRA SCRIPT HUB",
        Text = "Clean the WORLD! v3.0 (Active & Ready)!",
        Duration = 5
    })
end)
