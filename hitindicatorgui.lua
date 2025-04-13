if _G.HitIndicatorConnection then
    _G.HitIndicatorConnection:Disconnect()
    _G.HitIndicatorConnection = nil
end

_G.HitIndicatorEnabled = true

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Tabel untuk menyimpan damage stacking per target
local activeLabels = {}
local lastHealth = {}

-- Setup GUI
function setupGui()
    local gui = player:WaitForChild("PlayerGui"):FindFirstChild("DamageScreenGui")
    if gui then return gui end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DamageScreenGui"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = player:WaitForChild("PlayerGui")

    return screenGui
end

-- Fungsi untuk menampilkan damage
function showAccumulatedDamage(target, damage)
    local id = target.UserId
    local entry = activeLabels[id]

    if entry and entry.label and entry.label.Parent then
        entry.damage = entry.damage + damage
        entry.label.Text = "-" .. tostring(entry.damage)
        entry.label.TextColor3 = entry.damage > 272 and Color3.fromRGB(170, 0, 255) or Color3.new(1, 0, 0)
        entry.expireTime = tick() + 1.5
    else
        local screenGui = setupGui()
        local label = Instance.new("TextLabel")
        label.Name = "DamageLabel_" .. id
        label.Size = UDim2.new(0, 250, 0, 50)

        -- Posisi vertikal berdasarkan jumlah label aktif
        local yOffset = 0
        for _, other in pairs(activeLabels) do
            yOffset = yOffset + 55
        end
        label.Position = UDim2.new(0, 300, 1, -250 - yOffset)

        label.BackgroundTransparency = 1
        label.Text = "-" .. tostring(damage)
        label.TextColor3 = damage > 272 and Color3.fromRGB(170, 0, 255) or Color3.new(1, 0, 0)
        label.TextStrokeTransparency = 0
        label.TextScaled = true
        label.Font = Enum.Font.Arcade
        label.TextSize = 48
        label.Parent = screenGui

        activeLabels[id] = {
            label = label,
            damage = damage,
            expireTime = tick() + 1.5
        }
    end
end

-- Fungsi utama dengan koneksi tunggal
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

    -- Bersihkan label yang sudah expired
    for id, entry in pairs(activeLabels) do
        if tick() > entry.expireTime then
            if entry.label then entry.label:Destroy() end
            activeLabels[id] = nil
        end
    end
end)
