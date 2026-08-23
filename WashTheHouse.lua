-- ULTRA SCRIPT HUB - Made by Junejo
-- Game: Wash The House

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- State Variables
local AutoClean = false
local SpeedBoostEnabled = false
local InfJumpEnabled = false

local NormalSpeed = 16
local BoostSpeed = 50

-- Respawn Handler
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
    if SpeedBoostEnabled then
        Humanoid.WalkSpeed = BoostSpeed
    end
end)

----------------------------------------------------------------
-- GUI Creation (Matching ULTRA SCRIPT HUB Theme)
----------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraScriptHub_WashTheHouse"
ScreenGui.ResetOnSpawn = false

local parentGui = LocalPlayer:WaitForChild("PlayerGui")
if gethui then
    parentGui = gethui()
elseif game:GetService("CoreGui") then
    parentGui = game:GetService("CoreGui")
end
ScreenGui.Parent = parentGui

-- Main Outer Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 230)
MainFrame.Position = UDim2.new(0.5, -160, 0.4, -115)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Header Title
local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -40, 0, 35)
HeaderTitle.Position = UDim2.new(0, 15, 0, 8)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "WASH THE HOUSE"
HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitle.TextSize = 14
HeaderTitle.Font = Enum.Font.SourceSansBold
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.Parent = MainFrame

-- Close Button (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 8)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Parent = MainFrame

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Container for Toggles
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -30, 0, 120)
Container.Position = UDim2.new(0, 15, 0, 45)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = Container

-- Footer Branding
local FooterTitle = Instance.new("TextLabel")
FooterTitle.Size = UDim2.new(1, 0, 0, 18)
FooterTitle.Position = UDim2.new(0, 0, 1, -38)
FooterTitle.BackgroundTransparency = 1
FooterTitle.Text = "ULTRA SCRIPT HUB"
FooterTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
FooterTitle.TextSize = 14
FooterTitle.Font = Enum.Font.SourceSansBold
FooterTitle.Parent = MainFrame

local FooterSub = Instance.new("TextLabel")
FooterSub.Size = UDim2.new(1, 0, 0, 16)
FooterSub.Position = UDim2.new(0, 0, 1, -20)
FooterSub.BackgroundTransparency = 1
FooterSub.Text = "Made by Junejo"
FooterSub.TextColor3 = Color3.fromRGB(150, 150, 150)
FooterSub.TextSize = 12
FooterSub.Font = Enum.Font.SourceSans
FooterSub.Parent = MainFrame

-- Helper Function for Checkbox Row
local function CreateToggleRow(name, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 28)
    Row.BackgroundTransparency = 1
    Row.Parent = Container

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -35, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(240, 240, 240)
    Label.TextSize = 14
    Label.Font = Enum.Font.SourceSansBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local Checkbox = Instance.new("TextButton")
    Checkbox.Size = UDim2.new(0, 22, 0, 22)
    Checkbox.Position = UDim2.new(1, -25, 0.5, -11)
    Checkbox.BackgroundColor3 = Color3.fromRGB(25, 27, 35)
    Checkbox.BorderColor3 = Color3.fromRGB(50, 55, 70)
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
    Checkbox.MouseButton1Click:Connect(function()
        toggled = not toggled
        CheckIcon.Visible = toggled
        callback(toggled)
    end)
end

----------------------------------------------------------------
-- Features Implementation
----------------------------------------------------------------

-- Services
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Helper: Get Player Tool
local function getEquippedOrBackpackTool()
    local char = LocalPlayer.Character
    if char then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then return tool end
    end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then
        local tool = bp:FindFirstChildOfClass("Tool")
        if tool then return tool end
    end
    return nil
end

-- Helper: Find All Wall & Dirt Parts
local function getAllWallsAndDirt()
    local list = {}
    local char = LocalPlayer.Character
    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
    local myPos = root and root.Position or Vector3.new(0, 0, 0)

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(char) then
            local name = string.lower(obj.Name)
            if string.find(name, "wall") 
                or string.find(name, "dirt") 
                or string.find(name, "stain") 
                or string.find(name, "floor") 
                or string.find(name, "mud") 
                or string.find(name, "clean") 
                or obj:FindFirstChildOfClass("Decal") 
                or obj:FindFirstChildOfClass("Texture") then
                table.insert(list, obj)
            end
        end
    end

    table.sort(list, function(a, b)
        return (a.Position - myPos).Magnitude < (b.Position - myPos).Magnitude
    end)

    return list
end

-- 1. Auto Clean House (Full Wall & Room High-Speed Sweeper)
CreateToggleRow("Auto Clean House", function(state)
    AutoClean = state
    if AutoClean then
        -- Thread 1: Fast Screen Grid Sweep (Sweeps Water Gun across ENTIRE wall/screen)
        task.spawn(function()
            local cam = workspace.CurrentCamera
            while AutoClean do
                pcall(function()
                    local char = LocalPlayer.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    local tool = getEquippedOrBackpackTool()

                    -- Equip Water Gun / Cleaner
                    if tool and hum then
                        if tool.Parent ~= char then
                            hum:EquipTool(tool)
                        end
                        tool:Activate()
                    end

                    -- Sweep across the entire screen (10x10 matrix to wash the whole wall)
                    local vpSize = cam and cam.ViewportSize or Vector2.new(1920, 1080)
                    if VirtualUser then
                        VirtualUser:CaptureController()
                    end

                    for yRatio = 0.20, 0.85, 0.12 do
                        if not AutoClean then break end
                        for xRatio = 0.15, 0.85, 0.10 do
                            if not AutoClean then break end
                            local pos = Vector2.new(vpSize.X * xRatio, vpSize.Y * yRatio)
                            
                            if VirtualUser then
                                VirtualUser:Button1Down(pos)
                                VirtualUser:Button1Up(pos)
                            end

                            if VirtualInputManager then
                                VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 1)
                                VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 1)
                            end
                            task.wait(0.01)
                        end
                    end
                end)
                task.wait(0.05)
            end
        end)

        -- Thread 2: Remote Flooding across all Wall & Dirt coordinates
        task.spawn(function()
            while AutoClean do
                pcall(function()
                    local char = LocalPlayer.Character
                    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
                    local tool = getEquippedOrBackpackTool()
                    local walls = getAllWallsAndDirt()

                    -- Generate surface grid points for nearby walls
                    for i = 1, math.min(10, #walls) do
                        if not AutoClean then break end
                        local wall = walls[i]
                        local cf = wall.CFrame
                        local sz = wall.Size

                        -- Sweep 3D points across the wall face
                        for sx = -0.4, 0.4, 0.2 do
                            for sy = -0.4, 0.4, 0.2 do
                                local hitPoint = (cf * CFrame.new(sz.X * sx, sz.Y * sy, 0)).Position

                                -- Fire Tool Remotes with this point
                                if tool then
                                    for _, child in ipairs(tool:GetDescendants()) do
                                        if child:IsA("RemoteEvent") then
                                            child:FireServer(hitPoint, wall)
                                            child:FireServer(wall, hitPoint)
                                        end
                                    end
                                end

                                -- Fire ReplicatedStorage Cleaning Remotes
                                for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
                                    if remote:IsA("RemoteEvent") then
                                        local lower = string.lower(remote.Name)
                                        if string.find(lower, "clean") or string.find(lower, "wash") or string.find(lower, "shoot") or string.find(lower, "spray") or string.find(lower, "hit") then
                                            remote:FireServer(wall, hitPoint)
                                            remote:FireServer(hitPoint, wall)
                                        end
                                    end
                                end
                            end
                        end

                        -- Touch Interest
                        if firetouchinterest and root then
                            pcall(function()
                                firetouchinterest(root, wall, 0)
                                firetouchinterest(root, wall, 1)
                            end)
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
end)

-- 2. WalkSpeed Boost (50)
CreateToggleRow("WalkSpeed Boost (50)", function(state)
    SpeedBoostEnabled = state
    if Humanoid then
        if SpeedBoostEnabled then
            Humanoid.WalkSpeed = BoostSpeed
        else
            Humanoid.WalkSpeed = NormalSpeed
        end
    end
end)

-- 3. Infinite Jump
CreateToggleRow("Infinite Jump", function(state)
    InfJumpEnabled = state
end)

UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)
