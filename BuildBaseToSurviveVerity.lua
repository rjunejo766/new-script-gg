--==============================================================--
--  ULTRA SCRIPT HUB - Made by Junejo
--  Game: Build Base to Survive VERITY
--  Version: 1.0 (Inf Ammo, Shoot Aura, WalkSpeed & HipHeight)
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
local InfAmmoEnabled = false
local ShootAuraEnabled = false
local WalkSpeedEnabled = false
local HipHeightEnabled = false

-- Values
local NormalSpeed = 16
local BoostSpeed = 50
local NormalHipHeight = 2
local BoostHipHeight = 7

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

-- Equip Best Gun / Weapon
local function equipGun()
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

-- Find Nearest Enemy / Monster / Zombie (Deep workspace scan)
local function getNearestEnemy(maxDistance)
    local root = getRoot()
    if not root then return nil, math.huge end
    
    local closestEnemy = nil
    local shortestDist = maxDistance or 250

    local function checkModel(model)
        if not model or not model:IsA("Model") then return end
        if model == LocalPlayer.Character then return end
        
        -- Check if it's a real player
        if Players:GetPlayerFromCharacter(model) then return end

        local hum = model:FindFirstChildOfClass("Humanoid")
        local enemyRoot = model:FindFirstChild("Head") or model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model:FindFirstChildWhichIsA("BasePart")
        
        if enemyRoot and ((hum and hum.Health > 0) or not hum) then
            local n = model.Name:lower()
            local p = model.Parent and model.Parent.Name:lower() or ""
            -- Make sure it's not base building blocks or player structures
            if not n:find("base") and not n:find("block") and not n:find("wall") and not n:find("door") and not n:find("plot") then
                local dist = (enemyRoot.Position - root.Position).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    closestEnemy = enemyRoot
                end
            end
        end
    end

    -- Deep scan all Workspace descendants
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") then
            checkModel(obj)
        end
    end

    return closestEnemy, shortestDist
end

-- Respawn Handler for WalkSpeed & HipHeight
LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        if WalkSpeedEnabled then
            hum.WalkSpeed = BoostSpeed
        end
        if HipHeightEnabled then
            hum.HipHeight = BoostHipHeight
        end
    end
end)

--==============================================================--
--  GUI CREATION (Pixel-Perfect ULTRA SCRIPT HUB Design)
--==============================================================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraScriptHub_BuildBaseVerity"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999

-- Clean previous instances
pcall(function()
    if CoreGui and CoreGui:FindFirstChild("UltraScriptHub_BuildBaseVerity") then
        CoreGui:FindFirstChild("UltraScriptHub_BuildBaseVerity"):Destroy()
    end
    local lpGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if lpGui and lpGui:FindFirstChild("UltraScriptHub_BuildBaseVerity") then
        lpGui:FindFirstChild("UltraScriptHub_BuildBaseVerity"):Destroy()
    end
end)

local parentGui = nil
if gethui then 
    pcall(function() parentGui = gethui() end) 
end
if not parentGui then 
    pcall(function()
        parentGui = CoreGui
    end) 
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
MainFrame.Size = UDim2.new(0, 320, 0, 275)
MainFrame.Position = UDim2.new(0.5, -160, 0.35, -137)
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
HeaderTitle.Text = "BUILD BASE TO SURVIVE VERITY"
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
--  ADD 4 REQUESTED FEATURES TO GUI
--==============================================================--
CreateToggleRow("Inf Ammo", function(state)
    InfAmmoEnabled = state
end)

CreateToggleRow("Shoot Aura", function(state)
    ShootAuraEnabled = state
end)

CreateToggleRow("WalkSpeed (50)", function(state)
    WalkSpeedEnabled = state
    local hum = getHum()
    if hum then
        hum.WalkSpeed = state and BoostSpeed or NormalSpeed
    end
end)

CreateToggleRow("Hip Height Boost", function(state)
    HipHeightEnabled = state
    local hum = getHum()
    if hum then
        hum.HipHeight = state and BoostHipHeight or NormalHipHeight
    end
end)

-- Keep WalkSpeed active
RunService.Stepped:Connect(function()
    local hum = getHum()
    if hum then
        if WalkSpeedEnabled and hum.WalkSpeed ~= BoostSpeed then
            hum.WalkSpeed = BoostSpeed
        end
        if HipHeightEnabled and hum.HipHeight ~= BoostHipHeight then
            hum.HipHeight = BoostHipHeight
        end
    end
end)

--==============================================================--
--  1. SUPERCHARGED INF AMMO LOOP (Locks Ammo, Mag & Module Settings)
--==============================================================--
task.spawn(function()
    while true do
        if InfAmmoEnabled then
            pcall(function()
                local char = LocalPlayer.Character
                local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
                local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                
                local function refillTool(tool)
                    if not tool or not tool:IsA("Tool") then return end
                    
                    -- 1. Check all Value objects in tool
                    for _, child in ipairs(tool:GetDescendants()) do
                        if child:IsA("IntValue") or child:IsA("NumberValue") then
                            local n = child.Name:lower()
                            if n:find("ammo") or n:find("clip") or n:find("bullet") or n:find("mag") or n:find("count") or n:find("stored") or n:find("reserve") then
                                child.Value = 999999
                            end
                        elseif child:IsA("ModuleScript") then
                            -- Attempt to modify GunSetting module tables
                            local n = child.Name:lower()
                            if n:find("setting") or n:find("config") or n:find("gun") then
                                pcall(function()
                                    local mod = require(child)
                                    if type(mod) == "table" then
                                        if mod.Ammo then mod.Ammo = 999999 end
                                        if mod.MaxAmmo then mod.MaxAmmo = 999999 end
                                        if mod.ClipSize then mod.ClipSize = 999999 end
                                        if mod.StoredAmmo then mod.StoredAmmo = 999999 end
                                        if mod.Auto ~= nil then mod.Auto = true end
                                    end
                                end)
                            end
                        end
                    end
                    
                    -- 2. Set Attributes on tool
                    pcall(function()
                        for attrName, _ in pairs(tool:GetAttributes()) do
                            local n = attrName:lower()
                            if n:find("ammo") or n:find("clip") or n:find("bullet") or n:find("mag") or n:find("count") then
                                tool:SetAttribute(attrName, 999999)
                            end
                        end
                    end)
                end

                if char then
                    for _, item in ipairs(char:GetChildren()) do
                        if item:IsA("Tool") then refillTool(item) end
                    end
                end
                if backpack then
                    for _, item in ipairs(backpack:GetChildren()) do
                        if item:IsA("Tool") then refillTool(item) end
                    end
                end
                if pGui then
                    for _, child in ipairs(pGui:GetDescendants()) do
                        if child:IsA("IntValue") or child:IsA("NumberValue") then
                            local n = child.Name:lower()
                            if n:find("ammo") or n:find("clip") or n:find("bullet") or n:find("mag") then
                                child.Value = 999999
                            end
                        end
                    end
                end

                -- 3. Fire reload / refill remotes
                local reloadRemotes = findRemotes({"reload", "refill", "takeammo", "giveammo", "addammo"})
                for _, remote in ipairs(reloadRemotes) do
                    pcall(function()
                        if remote:IsA("RemoteEvent") then
                            remote:FireServer()
                            remote:FireServer(999999)
                        end
                    end)
                end
            end)
            task.wait(0.15)
        else
            task.wait(0.5)
        end
    end
end)

--==============================================================--
--  2. RAPID CONTINUOUS AUTO-SHOOT & SHOOT AURA
--==============================================================--
task.spawn(function()
    while true do
        if ShootAuraEnabled then
            pcall(function()
                -- 1. Auto equip gun / weapon immediately
                local tool = equipGun()
                
                -- 2. Search for any enemy/monster in range
                local enemyPart, dist = getNearestEnemy(600)
                
                if enemyPart and enemyPart.Parent then
                    -- Aim camera at enemy
                    pcall(function()
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, enemyPart.Position)
                    end)

                    -- Fire weapon at enemy
                    if tool then
                        tool:Activate()
                    end

                    -- Fire shoot/hit remotes with enemy target
                    local shootRemotes = findRemotes({"shoot", "fire", "attack", "hit", "damage", "gun", "bullet", "raycast", "weapon"})
                    for _, remote in ipairs(shootRemotes) do
                        pcall(function()
                            if remote:IsA("RemoteEvent") then
                                remote:FireServer(enemyPart, enemyPart.Position)
                                remote:FireServer(enemyPart.Position, enemyPart)
                                remote:FireServer(enemyPart.Position)
                                remote:FireServer(enemyPart)
                            elseif remote:IsA("RemoteFunction") then
                                remote:InvokeServer(enemyPart, enemyPart.Position)
                            end
                        end)
                    end
                else
                    -- No enemy nearby: Still auto-shoot continuously straight ahead
                    if tool then
                        tool:Activate()
                    end

                    local shootRemotes = findRemotes({"shoot", "fire", "attack", "hit", "damage", "gun", "bullet", "raycast", "weapon"})
                    for _, remote in ipairs(shootRemotes) do
                        pcall(function()
                            if remote:IsA("RemoteEvent") then
                                remote:FireServer(Camera.CFrame.LookVector * 100)
                                remote:FireServer()
                            end
                        end)
                    end
                end

                -- 3. Rapid click simulation
                if VirtualUser then
                    VirtualUser:Button1Down(Vector2.new(0, 0), Camera.CFrame)
                end
                if mouse1click then
                    pcall(mouse1click)
                end
            end)
            task.wait(0.02)
        else
            task.wait(0.4)
        end
    end
end)

print("[ULTRA SCRIPT HUB] Build Base to Survive VERITY Loaded Successfully!")

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ULTRA SCRIPT HUB",
        Text = "Build Base to Survive Loaded!",
        Duration = 5
    })
end)
