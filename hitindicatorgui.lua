if _G.HitIndicatorConnection then
    _G.HitIndicatorConnection:Disconnect()
    _G.HitIndicatorConnection = nil
end

_G.HitIndicatorEnabled = true

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local activeLabels = {}
local lastHealth = {}

-- Styling function
local function getStyle(damage)
    if damage >= 450 then
        return Color3.fromRGB(120, 0, 0), 200
    elseif damage >= 350 then
        return Color3.fromRGB(100, 0, 150), 150
    elseif damage >= 250 then
        return Color3.fromRGB(170, 0, 255), 100
    else
        return Color3.new(1, 0, 0), 50
    end
end

-- GUI setup
local function setupGui()
    local gui = player:WaitForChild("PlayerGui"):FindFirstChild("DamageScreenGui")
    if gui then return gui end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DamageScreenGui"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = player:WaitForChild("PlayerGui")

    return screenGui
end

-- Show accumulated damage
local function showAccumulatedDamage(target, damage)
    local id = target.UserId
    local entry = activeLabels[id]

    if entry and entry.label and entry.label.Parent then
        entry.damage = entry.damage + damage
        local color, size = getStyle(entry.damage)

        entry.label.Text = "-" .. tostring(entry.damage)
        entry.label.TextColor3 = color
        entry.label.TextSize = size
        entry.expireTime = tick() + 1.5
    else
        local screenGui = setupGui()
        local label = Instance.new("TextLabel")
        label.Name = "DamageLabel_" .. id
        label.Size = UDim2.new(0, 250, 0, 50)

        -- Posisi vertikal dinamis
        local yOffset = 0
        for _, other in pairs(activeLabels) do
            yOffset = yOffset + 55
        end
        label.Position = UDim2.new(0, 300, 1, -250 - yOffset)

        label.BackgroundTransparency = 1
        label.Text = "-" .. tostring(damage)

        local color, size = getStyle(damage)
        label.TextColor3 = color
        label.TextStrokeTransparency = 0
        label.TextScaled = false
        label.TextSize = size
        label.Font = Enum.Font.Arcade
        label.Parent = screenGui

        activeLabels[id] = {
            label = label,
            damage = damage,
            expireTime = tick() + 1.5
        }
    end
end

-- Heartbeat loop
_G.HitIndicatorConnection = RunService.Heartbeat:Connect(function()
    if not _G.HitIndicatorEnabled then return end

    for _, target in pairs(Players:GetPlayers()) do
        if target ~= player and target.Character then
            local humanoid = target.Character:FindFirstChild("Humanoid")
            if humanoid then
                local currentHealth = humanoid.Health
                local previous = lastHealth[target] or currentHealth

                if currentHealth < previous then
                    local damage = math.floor(previous - currentHealth)

                    local tag = humanoid:FindFirstChild("creator")
                    if tag and tag.Value == player then
                        showAccumulatedDamage(target, damage)
                    end
                end

                lastHealth[target] = currentHealth
            end
        end
    end

    -- Clean up expired labels
    for id, entry in pairs(activeLabels) do
        if tick() > entry.expireTime then
            if entry.label then entry.label:Destroy() end
            activeLabels[id] = nil
        end
    end
end)
