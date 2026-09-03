--==============================================================--
--  ULTRA SCRIPT HUB - Made by Junejo
--  Game: Search For The Needle / Find The Needles
--  Version: 2.0 (Flawless Universal Auto Collect, ESP & Auto Dig)
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

local VirtualInputManager = nil
pcall(function() VirtualInputManager = game:GetService("VirtualInputManager") end)

-- Feature Toggle States
local AutoCollectNeedlesEnabled = false
local NeedleESPEnabled = false
local AutoSearchHaystackEnabled = false
local SpeedBoostEnabled = false
local InfJumpEnabled = false
local FlyEnabled = false

-- Movement Settings
local DefaultSpeed = 16
local BoostSpeed = 60
local FlySpeed = 50

-- Anti-AFK Setup
LocalPlayer.Idled:Connect(function()
    if VirtualUser then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

-- Character Helper Functions
local function getChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

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

-- Universal Touch Simulation (Multi-Part & Multi-Pulse)
local function safeTouch(part)
    if not part or not part:IsA("BasePart") then return end
    local char = LocalPlayer.Character
    if not char then return end
    local root = getRoot()
    if not root then return end

    local partsToTouch = {
        root,
        char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"),
        char:FindFirstChild("LowerTorso"),
        char:FindFirstChild("Right Leg") or char:FindFirstChild("RightFoot") or char:FindFirstChild("RightLowerLeg"),
        char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftFoot") or char:FindFirstChild("LeftLowerLeg"),
        char:FindFirstChild("Right Arm") or char:FindFirstChild("RightHand"),
        char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftHand")
    }

    pcall(function()
        if firetouchinterest then
            for _, p in ipairs(partsToTouch) do
                if p and p:IsA("BasePart") then
                    firetouchinterest(p, part, 0)
                    task.wait()
                    firetouchinterest(p, part, 1)
                end
            end
        end
    end)
end

-- Universal ProximityPrompt Trigger
local function triggerPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return end
    pcall(function()
        prompt.HoldDuration = 0
        if fireproximityprompt then
            fireproximityprompt(prompt, 0)
        else
            prompt:InputHoldBegin()
            task.wait(0.01)
            prompt:InputHoldEnd()
        end
    end)
end

-- Universal ClickDetector Simulation
local function safeClick(detector)
    if not detector or not detector:IsA("ClickDetector") then return end
    pcall(function()
        if fireclickdetector then
            fireclickdetector(detector)
            fireclickdetector(detector, 1)
            fireclickdetector(detector, 0)
        end
    end)
end

-- Universal GUI Button Click
local function clickGuiButton(btn)
    if not btn or not btn:IsA("GuiButton") then return end
    pcall(function()
        if getconnections then
            for _, conn in ipairs(getconnections(btn.MouseButton1Click)) do conn:Fire() end
            for _, conn in ipairs(getconnections(btn.Activated)) do conn:Fire() end
            for _, conn in ipairs(getconnections(btn.MouseButton1Down)) do conn:Fire() end
        end
    end)
end

-- Comprehensive Remote Finder
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
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if playerGui then search(playerGui) end
    return found
end

-- Fast Auto Attack / Dig Action
local function autoAttackAction()
    local char = LocalPlayer.Character
    if not char then return end

    -- Auto Equip Tools
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then
        local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        if backpack then
            for _, bTool in ipairs(backpack:GetChildren()) do
                if bTool:IsA("Tool") then
                    bTool.Parent = char
                    tool = bTool
                    break
                end
            end
        end
    end

    if tool then
        pcall(function() tool:Activate() end)
        for _, sub in ipairs(tool:GetDescendants()) do
            if sub:IsA("RemoteEvent") then
                pcall(function() sub:FireServer() end)
            elseif sub:IsA("RemoteFunction") then
                pcall(function() sub:InvokeServer() end)
            end
        end
    end

    if VirtualUser then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(500, 500))
        end)
    end
    if VirtualInputManager then
        pcall(function()
            VirtualInputManager:SendMouseButtonEvent(500, 500, 0, true, game, 0)
            task.wait(0.01)
            VirtualInputManager:SendMouseButtonEvent(500, 500, 0, false, game, 0)
        end)
    end
end

-- Comprehensive Needle Identifier
local function isNeedle(obj)
    if not obj then return false end
    if obj:IsDescendantOf(LocalPlayer.Character or game) then return false end

    local name = obj.Name:lower()
    local parentName = obj.Parent and obj.Parent.Name:lower() or ""

    -- Direct Keywords
    local needleKeywords = {
        "needle", "pin", "golden", "silver", "badge", "secret", "hidden", 
        "find", "collectible", "clue", "trophy", "marker", "star", "relic", "item"
    }

    for _, kw in ipairs(needleKeywords) do
        if name:find(kw) or parentName:find(kw) then
            return true
        end
    end

    -- Check ProximityPrompt or ClickDetector text
    local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
    if prompt then
        local act = (prompt.ActionText .. " " .. prompt.ObjectText):lower()
        if act:find("needle") or act:find("take") or act:find("collect") or act:find("grab") or act:find("pick") or act:find("find") then
            return true
        end
    end

    -- Check BillboardGui inside
    for _, child in ipairs(obj:GetDescendants()) do
        if child:IsA("TextLabel") and child.Text ~= "" then
            local txt = child.Text:lower()
            if txt:find("needle") or txt:find("collect") or txt:find("find") then
                return true
            end
        end
    end

    return false
end

-- Comprehensive Haystack Identifier
local function isHaystack(obj)
    if not obj then return false end
    if obj:IsDescendantOf(LocalPlayer.Character or game) then return false end

    local name = obj.Name:lower()
    local parentName = obj.Parent and obj.Parent.Name:lower() or ""
    
    local hayKeywords = {
        "hay", "stack", "pile", "grass", "straw", "wheat", "search", 
        "dig", "break", "dirt", "sand", "block", "box", "debris"
    }

    for _, kw in ipairs(hayKeywords) do
        if name:find(kw) or parentName:find(kw) then
            return true
        end
    end

    local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
    if prompt then
        local act = (prompt.ActionText .. " " .. prompt.ObjectText):lower()
        if act:find("search") or act:find("dig") or act:find("hay") or act:find("rummage") or act:find("break") then
            return true
        end
    end

    return false
end

-- Get valid BasePart from any target
local function getPartFromObj(obj)
    if not obj then return nil end
    if obj:IsA("BasePart") then
        return obj
    elseif obj:IsA("Model") then
        return obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)
    elseif obj:IsA("Tool") then
        return obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart", true)
    end
    return obj:FindFirstChildWhichIsA("BasePart", true)
end

--==============================================================--
--  GUI CREATION (Pixel-Perfect ULTRA SCRIPT HUB Design)
--==============================================================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraScriptHub_SearchForTheNeedle"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999

-- Clean previous instances
pcall(function()
    if CoreGui and CoreGui:FindFirstChild("UltraScriptHub_SearchForTheNeedle") then
        CoreGui:FindFirstChild("UltraScriptHub_SearchForTheNeedle"):Destroy()
    end
    local lpGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if lpGui and lpGui:FindFirstChild("UltraScriptHub_SearchForTheNeedle") then
        lpGui:FindFirstChild("UltraScriptHub_SearchForTheNeedle"):Destroy()
    end
end)

local parentGui = nil
if gethui then 
    pcall(function() parentGui = gethui() end) 
end
if not parentGui then 
    pcall(function() parentGui = CoreGui end) 
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
MainFrame.Size = UDim2.new(0, 330, 0, 330)
MainFrame.Position = UDim2.new(0.5, -165, 0.35, -165)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 1
UIStroke.Color = Color3.fromRGB(40, 40, 48)
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

-- Floating Toggle Button (Open/Close GUI)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleHubBtn"
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0, 15, 0.5, -22)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Text = "🪡"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 22
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleBtn

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Thickness = 1
ToggleStroke.Color = Color3.fromRGB(55, 55, 65)
ToggleStroke.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Header Title
local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -50, 0, 32)
HeaderTitle.Position = UDim2.new(0, 16, 0, 12)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "SEARCH FOR THE NEEDLE"
HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitle.TextSize = 13
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
Container.Size = UDim2.new(1, -32, 0, 230)
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
    Row.Size = UDim2.new(1, 0, 0, 36)
    Row.BackgroundTransparency = 1
    Row.Parent = Container

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -45, 1, 0)
    Label.Position = UDim2.new(0, 4, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 13
    Label.Font = Enum.Font.SourceSansBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local Checkbox = Instance.new("TextButton")
    Checkbox.Size = UDim2.new(0, 20, 0, 20)
    Checkbox.Position = UDim2.new(1, -24, 0.5, -10)
    Checkbox.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    Checkbox.BorderColor3 = Color3.fromRGB(75, 80, 95)
    Checkbox.BorderSizePixel = 1
    Checkbox.Text = ""
    Checkbox.TextColor3 = Color3.fromRGB(255, 255, 255)
    Checkbox.TextSize = 14
    Checkbox.Font = Enum.Font.SourceSansBold
    Checkbox.Parent = Row

    local CheckCorner = Instance.new("UICorner")
    CheckCorner.CornerRadius = UDim.new(0, 4)
    CheckCorner.Parent = Checkbox

    local isChecked = false
    Checkbox.MouseButton1Click:Connect(function()
        isChecked = not isChecked
        if isChecked then
            Checkbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Checkbox.TextColor3 = Color3.fromRGB(0, 0, 0)
            Checkbox.Text = "✓"
        else
            Checkbox.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
            Checkbox.TextColor3 = Color3.fromRGB(255, 255, 255)
            Checkbox.Text = ""
        end
        callback(isChecked)
    end)

    if not isLast then
        local Divider = Instance.new("Frame")
        Divider.Size = UDim2.new(1, 0, 0, 1)
        Divider.Position = UDim2.new(0, 0, 1, -1)
        Divider.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        Divider.BorderSizePixel = 0
        Divider.Parent = Row
    end

    return Checkbox
end

-- Toggle Rows
CreateToggleRow("Auto Collect Needles", function(state)
    AutoCollectNeedlesEnabled = state
end, false)

CreateToggleRow("Needle ESP / Radar", function(state)
    NeedleESPEnabled = state
end, false)

CreateToggleRow("Auto Search Haystack", function(state)
    AutoSearchHaystackEnabled = state
end, false)

CreateToggleRow("WalkSpeed Boost (60)", function(state)
    SpeedBoostEnabled = state
    local hum = getHum()
    if hum then
        hum.WalkSpeed = state and BoostSpeed or DefaultSpeed
    end
end, false)

CreateToggleRow("Infinite Jump", function(state)
    InfJumpEnabled = state
end, false)

CreateToggleRow("Fly Mode", function(state)
    FlyEnabled = state
end, true)

--==============================================================--
--  1. AUTO COLLECT NEEDLES (High Accuracy Auto Teleport & Collect)
--==============================================================--
task.spawn(function()
    while true do
        if AutoCollectNeedlesEnabled then
            pcall(function()
                local root = getRoot()
                if not root then return end

                local needles = {}
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not AutoCollectNeedlesEnabled then break end
                    if isNeedle(obj) then
                        local part = getPartFromObj(obj)
                        if part and part:IsA("BasePart") then
                            table.insert(needles, {part = part, parent = obj})
                        end
                    end
                end

                -- Sort by nearest
                local curPos = root.Position
                table.sort(needles, function(a, b)
                    return (a.part.Position - curPos).Magnitude < (b.part.Position - curPos).Magnitude
                end)

                for _, item in ipairs(needles) do
                    if not AutoCollectNeedlesEnabled then break end
                    local part = item.part
                    local obj = item.parent
                    if part and part.Parent and root then
                        -- Prevent fling
                        pcall(function()
                            root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        end)

                        -- Teleport directly onto the needle
                        root.CFrame = CFrame.new(part.Position + Vector3.new(0, 1.5, 0))

                        -- Pulse touches
                        safeTouch(part)

                        -- Trigger Proximity Prompts
                        local prompt = part:FindFirstChildWhichIsA("ProximityPrompt", true) or obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if prompt then triggerPrompt(prompt) end

                        -- Click detectors
                        local click = part:FindFirstChildWhichIsA("ClickDetector", true) or obj:FindFirstChildWhichIsA("ClickDetector", true)
                        if click then safeClick(click) end

                        -- Click GUI confirmations in PlayerGui
                        local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                        if playerGui then
                            for _, btn in ipairs(playerGui:GetDescendants()) do
                                if btn:IsA("GuiButton") and btn.Visible then
                                    local bName = btn.Name:lower()
                                    local bText = (btn:IsA("TextButton") and btn.Text:lower()) or ""
                                    if bName:find("collect") or bName:find("claim") or bName:find("take") or bName:find("ok") or
                                       bText:find("collect") or bText:find("claim") or bText:find("take") or bText:find("ok") or bText:find("yes") then
                                        clickGuiButton(btn)
                                    end
                                end
                            end
                        end

                        -- Fire specific and universal needle remotes
                        local remotes = findRemotes({
                            "needle", "collect", "pickup", "found", "claim", "item", "secret", "badge", "take", "grab", "touch"
                        })
                        for _, rem in ipairs(remotes) do
                            pcall(function()
                                if rem:IsA("RemoteEvent") then
                                    rem:FireServer(obj)
                                    rem:FireServer(part)
                                    rem:FireServer(obj.Name)
                                    rem:FireServer(true)
                                    rem:FireServer(1)
                                elseif rem:IsA("RemoteFunction") then
                                    rem:InvokeServer(obj)
                                    rem:InvokeServer(part)
                                    rem:InvokeServer(obj.Name)
                                end
                            end)
                        end

                        task.wait(0.12)
                    end
                end
            end)
            task.wait(0.15)
        else
            task.wait(0.4)
        end
    end
end)

--==============================================================--
--  2. 100% RELIABLE NEEDLE ESP / VISUALIZER
--==============================================================--
local activeESP = {}

local function clearESP()
    for _, obj in pairs(activeESP) do
        if obj.highlight then pcall(function() obj.highlight:Destroy() end) end
        if obj.billboard then pcall(function() obj.billboard:Destroy() end) end
    end
    table.clear(activeESP)
end

-- Refresh ESP loop
task.spawn(function()
    while true do
        if NeedleESPEnabled then
            pcall(function()
                local root = getRoot()
                local foundKeys = {}

                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not NeedleESPEnabled then break end
                    if isNeedle(obj) then
                        local part = getPartFromObj(obj)
                        if part and part.Parent and part:IsA("BasePart") then
                            local key = part:GetDebugId() or tostring(part:GetFullName())
                            foundKeys[key] = true

                            if not activeESP[key] then
                                -- Create Highlight
                                local hl = Instance.new("Highlight")
                                hl.Name = "NeedleESP_HL"
                                hl.FillColor = Color3.fromRGB(255, 215, 0)
                                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                                hl.FillTransparency = 0.25
                                hl.OutlineTransparency = 0
                                hl.Adornee = obj:IsA("Model") and obj or part
                                hl.Parent = ScreenGui

                                -- Create BillboardGui
                                local bb = Instance.new("BillboardGui")
                                bb.Name = "NeedleESP_BB"
                                bb.Size = UDim2.new(0, 140, 0, 32)
                                bb.AlwaysOnTop = true
                                bb.Adornee = part
                                bb.Parent = ScreenGui

                                local txt = Instance.new("TextLabel")
                                txt.Name = "DistLabel"
                                txt.Size = UDim2.new(1, 0, 1, 0)
                                txt.BackgroundTransparency = 1
                                txt.TextColor3 = Color3.fromRGB(255, 230, 80)
                                txt.TextStrokeTransparency = 0
                                txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                                txt.TextSize = 13
                                txt.Font = Enum.Font.SourceSansBold
                                txt.Parent = bb

                                activeESP[key] = {highlight = hl, billboard = bb, label = txt, part = part, name = obj.Name}
                            end

                            -- Update Distance & Text
                            if activeESP[key] and activeESP[key].label and root then
                                local dist = math.floor((part.Position - root.Position).Magnitude)
                                activeESP[key].label.Text = "🪡 " .. activeESP[key].name .. "\n[" .. tostring(dist) .. "m]"
                            end
                        end
                    end
                end

                -- Remove dead ESP entries
                for key, data in pairs(activeESP) do
                    if not foundKeys[key] or not data.part or not data.part.Parent then
                        if data.highlight then pcall(function() data.highlight:Destroy() end) end
                        if data.billboard then pcall(function() data.billboard:Destroy() end) end
                        activeESP[key] = nil
                    end
                end
            end)
            task.wait(0.25)
        else
            clearESP()
            task.wait(0.5)
        end
    end
end)

--==============================================================--
--  3. AUTO SEARCH / DIG HAYSTACK
--==============================================================--
task.spawn(function()
    while true do
        if AutoSearchHaystackEnabled then
            pcall(function()
                local root = getRoot()
                if not root then return end

                -- Trigger Tool & Clicks
                autoAttackAction()

                -- Find Haystacks / Search Piles
                local haystacks = {}
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not AutoSearchHaystackEnabled then break end
                    if isHaystack(obj) then
                        local part = getPartFromObj(obj)
                        if part and part:IsA("BasePart") then
                            table.insert(haystacks, {part = part, parent = obj})
                        end
                    end
                end

                -- Sort by closest
                local curPos = root.Position
                table.sort(haystacks, function(a, b)
                    return (a.part.Position - curPos).Magnitude < (b.part.Position - curPos).Magnitude
                end)

                -- Interact with nearby / all haystacks
                for i = 1, math.min(5, #haystacks) do
                    if not AutoSearchHaystackEnabled then break end
                    local item = haystacks[i]
                    if item and item.part and item.part.Parent then
                        safeTouch(item.part)

                        local prompt = item.part:FindFirstChildWhichIsA("ProximityPrompt", true) or item.parent:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if prompt then triggerPrompt(prompt) end

                        local click = item.part:FindFirstChildWhichIsA("ClickDetector", true) or item.parent:FindFirstChildWhichIsA("ClickDetector", true)
                        if click then safeClick(click) end
                    end
                end

                -- Fire Haystack / Dig Remotes
                local searchRemotes = findRemotes({
                    "search", "dig", "break", "hay", "pile", "interact", "hit", "damage", "cut", "rummage"
                })
                for _, rem in ipairs(searchRemotes) do
                    pcall(function()
                        if rem:IsA("RemoteEvent") then
                            rem:FireServer("Haystack")
                            rem:FireServer(1)
                            rem:FireServer(true)
                            rem:FireServer()
                        elseif rem:IsA("RemoteFunction") then
                            rem:InvokeServer("Haystack")
                            rem:InvokeServer(1)
                            rem:InvokeServer(true)
                            rem:InvokeServer()
                        end
                    end)
                end
            end)
            task.wait(0.06)
        else
            task.wait(0.3)
        end
    end
end)

--==============================================================--
--  4. MOVEMENT & UTILITY (Infinite Jump, Speed, Fly)
--==============================================================--
-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled then
        local hum = getHum()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Speed Boost Keeper (Heartbeat Bypass)
RunService.Heartbeat:Connect(function()
    if SpeedBoostEnabled then
        local hum = getHum()
        if hum and hum.WalkSpeed ~= BoostSpeed then
            hum.WalkSpeed = BoostSpeed
        end
    end
end)

-- Fly Controller
local bodyGyro, bodyVelocity
RunService.RenderStepped:Connect(function()
    if FlyEnabled then
        local root = getRoot()
        local hum = getHum()
        if root and hum then
            if not bodyGyro or not bodyGyro.Parent then
                bodyGyro = Instance.new("BodyGyro")
                bodyGyro.P = 9e4
                bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                bodyGyro.CFrame = root.CFrame
                bodyGyro.Parent = root
            end
            if not bodyVelocity or not bodyVelocity.Parent then
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                bodyVelocity.Parent = root
            end

            hum.PlatformStand = true
            bodyGyro.CFrame = Camera.CFrame

            local moveDir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + (Camera.CFrame.LookVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - (Camera.CFrame.LookVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - (Camera.CFrame.RightVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + (Camera.CFrame.RightVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDir = moveDir - Vector3.new(0, 1, 0)
            end

            if moveDir.Magnitude > 0 then
                bodyVelocity.Velocity = moveDir.Unit * FlySpeed
            else
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
        end
    else
        if bodyGyro then bodyGyro:Destroy(); bodyGyro = nil end
        if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
        local hum = getHum()
        if hum and hum.PlatformStand then
            hum.PlatformStand = false
        end
    end
end)

print("[ULTRA SCRIPT HUB] Search For The Needle v2.0 Loaded Successfully!")

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ULTRA SCRIPT HUB",
        Text = "Search For The Needle v2.0 (Active & Ready)!",
        Duration = 5
    })
end)
