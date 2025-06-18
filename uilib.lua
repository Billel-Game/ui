local UIS = game:GetService("UserInputService")

local SleekUILib = {}
SleekUILib.__index = SleekUILib

local function MakeDraggable(topbarobject, object)
	local Dragging = false
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil

	local function Update(input)
		local Delta = input.Position - DragStart
		local pos = UDim2.new(
			StartPosition.X.Scale,
			StartPosition.X.Offset + Delta.X,
			StartPosition.Y.Scale,
			StartPosition.Y.Offset + Delta.Y
		)
		object.Position = pos
	end

	topbarobject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = input.Position
			StartPosition = object.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	topbarobject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			DragInput = input
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if input == DragInput and Dragging then
			Update(input)
		end
	end)
end

function SleekUILib:CreateWindow(title)
	local self = setmetatable({}, SleekUILib)

	self.Gui = Instance.new("ScreenGui")
	self.Gui.Name = "SleekUI"
	self.Gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

	self.Frame = Instance.new("Frame")
	self.Frame.Size = UDim2.new(0, 450, 0, 300)
	self.Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	self.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	self.Frame.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
	self.Frame.Parent = self.Gui

	self.TitleBar = Instance.new("Frame")
	self.TitleBar.Size = UDim2.new(1, 0, 0, 36)
	self.TitleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
	self.TitleBar.Parent = self.Frame

	-- title label, buttons etc here...

	-- Apply draggable behavior
	MakeDraggable(self.TitleBar, self.Frame)

	return self
end

return SleekUILib
