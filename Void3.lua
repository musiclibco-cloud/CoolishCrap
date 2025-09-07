-- VoidUI v3.0 - Void Nexus Edition 🌌
-- Spiced up, mobile-optimized, and way more stable
-- Original concept by VoidUi Dev, enhanced for the void

local VoidUI = {}
VoidUI.__index = VoidUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Void Theme Configuration 🌌
local VOID = {
    COLORS = {
        DEEP_VOID = Color3.fromRGB(8, 0, 20),
        VOID_PURPLE = Color3.fromRGB(25, 0, 55),
        COSMIC_PURPLE = Color3.fromRGB(40, 0, 90),
        NEBULA_GLOW = Color3.fromRGB(170, 85, 255),
        STELLAR_WHITE = Color3.fromRGB(255, 255, 255),
        SHADOW_GRAY = Color3.fromRGB(150, 150, 150)
    },
    ANIMS = {
        FAST = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        SMOOTH = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        BOUNCE = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    }
}

-- Create Window
function VoidUI:CreateWindow(title)
    local self = setmetatable({}, VoidUI)
    
    -- Main ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "VoidNexus"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = CoreGui
    
    -- Main Window with glow effect
    self.Window = Instance.new("Frame")
    self.Window.Name = "VoidWindow"
    self.Window.Size = UDim2.new(0, 480, 0, 320)
    self.Window.Position = UDim2.new(0.5, -240, 0.5, -160)
    self.Window.BackgroundColor3 = VOID.COLORS.VOID_PURPLE
    self.Window.BorderSizePixel = 0
    self.Window.Active = true
    self.Window.Draggable = true
    self.Window.Parent = self.ScreenGui
    
    -- Rounded corners
    local windowCorner = Instance.new("UICorner")
    windowCorner.CornerRadius = UDim.new(0, 12)
    windowCorner.Parent = self.Window
    
    -- Void glow effect
    local glow = Instance.new("Frame")
    glow.Name = "VoidGlow"
    glow.Size = UDim2.new(1, 20, 1, 20)
    glow.Position = UDim2.new(0, -10, 0, -10)
    glow.BackgroundColor3 = VOID.COLORS.NEBULA_GLOW
    glow.BackgroundTransparency = 0.8
    glow.ZIndex = self.Window.ZIndex - 1
    glow.Parent = self.Window
    
    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(0, 18)
    glowCorner.Parent = glow
    
    -- Animated glow pulse
    spawn(function()
        while self.Window.Parent do
            TweenService:Create(glow, VOID.ANIMS.SMOOTH, {BackgroundTransparency = 0.6}):Play()
            wait(0.35)
            TweenService:Create(glow, VOID.ANIMS.SMOOTH, {BackgroundTransparency = 0.9}):Play()
            wait(0.35)
        end
    end)
    
    -- Title Bar with gradient
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 40)
    self.TitleBar.BackgroundColor3 = VOID.COLORS.COSMIC_PURPLE
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.Window
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = self.TitleBar
    
    local titleGradient = Instance.new("UIGradient")
    titleGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, VOID.COLORS.COSMIC_PURPLE),
        ColorSequenceKeypoint.new(1, VOID.COLORS.NEBULA_GLOW)
    }
    titleGradient.Rotation = 90
    titleGradient.Parent = self.TitleBar
    
    -- Title Text with glow
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    self.TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = title or "🌌 Void Nexus"
    self.TitleLabel.TextColor3 = VOID.COLORS.STELLAR_WHITE
    self.TitleLabel.TextSize = 18
    self.TitleLabel.TextStrokeTransparency = 0.5
    self.TitleLabel.TextStrokeColor3 = VOID.COLORS.NEBULA_GLOW
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Parent = self.TitleBar
    
    -- Close Button
    self.CloseBtn = Instance.new("TextButton")
    self.CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    self.CloseBtn.Position = UDim2.new(1, -40, 0, 5)
    self.CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    self.CloseBtn.Text = "×"
    self.CloseBtn.TextColor3 = VOID.COLORS.STELLAR_WHITE
    self.CloseBtn.TextSize = 20
    self.CloseBtn.Font = Enum.Font.GothamBold
    self.CloseBtn.BorderSizePixel = 0
    self.CloseBtn.Parent = self.TitleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = self.CloseBtn
    
    -- Minimize Button
    self.MinBtn = Instance.new("TextButton")
    self.MinBtn.Size = UDim2.new(0, 30, 0, 30)
    self.MinBtn.Position = UDim2.new(1, -75, 0, 5)
    self.MinBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    self.MinBtn.Text = "–"
    self.MinBtn.TextColor3 = VOID.COLORS.STELLAR_WHITE
    self.MinBtn.TextSize = 18
    self.MinBtn.Font = Enum.Font.GothamBold
    self.MinBtn.BorderSizePixel = 0
    self.MinBtn.Parent = self.TitleBar
    
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 6)
    minCorner.Parent = self.MinBtn
    
    -- Tab Container
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Size = UDim2.new(0, 120, 1, -40)
    self.TabContainer.Position = UDim2.new(0, 0, 0, 40)
    self.TabContainer.BackgroundColor3 = VOID.COLORS.DEEP_VOID
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.Parent = self.Window
    
    -- Content Area
    self.ContentArea = Instance.new("Frame")
    self.ContentArea.Size = UDim2.new(1, -120, 1, -40)
    self.ContentArea.Position = UDim2.new(0, 120, 0, 40)
    self.ContentArea.BackgroundColor3 = VOID.COLORS.VOID_PURPLE
    self.ContentArea.BorderSizePixel = 0
    self.ContentArea.Parent = self.Window
    
    -- Made by signature (animated)
    self.Signature = Instance.new("TextLabel")
    self.Signature.Size = UDim2.new(1, 0, 0, 20)
    self.Signature.Position = UDim2.new(0, 0, 1, -20)
    self.Signature.BackgroundTransparency = 1
    self.Signature.Text = "🌌 VoidUI v3.0 - Nexus Edition"
    self.Signature.TextColor3 = VOID.COLORS.NEBULA_GLOW
    self.Signature.TextSize = 12
    self.Signature.Font = Enum.Font.GothamBold
    self.Signature.TextXAlignment = Enum.TextXAlignment.Center
    self.Signature.Parent = self.TabContainer
    
    -- Variables
    self.tabs = {}
    self.activeTab = nil
    self.minimized = false
    self.originalSize = self.Window.Size
    
    -- Button animations
    local function addButtonAnim(button)
        button.MouseEnter:Connect(function()
            TweenService:Create(button, VOID.ANIMS.FAST, {Size = button.Size + UDim2.new(0, 2, 0, 2)}):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, VOID.ANIMS.FAST, {Size = button.Size - UDim2.new(0, 2, 0, 2)}):Play()
        end)
    end
    
    addButtonAnim(self.CloseBtn)
    addButtonAnim(self.MinBtn)
    
    -- Close functionality
    self.CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(self.Window, VOID.ANIMS.SMOOTH, {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        wait(0.4)
        self.ScreenGui:Destroy()
    end)
    
    -- Minimize functionality
    self.MinBtn.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)
    
    return self
end

-- Toggle minimize with smooth animation
function VoidUI:ToggleMinimize()
    self.minimized = not self.minimized
    local targetSize = self.minimized and UDim2.new(0, 480, 0, 40) or self.originalSize
    
    TweenService:Create(self.Window, VOID.ANIMS.BOUNCE, {Size = targetSize}):Play()
    
    self.TabContainer.Visible = not self.minimized
    self.ContentArea.Visible = not self.minimized
end

-- Create Tab
function VoidUI:CreateTab(name, icon)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(1, -10, 0, 35)
    tabButton.Position = UDim2.new(0, 5, 0, #self.tabs * 40 + 5)
    tabButton.BackgroundColor3 = VOID.COLORS.COSMIC_PURPLE
    tabButton.BorderSizePixel = 0
    tabButton.Text = (icon or "⚫") .. " " .. name
    tabButton.TextColor3 = VOID.COLORS.STELLAR_WHITE
    tabButton.TextSize = 14
    tabButton.Font = Enum.Font.Gotham
    tabButton.Parent = self.TabContainer
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabButton
    
    -- Tab content frame
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, -20, 1, -20)
    contentFrame.Position = UDim2.new(0, 10, 0, 10)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 4
    contentFrame.ScrollBarImageColor3 = VOID.COLORS.NEBULA_GLOW
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentFrame.Visible = false
    contentFrame.Parent = self.ContentArea
    
    -- Content layout
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = contentFrame
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)
    
    local tab = {
        name = name,
        button = tabButton,
        content = contentFrame,
        elements = {}
    }
    
    -- Tab click animation and selection
    tabButton.MouseButton1Click:Connect(function()
        self:SelectTab(name)
    end)
    
    -- Tab hover effect
    tabButton.MouseEnter:Connect(function()
        if self.activeTab ~= tab then
            TweenService:Create(tabButton, VOID.ANIMS.FAST, {BackgroundColor3 = VOID.COLORS.NEBULA_GLOW}):Play()
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if self.activeTab ~= tab then
            TweenService:Create(tabButton, VOID.ANIMS.FAST, {BackgroundColor3 = VOID.COLORS.COSMIC_PURPLE}):Play()
        end
    end)
    
    table.insert(self.tabs, tab)
    
    -- Auto-select first tab
    if #self.tabs == 1 then
        self:SelectTab(name)
    end
    
    return tab
end

-- Select Tab with animation
function VoidUI:SelectTab(name)
    for _, tab in ipairs(self.tabs) do
        if tab.name == name then
            -- Show selected tab content
            tab.content.Visible = true
            TweenService:Create(tab.button, VOID.ANIMS.FAST, {BackgroundColor3 = VOID.COLORS.NEBULA_GLOW}):Play()
            self.activeTab = tab
        else
            -- Hide other tabs
            tab.content.Visible = false
            TweenService:Create(tab.button, VOID.ANIMS.FAST, {BackgroundColor3 = VOID.COLORS.COSMIC_PURPLE}):Play()
        end
    end
end

-- Add Button to Tab
function VoidUI:AddButton(tab, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 35)
    button.BackgroundColor3 = VOID.COLORS.COSMIC_PURPLE
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = VOID.COLORS.STELLAR_WHITE
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.Parent = tab.content
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    -- Button effects
    button.MouseEnter:Connect(function()
        TweenService:Create(button, VOID.ANIMS.FAST, {BackgroundColor3 = VOID.COLORS.NEBULA_GLOW}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, VOID.ANIMS.FAST, {BackgroundColor3 = VOID.COLORS.COSMIC_PURPLE}):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        -- Click animation
        TweenService:Create(button, TweenInfo.new(0.1), {Size = button.Size - UDim2.new(0, 4, 0, 4)}):Play()
        wait(0.1)
        TweenService:Create(button, TweenInfo.new(0.1), {Size = button.Size + UDim2.new(0, 4, 0, 4)}):Play()
        callback()
    end)
    
    table.insert(tab.elements, button)
    return button
end

-- Add Toggle to Tab
function VoidUI:AddToggle(tab, text, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 35)
    toggleFrame.BackgroundColor3 = VOID.COLORS.COSMIC_PURPLE
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = tab.content
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 6)
    frameCorner.Parent = toggleFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = VOID.COLORS.STELLAR_WHITE
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 30, 0, 20)
    toggle.Position = UDim2.new(1, -40, 0.5, -10)
    toggle.BackgroundColor3 = default and VOID.COLORS.NEBULA_GLOW or VOID.COLORS.SHADOW_GRAY
    toggle.BorderSizePixel = 0
    toggle.Text = ""
    toggle.Parent = toggleFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 10)
    toggleCorner.Parent = toggle
    
    local state = default
    
    toggle.MouseButton1Click:Connect(function()
        state = not state
        local newColor = state and VOID.COLORS.NEBULA_GLOW or VOID.COLORS.SHADOW_GRAY
        TweenService:Create(toggle, VOID.ANIMS.FAST, {BackgroundColor3 = newColor}):Play()
        callback(state)
    end)
    
    table.insert(tab.elements, toggleFrame)
    return toggleFrame, function() return state end
end

-- Add Label to Tab
function VoidUI:AddLabel(tab, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 25)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = VOID.COLORS.NEBULA_GLOW
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = tab.content
    
    table.insert(tab.elements, label)
    return label
end

return VoidUI
