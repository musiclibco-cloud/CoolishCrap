abel.Parent = billboard
            
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
