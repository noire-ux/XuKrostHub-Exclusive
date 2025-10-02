-- Mt.Atin Tab dengan GUI Custom
local function CreateAtinGUI()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Checkpoints Mt.Atin
    local AtinCheckPoints = {
        ["Spawn"] = {x = 5, y = 12, z = -404},
        ["Pos - 1"] = {x = -184, y = 128, z = 409},
        ["Pos - 2"] = {x = -165, y = 229, z = 653},
        ["Pos - 3"] = {x = -38, y = 406, z = 616},
        ["Pos - 4"] = {x = 130, y = 651, z = 614},
        ["Pos - 5"] = {x = -247, y = 665, z = 735},
        ["Pos - 6"] = {x = -685, y = 640, z = 868},
        ["Pos - 7"] = {x = -658, y = 688, z = 1458},
        ["Pos - 8"] = {x = -508, y = 902, z = 1868},
        ["Pos - 9"] = {x = 61, y = 949, z = 2088},
        ["Pos - 10"] = {x = 52, y = 981, z = 2451},
        ["Pos - 11"] = {x = 73, y = 1096, z = 2458},
        ["Pos - 12"] = {x = 263, y = 1270, z = 2038},
        ["Pos - 13"] = {x = -419, y = 1302, z = 2395},
        ["Pos - 14"] = {x = -773, y = 1313, z = 2665},
        ["Pos - 15"] = {x = -838, y = 1474, z = 2626},
        ["Pos - 16"] = {x = -469, y = 1465, z = 2769},
        ["Pos - 17"] = {x = -468, y = 1537, z = 2837},
        ["Pos - 18"] = {x = -385, y = 1640, z = 2794},
        ["Pos - 19"] = {x = -209, y = 1665, z = 2749},
        ["Pos - 20"] = {x = -232, y = 1742, z = 2792},
        ["Pos - 21"] = {x = -425, y = 1740, z = 2799},
        ["Pos - 22"] = {x = -424, y = 1712, z = 3421},
        ["Pos - 23"] = {x = 71, y = 1718, z = 3427},
        ["Pos - 24"] = {x = 436, y = 1720, z = 3430},
        ["Pos - 25"] = {x = 626, y = 1799, z = 3433},
        ["Puncak"] = {x = 823, y = 2146, z = 3899}
    }

    -- Urutan teleport
    local atinTeleportSequence = {
        "Spawn", "Pos - 1", "Pos - 2", "Pos - 3", "Pos - 4", 
        "Pos - 5", "Pos - 6", "Pos - 7", "Pos - 8", "Pos - 9",
        "Pos - 10", "Pos - 11", "Pos - 12", "Pos - 13", "Pos - 14",
        "Pos - 15", "Pos - 16", "Pos - 17", "Pos - 18", "Pos - 19",
        "Pos - 20", "Pos - 21", "Pos - 22", "Pos - 23", "Pos - 24",
        "Pos - 25", "Puncak"
    }

    -- Variabel state
    local isAtinAutoTeleporting = false
    local isAtinAutoRejoinEnabled = false
    local atinCurrentDelay = 3

    -- Color scheme
    local Colors = {
        Background = Color3.fromRGB(30, 30, 40),
        Primary = Color3.fromRGB(80, 120, 220),
        Secondary = Color3.fromRGB(60, 180, 100),
        Danger = Color3.fromRGB(220, 80, 80),
        Warning = Color3.fromRGB(220, 160, 60),
        Text = Color3.fromRGB(240, 240, 240),
        DarkText = Color3.fromRGB(180, 180, 180)
    }

    -- Create GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MtAtinAutoTeleportGUI"
    screenGui.IgnoreGuiInset = true
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    -- Main Frame dengan gradient background
    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 430, 0, 235)
    frame.Position = UDim2.new(0, 20, 0.5, -225)
    frame.BackgroundColor3 = Colors.Background
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = screenGui
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 35))
    })
    gradient.Rotation = 45
    gradient.Parent = frame
    
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 12)

    -- Header dengan efek glassmorphism
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 50)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    header.BackgroundTransparency = 0.9
    header.BorderSizePixel = 0
    header.Parent = frame
    
    local headerCorner = Instance.new("UICorner", header)
    headerCorner.CornerRadius = UDim.new(0, 12)
    
    local headerStroke = Instance.new("UIStroke", header)
    headerStroke.Color = Color3.fromRGB(255, 255, 255)
    headerStroke.Thickness = 0.5
    headerStroke.Transparency = 0.8

    -- Title dengan ikon
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 2)
    title.BackgroundTransparency = 1
    title.Text = "🚀 XuKrost Hub"
    title.TextColor3 = Colors.Text
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 25)
    closeBtn.Position = UDim2.new(1, -38, 0, 14)
    closeBtn.Text = "✖"
    closeBtn.BackgroundColor3 = Colors.Danger
    closeBtn.TextColor3 = Colors.Text
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.Parent = header
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
    
    closeBtn.MouseEnter:Connect(function()
        closeBtn.BackgroundColor3 = Color3.fromRGB(240, 80, 80)
    end)
    closeBtn.MouseLeave:Connect(function()
        closeBtn.BackgroundColor3 = Colors.Danger
    end)

    -- Minimize button
    local miniBtn = Instance.new("TextButton")
    miniBtn.Size = UDim2.new(0, 30, 0, 25)
    miniBtn.Position = UDim2.new(0, 355, 0, 14)
    miniBtn.Text = "—"
    miniBtn.BackgroundColor3 = Colors.Primary
    miniBtn.TextColor3 = Colors.Text
    miniBtn.Font = Enum.Font.GothamBold
    miniBtn.TextSize = 16
    miniBtn.Parent = header
    Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 6)
    
    miniBtn.MouseEnter:Connect(function()
        miniBtn.BackgroundColor3 = Color3.fromRGB(100, 140, 240)
    end)
    miniBtn.MouseLeave:Connect(function()
        miniBtn.BackgroundColor3 = Colors.Primary
    end)

    -- Bubble button (minimized state)
    local bubbleBtn = Instance.new("TextButton")
    bubbleBtn.Size = UDim2.new(0, 60, 0, 40)
    bubbleBtn.Position = UDim2.new(0, 20, 0.7, 0)
    bubbleBtn.Text = "🏔️ Mt.Atin"
    bubbleBtn.BackgroundColor3 = Colors.Primary
    bubbleBtn.TextColor3 = Colors.Text
    bubbleBtn.Font = Enum.Font.GothamBold
    bubbleBtn.TextSize = 14
    bubbleBtn.Visible = false
    bubbleBtn.Active = true
    bubbleBtn.Draggable = true
    bubbleBtn.Parent = screenGui
    Instance.new("UICorner", bubbleBtn).CornerRadius = UDim.new(0, 10)
    
    local bubbleStroke = Instance.new("UIStroke", bubbleBtn)
    bubbleStroke.Color = Color3.fromRGB(255, 255, 255)
    bubbleStroke.Thickness = 1.5

    -- Container untuk konten utama
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -100, 1, -70)
    contentFrame.Position = UDim2.new(0, 10, 0, 60)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = frame

    -- Start/Stop button
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(1, -170, 0, 35)
    toggleBtn.Position = UDim2.new(0, 0, 0, 8)
    toggleBtn.Text = "Start Auto Teleport"
    toggleBtn.BackgroundColor3 = Colors.Secondary
    toggleBtn.TextColor3 = Colors.Text
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 16
    toggleBtn.Parent = contentFrame
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)
    
    local toggleStroke = Instance.new("UIStroke", toggleBtn)
    toggleStroke.Color = Color3.fromRGB(255, 255, 255)
    toggleStroke.Thickness = 1

    -- Auto Rejoin toggle
    local rejoinToggleBtn = Instance.new("TextButton")
    rejoinToggleBtn.Size = UDim2.new(1, -170, 0, 35)
    rejoinToggleBtn.Position = UDim2.new(0, 0, 0, 51)
    rejoinToggleBtn.Text = "Auto Rejoin: OFF"
    rejoinToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    rejoinToggleBtn.TextColor3 = Colors.Text
    rejoinToggleBtn.Font = Enum.Font.GothamBold
    rejoinToggleBtn.TextSize = 14
    rejoinToggleBtn.Parent = contentFrame
    Instance.new("UICorner", rejoinToggleBtn).CornerRadius = UDim.new(0, 8)

    -- Delay container
    local delayContainer = Instance.new("Frame")
    delayContainer.Size = UDim2.new(1, 0, 0, 40)
    delayContainer.Position = UDim2.new(0, 0, 0, 110)
    delayContainer.BackgroundTransparency = 1
    delayContainer.Parent = contentFrame

    local delayBox = Instance.new("TextBox")
    delayBox.Size = UDim2.new(0, 80, 1, -9.3)
    delayBox.Position = UDim2.new(0, 79, 0, -15)
    delayBox.PlaceholderText = "Delay"
    delayBox.Text = tostring(atinCurrentDelay)
    delayBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    delayBox.TextColor3 = Colors.Text
    delayBox.Font = Enum.Font.Gotham
    delayBox.TextSize = 14
    delayBox.Parent = delayContainer
    Instance.new("UICorner", delayBox).CornerRadius = UDim.new(0, 6)

    local delayLabel = Instance.new("TextLabel")
    delayLabel.Size = UDim2.new(1, -90, 1, 0)
    delayLabel.Position = UDim2.new(0, 20, 0, -19)
    delayLabel.BackgroundTransparency = 1
    delayLabel.Text = "Detik:"
    delayLabel.TextColor3 = Colors.DarkText
    delayLabel.Font = Enum.Font.Gotham
    delayLabel.TextSize = 13
    delayLabel.TextXAlignment = Enum.TextXAlignment.Left
    delayLabel.Parent = delayContainer

    -- Scrolling frame untuk manual teleport
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -90, 0, 130)
    scrollFrame.Position = UDim2.new(0, 172, 0, 0)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = Colors.Primary
    scrollFrame.Parent = contentFrame
    Instance.new("UICorner", scrollFrame).CornerRadius = UDim.new(0, 8)

    local layout = Instance.new("UIListLayout", scrollFrame)
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local padding = Instance.new("UIPadding", scrollFrame)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingBottom = UDim.new(0, 8)

    -- Manual teleport buttons untuk checkpoints penting
    local importantCheckpoints = {"Spawn", "Pos - 1", "Pos - 2", "Pos - 3", "Pos - 4", "Pos - 5", "Pos - 6", "Pos - 7", "Pos - 8", "Pos - 9", "Pos - 10", "Pos - 11", "Pos - 12", "Pos - 13", "Pos - 14", "Pos - 15", "Pos - 16", "Pos - 17", "Pos - 18", "Pos - 19", "Pos - 20", "Pos - 21", "Pos - 22", "Pos - 23", "Pos - 24", "Pos - 25", "Puncak"}
    
    for _, checkpointName in ipairs(importantCheckpoints) do
        local checkpointData = AtinCheckPoints[checkpointName]
        if checkpointData then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 35)
            btn.Text = "" .. checkpointName
            btn.BackgroundColor3 = Colors.Primary
            btn.TextColor3 = Colors.Text
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 13
            btn.Parent = scrollFrame
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            
            btn.MouseEnter:Connect(function()
                btn.BackgroundColor3 = Color3.fromRGB(100, 140, 240)
            end)
            btn.MouseLeave:Connect(function()
                btn.BackgroundColor3 = Colors.Primary
            end)

            btn.MouseButton1Click:Connect(function()
                local cp = AtinCheckPoints[checkpointName]
                humanoidRootPart.CFrame = CFrame.new(cp.x, cp.y, cp.z)
            end)
        end
    end

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)

    -- Container untuk status dan Discord button
    local bottomContainer = Instance.new("Frame")
    bottomContainer.Size = UDim2.new(1, -106, 0, 30)
    bottomContainer.Position = UDim2.new(0, 180, 1, -29)
    bottomContainer.BackgroundTransparency = 1
    bottomContainer.Parent = contentFrame

    -- Status container
    local statusContainer = Instance.new("Frame")
    statusContainer.Size = UDim2.new(0.6, -5, 1, 0)
    statusContainer.Position = UDim2.new(0, 0, 0, 0)
    statusContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    statusContainer.BorderSizePixel = 0
    statusContainer.Parent = bottomContainer
    Instance.new("UICorner", statusContainer).CornerRadius = UDim.new(0, 8)

    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, -10, 1, 0)
    statusText.Position = UDim2.new(0, 5, 0, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = "Status: Ready"
    statusText.TextColor3 = Colors.Secondary
    statusText.TextSize = 13
    statusText.Font = Enum.Font.Gotham
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.Parent = statusContainer

    -- Discord button
    local discordBtn = Instance.new("TextButton")
    discordBtn.Size = UDim2.new(0.4, -5, 1, 0)
    discordBtn.Position = UDim2.new(0.6, 5, 0, 0)
    discordBtn.Text = "Discord"
    discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    discordBtn.TextColor3 = Colors.Text
    discordBtn.Font = Enum.Font.GothamBold
    discordBtn.TextSize = 13
    discordBtn.Parent = bottomContainer
    Instance.new("UICorner", discordBtn).CornerRadius = UDim.new(0, 8)

    discordBtn.MouseEnter:Connect(function()
        discordBtn.BackgroundColor3 = Color3.fromRGB(108, 121, 262)
    end)
    discordBtn.MouseLeave:Connect(function()
        discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    end)

    -- Event handlers
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        isAtinAutoTeleporting = false
    end)

    miniBtn.MouseButton1Click:Connect(function()
        frame.Visible = false
        bubbleBtn.Visible = true
    end)

    bubbleBtn.MouseButton1Click:Connect(function()
        frame.Visible = true
        bubbleBtn.Visible = false
    end)

    -- Update delay
    delayBox.FocusLost:Connect(function(enterPressed)
        local val = tonumber(delayBox.Text)
        if val and val > 0 then
            atinCurrentDelay = val
        else
            delayBox.Text = tostring(atinCurrentDelay)
        end
    end)

    -- Discord button handler
    discordBtn.MouseButton1Click:Connect(function()
        local discordLink = "https://discord.gg/RpYcMdzzwd"
        
        pcall(function()
            setclipboard(discordLink)
        end)
        
        statusText.Text = "Discord link copied!"
        statusText.TextColor3 = Colors.Primary
        
        task.wait(3)
        if isAtinAutoTeleporting then
            statusText.Text = "Status: Running..."
            statusText.TextColor3 = Colors.Warning
        else
            statusText.Text = "Status: Ready"
            statusText.TextColor3 = Colors.Secondary
        end
    end)

    -- Teleport function
    local function EnsureCharacterReady()
        character = player.Character or player.CharacterAdded:Wait()
        humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        return humanoidRootPart
    end

    local function TeleportToCheckpoint(name)
        local checkpoint = AtinCheckPoints[name]
        if not checkpoint then return false end
        local rootPart = EnsureCharacterReady()
        rootPart.CFrame = CFrame.new(checkpoint.x, checkpoint.y, checkpoint.z)
        return true
    end

    -- Auto rejoin function
    local function rejoinServer()
        local ts = game:GetService("TeleportService")
        local placeId = game.PlaceId
        local player = game.Players.LocalPlayer
        
        ts:Teleport(placeId, player)
    end

    -- Auto teleport loop
    local function AtinAutoTeleport()
        while isAtinAutoTeleporting and RunService.Heartbeat:Wait() do
            for _, checkpoint in ipairs(atinTeleportSequence) do
                if not isAtinAutoTeleporting then break end
                
                statusText.Text = "Status: " .. checkpoint
                statusText.TextColor3 = Colors.Warning
                TeleportToCheckpoint(checkpoint)
                
                -- Check if reached peak and handle auto rejoin
                if checkpoint == "Puncak" then
                    if isAtinAutoRejoinEnabled then
                        statusText.Text = "Status: Summit Reached, Auto rejoin 2s"
                        statusText.TextColor3 = Colors.Danger
                        task.wait(2)
                        rejoinServer()
                    else
                        for _ = 1, atinCurrentDelay do
                            if not isAtinAutoTeleporting then break end
                            task.wait(1)
                        end
                    end
                else
                    for _ = 1, atinCurrentDelay do
                        if not isAtinAutoTeleporting then break end
                        task.wait(1)
                    end
                end
            end
            
            -- If loop completes and still enabled, show completion message
            if isAtinAutoTeleporting then
                statusText.Text = "Status: Auto teleport completed!"
                statusText.TextColor3 = Colors.Secondary
                task.wait(2)
            end
        end
        
        if not isAtinAutoTeleporting then
            statusText.Text = "Status: Auto Teleport Berhenti"
            statusText.TextColor3 = Colors.Danger
            toggleBtn.Text = "Start Auto Teleport"
            toggleBtn.BackgroundColor3 = Colors.Secondary
        end
    end

    -- Start/Stop auto teleport
    toggleBtn.MouseButton1Click:Connect(function()
        if not isAtinAutoTeleporting then
            isAtinAutoTeleporting = true
            toggleBtn.Text = "Auto Teleport: OFF"
            toggleBtn.BackgroundColor3 = Colors.Danger
            task.spawn(AtinAutoTeleport)
        else
            isAtinAutoTeleporting = false
        end
    end)

    -- Auto Rejoin toggle
    rejoinToggleBtn.MouseButton1Click:Connect(function()
        isAtinAutoRejoinEnabled = not isAtinAutoRejoinEnabled
        if isAtinAutoRejoinEnabled then
            rejoinToggleBtn.Text = "Auto Rejoin: ON"
            rejoinToggleBtn.BackgroundColor3 = Colors.Secondary
        else
            rejoinToggleBtn.Text = "Auto Rejoin: OFF"
            rejoinToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
        end
    end)

    -- Handle character respawn
    player.CharacterAdded:Connect(function(newChar)
        character = newChar
        humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
        statusText.Text = "Status: Respawn terdeteksi"
        statusText.TextColor3 = Colors.Primary
        isAtinAutoTeleporting = false
    end)

    print("✅ XuKrost Hub GUI loaded successfully!")
end

-- Jalankan fungsi untuk membuat GUI
CreateAtinGUI()