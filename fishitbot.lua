-- Fish It! Auto Bot v2.0 by Nesia Darknet 😈
-- GitHub: https://raw.githubusercontent.com/username/repository/main/fishitbot.lua

-- Anti-detection
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Configurations
getgenv().NesiaConfig = {
    AutoFish = true,
    AutoSell = true,
    WalkSpeed = 50,
    JumpPower = 75,
    TeleportToSpot = true
}

-- Wait for character
repeat task.wait() until Player.Character
local Character = Player.Character
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Create Simple UI
local function CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local Status = Instance.new("TextLabel")
    local ToggleFishBtn = Instance.new("TextButton")
    local ToggleSellBtn = Instance.new("TextButton")
    local TeleportBtn = Instance.new("TextButton")
    local SpeedBtn = Instance.new("TextButton")
    local CloseBtn = Instance.new("TextButton")

    ScreenGui.Name = "NesiaDarknetFishBot"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
    MainFrame.Size = UDim2.new(0, 250, 0, 300)
    MainFrame.Active = true
    MainFrame.Draggable = true

    Title.Name = "Title"
    Title.Parent = MainFrame
    Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Title.BorderSizePixel = 0
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "FISH IT BOT 😈"
    Title.TextColor3 = Color3.fromRGB(255, 50, 50)
    Title.TextSize = 18

    Status.Name = "Status"
    Status.Parent = MainFrame
    Status.BackgroundTransparency = 1
    Status.Position = UDim2.new(0, 0, 0.15, 0)
    Status.Size = UDim2.new(1, 0, 0, 30)
    Status.Font = Enum.Font.Gotham
    Status.Text = "Status: Ready 🟢"
    Status.TextColor3 = Color3.fromRGB(100, 255, 100)
    Status.TextSize = 14

    -- Buttons
    local buttonY = 0.25
    local buttonHeight = 0.08
    
    local buttons = {
        {
            name = "ToggleFishBtn",
            text = "Auto Fish: ON 🎣",
            func = function()
                getgenv().NesiaConfig.AutoFish = not getgenv().NesiaConfig.AutoFish
                ToggleFishBtn.Text = "Auto Fish: " .. (getgenv().NesiaConfig.AutoFish and "ON 🎣" or "OFF ❌")
            end
        },
        {
            name = "ToggleSellBtn",
            text = "Auto Sell: ON 💰",
            func = function()
                getgenv().NesiaConfig.AutoSell = not getgenv().NesiaConfig.AutoSell
                ToggleSellBtn.Text = "Auto Sell: " .. (getgenv().NesiaConfig.AutoSell and "ON 💰" or "OFF ❌")
            end
        },
        {
            name = "TeleportBtn",
            text = "Teleport to Spot 🗺️",
            func = function()
                -- Find fishing spot
                local spots = {"FishingSpot", "Water", "Ocean", "Lake", "River", "FishArea"}
                for _, spotName in pairs(spots) do
                    local spot = workspace:FindFirstChild(spotName)
                    if spot then
                        HumanoidRootPart.CFrame = spot.CFrame + Vector3.new(0, 5, 0)
                        Status.Text = "Teleported! 🗺️"
                        break
                    end
                end
            end
        },
        {
            name = "SpeedBtn",
            text = "Speed: " .. getgenv().NesiaConfig.WalkSpeed .. " 🏃",
            func = function()
                getgenv().NesiaConfig.WalkSpeed = getgenv().NesiaConfig.WalkSpeed + 25
                if getgenv().NesiaConfig.WalkSpeed > 150 then
                    getgenv().NesiaConfig.WalkSpeed = 25
                end
                Character.Humanoid.WalkSpeed = getgenv().NesiaConfig.WalkSpeed
                SpeedBtn.Text = "Speed: " .. getgenv().NesiaConfig.WalkSpeed .. " 🏃"
            end
        },
        {
            name = "CloseBtn",
            text = "Destroy UI ❌",
            func = function()
                ScreenGui:Destroy()
            end
        }
    }

    for i, btnInfo in ipairs(buttons) do
        local btn = Instance.new("TextButton")
        btn.Name = btnInfo.name
        btn.Parent = MainFrame
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.BorderSizePixel = 0
        btn.Position = UDim2.new(0.1, 0, buttonY + (i-1)*0.15, 0)
        btn.Size = UDim2.new(0.8, 0, 0, 35)
        btn.Font = Enum.Font.Gotham
        btn.Text = btnInfo.text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        
        btn.MouseButton1Click:Connect(btnInfo.func)
        
        if btnInfo.name == "ToggleFishBtn" then ToggleFishBtn = btn end
        if btnInfo.name == "ToggleSellBtn" then ToggleSellBtn = btn end
        if btnInfo.name == "SpeedBtn" then SpeedBtn = btn end
        if btnInfo.name == "CloseBtn" then CloseBtn = btn end
    end

    return ScreenGui, Status
end

-- Main Fishing Function
local function StartFishingBot(StatusLabel)
    while true do
        if not getgenv().NesiaConfig.AutoFish then
            task.wait(1)
            StatusLabel.Text = "Status: Paused ⏸️"
            continue
        end
        
        StatusLabel.Text = "Status: Fishing... 🎣"
        
        -- Try to find and use fishing events
        local fired = false
        for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                local name = obj.Name:lower()
                if name:find("fish") or name:find("cast") or name:find("reel") or name:find("catch") then
                    pcall(function()
                        obj:FireServer()
                        fired = true
                        StatusLabel.Text = "Fired: " .. obj.Name .. " ⚡"
                    end)
                    task.wait(0.5)
                end
            end
        end
        
        -- Auto Sell
        if getgenv().NesiaConfig.AutoSell and fired then
            for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
                if obj:IsA("RemoteEvent") and obj.Name:lower():find("sell") then
                    pcall(function()
                        obj:FireServer()
                        StatusLabel.Text = "Selling fish... 💰"
                    end)
                end
            end
        end
        
        -- Equip fishing rod automatically
        pcall(function()
            local backpack = Player:FindFirstChild("Backpack")
            if backpack then
                for _, item in pairs(backpack:GetChildren()) do
                    if item:IsA("Tool") and (item.Name:find("Rod") or item.Name:find("Fishing")) then
                        item.Parent = Character
                    end
                end
            end
        end)
        
        task.wait(2)
    end
end

-- Initialize
local UI, StatusLabel = CreateUI()

-- Apply speed
Character.Humanoid.WalkSpeed = getgenv().NesiaConfig.WalkSpeed
Character.Humanoid.JumpPower = getgenv().NesiaConfig.JumpPower

-- No-clip
game:GetService("RunService").Stepped:Connect(function()
    pcall(function()
        if Character and Character:FindFirstChild("Humanoid") then
            Character.Humanoid:ChangeState(11)
        end
    end)
end)

-- Anti-AFK
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Start fishing bot
coroutine.wrap(function()
    StartFishingBot(StatusLabel)
end)()

print("==========================================")
print("🐟 FISH IT BOT LOADED SUCCESSFULLY! 🚀")
print("🔗 GitHub: https://github.com/username/repo")
print("😈 by Nesia Darknet")
print("==========================================")
