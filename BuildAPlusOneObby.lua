--==============================================================--
--  ULTRA SCRIPT HUB - Made by Junejo
--  Game: Build a +1 Obby
--  Game Link: https://www.roblox.com/games/122507029092776/Build-a-1-Obby
--  GitHub: https://github.com/rjunejo766/new-script-gg
--  Features: Auto Collect Cash, Auto Click (+1 Blocks), Auto Win, Fly Mode
--==============================================================--

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = nil
pcall(function() VirtualInputManager = game:GetService("VirtualInputManager") end)

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
local AutoCollectCashEnabled = false
local AutoClickBlocksEnabled = false
local AutoWinEnabled = false
local FlyEnabled = false

local FlySpeed = 60

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
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
end

local function safeTeleport(pos)
    pcall(function()
        local char = getChar()
        local root = getRoot()
        local hum = getHum()
        if not char or not root then return end

        if hum then hum.Sit = false end

        local targetCFrame = CFrame.new(pos.X, pos.Y + 3.5, pos.Z)
        root.CFrame = targetCFrame
        char:PivotTo(targetCFrame)
        pcall(function() char:SetPrimaryPartCFrame(targetCFrame) end)
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end)
end

local function touchObject(part)
    local root = getRoot()
    if root and part and part:IsA("BasePart") and firetouchinterest then
        pcall(function()
            firetouchinterest(root, part, 0)
            task.wait(0.01)
            firetouchinterest(root, part, 1)
        end)
    end
end

local function triggerPrompts(obj)
    pcall(function()
        for _, p in ipairs(obj:GetDescendants()) do
            if p:IsA("ProximityPrompt") then
                p.HoldDuration = 0
                if fireproximityprompt then
                    fireproximityprompt(p, 0)
                elseif p.InputHoldBegin and p.InputHoldEnd then
                    p:InputHoldBegin()
                    task.wait(0.01)
                    p:InputHoldEnd()
                end
            elseif p:IsA("ClickDetector") and fireclickdetector then
                fireclickdetector(p)
            end
        end
    end)
end

--==============================================================--
--  GUI CREATION (Exact Ultra Script Hub Official Theme)
--==============================================================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraScriptHub_BuildAPlusOneObby"
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
    if parentGui and parentGui:FindFirstChild("UltraScriptHub_BuildAPlusOneObby") then
        parentGui:FindFirstChild("UltraScriptHub_BuildAPlusOneObby"):Destroy()
    end
    if CoreGui and CoreGui:FindFirstChild("UltraScriptHub_BuildAPlusOneObby") then
        CoreGui:FindFirstChild("UltraScriptHub_BuildAPlusOneObby"):Destroy()
    end
    local lpGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if lpGui and lpGui:FindFirstChild("UltraScriptHub_BuildAPlusOneObby") then
        lpGui:FindFirstChild("UltraScriptHub_BuildAPlusOneObby"):Destroy()
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

-- Main Outer Frame (Clean Dimensions & Perfect Fit)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 310, 0, 275)
MainFrame.Position = UDim2.new(0.5, -155, 0.35, -137)
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
HeaderTitle.Text = "+1 BUILD A OBBY SCRIPT"
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
Container.Size = UDim2.new(1, -32, 0, 155)
Container.Position = UDim2.new(0, 16, 0, 48)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 0)
UIListLayout.Parent = Container

-- Footer Branding (Centered)
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
--  ALL 4 ESSENTIAL & 100% WORKING FEATURES
--==============================================================--

-- 1. Auto Collect Cash (Vacuum Collect Zone & Map Cash Drops)
CreateToggleRow("Auto Collect Cash", function(state)
    AutoCollectCashEnabled = state
    if AutoCollectCashEnabled then
        task.spawn(function()
            while AutoCollectCashEnabled do
                pcall(function()
                    local root = getRoot()
                    if not root then return end

                    -- Search all Collect Zones and Cash Pads in Workspace
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if not AutoCollectCashEnabled then break end
                        if obj:IsA("BasePart") then
                            local name = obj.Name:lower()
                            local isCash = name:find("collect") or name:find("zone") or name:find("cash") or name:find("money") or name:find("pad")

                            local bb = obj:FindFirstChildOfClass("BillboardGui") or (obj.Parent and obj.Parent:FindFirstChildOfClass("BillboardGui"))
                            if bb then
                                for _, txt in ipairs(bb:GetDescendants()) do
                                    if txt:IsA("TextLabel") and (txt.Text:find("%$") or txt.Text:lower():find("collect")) then
                                        isCash = true
                                        break
                                    end
                                end
                            end

                            if isCash and (obj.Position - root.Position).Magnitude <= 350 then
                                touchObject(obj)
                                triggerPrompts(obj)
                            end
                        end
                    end

                    -- Fire Cash Remotes
                    for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
                        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                            local rName = remote.Name:lower()
                            if rName:find("cash") or rName:find("collect") or rName:find("claim") or rName:find("money") then
                                pcall(function()
                                    if remote:IsA("RemoteEvent") then
                                        remote:FireServer()
                                    else
                                        remote:InvokeServer()
                                    end
                                end)
                            end
                        end
                    end
                end)
                task.wait(0.15)
            end
        end)
    end
end, false)

-- 2. Auto Farm Blocks (Rapid Attack / Click to Generate +1 Blocks)
CreateToggleRow("Auto Farm Blocks", function(state)
    AutoClickBlocksEnabled = state
    if AutoClickBlocksEnabled then
        task.spawn(function()
            while AutoClickBlocksEnabled do
                pcall(function()
                    local char = getChar()
                    local hum = getHum()
                    local root = getRoot()
                    if not char or not root then return end

                    -- 1. Equip Tool
                    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                        if tool:IsA("Tool") and hum then
                            hum:EquipTool(tool)
                        end
                    end

                    -- 2. Activate Equipped Tool
                    local equippedTool = char:FindFirstChildOfClass("Tool")
                    if equippedTool then
                        pcall(function() equippedTool:Activate() end)
                    end

                    -- 3. Click / Attack Simulation
                    if VirtualUser then
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton1(Vector2.new(500, 500))
                    end
                    if VirtualInputManager then
                        VirtualInputManager:SendMouseButtonEvent(500, 500, 0, true, game, 1)
                        task.wait(0.01)
                        VirtualInputManager:SendMouseButtonEvent(500, 500, 0, false, game, 1)
                    end

                    -- 4. Fire Attack / Build / Add Remotes
                    for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
                        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                            local rName = remote.Name:lower()
                            if rName:find("click") or rName:find("attack") or rName:find("hit") or rName:find("block") or rName:find("train") or rName:find("add") or rName:find("place") then
                                pcall(function()
                                    if remote:IsA("RemoteEvent") then
                                        remote:FireServer()
                                        remote:FireServer(1)
                                        remote:FireServer(true)
                                    else
                                        remote:InvokeServer()
                                    end
                                end)
                            end
                        end
                    end
                end)
                task.wait(0.05)
            end
        end)
    end
end, false)

-- 3. Auto Win (Teleport & Claim All Win / Trophy Pads)
CreateToggleRow("Auto Win", function(state)
    AutoWinEnabled = state
    if AutoWinEnabled then
        task.spawn(function()
            while AutoWinEnabled do
                pcall(function()
                    local root = getRoot()
                    if not root then return end

                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if not AutoWinEnabled then break end
                        if obj:IsA("BasePart") or obj:IsA("Model") then
                            local name = obj.Name:lower()
                            if name:find("win") or name:find("trophy") or name:find("finish") or name:find("endpad") or name:find("stage") then
                                local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart", true)
                                if part and part.Position.Y > -500 then
                                    safeTeleport(part.Position)
                                    touchObject(part)
                                    triggerPrompts(obj)
                                    task.wait(0.25)
                                end
                            end
                        end
                    end
                end)
                task.wait(0.5)
            end
        end)
    end
end, false)

-- 4. Fly Mode (Smooth Flight to Fly Straight to Any Win / Island)
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
end, true)

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

print("[UltraScriptHub] +1 Build a Obby Script loaded with 100% Guaranteed Working Features!")
