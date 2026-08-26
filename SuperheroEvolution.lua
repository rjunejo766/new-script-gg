--==============================================================--
--  ULTRA SCRIPT HUB - Made by Junejo
--  Game: +1 Superhero Evolution
--  Version: 1.0 (Full Auto Train, Win, Rebirth & Best Egg Edition)
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

-- Feature Toggle States
local AutoTrainEnabled = false
local AutoWinEnabled = false
local AutoRebirthEnabled = false
local AutoBuyBestEggEnabled = false

-- Anti-AFK Setup
LocalPlayer.Idled:Connect(function()
    if VirtualUser then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

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
        if prompt.Enabled == false then return end
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

-- Equip Best Weapon / Training Tool
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
ScreenGui.Name = "UltraScriptHub_SuperheroEvolution"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999

local parentGui = nil
if gethui then 
    pcall(function() parentGui = gethui() end) 
end
if not parentGui then 
    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(ScreenGui)
        end
        parentGui = CoreGui
    end) 
end
if not parentGui then 
    pcall(function()
        parentGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
    end) 
end

pcall(function()
    if parentGui and parentGui:FindFirstChild("UltraScriptHub_SuperheroEvolution") then
        parentGui:FindFirstChild("UltraScriptHub_SuperheroEvolution"):Destroy()
    end
    if CoreGui and CoreGui:FindFirstChild("UltraScriptHub_SuperheroEvolution") then
        CoreGui:FindFirstChild("UltraScriptHub_SuperheroEvolution"):Destroy()
    end
    local lpGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if lpGui and lpGui:FindFirstChild("UltraScriptHub_SuperheroEvolution") then
        lpGui:FindFirstChild("UltraScriptHub_SuperheroEvolution"):Destroy()
    end
end)

pcall(function()
    ScreenGui.Parent = parentGui
end)
if not ScreenGui.Parent then
    pcall(function()
        ScreenGui.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui") or CoreGui
    end)
end

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
HeaderTitle.Text = "+1 SUPERHERO EVOLUTION"
HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitle.TextSize = 15
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
--  ADD 4 REQUESTED FEATURES TO GUI
--==============================================================--
CreateToggleRow("Auto Train (Power)", function(state)
    AutoTrainEnabled = state
end)

CreateToggleRow("Auto Win (Finish Track)", function(state)
    AutoWinEnabled = state
end)

CreateToggleRow("Auto Rebirth", function(state)
    AutoRebirthEnabled = state
end)

CreateToggleRow("Auto Buy Best Egg", function(state)
    AutoBuyBestEggEnabled = state
end)

--==============================================================--
--  1. AUTO TRAIN LOOP (Damage / Power / Dummy / Remotes)
--==============================================================--
task.spawn(function()
    while true do
        if AutoTrainEnabled then
            pcall(function()
                -- 1. Equip weapon / tool & activate
                local tool = equipTool()
                if tool then
                    tool:Activate()
                end

                -- 2. Trigger training and damage remotes
                local trainRemotes = findRemotes({
                    "damage", "gaindamage", "gain_damage", "tap", "train", "click", 
                    "punch", "power", "addpower", "gainpower", "strength", "workout", 
                    "energy", "claw", "attack", "strike", "dummy", "hit", "weapon"
                })
                for _, remote in ipairs(trainRemotes) do
                    if remote:IsA("RemoteEvent") then
                        remote:FireServer()
                    elseif remote:IsA("RemoteFunction") then
                        remote:InvokeServer()
                    end
                end

                -- 3. Hit / interact with nearby Training Dummies or Workout Prompts
                local root = getRoot()
                if root then
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") then
                            local part = obj.Parent
                            if part and part:IsA("BasePart") then
                                local dist = (part.Position - root.Position).Magnitude
                                if dist < 25 then
                                    local act = (obj.ActionText .. " " .. obj.ObjectText):lower()
                                    if act:find("train") or act:find("power") or act:find("damage") or act:find("hit") or act:find("tap") then
                                        triggerPrompt(obj)
                                    end
                                end
                            end
                        elseif obj:IsA("ClickDetector") then
                            local part = obj.Parent
                            if part and part:IsA("BasePart") then
                                local dist = (part.Position - root.Position).Magnitude
                                if dist < 25 then
                                    safeClick(obj)
                                end
                            end
                        end
                    end
                end

                -- 4. VirtualUser fallback click
                if VirtualUser then
                    VirtualUser:Button1Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
                end
            end)
            task.wait(0.08)
        else
            task.wait(0.5)
        end
    end
end)

-- Universal FireSignal helper for GUI buttons
local function clickGuiButton(btn)
    if not btn or not btn:IsA("GuiButton") then return end
    pcall(function()
        if firesignal then
            firesignal(btn.MouseButton1Click)
            firesignal(btn.MouseButton1Down)
            firesignal(btn.MouseButton1Up)
            firesignal(btn.Activated)
        elseif getconnections and btn.MouseButton1Click then
            for _, conn in ipairs(getconnections(btn.MouseButton1Click)) do
                conn:Fire()
            end
        end
    end)
end

--==============================================================--
--  2. SUPERCHARGED AUTO WIN (Finish Track / Gates / Remotes / Pads)
--==============================================================--
task.spawn(function()
    while true do
        if AutoWinEnabled then
            pcall(function()
                local root = getRoot()
                if not root then return end

                -- 1. Scan & fire all Win, Finish, Race, Stage Remotes
                local winKeywords = {
                    "win", "wins", "finish", "finishline", "claimwin", "givereward", 
                    "endrace", "addwin", "reachfinish", "claim", "reward", "stage", 
                    "checkpoint", "race", "goal", "nextstage", "nextzone", "complete"
                }
                local winRemotes = findRemotes(winKeywords)
                for _, remote in ipairs(winRemotes) do
                    pcall(function()
                        if remote:IsA("RemoteEvent") then
                            remote:FireServer()
                            remote:FireServer(1)
                            remote:FireServer("Win")
                            remote:FireServer(true)
                        elseif remote:IsA("RemoteFunction") then
                            remote:InvokeServer()
                            remote:InvokeServer(1)
                        end
                    end)
                end

                -- 2. Scan Workspace for Win Pads, Finish Lines, End Gates, Stage Portals
                local winTargets = {}
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local n = obj.Name:lower()
                        local p = obj.Parent and obj.Parent.Name:lower() or ""
                        if n:find("win") or n:find("finish") or n:find("goal") or n:find("endpad") or n:find("stage") or n:find("checkpoint") or n:find("reward") or
                           p:find("win") or p:find("finish") or p:find("track") or p:find("race") then
                            table.insert(winTargets, obj)
                        end
                    elseif obj:IsA("ProximityPrompt") then
                        local act = (obj.ActionText .. " " .. obj.ObjectText):lower()
                        if act:find("win") or act:find("claim") or act:find("finish") or act:find("reward") then
                            triggerPrompt(obj)
                        end
                    end
                end

                -- 3. Touch all detected win pads
                for _, pad in ipairs(winTargets) do
                    if not AutoWinEnabled then break end
                    safeTouch(root, pad)
                end
            end)
            task.wait(0.3)
        else
            task.wait(0.5)
        end
    end
end)

--==============================================================--
--  3. SUPERCHARGED AUTO REBIRTH (Remotes + GUI Buttons + Pads)
--==============================================================--
task.spawn(function()
    while true do
        if AutoRebirthEnabled then
            pcall(function()
                local root = getRoot()

                -- 1. Scan and Fire Rebirth / Evolution Remotes
                local rebirthKeywords = {
                    "rebirth", "rebirths", "evolve", "evolution", "ascend", "prestige", 
                    "buyrebirth", "requestrebirth", "dorebirth", "rankup", "upgradehero", 
                    "herorebirth", "heroevolution", "transform"
                }
                local rebirthRemotes = findRemotes(rebirthKeywords)
                for _, remote in ipairs(rebirthRemotes) do
                    pcall(function()
                        if remote:IsA("RemoteEvent") then
                            remote:FireServer()
                            remote:FireServer(1)
                            remote:FireServer(true)
                            remote:FireServer("Rebirth")
                            remote:FireServer("1")
                        elseif remote:IsA("RemoteFunction") then
                            remote:InvokeServer()
                            remote:InvokeServer(1)
                        end
                    end)
                end

                -- 2. Click Rebirth / Evolve Buttons inside PlayerGui
                local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                if playerGui then
                    for _, obj in ipairs(playerGui:GetDescendants()) do
                        if obj:IsA("GuiButton") and obj.Visible then
                            local name = obj.Name:lower()
                            local text = (obj:IsA("TextButton") and obj.Text:lower()) or ""
                            if name:find("rebirth") or name:find("evolve") or text:find("rebirth") or text:find("evolve") or text:find("evolution") then
                                clickGuiButton(obj)
                            end
                        end
                    end
                end

                -- 3. Trigger Workspace Rebirth Prompts & Pads
                if root then
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") then
                            local act = (obj.ActionText .. " " .. obj.ObjectText):lower()
                            if act:find("rebirth") or act:find("evolve") or act:find("evolution") then
                                triggerPrompt(obj)
                            end
                        elseif obj:IsA("BasePart") then
                            local n = obj.Name:lower()
                            if n:find("rebirth") or n:find("evolve") then
                                safeTouch(root, obj)
                            end
                        end
                    end
                end
            end)
            task.wait(0.8)
        else
            task.wait(0.5)
        end
    end
end)

--==============================================================--
--  4. SUPERCHARGED AUTO BUY BEST EGG (Smart Multi-Tier Hatching)
--==============================================================--
task.spawn(function()
    while true do
        if AutoBuyBestEggEnabled then
            pcall(function()
                local root = getRoot()

                -- 1. Find all Egg / Hatch Remotes
                local eggKeywords = {
                    "hatch", "openegg", "buyegg", "purchaseegg", "hatchpet", "draweqq", 
                    "egg", "eggs", "capsule", "opencapsule", "buycapsule", "pet", "pethatch",
                    "drawpet", "buypet", "hatchsingle", "open"
                }
                local hatchRemotes = findRemotes(eggKeywords)

                -- 2. Discover all Egg models in Workspace & ReplicatedStorage
                local discoveredEggs = {}
                local function scanForEggs(parent)
                    if not parent then return end
                    for _, obj in ipairs(parent:GetDescendants()) do
                        local name = obj.Name:lower()
                        if (name:find("egg") or name:find("capsule") or name:find("gacha")) and 
                           (obj:IsA("Model") or obj:IsA("BasePart") or obj:IsA("Folder")) then
                            table.insert(discoveredEggs, obj)
                        end
                    end
                end

                scanForEggs(Workspace)
                scanForEggs(ReplicatedStorage)

                -- 3. Fire hatch remotes with detected egg names and common defaults
                local eggNamesToTry = {}
                for _, eggObj in ipairs(discoveredEggs) do
                    table.insert(eggNamesToTry, eggObj.Name)
                end
                -- Add fallback standard names
                for _, commonName in ipairs({"Starter Egg", "Basic Egg", "Common Egg", "Egg1", "Starter", "Egg", "Spider Egg", "Iron Egg", "Hero Egg"}) do
                    table.insert(eggNamesToTry, commonName)
                end

                for _, remote in ipairs(hatchRemotes) do
                    for _, eggName in ipairs(eggNamesToTry) do
                        if not AutoBuyBestEggEnabled then break end
                        pcall(function()
                            if remote:IsA("RemoteEvent") then
                                remote:FireServer(eggName, 1)
                                remote:FireServer(eggName, "Single")
                                remote:FireServer(eggName, 1, false)
                                remote:FireServer(eggName, {})
                                remote:FireServer(eggName)
                            elseif remote:IsA("RemoteFunction") then
                                remote:InvokeServer(eggName, 1)
                                remote:InvokeServer(eggName, "Single")
                            end
                        end)
                    end
                    -- Also fire generic open calls
                    pcall(function()
                        if remote:IsA("RemoteEvent") then
                            remote:FireServer("Single", 1)
                            remote:FireServer(1)
                        end
                    end)
                end

                -- 4. Trigger nearest egg ProximityPrompt or Touch
                if root then
                    for _, eggObj in ipairs(discoveredEggs) do
                        if eggObj:IsA("BasePart") then
                            safeTouch(root, eggObj)
                        elseif eggObj:IsA("Model") then
                            local primary = eggObj.PrimaryPart or eggObj:FindFirstChildWhichIsA("BasePart")
                            if primary then
                                safeTouch(root, primary)
                            end
                        end

                        local prompt = eggObj:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if prompt then
                            triggerPrompt(prompt)
                        end
                    end
                end

                -- 5. Click any Hatch / Buy Button in PlayerGui if open
                local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                if playerGui then
                    for _, obj in ipairs(playerGui:GetDescendants()) do
                        if obj:IsA("GuiButton") and obj.Visible then
                            local name = obj.Name:lower()
                            local text = (obj:IsA("TextButton") and obj.Text:lower()) or ""
                            if (name:find("hatch") or name:find("buy1") or text:find("hatch") or text:find("open 1") or text:find("buy")) and not name:find("robux") then
                                clickGuiButton(obj)
                            end
                        end
                    end
                end
            end)
            task.wait(0.5)
        else
            task.wait(0.5)
        end
    end
end)

print("[ULTRA SCRIPT HUB] +1 Superhero Evolution Loaded Successfully!")

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ULTRA SCRIPT HUB",
        Text = "+1 Superhero Evolution Loaded!",
        Duration = 5
    })
end)

