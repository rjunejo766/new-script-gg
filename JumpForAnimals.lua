--==============================================================--
--  ULTRA SCRIPT HUB - Made by Junejo
--  Game: Jump for Animals!
--  Game Link: https://www.roblox.com/games/126870639873289/Jump-for-Animals
--  GitHub: https://github.com/rjunejo766/new-script-gg
--  Features: Fly Mode, Walkspeed, Infinite Jump
--==============================================================--

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Safe LocalPlayer Resolution
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    repeat
        task.wait(0.05)
        LocalPlayer = Players.LocalPlayer
    until LocalPlayer
end

local Camera = Workspace.CurrentCamera

-- Feature Toggle States
local FlyEnabled = false
local WalkSpeedEnabled = false
local InfJumpEnabled = false

local NormalSpeed = 16
local BoostSpeed = 60
local FlySpeed = 60

--==============================================================--
--  GUI CREATION (Exact Ultra Script Hub Official Theme)
--==============================================================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraScriptHub_JumpForAnimals"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999

-- Safe Parent Resolution
local parentGui = nil
pcall(function()
    if gethui then parentGui = gethui() end
end)
if not parentGui then
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
        parentGui = CoreGui
    end)
end
if not parentGui then
    pcall(function()
        parentGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
    end)
end

-- Cleanup Old Instances
pcall(function()
    if parentGui and parentGui:FindFirstChild("UltraScriptHub_JumpForAnimals") then
        parentGui:FindFirstChild("UltraScriptHub_JumpForAnimals"):Destroy()
    end
    if CoreGui and CoreGui:FindFirstChild("UltraScriptHub_JumpForAnimals") then
        CoreGui:FindFirstChild("UltraScriptHub_JumpForAnimals"):Destroy()
    end
    local lpGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if lpGui and lpGui:FindFirstChild("UltraScriptHub_JumpForAnimals") then
        lpGui:FindFirstChild("UltraScriptHub_JumpForAnimals"):Destroy()
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

-- Main Outer Frame (Exact Screenshot Dimensions & Style)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 310, 0, 240)
MainFrame.Position = UDim2.new(0.5, -155, 0.35, -120)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(35, 38, 48)
UIStroke.Thickness = 1.2
UIStroke.Parent = MainFrame

-- Floating Open/Close Button (⚡) for Mobile & Quick Access
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "FloatingToggle"
ToggleBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleBtn.Position = UDim2.new(0, 15, 0.5, -20)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
ToggleBtn.BorderColor3 = Color3.fromRGB(0, 170, 255)
ToggleBtn.BorderSizePixel = 1
ToggleBtn.Text = "⚡"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
ToggleBtn.TextSize = 20
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

-- Header Title (Exact Screenshot: "+1 JUMP FOR ANIMALS SCRIPT")
local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -50, 0, 32)
HeaderTitle.Position = UDim2.new(0, 16, 0, 12)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "+1 JUMP FOR ANIMALS SCRIPT"
HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitle.TextSize = 14
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
Container.Size = UDim2.new(1, -32, 0, 125)
Container.Position = UDim2.new(0, 16, 0, 50)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 0)
UIListLayout.Parent = Container

-- Footer Branding (Exact Screenshot: Centered)
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

-- Checkbox Row Generator (Exact Screenshot Styling)
local function CreateToggleRow(name, callback, isLast)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 38)
    Row.BackgroundTransparency = 1
    Row.Parent = Container

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -45, 1, 0)
    Label.Position = UDim2.new(0, 4, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14
    Label.Font = Enum.Font.SourceSansBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local Checkbox = Instance.new("TextButton")
    Checkbox.Size = UDim2.new(0, 22, 0, 22)
    Checkbox.Position = UDim2.new(1, -24, 0.5, -11)
    Checkbox.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    Checkbox.BorderColor3 = Color3.fromRGB(75, 80, 95)
    Checkbox.BorderSizePixel = 1
    Checkbox.Text = ""
    Checkbox.AutoButtonColor = false
    Checkbox.Parent = Row

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 5)
    BoxCorner.Parent = Checkbox

    local CheckIcon = Instance.new("Frame")
    CheckIcon.Size = UDim2.new(1, -6, 1, -6)
    CheckIcon.Position = UDim2.new(0, 3, 0, 3)
    CheckIcon.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    CheckIcon.Visible = false
    CheckIcon.Parent = Checkbox

    local CheckIconCorner = Instance.new("UICorner")
    CheckIconCorner.CornerRadius = UDim.new(0, 3)
    CheckIconCorner.Parent = CheckIcon

    -- Subtle horizontal divider line (like screenshot)
    if not isLast then
        local Divider = Instance.new("Frame")
        Divider.Size = UDim2.new(1, 0, 0, 1)
        Divider.Position = UDim2.new(0, 0, 1, -1)
        Divider.BackgroundColor3 = Color3.fromRGB(28, 30, 38)
        Divider.BorderSizePixel = 0
        Divider.Parent = Row
    end

    local toggled = false
    local function setToggle(state)
        toggled = state
        CheckIcon.Visible = toggled
        if toggled then
            Checkbox.BorderColor3 = Color3.fromRGB(0, 170, 255)
        else
            Checkbox.BorderColor3 = Color3.fromRGB(75, 80, 95)
        end
        callback(toggled)
    end

    Checkbox.MouseButton1Click:Connect(function()
        setToggle(not toggled)
    end)
end

--==============================================================--
--  CHARACTER UTILITIES
--==============================================================--
local function getChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHum()
    local char = getChar()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function getRoot()
    local char = getChar()
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
end

--==============================================================--
--  1. FLY MODE (WASD / Space / Shift + Mobile Joystick)
--==============================================================--
CreateToggleRow("Fly Mode", function(state)
    FlyEnabled = state
    local char = getChar()
    local root = getRoot()
    local hum = getHum()
    if not root or not hum then return end

    if FlyEnabled then
        local bg = Instance.new("BodyGyro")
        bg.Name = "FlyGyro"
        bg.P = 9e4
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.CFrame = root.CFrame
        bg.Parent = root

        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyVelocity"
        bv.Velocity = Vector3.new(0, 0.1, 0)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Parent = root

        task.spawn(function()
            while FlyEnabled and root and bg and bv and bg.Parent and bv.Parent do
                local camCFrame = Camera.CFrame
                local newVelocity = Vector3.new(0, 0, 0)

                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    newVelocity = newVelocity + (camCFrame.LookVector * FlySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    newVelocity = newVelocity - (camCFrame.LookVector * FlySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    newVelocity = newVelocity - (camCFrame.RightVector * FlySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    newVelocity = newVelocity + (camCFrame.RightVector * FlySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    newVelocity = newVelocity + Vector3.new(0, FlySpeed, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    newVelocity = newVelocity - Vector3.new(0, FlySpeed, 0)
                end

                -- Mobile / Touch Move Direction support
                if hum.MoveDirection.Magnitude > 0 and newVelocity.Magnitude == 0 then
                    newVelocity = (camCFrame.LookVector * (hum.MoveDirection.Z * -FlySpeed)) + (camCFrame.RightVector * (hum.MoveDirection.X * FlySpeed))
                end

                bv.Velocity = newVelocity
                bg.CFrame = camCFrame
                RunService.RenderStepped:Wait()
            end

            if bg then bg:Destroy() end
            if bv then bv:Destroy() end
        end)
    else
        if root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
        if root:FindFirstChild("FlyVelocity") then root.FlyVelocity:Destroy() end
    end
end, false)

--==============================================================--
--  2. WALKSPEED
--==============================================================--
CreateToggleRow("Walkspeed", function(state)
    WalkSpeedEnabled = state
    local hum = getHum()
    if hum then
        hum.WalkSpeed = WalkSpeedEnabled and BoostSpeed or NormalSpeed
    end
end, false)

-- Continuous WalkSpeed Enforcement Loop
task.spawn(function()
    while true do
        task.wait(0.2)
        if WalkSpeedEnabled then
            local hum = getHum()
            if hum and hum.WalkSpeed ~= BoostSpeed then
                hum.WalkSpeed = BoostSpeed
            end
        end
    end
end)

--==============================================================--
--  3. INFINITE JUMP
--==============================================================--
CreateToggleRow("Infinite Jump", function(state)
    InfJumpEnabled = state
end, true)

UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled then
        local hum = getHum()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

--==============================================================--
--  RESPAWN HANDLER
--==============================================================--
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum and WalkSpeedEnabled then
        hum.WalkSpeed = BoostSpeed
    end
end)

--==============================================================--
--  ANTI-AFK
--==============================================================--
LocalPlayer.Idled:Connect(function()
    local vu = game:GetService("VirtualUser")
    if vu then
        vu:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    end
end)

print("[UltraScriptHub] +1 Jump for Animals Script loaded with Exact Screenshot UI!")
