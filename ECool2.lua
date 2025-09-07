-- C00lGUI Reborn v2.0 -- turned into a lib by **Swimmiel** on RBLX and **bestonlyteto** on dscrd
-- Grid-based layout inspired by c00lx design

local C00lGUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Configuration
local CONFIG = {
    COLORS = {
        BACKGROUND = Color3.fromRGB(20, 20, 20),
        SECONDARY = Color3.fromRGB(35, 35, 35),
        ACCENT = Color3.fromRGB(220, 50, 50),
        ACCENT_HOVER = Color3.fromRGB(255, 70, 70),
        TEXT = Color3.fromRGB(255, 255, 255),
        TEXT_DIM = Color3.fromRGB(180, 180, 180),
        BORDER = Color3.fromRGB(60, 60, 60)
    },
    ANIMATIONS = {
        DURATION = 0.25,
        EASING = Enum.EasingStyle.Quad,
        DIRECTION = Enum.EasingDirection.Out
    },
    MOBILE = {
        BASE_SIZE = UDim2.new(0, 380, 0, 500),
        BUTTON_HEIGHT = 35,
        GRID_COLUMNS = 4,
        PADDING = 6
    }
}

-- Main GUI Constructor
function C00lGUI.new(title)
    local gui = {}
    
    -- Create ScreenGui
    gui.ScreenGui = Instance.new("ScreenGui")
    gui.ScreenGui.Name = "C00lGUI_Reborn"
    gui.ScreenGui.ResetOnSpawn = false
    gui.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.ScreenGui.Parent = CoreGui
    
    -- Main Container
    gui.MainFrame = Instance.new("Frame")
    gui.MainFrame.Name = "MainContainer"
    gui.MainFrame.Size = CONFIG.MOBILE.BASE_SIZE
    gui.MainFrame.Position = UDim2.new(0.5, -190, 0.5, -250)
    gui.MainFrame.BackgroundColor3 = CONFIG.COLORS.BACKGROUND
    gui.MainFrame.BorderSizePixel = 2
    gui.MainFrame.BorderColor3 = CONFIG.COLORS.ACCENT
    gui.MainFrame.Active = true
    gui.MainFrame.Draggable = true
    gui.MainFrame.Parent = gui.ScreenGui
    
    -- Title Bar
    gui.TitleBar = Instance.new("Frame")
    gui.TitleBar.Name = "TitleBar"
    gui.TitleBar.Size = UDim2.new(1, 0, 0, 45)
    gui.TitleBar.Position = UDim2.new(0, 0, 0, 0)
    gui.TitleBar.BackgroundColor3 = CONFIG.COLORS.SECONDARY
    gui.TitleBar.BorderSizePixel = 0
    gui.TitleBar.Parent = gui.MainFrame
    
    -- Title Text
    gui.TitleLabel = Instance.new("TextLabel")
    gui.TitleLabel.Name = "TitleLabel"
    gui.TitleLabel.Size = UDim2.new(1, -90, 1, 0)
    gui.TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    gui.TitleLabel.BackgroundTransparency = 1
    gui.TitleLabel.Text = title or "c00lgui Reborn Rc7 by v3rx"
    gui.TitleLabel.TextColor3 = CONFIG.COLORS.TEXT
    gui.TitleLabel.TextSize = 14
    gui.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    gui.TitleLabel.Font = Enum.Font.SourceSans
    gui.TitleLabel.Parent = gui.TitleBar
    
    -- Navigation Arrows
    gui.LeftArrow = Instance.new("TextButton")
    gui.LeftArrow.Name = "LeftArrow"
    gui.LeftArrow.Size = UDim2.new(0, 30, 0, 25)
    gui.LeftArrow.Position = UDim2.new(1, -75, 0.5, -12)
    gui.LeftArrow.BackgroundColor3 = CONFIG.COLORS.ACCENT
    gui.LeftArrow.BorderSizePixel = 1
    gui.LeftArrow.BorderColor3 = CONFIG.COLORS.BORDER
    gui.LeftArrow.Text = "<"
    gui.LeftArrow.TextColor3 = CONFIG.COLORS.TEXT
    gui.LeftArrow.TextSize = 16
    gui.LeftArrow.Font = Enum.Font.SourceSansBold
    gui.LeftArrow.Parent = gui.TitleBar
    
    gui.RightArrow = Instance.new("TextButton")
    gui.RightArrow.Name = "RightArrow"
    gui.RightArrow.Size = UDim2.new(0, 30, 0, 25)
    gui.RightArrow.Position = UDim2.new(1, -40, 0.5, -12)
    gui.RightArrow.BackgroundColor3 = CONFIG.COLORS.ACCENT
    gui.RightArrow.BorderSizePixel = 1
    gui.RightArrow.BorderColor3 = CONFIG.COLORS.BORDER
    gui.RightArrow.Text = ">"
    gui.RightArrow.TextColor3 = CONFIG.COLORS.TEXT
    gui.RightArrow.TextSize = 16
    gui.RightArrow.Font = Enum.Font.SourceSansBold
    gui.RightArrow.Parent = gui.TitleBar
    
    -- Tab Container
    gui.TabContainer = Instance.new("Frame")
    gui.TabContainer.Name = "TabContainer"
    gui.TabContainer.Size = UDim2.new(1, -20, 1, -90)
    gui.TabContainer.Position = UDim2.new(0, 10, 0, 55)
    gui.TabContainer.BackgroundColor3 = CONFIG.COLORS.SECONDARY
    gui.TabContainer.BorderSizePixel = 1
    gui.TabContainer.BorderColor3 = CONFIG.COLORS.BORDER
    gui.TabContainer.Parent = gui.MainFrame
    
    -- Close Button
    gui.CloseButton = Instance.new("TextButton")
    gui.CloseButton.Name = "CloseButton"
    gui.CloseButton.Size = UDim2.new(1, -20, 0, 25)
    gui.CloseButton.Position = UDim2.new(0, 10, 1, -35)
    gui.CloseButton.BackgroundColor3 = CONFIG.COLORS.ACCENT
    gui.CloseButton.BorderSizePixel = 1
    gui.CloseButton.BorderColor3 = CONFIG.COLORS.BORDER
    gui.CloseButton.Text = "Close"
    gui.CloseButton.TextColor3 = CONFIG.COLORS.TEXT
    gui.CloseButton.TextSize = 14
    gui.CloseButton.Font = Enum.Font.SourceSansBold
    gui.CloseButton.Parent = gui.MainFrame
    
    -- Variables
    gui.tabs = {}
    gui.currentTab = 1
    gui.visible = true
    
    -- Button hover effects
    local function addHoverEffect(button)
        local originalColor = button.BackgroundColor3
        
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = CONFIG.COLORS.ACCENT_HOVER
            }):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = originalColor
            }):Play()
        end)
    end
    
    addHoverEffect(gui.LeftArrow)
    addHoverEffect(gui.RightArrow)
    addHoverEffect(gui.CloseButton)
    
    -- Navigation functionality
    gui.LeftArrow.MouseButton1Click:Connect(function()
        if gui.currentTab > 1 then
            gui.currentTab = gui.currentTab - 1
            gui:UpdateTab()
        end
    end)
    
    gui.RightArrow.MouseButton1Click:Connect(function()
        if gui.currentTab < #gui.tabs then
            gui.currentTab = gui.currentTab + 1
            gui:UpdateTab()
        end
    end)
    
    -- Close button functionality
    gui.CloseButton.MouseButton1Click:Connect(function()
        gui:Toggle()
    end)
    
    -- Toggle function
    function gui:Toggle()
        self.visible = not self.visible
        local targetPos = self.visible and 
            UDim2.new(0.5, -190, 0.5, -250) or 
            UDim2.new(0.5, -190, 1, 50)
        
        local tween = TweenService:Create(
            self.MainFrame,
            TweenInfo.new(CONFIG.ANIMATIONS.DURATION, CONFIG.ANIMATIONS.EASING, CONFIG.ANIMATIONS.DIRECTION),
            {Position = targetPos}
        )
        tween:Play()
    end
    
    -- Create Tab
    function gui:CreateTab(name)
        local tab = {
            name = name,
            frame = nil,
            buttons = {},
            currentSection = nil
        }
        
        -- Tab Frame
        tab.frame = Instance.new("Frame")
        tab.frame.Name = name .. "_Tab"
        tab.frame.Size = UDim2.new(1, -12, 1, -12)
        tab.frame.Position = UDim2.new(0, 6, 0, 6)
        tab.frame.BackgroundColor3 = CONFIG.COLORS.BACKGROUND
        tab.frame.BorderSizePixel = 0
        tab.frame.Visible = #self.tabs == 0
        tab.frame.Parent = self.TabContainer
        
        -- Section Label Frame
        tab.sectionFrame = Instance.new("Frame")
        tab.sectionFrame.Name = "SectionFrame"
        tab.sectionFrame.Size = UDim2.new(1, 0, 0, 30)
        tab.sectionFrame.Position = UDim2.new(0, 0, 0, 0)
        tab.sectionFrame.BackgroundColor3 = CONFIG.COLORS.SECONDARY
        tab.sectionFrame.BorderSizePixel = 1
        tab.sectionFrame.BorderColor3 = CONFIG.COLORS.BORDER
        tab.sectionFrame.Parent = tab.frame
        
        tab.sectionLabel = Instance.new("TextLabel")
        tab.sectionLabel.Size = UDim2.new(1, 0, 1, 0)
        tab.sectionLabel.BackgroundTransparency = 1
        tab.sectionLabel.Text = "Select a category"
        tab.sectionLabel.TextColor3 = CONFIG.COLORS.TEXT
        tab.sectionLabel.TextSize = 12
        tab.sectionLabel.Font = Enum.Font.SourceSans
        tab.sectionLabel.Parent = tab.sectionFrame
        
        -- Button Grid Container
        tab.gridFrame = Instance.new("Frame")
        tab.gridFrame.Name = "GridFrame"
        tab.gridFrame.Size = UDim2.new(1, -12, 1, -42)
        tab.gridFrame.Position = UDim2.new(0, 6, 0, 36)
        tab.gridFrame.BackgroundTransparency = 1
        tab.gridFrame.Parent = tab.frame
        
        -- Grid Layout
        tab.gridLayout = Instance.new("UIGridLayout")
        tab.gridLayout.CellSize = UDim2.new(0, 80, 0, CONFIG.MOBILE.BUTTON_HEIGHT)
        tab.gridLayout.CellPadding = UDim2.new(0, CONFIG.MOBILE.PADDING, 0, CONFIG.MOBILE.PADDING)
        tab.gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tab.gridLayout.Parent = tab.gridFrame
        
        table.insert(self.tabs, tab)
        return tab
    end
    
    -- Add Section
    function gui:AddSection(tabIndex, sectionName)
        if self.tabs[tabIndex] then
            local tab = self.tabs[tabIndex]
            tab.currentSection = sectionName
            tab.sectionLabel.Text = sectionName
        end
    end
    
    -- Add Button to Tab
    function gui:AddButton(tabIndex, text, callback, isEmpty)
        if not self.tabs[tabIndex] then return end
        
        local tab = self.tabs[tabIndex]
        
        local button = Instance.new("TextButton")
        button.Name = text .. "_Button"
        button.Size = UDim2.new(1, 0, 1, 0)
        button.BackgroundColor3 = isEmpty and CONFIG.COLORS.BACKGROUND or CONFIG.COLORS.SECONDARY
        button.BorderSizePixel = 1
        button.BorderColor3 = CONFIG.COLORS.BORDER
        button.Text = isEmpty and "" or text
        button.TextColor3 = CONFIG.COLORS.TEXT
        button.TextSize = 10
        button.Font = Enum.Font.SourceSans
        button.TextScaled = true
        button.LayoutOrder = #tab.buttons + 1
        button.Parent = tab.gridFrame
        
        if not isEmpty then
            -- Hover effect
            button.MouseEnter:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.2), {
                    BackgroundColor3 = CONFIG.COLORS.ACCENT
                }):Play()
            end)
            
            button.MouseLeave:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.2), {
                    BackgroundColor3 = CONFIG.COLORS.SECONDARY
                }):Play()
            end)
            
            button.MouseButton1Click:Connect(callback)
        end
        
        table.insert(tab.buttons, button)
        return button
    end
    
    -- Add Toggle Button
    function gui:AddToggle(tabIndex, text, default, callback)
        if not self.tabs[tabIndex] then return end
        
        local tab = self.tabs[tabIndex]
        local isEnabled = default
        
        local button = Instance.new("TextButton")
        button.Name = text .. "_Toggle"
        button.Size = UDim2.new(1, 0, 1, 0)
        button.BackgroundColor3 = isEnabled and CONFIG.COLORS.ACCENT or CONFIG.COLORS.SECONDARY
        button.BorderSizePixel = 1
        button.BorderColor3 = CONFIG.COLORS.BORDER
        button.Text = text
        button.TextColor3 = CONFIG.COLORS.TEXT
        button.TextSize = 10
        button.Font = Enum.Font.SourceSans
        button.TextScaled = true
        button.LayoutOrder = #tab.buttons + 1
        button.Parent = tab.gridFrame
        
        button.MouseButton1Click:Connect(function()
            isEnabled = not isEnabled
            local newColor = isEnabled and CONFIG.COLORS.ACCENT or CONFIG.COLORS.SECONDARY
            
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = newColor
            }):Play()
            
            callback(isEnabled)
        end)
        
        table.insert(tab.buttons, button)
        return button, function() return isEnabled end
    end
    
    -- Update current tab display
    function gui:UpdateTab()
        for i, tab in ipairs(self.tabs) do
            tab.frame.Visible = i == self.currentTab
        end
    end
    
    -- Add Empty Slots (for grid alignment)
    function gui:FillEmptySlots(tabIndex, count)
        for i = 1, count do
            self:AddButton(tabIndex, "", function() end, true)
        end
    end
    
    -- Destroy function
    function gui:Destroy()
        self.ScreenGui:Destroy()
    end
    
    return gui
end

return C00lGUI
