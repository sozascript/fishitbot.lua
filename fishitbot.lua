-- ==============================================
-- FISH IT! ULTIMATE BOT v3.0
-- WITH CUSTOM BYPASS DELAYS
-- GitHub: https://github.com/sozascript/fishitbot.lua
-- ==============================================

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- ===== ADVANCED CONFIGURATION =====
local Config = {
    -- Main Features
    AutoFish = true,
    AutoSell = true,
    AutoRebirth = false,
    
    -- Player Mods
    WalkSpeed = 50,
    JumpPower = 75,
    NoClip = true,
    
    -- Bypass Delays (BISA DIATUR SENDIRI! 😈)
    FishingDelay = 3,      -- Delay antar fishing (detik)
    CastDelay = 0.5,       -- Delay setelah cast
    ReelDelay = 2,         -- Delay sebelum reel
    CompleteDelay = 1,     -- Delay setelah complete
    SellDelay = 5,         -- Delay antar sell
    
    -- Teleport
    TeleportToBestSpot = true,
    
    -- UI
    UIPosition = UDim2.new(0.8, 0, 0.1, 0),
    
    Version = "3.0",
    Author = "Nesia Darknet"
}

-- ===== VARIABLES =====
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- ===== ADVANCED UI =====
local function CreateAdvancedUI()
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local Status = Instance.new("TextLabel")
    
    -- Main Frame
    ScreenGui.Name = "FishItBotUIv3"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = Config.UIPosition
    MainFrame.Size = UDim2.new(0, 280, 0, 400)
    MainFrame.Active = true
    MainFrame.Draggable = true
    
    -- Title
    Title.Name = "Title"
    Title.Parent = MainFrame
    Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Title.BorderSizePixel = 0
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "🎣 FISH IT ULTIMATE v" .. Config.Version
    Title.TextColor3 = Color3.fromRGB(255, 50, 50)
    Title.TextSize = 16
    
    -- Status
    Status.Name = "Status"
    Status.Parent = MainFrame
    Status.BackgroundTransparency = 1
    Status.Position = UDim2.new(0, 10, 0.1, 0)
    Status.Size = UDim2.new(1, -20, 0, 25)
    Status.Font = Enum.Font.Gotham
    Status.Text = "🟢 STATUS: READY"
    Status.TextColor3 = Color3.fromRGB(100, 255, 100)
    Status.TextSize = 13
    Status.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Delay Controls Section
    local DelaySectionTitle = Instance.new("TextLabel")
    DelaySectionTitle.Name = "DelaySectionTitle"
    DelaySectionTitle.Parent = MainFrame
    DelaySectionTitle.BackgroundTransparency = 1
    DelaySectionTitle.Position = UDim2.new(0, 10, 0.18, 0)
    DelaySectionTitle.Size = UDim2.new(1, -20, 0, 20)
    DelaySectionTitle.Font = Enum.Font.GothamBold
    DelaySectionTitle.Text = "⚡ BYPASS DELAYS:"
    DelaySectionTitle.TextColor3 = Color3.fromRGB(255, 200, 50)
    DelaySectionTitle.TextSize = 12
    DelaySectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Delay sliders
    local delays = {
        {name = "FishingDelay", text = "Fishing Delay: " .. Config.FishingDelay .. "s", ypos = 0.23, min = 1, max = 10, default = 3},
        {name = "CastDelay", text = "Cast Delay: " .. Config.CastDelay .. "s", ypos = 0.30, min = 0.1, max = 3, default = 0.5},
        {name = "ReelDelay", text = "Reel Delay: " .. Config.ReelDelay .. "s", ypos = 0.37, min = 0.5, max = 5, default = 2},
        {name = "CompleteDelay", text = "Complete Delay: " .. Config.CompleteDelay .. "s", ypos = 0.44, min = 0.1, max = 3, default = 1},
        {name = "SellDelay", text = "Sell Delay: " .. Config.SellDelay .. "s", ypos = 0.51, min = 1, max = 30, default = 5}
    }
    
    local delayButtons = {}
    
    for _, delayInfo in ipairs(delays) do
        local btn = Instance.new("TextButton")
        btn.Name = delayInfo.name
        btn.Parent = MainFrame
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        btn.BorderSizePixel = 0
        btn.Position = UDim2.new(0.05, 0, delayInfo.ypos, 0)
        btn.Size = UDim2.new(0.9, 0, 0, 30)
        btn.Font = Enum.Font.Gotham
        btn.Text = delayInfo.text
        btn.TextColor3 = Color3.fromRGB(200, 200, 255)
        btn.TextSize = 12
        
        delayButtons[delayInfo.name] = btn
    end
    
    -- Control Buttons
    local buttons = {
        {name = "FishToggle", text = "▶️ START FISHING", ypos = 0.60, color = Color3.fromRGB(20, 60, 20)},
        {name = "SellToggle", text = "💰 AUTO SELL: ON", ypos = 0.67, color = Color3.fromRGB(40, 40, 40)},
        {name = "TeleportBtn", text = "🗺️ TELEPORT TO SPOT", ypos = 0.74, color = Color3.fromRGB(60, 40, 20)},
        {name = "SpeedBtn", text = "⚡ SPEED: " .. Config.WalkSpeed, ypos = 0.81, color = Color3.fromRGB(40, 40, 40)},
        {name = "CloseBtn", text = "❌ CLOSE BOT", ypos = 0.90, color = Color3.fromRGB(60, 20, 20)}
    }
    
    local buttonInstances = {}
    
    for _, btnInfo in ipairs(buttons) do
        local btn = Instance.new("TextButton")
        btn.Name = btnInfo.name
        btn.Parent = MainFrame
        btn.BackgroundColor3 = btnInfo.color
        btn.BorderSizePixel = 0
        btn.Position = UDim2.new(0.05, 0, btnInfo.ypos, 0)
        btn.Size = UDim2.new(0.9, 0, 0, 30)
        btn.Font = Enum.Font.Gotham
        btn.Text = btnInfo.text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 13
        
        buttonInstances[btnInfo.name] = btn
    end
    
    return ScreenGui, MainFrame, Status, buttonInstances, delayButtons
end

-- ===== ADVANCED FISHING SYSTEM =====
local function FindFishingEvents()
    local events = {
        Cast = {},
        Reel = {},
        Sell = {},
        Rebirth = {},
        Other = {}
    }
    
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local name = obj.Name:lower()
            
            if name:find("cast") or name:find("throw") then
                table.insert(events.Cast, obj)
            elseif name:find("reel") or name:find("catch") or name:find("pull") then
                table.insert(events.Reel, obj)
            elseif name:find("sell") or name:find("exchange") or name:find("money") then
                table.insert(events.Sell, obj)
            elseif name:find("rebirth") or name:find("prestige") then
                table.insert(events.Rebirth, obj)
            elseif name:find("fish") then
                table.insert(events.Other, obj)
            end
        end
    end
    
    return events
end

-- ===== BYPASS FISHING WITH CUSTOM DELAYS =====
local function AdvancedAutoFishing(events, statusLabel)
    local cycle = 0
    
    while Config.AutoFish do
        cycle = cycle + 1
        statusLabel.Text = "🎣 CYCLE #" .. cycle
        
        -- PHASE 1: CAST
        if #events.Cast > 0 then
            statusLabel.Text = "🎣 CASTING..."
            for _, event in pairs(events.Cast) do
                pcall(function()
                    event:FireServer()
                end)
            end
            task.wait(Config.CastDelay) -- CAST DELAY (bisa diatur!)
        end
        
        -- PHASE 2: WAIT FOR FISH
        statusLabel.Text = "🎣 WAITING FOR FISH..."
        task.wait(Config.FishingDelay) -- FISHING DELAY (bisa diatur!)
        
        -- PHASE 3: REEL
        if #events.Reel > 0 then
            statusLabel.Text = "🎣 REELING..."
            task.wait(Config.ReelDelay) -- REEL DELAY (bisa diatur!)
            
            for _, event in pairs(events.Reel) do
                pcall(function()
                    event:FireServer()
                end)
            end
        end
        
        -- PHASE 4: COMPLETE
        statusLabel.Text = "🎣 COMPLETING..."
        task.wait(Config.CompleteDelay) -- COMPLETE DELAY (bisa diatur!)
        
        -- Try any other fishing events
        for _, event in pairs(events.Other) do
            pcall(function()
                event:FireServer()
            end)
        end
        
        -- PHASE 5: AUTO SELL
        if Config.AutoSell and cycle % 3 == 0 then -- Sell every 3 cycles
            statusLabel.Text = "💰 SELLING FISH..."
            task.wait(0.5)
            
            for _, event in pairs(events.Sell) do
                pcall(function()
                    event:FireServer()
                end)
            end
            
            task.wait(Config.SellDelay) -- SELL DELAY (bisa diatur!)
        end
        
        -- PHASE 6: AUTO REBIRTH
        if Config.AutoRebirth and cycle % 50 == 0 then -- Rebirth every 50 cycles
            statusLabel.Text = "🌟 AUTO REBIRTH..."
            for _, event in pairs(events.Rebirth) do
                pcall(function()
                    event:FireServer()
                end)
            end
        end
        
        statusLabel.Text = "🟢 READY | Cycle: " .. cycle
        task.wait(1)
    end
end

-- ===== TELEPORT FUNCTION =====
local function TeleportToBestFishingSpot()
    local character = Player.Character
    if not character then return false end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    
    -- Priority spots
    local spotPriority = {
        "BestFishingSpot",
        "FishingSpot",
        "FishArea",
        "GoldenSpot",
        "Water",
        "Ocean",
        "Lake",
        "River"
    }
    
    for _, spotName in pairs(spotPriority) do
        local spot = workspace:FindFirstChild(spotName)
        if spot then
            humanoidRootPart.CFrame = spot.CFrame + Vector3.new(0, 5, 0)
            return true
        end
    end
    
    -- Find any water
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("Part") and part.Material == Enum.Material.Water then
            humanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 10, 0)
            return true
        end
    end
    
    return false
end

-- ===== DELAY ADJUSTMENT FUNCTIONS =====
local function AdjustDelay(delayName, increase)
    local current = Config[delayName]
    
    if increase then
        Config[delayName] = math.min(current + 0.5, 30) -- Max 30 seconds
    else
        Config[delayName] = math.max(current - 0.5, 0.1) -- Min 0.1 seconds
    end
    
    return Config[delayName]
end

-- ===== MAIN EXECUTION =====
local function Main()
    -- Wait for character
    repeat task.wait() until Player.Character
    local character = Player.Character
    character:WaitForChild("HumanoidRootPart")
    
    -- Create advanced UI
    local ui, frame, statusLabel, buttons, delayButtons = CreateAdvancedUI()
    
    -- Find fishing events
    local fishingEvents = FindFishingEvents()
    print("⚡ Found fishing events:")
    print("   Cast: " .. #fishingEvents.Cast)
    print("   Reel: " .. #fishingEvents.Reel)
    print("   Sell: " .. #fishingEvents.Sell)
    print("   Other: " .. #fishingEvents.Other)
    
    -- Setup DELAY button functions
    for delayName, btn in pairs(delayButtons) do
        btn.MouseButton1Click:Connect(function()
            -- Left click: increase
            Config[delayName] = AdjustDelay(delayName, true)
            btn.Text = delayName:gsub("Delay", " Delay: ") .. Config[delayName] .. "s"
            statusLabel.Text = "⚡ " .. delayName .. ": " .. Config[delayName] .. "s"
        end)
        
        btn.MouseButton2Click:Connect(function()
            -- Right click: decrease
            Config[delayName] = AdjustDelay(delayName, false)
            btn.Text = delayName:gsub("Delay", " Delay: ") .. Config[delayName] .. "s"
            statusLabel.Text = "⚡ " .. delayName .. ": " .. Config[delayName] .. "s"
        end)
    end
    
    -- Setup CONTROL button functions
    local fishingThread = nil
    
    buttons.FishToggle.MouseButton1Click:Connect(function()
        Config.AutoFish = not Config.AutoFish
        
        if Config.AutoFish then
            buttons.FishToggle.Text = "⏸️ STOP FISHING"
            buttons.FishToggle.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
            statusLabel.Text = "🚀 STARTING FISHING..."
            
            -- Start fishing thread
            fishingThread = task.spawn(function()
                AdvancedAutoFishing(fishingEvents, statusLabel)
            end)
        else
            buttons.FishToggle.Text = "▶️ START FISHING"
            buttons.FishToggle.BackgroundColor3 = Color3.fromRGB(20, 60, 20)
            statusLabel.Text = "⏸️ FISHING STOPPED"
            
            -- Stop fishing thread
            if fishingThread then
                task.cancel(fishingThread)
                fishingThread = nil
            end
        end
    end)
    
    buttons.SellToggle.MouseButton1Click:Connect(function()
        Config.AutoSell = not Config.AutoSell
        buttons.SellToggle.Text = Config.AutoSell and "💰 AUTO SELL: ON" or "💰 AUTO SELL: OFF"
        buttons.SellToggle.BackgroundColor3 = Config.AutoSell and Color3.fromRGB(20, 60, 20) or Color3.fromRGB(60, 20, 20)
    end)
    
    buttons.TeleportBtn.MouseButton1Click:Connect(function()
        if TeleportToBestFishingSpot() then
            statusLabel.Text = "🗺️ TELEPORTED TO SPOT!"
        else
            statusLabel.Text = "❌ NO FISHING SPOT FOUND"
        end
    end)
    
    buttons.SpeedBtn.MouseButton1Click:Connect(function()
        Config.WalkSpeed = Config.WalkSpeed + 25
        if Config.WalkSpeed > 200 then Config.WalkSpeed = 25 end
        character.Humanoid.WalkSpeed = Config.WalkSpeed
        character.Humanoid.JumpPower = Config.WalkSpeed + 25
        buttons.SpeedBtn.Text = "⚡ SPEED: " .. Config.WalkSpeed
    end)
    
    buttons.CloseBtn.MouseButton1Click:Connect(function()
        Config.AutoFish = false
        Config.AutoSell = false
        if fishingThread then
            task.cancel(fishingThread)
        end
        ui:Destroy()
    end)
    
    -- Apply player modifications
    character.Humanoid.WalkSpeed = Config.WalkSpeed
    character.Humanoid.JumpPower = Config.JumpPower
    
    -- No-clip
    if Config.NoClip then
        RunService.Stepped:Connect(function()
            if character and character:FindFirstChild("Humanoid") then
                pcall(function()
                    character.Humanoid:ChangeState(11)
                end)
            end
        end)
    end
    
    -- Anti-AFK
    Player.Idled:Connect(function()
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end)
    
    -- Auto-start
    if Config.AutoFish then
        task.wait(1)
        buttons.FishToggle:Click()
    end
    
    -- Auto teleport
    if Config.TeleportToBestSpot then
        task.wait(2)
        TeleportToBestFishingSpot()
    end
    
    print("==========================================")
    print("🎣 FISH IT ULTIMATE BOT v" .. Config.Version)
    print("⚡ BYPASS DELAYS ENABLED!")
    print("   Fishing Delay: " .. Config.FishingDelay .. "s")
    print("   Cast Delay: " .. Config.CastDelay .. "s")
    print("   Reel Delay: " .. Config.ReelDelay .. "s")
    print("   Complete Delay: " .. Config.CompleteDelay .. "s")
    print("🔥 by " .. Config.Author)
    print("==========================================")
end

-- Start bot with error handling
local success, err = pcall(Main)
if not success then
    warn("❌ Error:", err)
    
    -- Ultra simple fallback
    task.spawn(function()
        while true do
            task.wait(Config.FishingDelay or 3)
            pcall(function()
                for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
                    if obj:IsA("RemoteEvent") then
                        obj:FireServer()
                    end
                end
            end)
        end
    end)
end

return {
    Version = Config.Version,
    Config = Config,
    Message = "Fish It Ultimate Bot - Ready to dominate! 😈"
}
