local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Notification helper
local function showNotification(text)
  local notifGui = Instance.new("ScreenGui", game.CoreGui)
  notifGui.Name = "KeyNotifGui"
  local frame = Instance.new("Frame", notifGui)
  frame.Size = UDim2.fromOffset(200, 40)
  frame.Position = UDim2.new(1, -210, 1, -50)
  frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
  frame.BackgroundTransparency = 0.2
  frame.BorderSizePixel = 0
  frame.ZIndex = 10
  local corner = Instance.new("UICorner", frame)
  corner.CornerRadius = UDim.new(0, 8)
  local label = Instance.new("TextLabel", frame)
  label.Size = UDim2.new(1, -10, 1, -10)
  label.Position = UDim2.fromOffset(5, 5)
  label.BackgroundTransparency = 1
  label.Font = Enum.Font.Gotham
  label.TextSize = 14
  label.TextColor3 = Color3.new(1,1,1)
  label.Text = text
  label.TextWrapped = true
  label.ZIndex = 11

  local tweenIn = TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 0})
  tweenIn:Play()
  delay(2, function()
    local tweenOut = TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 1})
    tweenOut:Play()
    tweenOut.Completed:Wait()
    notifGui:Destroy()
  end)
end

local keyFile = "key_accepted.txt"
local function fileExists(name)
  return pcall(function() readfile(name) end)
end
local function markKeyAccepted()
  if writefile then
    writefile(keyFile, "accepted")
  end
end
local function isKeyAccepted()
  if fileExists(keyFile) then
    return readfile(keyFile) == "accepted"
  end
  return false
end

if not isKeyAccepted() then
  local keyGui = Instance.new("ScreenGui", game.CoreGui)
  keyGui.Name = "KeyGui"
  
  local frame = Instance.new("Frame", keyGui)
  frame.Size = UDim2.fromOffset(300, 140)
  frame.Position = UDim2.new(0.5, -150, 0.4, -70)
  frame.BackgroundColor3 = Color3.fromRGB(31,31,53)
  frame.BorderSizePixel = 0
  frame.ZIndex = 1
  local function corner(o) local c=Instance.new("UICorner",o); c.CornerRadius=UDim.new(0,10) end
  corner(frame)
  
  local closeBtn = Instance.new("TextButton", frame)
  closeBtn.Size = UDim2.new(0, 24, 0, 24)
  closeBtn.Position = UDim2.new(1, -28, 0, 4)
  closeBtn.Text = "X"
  closeBtn.Font = Enum.Font.GothamBold
  closeBtn.TextSize = 18
  closeBtn.TextColor3 = Color3.new(1,1,1)
  closeBtn.BackgroundColor3 = Color3.fromRGB(80,80,120)
  corner(closeBtn)
  closeBtn.MouseButton1Click:Connect(function()
    keyGui:Destroy()
  end)

  local title = Instance.new("TextLabel", frame)
  title.Size = UDim2.new(1, -60, 0, 30)
  title.Position = UDim2.fromOffset(10, 10)
  title.BackgroundTransparency = 1
  title.Font = Enum.Font.GothamBold
  title.TextSize = 18
  title.TextColor3 = Color3.new(1,1,1)
  title.Text = "XuKrostHub. Key System"
  
  local input = Instance.new("TextBox", frame)
  input.Size = UDim2.new(1, -20, 0, 30)
  input.Position = UDim2.fromOffset(10, 50)
  input.PlaceholderText = "Enter your key"
  input.Text = ""
  input.TextSize = 16
  input.Font = Enum.Font.Gotham
  input.BackgroundColor3 = Color3.fromRGB(52,52,72)
  input.TextColor3 = Color3.new(1,1,1)
  corner(input)
  
  local submitBtn = Instance.new("TextButton", frame)
  submitBtn.Size = UDim2.new(0.5, -15, 0, 30)
  submitBtn.Position = UDim2.fromOffset(10, 90)
  submitBtn.Text = "Submit"
  submitBtn.Font = Enum.Font.GothamBold
  submitBtn.TextSize = 14
  submitBtn.BackgroundColor3 = Color3.fromRGB(110,212,140)
  corner(submitBtn)
  
  local getKeyBtn = Instance.new("TextButton", frame)
  getKeyBtn.Size = UDim2.new(0.5, -15, 0, 30)
  getKeyBtn.Position = UDim2.new(0.5, 5, 0, 90)
  getKeyBtn.Text = "Get Key"
  getKeyBtn.Font = Enum.Font.GothamBold
  getKeyBtn.TextSize = 14
  getKeyBtn.BackgroundColor3 = Color3.fromRGB(110,212,140)
  corner(getKeyBtn)
  
  local function validateKey(k)
    return k == "DadangKopling"
  end
  
  submitBtn.MouseButton1Click:Connect(function()
    if validateKey(input.Text) then
      markKeyAccepted()
      _G.keyAccepted = true
      keyGui:Destroy()
      showNotification("Key valid!")
    else
      showNotification("Invalid Key")
    end
  end)
  
  getKeyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
      setclipboard("dm ig: @snn2ndd_")
      showNotification("Copied to clipboard!")
    else
      showNotification("Copy failed")
    end
  end)
  
  do
    local drag, startPos, origPos
    frame.InputBegan:Connect(function(i)
      if i.UserInputType == Enum.UserInputType.MouseButton1 or
         i.UserInputType == Enum.UserInputType.Touch then
        drag = true
        startPos = i.Position
        origPos = frame.Position
        i.Changed:Connect(function()
          if i.UserInputState == Enum.UserInputState.End then
            drag = false
          end
        end)
      end
    end)
    UserInputService.InputChanged:Connect(function(i)
      if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or
                   i.UserInputType == Enum.UserInputType.Touch) then
        local delta = i.Position - startPos
        frame.Position = UDim2.new(
          origPos.X.Scale, origPos.X.Offset + delta.X,
          origPos.Y.Scale, origPos.Y.Offset + delta.Y
        )
      end
    end)
  end

  repeat wait() until _G.keyAccepted
end

print("Key accepted; initializing features...")

if game.CoreGui:FindFirstChild("AutoFishGUI") then
	game.CoreGui.AutoFishGUI:Destroy()
end

local rodOptions = {
	"Basic Rod","Party Rod","Shark Rod","Piranha Rod","Flowers Rod",
	"Thermo Rod","Trisula Rod","Feather Rod","Wave Rod","Duck Rod"
}
local currentRodIndex = 1
local rodName = rodOptions[currentRodIndex]

local REMOTE = game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("RodRemoteEvent")
local SellRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("SellItemRemoteFunction")
local VirtualInputManager = game:GetService("VirtualInputManager")
local plr = game.Players.LocalPlayer

-- Webhook Stats
local WEBHOOK_URL = "https://discord.com/api/webhooks/1422514810305773682/zDuuvrmC05rO58NHoQmzWuRQ3qVvUGrfalv8osSmjPW5-pxVqMB5LXl5MugeYdWkxh8a"

local webhookStats = {
	totalFishCaught = 0,
	totalFishSold = 0,
	startTime = tick(),
	webhookEnabled = false
}

-- Anti-AFK System
local antiAFKEnabled = true
spawn(function()
	while wait(120) do
		if antiAFKEnabled and plr.Character then
			local humanoid = plr.Character:FindFirstChild("Humanoid")
			if humanoid then
				humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	end
end)

-- Request function
local function req(body)
    local request = (http_request or request or syn and syn.request)
    if not request then 
		warn("Executor tidak support http_request")
		return false
	end
    
	local success, err = pcall(function()
		request({
			Url = WEBHOOK_URL,
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = HttpService:JSONEncode(body)
		})
	end)
	
	return success, err
end

-- Webhook Function
local function sendWebhook(fishName, fishWeight)
	if not webhookStats.webhookEnabled then 
		return 
	end
	
	local playerData = plr:FindFirstChild("PlayerData")
	if not playerData then 
		return 
	end
	
	local strikeStreak = playerData:FindFirstChild("StrikeStreak")
	local uang = playerData:FindFirstChild("Uang")
	local ikanFolder = playerData:FindFirstChild("Ikan")
	
	local strikeValue = strikeStreak and strikeStreak.Value or 0
	local moneyValue = uang and uang.Value or 0
	local fishCount = ikanFolder and #ikanFolder:GetChildren() or 0
	
	local elapsedTime = tick() - webhookStats.startTime
	local hours = math.floor(elapsedTime / 3600)
	local minutes = math.floor((elapsedTime % 3600) / 60)
	local seconds = math.floor(elapsedTime % 60)
	local farmingTime = string.format("%02d:%02d:%02d", hours, minutes, seconds)
	
	local mapName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
	local jobId = "https://www.roblox.com/games/" .. game.PlaceId .. "?jobId=" .. game.JobId
	
	local content = ""
	local embedColor = 0x3498db
	if fishWeight > 500 then
		content = "@everyone 🚨 **RARE FISH ALERT!** 🚨"
		embedColor = 0xFF0000
	else
		embedColor = 0x2ecc71
	end
	
	local body = {
		username = "👧🏻 Nahe baw ee",
		content = content,
		embeds = {{
			title = fishWeight > 500 and "🔥 IKAN GEDE CUY! 🔥" or "Stats Update",
			color = embedColor,
			fields = {
				{name = "Username:", value = "**@" .. plr.Name .. "**", inline = true},
				{name = "Fish Name:", value = "**" .. fishName .. "**", inline = true},
				{name = "Weight:", value = "**" .. fishWeight .. " Kg**", inline = true},
				{name = "Rod Type:", value = "**" .. rodName .. "**", inline = true},
				{name = "Strike Streak:", value = "**" .. tostring(strikeValue) .. "**", inline = true},
				{name = "Total Fish:", value = "**" .. tostring(fishCount) .. "**", inline = true},
				{name = "Sold Fish:", value = "**" .. tostring(webhookStats.totalFishSold) .. "**", inline = true},
				{name = "Current Money:", value = "**Rp " .. tostring(moneyValue):reverse():gsub("(%d%d%d)", "%1."):reverse():gsub("^%.", "") .. "**", inline = true},
				{name = "Farming Time:", value = "**" .. farmingTime .. "**", inline = true},
				{name = "Map:", value = "**" .. mapName .. "**", inline = true},
				{name = "Join Server:", value = "[Click to Join](" .. jobId .. ")", inline = false}
			},
			footer = {
				text = "Indo Hangout • " .. os.date("%H:%M:%S")
			},
			timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
		}}
	}
	
	spawn(function()
		req(body)
	end)
end

-- Get fish info from PlayerData.Ikan folder
local function getLatestFishInfo()
	local fishName = "Unknown Fish"
	local fishWeight = 0
	
	local playerData = plr:FindFirstChild("PlayerData")
	if not playerData then return fishName, fishWeight end
	
	local ikanFolder = playerData:FindFirstChild("Ikan")
	if not ikanFolder then return fishName, fishWeight end
	
	local fishes = ikanFolder:GetChildren()
	if #fishes > 0 then
		local lastFish = fishes[#fishes]
		if lastFish.Name:match("%((.+) Kg%)") then
			local weight = lastFish.Name:match("%((.+) Kg%)")
			if weight then
				fishWeight = tonumber(weight) or 0
				fishName = lastFish.Name:gsub(" %(.+ Kg%)", "")
			end
		end
	end
	
	return fishName, fishWeight
end

local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "AutoFishGUI"

local function corner(obj)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 10)
	c.Parent = obj
end

local mainFrm = Instance.new("Frame", sg)
local origSize = UDim2.fromOffset(280, 400)
mainFrm.Size = origSize
mainFrm.Position = UDim2.new(0.5, -140, 0.1, 0)
mainFrm.BackgroundColor3 = Color3.fromRGB(31,31,53)
mainFrm.BorderSizePixel = 0
mainFrm.Active = true
corner(mainFrm)

-- Header Section
local headerFrame = Instance.new("Frame", mainFrm)
headerFrame.Size = UDim2.new(1, 0, 0, 30)
headerFrame.Position = UDim2.fromOffset(0, 0)
headerFrame.BackgroundColor3 = Color3.fromRGB(45,45,70)
headerFrame.BorderSizePixel = 0
corner(headerFrame)

local titleLabel = Instance.new("TextLabel", headerFrame)
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.fromOffset(10, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextColor3 = Color3.new(1,1,1)
titleLabel.Text = "🎣 Indo Hangout Script"
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local minimizeBtn = Instance.new("TextButton", headerFrame)
minimizeBtn.Size = UDim2.new(0, 30, 0, 20)
minimizeBtn.Position = UDim2.new(1, -35, 0.5, -10)
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(80,80,120)
corner(minimizeBtn)

-- Content Area (with padding)
local contentFrame = Instance.new("Frame", mainFrm)
contentFrame.Size = UDim2.new(1, -16, 1, -46)
contentFrame.Position = UDim2.fromOffset(8, 38)
contentFrame.BackgroundTransparency = 1

-- Rod Selection Section
local rodSection = Instance.new("Frame", contentFrame)
rodSection.Size = UDim2.new(1, 0, 0, 60)
rodSection.Position = UDim2.fromOffset(0, 0)
rodSection.BackgroundColor3 = Color3.fromRGB(40,40,60)
rodSection.BorderSizePixel = 0
corner(rodSection)

local rodTitle = Instance.new("TextLabel", rodSection)
rodTitle.Size = UDim2.new(1, -10, 0, 20)
rodTitle.Position = UDim2.fromOffset(5, 5)
rodTitle.BackgroundTransparency = 1
rodTitle.Font = Enum.Font.GothamBold
rodTitle.TextSize = 14
rodTitle.TextColor3 = Color3.new(1,1,1)
rodTitle.Text = "🎣 Rod Selection"
rodTitle.TextXAlignment = Enum.TextXAlignment.Left

local rodBtn = Instance.new("TextButton", rodSection)
rodBtn.Size = UDim2.new(1, -10, 0, 30)
rodBtn.Position = UDim2.fromOffset(5, 25)
rodBtn.BackgroundColor3 = Color3.fromRGB(110, 212, 140)
rodBtn.TextColor3 = Color3.new(0, 0, 0)
rodBtn.Font = Enum.Font.GothamBold
rodBtn.TextSize = 14
rodBtn.Text = rodName
corner(rodBtn)

-- Auto Fishing Section
local fishingSection = Instance.new("Frame", contentFrame)
fishingSection.Size = UDim2.new(1, 0, 0, 80)
fishingSection.Position = UDim2.fromOffset(0, 65)
fishingSection.BackgroundColor3 = Color3.fromRGB(40,40,60)
fishingSection.BorderSizePixel = 0
corner(fishingSection)

local fishingTitle = Instance.new("TextLabel", fishingSection)
fishingTitle.Size = UDim2.new(1, -10, 0, 20)
fishingTitle.Position = UDim2.fromOffset(5, 5)
fishingTitle.BackgroundTransparency = 1
fishingTitle.Font = Enum.Font.GothamBold
fishingTitle.TextSize = 14
fishingTitle.TextColor3 = Color3.new(1,1,1)
fishingTitle.Text = "⚡ Auto Fishing"
fishingTitle.TextXAlignment = Enum.TextXAlignment.Left

local fishingBtn = Instance.new("TextButton", fishingSection)
fishingBtn.Size = UDim2.new(1, -10, 0, 30)
fishingBtn.Position = UDim2.fromOffset(5, 25)
fishingBtn.BackgroundColor3 = Color3.fromRGB(110, 212, 140)
fishingBtn.TextColor3 = Color3.new(0, 0, 0)
fishingBtn.Font = Enum.Font.GothamBold
fishingBtn.TextSize = 16
fishingBtn.Text = "Start Auto Fishing"
corner(fishingBtn)

local fishingStatus = Instance.new("TextLabel", fishingSection)
fishingStatus.Size = UDim2.new(1, -10, 0, 20)
fishingStatus.Position = UDim2.fromOffset(5, 55)
fishingStatus.BackgroundTransparency = 1
fishingStatus.Font = Enum.Font.Gotham
fishingStatus.TextSize = 12
fishingStatus.TextColor3 = Color3.fromRGB(230, 255, 210)
fishingStatus.TextXAlignment = Enum.TextXAlignment.Left
fishingStatus.Text = "Status: Standby | Anti-AFK: ON"

-- Auto Sell Section
local sellSection = Instance.new("Frame", contentFrame)
sellSection.Size = UDim2.new(1, 0, 0, 100)
sellSection.Position = UDim2.fromOffset(0, 150)
sellSection.BackgroundColor3 = Color3.fromRGB(40,40,60)
sellSection.BorderSizePixel = 0
corner(sellSection)

local sellTitle = Instance.new("TextLabel", sellSection)
sellTitle.Size = UDim2.new(1, -10, 0, 20)
sellTitle.Position = UDim2.fromOffset(5, 5)
sellTitle.BackgroundTransparency = 1
sellTitle.Font = Enum.Font.GothamBold
sellTitle.TextSize = 14
sellTitle.TextColor3 = Color3.new(1,1,1)
sellTitle.Text = "💰 Auto Sell"
sellTitle.TextXAlignment = Enum.TextXAlignment.Left

local sellModes = {
	"All under 50 Kg","All under 100 Kg","All under 400 Kg",
	"All under 600 Kg","All under 800 Kg","All under 1000 Kg",
	"Sell this fish","Sell All"
}
local currentSellIndex = 1

local sellModeBtn = Instance.new("TextButton", sellSection)
sellModeBtn.Size = UDim2.new(1, -10, 0, 25)
sellModeBtn.Position = UDim2.fromOffset(5, 25)
sellModeBtn.BackgroundColor3 = Color3.fromRGB(110, 212, 140)
sellModeBtn.TextColor3 = Color3.new(0, 0, 0)
sellModeBtn.Font = Enum.Font.GothamSemibold
sellModeBtn.TextSize = 12
sellModeBtn.Text = sellModes[currentSellIndex]
corner(sellModeBtn)

local intervalLabel = Instance.new("TextLabel", sellSection)
intervalLabel.Size = UDim2.new(0.4, -5, 0, 20)
intervalLabel.Position = UDim2.fromOffset(5, 55)
intervalLabel.BackgroundTransparency = 1
intervalLabel.Font = Enum.Font.Gotham
intervalLabel.TextSize = 12
intervalLabel.TextColor3 = Color3.new(1,1,1)
intervalLabel.Text = "Interval (s):"
intervalLabel.TextXAlignment = Enum.TextXAlignment.Left

local intervalBox = Instance.new("TextBox", sellSection)
intervalBox.Size = UDim2.new(0.6, -5, 0, 20)
intervalBox.Position = UDim2.new(0.4, 5, 0, 55)
intervalBox.BackgroundColor3 = Color3.fromRGB(52, 52, 72)
intervalBox.TextColor3 = Color3.new(1, 1, 1)
intervalBox.Font = Enum.Font.Gotham
intervalBox.TextSize = 13
intervalBox.Text = "30"
intervalBox.PlaceholderText = "Seconds"
intervalBox.ClearTextOnFocus = false
corner(intervalBox)

local autoSellBtn = Instance.new("TextButton", sellSection)
autoSellBtn.Size = UDim2.new(1, -10, 0, 20)
autoSellBtn.Position = UDim2.fromOffset(5, 75)
autoSellBtn.BackgroundColor3 = Color3.fromRGB(88, 233, 167)
autoSellBtn.TextColor3 = Color3.new(0, 0, 0)
autoSellBtn.Font = Enum.Font.GothamBold
autoSellBtn.TextSize = 13
autoSellBtn.Text = "Enable Auto Sell"
corner(autoSellBtn)

-- Tools Section
local toolsSection = Instance.new("Frame", contentFrame)
toolsSection.Size = UDim2.new(1, 0, 0, 70)
toolsSection.Position = UDim2.fromOffset(0, 255)
toolsSection.BackgroundColor3 = Color3.fromRGB(40,40,60)
toolsSection.BorderSizePixel = 0
corner(toolsSection)

local toolsTitle = Instance.new("TextLabel", toolsSection)
toolsTitle.Size = UDim2.new(1, -10, 0, 20)
toolsTitle.Position = UDim2.fromOffset(5, 5)
toolsTitle.BackgroundTransparency = 1
toolsTitle.Font = Enum.Font.GothamBold
toolsTitle.TextSize = 14
toolsTitle.TextColor3 = Color3.new(1,1,1)
toolsTitle.Text = "🛠️ Tools"
toolsTitle.TextXAlignment = Enum.TextXAlignment.Left

local buyRodBtn = Instance.new("TextButton", toolsSection)
buyRodBtn.Size = UDim2.new(0.48, -5, 0, 25)
buyRodBtn.Position = UDim2.fromOffset(5, 25)
buyRodBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
buyRodBtn.TextColor3 = Color3.new(0, 0, 0)
buyRodBtn.Font = Enum.Font.GothamBold
buyRodBtn.TextSize = 12
buyRodBtn.Text = "Rod Shop"
corner(buyRodBtn)

local webhookBtn = Instance.new("TextButton", toolsSection)
webhookBtn.Size = UDim2.new(0.48, -5, 0, 25)
webhookBtn.Position = UDim2.new(0.52, 5, 0, 25)
webhookBtn.BackgroundColor3 = Color3.fromRGB(234, 112, 112)
webhookBtn.TextColor3 = Color3.new(0, 0, 0)
webhookBtn.Font = Enum.Font.GothamBold
webhookBtn.TextSize = 12
webhookBtn.Text = "Webhook: OFF"
corner(webhookBtn)

-- Minimize functionality
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	contentFrame.Visible = not minimized
	if minimized then
		mainFrm.Size = UDim2.fromOffset(280, 30)
		minimizeBtn.Text = "+"
	else
		mainFrm.Size = origSize
		minimizeBtn.Text = "-"
	end
end)

-- Rod selection
rodBtn.MouseButton1Click:Connect(function()
	currentRodIndex = currentRodIndex % #rodOptions + 1
	rodName = rodOptions[currentRodIndex]
	rodBtn.Text = rodName
end)

-- Sell mode selection
sellModeBtn.MouseButton1Click:Connect(function()
	currentSellIndex = currentSellIndex % #sellModes + 1
	sellModeBtn.Text = sellModes[currentSellIndex]
end)

-- Quick sell (right click)
sellModeBtn.MouseButton2Click:Connect(function()
	local mode = sellModes[currentSellIndex]
	if mode == "Sell this fish" then
		SellRemote:InvokeServer("SellFish")
	else
		SellRemote:InvokeServer("SellFish", mode)
	end
	webhookStats.totalFishSold = webhookStats.totalFishSold + 1
	showNotification("Sold fish: " .. mode)
end)

-- Buy Rod button
buyRodBtn.MouseButton1Click:Connect(function()
	local rodShopGui = plr.PlayerGui:FindFirstChild("RodShop")
	if rodShopGui then
		rodShopGui.Enabled = true
		showNotification("Rod Shop Opened!")
	else
		showNotification("Rod Shop GUI not found!")
	end
end)

-- Webhook toggle
webhookBtn.MouseButton1Click:Connect(function()
	webhookStats.webhookEnabled = not webhookStats.webhookEnabled
	if webhookStats.webhookEnabled then
		webhookBtn.Text = "Webhook: ON"
		webhookBtn.BackgroundColor3 = Color3.fromRGB(88, 233, 167)
		showNotification("Webhook Enabled!")
	else
		webhookBtn.Text = "Webhook: OFF"
		webhookBtn.BackgroundColor3 = Color3.fromRGB(234, 112, 112)
		showNotification("Webhook Disabled!")
	end
end)

-- Draggable functionality
do
	local drag, startPos, origPos
	headerFrame.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			drag = true
			startPos = i.Position
			origPos = mainFrm.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then
					drag = false
				end
			end)
		end
	end)
	game:GetService("UserInputService").InputChanged:Connect(function(i)
		if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local delta = i.Position - startPos
			mainFrm.Position = UDim2.new(
				origPos.X.Scale, origPos.X.Offset + delta.X,
				origPos.Y.Scale, origPos.Y.Offset + delta.Y
			)
		end
	end)
end

-- Auto Fishing Logic
local running, looping = false, false
local globalReleaseFlag = false

local function getRod(a)
	if not plr.Character then return end
	if a then
		return plr.Character:FindFirstChild(rodName)
	else
		return plr.Backpack:FindFirstChild(rodName)
	end
end

local function forceEquipRod()
	local rod = getRod()
	if rod and plr.Character then
		local hum = plr.Character:FindFirstChild("Humanoid")
		if hum then pcall(function() hum:EquipTool(rod) end) end
		REMOTE:FireServer("Equipped", rod)
		return true
	end
	return false
end

local function ensureEquipped()
	if getRod() then forceEquipRod() end
end

local function unequipRod()
	if plr.Character then
		local hum = plr.Character:FindFirstChild("Humanoid")
		if hum then pcall(function() hum:UnequipTools() end) end
	end
end

local function throwRod()
	ensureEquipped()
	local rod = getRod(true)
	if rod then
		REMOTE:FireServer(unpack({"Throw", rod, workspace:WaitForChild("Terrain")}))
		return true
	end
	return false
end

local function getActiveRedBar(bars)
	if bars then
		for _, c in pairs(bars:GetChildren()) do
			if c:IsA("Frame") and c.Name == "RedBar" and c.Visible then
				return c
			end
		end
	end 
	return nil
end

local function seekAndImmediateFollow(white, bars)
	local function getRedBar()
		for _, c in pairs(bars:GetChildren()) do
			if c:IsA("Frame") and c.Name == "RedBar" and c.Visible then
				return c
			end
		end
		return nil
	end
	local function getRedBarCenter(red)
		local abs = red.AbsolutePosition or Vector2.new(450, 450)
		local sz = red.AbsoluteSize or Vector2.new(30, 16)
		return Vector2.new(math.floor(abs.X + sz.X / 2), math.floor(abs.Y + sz.Y / 2))
	end

	local holded = false
	spawn(function()
		while plr.PlayerGui:FindFirstChild("Reeling") and plr.PlayerGui.Reeling.Enabled do
			local red = getRedBar()
			local whiteBar = bars:FindFirstChild("WhiteBar")
			if red and red.Visible and whiteBar then
				whiteBar.Position = red.Position
				whiteBar.Size = UDim2.new(red.Size.X.Scale, red.Size.X.Offset, whiteBar.Size.Y.Scale, whiteBar.Size.Y.Offset)
			else
				break
			end
			wait(0.005)
		end
	end)
	
	while plr.PlayerGui:FindFirstChild("Reeling") and plr.PlayerGui.Reeling.Enabled do
		local red = getRedBar()
		if red and red.Visible then
			local redCt = getRedBarCenter(red)
			VirtualInputManager:SendMouseButtonEvent(redCt.X, redCt.Y, 0, true, game, 1)
			holded = true
		else
			break
		end
		wait(0.01)
	end
	
	if holded then
		local red = getRedBar()
		if red then
			local redCt = getRedBarCenter(red)
			VirtualInputManager:SendMouseButtonEvent(redCt.X, redCt.Y, 0, false, game, 1)
		end
	end
	return true
end

local fishDetected = false
local waitingBite = false
local function setupBiteListener()
	REMOTE.OnClientEvent:Connect(function(action)
		if waitingBite and tostring(action):lower():find("reeling") then
			fishDetected = true
		end
	end)
end
setupBiteListener()

local function autoFishLoop()
	while running do
		fishingStatus.Text = "Status: Standby | Anti-AFK: ON"
		wait(0.7)
		if not workspace:FindFirstChild("Pelampung-" .. plr.Name) then
			fishingStatus.Text = "Status: Throw | Anti-AFK: ON"
			throwRod()
		end
		wait(0.38)
		fishingStatus.Text = "Status: Wait Fish Bait | Anti-AFK: ON"
		waitingBite, fishDetected = true, false
		local t0 = tick()
		while running and not fishDetected and (tick() - t0 < 35) do
			wait(0.22)
			if not workspace:FindFirstChild("Pelampung-" .. plr.Name) then
				throwRod()
			end
			fishingStatus.Text = "Status: Wait Fish Bait... " .. math.floor(tick() - t0) .. "s | Anti-AFK: ON"
		end
		waitingBite = false
		if not running then
			break
		end
		if not fishDetected then
			fishingStatus.Text = "Status: Timeout, retry | Anti-AFK: ON"
			wait(1.1)
		else
			fishingStatus.Text = "Status: Perfect Overlap | Anti-AFK: ON"
			local bars = plr.PlayerGui.Reeling.Frame and plr.PlayerGui.Reeling.Frame:FindFirstChild("Frame")
			local white = bars and bars:FindFirstChild("WhiteBar")
			while plr.PlayerGui.Reeling.Enabled and not globalReleaseFlag do
				if white and white.Visible then
					seekAndImmediateFollow(white, bars)
					break
				end
				if not running or not plr.PlayerGui.Reeling.Enabled then
					break
				end
				wait(0.01)
			end
			
			-- Send webhook after fish caught
			wait(0.5)
			local fishName, fishWeight = getLatestFishInfo()
			if fishWeight > 0 then
				webhookStats.totalFishCaught = webhookStats.totalFishCaught + 1
				sendWebhook(fishName, fishWeight)
			end
		end
		fishingStatus.Text = "Status: Standby | Anti-AFK: ON"
		fishDetected = false
		wait(0.7)
	end
	fishingStatus.Text = "Status: Standby | Anti-AFK: ON"
	waitingBite = false
	fishDetected = false
end

-- Auto Fishing Toggle - FIXED
fishingBtn.MouseButton1Click:Connect(function()
	running = not running
	fishingBtn.Text = running and "Stop Auto Fishing" or "Start Auto Fishing"
	fishingBtn.BackgroundColor3 = running and Color3.fromRGB(234, 112, 112) or Color3.fromRGB(110, 212, 140)
	fishingStatus.Text = running and "Status: Loading... | Anti-AFK: ON" or "Status: Standby | Anti-AFK: ON"
	if running then
		globalReleaseFlag = false
		spawn(autoFishLoop)
	else
		globalReleaseFlag = true
		unequipRod()
	end
end)

-- Auto Sell Logic
local runAuto = false

local function doSell()
	local mode = sellModes[currentSellIndex]
	if mode == "Sell this fish" then
		SellRemote:InvokeServer("SellFish")
	else
		SellRemote:InvokeServer("SellFish", mode)
	end
	webhookStats.totalFishSold = webhookStats.totalFishSold + 1
end

-- Auto Sell Toggle - FIXED
autoSellBtn.MouseButton1Click:Connect(function()
	runAuto = not runAuto
	autoSellBtn.Text = runAuto and "Disable Auto Sell" or "Enable Auto Sell"
	autoSellBtn.BackgroundColor3 = runAuto and Color3.fromRGB(234, 112, 112) or Color3.fromRGB(88, 233, 167)
	if runAuto then
		spawn(function()
			while runAuto do
				doSell()
				local n = tonumber(intervalBox.Text)
				n = (n and n >= 2) and n or 30
				for i = 1, n do
					if not runAuto then
						break
					end
					wait(1)
				end
			end
		end)
	end
end)

showNotification("Indo Hangout Script, Loaded!")