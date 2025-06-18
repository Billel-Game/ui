local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- Make UI
local gui = Instance.new("ScreenGui")
gui.Name = "CustomUILib"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Window
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Name = "MainWindow"
frame.Parent = gui
frame.Active = true
frame.Draggable = true

-- UIListLayout
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = frame

-- Padding
local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 10)
padding.PaddingBottom = UDim.new(0, 10)
padding.PaddingLeft = UDim.new(0, 10)
padding.PaddingRight = UDim.new(0, 10)
padding.Parent = frame

-- Create Button
local function CreateButton(text, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -20, 0, 40)
	button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 16
	button.Text = text
	button.AutoButtonColor = true
	button.Parent = frame

	button.MouseButton1Click:Connect(callback)
	return button
end

-- Create Toggle
local function CreateToggle(text, default, callback)
	local value = default
	local toggle = Instance.new("TextButton")
	toggle.Size = UDim2.new(1, -20, 0, 40)
	toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggle.Font = Enum.Font.Gotham
	toggle.TextSize = 16
	toggle.Text = text .. ": OFF"
	toggle.AutoButtonColor = true
	toggle.Parent = frame

	toggle.MouseButton1Click:Connect(function()
		value = not value
		toggle.Text = text .. ": " .. (value and "ON" or "OFF")
		callback(value)
	end)

	return toggle
end

-- Example Buttons
CreateButton("Kill All", function()
	print("Killed everyone!")
end)

CreateButton("Get Max Level", function()
	print("Max level granted!")
end)

CreateToggle("Auto-Farm", false, function(enabled)
	if enabled then
		print("Auto-Farm enabled!")
	else
		print("Auto-Farm disabled!")
	end
end)

-- Unload Button
CreateButton("Unload UI", function()
	gui:Destroy()
end)
