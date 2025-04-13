local lastHealth = {}
local activeLabels = {}
local damageLogGui = nil

-- GUI setup
function setupGui()
    local player = game.Players.LocalPlayer
    local gui = player:FindFirstChild("PlayerGui"):FindFirstChild("DamageLogGui")
    if gui then return gui end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DamageLogGui"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = player:WaitForChild("PlayerGui")

    damageLogGui = screenGui
    return screenGui
end

-- Show damage per enemy (stacked + auto remove)
function showAccumulatedDamage(player, damage)
    local id = player.UserId
    local entry = activeLabels[id]

    if entry and entry.label and entry.label.Parent then
        entry.damage = entry.damage + damage
        entry.label.Text = "-" .. tostring(entry.damage)

        -- Ganti warna jika damage besar
        if entry.damage > 272 then
            entry.label.TextColor3 = Color3.fromRGB(170, 0, 255)
        else
            entry.label.TextColor3 = Color3.new(1, 0, 0)
        end

        entry.expireTime = tick() + 1.5
    else
        local screenGui = setupGui()

        local label = Instance.new("TextLabel")
        label.Name = "DamageLabel_" .. id
        label.Size = UDim2.new(0, 200, 0, 30)

        -- Urutan label
        local yOffset = 0
        for _, other in pairs(activeLabels) do
            yOffset = yOffset + 35
        end
        label.Position = UDim2.new(0, 350, 1, -300 - yOffset)

        label.BackgroundTransparency = 1
        label.Text = "-" .. tostring(damage)
        label.TextColor3 = damage > 272 and Color3.fromRGB(170, 0, 255) or Color3.new(1, 0, 0)
        label.TextStrokeTransparency = 0
        label.TextScaled = true
        label.Font = Enum.Font.SourceSansBold
		label.TextSize = 30
        label.Parent = screenGui

        activeLabels[id] = {
            label = label,
            damage = damage,
            expireTime = tick() + 1.5
        }
    end
end

-- Main damage monitor
function monitorDamage()
    while task.wait(0.1) do
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid then
                    local currentHealth = humanoid.Health
                    local previousHealth = lastHealth[player] or currentHealth
                    if currentHealth < previousHealth then
                        local damage = math.floor(previousHealth - currentHealth)
                        showAccumulatedDamage(player, damage)
                    end
                    lastHealth[player] = currentHealth
                end
            end
        end

        -- Hapus label jika waktunya habis
        for id, entry in pairs(activeLabels) do
            if tick() > entry.expireTime then
                if entry.label then
                    entry.label:Destroy()
                end
                activeLabels[id] = nil
            end
        end
    end
end

monitorDamage()
