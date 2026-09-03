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
--  CHARACTER UTILITIES & RELIABLE TELEPORT
--==============================================================--
local function getChar()
    return LocalPlayer.Character or (LocalPlayer.CharacterAdded:Wait())
end

local function getHum()
    local char = getChar()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function getRoot()
    local char = getChar()
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
end

local function teleportTo(pos)
    pcall(function()
        local char = getChar()
        local root = getRoot()
        local hum = getHum()
        if not char or not root then return end

        if hum then
            hum.Sit = false
        end

        local targetCFrame = CFrame.new(pos.X, pos.Y + 3.5, pos.Z)
        root.CFrame = targetCFrame
        char:PivotTo(targetCFrame)
        pcall(function() char:SetPrimaryPartCFrame(targetCFrame) end)
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end)
end

--==============================================================--
--  EGG SCANNER & RARITY SCORER
--==============================================================--
local function clearEggESP()
    for _, esp in ipairs(ActiveESPObjects) do
        if esp and esp.Parent then
            pcall(function() esp:Destroy() end)
        end
    end
    table.clear(ActiveESPObjects)
end

local function calculateScore(name, pos, promptText)
    local n = (name .. " " .. (promptText or "")):lower()
    local score = 100

    if n:find("secret") then
        score = score + 5000
    elseif n:find("godly") or n:find("divine") then
        score = score + 3500
    elseif n:find("mythic") or n:find("dragon") then
        score = score + 2500
    elseif n:find("legendary") then
        score = score + 1500
    elseif n:find("epic") then
        score = score + 800
    elseif n:find("rare") then
        score = score + 400
    elseif n:find("uncommon") then
        score = score + 200
    elseif n:find("egg") or n:find("nest") or n:find("animal") then
        score = score + 100
    end

    -- Altitude bonus (Upper platforms have rarest eggs)
    if pos then
        score = score + math.floor(pos.Y * 4)
    end

    return score
end

-- Comprehensive Map Egg Finder
local function findEggsOnMap()
    local found = {}
    local char = getChar()

    -- 1. Fast targeted scan in known folders
    local priorityFolders = {
        Workspace:FindFirstChild("Eggs"),
        Workspace:FindFirstChild("EggSpawns"),
        Workspace:FindFirstChild("Nests"),
        Workspace:FindFirstChild("Map"),
        Workspace:FindFirstChild("Islands"),
        Workspace:FindFirstChild("Spawns"),
        Workspace:FindFirstChild("Zones"),
        Workspace
    }

    local checked = {}

    for _, container in ipairs(priorityFolders) do
        if container then
            for _, obj in ipairs(container:GetChildren()) do
                if not checked[obj] and obj ~= char and not obj:FindFirstChildOfClass("Humanoid") then
                    checked[obj] = true
                    local name = obj.Name:lower()
                    
                    local isEgg = name:find("egg") or name:find("nest") or name:find("dragon") or name:find("secret") or name:find("spawn")
                    local prompt = obj:FindFirstChildOfClass("ProximityPrompt", true)
                    local promptText = prompt and ((prompt.ActionText or "") .. " " .. (prompt.ObjectText or "")) or ""
                    
                    if not isEgg and prompt then
                        local pLower = promptText:lower()
                        if pLower:find("egg") or pLower:find("steal") or pLower:find("grab") or pLower:find("take") or pLower:find("claim") or pLower:find("collect") then
                            isEgg = true
                        end
                    end

                    if isEgg then
                        local mainPart = obj:IsA("BasePart") and obj or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)))
                        if mainPart then
                            local pos = mainPart.Position
                            local score = calculateScore(obj.Name, pos, promptText)
                            table.insert(found, {
                                Object = obj,
                                Part = mainPart,
                                Position = pos,
                                Score = score,
                                Name = obj.Name,
                                Prompt = prompt
                            })
                        end
                    end
                end
            end
        end
    end

    -- 2. Deep scan for any nested ProximityPrompts or Egg Models if fast scan was empty
    if #found == 0 then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                local parentPart = obj.Parent:IsA("BasePart") and obj.Parent or obj.Parent:FindFirstChildWhichIsA("BasePart", true)
                if parentPart and (not char or not parentPart:IsDescendantOf(char)) then
                    local pText = (obj.ActionText or "") .. " " .. (obj.ObjectText or "")
                    local pos = parentPart.Position
                    table.insert(found, {
                        Object = obj.Parent,
                        Part = parentPart,
                        Position = pos,
                        Score = calculateScore(obj.Parent.Name, pos, pText),
                        Name = obj.Parent.Name,
                        Prompt = obj
                    })
                end
            elseif obj:IsA("BasePart") and (obj.Name:lower():find("egg") or obj.Name:lower():find("nest")) then
                if not char or not obj:IsDescendantOf(char) then
                    local pos = obj.Position
                    table.insert(found, {
                        Object = obj,
                        Part = obj,
                        Position = pos,
                        Score = calculateScore(obj.Name, pos, ""),
                        Name = obj.Name,
                        Prompt = nil
                    })
                end
            end
        end
    end

    -- Sort by highest score descending
    table.sort(found, function(a, b)
        return a.Score > b.Score
    end)

    return found
end

local function createEggESP(data, isRarest)
    pcall(function()
        local part = data.Part
        if not part or not part.Parent then return end

        local bb = Instance.new("BillboardGui")
        bb.Name = "UltraEggESP"
        bb.Adornee = part
        bb.Size = UDim2.new(0, 180, 0, 45)
        bb.StudsOffset = Vector3.new(0, 4, 0)
        bb.AlwaysOnTop = true

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.SourceSansBold
        label.TextSize = isRarest and 16 or 13
        label.TextColor3 = isRarest and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(0, 255, 255)
        label.TextStrokeTransparency = 0
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        label.Text = (isRarest and "👑 [RAREST EGG]\n" or "🥚 ") .. data.Name
        label.Parent = bb

        bb.Parent = part
        table.insert(ActiveESPObjects, bb)

        local highlight = Instance.new("Highlight")
        highlight.Name = "UltraEggHighlight"
        highlight.Adornee = data.Object
        highlight.FillColor = isRarest and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(0, 170, 255)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.4
        highlight.OutlineTransparency = 0
        highlight.Parent = data.Object
        table.insert(ActiveESPObjects, highlight)
    end)
end

local function grabEgg(data)
    pcall(function()
        local root = getRoot()
        if not root then return end

        -- 1. Proximity Prompt Fire
        if data.Prompt then
            data.Prompt.HoldDuration = 0
            if fireproximityprompt then
                fireproximityprompt(data.Prompt, 0)
            elseif data.Prompt.InputHoldBegin and data.Prompt.InputHoldEnd then
                data.Prompt:InputHoldBegin()
                task.wait(0.01)
                data.Prompt:InputHoldEnd()
            end
        end

        -- 2. Touch Simulation
        if data.Part and firetouchinterest then
            firetouchinterest(root, data.Part, 0)
            task.wait(0.01)
            firetouchinterest(root, data.Part, 1)
        end

        -- 3. Click Detector Fire
        local cd = data.Object:FindFirstChildOfClass("ClickDetector", true)
        if cd and fireclickdetector then
            fireclickdetector(cd)
        end
    end)
end

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

-- Main Outer Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 310, 0, 290)
MainFrame.Position = UDim2.new(0.5, -155, 0.35, -145)
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

-- Floating Open/Close Button (⚡)
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

-- Header Title
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
Container.Size = UDim2.new(1, -32, 0, 170)
Container.Position = UDim2.new(0, 16, 0, 48)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 0)
UIListLayout.Parent = Container

-- Footer Branding
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

-- Checkbox Row Generator
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
--  ALL 4 TOGGLE ROWS
--==============================================================--

-- 1. Fly Mode
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

-- 2. Walkspeed
CreateToggleRow("Walkspeed", function(state)
    WalkSpeedEnabled = state
    local hum = getHum()
    if hum then
        hum.WalkSpeed = WalkSpeedEnabled and BoostSpeed or NormalSpeed
    end
end, false)

-- 3. Infinite Jump
CreateToggleRow("Infinite Jump", function(state)
    InfJumpEnabled = state
end, false)

-- 4. Rare Egg ESP (Instant Teleport + Deep Map Scan + ESP + Auto Grab)
CreateToggleRow("Rare Egg ESP", function(state)
    RareEggESPEnabled = state
    if not RareEggESPEnabled then
        clearEggESP()
        return
    end

    task.spawn(function()
        while RareEggESPEnabled do
            clearEggESP()
            local eggList = findEggsOnMap()

            if #eggList > 0 then
                local rarest = eggList[1]

                -- 1. Create ESP markers on all detected eggs
                for i = 1, math.min(#eggList, 15) do
                    createEggESP(eggList[i], (i == 1))
                end

                -- 2. INSTANT DIRECT TELEPORT TO THE RAREST EGG
                if rarest and rarest.Position then
                    teleportTo(rarest.Position)
                    task.wait(0.1)
                    grabEgg(rarest)
                end
            end

            task.wait(2)
        end
        clearEggESP()
    end)
end, true)

--==============================================================--
--  BACKGROUND LOOPS & LISTENERS
--==============================================================--

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

-- Infinite Jump Listener
UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled then
        local hum = getHum()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Respawn Handler
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum and WalkSpeedEnabled then
        hum.WalkSpeed = BoostSpeed
    end
end)

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    local vu = game:GetService("VirtualUser")
    if vu then
        vu:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    end
end)

print("[UltraScriptHub] +1 Jump for Animals Script loaded with 100% Instant Rare Egg Teleport!")
