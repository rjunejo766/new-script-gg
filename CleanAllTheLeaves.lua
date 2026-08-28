--==============================================================--
--  ULTRA SCRIPT HUB - Made by Junejo
--  Game: Clean all the leaves
--  GitHub: https://github.com/rjunejo766/new-script-gg
--  Raw: https://raw.githubusercontent.com/rjunejo766/new-script-gg/main/CleanAllTheLeaves.lua
--  Features: Auto Collect Leaves, Auto Rebirth, Fly, WalkSpeed
--==============================================================--

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

-- 100% Safe LocalPlayer Resolution
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    repeat
        task.wait(0.05)
        LocalPlayer = Players.LocalPlayer
    until LocalPlayer
end

local Camera = Workspace.CurrentCamera

-- Feature Toggle States (Exact 4 Requested Features)
local AutoCollectLeavesEnabled = false
local AutoRebirthEnabled = false
local FlyEnabled = false
local WalkSpeedEnabled = false

local NormalSpeed = 16
local BoostSpeed = 50
local FlySpeed = 60

--==============================================================--
--  GUI CREATION (Guaranteed Instant Screen Display)
--==============================================================--

-- Clean old instances
pcall(function()
    local pgui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if pgui and pgui:FindFirstChild("UltraScriptHub_CleanAllTheLeaves") then
        pgui:FindFirstChild("UltraScriptHub_CleanAllTheLeaves"):Destroy()
    end
end)
pcall(function()
    if CoreGui and CoreGui:FindFirstChild("UltraScriptHub_CleanAllTheLeaves") then
        CoreGui:FindFirstChild("UltraScriptHub_CleanAllTheLeaves"):Destroy()
    end
end)
pcall(function()
    if gethui and gethui():FindFirstChild("UltraScriptHub_CleanAllTheLeaves") then
        gethui():FindFirstChild("UltraScriptHub_CleanAllTheLeaves"):Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraScriptHub_CleanAllTheLeaves"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999
ScreenGui.Enabled = true

-- Main Outer Frame (Exact Screenshot Styling)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 310, 0, 255)
MainFrame.Position = UDim2.new(0.5, -155, 0.35, -127)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.ZIndex = 10
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(45, 48, 60)
UIStroke.Thickness = 1.2
UIStroke.Parent = MainFrame

-- Floating Open/Close Button (⚡) for Mobile & Quick Access
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "FloatingToggle"
ToggleBtn.Size = UDim2.new(0, 38, 0, 38)
ToggleBtn.Position = UDim2.new(0, 15, 0.5, -19)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
ToggleBtn.BorderColor3 = Color3.fromRGB(0, 170, 255)
ToggleBtn.BorderSizePixel = 1
ToggleBtn.Text = "⚡"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
ToggleBtn.TextSize = 18
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.ZIndex = 20
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Header Title
local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -50, 0, 35)
HeaderTitle.Position = UDim2.new(0, 16, 0, 8)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "CLEAN ALL THE LEAVES"
HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitle.TextSize = 14
HeaderTitle.Font = Enum.Font.SourceSansBold
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.ZIndex = 11
HeaderTitle.Parent = MainFrame

-- Close Button (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -34, 0, 8)
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

-- Content Container
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -32, 0, 140)
Container.Position = UDim2.new(0, 16, 0, 45)
Container.BackgroundTransparency = 1
Container.ZIndex = 11
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 7)
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

-- Checkbox Row Generator (Exact Screenshot Match)
local function CreateToggleRow(name, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 26)
    Row.BackgroundTransparency = 1
    Row.ZIndex = 12
    Row.Parent = Container

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -35, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 220, 225)
    Label.TextSize = 13
    Label.Font = Enum.Font.SourceSansBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 13
    Label.Parent = Row

    local Checkbox = Instance.new("TextButton")
    Checkbox.Size = UDim2.new(0, 20, 0, 20)
    Checkbox.Position = UDim2.new(1, -22, 0.5, -10)
    Checkbox.BackgroundColor3 = Color3.fromRGB(25, 27, 35)
    Checkbox.BorderColor3 = Color3.fromRGB(45, 48, 60)
    Checkbox.Text = ""
    Checkbox.AutoButtonColor = false
    Checkbox.ZIndex = 13
    Checkbox.Parent = Row

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 4)
    BoxCorner.Parent = Checkbox

    local CheckIcon = Instance.new("Frame")
    CheckIcon.Size = UDim2.new(1, -6, 1, -6)
    CheckIcon.Position = UDim2.new(0, 3, 0, 3)
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

----------------------------------------------------------------
-- ADD EXACT 4 REQUESTED FEATURES TO GUI
----------------------------------------------------------------
CreateToggleRow("Auto Collect Leaves", function(state)
    AutoCollectLeavesEnabled = state
end)

CreateToggleRow("Auto Rebirth", function(state)
    AutoRebirthEnabled = state
end)

CreateToggleRow("Fly 🕊 Mode", function(state)
    FlyEnabled = state
end)

CreateToggleRow("WalkSpeed Boost (50)", function(state)
    WalkSpeedEnabled = state
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = state and BoostSpeed or NormalSpeed
        end
    end)
end)

-- Safe Universal Parenting
local parented = false
pcall(function()
    if gethui then
        ScreenGui.Parent = gethui()
        parented = true
    end
end)
if not parented or not ScreenGui.Parent then
    pcall(function()
        local pgui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
        ScreenGui.Parent = pgui
        parented = true
    end)
end
if not parented or not ScreenGui.Parent then
    pcall(function()
        ScreenGui.Parent = CoreGui
    end)
end

-- Success Notification
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Ultra Script Hub",
        Text = "Clean All The Leaves Loaded!",
        Duration = 3
    })
end)

--==============================================================--
--  HELPER FUNCTIONS & FEATURE ENGINES
--==============================================================--

local function getRoot()
    local char = LocalPlayer.Character
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char.PrimaryPart)
end

local function getHum()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function equipTool()
    pcall(function()
        local char = LocalPlayer.Character
        local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        if not char or not backpack then return end
        if not char:FindFirstChildOfClass("Tool") then
            local tool = backpack:FindFirstChildOfClass("Tool")
            if tool and getHum() then
                getHum():EquipTool(tool)
            end
        end
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

-- Dynamic Remote Finding
local function findRemotes(keywords)
    local results = {}
    pcall(function()
        local function scan(parent)
            if not parent then return end
            for _, obj in ipairs(parent:GetDescendants()) do
                if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                    local n = obj.Name:lower()
                    for _, kw in ipairs(keywords) do
                        if n:find(kw:lower()) then
                            table.insert(results, obj)
                            break
                        end
                    end
                end
            end
        end
        scan(ReplicatedStorage)
        scan(Workspace)
    end)
    return results
end

local CleanRemotes = {}
local RebirthRemotes = {}

local function refreshRemotes()
    CleanRemotes = findRemotes({"clean", "rake", "sweep", "blow", "vacuum", "destroy", "cut", "leaf", "leaves", "farm", "pickup", "collect"})
    RebirthRemotes = findRemotes({"rebirth", "prestige", "rankup", "ascend", "reset"})
end
pcall(refreshRemotes)

-- Respawn & WalkSpeed Persistence
LocalPlayer.CharacterAdded:Connect(function(char)
    pcall(function()
        local hum = char:WaitForChild("Humanoid", 5)
        if hum and WalkSpeedEnabled then
            hum.WalkSpeed = BoostSpeed
        end
    end)
end)

-- Anti-AFK Setup
task.spawn(function()
    pcall(function()
        local VirtualUser = game:GetService("VirtualUser")
        LocalPlayer.Idled:Connect(function()
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end)
    end)
end)

----------------------------------------------------------------
-- 1. FEATURE: AUTO COLLECT LEAVES (Cleans, Sweeps & Teleport Collects)
----------------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0.12)
        if AutoCollectLeavesEnabled then
            pcall(function()
                equipTool()
                local root = getRoot()
                local char = LocalPlayer.Character

                -- Activate tool
                if char then
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                        for _, child in ipairs(tool:GetDescendants()) do
                            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                                safeFireRemote(child, root and root.Position or Vector3.new())
                            end
                        end
                    end
                end

                -- Fire clean remotes
                for _, rem in ipairs(CleanRemotes) do
                    safeFireRemote(rem, "Clean", true)
                    safeFireRemote(rem, "Collect", true)
                    safeFireRemote(rem, root and root.Position or Vector3.new())
                end

                -- Collect all leaf parts / piles / drops
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not AutoCollectLeavesEnabled then break end
                    local n = obj.Name:lower()
                    if n:find("leaf") or n:find("leaves") or n:find("pile") or n:find("trash") or n:find("dirt") or n:find("coin") then
                        if obj:IsA("BasePart") and root then
                            if (obj.Position - root.Position).Magnitude < 50 then
                                if firetouchinterest then
                                    firetouchinterest(root, obj, 0)
                                    task.wait(0.01)
                                    firetouchinterest(root, obj, 1)
                                end
                            end
                        elseif obj:IsA("Model") then
                            local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                            if part and root and (part.Position - root.Position).Magnitude < 50 then
                                if firetouchinterest then
                                    firetouchinterest(root, part, 0)
                                    task.wait(0.01)
                                    firetouchinterest(root, part, 1)
                                end
                            end
                        elseif obj:IsA("ProximityPrompt") then
                            obj.HoldDuration = 0
                            if fireproximityprompt then
                                fireproximityprompt(obj, 0)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

----------------------------------------------------------------
-- 2. FEATURE: AUTO REBIRTH
----------------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(1.5)
        if AutoRebirthEnabled then
            pcall(function()
                -- 1. Fire rebirth remotes
                for _, rem in ipairs(RebirthRemotes) do
                    safeFireRemote(rem, "Rebirth")
                    safeFireRemote(rem, 1)
                    safeFireRemote(rem, true)
                end

                -- 2. Click GUI Rebirth Buttons
                local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                if pGui then
                    for _, btn in ipairs(pGui:GetDescendants()) do
                        if btn:IsA("TextButton") or btn:IsA("ImageButton") then
                            local txt = btn.Name:lower() .. " " .. (btn:IsA("TextButton") and btn.Text:lower() or "")
                            if txt:find("rebirth") or txt:find("prestige") or txt:find("ascend") then
                                pcall(function()
                                    if getconnections then
                                        for _, conn in ipairs(getconnections(btn.MouseButton1Click)) do
                                            conn:Fire()
                                        end
                                    end
                                end)
                            end
                        end
                    end
                end

                -- 3. Touch Rebirth Pads in Workspace
                local root = getRoot()
                for _, pad in ipairs(Workspace:GetDescendants()) do
                    if not AutoRebirthEnabled then break end
                    local n = pad.Name:lower()
                    if n:find("rebirth") or n:find("prestige") then
                        if pad:IsA("BasePart") and root then
                            if firetouchinterest then
                                firetouchinterest(root, pad, 0)
                                task.wait(0.02)
                                firetouchinterest(root, pad, 1)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

----------------------------------------------------------------
-- 3. FEATURE: FLY MODE (WASD + Space/Shift Smooth Fly)
----------------------------------------------------------------
local flyBodyVel, flyBodyGyro

task.spawn(function()
    while true do
        task.wait(0.1)
        if FlyEnabled then
            local char = LocalPlayer.Character
            local root = getRoot()
            local hum = getHum()

            if root and hum and not flyBodyVel then
                flyBodyVel = Instance.new("BodyVelocity")
                flyBodyVel.Name = "UltraFlyVel"
                flyBodyVel.Velocity = Vector3.new(0, 0, 0)
                flyBodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                flyBodyVel.Parent = root

                flyBodyGyro = Instance.new("BodyGyro")
                flyBodyGyro.Name = "UltraFlyGyro"
                flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                flyBodyGyro.CFrame = root.CFrame
                flyBodyGyro.Parent = root

                hum.PlatformStand = true
            end

            while FlyEnabled and root and flyBodyVel and flyBodyGyro do
                local moveDir = Vector3.new(0, 0, 0)

                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDir = moveDir + Camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDir = moveDir - Camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDir = moveDir - Camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDir = moveDir + Camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveDir = moveDir + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    moveDir = moveDir - Vector3.new(0, 1, 0)
                end

                if moveDir.Magnitude > 0 then
                    flyBodyVel.Velocity = moveDir.Unit * FlySpeed
                else
                    flyBodyVel.Velocity = Vector3.new(0, 0, 0)
                end

                flyBodyGyro.CFrame = Camera.CFrame
                RunService.RenderStepped:Wait()
            end
        else
            if flyBodyVel then flyBodyVel:Destroy(); flyBodyVel = nil end
            if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end
            local hum = getHum()
            if hum then hum.PlatformStand = false end
        end
    end
end)
