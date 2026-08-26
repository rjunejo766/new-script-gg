--==============================================================--
--  ULTRA SCRIPT HUB - Made by Junejo
--  Game: Fish For Junk
--  Game Link: https://www.roblox.com/games/132010220154773/Fish-For-Junk
--  Version: 1.0 (Cast 100%, Auto Upgrade, Sell All)
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

-- Feature Toggle States (Exact 3 Features)
local Cast100Enabled = false
local AutoUpgradeEnabled = false
local SellAllEnabled = false

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

-- Universal Touch Simulation
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

-- Auto Equip Fishing Rod
local function equipRod()
    local char = LocalPlayer.Character
    if not char then return nil end

    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then
        local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        if backpack then
            -- Prefer tools with rod / fish in name or first tool
            for _, t in ipairs(backpack:GetChildren()) do
                if t:IsA("Tool") then
                    t.Parent = char
                    tool = t
                    break
                end
            end
        end
    end
    return tool
end

--==============================================================--
--  GUI CREATION (Pixel-Perfect ULTRA SCRIPT HUB Design)
--==============================================================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraScriptHub_FishForJunk"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999

-- Clean previous instances
pcall(function()
    if CoreGui and CoreGui:FindFirstChild("UltraScriptHub_FishForJunk") then
        CoreGui:FindFirstChild("UltraScriptHub_FishForJunk"):Destroy()
    end
    local lpGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if lpGui and lpGui:FindFirstChild("UltraScriptHub_FishForJunk") then
        lpGui:FindFirstChild("UltraScriptHub_FishForJunk"):Destroy()
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
MainFrame.Size = UDim2.new(0, 320, 0, 245)
MainFrame.Position = UDim2.new(0.5, -160, 0.35, -122)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Header Title
local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -50, 0, 35)
HeaderTitle.Position = UDim2.new(0, 16, 0, 10)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "FISH FOR JUNK"
HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitle.TextSize = 14
HeaderTitle.Font = Enum.Font.SourceSansBold
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.Parent = MainFrame

-- Close Button (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -34, 0, 10)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Content Container
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -32, 0, 125)
Container.Position = UDim2.new(0, 16, 0, 50)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 7)
UIListLayout.Parent = Container

-- Footer Titles
local FooterTitle = Instance.new("TextLabel")
FooterTitle.Size = UDim2.new(1, 0, 0, 22)
FooterTitle.Position = UDim2.new(0, 0, 1, -44)
FooterTitle.BackgroundTransparency = 1
FooterTitle.Text = "ULTRA SCRIPT HUB"
FooterTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
FooterTitle.TextSize = 17
FooterTitle.Font = Enum.Font.SourceSansBold
FooterTitle.Parent = MainFrame

local FooterSub = Instance.new("TextLabel")
FooterSub.Size = UDim2.new(1, 0, 0, 16)
FooterSub.Position = UDim2.new(0, 0, 1, -22)
FooterSub.BackgroundTransparency = 1
FooterSub.Text = "Made by Junejo"
FooterSub.TextColor3 = Color3.fromRGB(150, 150, 150)
FooterSub.TextSize = 13
FooterSub.Font = Enum.Font.SourceSans
FooterSub.Parent = MainFrame

-- Checkbox Row Generator
local function CreateToggleRow(name, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 28)
    Row.BackgroundTransparency = 1
    Row.Parent = Container

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -35, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 220, 225)
    Label.TextSize = 14
    Label.Font = Enum.Font.SourceSansBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local Checkbox = Instance.new("TextButton")
    Checkbox.Size = UDim2.new(0, 22, 0, 22)
    Checkbox.Position = UDim2.new(1, -24, 0.5, -11)
    Checkbox.BackgroundColor3 = Color3.fromRGB(25, 27, 35)
    Checkbox.BorderColor3 = Color3.fromRGB(45, 48, 60)
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

--==============================================================--
--  ADD EXACT 3 REQUESTED FEATURES TO GUI
--==============================================================--
CreateToggleRow("Cast 100%", function(state)
    Cast100Enabled = state
end)

CreateToggleRow("Auto Upgrade", function(state)
    AutoUpgradeEnabled = state
end)

CreateToggleRow("Sell All", function(state)
    SellAllEnabled = state
end)

--==============================================================--
--  1. CAST 100% (Auto Equip, 100% Perfect Power Cast & Auto Reel)
--==============================================================--
task.spawn(function()
    while true do
        if Cast100Enabled then
            pcall(function()
                local char = LocalPlayer.Character
                local root = getRoot()
                if not char or not root then return end

                -- A. Auto equip fishing rod
                local tool = equipRod()

                -- B. Activate rod tool
                if tool then
                    pcall(function() tool:Activate() end)

                    for _, sub in ipairs(tool:GetDescendants()) do
                        if sub:IsA("RemoteEvent") then
                            pcall(function()
                                sub:FireServer()
                                sub:FireServer(100)
                                sub:FireServer(1)
                                sub:FireServer(true)
                                sub:FireServer(Vector3.new(0, 0, 0))
                            end)
                        elseif sub:IsA("RemoteFunction") then
                            pcall(function()
                                sub:InvokeServer(100)
                                sub:InvokeServer(1)
                                sub:InvokeServer(true)
                            end)
                        end
                    end
                end

                -- C. Fire Cast, Fish & Reel Remotes with 100% Perfect arguments
                local fishRemotes = findRemotes({
                    "cast", "fish", "reel", "catch", "hook", "throw", "pull", 
                    "bobber", "castrod", "reelrod", "perfectcast", "power", "minigame", "junk"
                })
                for _, remote in ipairs(fishRemotes) do
                    pcall(function()
                        if remote:IsA("RemoteEvent") then
                            remote:FireServer()
                            remote:FireServer(100) -- 100% perfect cast power
                            remote:FireServer(1)
                            remote:FireServer(true)
                            remote:FireServer("Perfect")
                            remote:FireServer("Cast")
                            remote:FireServer("Reel")
                        elseif remote:IsA("RemoteFunction") then
                            remote:InvokeServer(100)
                            remote:InvokeServer(1)
                            remote:InvokeServer(true)
                            remote:InvokeServer("Perfect")
                        end
                    end)
                end

                -- D. Virtual Clicks for Rod Casting & Reeling
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

                -- E. Click Cast/Reel buttons in PlayerGui if present
                local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                if playerGui then
                    for _, btn in ipairs(playerGui:GetDescendants()) do
                        if btn:IsA("GuiButton") and btn.Visible then
                            local name = btn.Name:lower()
                            local text = (btn:IsA("TextButton") and btn.Text:lower()) or ""
                            if name:find("cast") or text:find("cast") or name:find("reel") or text:find("reel") or 
                               name:find("pull") or text:find("pull") or name:find("fish") or text:find("fish") then
                                clickGuiButton(btn)
                            end
                        end
                    end
                end
            end)
            task.wait(0.06)
        else
            task.wait(0.3)
        end
    end
end)

--==============================================================--
--  2. AUTO UPGRADE (Buy Best Rods, Luck, Speed & Capacity)
--==============================================================--
task.spawn(function()
    while true do
        if AutoUpgradeEnabled then
            pcall(function()
                local root = getRoot()

                -- A. Click Upgrade / Buy Buttons in PlayerGui
                local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                if playerGui then
                    for _, btn in ipairs(playerGui:GetDescendants()) do
                        if btn:IsA("GuiButton") and btn.Visible then
                            local name = btn.Name:lower()
                            local text = (btn:IsA("TextButton") and btn.Text:lower()) or ""
                            if (name:find("upgrade") or text:find("upgrade") or name:find("buyrod") or text:find("buy") or 
                                name:find("luck") or text:find("luck") or name:find("speed") or text:find("capacity")) and not name:find("robux") then
                                clickGuiButton(btn)
                            end
                        end
                    end
                end

                -- B. Scan and Touch Upgrade Pads in Workspace
                if root then
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if not AutoUpgradeEnabled then break end

                        if obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
                            for _, txt in ipairs(obj:GetDescendants()) do
                                if txt:IsA("TextLabel") and txt.Text ~= "" then
                                    local textLower = txt.Text:lower()
                                    if textLower:find("upgrade") or textLower:find("buy") or textLower:find("rod") or 
                                       textLower:find("luck") or textLower:find("cost") or string.match(txt.Text, "%d+") then
                                        local part = obj.Adornee or obj.Parent
                                        if part and part:IsA("BasePart") then
                                            safeTouch(part)
                                        end
                                    end
                                end
                            end
                        elseif obj:IsA("BasePart") then
                            local n = obj.Name:lower()
                            local p = obj.Parent and obj.Parent.Name:lower() or ""
                            if n:find("upgrade") or n:find("buy") or n:find("rod") or n:find("pad") or 
                               p:find("upgrade") or p:find("shop") or p:find("merchant") then
                                safeTouch(obj)
                            end
                        elseif obj:IsA("ProximityPrompt") then
                            local act = (obj.ActionText .. " " .. obj.ObjectText):lower()
                            if act:find("upgrade") or act:find("buy") or act:find("purchase") or act:find("rod") then
                                triggerPrompt(obj)
                            end
                        elseif obj:IsA("ClickDetector") then
                            safeClick(obj)
                        end
                    end
                end

                -- C. Fire Upgrade Remotes
                local upgradeRemotes = findRemotes({
                    "upgrade", "buyrod", "purchaserod", "upgradeluck", "upgraderod", 
                    "buyupgrade", "purchase", "buyspeed", "buycapacity"
                })
                for _, remote in ipairs(upgradeRemotes) do
                    pcall(function()
                        if remote:IsA("RemoteEvent") then
                            remote:FireServer()
                            remote:FireServer(1)
                            remote:FireServer(true)
                            remote:FireServer("Rod")
                            remote:FireServer("Luck")
                        elseif remote:IsA("RemoteFunction") then
                            remote:InvokeServer()
                            remote:InvokeServer(1)
                            remote:InvokeServer(true)
                        end
                    end)
                end
            end)
            task.wait(0.4)
        else
            task.wait(0.5)
        end
    end
end)

--==============================================================--
--  3. SELL ALL (Sell Junk, Cash Out & Clear Inventory)
--==============================================================--
task.spawn(function()
    while true do
        if SellAllEnabled then
            pcall(function()
                local root = getRoot()

                -- A. Click Sell / Sell All Buttons in PlayerGui
                local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                if playerGui then
                    for _, btn in ipairs(playerGui:GetDescendants()) do
                        if btn:IsA("GuiButton") and btn.Visible then
                            local name = btn.Name:lower()
                            local text = (btn:IsA("TextButton") and btn.Text:lower()) or ""
                            if name:find("sell") or text:find("sell") or name:find("cashout") or text:find("cashout") then
                                clickGuiButton(btn)
                            end
                        end
                    end
                end

                -- B. Touch Sell Pads & Sell Circles in Workspace
                if root then
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if not SellAllEnabled then break end

                        if obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
                            for _, txt in ipairs(obj:GetDescendants()) do
                                if txt:IsA("TextLabel") and txt.Text ~= "" then
                                    if txt.Text:lower():find("sell") then
                                        local part = obj.Adornee or obj.Parent
                                        if part and part:IsA("BasePart") then
                                            safeTouch(part)
                                        end
                                    end
                                end
                            end
                        elseif obj:IsA("BasePart") then
                            local n = obj.Name:lower()
                            local p = obj.Parent and obj.Parent.Name:lower() or ""
                            if n:find("sell") or p:find("sell") or n:find("junkbuyer") or p:find("junkbuyer") then
                                safeTouch(obj)
                            end
                        elseif obj:IsA("ProximityPrompt") then
                            local act = (obj.ActionText .. " " .. obj.ObjectText):lower()
                            if act:find("sell") or act:find("junk") then
                                triggerPrompt(obj)
                            end
                        elseif obj:IsA("ClickDetector") then
                            safeClick(obj)
                        end
                    end
                end

                -- C. Fire Sell Remotes
                local sellRemotes = findRemotes({
                    "sell", "sellall", "selljunk", "sellfish", "claimsell", "cashout", "merchantsell"
                })
                for _, remote in ipairs(sellRemotes) do
                    pcall(function()
                        if remote:IsA("RemoteEvent") then
                            remote:FireServer()
                            remote:FireServer(1)
                            remote:FireServer(true)
                            remote:FireServer("All")
                            remote:FireServer("Sell")
                        elseif remote:IsA("RemoteFunction") then
                            remote:InvokeServer()
                            remote:InvokeServer(1)
                            remote:InvokeServer(true)
                            remote:InvokeServer("All")
                        end
                    end)
                end
            end)
            task.wait(0.3)
        else
            task.wait(0.5)
        end
    end
end)

print("[ULTRA SCRIPT HUB] Fish For Junk Loaded Successfully!")

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ULTRA SCRIPT HUB",
        Text = "Fish For Junk Loaded!",
        Duration = 5
    })
end)
