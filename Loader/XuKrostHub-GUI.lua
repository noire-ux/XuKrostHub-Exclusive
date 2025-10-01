-- XuKrost Hub | By noirexe (Enhanced + Tabs + Search + Manual Tab Position + Mini Control Bar + Bubble Minimize + Dividers + Console + Teleport Manager)
-- LocalScript (StarterGui)

-- CONFIG
local HubName = "XuKrost Hub"
local CreatorText = "By noirexe"

-- Scripts data
local scripts = {
["Main Scripts"] = {
["Indo-Hangout Beta"] = "https://raw.githubusercontent.com/noire-ux/XuKrostHub-Exclusive/refs/heads/main/Loader/Main-map/Indo-hangout/test.lua",
["Mt.Sumbing"] = "https://raw.githubusercontent.com/noire-ux/XuKrostHub-Exclusive/refs/heads/main/Loader/Main-map/Mt-Sumbing.lua",
["Mt.Hts"] = "https://raw.githubusercontent.com/noire-ux/XuKrostHub-Exclusive/refs/heads/main/Loader/Main-map/Mt-Hts.lua",
["Mt.Jawa"] = "https://raw.githubusercontent.com/noire-ux/XuKrostHub-Exclusive/refs/heads/main/Loader/Main-map/Mt-Jawa.lua",
["Mt.Malang"] = "https://raw.githubusercontent.com/noire-ux/XuKrostHub-Exclusive/refs/heads/main/Loader/Main-map/Mt-Malang.lua",
["Mt.Papua"] = "https://raw.githubusercontent.com/noire-ux/XuKrostHub-Exclusive/refs/heads/main/Loader/Main-map/Mt-Papua.lua",
["Mt.Bohong"] = "https://raw.githubusercontent.com/noire-ux/XuKrostHub-Exclusive/refs/heads/main/Loader/Main-map/Mt-Bohong.lua",
["Mt.Bayii"]  = "https://raw.githubusercontent.com/noire-ux/XuKrostHub-Exclusive/refs/heads/main/Loader/Main-map/Mt-Bayi.lua",
["Mt.Yareu"]  = "https://raw.githubusercontent.com/noire-ux/XuKrostHub-Exclusive/refs/heads/main/Loader/Main-map/Mt-Yareu.lua"
},
["Extra Tools"] = {
["Movement Controls"] = "movement_controls_internal",
["Fly"] = "https://raw.githubusercontent.com/noirexe/GYkHTrZSc5W/refs/heads/main/sc-free-ko-dijual-awoakowk.lua",
["Remove Network Pause"] = "remove_network_pause_internal"
},
["Own Script"] = {},
["Console"] = {},
["Credits"] = {}
}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Movement Controls Variables
local WalkSpeedValue = 16
local JumpPowerValue = 50
local infJump = false

-- Teleport Manager Variables
local teleportLocations = {}
local TELEPORT_DATA_KEY = "XuKrostHub_TeleportData"

-- UTIL: notifications
local function notify(title, text, duration)
    duration = duration or 4
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title=title,Text=text,Duration=duration})
    end)
end

-- UTIL: HTTP + run
local function httpGet(url)
    local ok, res = pcall(function() return game:HttpGet(url, true) end)
    if ok and res then return true, res end
    return false, "HttpGet failed"
end

local function fetchAndRun(url)
    local ok, body = httpGet(url)
    if not ok then return false, body end
    local f, err = loadstring(body)
    if not f then return false, "Compile error: "..tostring(err) end
    local ok2, runErr = pcall(f)
    if not ok2 then return false, "Runtime error: "..tostring(runErr) end
    return true, "Executed"
end

-- Teleport Manager Functions
local function saveTeleportData()
    local dataToSave = {}
    for name, location in pairs(teleportLocations) do
        dataToSave[name] = {
            X = location.X,
            Y = location.Y,
            Z = location.Z
        }
    end
    
    local jsonData = HttpService:JSONEncode(dataToSave)
    writefile(TELEPORT_DATA_KEY .. ".json", jsonData)
    return true
end

local function loadTeleportData()
    local success, data = pcall(function()
        if isfile(TELEPORT_DATA_KEY .. ".json") then
            local jsonData = readfile(TELEPORT_DATA_KEY .. ".json")
            return HttpService:JSONDecode(jsonData)
        end
    end)
    
    if success and data then
        teleportLocations = {}
        for name, posData in pairs(data) do
            teleportLocations[name] = Vector3.new(posData.X, posData.Y, posData.Z)
        end
        return true
    end
    return false
end

local function teleportToPosition(position)
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(position)
        return true
    end
    return false
end

local function getCurrentPosition()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        return character.HumanoidRootPart.Position
    end
    return nil
end

local function refreshTeleportList(scrollFrame, consoleOutput)
    -- Clear existing teleport entries
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") and child.Name == "TeleportEntry" then
            child:Destroy()
        end
    end
    
    -- Add saved locations
    local entryHeight = 35
    local padding = 5
    local totalHeight = 0
    
    for name, position in pairs(teleportLocations) do
        local entryFrame = Instance.new("Frame", scrollFrame)
        entryFrame.Size = UDim2.new(1, -10, 0, entryHeight)
        entryFrame.Position = UDim2.new(0, 5, 0, totalHeight)
        entryFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
        entryFrame.BorderSizePixel = 0
        entryFrame.Name = "TeleportEntry"
        Instance.new("UICorner", entryFrame).CornerRadius = UDim.new(0, 6)
        
        -- Name and Position Info
        local infoFrame = Instance.new("Frame", entryFrame)
        infoFrame.Size = UDim2.new(0.6, -5, 1, 0)
        infoFrame.Position = UDim2.new(0, 5, 0, 0)
        infoFrame.BackgroundTransparency = 1
        
        local nameLabel = Instance.new("TextLabel", infoFrame)
        nameLabel.Size = UDim2.new(1, 0, 0.6, 0)
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
        nameLabel.Text = name
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Font = Enum.Font.GothamSemibold
        nameLabel.TextSize = 12
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local posLabel = Instance.new("TextLabel", infoFrame)
        posLabel.Size = UDim2.new(1, 0, 0.4, 0)
        posLabel.Position = UDim2.new(0, 0, 0.6, 0)
        posLabel.Text = string.format("X:%.1f Y:%.1f Z:%.1f", position.X, position.Y, position.Z)
        posLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        posLabel.BackgroundTransparency = 1
        posLabel.Font = Enum.Font.Gotham
        posLabel.TextSize = 10
        posLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Action Buttons
        local buttonFrame = Instance.new("Frame", entryFrame)
        buttonFrame.Size = UDim2.new(0.4, -5, 1, 0)
        buttonFrame.Position = UDim2.new(0.6, 0, 0, 0)
        buttonFrame.BackgroundTransparency = 1
        
        local tpButton = Instance.new("TextButton", buttonFrame)
        tpButton.Size = UDim2.new(0.45, -2, 0.7, 0)
        tpButton.Position = UDim2.new(0, 0, 0.15, 0)
        tpButton.Text = "TP"
        tpButton.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
        tpButton.TextColor3 = Color3.new(1, 1, 1)
        tpButton.Font = Enum.Font.GothamSemibold
        tpButton.TextSize = 11
        Instance.new("UICorner", tpButton).CornerRadius = UDim.new(0, 4)
        
        local deleteButton = Instance.new("TextButton", buttonFrame)
        deleteButton.Size = UDim2.new(0.45, -2, 0.7, 0)
        deleteButton.Position = UDim2.new(0.55, 0, 0.15, 0)
        deleteButton.Text = "Delete"
        deleteButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        deleteButton.TextColor3 = Color3.new(1, 1, 1)
        deleteButton.Font = Enum.Font.GothamSemibold
        deleteButton.TextSize = 11
        Instance.new("UICorner", deleteButton).CornerRadius = UDim.new(0, 4)
        
        -- Button functionality
        tpButton.MouseButton1Click:Connect(function()
            if teleportToPosition(position) then
                consoleOutput.Text = consoleOutput.Text .. ">> Teleported to: " .. name .. "\n"
                notify("Teleport", "Teleported to " .. name, 2)
            else
                consoleOutput.Text = consoleOutput.Text .. ">> Teleport failed! No character found.\n"
                notify("Teleport", "Teleport failed!", 3)
            end
        end)
        
        deleteButton.MouseButton1Click:Connect(function()
            teleportLocations[name] = nil
            saveTeleportData()
            refreshTeleportList(scrollFrame, consoleOutput)
            consoleOutput.Text = consoleOutput.Text .. ">> Deleted location: " .. name .. "\n"
            notify("Teleport", "Deleted " .. name, 2)
        end)
        
        totalHeight = totalHeight + entryHeight + padding
    end
    
    -- Update scroll frame size
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

-- Movement Controls Functions
local function updateWalkSpeed(v)
    WalkSpeedValue = v
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = v end
end

local function updateJumpPower(v)
    JumpPowerValue = v
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.UseJumpPower = true
        hum.JumpPower = v
    end
end

-- Remove Network Pause Function
local function removeNetworkPause()
    local success, result = pcall(function()
        local networkPause = CoreGui.RobloxGui:FindFirstChild("CoreScripts/NetworkPause")
        if networkPause then
            networkPause:Destroy()
            return true, "Network Pause removed successfully!"
        else
            return false, "Network Pause not found!"
        end
    end)
    
    return success, result
end

-- Setup movement controls
UserInputService.JumpRequest:Connect(function()
    if infJump and player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

player.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    task.wait(0.1)
    hum.WalkSpeed = WalkSpeedValue
    hum.UseJumpPower = true
    hum.JumpPower = JumpPowerValue
end)

-- BUILD UI
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "XuKrostHub"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 500, 0, 400)
mainFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,35)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.BorderSizePixel = 0
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,12)

-- Header
local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1, 0, 0, 44)
header.BackgroundTransparency = 1

local title = Instance.new("TextLabel", header)
title.Text = HubName
title.Font = Enum.Font.GothamBlack
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(245,245,245)
title.Position = UDim2.new(0, 12, 0, 0)
title.Size = UDim2.new(0.6, 0, 1, 0)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

local creator = Instance.new("TextLabel", header)
creator.Text = CreatorText
creator.Font = Enum.Font.Gotham
creator.TextSize = 12
creator.TextColor3 = Color3.fromRGB(170,170,170)
creator.Size = UDim2.new(0.4, -12, 1, 0)
creator.Position = UDim2.new(0.6, -280, 0, 0)
creator.BackgroundTransparency = 1
creator.TextXAlignment = Enum.TextXAlignment.Right

-- Divider bawah header
local headerLine = Instance.new("Frame", mainFrame)
headerLine.Size = UDim2.new(1, -24, 0, 1)
headerLine.Position = UDim2.new(0, 12, 0, 47)
headerLine.BackgroundColor3 = Color3.fromRGB(70,70,80)
headerLine.BorderSizePixel = 0

-- Mini Control Bar
local controlBar = Instance.new("Frame", header)
controlBar.Size = UDim2.new(0, 80, 1, 0)
controlBar.Position = UDim2.new(1, -84, 0, 2)
controlBar.BackgroundTransparency = 1

local function makeControlButton(parent, text, color)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 29, 0, 21)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,5)
    return btn
end

local minimizeBtn = makeControlButton(controlBar,"–",Color3.fromRGB(60,120,200))
minimizeBtn.Position = UDim2.new(0,8,0.5,-12)

local closeBtn = makeControlButton(controlBar,"X",Color3.fromRGB(200,60,60))
closeBtn.Position = UDim2.new(0,44,0.5,-12)

-- Divider bawah status
local statusLine = Instance.new("Frame", mainFrame)
statusLine.Size = UDim2.new(1, -24, 0, 1)
statusLine.Position = UDim2.new(0, 12, 0, 53)
statusLine.BackgroundColor3 = Color3.fromRGB(70,70,80)
statusLine.BorderSizePixel = 0

-- Tabs container
local tabsFrame = Instance.new("Frame", mainFrame)
tabsFrame.Size = UDim2.new(1, -24, 0, 32)
tabsFrame.Position = UDim2.new(0, 19, 0, 48)
tabsFrame.BackgroundTransparency = 1

-- Divider vertikal (antara tabs dan content)
local verticalLine = Instance.new("Frame", mainFrame)
verticalLine.Size = UDim2.new(0, 1, 1, -100)
verticalLine.Position = UDim2.new(0, 145, 0, 54.3)
verticalLine.BackgroundColor3 = Color3.fromRGB(70,70,80)
verticalLine.BorderSizePixel = 0

-- Tabs + Search
local tabButtons = {}
local tabContentFrames = {}
local currentTab = nil
local searchBox = nil

-- Koordinat tab (manual)
local tabPositions = {
    ["Main Scripts"] = UDim2.new(0, -3, 0, 20),
    ["Extra Tools"] = UDim2.new(0, -3, 0, 60),
    ["Own Script"] = UDim2.new(0, -3, 0, 100),
    ["Console"]     = UDim2.new(0, -3, 0, 140),
    ["Credits"]     = UDim2.new(0, -3, 0, 180)
}

local function switchTab(name)
    for t,frame in pairs(tabContentFrames) do
        frame.Visible = (t == name)
    end
    currentTab = name
end

-- Buat Tab Buttons
for tabName,_ in pairs(scripts) do
    local btn = Instance.new("TextButton", tabsFrame)
    btn.Size = UDim2.new(0, 120, 1, 0)
    btn.Position = tabPositions[tabName] or UDim2.new(0, 0, 0, 0)
    btn.Text = tabName
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(45,45,52)
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
    btn.MouseButton1Click:Connect(function() switchTab(tabName) end)
    tabButtons[tabName] = btn
end

-- Search bar
searchBox = Instance.new("TextBox", mainFrame)
searchBox.PlaceholderText = "search..."
searchBox.Size = UDim2.new(1, -357, 0, 20)
searchBox.Position = UDim2.new(0, 276, 0, 13)
searchBox.BackgroundTransparency = 1
searchBox.TextColor3 = Color3.new(1,1,1)
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 14
searchBox.Text = ""
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0,6)
searchBox.Visible = true

-- Tab contents
local consoleOutput
local consoleScrollingFrame
local movementDropdownOpen = false
local movementDropdownFrame

-- FIX: Fungsi untuk update console dengan auto-scroll
local function updateConsole(text)
    consoleOutput.Text = text
    -- Auto-scroll ke bawah
    task.wait(0.05) -- Tunggu sebentar untuk render
    if consoleScrollingFrame then
        consoleScrollingFrame.CanvasPosition = Vector2.new(0, consoleOutput.TextBounds.Y + 100)
    end
end

local function appendToConsole(newText)
    consoleOutput.Text = consoleOutput.Text .. newText
    -- Auto-scroll ke bawah
    task.wait(0.05) -- Tunggu sebentar untuk render
    if consoleScrollingFrame then
        consoleScrollingFrame.CanvasPosition = Vector2.new(0, consoleOutput.TextBounds.Y + 100)
    end
end

local function createTabContent(tabName, data)
    local offsetY = (tabName == "Main Scripts" or tabName == "Extra Tools" or tabName == "Own Script" or tabName == "Console") and 68.1 or 120
    local contentFrame = Instance.new("Frame", mainFrame)
    contentFrame.Size = UDim2.new(1, -170, 1, -offsetY)
    contentFrame.Position = UDim2.new(0, 154, 0, offsetY)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Visible = false
    tabContentFrames[tabName] = contentFrame

    if tabName == "Console" then  
        -- FIX: Gunakan ScrollingFrame untuk console
        consoleScrollingFrame = Instance.new("ScrollingFrame", contentFrame)
        consoleScrollingFrame.Size = UDim2.new(1, -10, 1, -10)
        consoleScrollingFrame.Position = UDim2.new(0, 5, 0, 5)
        consoleScrollingFrame.BackgroundColor3 = Color3.fromRGB(20,20,25)
        consoleScrollingFrame.BorderSizePixel = 0
        consoleScrollingFrame.ScrollBarThickness = 8
        consoleScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y -- FIX: Auto size
        Instance.new("UICorner", consoleScrollingFrame).CornerRadius = UDim.new(0,6)
        
        consoleOutput = Instance.new("TextLabel", consoleScrollingFrame)
        consoleOutput.Size = UDim2.new(1, -10, 0, 0)
        consoleOutput.Position = UDim2.new(0, 5, 0, 5)
        consoleOutput.BackgroundTransparency = 1
        consoleOutput.TextColor3 = Color3.new(1,1,1)
        consoleOutput.Font = Enum.Font.Code
        consoleOutput.TextSize = 14
        consoleOutput.TextXAlignment = Enum.TextXAlignment.Left
        consoleOutput.TextYAlignment = Enum.TextYAlignment.Top
        consoleOutput.TextWrapped = true
        consoleOutput.Text = ">> Console ready...\n"
        consoleOutput.TextStrokeTransparency = 0.8
        consoleOutput.AutomaticSize = Enum.AutomaticSize.Y -- FIX: Auto size text label
        
    elseif tabName == "Extra Tools" then  
        -- UIListLayout untuk mengatur button  
        local listLayout = Instance.new("UIListLayout", contentFrame)  
        listLayout.Padding = UDim.new(0,6)  
          
        -- Movement Controls Dropdown Button  
        local movementDropdownBtn = Instance.new("TextButton", contentFrame)  
        movementDropdownBtn.Size = UDim2.new(1, 0, 0, 36)  
        movementDropdownBtn.Text = "Movement Controls"  
        movementDropdownBtn.Font = Enum.Font.GothamSemibold  
        movementDropdownBtn.TextSize = 14  
        movementDropdownBtn.TextColor3 = Color3.new(1,1,1)  
        movementDropdownBtn.BackgroundColor3 = Color3.fromRGB(50,50,60)  
        movementDropdownBtn.BorderSizePixel = 0  
        Instance.new("UICorner", movementDropdownBtn).CornerRadius = UDim.new(0,6)  
          
        -- Movement Controls Dropdown Content  
        movementDropdownFrame = Instance.new("Frame", contentFrame)  
        movementDropdownFrame.Size = UDim2.new(1, 0, 0, 0)  
        movementDropdownFrame.Position = UDim2.new(0, 0, 0, 42)  
        movementDropdownFrame.BackgroundColor3 = Color3.fromRGB(40,40,45)  
        movementDropdownFrame.BorderSizePixel = 0  
        movementDropdownFrame.ClipsDescendants = true  
        Instance.new("UICorner", movementDropdownFrame).CornerRadius = UDim.new(0,6)  
        movementDropdownFrame.Visible = false  
          
        -- WalkSpeed Control  
        local walkSpeedFrame = Instance.new("Frame", movementDropdownFrame)  
        walkSpeedFrame.Size = UDim2.new(1, -10, 0, 30)  
        walkSpeedFrame.Position = UDim2.new(0, 5, 0, 5)  
        walkSpeedFrame.BackgroundTransparency = 1  
          
        local walkSpeedLabel = Instance.new("TextLabel", walkSpeedFrame)  
        walkSpeedLabel.Size = UDim2.new(0.4, 0, 1, 0)  
        walkSpeedLabel.Position = UDim2.new(0.4, -87, 0, 0)  
        walkSpeedLabel.Text = "WalkSpeed:"  
        walkSpeedLabel.TextColor3 = Color3.new(1,1,1)  
        walkSpeedLabel.BackgroundTransparency = 1  
        walkSpeedLabel.Font = Enum.Font.Gotham  
        walkSpeedLabel.TextSize = 12  
        walkSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left  
          
        local walkSpeedBox = Instance.new("TextBox", walkSpeedFrame)  
        walkSpeedBox.Size = UDim2.new(0.3, 0, 1, 0)  
        walkSpeedBox.Position = UDim2.new(0.4, 5, 0, 0)  
        walkSpeedBox.Text = tostring(WalkSpeedValue)  
        walkSpeedBox.BackgroundColor3 = Color3.fromRGB(60,60,70)  
        walkSpeedBox.TextColor3 = Color3.new(1,1,1)  
        walkSpeedBox.Font = Enum.Font.Gotham  
        walkSpeedBox.TextSize = 12  
        Instance.new("UICorner", walkSpeedBox).CornerRadius = UDim.new(0,4)  
          
        local walkSpeedBtn = Instance.new("TextButton", walkSpeedFrame)  
        walkSpeedBtn.Size = UDim2.new(0.25, -5, 1, 0)  
        walkSpeedBtn.Position = UDim2.new(0.75, 5, 0, 0)  
        walkSpeedBtn.Text = "Apply"  
        walkSpeedBtn.BackgroundColor3 = Color3.fromRGB(60,120,200)  
        walkSpeedBtn.TextColor3 = Color3.new(1,1,1)  
        walkSpeedBtn.Font = Enum.Font.GothamSemibold  
        walkSpeedBtn.TextSize = 12  
        Instance.new("UICorner", walkSpeedBtn).CornerRadius = UDim.new(0,4)  
          
        walkSpeedBtn.MouseButton1Click:Connect(function()  
            local ws = tonumber(walkSpeedBox.Text)  
            if ws then  
                updateWalkSpeed(ws)  
                appendToConsole(">> WalkSpeed set to "..ws.."\n")  
                notify("Movement", "WalkSpeed: "..ws, 2)  
            end  
        end)  
          
        -- JumpPower Control  
        local jumpPowerFrame = Instance.new("Frame", movementDropdownFrame)  
        jumpPowerFrame.Size = UDim2.new(1, -10, 0, 30)  
        jumpPowerFrame.Position = UDim2.new(0, 5, 0, 40)  
        jumpPowerFrame.BackgroundTransparency = 1  
          
        local jumpPowerLabel = Instance.new("TextLabel", jumpPowerFrame)  
        jumpPowerLabel.Size = UDim2.new(0.4, 0, 1, 0)  
        jumpPowerLabel.Position = UDim2.new(0.4, -90, 0, 0)  
        jumpPowerLabel.Text = "JumpPower:"  
        jumpPowerLabel.TextColor3 = Color3.new(1,1,1)  
        jumpPowerLabel.BackgroundTransparency = 1  
        jumpPowerLabel.Font = Enum.Font.Gotham  
        jumpPowerLabel.TextSize = 12  
        jumpPowerLabel.TextXAlignment = Enum.TextXAlignment.Left  
          
        local jumpPowerBox = Instance.new("TextBox", jumpPowerFrame)  
        jumpPowerBox.Size = UDim2.new(0.3, 0, 1, 0)  
        jumpPowerBox.Position = UDim2.new(0.4, 5, 0, 0)  
        jumpPowerBox.Text = tostring(JumpPowerValue)  
        jumpPowerBox.BackgroundColor3 = Color3.fromRGB(60,60,70)  
        jumpPowerBox.TextColor3 = Color3.new(1,1,1)  
        jumpPowerBox.Font = Enum.Font.Gotham  
        jumpPowerBox.TextSize = 12  
        Instance.new("UICorner", jumpPowerBox).CornerRadius = UDim.new(0,4)  
          
        local jumpPowerBtn = Instance.new("TextButton", jumpPowerFrame)  
        jumpPowerBtn.Size = UDim2.new(0.25, -5, 1, 0)  
        jumpPowerBtn.Position = UDim2.new(0.75, 5, 0, 0)  
        jumpPowerBtn.Text = "Apply"  
        jumpPowerBtn.BackgroundColor3 = Color3.fromRGB(60,120,200)  
        jumpPowerBtn.TextColor3 = Color3.new(1,1,1)  
        jumpPowerBtn.Font = Enum.Font.GothamSemibold  
        jumpPowerBtn.TextSize = 12  
        Instance.new("UICorner", jumpPowerBtn).CornerRadius = UDim.new(0,4)  
          
        jumpPowerBtn.MouseButton1Click:Connect(function()  
            local jp = tonumber(jumpPowerBox.Text)  
            if jp then  
                updateJumpPower(jp)  
                appendToConsole(">> JumpPower set to "..jp.."\n")  
                notify("Movement", "JumpPower: "..jp, 2)  
            end  
        end)  
          
        -- Infinity Jump Toggle  
        local infJumpBtn = Instance.new("TextButton", movementDropdownFrame)  
        infJumpBtn.Size = UDim2.new(1, -10, 0, 30)  
        infJumpBtn.Position = UDim2.new(0, 5, 0, 75)  
        infJumpBtn.Text = "Infinity Jump: OFF"  
        infJumpBtn.BackgroundColor3 = Color3.fromRGB(80,80,90)  
        infJumpBtn.TextColor3 = Color3.new(1,1,1)  
        infJumpBtn.Font = Enum.Font.GothamSemibold  
        infJumpBtn.TextSize = 12  
        Instance.new("UICorner", infJumpBtn).CornerRadius = UDim.new(0,6)  
          
        infJumpBtn.MouseButton1Click:Connect(function()  
            infJump = not infJump  
            infJumpBtn.Text = "Infinity Jump: " .. (infJump and "ON" or "OFF")  
            infJumpBtn.BackgroundColor3 = infJump and Color3.fromRGB(60,180,80) or Color3.fromRGB(80,80,90)  
            appendToConsole(">> Infinity Jump: "..(infJump and "ON" or "OFF").."\n")  
            notify("Movement", "Infinity Jump "..(infJump and "ON" or "OFF"), 2)  
        end)  
          
        -- Presets  
        local preset1Btn = Instance.new("TextButton", movementDropdownFrame)  
        preset1Btn.Size = UDim2.new(1, -178, 0, 28)  
        preset1Btn.Position = UDim2.new(0, 5, 0, 110)  
        preset1Btn.Text = "Default"  
        preset1Btn.BackgroundColor3 = Color3.fromRGB(70,70,80)  
        preset1Btn.TextColor3 = Color3.new(1,1,1)  
        preset1Btn.Font = Enum.Font.Gotham  
        preset1Btn.TextSize = 13  
        Instance.new("UICorner", preset1Btn).CornerRadius = UDim.new(0,4)  
          
        preset1Btn.MouseButton1Click:Connect(function()  
            updateWalkSpeed(16)  
            updateJumpPower(50)  
            infJump = false  
            walkSpeedBox.Text = "16"  
            jumpPowerBox.Text = "50"  
            infJumpBtn.Text = "Infinity Jump: OFF"  
            infJumpBtn.BackgroundColor3 = Color3.fromRGB(80,80,90)  
            appendToConsole(">> Movement preset: Default\n")  
            notify("Movement", "Default preset applied", 2)  
        end)  
          
        local preset2Btn = Instance.new("TextButton", movementDropdownFrame)  
        preset2Btn.Size = UDim2.new(1, -178, 0, 28)  
        preset2Btn.Position = UDim2.new(0, 173, 0, 110) -- sejajar dengan Default  
        preset2Btn.Text = "Ngibrits"  
        preset2Btn.BackgroundColor3 = Color3.fromRGB(70,70,80)  
        preset2Btn.TextColor3 = Color3.new(1,1,1)  
        preset2Btn.Font = Enum.Font.Gotham  
        preset2Btn.TextSize = 13  
        Instance.new("UICorner", preset2Btn).CornerRadius = UDim.new(0,4)  
          
        preset2Btn.MouseButton1Click:Connect(function()  
            updateWalkSpeed(50)  
            updateJumpPower(75)  
            infJump = true  
            walkSpeedBox.Text = "50"  
            jumpPowerBox.Text = "75"  
            infJumpBtn.Text = "Infinity Jump: ON"  
            infJumpBtn.BackgroundColor3 = Color3.fromRGB(60,180,80)  
            appendToConsole(">> Movement preset: Ngibrits\n")  
            notify("Movement", "Ngibrits preset applied", 2)  
        end)  
          
        -- Dropdown toggle functionality  
        movementDropdownBtn.MouseButton1Click:Connect(function()  
            movementDropdownOpen = not movementDropdownOpen  
              
            if movementDropdownOpen then  
                movementDropdownBtn.Text = "Movement Controls"  
                movementDropdownFrame.Size = UDim2.new(1, 0, 0, 170)  
                movementDropdownFrame.Visible = true  
            else  
                movementDropdownBtn.Text = "Movement Controls"  
                movementDropdownFrame.Size = UDim2.new(1, 0, 0, 0)  
                movementDropdownFrame.Visible = false  
            end  
        end)  
          
        -- Fly Button  
        local flyBtn = Instance.new("TextButton", contentFrame)  
        flyBtn.Size = UDim2.new(1, 0, 0, 36)  
        flyBtn.Text = "Fly"  
        flyBtn.Font = Enum.Font.GothamSemibold  
        flyBtn.TextSize = 14  
        flyBtn.TextColor3 = Color3.new(1,1,1)  
        flyBtn.BackgroundColor3 = Color3.fromRGB(50,50,60)  
        flyBtn.BorderSizePixel = 0  
        Instance.new("UICorner", flyBtn).CornerRadius = UDim.new(0,6)  
          
        flyBtn.MouseButton1Click:Connect(function()  
            appendToConsole(">> Loading Fly Script...\n")  
            local ok,msg = fetchAndRun("https://raw.githubusercontent.com/noirexe/GYkHTrZSc5W/refs/heads/main/sc-free-ko-dijual-awoakowk.lua")      
            if ok then      
                appendToConsole(">> Fly script loaded!\n")      
                notify("XuKrost Hub", "Fly script success",3)      
            else      
                appendToConsole(">> Fly script failed: "..tostring(msg).."\n")      
                notify("XuKrost Hub", "Fly script failed: "..tostring(msg),5)      
            end      
        end)

        -- Remove Network Pause Button
        local removeNetworkPauseBtn = Instance.new("TextButton", contentFrame)  
        removeNetworkPauseBtn.Size = UDim2.new(1, 0, 0, 36)  
        removeNetworkPauseBtn.Text = "Remove Network Pause"  
        removeNetworkPauseBtn.Font = Enum.Font.GothamSemibold  
        removeNetworkPauseBtn.TextSize = 14  
        removeNetworkPauseBtn.TextColor3 = Color3.new(1,1,1)  
        removeNetworkPauseBtn.BackgroundColor3 = Color3.fromRGB(50,50,60)  
        removeNetworkPauseBtn.BorderSizePixel = 0  
        Instance.new("UICorner", removeNetworkPauseBtn).CornerRadius = UDim.new(0,6)  
          
        removeNetworkPauseBtn.MouseButton1Click:Connect(function()  
            appendToConsole(">> Removing Network Pause...\n")  
            
            local success, result = removeNetworkPause()
            
            if success then
                appendToConsole(">> " .. result .. "\n")  
                notify("Network Pause", "Removed successfully!", 3)  
            else
                appendToConsole(">> Failed: " .. tostring(result) .. "\n")  
                notify("Network Pause", "Failed to remove!", 3)  
            end
        end)
          
    elseif tabName == "Own Script" then
        -- Teleport Manager UI
        
        -- Save Position Section
        local saveSection = Instance.new("Frame", contentFrame)
        saveSection.Size = UDim2.new(1, 0, 0, 80)
        saveSection.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        saveSection.BorderSizePixel = 0
        Instance.new("UICorner", saveSection).CornerRadius = UDim.new(0, 6)
        
        local saveLabel = Instance.new("TextLabel", saveSection)
        saveLabel.Size = UDim2.new(1, -10, 0, 20)
        saveLabel.Position = UDim2.new(0, 5, 0, 4)
        saveLabel.Text = "Save Current Position"
        saveLabel.TextColor3 = Color3.new(1, 1, 1)
        saveLabel.BackgroundTransparency = 1
        saveLabel.Font = Enum.Font.GothamSemibold
        saveLabel.TextSize = 14
        saveLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local nameInput = Instance.new("TextBox", saveSection)
        nameInput.Size = UDim2.new(0.6, -30, 0, 30)
        nameInput.Position = UDim2.new(0, 7, 0, 30)
        nameInput.PlaceholderText = "Location Name"
        nameInput.Text = ""
        nameInput.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        nameInput.TextColor3 = Color3.new(1, 1, 1)
        nameInput.Font = Enum.Font.Gotham
        nameInput.TextSize = 12
        Instance.new("UICorner", nameInput).CornerRadius = UDim.new(0, 4)
        
        local saveButton = Instance.new("TextButton", saveSection)
        saveButton.Size = UDim2.new(0.4, -8, 0, 30)
        saveButton.Position = UDim2.new(0.6, -3, 0, 29.5)
        saveButton.Text = "Save Pos"
        saveButton.BackgroundColor3 = Color3.fromRGB(60, 180, 80)
        saveButton.TextColor3 = Color3.new(1, 1, 1)
        saveButton.Font = Enum.Font.GothamSemibold
        saveButton.TextSize = 12
        Instance.new("UICorner", saveButton).CornerRadius = UDim.new(0, 4)
        
        saveButton.MouseButton1Click:Connect(function()
            local locationName = nameInput.Text:gsub("^%s*(.-)%s*$", "%1") -- Trim whitespace
            if locationName == "" then
                appendToConsole(">> Please enter a location name!\n")
                notify("Teleport", "Enter location name!", 2)
                return
            end
            
            if teleportLocations[locationName] then
                appendToConsole(">> Location name already exists!\n")
                notify("Teleport", "Name already exists!", 2)
                return
            end
            
            local currentPos = getCurrentPosition()
            if not currentPos then
                appendToConsole(">> Cannot get current position!\n")
                notify("Teleport", "Cannot get position!", 2)
                return
            end
            
            teleportLocations[locationName] = currentPos
            saveTeleportData()
            
            -- Refresh teleport list
            for _, child in ipairs(contentFrame:GetChildren()) do
                if child.Name == "TeleportScrollFrame" then
                    refreshTeleportList(child, consoleOutput)
                    break
                end
            end
            
            nameInput.Text = ""
            appendToConsole(">> Saved location: " .. locationName .. "\n")
            notify("Teleport", "Saved " .. locationName, 2)
        end)
        
        -- File Management Section
        local fileSection = Instance.new("Frame", contentFrame)
        fileSection.Size = UDim2.new(1, 0, 0, 40)
        fileSection.Position = UDim2.new(0, 0, 0, 85)
        fileSection.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        fileSection.BorderSizePixel = 0
        Instance.new("UICorner", fileSection).CornerRadius = UDim.new(0, 6)
        
        local loadButton = Instance.new("TextButton", fileSection)
        loadButton.Size = UDim2.new(0.5, -15, 0, 30)
        loadButton.Position = UDim2.new(0, 10, 0, 5)
        loadButton.Text = "Load Data"
        loadButton.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
        loadButton.TextColor3 = Color3.new(1, 1, 1)
        loadButton.Font = Enum.Font.GothamSemibold
        loadButton.TextSize = 12
        Instance.new("UICorner", loadButton).CornerRadius = UDim.new(0, 4)
        
        local clearButton = Instance.new("TextButton", fileSection)
        clearButton.Size = UDim2.new(0.5, -15, 0, 30)
        clearButton.Position = UDim2.new(0.5, 5, 0, 5)
        clearButton.Text = "Clear All"
        clearButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        clearButton.TextColor3 = Color3.new(1, 1, 1)
        clearButton.Font = Enum.Font.GothamSemibold
        clearButton.TextSize = 12
        Instance.new("UICorner", clearButton).CornerRadius = UDim.new(0, 4)
        
        loadButton.MouseButton1Click:Connect(function()
            if loadTeleportData() then
                for _, child in ipairs(contentFrame:GetChildren()) do
                    if child.Name == "TeleportScrollFrame" then
                        refreshTeleportList(child, consoleOutput)
                        break
                    end
                end
                appendToConsole(">> Teleport data loaded!\n")
                notify("Teleport", "Data loaded successfully", 2)
            else
                appendToConsole(">> No saved data found!\n")
                notify("Teleport", "No saved data", 2)
            end
        end)
        
        clearButton.MouseButton1Click:Connect(function()
            teleportLocations = {}
            saveTeleportData()
            for _, child in ipairs(contentFrame:GetChildren()) do
                if child.Name == "TeleportScrollFrame" then
                    refreshTeleportList(child, consoleOutput)
                    break
                end
            end
            appendToConsole(">> All locations cleared!\n")
            notify("Teleport", "All locations cleared", 2)
        end)
        
        -- Saved Locations Label
        local locationsLabel = Instance.new("TextLabel", contentFrame)
        locationsLabel.Size = UDim2.new(1, 0, 0, 20)
        locationsLabel.Position = UDim2.new(0, 0, 0, 130)
        locationsLabel.Text = "Saved Locations:"
        locationsLabel.TextColor3 = Color3.new(1, 1, 1)
        locationsLabel.BackgroundTransparency = 1
        locationsLabel.Font = Enum.Font.GothamSemibold
        locationsLabel.TextSize = 14
        locationsLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Scroll frame for teleport locations
        local scrollFrame = Instance.new("ScrollingFrame", contentFrame)
        scrollFrame.Size = UDim2.new(1, 0, 1, -155)
        scrollFrame.Position = UDim2.new(0, 0, 0, 155)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.BorderSizePixel = 0
        scrollFrame.ScrollBarThickness = 6
        scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y -- FIX: Auto size
        scrollFrame.Name = "TeleportScrollFrame"
        
        -- Initial load of teleport data
        loadTeleportData()
        refreshTeleportList(scrollFrame, consoleOutput)
        
    elseif tabName == "Main Scripts" then
        -- Create ScrollingFrame for Main Scripts
        local scrollFrame = Instance.new("ScrollingFrame", contentFrame)
        scrollFrame.Size = UDim2.new(1, 0, 1, 0)
        scrollFrame.Position = UDim2.new(0, 0, 0, 0)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.BorderSizePixel = 0
        scrollFrame.ScrollBarThickness = 8
        scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scrollFrame.Name = "MainScriptsScrollFrame"
        
        local buttons = {}
        local buttonHeight = 36
        local padding = 6
        local totalHeight = 0
        
        local function refreshFilter()
            local filter = searchBox.Text:lower()
            local currentY = 0
            
            for name, btn in pairs(buttons) do
                if filter == "" or name:lower():find(filter) then
                    btn.Visible = true
                    btn.Position = UDim2.new(0, 0, 0, currentY)
                    currentY = currentY + buttonHeight + padding
                else
                    btn.Visible = false
                end
            end
            
            -- Update scroll frame size
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, currentY)
        end

        for name, url in pairs(data) do
            local btn = Instance.new("TextButton", scrollFrame)
            btn.Size = UDim2.new(1, 0, 0, buttonHeight)
            btn.Position = UDim2.new(0, 0, 0, totalHeight)
            btn.Text = name
            btn.Font = Enum.Font.GothamSemibold
            btn.TextSize = 14
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            btn.BorderSizePixel = 0
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

            btn.MouseButton1Click:Connect(function()
                appendToConsole(">> Loading " .. name .. "\n")
                local ok, msg = fetchAndRun(url)
                if ok then
                    appendToConsole(">> " .. name .. " loaded!\n")
                    notify("XuKrost Hub", name .. " success", 3)
                else
                    appendToConsole(">> " .. name .. " failed: " .. tostring(msg) .. "\n")
                    notify("XuKrost Hub", name .. " failed: " .. tostring(msg), 5)
                end
            end)

            buttons[name] = btn
            totalHeight = totalHeight + buttonHeight + padding
        end
        
        -- Set initial scroll frame size
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
        
        -- Connect search functionality
        searchBox:GetPropertyChangedSignal("Text"):Connect(refreshFilter)
        refreshFilter()
        
    else  
        local listLayout = Instance.new("UIListLayout", contentFrame)  
        listLayout.Padding = UDim.new(0,6)  

        local buttons = {}  
        local function refreshFilter()  
            local filter = searchBox.Text:lower()  
            for name,btn in pairs(buttons) do  
                btn.Visible = (filter == "" or name:lower():find(filter))  
            end  
        end  

        for name,url in pairs(data) do  
            local btn = Instance.new("TextButton", contentFrame)  
            btn.Size = UDim2.new(1, 0, 0, 36)  
            btn.Text = name  
            btn.Font = Enum.Font.GothamSemibold  
            btn.TextSize = 14  
            btn.TextColor3 = Color3.new(1,1,1)  
            btn.BackgroundColor3 = Color3.fromRGB(50,50,60)  
            btn.BorderSizePixel = 0  
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)  

            btn.MouseButton1Click:Connect(function()  
                appendToConsole(">> Loading "..name.."\n")  
                local ok,msg = fetchAndRun(url)      
                if ok then      
                    appendToConsole(">> "..name.." loaded!\n")      
                    notify("XuKrost Hub", name.." success",3)      
                else      
                    appendToConsole(">> "..name.." failed: "..tostring(msg).."\n")      
                    notify("XuKrost Hub", name.." failed: "..tostring(msg),5)      
                end      
            end)  

            buttons[name] = btn  
        end  

        if tabName == "Main Scripts" then  
            searchBox:GetPropertyChangedSignal("Text"):Connect(refreshFilter)  
            refreshFilter()  
        end  
    end
end

for tabName,data in pairs(scripts) do
    createTabContent(tabName,data)
end

-- Default tab
switchTab("Main Scripts")

-- Bubble button (hidden by default)
local bubbleButton = Instance.new("TextButton", screenGui)
bubbleButton.Size = UDim2.new(0, 50, 0, 40)
bubbleButton.Position = UDim2.new(0.05, 0, 0.1, 0)
bubbleButton.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
bubbleButton.Text = "XHUB"
bubbleButton.Font = Enum.Font.GothamBlack
bubbleButton.TextSize = 14
bubbleButton.TextColor3 = Color3.new(1,1,1)
bubbleButton.Draggable = true
bubbleButton.Visible = false
bubbleButton.BorderSizePixel = 0
Instance.new("UICorner", bubbleButton).CornerRadius = UDim.new(0,6)

-- Minimize/Close actions
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    if minimized then return end
    minimized = true
    TweenService:Create(mainFrame,TweenInfo.new(0.3),{Size=UDim2.new(0,0,0,0)}):Play()
    task.delay(0.35,function()
        mainFrame.Visible = false
        bubbleButton.Visible = true
    end)
end)

bubbleButton.MouseButton1Click:Connect(function()
    bubbleButton.Visible = false
    mainFrame.Visible = true
    TweenService:Create(mainFrame,TweenInfo.new(0.3),{Size=UDim2.new(0,500,0,400)}):Play()
    minimized = false
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

notify(HubName,"✅ XuKrost Hub Successfully loaded! have fun!",4)local playerGui = player:WaitForChild("PlayerGui")

-- Movement Controls Variables
local WalkSpeedValue = 16
local JumpPowerValue = 50
local infJump = false

-- Teleport Manager Variables
local teleportLocations = {}
local TELEPORT_DATA_KEY = "XuKrostHub_TeleportData"

-- UTIL: notifications
local function notify(title, text, duration)
    duration = duration or 4
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title=title,Text=text,Duration=duration})
    end)
end

-- UTIL: HTTP + run
local function httpGet(url)
    local ok, res = pcall(function() return game:HttpGet(url, true) end)
    if ok and res then return true, res end
    return false, "HttpGet failed"
end

local function fetchAndRun(url)
    local ok, body = httpGet(url)
    if not ok then return false, body end
    local f, err = loadstring(body)
    if not f then return false, "Compile error: "..tostring(err) end
    local ok2, runErr = pcall(f)
    if not ok2 then return false, "Runtime error: "..tostring(runErr) end
    return true, "Executed"
end

-- Teleport Manager Functions
local function saveTeleportData()
    local dataToSave = {}
    for name, location in pairs(teleportLocations) do
        dataToSave[name] = {
            X = location.X,
            Y = location.Y,
            Z = location.Z
        }
    end
    
    local jsonData = HttpService:JSONEncode(dataToSave)
    writefile(TELEPORT_DATA_KEY .. ".json", jsonData)
    return true
end

local function loadTeleportData()
    local success, data = pcall(function()
        if isfile(TELEPORT_DATA_KEY .. ".json") then
            local jsonData = readfile(TELEPORT_DATA_KEY .. ".json")
            return HttpService:JSONDecode(jsonData)
        end
    end)
    
    if success and data then
        teleportLocations = {}
        for name, posData in pairs(data) do
            teleportLocations[name] = Vector3.new(posData.X, posData.Y, posData.Z)
        end
        return true
    end
    return false
end

local function teleportToPosition(position)
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(position)
        return true
    end
    return false
end

local function getCurrentPosition()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        return character.HumanoidRootPart.Position
    end
    return nil
end

local function refreshTeleportList(scrollFrame, consoleOutput)
    -- Clear existing teleport entries
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") and child.Name == "TeleportEntry" then
            child:Destroy()
        end
    end
    
    -- Add saved locations
    local entryHeight = 35
    local padding = 5
    local totalHeight = 0
    
    for name, position in pairs(teleportLocations) do
        local entryFrame = Instance.new("Frame", scrollFrame)
        entryFrame.Size = UDim2.new(1, -10, 0, entryHeight)
        entryFrame.Position = UDim2.new(0, 5, 0, totalHeight)
        entryFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
        entryFrame.BorderSizePixel = 0
        entryFrame.Name = "TeleportEntry"
        Instance.new("UICorner", entryFrame).CornerRadius = UDim.new(0, 6)
        
        -- Name and Position Info
        local infoFrame = Instance.new("Frame", entryFrame)
        infoFrame.Size = UDim2.new(0.6, -5, 1, 0)
        infoFrame.Position = UDim2.new(0, 5, 0, 0)
        infoFrame.BackgroundTransparency = 1
        
        local nameLabel = Instance.new("TextLabel", infoFrame)
        nameLabel.Size = UDim2.new(1, 0, 0.6, 0)
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
        nameLabel.Text = name
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Font = Enum.Font.GothamSemibold
        nameLabel.TextSize = 12
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local posLabel = Instance.new("TextLabel", infoFrame)
        posLabel.Size = UDim2.new(1, 0, 0.4, 0)
        posLabel.Position = UDim2.new(0, 0, 0.6, 0)
        posLabel.Text = string.format("X:%.1f Y:%.1f Z:%.1f", position.X, position.Y, position.Z)
        posLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        posLabel.BackgroundTransparency = 1
        posLabel.Font = Enum.Font.Gotham
        posLabel.TextSize = 10
        posLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Action Buttons
        local buttonFrame = Instance.new("Frame", entryFrame)
        buttonFrame.Size = UDim2.new(0.4, -5, 1, 0)
        buttonFrame.Position = UDim2.new(0.6, 0, 0, 0)
        buttonFrame.BackgroundTransparency = 1
        
        local tpButton = Instance.new("TextButton", buttonFrame)
        tpButton.Size = UDim2.new(0.45, -2, 0.7, 0)
        tpButton.Position = UDim2.new(0, 0, 0.15, 0)
        tpButton.Text = "TP"
        tpButton.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
        tpButton.TextColor3 = Color3.new(1, 1, 1)
        tpButton.Font = Enum.Font.GothamSemibold
        tpButton.TextSize = 11
        Instance.new("UICorner", tpButton).CornerRadius = UDim.new(0, 4)
        
        local deleteButton = Instance.new("TextButton", buttonFrame)
        deleteButton.Size = UDim2.new(0.45, -2, 0.7, 0)
        deleteButton.Position = UDim2.new(0.55, 0, 0.15, 0)
        deleteButton.Text = "Delete"
        deleteButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        deleteButton.TextColor3 = Color3.new(1, 1, 1)
        deleteButton.Font = Enum.Font.GothamSemibold
        deleteButton.TextSize = 11
        Instance.new("UICorner", deleteButton).CornerRadius = UDim.new(0, 4)
        
        -- Button functionality
        tpButton.MouseButton1Click:Connect(function()
            if teleportToPosition(position) then
                consoleOutput.Text = consoleOutput.Text .. ">> Teleported to: " .. name .. "\n"
                notify("Teleport", "Teleported to " .. name, 2)
            else
                consoleOutput.Text = consoleOutput.Text .. ">> Teleport failed! No character found.\n"
                notify("Teleport", "Teleport failed!", 3)
            end
        end)
        
        deleteButton.MouseButton1Click:Connect(function()
            teleportLocations[name] = nil
            saveTeleportData()
            refreshTeleportList(scrollFrame, consoleOutput)
            consoleOutput.Text = consoleOutput.Text .. ">> Deleted location: " .. name .. "\n"
            notify("Teleport", "Deleted " .. name, 2)
        end)
        
        totalHeight = totalHeight + entryHeight + padding
    end
    
    -- Update scroll frame size
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

-- Movement Controls Functions
local function updateWalkSpeed(v)
    WalkSpeedValue = v
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = v end
end

local function updateJumpPower(v)
    JumpPowerValue = v
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.UseJumpPower = true
        hum.JumpPower = v
    end
end

-- Remove Network Pause Function
local function removeNetworkPause()
    local success, result = pcall(function()
        local networkPause = CoreGui.RobloxGui:FindFirstChild("CoreScripts/NetworkPause")
        if networkPause then
            networkPause:Destroy()
            return true, "Network Pause removed successfully!"
        else
            return false, "Network Pause not found!"
        end
    end)
    
    return success, result
end

-- Setup movement controls
UserInputService.JumpRequest:Connect(function()
    if infJump and player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

player.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    task.wait(0.1)
    hum.WalkSpeed = WalkSpeedValue
    hum.UseJumpPower = true
    hum.JumpPower = JumpPowerValue
end)

-- BUILD UI
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "XuKrostHub"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 500, 0, 400)
mainFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,35)
mainFrame.BorderSizePixel = 0
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,12)

-- Header
local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1, 0, 0, 44)
header.BackgroundTransparency = 1

local title = Instance.new("TextLabel", header)
title.Text = HubName
title.Font = Enum.Font.GothamBlack
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(245,245,245)
title.Position = UDim2.new(0, 12, 0, 0)
title.Size = UDim2.new(0.6, 0, 1, 0)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

local creator = Instance.new("TextLabel", header)
creator.Text = CreatorText
creator.Font = Enum.Font.Gotham
creator.TextSize = 12
creator.TextColor3 = Color3.fromRGB(170,170,170)
creator.Size = UDim2.new(0.4, -12, 1, 0)
creator.Position = UDim2.new(0.6, -280, 0, 0)
creator.BackgroundTransparency = 1
creator.TextXAlignment = Enum.TextXAlignment.Right

-- Divider bawah header
local headerLine = Instance.new("Frame", mainFrame)
headerLine.Size = UDim2.new(1, -24, 0, 1)
headerLine.Position = UDim2.new(0, 12, 0, 47)
headerLine.BackgroundColor3 = Color3.fromRGB(70,70,80)
headerLine.BorderSizePixel = 0

-- Mini Control Bar
local controlBar = Instance.new("Frame", header)
controlBar.Size = UDim2.new(0, 80, 1, 0)
controlBar.Position = UDim2.new(1, -84, 0, 2)
controlBar.BackgroundTransparency = 1

local function makeControlButton(parent, text, color)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 29, 0, 21)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,5)
    return btn
end

local minimizeBtn = makeControlButton(controlBar,"–",Color3.fromRGB(60,120,200))
minimizeBtn.Position = UDim2.new(0,8,0.5,-12)

local closeBtn = makeControlButton(controlBar,"X",Color3.fromRGB(200,60,60))
closeBtn.Position = UDim2.new(0,44,0.5,-12)

-- Divider bawah status
local statusLine = Instance.new("Frame", mainFrame)
statusLine.Size = UDim2.new(1, -24, 0, 1)
statusLine.Position = UDim2.new(0, 12, 0, 53)
statusLine.BackgroundColor3 = Color3.fromRGB(70,70,80)
statusLine.BorderSizePixel = 0

-- Tabs container
local tabsFrame = Instance.new("Frame", mainFrame)
tabsFrame.Size = UDim2.new(1, -24, 0, 32)
tabsFrame.Position = UDim2.new(0, 19, 0, 48)
tabsFrame.BackgroundTransparency = 1

-- Divider vertikal (antara tabs dan content)
local verticalLine = Instance.new("Frame", mainFrame)
verticalLine.Size = UDim2.new(0, 1, 1, -100)
verticalLine.Position = UDim2.new(0, 145, 0, 54.3)
verticalLine.BackgroundColor3 = Color3.fromRGB(70,70,80)
verticalLine.BorderSizePixel = 0

-- Tabs + Search
local tabButtons = {}
local tabContentFrames = {}
local currentTab = nil
local searchBox = nil

-- Koordinat tab (manual)
local tabPositions = {
    ["Main Scripts"] = UDim2.new(0, -3, 0, 20),
    ["Extra Tools"] = UDim2.new(0, -3, 0, 60),
    ["Own Script"] = UDim2.new(0, -3, 0, 100),
    ["Console"]     = UDim2.new(0, -3, 0, 140),
    ["Credits"]     = UDim2.new(0, -3, 0, 180)
}

local function switchTab(name)
    for t,frame in pairs(tabContentFrames) do
        frame.Visible = (t == name)
    end
    currentTab = name
end

-- Buat Tab Buttons
for tabName,_ in pairs(scripts) do
    local btn = Instance.new("TextButton", tabsFrame)
    btn.Size = UDim2.new(0, 120, 1, 0)
    btn.Position = tabPositions[tabName] or UDim2.new(0, 0, 0, 0)
    btn.Text = tabName
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(45,45,52)
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
    btn.MouseButton1Click:Connect(function() switchTab(tabName) end)
    tabButtons[tabName] = btn
end

-- Search bar
searchBox = Instance.new("TextBox", mainFrame)
searchBox.PlaceholderText = "search..."
searchBox.Size = UDim2.new(1, -357, 0, 20)
searchBox.Position = UDim2.new(0, 276, 0, 13)
searchBox.BackgroundTransparency = 1
searchBox.TextColor3 = Color3.new(1,1,1)
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 14
searchBox.Text = ""
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0,6)
searchBox.Visible = true

-- Tab contents
local consoleOutput
local consoleScrollingFrame -- FIX: Tambahkan ScrollingFrame untuk console
local movementDropdownOpen = false
local movementDropdownFrame

-- FIX: Fungsi untuk update console dengan auto-scroll
local function updateConsole(text)
    consoleOutput.Text = text
    -- Auto-scroll ke bawah
    task.wait(0.05) -- Tunggu sebentar untuk render
    if consoleScrollingFrame then
        consoleScrollingFrame.CanvasPosition = Vector2.new(0, consoleOutput.TextBounds.Y + 100)
    end
end

local function appendToConsole(newText)
    consoleOutput.Text = consoleOutput.Text .. newText
    -- Auto-scroll ke bawah
    task.wait(0.05) -- Tunggu sebentar untuk render
    if consoleScrollingFrame then
        consoleScrollingFrame.CanvasPosition = Vector2.new(0, consoleOutput.TextBounds.Y + 100)
    end
end

local function createTabContent(tabName, data)
    local offsetY = (tabName == "Main Scripts" or tabName == "Extra Tools" or tabName == "Own Script" or tabName == "Console") and 68.1 or 120
    local contentFrame = Instance.new("Frame", mainFrame)
    contentFrame.Size = UDim2.new(1, -170, 1, -offsetY)
    contentFrame.Position = UDim2.new(0, 154, 0, offsetY)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Visible = false
    tabContentFrames[tabName] = contentFrame

    if tabName == "Console" then  
        -- FIX: Gunakan ScrollingFrame untuk console
        consoleScrollingFrame = Instance.new("ScrollingFrame", contentFrame)
        consoleScrollingFrame.Size = UDim2.new(1, -10, 1, -10)
        consoleScrollingFrame.Position = UDim2.new(0, 5, 0, 5)
        consoleScrollingFrame.BackgroundColor3 = Color3.fromRGB(20,20,25)
        consoleScrollingFrame.BorderSizePixel = 0
        consoleScrollingFrame.ScrollBarThickness = 8
        consoleScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y -- FIX: Auto size
        Instance.new("UICorner", consoleScrollingFrame).CornerRadius = UDim.new(0,6)
        
        consoleOutput = Instance.new("TextLabel", consoleScrollingFrame)
        consoleOutput.Size = UDim2.new(1, -10, 0, 0)
        consoleOutput.Position = UDim2.new(0, 5, 0, 5)
        consoleOutput.BackgroundTransparency = 1
        consoleOutput.TextColor3 = Color3.new(1,1,1)
        consoleOutput.Font = Enum.Font.Code
        consoleOutput.TextSize = 14
        consoleOutput.TextXAlignment = Enum.TextXAlignment.Left
        consoleOutput.TextYAlignment = Enum.TextYAlignment.Top
        consoleOutput.TextWrapped = true
        consoleOutput.Text = ">> Console ready...\n"
        consoleOutput.TextStrokeTransparency = 0.8
        consoleOutput.AutomaticSize = Enum.AutomaticSize.Y -- FIX: Auto size text label
        
    elseif tabName == "Extra Tools" then  
        -- UIListLayout untuk mengatur button  
        local listLayout = Instance.new("UIListLayout", contentFrame)  
        listLayout.Padding = UDim.new(0,6)  
          
        -- Movement Controls Dropdown Button  
        local movementDropdownBtn = Instance.new("TextButton", contentFrame)  
        movementDropdownBtn.Size = UDim2.new(1, 0, 0, 36)  
        movementDropdownBtn.Text = "Movement Controls"  
        movementDropdownBtn.Font = Enum.Font.GothamSemibold  
        movementDropdownBtn.TextSize = 14  
        movementDropdownBtn.TextColor3 = Color3.new(1,1,1)  
        movementDropdownBtn.BackgroundColor3 = Color3.fromRGB(50,50,60)  
        movementDropdownBtn.BorderSizePixel = 0  
        Instance.new("UICorner", movementDropdownBtn).CornerRadius = UDim.new(0,6)  
          
        -- Movement Controls Dropdown Content  
        movementDropdownFrame = Instance.new("Frame", contentFrame)  
        movementDropdownFrame.Size = UDim2.new(1, 0, 0, 0)  
        movementDropdownFrame.Position = UDim2.new(0, 0, 0, 42)  
        movementDropdownFrame.BackgroundColor3 = Color3.fromRGB(40,40,45)  
        movementDropdownFrame.BorderSizePixel = 0  
        movementDropdownFrame.ClipsDescendants = true  
        Instance.new("UICorner", movementDropdownFrame).CornerRadius = UDim.new(0,6)  
        movementDropdownFrame.Visible = false  
          
        -- WalkSpeed Control  
        local walkSpeedFrame = Instance.new("Frame", movementDropdownFrame)  
        walkSpeedFrame.Size = UDim2.new(1, -10, 0, 30)  
        walkSpeedFrame.Position = UDim2.new(0, 5, 0, 5)  
        walkSpeedFrame.BackgroundTransparency = 1  
          
        local walkSpeedLabel = Instance.new("TextLabel", walkSpeedFrame)  
        walkSpeedLabel.Size = UDim2.new(0.4, 0, 1, 0)  
        walkSpeedLabel.Position = UDim2.new(0.4, -87, 0, 0)  
        walkSpeedLabel.Text = "WalkSpeed:"  
        walkSpeedLabel.TextColor3 = Color3.new(1,1,1)  
        walkSpeedLabel.BackgroundTransparency = 1  
        walkSpeedLabel.Font = Enum.Font.Gotham  
        walkSpeedLabel.TextSize = 12  
        walkSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left  
          
        local walkSpeedBox = Instance.new("TextBox", walkSpeedFrame)  
        walkSpeedBox.Size = UDim2.new(0.3, 0, 1, 0)  
        walkSpeedBox.Position = UDim2.new(0.4, 5, 0, 0)  
        walkSpeedBox.Text = tostring(WalkSpeedValue)  
        walkSpeedBox.BackgroundColor3 = Color3.fromRGB(60,60,70)  
        walkSpeedBox.TextColor3 = Color3.new(1,1,1)  
        walkSpeedBox.Font = Enum.Font.Gotham  
        walkSpeedBox.TextSize = 12  
        Instance.new("UICorner", walkSpeedBox).CornerRadius = UDim.new(0,4)  
          
        local walkSpeedBtn = Instance.new("TextButton", walkSpeedFrame)  
        walkSpeedBtn.Size = UDim2.new(0.25, -5, 1, 0)  
        walkSpeedBtn.Position = UDim2.new(0.75, 5, 0, 0)  
        walkSpeedBtn.Text = "Apply"  
        walkSpeedBtn.BackgroundColor3 = Color3.fromRGB(60,120,200)  
        walkSpeedBtn.TextColor3 = Color3.new(1,1,1)  
        walkSpeedBtn.Font = Enum.Font.GothamSemibold  
        walkSpeedBtn.TextSize = 12  
        Instance.new("UICorner", walkSpeedBtn).CornerRadius = UDim.new(0,4)  
          
        walkSpeedBtn.MouseButton1Click:Connect(function()  
            local ws = tonumber(walkSpeedBox.Text)  
            if ws then  
                updateWalkSpeed(ws)  
                appendToConsole(">> WalkSpeed set to "..ws.."\n")  
                notify("Movement", "WalkSpeed: "..ws, 2)  
            end  
        end)  
          
        -- JumpPower Control  
        local jumpPowerFrame = Instance.new("Frame", movementDropdownFrame)  
        jumpPowerFrame.Size = UDim2.new(1, -10, 0, 30)  
        jumpPowerFrame.Position = UDim2.new(0, 5, 0, 40)  
        jumpPowerFrame.BackgroundTransparency = 1  
          
        local jumpPowerLabel = Instance.new("TextLabel", jumpPowerFrame)  
        jumpPowerLabel.Size = UDim2.new(0.4, 0, 1, 0)  
        jumpPowerLabel.Position = UDim2.new(0.4, -90, 0, 0)  
        jumpPowerLabel.Text = "JumpPower:"  
        jumpPowerLabel.TextColor3 = Color3.new(1,1,1)  
        jumpPowerLabel.BackgroundTransparency = 1  
        jumpPowerLabel.Font = Enum.Font.Gotham  
        jumpPowerLabel.TextSize = 12  
        jumpPowerLabel.TextXAlignment = Enum.TextXAlignment.Left  
          
        local jumpPowerBox = Instance.new("TextBox", jumpPowerFrame)  
        jumpPowerBox.Size = UDim2.new(0.3, 0, 1, 0)  
        jumpPowerBox.Position = UDim2.new(0.4, 5, 0, 0)  
        jumpPowerBox.Text = tostring(JumpPowerValue)  
        jumpPowerBox.BackgroundColor3 = Color3.fromRGB(60,60,70)  
        jumpPowerBox.TextColor3 = Color3.new(1,1,1)  
        jumpPowerBox.Font = Enum.Font.Gotham  
        jumpPowerBox.TextSize = 12  
        Instance.new("UICorner", jumpPowerBox).CornerRadius = UDim.new(0,4)  
          
        local jumpPowerBtn = Instance.new("TextButton", jumpPowerFrame)  
        jumpPowerBtn.Size = UDim2.new(0.25, -5, 1, 0)  
        jumpPowerBtn.Position = UDim2.new(0.75, 5, 0, 0)  
        jumpPowerBtn.Text = "Apply"  
        jumpPowerBtn.BackgroundColor3 = Color3.fromRGB(60,120,200)  
        jumpPowerBtn.TextColor3 = Color3.new(1,1,1)  
        jumpPowerBtn.Font = Enum.Font.GothamSemibold  
        jumpPowerBtn.TextSize = 12  
        Instance.new("UICorner", jumpPowerBtn).CornerRadius = UDim.new(0,4)  
          
        jumpPowerBtn.MouseButton1Click:Connect(function()  
            local jp = tonumber(jumpPowerBox.Text)  
            if jp then  
                updateJumpPower(jp)  
                appendToConsole(">> JumpPower set to "..jp.."\n")  
                notify("Movement", "JumpPower: "..jp, 2)  
            end  
        end)  
          
        -- Infinity Jump Toggle  
        local infJumpBtn = Instance.new("TextButton", movementDropdownFrame)  
        infJumpBtn.Size = UDim2.new(1, -10, 0, 30)  
        infJumpBtn.Position = UDim2.new(0, 5, 0, 75)  
        infJumpBtn.Text = "Infinity Jump: OFF"  
        infJumpBtn.BackgroundColor3 = Color3.fromRGB(80,80,90)  
        infJumpBtn.TextColor3 = Color3.new(1,1,1)  
        infJumpBtn.Font = Enum.Font.GothamSemibold  
        infJumpBtn.TextSize = 12  
        Instance.new("UICorner", infJumpBtn).CornerRadius = UDim.new(0,6)  
          
        infJumpBtn.MouseButton1Click:Connect(function()  
            infJump = not infJump  
            infJumpBtn.Text = "Infinity Jump: " .. (infJump and "ON" or "OFF")  
            infJumpBtn.BackgroundColor3 = infJump and Color3.fromRGB(60,180,80) or Color3.fromRGB(80,80,90)  
            appendToConsole(">> Infinity Jump: "..(infJump and "ON" or "OFF").."\n")  
            notify("Movement", "Infinity Jump "..(infJump and "ON" or "OFF"), 2)  
        end)  
          
        -- Presets  
        local preset1Btn = Instance.new("TextButton", movementDropdownFrame)  
        preset1Btn.Size = UDim2.new(1, -178, 0, 28)  
        preset1Btn.Position = UDim2.new(0, 5, 0, 110)  
        preset1Btn.Text = "Default"  
        preset1Btn.BackgroundColor3 = Color3.fromRGB(70,70,80)  
        preset1Btn.TextColor3 = Color3.new(1,1,1)  
        preset1Btn.Font = Enum.Font.Gotham  
        preset1Btn.TextSize = 13  
        Instance.new("UICorner", preset1Btn).CornerRadius = UDim.new(0,4)  
          
        preset1Btn.MouseButton1Click:Connect(function()  
            updateWalkSpeed(16)  
            updateJumpPower(50)  
            infJump = false  
            walkSpeedBox.Text = "16"  
            jumpPowerBox.Text = "50"  
            infJumpBtn.Text = "Infinity Jump: OFF"  
            infJumpBtn.BackgroundColor3 = Color3.fromRGB(80,80,90)  
            appendToConsole(">> Movement preset: Default\n")  
            notify("Movement", "Default preset applied", 2)  
        end)  
          
        local preset2Btn = Instance.new("TextButton", movementDropdownFrame)  
        preset2Btn.Size = UDim2.new(1, -178, 0, 28)  
        preset2Btn.Position = UDim2.new(0, 173, 0, 110) -- sejajar dengan Default  
        preset2Btn.Text = "Ngibrits"  
        preset2Btn.BackgroundColor3 = Color3.fromRGB(70,70,80)  
        preset2Btn.TextColor3 = Color3.new(1,1,1)  
        preset2Btn.Font = Enum.Font.Gotham  
        preset2Btn.TextSize = 13  
        Instance.new("UICorner", preset2Btn).CornerRadius = UDim.new(0,4)  
          
        preset2Btn.MouseButton1Click:Connect(function()  
            updateWalkSpeed(50)  
            updateJumpPower(75)  
            infJump = true  
            walkSpeedBox.Text = "50"  
            jumpPowerBox.Text = "75"  
            infJumpBtn.Text = "Infinity Jump: ON"  
            infJumpBtn.BackgroundColor3 = Color3.fromRGB(60,180,80)  
            appendToConsole(">> Movement preset: Ngibrits\n")  
            notify("Movement", "Ngibrits preset applied", 2)  
        end)  
          
        -- Dropdown toggle functionality  
        movementDropdownBtn.MouseButton1Click:Connect(function()  
            movementDropdownOpen = not movementDropdownOpen  
              
            if movementDropdownOpen then  
                movementDropdownBtn.Text = "Movement Controls"  
                movementDropdownFrame.Size = UDim2.new(1, 0, 0, 170)  
                movementDropdownFrame.Visible = true  
            else  
                movementDropdownBtn.Text = "Movement Controls"  
                movementDropdownFrame.Size = UDim2.new(1, 0, 0, 0)  
                movementDropdownFrame.Visible = false  
            end  
        end)  
          
        -- Fly Button  
        local flyBtn = Instance.new("TextButton", contentFrame)  
        flyBtn.Size = UDim2.new(1, 0, 0, 36)  
        flyBtn.Text = "Fly"  
        flyBtn.Font = Enum.Font.GothamSemibold  
        flyBtn.TextSize = 14  
        flyBtn.TextColor3 = Color3.new(1,1,1)  
        flyBtn.BackgroundColor3 = Color3.fromRGB(50,50,60)  
        flyBtn.BorderSizePixel = 0  
        Instance.new("UICorner", flyBtn).CornerRadius = UDim.new(0,6)  
          
        flyBtn.MouseButton1Click:Connect(function()  
            appendToConsole(">> Loading Fly Script...\n")  
            local ok,msg = fetchAndRun("https://raw.githubusercontent.com/noirexe/GYkHTrZSc5W/refs/heads/main/sc-free-ko-dijual-awoakowk.lua")      
            if ok then      
                appendToConsole(">> Fly script loaded!\n")      
                notify("XuKrost Hub", "Fly script success",3)      
            else      
                appendToConsole(">> Fly script failed: "..tostring(msg).."\n")      
                notify("XuKrost Hub", "Fly script failed: "..tostring(msg),5)      
            end      
        end)

        -- Remove Network Pause Button
        local removeNetworkPauseBtn = Instance.new("TextButton", contentFrame)  
        removeNetworkPauseBtn.Size = UDim2.new(1, 0, 0, 36)  
        removeNetworkPauseBtn.Text = "Remove Network Pause"  
        removeNetworkPauseBtn.Font = Enum.Font.GothamSemibold  
        removeNetworkPauseBtn.TextSize = 14  
        removeNetworkPauseBtn.TextColor3 = Color3.new(1,1,1)  
        removeNetworkPauseBtn.BackgroundColor3 = Color3.fromRGB(50,50,60)  
        removeNetworkPauseBtn.BorderSizePixel = 0  
        Instance.new("UICorner", removeNetworkPauseBtn).CornerRadius = UDim.new(0,6)  
          
        removeNetworkPauseBtn.MouseButton1Click:Connect(function()  
            appendToConsole(">> Removing Network Pause...\n")  
            
            local success, result = removeNetworkPause()
            
            if success then
                appendToConsole(">> " .. result .. "\n")  
                notify("Network Pause", "Removed successfully!", 3)  
            else
                appendToConsole(">> Failed: " .. tostring(result) .. "\n")  
                notify("Network Pause", "Failed to remove!", 3)  
            end
        end)
          
    elseif tabName == "Own Script" then
        -- Teleport Manager UI
        
        -- Save Position Section
        local saveSection = Instance.new("Frame", contentFrame)
        saveSection.Size = UDim2.new(1, 0, 0, 80)
        saveSection.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        saveSection.BorderSizePixel = 0
        Instance.new("UICorner", saveSection).CornerRadius = UDim.new(0, 6)
        
        local saveLabel = Instance.new("TextLabel", saveSection)
        saveLabel.Size = UDim2.new(1, -10, 0, 20)
        saveLabel.Position = UDim2.new(0, 5, 0, 4)
        saveLabel.Text = "Save Current Position"
        saveLabel.TextColor3 = Color3.new(1, 1, 1)
        saveLabel.BackgroundTransparency = 1
        saveLabel.Font = Enum.Font.GothamSemibold
        saveLabel.TextSize = 14
        saveLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local nameInput = Instance.new("TextBox", saveSection)
        nameInput.Size = UDim2.new(0.6, -30, 0, 30)
        nameInput.Position = UDim2.new(0, 7, 0, 30)
        nameInput.PlaceholderText = "Location Name"
        nameInput.Text = ""
        nameInput.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        nameInput.TextColor3 = Color3.new(1, 1, 1)
        nameInput.Font = Enum.Font.Gotham
        nameInput.TextSize = 12
        Instance.new("UICorner", nameInput).CornerRadius = UDim.new(0, 4)
        
        local saveButton = Instance.new("TextButton", saveSection)
        saveButton.Size = UDim2.new(0.4, -8, 0, 30)
        saveButton.Position = UDim2.new(0.6, -3, 0, 29.5)
        saveButton.Text = "Save Pos"
        saveButton.BackgroundColor3 = Color3.fromRGB(60, 180, 80)
        saveButton.TextColor3 = Color3.new(1, 1, 1)
        saveButton.Font = Enum.Font.GothamSemibold
        saveButton.TextSize = 12
        Instance.new("UICorner", saveButton).CornerRadius = UDim.new(0, 4)
        
        saveButton.MouseButton1Click:Connect(function()
            local locationName = nameInput.Text:gsub("^%s*(.-)%s*$", "%1") -- Trim whitespace
            if locationName == "" then
                appendToConsole(">> Please enter a location name!\n")
                notify("Teleport", "Enter location name!", 2)
                return
            end
            
            if teleportLocations[locationName] then
                appendToConsole(">> Location name already exists!\n")
                notify("Teleport", "Name already exists!", 2)
                return
            end
            
            local currentPos = getCurrentPosition()
            if not currentPos then
                appendToConsole(">> Cannot get current position!\n")
                notify("Teleport", "Cannot get position!", 2)
                return
            end
            
            teleportLocations[locationName] = currentPos
            saveTeleportData()
            
            -- Refresh teleport list
            for _, child in ipairs(contentFrame:GetChildren()) do
                if child.Name == "TeleportScrollFrame" then
                    refreshTeleportList(child, consoleOutput)
                    break
                end
            end
            
            nameInput.Text = ""
            appendToConsole(">> Saved location: " .. locationName .. "\n")
            notify("Teleport", "Saved " .. locationName, 2)
        end)
        
        -- File Management Section
        local fileSection = Instance.new("Frame", contentFrame)
        fileSection.Size = UDim2.new(1, 0, 0, 40)
        fileSection.Position = UDim2.new(0, 0, 0, 85)
        fileSection.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        fileSection.BorderSizePixel = 0
        Instance.new("UICorner", fileSection).CornerRadius = UDim.new(0, 6)
        
        local loadButton = Instance.new("TextButton", fileSection)
        loadButton.Size = UDim2.new(0.5, -15, 0, 30)
        loadButton.Position = UDim2.new(0, 10, 0, 5)
        loadButton.Text = "Load Data"
        loadButton.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
        loadButton.TextColor3 = Color3.new(1, 1, 1)
        loadButton.Font = Enum.Font.GothamSemibold
        loadButton.TextSize = 12
        Instance.new("UICorner", loadButton).CornerRadius = UDim.new(0, 4)
        
        local clearButton = Instance.new("TextButton", fileSection)
        clearButton.Size = UDim2.new(0.5, -15, 0, 30)
        clearButton.Position = UDim2.new(0.5, 5, 0, 5)
        clearButton.Text = "Clear All"
        clearButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        clearButton.TextColor3 = Color3.new(1, 1, 1)
        clearButton.Font = Enum.Font.GothamSemibold
        clearButton.TextSize = 12
        Instance.new("UICorner", clearButton).CornerRadius = UDim.new(0, 4)
        
        loadButton.MouseButton1Click:Connect(function()
            if loadTeleportData() then
                for _, child in ipairs(contentFrame:GetChildren()) do
                    if child.Name == "TeleportScrollFrame" then
                        refreshTeleportList(child, consoleOutput)
                        break
                    end
                end
                appendToConsole(">> Teleport data loaded!\n")
                notify("Teleport", "Data loaded successfully", 2)
            else
                appendToConsole(">> No saved data found!\n")
                notify("Teleport", "No saved data", 2)
            end
        end)
        
        clearButton.MouseButton1Click:Connect(function()
            teleportLocations = {}
            saveTeleportData()
            for _, child in ipairs(contentFrame:GetChildren()) do
                if child.Name == "TeleportScrollFrame" then
                    refreshTeleportList(child, consoleOutput)
                    break
                end
            end
            appendToConsole(">> All locations cleared!\n")
            notify("Teleport", "All locations cleared", 2)
        end)
        
        -- Saved Locations Label
        local locationsLabel = Instance.new("TextLabel", contentFrame)
        locationsLabel.Size = UDim2.new(1, 0, 0, 20)
        locationsLabel.Position = UDim2.new(0, 0, 0, 130)
        locationsLabel.Text = "Saved Locations:"
        locationsLabel.TextColor3 = Color3.new(1, 1, 1)
        locationsLabel.BackgroundTransparency = 1
        locationsLabel.Font = Enum.Font.GothamSemibold
        locationsLabel.TextSize = 14
        locationsLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Scroll frame for teleport locations
        local scrollFrame = Instance.new("ScrollingFrame", contentFrame)
        scrollFrame.Size = UDim2.new(1, 0, 1, -155)
        scrollFrame.Position = UDim2.new(0, 0, 0, 155)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.BorderSizePixel = 0
        scrollFrame.ScrollBarThickness = 6
        scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y -- FIX: Auto size
        scrollFrame.Name = "TeleportScrollFrame"
        
        -- Initial load of teleport data
        loadTeleportData()
        refreshTeleportList(scrollFrame, consoleOutput)
        
    else  
        local listLayout = Instance.new("UIListLayout", contentFrame)  
        listLayout.Padding = UDim.new(0,6)  

        local buttons = {}  
        local function refreshFilter()  
            local filter = searchBox.Text:lower()  
            for name,btn in pairs(buttons) do  
                btn.Visible = (filter == "" or name:lower():find(filter))  
            end  
        end  

        for name,url in pairs(data) do  
            local btn = Instance.new("TextButton", contentFrame)  
            btn.Size = UDim2.new(1, 0, 0, 36)  
            btn.Text = name  
            btn.Font = Enum.Font.GothamSemibold  
            btn.TextSize = 14  
            btn.TextColor3 = Color3.new(1,1,1)  
            btn.BackgroundColor3 = Color3.fromRGB(50,50,60)  
            btn.BorderSizePixel = 0  
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)  

            btn.MouseButton1Click:Connect(function()  
                appendToConsole(">> Loading "..name.."\n")  
                local ok,msg = fetchAndRun(url)      
                if ok then      
                    appendToConsole(">> "..name.." loaded!\n")      
                    notify("XuKrost Hub", name.." success",3)      
                else      
                    appendToConsole(">> "..name.." failed: "..tostring(msg).."\n")      
                    notify("XuKrost Hub", name.." failed: "..tostring(msg),5)      
                end      
            end)  

            buttons[name] = btn  
        end  

        if tabName == "Main Scripts" then  
            searchBox:GetPropertyChangedSignal("Text"):Connect(refreshFilter)  
            refreshFilter()  
        end  
    end
end

for tabName,data in pairs(scripts) do
    createTabContent(tabName,data)
end

-- Default tab
switchTab("Main Scripts")

-- Bubble button (hidden by default)
local bubbleButton = Instance.new("TextButton", screenGui)
bubbleButton.Size = UDim2.new(0, 50, 0, 40)
bubbleButton.Position = UDim2.new(0.05, 0, 0.1, 0)
bubbleButton.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
bubbleButton.Text = "XHUB"
bubbleButton.Font = Enum.Font.GothamBlack
bubbleButton.TextSize = 14
bubbleButton.TextColor3 = Color3.new(1,1,1)
bubbleButton.Visible = false
bubbleButton.BorderSizePixel = 0
Instance.new("UICorner", bubbleButton).CornerRadius = UDim.new(0,6)

-- Minimize/Close actions
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    if minimized then return end
    minimized = true
    TweenService:Create(mainFrame,TweenInfo.new(0.3),{Size=UDim2.new(0,0,0,0)}):Play()
    task.delay(0.35,function()
        mainFrame.Visible = false
        bubbleButton.Visible = true
    end)
end)

bubbleButton.MouseButton1Click:Connect(function()
    bubbleButton.Visible = false
    mainFrame.Visible = true
    TweenService:Create(mainFrame,TweenInfo.new(0.3),{Size=UDim2.new(0,500,0,400)}):Play()
    minimized = false
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

notify(HubName,"✅ XuKrost Hub Successfully loaded! have fun!",4)
