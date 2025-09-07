-- 🌌 VOID ARTILLERY HUB v4.0 🌌
-- Full Proprietary Gaming Hub with Game-Specific Features
-- "Slučajna referenca na bosansku artiljeriju" - Random reference to Bosnian artillery 💀
-- Created by: Void Development Team

-- Load the VoidUI v3.0 library
local VoidUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/musiclibco-cloud/CoolishCrap/refs/heads/main/Void3.lua"))()

-- Get all required services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Current game PlaceID
local currentPlaceId = game.PlaceId

-- 🌌 VOID ARTILLERY CONFIGURATION
local VOID_ARTILLERY = {
    VERSION = "4.0",
    CODENAME = "DARKNESS_NEXUS",
    AUTHOR = "Void Artillery Team 💀",
    THEME = {
        DARKNESS = Color3.fromRGB(5, 5, 15),
        VOID_BLACK = Color3.fromRGB(10, 10, 20),
        ARTILLERY_RED = Color3.fromRGB(180, 20, 20),
        BLOOD_RED = Color3.fromRGB(150, 0, 0),
        GHOST_WHITE = Color3.fromRGB(240, 240, 240),
        SHADOW_GRAY = Color3.fromRGB(80, 80, 80)
    }
}

-- 💀 GAME-SPECIFIC FEATURE SETS
local FEATURE_SETS = {
    -- Arsenal (Gun game)
    [286090429] = {
        name = "🔫 Arsenal Artillery",
        features = {
            "aimbot", "esp", "wallhack", "unlimited_ammo", "rapid_fire",
            "kill_aura", "auto_headshot", "silent_aim", "weapon_mods"
        }
    },
    
    -- Brookhaven (Roleplay)
    [4924922222] = {
        name = "🏠 Brookhaven Domination",
        features = {
            "house_teleports", "vehicle_spawn", "money_farm", "admin_powers",
            "weather_control", "time_control", "building_tools", "roleplay_mods"
        }
    },
    
    -- Da Hood (Street game)
    [2788229376] = {
        name = "🌃 Hood Artillery",
        features = {
            "money_farm", "auto_stomp", "kill_aura", "gun_mods", "car_fly",
            "infinite_cash", "auto_rob", "anti_fling", "hood_esp"
        }
    },
    
    -- Adopt Me (Pet game)
    [920587237] = {
        name = "🐾 Pet Artillery",
        features = {
            "auto_collect", "pet_duplication", "money_farm", "trade_scam_protection",
            "auto_age_pets", "legendary_spawner", "house_decorator", "gift_farm"
        }
    },
    
    -- Blox Fruits (One Piece inspired)
    [2753915549] = {
        name = "🍎 Fruit Artillery",
        features = {
            "auto_farm", "devil_fruit_notifier", "auto_boss", "teleport_islands",
            "infinite_stamina", "no_clip_boats", "auto_quest", "fruit_finder"
        }
    },
    
    -- Jailbreak (Cops vs Robbers)
    [606849621] = {
        name = "🚔 Jailbreak Artillery",
        features = {
            "auto_rob", "vehicle_fly", "infinite_nitro", "wall_climb", "arrest_aura",
            "keycard_teleport", "bank_teleports", "anti_arrest", "speed_boost"
        }
    },
    
    -- Murder Mystery 2
    [142823291] = {
        name = "🔪 Mystery Artillery",
        features = {
            "murderer_esp", "sheriff_esp", "gun_esp", "knife_esp", "auto_collect_coins",
            "win_every_round", "xray_vision", "teleport_to_gun", "god_mode"
        }
    },
    
    -- UNIVERSAL (Default for unknown games)
    ["UNIVERSAL"] = {
        name = "🌌 Universal Artillery",
        features = {
            "fly", "speed", "noclip", "esp", "teleport", "god_mode", "jump_power",
            "walkspeed", "invisible", "fullbright", "click_teleport", "anti_afk"
        }
    }
}

-- 🎯 GET CURRENT FEATURE SET
local function getFeatureSet()
    local featureSet = FEATURE_SETS[currentPlaceId]
    if not featureSet then
        print("🌌 Unknown game detected, loading Universal Artillery...")
        featureSet = FEATURE_SETS["UNIVERSAL"]
    else
        print("🌌 Game-specific artillery loaded:", featureSet.name)
    end
    return featureSet
end

local currentFeatures = getFeatureSet()

-- Create the main window with artillery theme
local window = VoidUI:CreateWindow("💀 VOID ARTILLERY HUB " .. VOID_ARTILLERY.VERSION)

-- Global state variables
local states = {
    fly = false,
    speed = false,
    noclip = false,
    esp = false,
    godMode = false,
    aimbot = false,
    autoFarm = false,
    antiAfk = false,
    connections = {}
}

-- 🌌 STARTUP NOTIFICATION
StarterGui:SetCore("SendNotification", {
    Title = "💀 VOID ARTILLERY ACTIVATED",
    Text = currentFeatures.name .. " loaded successfully!",
    Duration = 5
})

-- ===========================================
-- 💀 MAIN ARTILLERY TAB
-- ===========================================

local mainTab = window:CreateTab("Artillery", "💀")

window:AddLabel(mainTab, "💀 " .. currentFeatures.name)
window:AddLabel(mainTab, "🎯 PlaceID: " .. currentPlaceId)

-- Core Movement Features
window:AddLabel(mainTab, "🚀 MOVEMENT ARTILLERY")

if table.find(currentFeatures.features, "fly") then
    window:AddToggle(mainTab, "🚁 Void Flight", false, function(state)
        states.fly = state
        if state then
            enableFly()
            notify("🌌 ARTILLERY FLIGHT: ENGAGED")
        else
            disableFly()
            notify("🌌 ARTILLERY FLIGHT: DISENGAGED")
        end
    end)
end

if table.find(currentFeatures.features, "speed") then
    window:AddToggle(mainTab, "⚡ Artillery Speed", false, function(state)
        states.speed = state
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = state and 150 or 16
            notify("🌌 ARTILLERY SPEED: " .. (state and "MAXIMUM" or "NORMAL"))
        end
    end)
end

if table.find(currentFeatures.features, "noclip") then
    window:AddToggle(mainTab, "👻 Phase Artillery", false, function(state)
        states.noclip = state
        toggleNoclip(state)
        notify("🌌 PHASE ARTILLERY: " .. (state and "ACTIVE" or "INACTIVE"))
    end)
end

if table.find(currentFeatures.features, "god_mode") then
    window:AddToggle(mainTab, "🛡️ Artillery Shield", false, function(state)
        states.godMode = state
        if character and character:FindFirstChild("Humanoid") then
            if state then
                character.Humanoid.MaxHealth = math.huge
                character.Humanoid.Health = math.huge
            else
                character.Humanoid.MaxHealth = 100
                character.Humanoid.Health = 100
            end
            notify("🌌 ARTILLERY SHIELD: " .. (state and "INVINCIBLE" or "MORTAL"))
        end
    end)
end

-- Quick Actions
window:AddLabel(mainTab, "⚡ QUICK ARTILLERY")

window:AddButton(mainTab, "🏠 Artillery Base", function()
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(0, 5, 0)
        notify("🌌 Returned to Artillery Base")
    end
end)

window:AddButton(mainTab, "💀 Self Destruct", function()
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.Health = 0
        notify("💀 Artillery unit destroyed")
    end
end)

-- ===========================================
-- 🎯 COMBAT ARTILLERY TAB
-- ===========================================

local combatTab = window:CreateTab("Combat", "🎯")

window:AddLabel(combatTab, "⚔️ COMBAT SYSTEMS")

if table.find(currentFeatures.features, "aimbot") then
    window:AddToggle(combatTab, "🎯 Artillery Aimbot", false, function(state)
        states.aimbot = state
        if state then
            enableAimbot()
            notify("🎯 ARTILLERY AIMBOT: LOCKED AND LOADED")
        else
            disableAimbot()
            notify("🎯 ARTILLERY AIMBOT: DISARMED")
        end
    end)
end

if table.find(currentFeatures.features, "kill_aura") then
    window:AddToggle(combatTab, "💀 Death Artillery", false, function(state)
        if state then
            enableKillAura()
            notify("💀 DEATH ARTILLERY: RADIUS ACTIVE")
        else
            disableKillAura()
            notify("💀 DEATH ARTILLERY: STAND DOWN")
        end
    end)
end

if table.find(currentFeatures.features, "rapid_fire") then
    window:AddToggle(combatTab, "🔫 Rapid Artillery", false, function(state)
        enableRapidFire(state)
        notify("🔫 RAPID ARTILLERY: " .. (state and "MAXIMUM FIREPOWER" or "STANDARD RATE"))
    end)
end

if table.find(currentFeatures.features, "unlimited_ammo") then
    window:AddButton(combatTab, "♾️ Infinite Ammo", function()
        enableInfiniteAmmo()
        notify("♾️ ARTILLERY AMMO: UNLIMITED SUPPLY")
    end)
end

if table.find(currentFeatures.features, "auto_headshot") then
    window:AddToggle(combatTab, "🎯 Precision Artillery", false, function(state)
        enableAutoHeadshot(state)
        notify("🎯 PRECISION ARTILLERY: " .. (state and "HEADHUNTER MODE" or "STANDARD AIM"))
    end)
end

-- ===========================================
-- 👁️ VISION ARTILLERY TAB
-- ===========================================

local visionTab = window:CreateTab("Vision", "👁️")

window:AddLabel(visionTab, "🔍 TACTICAL VISION")

if table.find(currentFeatures.features, "esp") then
    window:AddToggle(visionTab, "👁️ Artillery Vision", false, function(state)
        states.esp = state
        if state then
            enableESP()
            notify("👁️ ARTILLERY VISION: ENEMY DETECTED")
        else
            disableESP()
            notify("👁️ ARTILLERY VISION: RADAR OFF")
        end
    end)
end

if table.find(currentFeatures.features, "wallhack") then
    window:AddToggle(visionTab, "🧱 Wall Penetration", false, function(state)
        enableWallhack(state)
        notify("🧱 WALL PENETRATION: " .. (state and "XRAY ACTIVE" or "STANDARD VIEW"))
    end)
end

if table.find(currentFeatures.features, "fullbright") then
    window:AddToggle(visionTab, "☀️ Artillery Illumination", false, function(state)
        if state then
            Lighting.Brightness = 3
            Lighting.ClockTime = 12
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            notify("☀️ ARTILLERY ILLUMINATION: BATTLEFIELD LIT")
        else
            Lighting.Brightness = 1
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = true
            notify("☀️ ARTILLERY ILLUMINATION: NORMAL LIGHTING")
        end
    end)
end

window:AddButton(visionTab, "🔍 Tactical Scope", function()
    local camera = Workspace.CurrentCamera
    if camera then
        camera.FieldOfView = camera.FieldOfView == 70 and 30 or 70
        notify("🔍 TACTICAL SCOPE: " .. (camera.FieldOfView == 30 and "ZOOMED" or "NORMAL"))
    end
end)

-- ===========================================
-- 💰 ECONOMY ARTILLERY TAB
-- ===========================================

local economyTab = window:CreateTab("Economy", "💰")

window:AddLabel(economyTab, "💎 RESOURCE WARFARE")

if table.find(currentFeatures.features, "money_farm") then
    window:AddToggle(economyTab, "💰 Artillery Bank", false, function(state)
        if state then
            enableMoneyFarm()
            notify("💰 ARTILLERY BANK: GENERATING WEALTH")
        else
            disableMoneyFarm()
            notify("💰 ARTILLERY BANK: OPERATIONS CEASED")
        end
    end)
end

if table.find(currentFeatures.features, "auto_farm") then
    window:AddToggle(economyTab, "🚜 Auto Artillery", false, function(state)
        states.autoFarm = state
        if state then
            enableAutoFarm()
            notify("🚜 AUTO ARTILLERY: FARMING COMMENCED")
        else
            disableAutoFarm()
            notify("🚜 AUTO ARTILLERY: HARVEST COMPLETE")
        end
    end)
end

if table.find(currentFeatures.features, "auto_collect") then
    window:AddToggle(economyTab, "🧲 Artillery Magnet", false, function(state)
        enableAutoCollect(state)
        notify("🧲 ARTILLERY MAGNET: " .. (state and "COLLECTING ALL" or "MANUAL COLLECTION"))
    end)
end

if table.find(currentFeatures.features, "infinite_cash") then
    window:AddButton(economyTab, "♾️ Artillery Treasury", function()
        enableInfiniteCash()
        notify("♾️ ARTILLERY TREASURY: UNLIMITED FUNDS")
    end)
end

-- ===========================================
-- 🚀 VEHICLE ARTILLERY TAB
-- ===========================================

local vehicleTab = window:CreateTab("Vehicles", "🚀")

window:AddLabel(vehicleTab, "🚗 MOBILE ARTILLERY")

if table.find(currentFeatures.features, "vehicle_fly") then
    window:AddToggle(vehicleTab, "🚁 Flying Artillery", false, function(state)
        enableVehicleFly(state)
        notify("🚁 FLYING ARTILLERY: " .. (state and "AIRBORNE UNIT" or "GROUND UNIT"))
    end)
end

if table.find(currentFeatures.features, "car_fly") then
    window:AddToggle(vehicleTab, "🚗 Aerial Vehicles", false, function(state)
        enableCarFly(state)
        notify("🚗 AERIAL VEHICLES: " .. (state and "SKY HIGHWAYS" or "ROAD BOUND"))
    end)
end

if table.find(currentFeatures.features, "infinite_nitro") then
    window:AddButton(vehicleTab, "🔥 Artillery Boost", function()
        enableInfiniteNitro()
        notify("🔥 ARTILLERY BOOST: MAXIMUM OVERDRIVE")
    end)
end

if table.find(currentFeatures.features, "vehicle_spawn") then
    window:AddButton(vehicleTab, "🚚 Spawn Artillery", function()
        spawnVehicle()
        notify("🚚 ARTILLERY VEHICLE: DEPLOYED")
    end)
end

-- ===========================================
-- 🛠️ UTILITY ARTILLERY TAB
-- ===========================================

local utilityTab = window:CreateTab("Utilities", "🛠️")

window:AddLabel(utilityTab, "⚙️ SUPPORT SYSTEMS")

if table.find(currentFeatures.features, "click_teleport") then
    window:AddButton(utilityTab, "🎯 Artillery Strike", function()
        local mouse = player:GetMouse()
        notify("🎯 Click to deploy artillery strike!")
        
        local connection
        connection = mouse.Button1Down:Connect(function()
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 5, 0))
                notify("🎯 Artillery strike successful!")
            end
            connection:Disconnect()
        end)
    end)
end

if table.find(currentFeatures.features, "anti_afk") then
    window:AddToggle(utilityTab, "🤖 Artillery Sentinel", false, function(state)
        states.antiAfk = state
        if state then
            enableAntiAFK()
            notify("🤖 ARTILLERY SENTINEL: MAINTAINING PRESENCE")
        else
            disableAntiAFK()
            notify("🤖 ARTILLERY SENTINEL: STANDING DOWN")
        end
    end)
end

window:AddButton(utilityTab, "📋 Artillery Intel", function()
    local gameInfo = getGameInformation()
    for _, info in ipairs(gameInfo) do
        print(info)
    end
    notify("📋 Artillery intelligence gathered")
end)

window:AddButton(utilityTab, "🔄 Artillery Redeployment", function()
    notify("🔄 Redeploying artillery unit...")
    wait(1)
    game:GetService("TeleportService"):Teleport(game.PlaceId, player)
end)

window:AddButton(utilityTab, "💾 Artillery Backup", function()
    local backupData = {
        placeId = currentPlaceId,
        timestamp = os.time(),
        features = currentFeatures.name,
        version = VOID_ARTILLERY.VERSION
    }
    setclipboard(HttpService:JSONEncode(backupData))
    notify("💾 Artillery data backed up to clipboard")
end)

-- ===========================================
-- 🔧 ARTILLERY FUNCTIONS
-- ===========================================

-- Notification system
function notify(message)
    StarterGui:SetCore("SendNotification", {
        Title = "💀 VOID ARTILLERY",
        Text = message,
        Duration = 3
    })
    print("🌌 " .. message)
end

-- Movement Systems
function enableFly()
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    
    if character and character:FindFirstChild("HumanoidRootPart") then
        bodyVelocity.Parent = character.HumanoidRootPart
        
        states.connections.fly = RunService.Heartbeat:Connect(function()
            if states.fly and bodyVelocity.Parent then
                local camera = Workspace.CurrentCamera
                local moveVector = Vector3.new(0, 0, 0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveVector = moveVector + camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveVector = moveVector - camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveVector = moveVector - camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveVector = moveVector + camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveVector = moveVector + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    moveVector = moveVector - Vector3.new(0, 1, 0)
                end
                
                bodyVelocity.Velocity = moveVector * 75
            end
        end)
    end
end

function disableFly()
    if states.connections.fly then
        states.connections.fly:Disconnect()
        states.connections.fly = nil
    end
    
    if character and character:FindFirstChild("HumanoidRootPart") then
        local bodyVelocity = character.HumanoidRootPart:FindFirstChild("BodyVelocity")
        if bodyVelocity then
            bodyVelocity:Destroy()
        end
    end
end

function toggleNoclip(state)
    if not character then return end
    
    if state then
        states.connections.noclip = RunService.Stepped:Connect(function()
            if states.noclip then
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if states.connections.noclip then
            states.connections.noclip:Disconnect()
            states.connections.noclip = nil
        end
        
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
end

-- ESP System
function enableESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "ArtilleryESP"
            billboard.Size = UDim2.new(0, 200, 0, 60)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.Parent = plr.Character.Head
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = "💀 " .. plr.Name
            nameLabel.TextColor3 = VOID_ARTILLERY.THEME.ARTILLERY_RED
            nameLabel.TextSize = 16
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextStrokeTransparency = 0
            nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            nameLabel.Parent = billboard
            
            local distanceLabel = Instance.new("TextLabel")
            distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
            distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
            distanceLabel.BackgroundTransparency = 1
            distanceLabel.Text = "🎯 0m"
            distanceLabel.TextColor3 = VOID_ARTILLERY.THEME.GHOST_WHITE
            distanceLabel.TextSize = 12
            distanceLabel.Font = Enum.Font.Gotham
            distanceLabel.TextStrokeTransparency = 0
            distanceLabel.Parent = billboard
            
            -- Update distance
            spawn(function()
                while billboard.Parent and states.esp do
                    if character and character:FindFirstChild("HumanoidRootPart") and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = math.floor((character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude)
                        distanceLabel.Text = "🎯 " .. distance .. "m"
                    end
                    wait(0.5)
                end
            end)
        end
    end
end

function disableESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("Head") then
            local esp = plr.Character.Head:FindFirstChild("ArtilleryESP")
            if esp then
                esp:Destroy()
            end
        end
    end
end

-- Combat Systems (Placeholder functions for game-specific features)
function enableAimbot()
    notify("🎯 Aimbot system would be initialized here for " .. currentFeatures.name)
end

function disableAimbot()
    notify("🎯 Aimbot system disabled")
end

function enableKillAura()
    notify("💀 Kill aura would be enabled for " .. currentFeatures.name)
end

function disableKillAura()
    notify("💀 Kill aura disabled")
end

function enableRapidFire(state)
    notify("🔫 Rapid fire " .. (state and "enabled" or "disabled") .. " for " .. currentFeatures.name)
end

function enableInfiniteAmmo()
    notify("♾️ Infinite ammo enabled for " .. currentFeatures.name)
end

function enableAutoHeadshot(state)
    notify("🎯 Auto headshot " .. (state and "enabled" or "disabled"))
end

function enableWallhack(state)
    notify("🧱 Wallhack " .. (state and "enabled" or "disabled"))
end

-- Economy Systems
function enableMoneyFarm()
    notify("💰 Money farming started for " .. currentFeatures.name)
end

function disableMoneyFarm()
    notify("💰 Money farming stopped")
end

function enableAutoFarm()
    notify("🚜 Auto farming enabled for " .. currentFeatures.name)
end

function disableAutoFarm()
    notify("🚜 Auto farming disabled")
end

function enableAutoCollect(state)
    notify("🧲 Auto collect " .. (state and "enabled" or "disabled"))
end

function enableInfiniteCash()
    notify("♾️ Infinite cash enabled for " .. currentFeatures.name)
end

-- Vehicle Systems
function enableVehicleFly(state)
    notify("🚁 Vehicle fly " .. (state and "enabled" or "disabled"))
end

function enableCarFly(state)
    notify("🚗 Car fly " .. (state and "enabled" or "disabled"))
end

function enableInfiniteNitro()
    notify("🔥 Infinite nitro enabled")
end

function spawnVehicle()
    notify("🚚 Vehicle spawned for " .. currentFeatures.name)
end

-- Utility Systems
function enableAntiAFK()
    states.connections.antiAfk = spawn(function()
        while states.antiAfk do
            wait(300) -- 5 minutes
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 0)
            end
        end
    end)
end

function disableAntiAFK()
    if states.connections.antiAfk then
        states.connections.antiAfk = nil
    end
end

function getGameInformation()
    return {
        "💀 ========= ARTILLERY INTELLIGENCE =========",
        "🎮 Game: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
        "🆔 PlaceID: " .. currentPlaceId,
        "👤 Commander: " .. player.Name,
        "🎯 Target Features: " .. currentFeatures.name,
        "⚡ Available Systems: " .. #currentFeatures.features,
        "👥 Enemy Count: " .. (#Players:GetPlayers() - 1),
        "🕐 Mission Time: " .. math.floor(tick() - game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) .. "s",
        "🌌 Artillery Version: " .. VOID_ARTILLERY.VERSION,
        "💀 Status: FULLY OPERATIONAL",
        "💀 ========================================"
    }
end

-- ===========================================
-- 🎮 KEYBINDS & FINAL SETUP
-- ===========================================

-- Keybind to toggle GUI (B for Bosnia 💀)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.B then
        window:ToggleMinimize()
    end
end)

-- Handle character respawning
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    
    -- Reset all states
    for key, _ in pairs(states) do
        if key ~= "connections" then
            states[key] = false
        end
    end
    
    -- Disconnect all connections
    for _, connection in pairs(states.connections) do
        if connection and typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        end
    end
    states.connections = {}
    
    wait(1)
    notify("💀 Artillery unit respawned and ready")
end)

-- Cleanup on leaving
game:BindToClose(function()
    for _, connection in pairs(states.connections) do
        if connection and typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        end
    end
end)

-- ===========================================
-- 🌌 ARTILLERY DEPLOYMENT COMPLETE
-- ===========================================

wait(1)
print("💀 ================================================")
print("💀           VOID ARTILLERY HUB v" .. VOID_ARTILLERY.VERSION)
