local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local SleekUILib = {}
SleekUILib.__index = SleekUILib

-- 🧲 Dragging helper function
local function MakeDraggable(topbarObject, targetObject)
	local dragging = false
	local dragInput, dragStart, startPos

	local function update(input)
		local delta = input.Position - dragStart
		targetObject.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end

	topbarObject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = targetObject.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	topbarObject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end


-- 🪟 Window creation
function SleekUILib:CreateWindow(title)
	local self = setmetatable({}, SleekUILib)

	self.Gui = Instance.new("ScreenGui")
	self.Gui.Name = "SleekUI"
	self.Gui.ResetOnSpawn = false
	self.Gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

	self.Frame = Instance.new("Frame")
	self.Frame.Size = UDim2.new(0, 450, 0, 300)
	self.Frame.Position = UDim2.new(0.5, -225, 0.5, -150)
	self.Frame.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
	self.Frame.BorderSizePixel = 0
	self.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	self.Frame.Parent = self.Gui

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(85, 170, 255)
	stroke.Thickness = 2
	stroke.Parent = self.Frame

	self.TitleBar = Instance.new("Frame")
	self.TitleBar.Size = UDim2.new(1, 0, 0, 36)
	self.TitleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
	self.TitleBar.Parent = self.Frame

	self.TitleLabel = Instance.new("TextLabel")
	self.TitleLabel.Size = UDim2.new(1, -50, 1, 0)
	self.TitleLabel.Position = UDim2.new(0, 15, 0, 0)
	self.TitleLabel.BackgroundTransparency = 1
	self.TitleLabel.Text = title or "Sleek UI"
	self.TitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	self.TitleLabel.Font = Enum.Font.GothamBold
	self.TitleLabel.TextSize = 20
	self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	self.TitleLabel.Parent = self.TitleBar

	self.CloseBtn = Instance.new("TextButton")
	self.CloseBtn.Size = UDim2.new(0, 30, 0, 30)
	self.CloseBtn.Position = UDim2.new(1, -40, 0, 3)
	self.CloseBtn.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
	self.CloseBtn.Text = "✕"
	self.CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	self.CloseBtn.Font = Enum.Font.GothamBold
	self.CloseBtn.TextSize = 20
	self.CloseBtn.Parent = self.TitleBar

	self.CloseBtn.MouseButton1Click:Connect(function()
		self:Destroy()
	end)

	self.Content = Instance.new("Frame")
	self.Content.Size = UDim2.new(1, -20, 1, -60)
	self.Content.Position = UDim2.new(0, 10, 0, 45)
	self.Content.BackgroundTransparency = 1
	self.Content.Parent = self.Frame

	self.UIList = Instance.new("UIListLayout")
	self.UIList.Parent = self.Content
	self.UIList.SortOrder = Enum.SortOrder.LayoutOrder
	self.UIList.Padding = UDim.new(0, 12)

	-- 📦 Resize logic
	self.ResizeCorner = Instance.new("Frame")
	self.ResizeCorner.Size = UDim2.new(0, 20, 0, 20)
	self.ResizeCorner.Position = UDim2.new(1, -20, 1, -20)
	self.ResizeCorner.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
	self.ResizeCorner.BorderSizePixel = 0
	self.ResizeCorner.AnchorPoint = Vector2.new(0, 0)
	self.ResizeCorner.Parent = self.Frame

	local resizing = false
	local mouseStartPos, frameStartSize

	self.ResizeCorner.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			resizing = true
			mouseStartPos = input.Position
			frameStartSize = self.Frame.Size

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					resizing = false
				end
			end)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and resizing then
			local delta = input.Position - mouseStartPos
			local newWidth = math.clamp(frameStartSize.X.Offset + delta.X, 300, workspace.CurrentCamera.ViewportSize.X)
			local newHeight = math.clamp(frameStartSize.Y.Offset + delta.Y, 200, workspace.CurrentCamera.ViewportSize.Y)

			self.Frame.Size = UDim2.new(0, newWidth, 0, newHeight)
			self.Content.Size = UDim2.new(1, -20, 1, -60)
		end
	end)

	-- ✅ Apply dragging to the window
	MakeDraggable(self.TitleBar, self.Frame)

	return self
end

-- Rest of the library unchanged
function SleekUILib:AddButton(...) -- ...
-- etc.

return SleekUILib
