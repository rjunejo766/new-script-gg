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
local AutoCleanDirt = false
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

-- Helper: Find Water Gun / Washer Tool (Strict Filter)
local function getWasherGunTool()
    local char = LocalPlayer.Character
    local bp = LocalPlayer:FindFirstChild("Backpack")

    -- Check equipped tools
    if char then
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") then
                local name = string.lower(t.Name)
                -- Avoid furniture, items, boxes, seats
                if not string.find(name, "item") and not string.find(name, "box") and not string.find(name, "seat") and not string.find(name, "chair") then
                    return t
                end
            end
        end
    end

    -- Check Backpack
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") then
                local name = string.lower(t.Name)
                if not string.find(name, "item") and not string.find(name, "box") and not string.find(name, "seat") and not string.find(name, "chair") then
                    return t
                end
            end
        end
    end

    -- Fallback to any tool if not holding an item
    return char and char:FindFirstChildOfClass("Tool") or bp and bp:FindFirstChildOfClass("Tool")
end

-- Helper: Get All Cleanable Dirt & Wall Objects in Entire House
local function getAllDirtAndWalls()
    local targets = {}
    local char = LocalPlayer.Character
    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
    local myPos = root and root.Position or Vector3.new(0, 0, 0)

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(char) then
            local name = string.lower(obj.Name)
            local parentName = obj.Parent and string.lower(obj.Parent.Name) or ""
            
            -- Detect all dirt, mud, stains, walls, floors, washed objects, cleanables
            local isDirt = string.find(name, "dirt") 
                        or string.find(name, "stain") 
                        or string.find(name, "mud") 
                        or string.find(name, "wall") 
                        or string.find(name, "floor") 
                        or string.find(name, "clean") 
                        or string.find(name, "wash") 
                        or string.find(name, "mess") 
                        or string.find(name, "tile") 
                        or string.find(parentName, "dirt") 
                        or string.find(parentName, "wall") 
                        or string.find(parentName, "wash") 
                        or string.find(parentName, "house") 
                        or obj:FindFirstChildOfClass("Decal") 
                        or obj:FindFirstChildOfClass("Texture")

            -- Exclude player characters and UI
            if isDirt and not string.find(name, "humanoid") and not string.find(name, "head") then
                table.insert(targets, obj)
            end
        end
    end

    -- Sort nearest first
    table.sort(targets, function(a, b)
        return (a.Position - myPos).Magnitude < (b.Position - myPos).Magnitude
    end)

    return targets
end

-- 1. Auto Clean Dirt (Instant 1-Click Complete House & Wall Cleaner)
CreateToggleRow("Auto Clean Dirt", function(state)
    AutoCleanDirt = state
    if AutoCleanDirt then
        task.spawn(function()
            while AutoCleanDirt do
                pcall(function()
                    local char = LocalPlayer.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    local tool = getWasherGunTool()

                    -- 1. Equip Washer Gun
                    if tool and hum then
                        if tool.Parent ~= char then
                            hum:UnequipTools()
                            task.wait(0.01)
                            hum:EquipTool(tool)
                        end
                        tool:Activate()
                    end

                    -- 2. Scan ALL dirt objects across entire house
                    local allDirt = getAllDirtAndWalls()

                    -- 3. Instant Clean Loop across all detected objects
                    for i = 1, #allDirt do
                        if not AutoCleanDirt then break end
                        local dirt = allDirt[i]
                        local dirtPos = dirt.Position

                        -- Fire Tool Remotes
                        if tool then
                            for _, rem in ipairs(tool:GetDescendants()) do
                                if rem:IsA("RemoteEvent") then
                                    rem:FireServer(dirtPos, dirt)
                                    rem:FireServer(dirt, dirtPos)
                                    rem:FireServer(dirt)
                                    rem:FireServer(dirtPos)
                                elseif rem:IsA("RemoteFunction") then
                                    pcall(function() rem:InvokeServer(dirtPos, dirt) end)
                                end
                            end
                        end

                        -- Fire ReplicatedStorage Cleaning Remotes
                        for _, rem in ipairs(ReplicatedStorage:GetDescendants()) do
                            if rem:IsA("RemoteEvent") then
                                local lower = string.lower(rem.Name)
                                if string.find(lower, "clean") 
                                    or string.find(lower, "wash") 
                                    or string.find(lower, "spray") 
                                    or string.find(lower, "water") 
                                    or string.find(lower, "hit") 
                                    or string.find(lower, "damage") 
                                    or string.find(lower, "gun") then
                                    if not string.find(lower, "buy") and not string.find(lower, "shop") and not string.find(lower, "item") and not string.find(lower, "trade") then
                                        rem:FireServer(dirtPos, dirt)
                                        rem:FireServer(dirt, dirtPos)
                                        rem:FireServer(dirt)
                                    end
                                end
                            end
                        end

                        -- Clear dirt decals / textures instantly
                        for _, child in ipairs(dirt:GetChildren()) do
                            if child:IsA("Decal") or child:IsA("Texture") then
                                child.Transparency = 1
                            end
                        end
                    end
                end)
                task.wait(0.15)
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
