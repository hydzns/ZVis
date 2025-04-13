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

local function showAccumulatedDamage(target, damage)
    local id = target:GetDebugId()
    local entry = activeLabels[id]

    if entry and entry.label and entry.label.Parent then
        entry.damage = entry.damage + damage
        entry.label.Text = "-" .. tostring(entry.damage)

        local color, size = getStyle(entry.damage)
        entry.label.TextColor3 = color
        entry.label.TextSize = size
        entry.expireTime = tick() + 5
    else
        local screenGui = setupGui()
        local label = Instance.new("TextLabel")
        label.Name = "DamageLabel_" .. id
        label.Size = UDim2.new(0, 250, 0, 50)

        local yOffset = 0
        for _, other in pairs(activeLabels) do
            yOffset += 55
        end
        label.Position = UDim2.new(0, 300, 1, -250 - yOffset)

        label.BackgroundTransparency = 1
        label.Text = "-" .. tostring(damage)

        local color, size = getStyle(damage)
        label.TextColor3 = color
        label.TextStrokeTransparency = 0
        label.TextScaled = true
        label.Font = Enum.Font.Arcade
        label.TextSize = size
        label.Parent = screenGui

        activeLabels[id] = {
            label = label,
            damage = damage,
            expireTime = tick() + 5
        }
    end
end

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

                    if tag then
                        local val = tag.Value
                        local isFromPlayer =
                            (typeof(val) == "Instance" and (val == player or (val:IsA("Tool") and val.Parent == player.Character))) or
                            (typeof(val) == "string" and val == player.Name)

                        if isFromPlayer then
                            showAccumulatedDamage(target, damage)
                        end
                    end
                end
                lastHealth[target] = currentHealth
            end
        end
    end

    -- Check NPCs (humanoids in Workspace but not Players)
    for _, model in pairs(workspace:GetChildren()) do
        if model:IsA("Model") and not Players:GetPlayerFromCharacter(model) then
            local humanoid = model:FindFirstChild("Humanoid")
            if humanoid then
                local currentHealth = humanoid.Health
                local previous = lastHealth[model] or currentHealth

                if currentHealth < previous then
                    local damage = math.floor(previous - currentHealth)
                    local tag = humanoid:FindFirstChild("creator")

                    if tag then
                        local val = tag.Value
                        local isFromPlayer =
                            (typeof(val) == "Instance" and (val == player or (val:IsA("Tool") and val.Parent == player.Character))) or
                            (typeof(val) == "string" and val == player.Name)

                        if isFromPlayer then
                            showAccumulatedDamage(model, damage)
                        end
                    end
                end
                lastHealth[model] = currentHealth
            end
        end
    end

    for id, entry in pairs(activeLabels) do
        if tick() > entry.expireTime then
            if entry.label then entry.label:Destroy() end
            activeLabels[id] = nil
        end
    end
end)
