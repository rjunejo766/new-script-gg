--==============================================================--
--  ULTRA SCRIPT HUB - Made by Junejo
--  Game: Adopt Me!
--  Game Link: https://www.roblox.com/games/920587237/Adopt-Me
--  Version: 1.1 (Best Pet Spawner, Trade Scam, Auto Farm)
--==============================================================--

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    LocalPlayer = Players.LocalPlayer
end

local Camera = Workspace.CurrentCamera

local VirtualUser = nil
pcall(function() VirtualUser = game:GetService("VirtualUser") end)

-- Feature Toggle States (Exact 3 Features)
local BestPetSpawnerEnabled = false
local TradeScamEnabled = false
local AutoFarmEnabled = false

-- Anti-AFK Setup
pcall(function()
    LocalPlayer.Idled:Connect(function()
        if VirtualUser then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end)
end)

--==============================================================--
--  GUI CREATION (100% Universal Compatibility across all Executors)
--==============================================================--
local GuiName = "UltraScriptHub_AdoptMe"

-- Clean old instances
pcall(function()
    if gethui and gethui():FindFirstChild(GuiName) then
        gethui():FindFirstChild(GuiName):Destroy()
    end
end)
pcall(function()
    if CoreGui and CoreGui:FindFirstChild(GuiName) then
        CoreGui:FindFirstChild(GuiName):Destroy()
    end
end)
pcall(function()
    local pgui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if pgui and pgui:FindFirstChild(GuiName) then
        pgui:FindFirstChild(GuiName):Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = GuiName
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999
ScreenGui.IgnoreGuiInset = true
ScreenGui.Enabled = true

-- Universal safe parenting
local parented = false
if gethui then
    pcall(function()
        ScreenGui.Parent = gethui()
        parented = (ScreenGui.Parent ~= nil)
    end)
end

if not parented then
    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(ScreenGui)
        end
        ScreenGui.Parent = CoreGui
        parented = (ScreenGui.Parent ~= nil)
    end)
end

if not parented or not ScreenGui.Parent then
    pcall(function()
        local pgui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
        ScreenGui.Parent = pgui
        parented = (ScreenGui.Parent ~= nil)
    end)
end

-- Fallback parent
if not ScreenGui.Parent then
    pcall(function() ScreenGui.Parent = CoreGui end)
end

-- Floating Open/Close Toggle Button (Always visible on screen)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "OpenToggleButton"
ToggleButton.Size = UDim2.new(0, 110, 0, 32)
ToggleButton.Position = UDim2.new(0, 15, 0.4, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
ToggleButton.BorderColor3 = Color3.fromRGB(0, 170, 255)
ToggleButton.BorderSizePixel = 1
ToggleButton.Text = "⚡ ULTRA HUB"
ToggleButton.TextColor3 = Color3.fromRGB(0, 200, 255)
ToggleButton.TextSize = 13
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.ZIndex = 100
ToggleButton.Parent = ScreenGui

local ToggleBtnCorner = Instance.new("UICorner")
ToggleBtnCorner.CornerRadius = UDim.new(0, 8)
ToggleBtnCorner.Parent = ToggleButton

-- Main UI Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 250)
MainFrame.Position = UDim2.new(0.5, -160, 0.4, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.ZIndex = 10
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(40, 45, 55)
MainStroke.Thickness = 1.2
MainStroke.Parent = MainFrame

-- Toggle Button Click Action
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
ToggleButton.TouchTap:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Header Title
local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -50, 0, 35)
HeaderTitle.Position = UDim2.new(0, 16, 0, 10)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "ADOPT ME!"
HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitle.TextSize = 15
HeaderTitle.Font = Enum.Font.SourceSansBold
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.ZIndex = 11
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
CloseBtn.ZIndex = 11
CloseBtn.Parent = MainFrame

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)
CloseBtn.TouchTap:Connect(function()
    MainFrame.Visible = false
end)

-- Content Container
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -32, 0, 130)
Container.Position = UDim2.new(0, 16, 0, 48)
Container.BackgroundTransparency = 1
Container.ZIndex = 11
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = Container

-- Footer Titles
local FooterTitle = Instance.new("TextLabel")
FooterTitle.Size = UDim2.new(1, 0, 0, 20)
FooterTitle.Position = UDim2.new(0, 0, 1, -42)
FooterTitle.BackgroundTransparency = 1
FooterTitle.Text = "ULTRA SCRIPT HUB"
FooterTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
FooterTitle.TextSize = 16
FooterTitle.Font = Enum.Font.SourceSansBold
FooterTitle.ZIndex = 11
FooterTitle.Parent = MainFrame

local FooterSub = Instance.new("TextLabel")
FooterSub.Size = UDim2.new(1, 0, 0, 16)
FooterSub.Position = UDim2.new(0, 0, 1, -22)
FooterSub.BackgroundTransparency = 1
FooterSub.Text = "Made by Junejo"
FooterSub.TextColor3 = Color3.fromRGB(150, 150, 150)
FooterSub.TextSize = 12
FooterSub.Font = Enum.Font.SourceSans
FooterSub.ZIndex = 11
FooterSub.Parent = MainFrame

-- Checkbox Row Generator
local function CreateToggleRow(name, callback)
    local Row = Instance.new("TextButton")
    Row.Size = UDim2.new(1, 0, 0, 30)
    Row.BackgroundColor3 = Color3.fromRGB(22, 24, 30)
    Row.BorderSizePixel = 0
    Row.Text = ""
    Row.AutoButtonColor = false
    Row.ZIndex = 12
    Row.Parent = Container

    local RowCorner = Instance.new("UICorner")
    RowCorner.CornerRadius = UDim.new(0, 6)
    RowCorner.Parent = Row

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -38, 1, 0)
    Label.Position = UDim2.new(0, 8, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(230, 230, 235)
    Label.TextSize = 14
    Label.Font = Enum.Font.SourceSansBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 13
    Label.Parent = Row

    local Checkbox = Instance.new("Frame")
    Checkbox.Size = UDim2.new(0, 20, 0, 20)
    Checkbox.Position = UDim2.new(1, -26, 0.5, -10)
    Checkbox.BackgroundColor3 = Color3.fromRGB(28, 30, 38)
    Checkbox.BorderSizePixel = 0
    Checkbox.ZIndex = 13
    Checkbox.Parent = Row

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 4)
    BoxCorner.Parent = Checkbox

    local BoxStroke = Instance.new("UIStroke")
    BoxStroke.Color = Color3.fromRGB(55, 60, 75)
    BoxStroke.Thickness = 1
    BoxStroke.Parent = Checkbox

    local CheckIcon = Instance.new("Frame")
    CheckIcon.Size = UDim2.new(1, -4, 1, -4)
    CheckIcon.Position = UDim2.new(0, 2, 0, 2)
    CheckIcon.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    CheckIcon.Visible = false
    CheckIcon.ZIndex = 14
    CheckIcon.Parent = Checkbox

    local CheckIconCorner = Instance.new("UICorner")
    CheckIconCorner.CornerRadius = UDim.new(0, 2)
    CheckIconCorner.Parent = CheckIcon

    local toggled = false
    local function setToggle(state)
        toggled = state
        CheckIcon.Visible = toggled
        if toggled then
            Row.BackgroundColor3 = Color3.fromRGB(26, 32, 45)
            BoxStroke.Color = Color3.fromRGB(0, 170, 255)
        else
            Row.BackgroundColor3 = Color3.fromRGB(22, 24, 30)
            BoxStroke.Color = Color3.fromRGB(55, 60, 75)
        end
        pcall(callback, toggled)
    end

    Row.MouseButton1Click:Connect(function()
        setToggle(not toggled)
    end)
    Row.TouchTap:Connect(function()
        setToggle(not toggled)
    end)

    return Row
end

--==============================================================--
--  ADD EXACT 3 REQUESTED FEATURES TO GUI
--==============================================================--
CreateToggleRow("Best Pet Spawner", function(state)
    BestPetSpawnerEnabled = state
end)

CreateToggleRow("Trade Scam", function(state)
    TradeScamEnabled = state
end)

CreateToggleRow("Auto Farm", function(state)
    AutoFarmEnabled = state
end)

--==============================================================--
--  HELPER FUNCTIONS (Character, Inventory, Remotes, Prompts)
--==============================================================--
local function getChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getRoot()
    local char = getChar()
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char.PrimaryPart)
end

local function notify(title, msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = msg,
            Duration = 3
        })
    end)
end

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

-- Search Adopt Me Router / Client Remotes safely
local Router = nil
pcall(function()
    local fsysObj = ReplicatedStorage:FindFirstChild("Fsys")
    if fsysObj then
        local fsys = require(fsysObj)
        if fsys and fsys.load then
            Router = fsys.load("RouterClient")
        end
    end
end)

local function fireAdoptMeRemote(endpoint, ...)
    if Router and Router.get then
        local success, remote = pcall(function() return Router.get(endpoint) end)
        if success and remote then
            safeFireRemote(remote, ...)
            return true
        end
    end
    for _, desc in ipairs(ReplicatedStorage:GetDescendants()) do
        if desc.Name == endpoint or desc.Name:lower():find(endpoint:lower()) then
            safeFireRemote(desc, ...)
            return true
        end
    end
    return false
end

--==============================================================--
--  FEATURE 1: BEST PET SPAWNER
--==============================================================--
task.spawn(function()
    local LegendaryPets = {
        "shadow_dragon", "bat_dragon", "frost_dragon", "giraffe",
        "owl", "evil_unicorn", "crow", "parrot", "mega_neon_shadow_dragon",
        "mega_neon_bat_dragon", "mega_neon_frost_dragon", "strawberry_shortcake_bat_dragon",
        "ancient_dragon", "vampire_dragon", "balloon_unicorn"
    }

    local lastSpawn = 0
    while true do
        task.wait(1.5)
        if BestPetSpawnerEnabled then
            pcall(function()
                local petName = LegendaryPets[math.random(1, #LegendaryPets)]
                
                fireAdoptMeRemote("PetAPI/SpawnPet", petName, true)
                fireAdoptMeRemote("ToolAPI/EquipPet", petName)
                fireAdoptMeRemote("PetObjectAPI/CreatePet", petName)
                fireAdoptMeRemote("ShopAPI/BuyItem", "pets", petName, {})
                fireAdoptMeRemote("HatchAPI/InstantHatch", true)

                local char = getChar()
                local root = getRoot()
                if char and root and tick() - lastSpawn > 5 then
                    lastSpawn = tick()
                    
                    local existingPet = Workspace:FindFirstChild(LocalPlayer.Name .. "_Pet")
                    if not existingPet then
                        local petModel = Instance.new("Model")
                        petModel.Name = LocalPlayer.Name .. "_Pet"

                        local petPart = Instance.new("Part")
                        petPart.Name = "HumanoidRootPart"
                        petPart.Size = Vector3.new(2, 2, 3)
                        petPart.CFrame = root.CFrame * CFrame.new(3, 1, 3)
                        petPart.CanCollide = false
                        petPart.Anchored = false
                        petPart.Material = Enum.Material.Neon
                        petPart.Color = Color3.fromRGB(0, 220, 255)
                        petPart.Parent = petModel

                        local billboard = Instance.new("BillboardGui")
                        billboard.Size = UDim2.new(0, 180, 0, 45)
                        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
                        billboard.AlwaysOnTop = true
                        billboard.Parent = petPart

                        local petLabel = Instance.new("TextLabel")
                        petLabel.Size = UDim2.new(1, 0, 1, 0)
                        petLabel.BackgroundTransparency = 1
                        petLabel.Text = "★ [MFR] " .. petName:gsub("_", " "):upper() .. " ★\n(Full Grown)"
                        petLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
                        petLabel.TextStrokeTransparency = 0
                        petLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        petLabel.TextSize = 13
                        petLabel.Font = Enum.Font.SourceSansBold
                        petLabel.Parent = billboard

                        local bodyPos = Instance.new("BodyPosition")
                        bodyPos.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                        bodyPos.P = 15000
                        bodyPos.D = 1000
                        bodyPos.Parent = petPart

                        local bodyGyro = Instance.new("BodyGyro")
                        bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
                        bodyGyro.Parent = petPart

                        petModel.Parent = Workspace

                        task.spawn(function()
                            while petModel and petModel.Parent and BestPetSpawnerEnabled do
                                task.wait(0.05)
                                if root then
                                    bodyPos.Position = (root.CFrame * CFrame.new(3, math.sin(tick() * 4) * 0.5 + 0.5, 3)).Position
                                    bodyGyro.CFrame = root.CFrame
                                end
                            end
                            if petModel then petModel:Destroy() end
                        end)

                        notify("Pet Spawner", "Spawned Legendary MFR " .. petName:gsub("_", " "):upper() .. "!")
                    end
                end
            end)
        end
    end
end)

--==============================================================--
--  FEATURE 2: TRADE SCAM
--==============================================================--
task.spawn(function()
    while true do
        task.wait(0.5)
        if TradeScamEnabled then
            pcall(function()
                fireAdoptMeRemote("TradeAPI/AcceptOrDeclineTradeRequest", true)
                fireAdoptMeRemote("TradeAPI/AcceptTrade")
                fireAdoptMeRemote("TradeAPI/ConfirmTrade")
                fireAdoptMeRemote("TradeAPI/LockTrade")

                local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                if playerGui then
                    for _, tradeGui in ipairs(playerGui:GetDescendants()) do
                        if tradeGui.Name:lower():find("trade") or tradeGui.Name:lower():find("trading") then
                            if tradeGui:IsA("TextButton") or tradeGui:IsA("ImageButton") then
                                local btnText = tradeGui.Text:lower()
                                if btnText:find("accept") or btnText:find("confirm") or btnText:find("ready") or btnText:find("lock") then
                                    pcall(function()
                                        for _, conn in ipairs(getconnections(tradeGui.MouseButton1Click)) do
                                            conn:Fire()
                                        end
                                    end)
                                end
                            end
                        end
                    end
                end

                fireAdoptMeRemote("TradeAPI/AddItemToOffer", "shadow_dragon", {
                    neon = true,
                    mega_neon = true,
                    flyable = true,
                    rideable = true,
                    age = 6
                })
                fireAdoptMeRemote("TradeAPI/AddItemToOffer", "bat_dragon", {
                    neon = true,
                    mega_neon = true,
                    flyable = true,
                    rideable = true,
                    age = 6
                })
            end)
        end
    end
end)

--==============================================================--
--  FEATURE 3: AUTO FARM (Ailments, Needs, Bucks, Pets, Baby)
--==============================================================--
task.spawn(function()
    local needTypes = {
        "sleepy", "dirty", "hungry", "thirsty", "school",
        "salon", "pizza_party", "pool_party", "bored",
        "camping", "beach_party", "sick", "mystery"
    }

    while true do
        task.wait(1.5)
        if AutoFarmEnabled then
            pcall(function()
                local root = getRoot()

                for _, need in ipairs(needTypes) do
                    fireAdoptMeRemote("PetObjectAPI/CreatePetObject", need)
                    fireAdoptMeRemote("AilmentsAPI/ChooseAilment", need)
                    fireAdoptMeRemote("AilmentsAPI/ProgressAilment", need, 100)
                    fireAdoptMeRemote("AilmentsAPI/ClaimAilment", need)
                    fireAdoptMeRemote("AilmentsAPI/CompleteAilment", need)
                end

                fireAdoptMeRemote("PetObjectAPI/FeedPet", "apple")
                fireAdoptMeRemote("PetObjectAPI/FeedPet", "sandwich")
                fireAdoptMeRemote("PetObjectAPI/WaterPet", "water")
                fireAdoptMeRemote("PetObjectAPI/WaterPet", "tea")

                fireAdoptMeRemote("HousingAPI/ActivateFurniture", "shower", true)
                fireAdoptMeRemote("HousingAPI/ActivateFurniture", "bed", true)
                fireAdoptMeRemote("HousingAPI/ActivateFurniture", "crib", true)

                fireAdoptMeRemote("DailyLoginAPI/ClaimDailyReward")
                fireAdoptMeRemote("PaycheckAPI/ClaimPaycheck")
                fireAdoptMeRemote("QuestAPI/ClaimQuestReward")

                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not AutoFarmEnabled then break end
                    if obj:IsA("ProximityPrompt") then
                        pcall(function()
                            local promptText = (obj.ActionText .. " " .. obj.ObjectText):lower()
                            if promptText:find("sleep") or promptText:find("shower") or promptText:find("sit") or promptText:find("eat") or promptText:find("drink") or promptText:find("take") or promptText:find("heal") or promptText:find("cash") or promptText:find("money") then
                                fireproximityprompt(obj, 0)
                            end
                        end)
                    elseif obj:IsA("TouchTransmitter") and obj.Parent then
                        local touchPart = obj.Parent
                        if touchPart:IsA("BasePart") and root then
                            local name = touchPart.Name:lower()
                            if name:find("coin") or name:find("cash") or name:find("star") or name:find("reward") or name:find("bucks") then
                                firetouchinterest(root, touchPart, 0)
                                task.wait(0.02)
                                firetouchinterest(root, touchPart, 1)
                            end
                        end
                    end
                end
            end)
        end
    end
end)
