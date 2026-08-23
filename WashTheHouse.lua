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

-- 1. Auto Clean House (Multi-Engine Wall & Object Cleaning)
CreateToggleRow("Auto Clean House", function(state)
    AutoClean = state
    if AutoClean then
        task.spawn(function()
            while AutoClean do
                pcall(function()
                    local char = LocalPlayer.Character
                    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    local tool = getEquippedOrBackpackTool()

                    -- 1. Auto Equip & Activate Cleaner / Washer Tool
                    if tool and hum then
                        if tool.Parent ~= char then
                            hum:EquipTool(tool)
                        end
                        tool:Activate()
                    end

                    -- 2. Scan & Fire Tool Remotes
                    if tool then
                        for _, child in ipairs(tool:GetDescendants()) do
                            if child:IsA("RemoteEvent") then
                                child:FireServer()
                            elseif child:IsA("RemoteFunction") then
                                child:InvokeServer()
                            end
                        end
                    end

                    -- 3. Scan & Fire Global Cleaning / Washing Remotes
                    local commonNames = {
                        "clean", "wash", "cleanhouse", "cleanwall", "spray", "water", 
                        "hit", "interact", "wipe", "brush", "mop", "sponge", "progress"
                    }
                    
                    for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
                        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                            local lowerName = string.lower(remote.Name)
                            for _, match in ipairs(commonNames) do
                                if string.find(lowerName, match) then
                                    if remote:IsA("RemoteEvent") then
                                        remote:FireServer()
                                    elseif remote:IsA("RemoteFunction") then
                                        remote:InvokeServer()
                                    end
                                    break
                                end
                            end
                        end
                    end

                    -- 4. Clean Walls, Dirt Parts, & Objects in Workspace
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if not AutoClean then break end

                        -- Instant Proximity Prompts
                        if obj:IsA("ProximityPrompt") then
                            pcall(function()
                                obj.HoldDuration = 0
                                obj.RequiresLineOfSight = false
                                obj.MaxActivationDistance = 50
                                if fireproximityprompt then
                                    fireproximityprompt(obj, 0, true)
                                end
                            end)
                        end

                        -- Instant ClickDetectors (Many wall-cleaning games use ClickDetectors)
                        if obj:IsA("ClickDetector") and fireclickdetector then
                            pcall(function()
                                fireclickdetector(obj)
                            end)
                        end

                        -- Touch Interest on Dirt / Wall / Stain Parts
                        local lowerObj = string.lower(obj.Name)
                        if obj:IsA("BasePart") and (
                            string.find(lowerObj, "dirt") or 
                            string.find(lowerObj, "wall") or 
                            string.find(lowerObj, "stain") or 
                            string.find(lowerObj, "clean") or 
                            string.find(lowerObj, "mess") or 
                            string.find(lowerObj, "spot")
                        ) then
                            -- Touch simulation if supported
                            if firetouchinterest and root then
                                pcall(function()
                                    firetouchinterest(root, obj, 0)
                                    firetouchinterest(root, obj, 1)
                                end)
                            end

                            -- If the part has specific remotes or click triggers inside it
                            local partRemote = obj:FindFirstChildOfClass("RemoteEvent")
                            if partRemote then
                                partRemote:FireServer()
                            end
                        end
                    end
                end)
                task.wait(0.2)
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
