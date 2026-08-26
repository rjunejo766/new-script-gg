--==============================================================--
--  ULTRA SCRIPT HUB - Made by Junejo
--  Game: Save Your Cat
--  Version: 1.0 (Inf Seed, Auto Rebirth, Auto Button)
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

-- Feature Toggle States
local InfSeedEnabled = false
local AutoRebirthEnabled = false
local AutoButtonEnabled = false

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
local function getChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

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

-- Safe Touch Function
local function safeTouch(part1, part2)
    if not part1 or not part2 then return end
    pcall(function()
        if firetouchinterest then
            firetouchinterest(part1, part2, 0)
            task.wait()
            firetouchinterest(part1, part2, 1)
        end
    end)
end

-- Safe ProximityPrompt Trigger
local function triggerPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return end
    pcall(function()
        if fireproximityprompt then
            fireproximityprompt(prompt, 0)
        else
            prompt:InputHoldBegin()
            task.wait(prompt.HoldDuration or 0.1)
            prompt:InputHoldEnd()
        end
    end)
end

-- Safe GUI Button Click
local function clickGuiButton(btn)
    if not btn or not btn:IsA("GuiButton") then return end
    pcall(function()
        if getconnections then
            for _, conn in ipairs(getconnections(btn.MouseButton1Click)) do
                conn:Fire()
            end
            for _, conn in ipairs(getconnections(btn.Activated)) do
                conn:Fire()
            end
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

--==============================================================--
--  GUI CREATION (Pixel-Perfect ULTRA SCRIPT HUB Design)
--==============================================================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraScriptHub_SaveYourCat"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999

-- Clean previous instances
pcall(function()
    if CoreGui and CoreGui:FindFirstChild("UltraScriptHub_SaveYourCat") then
        CoreGui:FindFirstChild("UltraScriptHub_SaveYourCat"):Destroy()
    end
    local lpGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if lpGui and lpGui:FindFirstChild("UltraScriptHub_SaveYourCat") then
        lpGui:FindFirstChild("UltraScriptHub_SaveYourCat"):Destroy()
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
MainFrame.Size = UDim2.new(0, 320, 0, 245)
MainFrame.Position = UDim2.new(0.5, -160, 0.35, -122)
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
HeaderTitle.Text = "SAVE YOUR CAT"
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
Container.Size = UDim2.new(1, -32, 0, 125)
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
--  ADD 3 REQUESTED FEATURES TO GUI
--==============================================================--
CreateToggleRow("Inf Seed", function(state)
    InfSeedEnabled = state
end)

CreateToggleRow("Auto Rebirth", function(state)
    AutoRebirthEnabled = state
end)

CreateToggleRow("Auto Button", function(state)
    AutoButtonEnabled = state
end)

--==============================================================--
--  1. SUPERCHARGED INF SEED (Farms, Collects & Multiplies Seeds)
--==============================================================--
task.spawn(function()
    while true do
        if InfSeedEnabled then
            pcall(function()
                local root = getRoot()

                -- 1. Scan & Fire Seed / Farming Remotes
                local seedRemotes = findRemotes({
                    "seed", "seeds", "plant", "harvest", "collect", "farm", 
                    "giveseed", "addseed", "claimseed", "feed", "catseed", "drop"
                })
                for _, remote in ipairs(seedRemotes) do
                    pcall(function()
                        if remote:IsA("RemoteEvent") then
                            remote:FireServer()
                            remote:FireServer(1)
                            remote:FireServer(999999)
                            remote:FireServer("Seed")
                            remote:FireServer(true)
                        elseif remote:IsA("RemoteFunction") then
                            remote:InvokeServer()
                            remote:InvokeServer(1)
                            remote:InvokeServer(999999)
                        end
                    end)
                end

                -- 2. Modify Seed Values inside Leaderstats & Player
                local leaderstats = LocalPlayer:FindFirstChild("leaderstats") or LocalPlayer:FindFirstChild("Data")
                if leaderstats then
                    for _, val in ipairs(leaderstats:GetDescendants()) do
                        if val:IsA("IntValue") or val:IsA("NumberValue") then
                            local n = val.Name:lower()
                            if n:find("seed") or n:find("food") or n:find("coin") then
                                val.Value = 999999999
                            end
                        end
                    end
                end

                -- 3. Collect Seed Drops, Plants & Seeds in Workspace
                if root then
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if not InfSeedEnabled then break end
                        if obj:IsA("BasePart") then
                            local n = obj.Name:lower()
                            if n:find("seed") or n:find("drop") or n:find("collect") or n:find("plant") or n:find("food") then
                                safeTouch(root, obj)
                            end
                        elseif obj:IsA("ProximityPrompt") then
                            local act = (obj.ActionText .. " " .. obj.ObjectText):lower()
                            if act:find("seed") or act:find("harvest") or act:find("collect") or act:find("plant") or act:find("feed") or act:find("claim") then
                                triggerPrompt(obj)
                            end
                        end
                    end
                end
            end)
            task.wait(0.2)
        else
            task.wait(0.5)
        end
    end
end)

--==============================================================--
--  2. AUTO REBIRTH (Remotes + GUI Buttons + Rebirth Pads)
--==============================================================--
task.spawn(function()
    while true do
        if AutoRebirthEnabled then
            pcall(function()
                local root = getRoot()

                -- 1. Scan and Fire Rebirth Remotes
                local rebirthRemotes = findRemotes({
                    "rebirth", "rebirths", "buyrebirth", "dorebirth", "requestrebirth", 
                    "catrebirth", "prestige", "evolve", "rankup", "upgradecat"
                })
                for _, remote in ipairs(rebirthRemotes) do
                    pcall(function()
                        if remote:IsA("RemoteEvent") then
                            remote:FireServer()
                            remote:FireServer(1)
                            remote:FireServer(true)
                            remote:FireServer("Rebirth")
                        elseif remote:IsA("RemoteFunction") then
                            remote:InvokeServer()
                            remote:InvokeServer(1)
                        end
                    end)
                end

                -- 2. Click Rebirth Buttons in PlayerGui
                local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                if playerGui then
                    for _, obj in ipairs(playerGui:GetDescendants()) do
                        if obj:IsA("GuiButton") and obj.Visible then
                            local name = obj.Name:lower()
                            local text = (obj:IsA("TextButton") and obj.Text:lower()) or ""
                            if (name:find("rebirth") or text:find("rebirth")) and not name:find("robux") then
                                clickGuiButton(obj)
                            end
                        end
                    end
                end

                -- 3. Trigger Rebirth Prompts and Pads
                if root then
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") then
                            local act = (obj.ActionText .. " " .. obj.ObjectText):lower()
                            if act:find("rebirth") then
                                triggerPrompt(obj)
                            end
                        elseif obj:IsA("BasePart") then
                            local n = obj.Name:lower()
                            if n:find("rebirth") then
                                safeTouch(root, obj)
                            end
                        end
                    end
                end
            end)
            task.wait(0.6)
        else
            task.wait(0.5)
        end
    end
end)

--==============================================================--
--  3. AUTO BUTTON (Auto Buy Tycoon Buttons, Upgrades & Base Pads)
--==============================================================--
task.spawn(function()
    while true do
        if AutoButtonEnabled then
            pcall(function()
                local root = getRoot()
                if not root then return end

                -- 1. Scan and Fire Button / Buy / Build Remotes
                local buttonRemotes = findRemotes({
                    "buybutton", "purchasebutton", "buy", "purchase", "build", 
                    "upgrade", "unlock", "place", "stepbutton", "touchbutton", "claimbutton"
                })
                for _, remote in ipairs(buttonRemotes) do
                    pcall(function()
                        if remote:IsA("RemoteEvent") then
                            remote:FireServer()
                            remote:FireServer(1)
                            remote:FireServer(true)
                        elseif remote:IsA("RemoteFunction") then
                            remote:InvokeServer()
                            remote:InvokeServer(1)
                        end
                    end)
                end

                -- 2. Discover all Tycoon / Base Buttons across Workspace
                local buttons = {}
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not AutoButtonEnabled then break end
                    if obj:IsA("BasePart") then
                        local n = obj.Name:lower()
                        local p = obj.Parent and obj.Parent.Name:lower() or ""
                        if n:find("button") or n:find("pad") or n:find("buy") or n:find("upgrade") or 
                           n:find("unlock") or n:find("build") or p:find("buttons") or p:find("tycoon") or p:find("base") then
                            table.insert(buttons, obj)
                        end
                    elseif obj:IsA("ProximityPrompt") then
                        local act = (obj.ActionText .. " " .. obj.ObjectText):lower()
                        if act:find("buy") or act:find("build") or act:find("upgrade") or act:find("unlock") or act:find("button") then
                            triggerPrompt(obj)
                        end
                    end
                end

                -- Sort buttons by distance from player
                local currentPos = root.Position
                table.sort(buttons, function(a, b)
                    return (a.Position - currentPos).Magnitude < (b.Position - currentPos).Magnitude
                end)

                -- 3. Step on each button smoothly
                for _, btn in ipairs(buttons) do
                    if not AutoButtonEnabled then break end
                    if btn and btn.Parent then
                        safeTouch(root, btn)
                        
                        local prompt = btn:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if prompt then
                            triggerPrompt(prompt)
                        end
                        task.wait(0.08)
                    end
                end
            end)
            task.wait(0.2)
        else
            task.wait(0.5)
        end
    end
end)

print("[ULTRA SCRIPT HUB] Save Your Cat Loaded Successfully!")

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ULTRA SCRIPT HUB",
        Text = "Save Your Cat Loaded!",
        Duration = 5
    })
end)
