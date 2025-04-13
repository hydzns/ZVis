local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Matikan koneksi sebelumnya kalau ada
if _G.HitIndicatorConnection then
    _G.HitIndicatorConnection:Disconnect()
    _G.HitIndicatorConnection = nil
end

_G.HitIndicatorEnabled = true

local activeBillboards = {}
local lastHealth = {}

-- Fungsi styling damage
local function getStyle(amount)
    if amount >= 450 then
        return Color3.fromRGB(120, 0, 0), 200
    elseif amount >= 350 then
        return Color3.fromRGB(100, 0, 150), 150
    elseif amount >= 250 then
        return Color3.fromRGB(170, 0, 255), 100
    else
        return Color3.new(1, 0, 0), 50
    end
end

-- Fungsi menampilkan damage
local function showAccumulatedDamage(targetPlayer, damage)
    local head = targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head")
    if not head then return end

    local id = targetPlayer.UserId
    local billboard = activeBillboards[id]

    if billboard and billboard.Parent then
        local label = billboard:FindFirstChild("DamageLabel")
        if label then
            local currentDamage = tonumber(string.match(label.Text, "%d+")) or 0
            local newDamage = currentDamage + damage
            label.Text = "-" .. tostring(newDamage)

            local color, size = getStyle(newDamage)
            label.TextColor3 = color
            label.TextSize = size

            local removeTime = billboard:FindFirstChild("RemoveAt")
            if removeTime then
                removeTime.Value = tick() + 5
            end
        end
    else
        billboard = Instance.new("BillboardGui")
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 100, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.AlwaysOnTop = true
        billboard.Name = "AccumulatedDamage_" .. id

        local label = Instance.new("TextLabel")
        label.Name = "DamageLabel"
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = "-" .. tostring(damage)

        local color, size = getStyle(damage)
        label.TextColor3 = color
        label.TextStrokeTransparency = 0
        label.TextScaled = false
        label.TextSize = size
        label.Font = Enum.Font.Arcade
        label.Parent = billboard

        local removeTime = Instance.new("NumberValue")
        removeTime.Name = "RemoveAt"
        removeTime.Value = tick() + 5
        removeTime.Parent = billboard

        billboard.Parent = LocalPlayer:WaitForChild("PlayerGui")
        activeBillboards[id] = billboard
    end
end

-- Deteksi damage
_G.HitIndicatorConnection = RunService.Heartbeat:Connect(function()
    if not _G.HitIndicatorEnabled then return end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                local currentHealth = humanoid.Health
                local previous = lastHealth[player] or currentHealth

                if currentHealth < previous then
                    local damage = math.floor(previous - currentHealth)

                    local tag = humanoid:FindFirstChild("creator")
                    if tag and tag.Value == LocalPlayer then
                        showAccumulatedDamage(player, damage)
                    end
                end

                lastHealth[player] = currentHealth
            end
        end
    end

    -- Bersihkan jika sudah waktunya
    for id, billboard in pairs(activeBillboards) do
        local removeTime = billboard:FindFirstChild("RemoveAt")
        if removeTime and tick() > removeTime.Value then
            billboard:Destroy()
            activeBillboards[id] = nil
        end
    end
end)
