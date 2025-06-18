local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local SleekUILib = {}
SleekUILib.__index = SleekUILib

function SleekUILib:CreateWindow(title)
    local self = setmetatable({}, SleekUILib)

    self.Gui = Instance.new("ScreenGui")
    self.Gui.Name = "SleekUI"
    self.Gui.ResetOnSpawn = false
    self.Gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    self.Frame = Instance.new("Frame")
    self.Frame.Size = UDim2.new(0, 450, 0, 300)
    self.Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Frame.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
    self.Frame.BorderSizePixel = 0
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

    local UIList = Instance.new("UIListLayout")
    UIList.Parent = self.Content
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 12)

    -- Dragging vars
    local dragging = false
    local dragStartPos = nil
    local frameStartPos = nil

    local function getFrameCenterAbsolutePos()
        local absPos = self.Frame.AbsolutePosition
        local absSize = self.Frame.AbsoluteSize
        local anchor = self.Frame.AnchorPoint
        return Vector2.new(absPos.X + absSize.X * anchor.X, absPos.Y + absSize.Y * anchor.Y)
    end

    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStartPos = input.Position
            frameStartPos = getFrameCenterAbsolutePos()

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStartPos
            local newPos = frameStartPos + delta

            local camSize = workspace.CurrentCamera.ViewportSize
            local frameSize = self.Frame.AbsoluteSize
            local anchor = self.Frame.AnchorPoint

            local clampedX = math.clamp(newPos.X, frameSize.X * anchor.X, camSize.X - frameSize.X * (1 - anchor.X))
            local clampedY = math.clamp(newPos.Y, frameSize.Y * anchor.Y, camSize.Y - frameSize.Y * (1 - anchor.Y))

            local finalPos = UDim2.new(0, clampedX - frameSize.X * anchor.X, 0, clampedY - frameSize.Y * anchor.Y)
            self.Frame.Position = finalPos
        end
    end)

    -- Resize handle
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

    return self
end

function SleekUILib:AddButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Text = text
    btn.AutoButtonColor = true
    btn.Parent = self.Content

    btn.MouseButton1Click:Connect(callback)

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    end)

    return btn
end

function SleekUILib:AddToggle(text, default, callback)
    local frameToggle = Instance.new("Frame")
    frameToggle.Size = UDim2.new(1, 0, 0, 40)
    frameToggle.BackgroundTransparency = 1
    frameToggle.Parent = self.Content

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 18
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frameToggle

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 60, 0, 30)
    toggleBtn.Position = UDim2.new(1, -65, 0, 5)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(85, 170, 255) or Color3.fromRGB(70, 70, 70)
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 16
    toggleBtn.Text = default and "ON" or "OFF"
    toggleBtn.Parent = frameToggle

    local state = default

    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(85, 170, 255) or Color3.fromRGB(70, 70, 70)
        toggleBtn.Text = state and "ON" or "OFF"
        callback(state)
    end)

    return frameToggle
end

function SleekUILib:Destroy()
    if self.Gui then
        self.Gui:Destroy()
        self.Gui = nil
    end
end

return SleekUILib
