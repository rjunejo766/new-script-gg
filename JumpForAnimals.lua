--==============================================================--
--  ULTRA SCRIPT HUB - Made by Junejo
--  Game: Jump for Animals!
--  Game Link: https://www.roblox.com/games/126870639873289/Jump-for-Animals
--  GitHub: https://github.com/rjunejo766/new-script-gg
--  Features: Fly Mode, Walkspeed, Infinite Jump, Rare Egg ESP
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
local RareEggESPEnabled = false

local NormalSpeed = 16
local BoostSpeed = 60
local FlySpeed = 60

local ActiveESPObjects = {}

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
MainFrame.Size = UDim2.new(0, 310, 0, 285)
MainFrame.Position = UDim2.new(0.5, -155, 0.35, -142)
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
Container.Size = UDim2.new(1, -32, 0, 165)
Container.Position = UDim2.new(0, 16, 0, 48)
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

    -- Subtle horizontal divider line
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
end, false)

UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled then
        local hum = getHum()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

--==============================================================--
--  4. RARE EGG ESP (Highlights + Direct Teleport to Rarest Egg)
--==============================================================--
local function clearEggESP()
    for _, esp in ipairs(ActiveESPObjects) do
        if esp and esp.Parent then
            pcall(function() esp:Destroy() end)
        end
    end
    table.clear(ActiveESPObjects)
end

local function getEggScore(obj)
    local name = obj.Name:lower()
    local parentName = (obj.Parent and obj.Parent.Name:lower()) or ""
    local full = name .. " " .. parentName

    local score = 0
    if full:find("secret") then
        score = 1000
    elseif full:find("divine") or full:find("godly") then
        score = 800
    elseif full:find("mythic") or full:find("mythical") then
        score = 600
    elseif full:find("legendary") then
        score = 400
    elseif full:find("epic") then
        score = 250
    elseif full:find("rare") then
        score = 150
    elseif full:find("uncommon") then
        score = 80
    elseif full:find("egg") or full:find("nest") or full:find("animal") then
        score = 50
    end

    -- Add altitude / Y bonus (higher islands usually have rarer eggs)
    local pos = obj:IsA("BasePart") and obj.Position or (obj:IsA("Model") and obj:GetPivot().Position)
    if pos then
        score = score + math.floor(pos.Y / 10)
    end
    return score
end

local function findRarestEgg()
    local bestEgg = nil
    local highestScore = -1
    local bestPosition = nil

    local searchRoots = {
        Workspace:FindFirstChild("Eggs"),
        Workspace:FindFirstChild("Nests"),
        Workspace:FindFirstChild("Spawns"),
        Workspace:FindFirstChild("Map"),
        Workspace:FindFirstChild("Islands"),
        Workspace
    }

    for _, rootFolder in ipairs(searchRoots) do
        if rootFolder then
            for _, obj in ipairs(rootFolder:GetDescendants()) do
                if obj:IsA("BasePart") or obj:IsA("Model") then
                    local name = obj.Name:lower()
                    local parentName = (obj.Parent and obj.Parent.Name:lower()) or ""
                    
                    -- Check if it's an egg / nest / animal spawn
                    local isEgg = name:find("egg") or name:find("nest") or parentName:find("egg") or parentName:find("nest")
                    if not isEgg then
                        if obj:FindFirstChildOfClass("ProximityPrompt") or obj:FindFirstChildOfClass("ClickDetector") then
                            if name:find("steal") or name:find("grab") or name:find("collect") or name:find("claim") then
                                isEgg = true
                            end
                        end
                    end

                    if isEgg then
                        local score = getEggScore(obj)
                        local pos = obj:IsA("BasePart") and obj.Position or obj:GetPivot().Position
                        if score > highestScore and pos then
                            highestScore = score
                            bestEgg = obj
                            bestPosition = pos
                        end
                    end
                end
            end
        end
        if bestEgg and highestScore > 100 then break end
    end

    return bestEgg, bestPosition, highestScore
end

local function createESPForEgg(obj, isRarest)
    pcall(function()
        local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart", true)
        if not part then return end

        local bb = Instance.new("BillboardGui")
        bb.Name = "EggESP"
        bb.Adornee = part
        bb.Size = UDim2.new(0, 160, 0, 40)
        bb.StudsOffset = Vector3.new(0, 3.5, 0)
        bb.AlwaysOnTop = true

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.SourceSansBold
        label.TextSize = isRarest and 15 or 13
        label.TextColor3 = isRarest and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(0, 255, 255)
        label.TextStrokeTransparency = 0
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        label.Text = (isRarest and "👑 [RAREST EGG]\n" or "🥚 ") .. obj.Name
        label.Parent = bb

        bb.Parent = part
        table.insert(ActiveESPObjects, bb)

        -- Highlight Box
        local highlight = Instance.new("Highlight")
        highlight.Adornee = obj
        highlight.FillColor = isRarest and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(0, 170, 255)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = obj
        table.insert(ActiveESPObjects, highlight)
    end)
end

CreateToggleRow("Rare Egg ESP", function(state)
    RareEggESPEnabled = state
    if not RareEggESPEnabled then
        clearEggESP()
        return
    end

    task.spawn(function()
        local teleportedOnce = false

        while RareEggESPEnabled do
            clearEggESP()
            local rarestEgg, rarestPos, score = findRarestEgg()
            local root = getRoot()

            if rarestEgg and rarestPos then
                -- 1. Create ESP on Rarest Egg
                createESPForEgg(rarestEgg, true)

                -- 2. Direct Teleport to Rarest Egg (Lands directly on it)
                if root and (not teleportedOnce or (root.Position - rarestPos).Magnitude > 250) then
                    root.CFrame = CFrame.new(rarestPos + Vector3.new(0, 4, 0))
                    teleportedOnce = true

                    -- Auto trigger proximity prompt if available
                    task.wait(0.2)
                    for _, p in ipairs(rarestEgg:GetDescendants()) do
                        if p:IsA("ProximityPrompt") then
                            p.HoldDuration = 0
                            if fireproximityprompt then
                                fireproximityprompt(p, 0)
                            end
                        elseif p:IsA("ClickDetector") and fireclickdetector then
                            fireclickdetector(p)
                        end
                    end
                end
            end

            task.wait(3)
        end
        clearEggESP()
    end)
end, true)

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

print("[UltraScriptHub] +1 Jump for Animals Script with Rare Egg ESP loaded!")
