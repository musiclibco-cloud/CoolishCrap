local HoneycombCMD = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

-- Configuration
local Config = {
    Theme = {
        Primary = Color3.fromRGB(20, 20, 20),      -- Dark background
        Secondary = Color3.fromRGB(40, 40, 40),    -- Lighter background
        Accent = Color3.fromRGB(220, 50, 50),      -- Red accent
        AccentDark = Color3.fromRGB(180, 40, 40),  -- Darker red
        Text = Color3.fromRGB(255, 255, 255),      -- White text
        TextDim = Color3.fromRGB(180, 180, 180),   -- Gray text
        Success = Color3.fromRGB(50, 220, 50),     -- Green
        Warning = Color3.fromRGB(220, 220, 50),    -- Yellow
        Error = Color3.fromRGB(220, 50, 50),       -- Red
    },
    Prefix = "/",
    CmdBarKey = Enum.KeyCode.Semicolon,
    MaxHistory = 50,
    AutoCompleteLimit = 10,
}

-- Internal state
local commands = {}
local commandHistory = {}
local chatConnection = nil
local cmdBarGui = nil
local isCommandBarOpen = false
local currentSuggestionIndex = 0
local suggestions = {}

-- Utility functions
local function CreateCorner(radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    return corner
end

local function CreateStroke(color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Config.Theme.Accent
    stroke.Thickness = thickness or 1
    return stroke
end

local function CreatePadding(padding)
    local pad = Instance.new("UIPadding")
    if typeof(padding) == "number" then
        pad.PaddingTop = UDim.new(0, padding)
        pad.PaddingBottom = UDim.new(0, padding)
        pad.PaddingLeft = UDim.new(0, padding)
        pad.PaddingRight = UDim.new(0, padding)
    else
        pad.PaddingTop = UDim.new(0, padding.Top or 0)
        pad.PaddingBottom = UDim.new(0, padding.Bottom or 0)
        pad.PaddingLeft = UDim.new(0, padding.Left or 0)
        pad.PaddingRight = UDim.new(0, padding.Right or 0)
    end
    return pad
end

local function CreateLayout(direction, padding)
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = direction or Enum.FillDirection.Vertical
    layout.Padding = UDim.new(0, padding or 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    return layout
end

-- Notification system
local function ShowNotification(text, type, duration)
    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "HoneycombNotification"
    notifGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    notifGui.DisplayOrder = 999
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 60)
    frame.Position = UDim2.new(1, -320, 0, 20)
    frame.BackgroundColor3 = Config.Theme.Secondary
    frame.Parent = notifGui
    CreateCorner(8).Parent = frame
    CreateStroke(type == "error" and Config.Theme.Error or 
                 type == "success" and Config.Theme.Success or 
                 type == "warning" and Config.Theme.Warning or 
                 Config.Theme.Accent, 2).Parent = frame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 1, 0)
    textLabel.Position = UDim2.new(0, 10, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Config.Theme.Text
    textLabel.Font = Enum.Font.GothamMedium
    textLabel.TextSize = 14
    textLabel.TextWrapped = true
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = frame
    
    -- Animate in
    frame.Position = UDim2.new(1, 20, 0, 20)
    local tweenIn = TweenService:Create(frame, 
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(1, -320, 0, 20)}
    )
    tweenIn:Play()
    
    -- Auto remove
    local function removeNotification()
        local tweenOut = TweenService:Create(frame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {Position = UDim2.new(1, 20, 0, 20)}
        )
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            notifGui:Destroy()
        end)
    end
    
    task.wait(duration or 3)
    removeNotification()
end

-- Argument parsing utilities
local function ParseArguments(argString, expectedArgs)
    local args = {}
    local current = ""
    local inQuotes = false
    local quoteChar = nil
    
    for i = 1, #argString do
        local char = argString:sub(i, i)
        
        if (char == '"' or char == "'") and not inQuotes then
            inQuotes = true
            quoteChar = char
        elseif char == quoteChar and inQuotes then
            inQuotes = false
            quoteChar = nil
        elseif char == " " and not inQuotes then
            if current ~= "" then
                table.insert(args, current)
                current = ""
            end
        else
            current = current .. char
        end
    end
    
    if current ~= "" then
        table.insert(args, current)
    end
    
    -- Type conversion based on expected args
    for i, arg in ipairs(args) do
        if expectedArgs and expectedArgs[i] then
            local expectedType = expectedArgs[i].type
            if expectedType == "number" then
                local num = tonumber(arg)
                if num then
                    args[i] = num
                else
                    return nil, "Argument " .. i .. " must be a number"
                end
            elseif expectedType == "player" then
                local player = FindPlayer(arg)
                if player then
                    args[i] = player
                else
                    return nil, "Player '" .. arg .. "' not found"
                end
            elseif expectedType == "boolean" then
                local lower = arg:lower()
                if lower == "true" or lower == "1" or lower == "yes" then
                    args[i] = true
                elseif lower == "false" or lower == "0" or lower == "no" then
                    args[i] = false
                else
                    return nil, "Argument " .. i .. " must be true/false"
                end
            end
        end
    end
    
    return args
end

local function FindPlayer(name)
    local nameLower = name:lower()
    
    -- Exact match first
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower() == nameLower or player.DisplayName:lower() == nameLower then
            return player
        end
    end
    
    -- Partial match
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower():find(nameLower, 1, true) or 
           player.DisplayName:lower():find(nameLower, 1, true) then
            return player
        end
    end
    
    return nil
end

-- Command execution
local function ExecuteCommand(commandLine)
    local parts = commandLine:split(" ")
    local cmdName = parts[1]:lower()
    local argString = commandLine:sub(#parts[1] + 2)
    
    if commands[cmdName] then
        local cmd = commands[cmdName]
        local args, error = ParseArguments(argString, cmd.args)
        
        if error then
            ShowNotification("Error: " .. error, "error")
            return false
        end
        
        -- Check required arguments
        if cmd.args then
            for i, argDef in ipairs(cmd.args) do
                if argDef.required and not args[i] then
                    ShowNotification("Error: Missing required argument: " .. argDef.name, "error")
                    return false
                end
            end
        end
        
        -- Add to history
        table.insert(commandHistory, 1, commandLine)
        if #commandHistory > Config.MaxHistory then
            table.remove(commandHistory, #commandHistory)
        end
        
        -- Execute command
        pcall(function()
            cmd.callback(args or {})
        end)
        
        return true
    else
        ShowNotification("Unknown command: " .. cmdName .. ". Type /help for available commands.", "error")
        return false
    end
end

-- Auto-complete system
local function GetCommandSuggestions(input)
    local suggestions = {}
    local inputLower = input:lower()
    
    for cmdName, cmd in pairs(commands) do
        if cmdName:find(inputLower, 1, true) then
            table.insert(suggestions, {
                name = cmdName,
                description = cmd.description or "No description",
                usage = cmd.usage or ("/" .. cmdName)
            })
        end
    end
    
    -- Sort by relevance (exact matches first, then alphabetical)
    table.sort(suggestions, function(a, b)
        local aStarts = a.name:lower():sub(1, #inputLower) == inputLower
        local bStarts = b.name:lower():sub(1, #inputLower) == inputLower
        
        if aStarts and not bStarts then return true end
        if bStarts and not aStarts then return false end
        
        return a.name < b.name
    end)
    
    -- Limit results
    local limited = {}
    for i = 1, math.min(#suggestions, Config.AutoCompleteLimit) do
        table.insert(limited, suggestions[i])
    end
    
    return limited
end

-- Create floating command bar
local function CreateCommandBar()
    if cmdBarGui then
        cmdBarGui:Destroy()
    end
    
    cmdBarGui = Instance.new("ScreenGui")
    cmdBarGui.Name = "HoneycombCMDBar"
    cmdBarGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    cmdBarGui.DisplayOrder = 100
    cmdBarGui.ResetOnSpawn = false
    
    -- Main container
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(0, 600, 0, 40)
    container.Position = UDim2.new(0.5, -300, 1, -60)
    container.BackgroundColor3 = Config.Theme.Primary
    container.Parent = cmdBarGui
    container.Visible = false
    CreateCorner(8).Parent = container
    CreateStroke(Config.Theme.Accent, 2).Parent = container
    
    -- Input box
    local inputBox = Instance.new("TextBox")
    inputBox.Name = "InputBox"
    inputBox.Size = UDim2.new(1, -20, 1, -10)
    inputBox.Position = UDim2.new(0, 10, 0, 5)
    inputBox.BackgroundTransparency = 1
    inputBox.Text = ""
    inputBox.PlaceholderText = "Enter command... (Press Tab for suggestions)"
    inputBox.PlaceholderColor3 = Config.Theme.TextDim
    inputBox.TextColor3 = Config.Theme.Text
    inputBox.Font = Enum.Font.GothamMedium
    inputBox.TextSize = 16
    inputBox.TextXAlignment = Enum.TextXAlignment.Left
    inputBox.ClearTextOnFocus = false
    inputBox.Parent = container
    
    -- Suggestions container
    local suggestionsFrame = Instance.new("Frame")
    suggestionsFrame.Name = "Suggestions"
    suggestionsFrame.Size = UDim2.new(1, 0, 0, 0)
    suggestionsFrame.Position = UDim2.new(0, 0, 0, -5)
    suggestionsFrame.BackgroundColor3 = Config.Theme.Secondary
    suggestionsFrame.Visible = false
    suggestionsFrame.Parent = container
    CreateCorner(8).Parent = suggestionsFrame
    CreateStroke(Config.Theme.Accent, 1).Parent = suggestionsFrame
    
    local suggestionsLayout = CreateLayout(Enum.FillDirection.Vertical, 2)
    suggestionsLayout.Parent = suggestionsFrame
    CreatePadding(5).Parent = suggestionsFrame
    
    -- Command bar functions
    local function ShowSuggestions(input)
        -- Clear existing suggestions
        for _, child in pairs(suggestionsFrame:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        
        suggestions = GetCommandSuggestions(input)
        currentSuggestionIndex = 0
        
        if #suggestions == 0 then
            suggestionsFrame.Visible = false
            return
        end
        
        -- Create suggestion items
        for i, suggestion in ipairs(suggestions) do
            local item = Instance.new("Frame")
            item.Size = UDim2.new(1, 0, 0, 30)
            item.BackgroundColor3 = i == 1 and Config.Theme.AccentDark or Color3.fromRGB(0, 0, 0, 0)
            item.BackgroundTransparency = i == 1 and 0.8 or 1
            item.Parent = suggestionsFrame
            CreateCorner(4).Parent = item
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(0.3, 0, 1, 0)
            nameLabel.Position = UDim2.new(0, 5, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = "/" .. suggestion.name
            nameLabel.TextColor3 = Config.Theme.Accent
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextSize = 14
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.Parent = item
            
            local descLabel = Instance.new("TextLabel")
            descLabel.Size = UDim2.new(0.7, -10, 1, 0)
            descLabel.Position = UDim2.new(0.3, 0, 0, 0)
            descLabel.BackgroundTransparency = 1
            descLabel.Text = suggestion.description
            descLabel.TextColor3 = Config.Theme.TextDim
            descLabel.Font = Enum.Font.Gotham
            descLabel.TextSize = 12
            descLabel.TextXAlignment = Enum.TextXAlignment.Left
            descLabel.Parent = item
        end
        
        -- Resize suggestions frame
        suggestionsFrame.Size = UDim2.new(1, 0, 0, math.min(#suggestions * 32 + 10, 200))
        suggestionsFrame.Position = UDim2.new(0, 0, 0, -suggestionsFrame.Size.Y.Offset - 5)
        suggestionsFrame.Visible = true
    end
    
    local function HideSuggestions()
        suggestionsFrame.Visible = false
        suggestions = {}
        currentSuggestionIndex = 0
    end
    
    local function UpdateSuggestionSelection(direction)
        if #suggestions == 0 then return end
        
        -- Clear current highlight
        for i, child in pairs(suggestionsFrame:GetChildren()) do
            if child:IsA("Frame") then
                child.BackgroundTransparency = 1
            end
        end
        
        -- Update index
        currentSuggestionIndex = currentSuggestionIndex + direction
        if currentSuggestionIndex < 1 then
            currentSuggestionIndex = #suggestions
        elseif currentSuggestionIndex > #suggestions then
            currentSuggestionIndex = 1
        end
        
        -- Highlight new selection
        local frames = {}
        for _, child in pairs(suggestionsFrame:GetChildren()) do
            if child:IsA("Frame") then
                table.insert(frames, child)
            end
        end
        
        if frames[currentSuggestionIndex] then
            frames[currentSuggestionIndex].BackgroundTransparency = 0.8
            frames[currentSuggestionIndex].BackgroundColor3 = Config.Theme.AccentDark
        end
    end
    
    -- Input handling
    inputBox.Changed:Connect(function(property)
        if property == "Text" then
            local text = inputBox.Text
            if text:sub(1, 1) == Config.Prefix then
                text = text:sub(2)
            end
            
            if text == "" then
                HideSuggestions()
            else
                ShowSuggestions(text)
            end
        end
    end)
    
    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local command = inputBox.Text
            if command:sub(1, 1) ~= Config.Prefix then
                command = Config.Prefix .. command
            end
            
            ExecuteCommand(command:sub(2))
            inputBox.Text = ""
            HideSuggestions()
            HoneycombCMD:HideCommandBar()
        end
    end)
    
    -- Keyboard shortcuts
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed or not isCommandBarOpen then return end
        
        if input.KeyCode == Enum.KeyCode.Tab then
            if currentSuggestionIndex > 0 and suggestions[currentSuggestionIndex] then
                inputBox.Text = Config.Prefix .. suggestions[currentSuggestionIndex].name .. " "
                inputBox.CursorPosition = #inputBox.Text + 1
                HideSuggestions()
            end
        elseif input.KeyCode == Enum.KeyCode.Up then
            UpdateSuggestionSelection(-1)
        elseif input.KeyCode == Enum.KeyCode.Down then
            UpdateSuggestionSelection(1)
        elseif input.KeyCode == Enum.KeyCode.Escape then
            HoneycombCMD:HideCommandBar()
        end
    end)
    
    return container
end

-- Chat parser
local function EnableChatParser()
    if chatConnection then
        chatConnection:Disconnect()
    end
    
    -- Try new TextChatService first
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local textChannel = TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")
        
        chatConnection = textChannel.MessageReceived:Connect(function(message)
            if message.TextSource and message.TextSource.UserId == LocalPlayer.UserId then
                local text = message.Text
                if text:sub(1, 1) == Config.Prefix then
                    ExecuteCommand(text:sub(2))
                end
            end
        end)
    else
        -- Legacy chat system
        local chatEvents = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents")
        local messageDoneFiltering = chatEvents:WaitForChild("OnMessageDoneFiltering")
        
        chatConnection = messageDoneFiltering.OnClientEvent:Connect(function(messageData)
            if messageData.FromSpeaker == LocalPlayer.Name then
                local text = messageData.Message
                if text:sub(1, 1) == Config.Prefix then
                    ExecuteCommand(text:sub(2))
                end
            end
        end)
    end
end

-- API Functions
function HoneycombCMD:Initialize()
    self:Print("Initializing HoneycombCMD...")
    
    -- Create command bar
    CreateCommandBar()
    
    -- Enable chat parser
    EnableChatParser()
    
    -- Register built-in commands
    self:RegisterCommand("help", {
        {name = "command", type = "string", required = false}
    }, function(args)
        if args[1] then
            local cmd = commands[args[1]:lower()]
            if cmd then
                local helpText = "/" .. args[1]
                if cmd.usage then
                    helpText = cmd.usage
                end
                if cmd.description then
                    helpText = helpText .. " - " .. cmd.description
                end
                ShowNotification(helpText, "info", 5)
            else
                ShowNotification("Command not found: " .. args[1], "error")
            end
        else
            local cmdList = {}
            for name, _ in pairs(commands) do
                table.insert(cmdList, name)
            end
            table.sort(cmdList)
            ShowNotification("Available commands: " .. table.concat(cmdList, ", "), "info", 8)
        end
    end, "Show help for commands", "/help [command]")
    
    self:RegisterCommand("cmdbar", {}, function()
        self:ShowCommandBar()
    end, "Open the command bar", "/cmdbar")
    
    self:RegisterCommand("history", {}, function()
        if #commandHistory == 0 then
            ShowNotification("No command history", "info")
        else
            local history = "Recent commands: " .. table.concat(commandHistory, ", ")
            ShowNotification(history:sub(1, 200) .. (history:len() > 200 and "..." or ""), "info", 6)
        end
    end, "Show command history", "/history")
    
    self:RegisterCommand("clear", {}, function()
        commandHistory = {}
        ShowNotification("Command history cleared", "success")
    end, "Clear command history", "/clear")
    
    -- Keybind for command bar
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Config.CmdBarKey then
            if isCommandBarOpen then
                self:HideCommandBar()
            else
                self:ShowCommandBar()
            end
        end
    end)
    
    self:Print("Initialized! Press ;" .. " to open command bar, or use chat commands with '" .. Config.Prefix .. "'")
    ShowNotification("HoneycombCMD loaded! Press ;" .. " for command bar", "success")
end

function HoneycombCMD:RegisterCommand(name, args, callback, description, usage)
    name = name:lower()
    commands[name] = {
        callback = callback,
        args = args,
        description = description,
        usage = usage or ("/" .. name)
    }
    self:Print("Registered command: " .. name)
end

function HoneycombCMD:ShowCommandBar()
    if not cmdBarGui then return end
    
    local container = cmdBarGui:FindFirstChild("Container")
    if not container then return end
    
    isCommandBarOpen = true
    container.Visible = true
    
    local inputBox = container:FindFirstChild("InputBox")
    if inputBox then
        inputBox:CaptureFocus()
    end
    
    -- Animate in
    container.Position = UDim2.new(0.5, -300, 1, 20)
    local tween = TweenService:Create(container,
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, -300, 1, -60)}
    )
    tween:Play()
end

function HoneycombCMD:HideCommandBar()
    if not cmdBarGui then return end
    
    local container = cmdBarGui:FindFirstChild("Container")
    if not container then return end
    
    isCommandBarOpen = false
    
    local inputBox = container:FindFirstChild("InputBox")
    if inputBox then
        inputBox:ReleaseFocus()
        inputBox.Text = ""
    end
    
    -- Hide suggestions
    local suggestions = container:FindFirstChild("Suggestions")
    if suggestions then
        suggestions.Visible = false
    end
    
    -- Animate out
    local tween = TweenService:Create(container,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {Position = UDim2.new(0.5, -300, 1, 20)}
    )
    tween:Play()
    tween.Completed:Connect(function()
        container.Visible = false
    end)
end

function HoneycombCMD:ExecuteCommand(commandLine)
    return ExecuteCommand(commandLine)
end

function HoneycombCMD:GetCommands()
    return commands
end

function HoneycombCMD:SetPrefix(prefix)
    Config.Prefix = prefix
end

function HoneycombCMD:SetTheme(theme)
    for key, value in pairs(theme) do
        if Config.Theme[key] then
            Config.Theme[key] = value
        end
    end
end

function HoneycombCMD:Print(text)
    print("[HoneycombCMD]: " .. tostring(text))
end

return HoneycombCMD
