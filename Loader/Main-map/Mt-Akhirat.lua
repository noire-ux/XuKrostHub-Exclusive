-- Mt.Akhirat Tab dengan GUI Custom (Tanpa One-Time dan Auto Kill)
local function CreateAkhiratGUI()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Checkpoints Mt.Akhirat
    local AkhiratCheckPoints = {
        Spawn = {x = -244, y = 121, z = 202},
        ["CheckPoint 1"] = {x = -135, y = 422, z = -216},
        ["CheckPoint 2"] = {x = -4, y = 951, z = -1054},
        ["CheckPoint 3"] = {x = 109, y = 1203, z = -1359},
        ["CheckPoint 4"] = {x = 103, y = 1467, z = -1803},
        ["CheckPoint 5"] = {x = 298, y = 1867, z = -2333},
        ["CheckPoint 6"] = {x = 560, y = 2087, z = -2556},
        ["CheckPoint 7"] = {x = 754, y = 2185, z = -2500},
        ["CheckPoint 8"] = {x = 792, y = 2329, z = -2637},
        ["CheckPoint 9"] = {x = 969, y = 2517, z = -2630},
        ["CheckPoint 10"] = {x = 1237, y = 2693, z = -2800},
        ["CheckPoint 11"] = {x = 1621, y = 3059, z = -2755},
        ["CheckPoint 12"] = {x = 1813, y = 3577, z = -3248},
        ["CheckPoint 13"] = {x = 2809, y = 4421, z = -4791},
        ["CheckPoint 14"] = {x = 3471, y = 4860, z = -4181},
        ["CheckPoint 15"] = {x = 3481, y = 5105, z = -4279},
        ["CheckPoint 16"] = {x = 3978, y = 5667, z = -3974},
        ["CheckPoint 17"] = {x = 4498, y = 5897, z = -3790},
        ["CheckPoint 18"] = {x = 4837, y = 6128, z = -3463},
        ["CheckPoint 19"] = {x = 5064, y = 6371, z = -2980},
        ["CheckPoint 20"] = {x = 5539, y = 6591, z = -2491},
        ["CheckPoint 21"] = {x = 5587, y = 6880, z = -1543},
        ["CheckPoint 22"] = {x = 5547, y = 6875, z = -1050},
        ["CheckPoint 23"] = {x = 4340, y = 7371, z = 104},
        ["CheckPoint 24"] = {x = 4330, y = 7642, z = 130},
        ["CheckPoint 25"] = {x = 3456, y = 7711, z = 939},
        Puncak = {x = 3058, y = 7877, z = 1034}
    }

    -- Urutan teleport
    local akhiratTeleportSequence = {
        "Spawn", "CheckPoint 1", "CheckPoint 2", "CheckPoint 3", "CheckPoint 4", 
        "CheckPoint 5", "CheckPoint 6", "CheckPoint 7", "CheckPoint 8", "CheckPoint 9",
        "CheckPoint 10", "CheckPoint 11", "CheckPoint 12", "CheckPoint 13", "CheckPoint 14",
        "CheckPoint 15", "CheckPoint 16", "CheckPoint 17", "CheckPoint 18", "CheckPoint 19",
        "CheckPoint 20", "CheckPoint 21", "CheckPoint 22", "CheckPoint 23", "CheckPoint 24",
        "CheckPoint 25", "Puncak"
    }

    -- Variabel state
    local isAkhiratLoopEnabled = false
    local isAkhiratAutoReturnEnabled = false
    local akhiratCurrentDelay = 5

    -- Color scheme
    local Colors = {
        Background = Color3.fromRGB(30, 30, 40),
        Primary = Color3.fromRGB(80, 120, 220),
        Secondary = Color3.fromRGB(60, 180, 100),
        Danger = Color3.fromRGB(220, 80, 80),
        Warning = Color3.fromRGB(220, 160, 60),
        Text = Color3.fromRGB(240, 240, 240),
        DarkText = Color3.fromRGB(180, 180, 180),
        Special = Color3.fromRGB(160, 100, 220) -- Warna khusus untuk Akhirat
    }

    -- Create GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MtAkhiratAutoTeleportGUI"
    screenGui.IgnoreGuiInset = true
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    -- Main Frame dengan gradient background
    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 500, 0, 400)
    frame.Position = UDim2.new(0.5, -250, 0.5, -200)
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
    title.Position = UDim2.new(0, 15, 0, 2)
    title.BackgroundTransparency = 1
    title.Text = "🚀 XuKrost Hub"
    title.TextColor3 = Colors.Special
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
    miniBtn.Position = UDim2.new(1, -76, 0, 14)
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
    bubbleBtn.Size = UDim2.new(0, 80, 0, 40)
    bubbleBtn.Position = UDim2.new(0, 20, 0.7, 0)
    bubbleBtn.Text = "🚀 XS"
    bubbleBtn.BackgroundColor3 = Colors.Special
    bubbleBtn.TextColor3 = Colors.Text
    bubbleBtn.Font = Enum.Font.GothamBold
    bubbleBtn.TextSize = 12
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
    contentFrame.Size = UDim2.new(1, -20, 1, -70)
    contentFrame.Position = UDim2.new(0, 10, 0, 60)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = frame

    -- Left side controls
    local leftFrame = Instance.new("Frame")
    leftFrame.Size = UDim2.new(0.5, -10, 1, 0)
    leftFrame.Position = UDim2.new(0, 0, 0, 0)
    leftFrame.BackgroundTransparency = 1
    leftFrame.Parent = contentFrame

    -- Loop Teleport button
    local loopToggleBtn = Instance.new("TextButton")
    loopToggleBtn.Size = UDim2.new(1, 0, 0, 35)
    loopToggleBtn.Position = UDim2.new(0, 0, 0, 8)
    loopToggleBtn.Text = "Start Loop Teleport"
    loopToggleBtn.BackgroundColor3 = Colors.Primary
    loopToggleBtn.TextColor3 = Colors.Text
    loopToggleBtn.Font = Enum.Font.GothamBold
    loopToggleBtn.TextSize = 14
    loopToggleBtn.Parent = leftFrame
    Instance.new("UICorner", loopToggleBtn).CornerRadius = UDim.new(0, 8)

    -- Auto Return toggle (Khusus Akhirat)
    local returnToggleBtn = Instance.new("TextButton")
    returnToggleBtn.Size = UDim2.new(1, 0, 0, 35)
    returnToggleBtn.Position = UDim2.new(0, 0, 0, 51)
    returnToggleBtn.Text = "Auto Return: OFF"
    returnToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    returnToggleBtn.TextColor3 = Colors.Text
    returnToggleBtn.Font = Enum.Font.GothamBold
    returnToggleBtn.TextSize = 14
    returnToggleBtn.Parent = leftFrame
    Instance.new("UICorner", returnToggleBtn).CornerRadius = UDim.new(0, 8)

    -- Delay container
    local delayContainer = Instance.new("Frame")
    delayContainer.Size = UDim2.new(1, 0, 0, 40)
    delayContainer.Position = UDim2.new(0, 0, 0, 94)
    delayContainer.BackgroundTransparency = 1
    delayContainer.Parent = leftFrame

    local delayBox = Instance.new("TextBox")
    delayBox.Size = UDim2.new(0, 80, 1, 0)
    delayBox.Position = UDim2.new(0, 100, 0, 0)
    delayBox.PlaceholderText = "Delay"
    delayBox.Text = tostring(akhiratCurrentDelay)
    delayBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    delayBox.TextColor3 = Colors.Text
    delayBox.Font = Enum.Font.Gotham
    delayBox.TextSize = 14
    delayBox.Parent = delayContainer
    Instance.new("UICorner", delayBox).CornerRadius = UDim.new(0, 6)

    local delayLabel = Instance.new("TextLabel")
    delayLabel.Size = UDim2.new(1, -90, 1, 0)
    delayLabel.Position = UDim2.new(0, 0, 0, 0)
    delayLabel.BackgroundTransparency = 1
    delayLabel.Text = "Delay (seconds):"
    delayLabel.TextColor3 = Colors.DarkText
    delayLabel.Font = Enum.Font.Gotham
    delayLabel.TextSize = 14
    delayLabel.TextXAlignment = Enum.TextXAlignment.Left
    delayLabel.Parent = delayContainer

    -- Status container
    local statusContainer = Instance.new("Frame")
    statusContainer.Size = UDim2.new(1, 0, 0, 40)
    statusContainer.Position = UDim2.new(0, 0, 1, -45)
    statusContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    statusContainer.BorderSizePixel = 0
    statusContainer.Parent = leftFrame
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

    -- Right side - Manual teleport buttons
    local rightFrame = Instance.new("Frame")
    rightFrame.Size = UDim2.new(0.5, -10, 1, 0)
    rightFrame.Position = UDim2.new(0.5, 10, 0, 0)
    rightFrame.BackgroundTransparency = 1
    rightFrame.Parent = contentFrame

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, 0, 1, -40)
    scrollFrame.Position = UDim2.new(0, 0, 0, 0)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = Colors.Special
    scrollFrame.Parent = rightFrame
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
    local importantCheckpoints = {
        "Spawn", "CheckPoint 5", "CheckPoint 10", "CheckPoint 15", 
        "CheckPoint 20", "CheckPoint 25", "Puncak"
    }
    
    for _, checkpointName in ipairs(importantCheckpoints) do
        local checkpointData = AkhiratCheckPoints[checkpointName]
        if checkpointData then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 35)
            btn.Text = "" .. checkpointName
            btn.BackgroundColor3 = Colors.Special
            btn.TextColor3 = Colors.Text
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 13
            btn.Parent = scrollFrame
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            
            btn.MouseEnter:Connect(function()
                btn.BackgroundColor3 = Color3.fromRGB(180, 120, 240)
            end)
            btn.MouseLeave:Connect(function()
                btn.BackgroundColor3 = Colors.Special
            end)

            btn.MouseButton1Click:Connect(function()
                local cp = AkhiratCheckPoints[checkpointName]
                humanoidRootPart.CFrame = CFrame.new(cp.x, cp.y, cp.z)
                statusText.Text = "Teleported to: " .. checkpointName
                statusText.TextColor3 = Colors.Special
            end)
        end
    end

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)

    -- Quick actions title
    local quickActionsTitle = Instance.new("TextLabel")
    quickActionsTitle.Size = UDim2.new(1, 0, 0, 30)
    quickActionsTitle.Position = UDim2.new(0, 0, 1, -35)
    quickActionsTitle.BackgroundTransparency = 1
    quickActionsTitle.Text = "Quick Teleport:"
    quickActionsTitle.TextColor3 = Colors.DarkText
    quickActionsTitle.TextSize = 14
    quickActionsTitle.Font = Enum.Font.GothamBold
    quickActionsTitle.TextXAlignment = Enum.TextXAlignment.Left
    quickActionsTitle.Parent = rightFrame

    -- Event handlers
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        isAkhiratLoopEnabled = false
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
        if val and val >= 4 and val <= 20 then
            akhiratCurrentDelay = val
        else
            delayBox.Text = tostring(akhiratCurrentDelay)
            statusText.Text = "Delay must be 4-20 seconds"
            statusText.TextColor3 = Colors.Warning
            task.wait(2)
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
        local checkpoint = AkhiratCheckPoints[name]
        if not checkpoint then return false end
        local rootPart = EnsureCharacterReady()
        rootPart.CFrame = CFrame.new(checkpoint.x, checkpoint.y, checkpoint.z)
        return true
    end

    -- Auto return function (Khusus Akhirat)
    local function autoReturnAkhiratFunction()
        local returnRemote = ReplicatedStorage:FindFirstChild("ReturnToSpawn")
        
        if returnRemote then
            pcall(function()
                returnRemote:FireServer()
                statusText.Text = "Auto Return successful!"
                statusText.TextColor3 = Colors.Special
            end)
        else
            statusText.Text = "Error: Return remote not found"
            statusText.TextColor3 = Colors.Danger
        end
    end

    -- Loop Teleport
    local function AkhiratLoopTeleport()
        while isAkhiratLoopEnabled do
            for _, checkpoint in ipairs(akhiratTeleportSequence) do
                if not isAkhiratLoopEnabled then break end
                
                statusText.Text = "Loop: " .. checkpoint
                statusText.TextColor3 = Colors.Primary
                TeleportToCheckpoint(checkpoint)
                
                -- Check peak actions untuk loop
                if checkpoint == "Puncak" then
                    if isAkhiratAutoReturnEnabled then
                        statusText.Text = "Summit! Auto Return in 4s"
                        statusText.TextColor3 = Colors.Special
                        task.wait(4)
                        autoReturnAkhiratFunction()
                    else
                        task.wait(akhiratCurrentDelay)
                    end
                else
                    task.wait(akhiratCurrentDelay)
                end
            end
            
            if isAkhiratLoopEnabled then
                statusText.Text = "Loop completed! Restarting..."
                statusText.TextColor3 = Colors.Warning
                task.wait(1)
            end
        end
        
        statusText.Text = "Loop teleport stopped"
        statusText.TextColor3 = Colors.Danger
    end

    -- Start/Stop Loop teleport
    loopToggleBtn.MouseButton1Click:Connect(function()
        if not isAkhiratLoopEnabled then
            isAkhiratLoopEnabled = true
            loopToggleBtn.Text = "Stop Loop Teleport"
            loopToggleBtn.BackgroundColor3 = Colors.Danger
            task.spawn(AkhiratLoopTeleport)
        else
            isAkhiratLoopEnabled = false
            loopToggleBtn.Text = "Start Loop Teleport"
            loopToggleBtn.BackgroundColor3 = Colors.Primary
        end
    end)

    -- Auto Return toggle (Khusus Akhirat)
    returnToggleBtn.MouseButton1Click:Connect(function()
        isAkhiratAutoReturnEnabled = not isAkhiratAutoReturnEnabled
        if isAkhiratAutoReturnEnabled then
            returnToggleBtn.Text = "Auto Return: ON"
            returnToggleBtn.BackgroundColor3 = Colors.Special
        else
            returnToggleBtn.Text = "Auto Return: OFF"
            returnToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
        end
    end)

    -- Handle character respawn
    player.CharacterAdded:Connect(function(newChar)
        character = newChar
        humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
        if isAkhiratLoopEnabled then
            statusText.Text = "Respawn detected, continuing..."
            statusText.TextColor3 = Colors.Primary
        else
            statusText.Text = "Respawn detected - Ready"
            statusText.TextColor3 = Colors.Secondary
        end
    end)

    print("✅ Mt.Akhirat Auto Teleport GUI loaded successfully!")
end

-- Jalankan fungsi untuk membuat GUI
CreateAkhiratGUI()
