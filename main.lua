local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- 1. Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PureClassicFloat"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- 2. Tạo Frame chính (MainFrame)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, -40, 0.5, 0.0) 
local mainFrameSize = UDim2.new(0, 300, 0, 130) 
mainFrame.Size = mainFrameSize
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true 
mainFrame.Active = true 
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- 2.5. TextLabel hiển thị độ cao thực tế
local heightLabel = Instance.new("TextLabel")
heightLabel.Name = "HeightLabel"
heightLabel.Size = UDim2.new(0, 150, 0, 35)
heightLabel.Position = UDim2.new(0, 15, 0, 5)
heightLabel.BackgroundTransparency = 1
heightLabel.Text = "Độ cao: 0"
heightLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
heightLabel.TextXAlignment = Enum.TextXAlignment.Left
heightLabel.Font = Enum.Font.SourceSansBold
heightLabel.TextSize = 16
heightLabel.Parent = mainFrame

task.spawn(function()
	while true do
		task.wait(0.05)
		local char = localPlayer.Character
		local rootPart = char and char:FindFirstChild("HumanoidRootPart")
		if rootPart then
			heightLabel.Text = "Độ cao: " .. string.format("%.1f", rootPart.Position.Y)
		end
	end
end)

-- 3. Nút Thu nhỏ / Phóng to GUI Chính
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "Toggle"
toggleBtn.Size = UDim2.new(0, 35, 0, 35)
toggleBtn.Position = UDim2.new(1, -40, 0, 5)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleBtn.Text = "_"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 20
toggleBtn.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = toggleBtn

-- 4. Thanh ghi số độ cao mục tiêu
local numberInput = Instance.new("TextBox")
numberInput.Name = "NumberInput"
numberInput.Size = UDim2.new(0, 260, 0, 35)
numberInput.Position = UDim2.new(0, 20, 0, 65)
numberInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
numberInput.TextColor3 = Color3.fromRGB(255, 255, 255)
numberInput.PlaceholderText = "Nhập giới hạn dưới (VD: 20)..."
numberInput.Text = ""
numberInput.Font = Enum.Font.SourceSans
numberInput.TextSize = 16
numberInput.ClearTextOnFocus = false
numberInput.Parent = mainFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = numberInput


-- 5. TẠO UI PHỤ BẬT/TẮT (Widget 50x50)
local widgetFrame = Instance.new("Frame")
widgetFrame.Name = "FloatWidget"
widgetFrame.Size = UDim2.new(0, 50, 0, 50) 
widgetFrame.Position = UDim2.new(0.5, 120, 0.5, -25) 
widgetFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
widgetFrame.BorderSizePixel = 0
widgetFrame.Active = true
widgetFrame.Parent = screenGui

local widgetCorner = Instance.new("UICorner")
widgetCorner.CornerRadius = UDim.new(0, 10)
widgetCorner.Parent = widgetFrame

local widgetBtn = Instance.new("TextButton")
widgetBtn.Name = "WidgetBtn"
widgetBtn.Size = UDim2.new(1, 0, 1, 0) 
widgetBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
widgetBtn.Text = "FLOAT\nOFF"
widgetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
widgetBtn.Font = Enum.Font.SourceSansBold
widgetBtn.TextSize = 12 
widgetBtn.Parent = widgetFrame

local wBtnCorner = Instance.new("UICorner")
wBtnCorner.CornerRadius = UDim.new(0, 10)
wBtnCorner.Parent = widgetBtn


--- =================================================== ---
---        CHỈ SỬA ĐỔI: CƠ CHẾ FLOAT TẤM VÁN CỔ ĐIỂN     ---
--- =================================================== ---
local floatEnabled = false
local floatPart = nil

local function removeFloatPart()
	if floatPart then floatPart:Destroy() floatPart = nil end
end

local function setFloatState(state)
	floatEnabled = state
	if floatEnabled then
		widgetBtn.Text = "FLOAT\nON"
		widgetBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
	else
		widgetBtn.Text = "FLOAT\nOFF"
		widgetBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		removeFloatPart()
	end
end

local isDraggingWidget = false
widgetBtn.MouseButton1Up:Connect(function()
	if not isDraggingWidget then
		setFloatState(not floatEnabled)
	end
end)

-- Vòng lặp tạo và cập nhật tấm ván Float cổ điển
task.spawn(function()
	while true do
		task.wait(0.01) -- Chạy liên tục để bám sát vị trí nhân vật
		if floatEnabled then
			local char = localPlayer.Character
			local rootPart = char and char:FindFirstChild("HumanoidRootPart")
			local targetY = tonumber(numberInput.Text)
			
			if rootPart and targetY then
				-- Chỉ kích hoạt khi nhân vật ở gần hoặc rơi xuống dưới độ cao mục tiêu
				if rootPart.Position.Y <= targetY + 3 then
					-- Nếu chưa có tấm ván, tạo mới một tấm ván tàng hình thực sự
					if not floatPart or not floatPart.Parent then
						removeFloatPart()
						floatPart = Instance.new("Part")
						floatPart.Name = "ClassicFloatPlatform"
						floatPart.Size = Vector3.new(12, 1, 12) -- Kích thước ván rộng rãi để di chuyển không lo trượt
						floatPart.Transparency = 1 -- Để bằng 1 để tàng hình hoàn toàn, không lộ
						floatPart.Anchored = true
						floatPart.CanCollide = true -- Bật va chạm thực tế để đứng chân lên mượt mà
						floatPart.Parent = workspace
					end
					
					-- Đồng bộ vị trí tấm ván liên tục theo X và Z của bạn, nhưng khóa chặt trục Y ở độ cao mục tiêu
					-- Trừ đi 3.2 để tính toán khoảng cách từ thắt lưng (HumanoidRootPart) xuống lòng bàn chân
					floatPart.CFrame = CFrame.new(rootPart.Position.X, targetY - 3.2, rootPart.Position.Z)
				else
					-- Nếu bạn chủ động nhảy lên cao hơn độ cao mục tiêu, xóa ván tạm thời để rơi tự nhiên
					removeFloatPart()
				end
			else
				removeFloatPart()
			end
		else
			removeFloatPart()
		end
	end
end)
--- =================================================== ---


-- 6. HỆ THỐNG KÉO THẢ CHUẨN KHÔNG LỖI
local function makeMainDraggable(frame)
	local dragging, dragInput, dragStart, startPos
	local function update(input)
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true dragStart = input.Position startPos = frame.Position
			input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
		end
	end)
	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
	end)
	UIS.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)
end

local function makeWidgetDraggable(targetFrame, handleButton)
	local dragging, dragInput, dragStart, startPos
	local function update(input)
		local delta = input.Position - dragStart
		targetFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
	handleButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true isDraggingWidget = false dragStart = input.Position startPos = targetFrame.Position
			input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
		end
	end)
	handleButton.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input if dragging then isDraggingWidget = true end
		end
	end)
	UIS.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)
end

makeMainDraggable(mainFrame)   
makeWidgetDraggable(widgetFrame, widgetBtn) 


-- 7. LOGIC THU NHỎ / PHÓNG TO
local isFull = true
local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

toggleBtn.MouseButton1Click:Connect(function()
	isFull = not isFull
	if isFull then
		TweenService:Create(mainFrame, tweenInfo, {Size = mainFrameSize}):Play()
		toggleBtn.Text = "_"
		toggleBtn.Position = UDim2.new(1, -40, 0, 5)
		heightLabel.Visible = true
		numberInput.Visible = true
	else
		TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 50, 0, 50)}):Play()
		toggleBtn.Text = "+"
		toggleBtn.Position = UDim2.new(0, 7, 0, 7)
		heightLabel.Visible = false
		numberInput.Visible = false
	end
end)
