local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local UILib = {}

function UILib:Create()
    local LocalPlayer = Players.LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "CustomUILib"
    gui.ResetOnSpawn = false
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

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

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = frame

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = frame

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

    -- Autofarm toggle logic
    local connection
    CreateToggle("Auto-Farm", false, function(enabled)
        if enabled then
            connection = RunService.Heartbeat:Connect(function()
                local MineCoinEvent = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("MineCoin")
                MineCoinEvent:FireServer()
            end)
        else
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end)

    -- Unload button
    CreateButton("Unload UI", function()
        gui:Destroy()
    end)
end

return UILib
