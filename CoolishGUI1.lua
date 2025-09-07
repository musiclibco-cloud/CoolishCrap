-- C00lGUI Mobile Script Library v1.0
-- Inspired by 007n7/C00LKIDD's C00lGUI
-- Mobile-optimized draggable UI library

local C00lGUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Configuration
local CONFIG = {
    COLORS = {
        PRIMARY = Color3.fromRGB(40, 40, 60),
        SECONDARY = Color3.fromRGB(60, 60, 80),
        ACCENT = Color3.fromRGB(0, 255, 127),
        TEXT = Color3.fromRGB(255, 255, 255),
        BACKGROUND = Color3.fromRGB(20, 20, 30)
    },
    ANIMATIONS = {
        DURATION = 0.3,
        EASING = Enum.EasingStyle.Quart,
        DIRECTION = Enum.EasingDirection.Out
    }
}

-- Create main GUI container
function C00lGUI.new(title)
    local gui = {}
    
    -- Create ScreenGui
    gui.ScreenGui = Instance.new("ScreenGui")
    gui.ScreenGui.Name = "C00lGUI_" .. title
    gui.ScreenGui.ResetOnSpawn = false
    gui.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.ScreenGui.Parent = CoreGui
    
    -- Main Frame
    gui.MainFrame = Instance.new("Frame")
    gui.MainFrame.Name = "MainFrame"
    gui.MainFrame.Size = UDim2.new(0, 350, 0, 500)
    gui.MainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
    gui.MainFrame.BackgroundColor3 = CONFIG.COLORS.PRIMARY
    gui.MainFrame.BorderSizePixel = 0
    gui.MainFrame.Active = true
    gui.MainFrame.Draggable = true
    gui.MainFrame.Parent = gui.ScreenGui
    
    -- Corner rounding
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = gui.MainFrame
    
    -- Drop shadow effect
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.7
    shadow.ZIndex = gui.MainFrame.ZIndex - 1
    shadow.Parent = gui.MainFrame
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 12)
    shadowCorner.Parent = shadow
    
    -- Title Bar
    gui.TitleBar = Instance.new("Frame")
    gui.TitleBar.Name = "TitleBar"
    gui.TitleBar.Size = UDim2.new(1, 0, 0, 50)
    gui.TitleBar.Position = UDim2.new(0, 0, 0, 0)
    gui.TitleBar.BackgroundColor3 = CONFIG.COLORS.ACCENT
    gui.TitleBar.BorderSizePixel = 0
    gui.TitleBar.Parent = gui.MainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = gui.TitleBar
    
    -- Title gradient
    local titleGradient = Instance.new("UIGradient")
    titleGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, CONFIG.COLORS.ACCENT),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 100))
    }
    titleGradient.Rotation = 45
    titleGradient.Parent = gui.TitleBar
    
    -- Title Text
    gui.TitleLabel = Instance.new("TextLabel")
    gui.TitleLabel.Name = "TitleLabel"
    gui.TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    gui.TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    gui.TitleLabel.BackgroundTransparency = 1
    gui.TitleLabel.Text = title or "C00lGUI"
    gui.TitleLabel.TextColor3 = CONFIG.COLORS.TEXT
    gui.TitleLabel.TextSize = 18
    gui.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    gui.TitleLabel.Font = Enum.Font.GothamBold
    gui.TitleLabel.Parent = gui.TitleBar
    
    -- Close Button
    gui.CloseButton = Instance.new("TextButton")
    gui.CloseButton.Name = "CloseButton"
    gui.CloseButton.Size = UDim2.new(0, 40, 0, 30)
    gui.CloseButton.Position = UDim2.new(1, -50, 0.5, -15)
    gui.CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    gui.CloseButton.BorderSizePixel = 0
    gui.CloseButton.Text = "×"
    gui.CloseButton.TextColor3 = CONFIG.COLORS.TEXT
    gui.CloseButton.TextSize = 20
    gui.CloseButton.Font = Enum.Font.GothamBold
    gui.CloseButton.Parent = gui.TitleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = gui.CloseButton
    
    -- Content Area
    gui.ContentFrame = Instance.new("ScrollingFrame")
    gui.ContentFrame.Name = "ContentFrame"
    gui.ContentFrame.Size = UDim2.new(1, -20, 1, -70)
    gui.ContentFrame.Position = UDim2.new(0, 10, 0, 60)
    gui.ContentFrame.BackgroundColor3 = CONFIG.COLORS.BACKGROUND
    gui.ContentFrame.BorderSizePixel = 0
    gui.ContentFrame.ScrollBarThickness = 6
    gui.ContentFrame.ScrollBarImageColor3 = CONFIG.COLORS.ACCENT
    gui.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    gui.ContentFrame.Parent = gui.MainFrame
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 8)
    contentCorner.Parent = gui.ContentFrame
    
    -- Layout for content
    gui.Layout = Instance.new("UIListLayout")
    gui.Layout.SortOrder = Enum.SortOrder.LayoutOrder
    gui.Layout.Padding = UDim.new(0, 8)
    gui.Layout.Parent = gui.ContentFrame
    
    -- Padding for content
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingLeft = UDim.new(0, 10)
    contentPadding.PaddingRight = UDim.new(0, 10)
    contentPadding.PaddingTop = UDim.new(0, 10)
    contentPadding.PaddingBottom = UDim.new(0, 10)
    contentPadding.Parent = gui.ContentFrame
    
    -- Variables for elements
    gui.elements = {}
    gui.visible = true
    
    -- Close button functionality
    gui.CloseButton.MouseButton1Click:Connect(function()
        gui:Toggle()
    end)
    
    -- Update canvas size when layout changes
    gui.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        gui.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, gui.Layout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Toggle function
    function gui:Toggle()
        self.visible = not self.visible
        local targetPos = self.visible and 
            UDim2.new(0.5, -175, 0.5, -250) or 
            UDim2.new(0.5, -175, 1, 50)
        
        local tween = TweenService:Create(
            self.MainFrame,
            TweenInfo.new(CONFIG.ANIMATIONS.DURATION, CONFIG.ANIMATIONS.EASING, CONFIG.ANIMATIONS.DIRECTION),
            {Position = targetPos}
        )
        tween:Play()
    end
    
    -- Add Button
    function gui:AddButton(text, callback)
        local button = Instance.new("TextButton")
        button.Name = "Button_" .. #self.elements
        button.Size = UDim2.new(1, 0, 0, 40)
        button.BackgroundColor3 = CONFIG.COLORS.SECONDARY
        button.BorderSizePixel = 0
        button.Text = text
        button.TextColor3 = CONFIG.COLORS.TEXT
        button.TextSize = 14
        button.Font = Enum.Font.Gotham
        button.Parent = self.ContentFrame
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button
        
        -- Hover effect
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.COLORS.ACCENT}):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.COLORS.SECONDARY}):Play()
        end)
        
        button.MouseButton1Click:Connect(callback)
        table.insert(self.elements, button)
        return button
    end
    
    -- Add Toggle
    function gui:AddToggle(text, default, callback)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = "Toggle_" .. #self.elements
        toggleFrame.Size = UDim2.new(1, 0, 0, 40)
        toggleFrame.BackgroundColor3 = CONFIG.COLORS.SECONDARY
        toggleFrame.BorderSizePixel = 0
        toggleFrame.Parent = self.ContentFrame
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 6)
        toggleCorner.Parent = toggleFrame
        
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Size = UDim2.new(1, -60, 1, 0)
        toggleLabel.Position = UDim2.new(0, 10, 0, 0)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Text = text
        toggleLabel.TextColor3 = CONFIG.COLORS.TEXT
        toggleLabel.TextSize = 14
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.Font = Enum.Font.Gotham
        toggleLabel.Parent = toggleFrame
        
        local toggleButton = Instance.new("TextButton")
        toggleButton.Size = UDim2.new(0, 40, 0, 24)
        toggleButton.Position = UDim2.new(1, -50, 0.5, -12)
        toggleButton.BackgroundColor3 = default and CONFIG.COLORS.ACCENT or Color3.fromRGB(100, 100, 100)
        toggleButton.BorderSizePixel = 0
        toggleButton.Text = ""
        toggleButton.Parent = toggleFrame
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 12)
        buttonCorner.Parent = toggleButton
        
        local toggleState = default
        
        toggleButton.MouseButton1Click:Connect(function()
            toggleState = not toggleState
            local newColor = toggleState and CONFIG.COLORS.ACCENT or Color3.fromRGB(100, 100, 100)
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = newColor}):Play()
            callback(toggleState)
        end)
        
        table.insert(self.elements, toggleFrame)
        return toggleFrame, function() return toggleState end
    end
    
    -- Add Slider
    function gui:AddSlider(text, min, max, default, callback)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Name = "Slider_" .. #self.elements
        sliderFrame.Size = UDim2.new(1, 0, 0, 60)
        sliderFrame.BackgroundColor3 = CONFIG.COLORS.SECONDARY
        sliderFrame.BorderSizePixel = 0
        sliderFrame.Parent = self.ContentFrame
        
        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(0, 6)
        sliderCorner.Parent = sliderFrame
        
        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.Size = UDim2.new(0.7, 0, 0, 20)
        sliderLabel.Position = UDim2.new(0, 10, 0, 5)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Text = text
        sliderLabel.TextColor3 = CONFIG.COLORS.TEXT
        sliderLabel.TextSize = 14
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        sliderLabel.Font = Enum.Font.Gotham
        sliderLabel.Parent = sliderFrame
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0.3, -10, 0, 20)
        valueLabel.Position = UDim2.new(0.7, 0, 0, 5)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(default)
        valueLabel.TextColor3 = CONFIG.COLORS.ACCENT
        valueLabel.TextSize = 14
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.Parent = sliderFrame
        
        local sliderBG = Instance.new("Frame")
        sliderBG.Size = UDim2.new(1, -20, 0, 8)
        sliderBG.Position = UDim2.new(0, 10, 1, -18)
        sliderBG.BackgroundColor3 = CONFIG.COLORS.BACKGROUND
        sliderBG.BorderSizePixel = 0
        sliderBG.Parent = sliderFrame
        
        local sliderBGCorner = Instance.new("UICorner")
        sliderBGCorner.CornerRadius = UDim.new(0, 4)
        sliderBGCorner.Parent = sliderBG
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        sliderFill.Position = UDim2.new(0, 0, 0, 0)
        sliderFill.BackgroundColor3 = CONFIG.COLORS.ACCENT
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBG
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(0, 4)
        fillCorner.Parent = sliderFill
        
        local currentValue = default
        local dragging = false
        
        sliderBG.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local mouse = UserInputService:GetMouseLocation()
                local relativeX = math.clamp((mouse.X - sliderBG.AbsolutePosition.X) / sliderBG.AbsoluteSize.X, 0, 1)
                currentValue = min + (max - min) * relativeX
                currentValue = math.floor(currentValue * 10) / 10
                
                valueLabel.Text = tostring(currentValue)
                TweenService:Create(sliderFill, TweenInfo.new(0.1), {Size = UDim2.new(relativeX, 0, 1, 0)}):Play()
                callback(currentValue)
            end
        end)
        
        table.insert(self.elements, sliderFrame)
        return sliderFrame, function() return currentValue end
    end
    
    -- Add TextBox
    function gui:AddTextBox(placeholder, callback)
        local textBox = Instance.new("TextBox")
        textBox.Name = "TextBox_" .. #self.elements
        textBox.Size = UDim2.new(1, 0, 0, 40)
        textBox.BackgroundColor3 = CONFIG.COLORS.BACKGROUND
        textBox.BorderSizePixel = 0
        textBox.PlaceholderText = placeholder
        textBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
        textBox.Text = ""
        textBox.TextColor3 = CONFIG.COLORS.TEXT
        textBox.TextSize = 14
        textBox.Font = Enum.Font.Gotham
        textBox.ClearTextOnFocus = false
        textBox.Parent = self.ContentFrame
        
        local textBoxCorner = Instance.new("UICorner")
        textBoxCorner.CornerRadius = UDim.new(0, 6)
        textBoxCorner.Parent = textBox
        
        textBox.FocusLost:Connect(function()
            callback(textBox.Text)
        end)
        
        table.insert(self.elements, textBox)
        return textBox
    end
    
    -- Add Label
    function gui:AddLabel(text)
        local label = Instance.new("TextLabel")
        label.Name = "Label_" .. #self.elements
        label.Size = UDim2.new(1, 0, 0, 30)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = CONFIG.COLORS.TEXT
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.Gotham
        label.Parent = self.ContentFrame
        
        table.insert(self.elements, label)
        return label
    end
    
    -- Destroy function
    function gui:Destroy()
        self.ScreenGui:Destroy()
    end
    
    return gui
end

return C00lGUI
