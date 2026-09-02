--==============================================================--
--  ULTRA SCRIPT HUB - Made by Junejo
--  Game: Dig and Clean
--  Game Link: https://www.roblox.com/games/83038462357724/Dig-Clean
--  GitHub: https://github.com/rjunejo766/new-script-gg
--  Raw: https://raw.githubusercontent.com/rjunejo766/new-script-gg/main/DigAndClean.lua
--  Features: Auto Dig, Auto Clean, Auto Sell, Teleports, Speed, Inf Jump
--==============================================================--

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- 100% Safe LocalPlayer Resolution
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    repeat
        task.wait(0.05)
        LocalPlayer = Players.LocalPlayer
    until LocalPlayer
end

local Camera = Workspace.CurrentCamera

local VirtualUser = nil
pcall(function() VirtualUser = game:GetService("VirtualUser") end)

local VirtualInputManager = nil
pcall(function() VirtualInputManager = game:GetService("VirtualInputManager") end)

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

-- Feature Toggle States
local AutoDigEnabled = false
local AutoCleanEnabled = false
local AutoSellEnabled = false
local WalkSpeedEnabled = false
local InfJumpEnabled = false

local NormalSpeed = 16
local BoostSpeed = 45

--==============================================================--
--  GUI CREATION (Guaranteed Instant Parent & Display)
--==============================================================--
local GuiName = "UltraScriptHub_DigAndClean"

-- Clean old instances
pcall(function()
    local pgui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if pgui and pgui:FindFirstChild(GuiName) then
        pgui:FindFirstChild(GuiName):Destroy()
    end
end)
pcall(function()
    if CoreGui and CoreGui:FindFirstChild(GuiName) then
        CoreGui:FindFirstChild(GuiName):Destroy()
    end
end)
pcall(function()
    if gethui and gethui():FindFirstChild(GuiName) then
        gethui():FindFirstChild(GuiName):Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = GuiName
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999

-- Safe GUI Parent Selection
local guiParent = nil
pcall(function()
    if gethui then guiParent = gethui() end
end)
if not guiParent then
    pcall(function()
        if CoreGui and pcall(function() local _ = CoreGui.Name end) then
            guiParent = CoreGui
        end
    end)
end
if not guiParent then
    pcall(function()
        guiParent = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
    end)
end

pcall(function() ScreenGui.Parent = guiParent end)
if not ScreenGui.Parent then
    pcall(function() ScreenGui.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui") end)
end

-- Floating Open/Close Button (⚡) for Mobile & Quick Access
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "FloatingToggle"
ToggleBtn.Size = UDim2.new(0, 42, 0, 42)
ToggleBtn.Position = UDim2.new(0, 15, 0.5, -21)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
ToggleBtn.BorderColor3 = Color3.fromRGB(0, 170, 255)
ToggleBtn.BorderSizePixel = 1
ToggleBtn.Text = "⚡"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
ToggleBtn.TextSize = 20
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.ZIndex = 30
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 9)
ToggleCorner.Parent = ToggleBtn

-- Main Outer Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 330, 0, 380)
MainFrame.Position = UDim2.new(0.5, -165, 0.3, -190)
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

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Header Title
local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -50, 0, 35)
HeaderTitle.Position = UDim2.new(0, 16, 0, 8)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "DIG AND CLEAN"
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

-- Tab Switcher Bar
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -32, 0, 30)
TabBar.Position = UDim2.new(0, 16, 0, 42)
TabBar.BackgroundColor3 = Color3.fromRGB(22, 24, 30)
TabBar.BorderSizePixel = 0
TabBar.ZIndex = 11
TabBar.Parent = MainFrame

local TabBarCorner = Instance.new("UICorner")
TabBarCorner.CornerRadius = UDim.new(0, 6)
TabBarCorner.Parent = TabBar

local TabMainBtn = Instance.new("TextButton")
TabMainBtn.Size = UDim2.new(0.5, -2, 1, -4)
TabMainBtn.Position = UDim2.new(0, 2, 0, 2)
TabMainBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
TabMainBtn.Text = "⚡ Auto Farm"
TabMainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TabMainBtn.TextSize = 12
TabMainBtn.Font = Enum.Font.SourceSansBold
TabMainBtn.ZIndex = 12
TabMainBtn.Parent = TabBar

local TabMainCorner = Instance.new("UICorner")
TabMainCorner.CornerRadius = UDim.new(0, 4)
TabMainCorner.Parent = TabMainBtn

local TabTpBtn = Instance.new("TextButton")
TabTpBtn.Size = UDim2.new(0.5, -2, 1, -4)
TabTpBtn.Position = UDim2.new(0.5, 0, 0, 2)
TabTpBtn.BackgroundColor3 = Color3.fromRGB(28, 30, 38)
TabTpBtn.Text = "📍 Teleports"
TabTpBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
TabTpBtn.TextSize = 12
TabTpBtn.Font = Enum.Font.SourceSansBold
TabTpBtn.ZIndex = 12
TabTpBtn.Parent = TabBar

local TabTpCorner = Instance.new("UICorner")
TabTpCorner.CornerRadius = UDim.new(0, 4)
TabTpCorner.Parent = TabTpBtn

-- Scrolling Content Pages
local FarmContainer = Instance.new("ScrollingFrame")
FarmContainer.Size = UDim2.new(1, -32, 0, 240)
FarmContainer.Position = UDim2.new(0, 16, 0, 80)
FarmContainer.BackgroundTransparency = 1
FarmContainer.BorderSizePixel = 0
FarmContainer.ScrollBarThickness = 3
FarmContainer.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
FarmContainer.CanvasSize = UDim2.new(0, 0, 0, 260)
FarmContainer.ZIndex = 11
FarmContainer.Visible = true
FarmContainer.Parent = MainFrame

local FarmLayout = Instance.new("UIListLayout")
FarmLayout.SortOrder = Enum.SortOrder.LayoutOrder
FarmLayout.Padding = UDim.new(0, 7)
FarmLayout.Parent = FarmContainer

local TpContainer = Instance.new("ScrollingFrame")
TpContainer.Size = UDim2.new(1, -32, 0, 240)
TpContainer.Position = UDim2.new(0, 16, 0, 80)
TpContainer.BackgroundTransparency = 1
TpContainer.BorderSizePixel = 0
TpContainer.ScrollBarThickness = 3
TpContainer.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
TpContainer.CanvasSize = UDim2.new(0, 0, 0, 270)
TpContainer.ZIndex = 11
TpContainer.Visible = false
TpContainer.Parent = MainFrame

local TpLayout = Instance.new("UIListLayout")
TpLayout.SortOrder = Enum.SortOrder.LayoutOrder
TpLayout.Padding = UDim.new(0, 7)
TpLayout.Parent = TpContainer

-- Tab Switch Handler
TabMainBtn.MouseButton1Click:Connect(function()
    FarmContainer.Visible = true
    TpContainer.Visible = false
    TabMainBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    TabMainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabTpBtn.BackgroundColor3 = Color3.fromRGB(28, 30, 38)
    TabTpBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
end)

TabTpBtn.MouseButton1Click:Connect(function()
    FarmContainer.Visible = false
    TpContainer.Visible = true
    TabTpBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    TabTpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabMainBtn.BackgroundColor3 = Color3.fromRGB(28, 30, 38)
    TabMainBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
end)

-- Footer Titles
local FooterTitle = Instance.new("TextLabel")
FooterTitle.Size = UDim2.new(1, 0, 0, 20)
FooterTitle.Position = UDim2.new(0, 0, 1, -44)
FooterTitle.BackgroundTransparency = 1
FooterTitle.Text = "ULTRA SCRIPT HUB"
FooterTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
FooterTitle.TextSize = 15
FooterTitle.Font = Enum.Font.SourceSansBold
FooterTitle.ZIndex = 11
FooterTitle.Parent = MainFrame

local FooterSub = Instance.new("TextLabel")
FooterSub.Size = UDim2.new(1, 0, 0, 16)
FooterSub.Position = UDim2.new(0, 0, 1, -24)
FooterSub.BackgroundTransparency = 1
FooterSub.Text = "Made by Junejo"
FooterSub.TextColor3 = Color3.fromRGB(150, 150, 150)
FooterSub.TextSize = 12
FooterSub.Font = Enum.Font.SourceSans
FooterSub.ZIndex = 11
FooterSub.Parent = MainFrame

-- Checkbox Row Generator
local function CreateToggleRow(parent, name, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, -6, 0, 28)
    Row.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
    Row.BackgroundTransparency = 0.5
    Row.ZIndex = 12
    Row.Parent = parent

    local RowCorner = Instance.new("UICorner")
    RowCorner.CornerRadius = UDim.new(0, 6)
    RowCorner.Parent = Row

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -40, 1, 0)
    Label.Position = UDim2.new(0, 8, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(225, 225, 230)
    Label.TextSize = 13
    Label.Font = Enum.Font.SourceSansBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 13
    Label.Parent = Row

    local Checkbox = Instance.new("TextButton")
    Checkbox.Size = UDim2.new(0, 20, 0, 20)
    Checkbox.Position = UDim2.new(1, -26, 0.5, -10)
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
            Row.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
        else
            Checkbox.BackgroundColor3 = Color3.fromRGB(25, 27, 35)
            Checkbox.BorderColor3 = Color3.fromRGB(45, 48, 60)
            Row.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
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

-- Action Button Generator
local function CreateActionButton(parent, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -6, 0, 30)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 28, 38)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(0, 170, 255)
    Btn.TextSize = 13
    Btn.Font = Enum.Font.SourceSansBold
    Btn.ZIndex = 12
    Btn.Parent = parent

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Btn

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = Color3.fromRGB(45, 55, 75)
    BtnStroke.Thickness = 1
    BtnStroke.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)

    return Btn
end

--==============================================================--
--  ADD REQUESTED FEATURES TO GUI
--==============================================================--

-- Tab 1: Auto Farm
CreateToggleRow(FarmContainer, "⛏️ Auto Dig (Dig Dirt / Ground)", function(state)
    AutoDigEnabled = state
end)

CreateToggleRow(FarmContainer, "🧼 Auto Clean (Wash & Clean Objects)", function(state)
    AutoCleanEnabled = state
end)

CreateToggleRow(FarmContainer, "💰 Auto Sell (Auto Sell All)", function(state)
    AutoSellEnabled = state
end)

CreateToggleRow(FarmContainer, "🏃 WalkSpeed Boost (45)", function(state)
    WalkSpeedEnabled = state
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = state and BoostSpeed or NormalSpeed
    end
end)

CreateToggleRow(FarmContainer, "🦘 Infinite Jump", function(state)
    InfJumpEnabled = state
end)

-- Tab 2: Teleports
local function TeleportToCFrame(targetCFrame)
    local root = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso"))
    if root and targetCFrame then
        root.CFrame = targetCFrame + Vector3.new(0, 3, 0)
    end
end

CreateActionButton(TpContainer, "📍 Teleport to Dig Zone", function()
    -- Scan workspace for dig areas
    local target = nil
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:find("dig") or name:find("dirt") or name:find("mine") or name:find("ground") then
                target = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
                if target then break end
            end
        end
    end
    if target then
        TeleportToCFrame(target.CFrame)
    else
        -- Fallback default area
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            TeleportToCFrame(root.CFrame + Vector3.new(0, 0, 20))
        end
    end
end)

CreateActionButton(TpContainer, "🧼 Teleport to Clean Station", function()
    local target = nil
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:find("clean") or name:find("wash") or name:find("station") or name:find("water") or name:find("sink") then
                target = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
                if target then break end
            end
        end
    end
    if target then
        TeleportToCFrame(target.CFrame)
    end
end)

CreateActionButton(TpContainer, "💰 Teleport to Sell Zone", function()
    local target = nil
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:find("sell") or name:find("shop") or name:find("merchant") or name:find("bank") then
                target = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
                if target then break end
            end
        end
    end
    if target then
        TeleportToCFrame(target.CFrame)
    end
end)

CreateActionButton(TpContainer, "🏪 Teleport to Shop / Upgrades", function()
    local target = nil
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:find("upgrade") or name:find("shop") or name:find("store") or name:find("tools") then
                target = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
                if target then break end
            end
        end
    end
    if target then
        TeleportToCFrame(target.CFrame)
    end
end)

CreateActionButton(TpContainer, "🏠 Teleport to Spawn / Base", function()
    local spawns = Workspace:FindFirstChild("SpawnLocation") or Workspace:FindFirstChildWhichIsA("SpawnLocation", true)
    if spawns then
        TeleportToCFrame(spawns.CFrame)
    else
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            TeleportToCFrame(CFrame.new(0, 10, 0))
        end
    end
end)

--==============================================================--
--  HELPER FUNCTIONS (Character, Touch, Prompt, Tool Handling)
--==============================================================--
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

local function triggerPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return end
    pcall(function()
        prompt.HoldDuration = 0
        if fireproximityprompt then
            fireproximityprompt(prompt, 0)
        else
            prompt:InputHoldBegin()
            task.wait(0.05)
            prompt:InputHoldEnd()
        end
    end)
end

local function equipAndActivateTool(toolNameFilter)
    pcall(function()
        local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
        local char = LocalPlayer.Character
        local hum = getHum()
        if not hum or not char then return end

        local targetTool = nil
        if bp then
            for _, t in ipairs(bp:GetChildren()) do
                if t:IsA("Tool") then
                    if not toolNameFilter or t.Name:lower():find(toolNameFilter:lower()) then
                        targetTool = t
                        break
                    end
                end
            end
        end

        if targetTool then
            hum:EquipTool(targetTool)
            task.wait(0.05)
        end

        local equipped = char:FindFirstChildOfClass("Tool")
        if equipped then
            equipped:Activate()
        end
    end)
end

-- Infinite Jump Hook
UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled then
        local hum = getHum()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Character Added handler for WalkSpeed
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum and WalkSpeedEnabled then
        hum.WalkSpeed = BoostSpeed
    end
end)

--==============================================================--
--  DYNAMIC REMOTE & OBJECT SCANNERS
--==============================================================--
local CachedRemotes = {
    Dig = {},
    Clean = {},
    Sell = {}
}

local function ScanRemotes()
    local searchLocations = {ReplicatedStorage, Workspace}
    for _, loc in ipairs(searchLocations) do
        pcall(function()
            for _, obj in ipairs(loc:GetDescendants()) do
                if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                    local name = obj.Name:lower()
                    if name:find("dig") or name:find("mine") or name:find("shovel") or name:find("harvest") then
                        table.insert(CachedRemotes.Dig, obj)
                    elseif name:find("clean") or name:find("wash") or name:find("sponge") or name:find("scrub") or name:find("wipe") then
                        table.insert(CachedRemotes.Clean, obj)
                    elseif name:find("sell") or name:find("deposit") or name:find("trade") then
                        table.insert(CachedRemotes.Sell, obj)
                    end
                end
            end
        end)
    end
end

ScanRemotes()

--==============================================================--
--  BACKGROUND FARMING LOOPS
--==============================================================--

-- 1. AUTO DIG LOOP
task.spawn(function()
    while true do
        task.wait(0.1)
        if AutoDigEnabled then
            pcall(function()
                -- 1. Equip shovel / pickaxe / dig tool and activate
                equipAndActivateTool("dig")
                equipAndActivateTool("shovel")
                equipAndActivateTool()

                -- 2. Fire Cached Dig Remotes
                for _, rem in ipairs(CachedRemotes.Dig) do
                    pcall(function()
                        if rem:IsA("RemoteEvent") then
                            rem:FireServer()
                            rem:FireServer("Dig")
                            rem:FireServer(true)
                        elseif rem:IsA("RemoteFunction") then
                            rem:InvokeServer()
                        end
                    end)
                end

                -- 3. Trigger Nearby Dig ProximityPrompts & ClickDetectors
                local root = getRoot()
                if root then
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if not AutoDigEnabled then break end
                        local n = obj.Name:lower()
                        if n:find("dig") or n:find("dirt") or n:find("ore") or n:find("ground") or n:find("node") or n:find("pile") then
                            if obj:IsA("ProximityPrompt") then
                                triggerPrompt(obj)
                            elseif obj:IsA("ClickDetector") and fireclickdetector then
                                fireclickdetector(obj)
                            elseif obj:IsA("BasePart") and (obj.Position - root.Position).Magnitude < 25 then
                                safeTouch(obj)
                            end
                        end
                    end
                end

                -- 4. Virtual Input click simulation
                if VirtualInputManager then
                    pcall(function()
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                        task.wait(0.02)
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                    end)
                end
            end)
        end
    end
end)

-- 2. AUTO CLEAN LOOP
task.spawn(function()
    while true do
        task.wait(0.12)
        if AutoCleanEnabled then
            pcall(function()
                -- 1. Equip sponge / brush / clean tool
                equipAndActivateTool("clean")
                equipAndActivateTool("wash")
                equipAndActivateTool("sponge")
                equipAndActivateTool("brush")

                -- 2. Fire Clean Remotes
                for _, rem in ipairs(CachedRemotes.Clean) do
                    pcall(function()
                        if rem:IsA("RemoteEvent") then
                            rem:FireServer()
                            rem:FireServer("Clean")
                            rem:FireServer(true)
                        elseif rem:IsA("RemoteFunction") then
                            rem:InvokeServer()
                        end
                    end)
                end

                -- 3. Scan & Clean Objects (Dirt, Objects, Trash, Mud, Stains)
                local root = getRoot()
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not AutoCleanEnabled then break end
                    local n = obj.Name:lower()
                    if n:find("clean") or n:find("wash") or n:find("dirt") or n:find("trash") or n:find("mud") or n:find("stain") or n:find("item") then
                        if obj:IsA("ProximityPrompt") then
                            triggerPrompt(obj)
                        elseif obj:IsA("ClickDetector") and fireclickdetector then
                            fireclickdetector(obj)
                        elseif obj:IsA("BasePart") then
                            if root and (obj.Position - root.Position).Magnitude < 30 then
                                safeTouch(obj)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- 3. AUTO SELL LOOP
task.spawn(function()
    while true do
        task.wait(0.3)
        if AutoSellEnabled then
            pcall(function()
                -- 1. Fire Sell Remotes
                for _, rem in ipairs(CachedRemotes.Sell) do
                    pcall(function()
                        if rem:IsA("RemoteEvent") then
                            rem:FireServer()
                            rem:FireServer("Sell")
                            rem:FireServer("SellAll")
                            rem:FireServer(true)
                        elseif rem:IsA("RemoteFunction") then
                            rem:InvokeServer()
                            rem:InvokeServer("SellAll")
                        end
                    end)
                end

                -- 2. Scan for Sell Pads & Touch / Trigger them
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not AutoSellEnabled then break end
                    local n = obj.Name:lower()
                    if n:find("sell") or n:find("deposit") or n:find("cashout") then
                        if obj:IsA("BasePart") then
                            safeTouch(obj)
                        elseif obj:IsA("ProximityPrompt") then
                            triggerPrompt(obj)
                        elseif obj:IsA("Model") and obj.PrimaryPart then
                            safeTouch(obj.PrimaryPart)
                        end
                    end
                end
            end)
        end
    end
end)

-- 4. SPEED REGULATOR LOOP
task.spawn(function()
    while true do
        task.wait(0.5)
        if WalkSpeedEnabled then
            local hum = getHum()
            if hum and hum.WalkSpeed ~= BoostSpeed then
                hum.WalkSpeed = BoostSpeed
            end
        end
    end
end)

-- Display Notification
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Ultra Script Hub",
        Text = "Dig and Clean script loaded successfully!",
        Duration = 4
    })
end)

print("[Ultra Script Hub] Dig and Clean initialized successfully.")
