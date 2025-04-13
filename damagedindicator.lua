-- Tabel untuk menyimpan health sebelumnya dan damage stacking
local lastHealth = nil
local activeLabel = nil

-- Buat GUI jika belum ada
function setupGui()
    local player = game.Players.LocalPlayer
    local gui = player:FindFirstChild("PlayerGui"):FindFirstChild("DamageScreenGui")
    if gui then return gui end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DamageScreenGui"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = player:WaitForChild("PlayerGui")

    return screenGui
end

-- Fungsi untuk menampilkan atau update damage di layar
function showAccumulatedDamage(damage)
    local screenGui = setupGui()

    if activeLabel and activeLabel.Parent then
        local currentDamage = tonumber(string.match(activeLabel.Text, "%d+")) or 0
        local newDamage = currentDamage + damage
        activeLabel.Text = "-" .. tostring(newDamage)

        if newDamage > 272 then
            activeLabel.TextColor3 = Color3.fromRGB(170, 0, 255)
        else
            activeLabel.TextColor3 = Color3.new(1, 0, 0)
        end

        activeLabel:SetAttribute("ExpireTime", tick() + 1.5)
    else
        local label = Instance.new("TextLabel")
        label.Name = "DamageLabel"
        label.Size = UDim2.new(0, 300, 0, 60)
        label.Position = UDim2.new(0.5, -150, 0.75, 0) -- Tengah bawah layar
        label.BackgroundTransparency = 1
        label.Text = "-" .. tostring(damage)
        label.TextColor3 = damage > 272 and Color3.fromRGB(170, 0, 255) or Color3.new(1, 0, 0)
        label.TextStrokeTransparency = 0
        label.TextScaled = true
        label.Font = Enum.Font.Arcade -- Font pixel
        label.TextSize = 60
        label.Parent = screenGui

        label:SetAttribute("ExpireTime", tick() + 1.5)
        activeLabel = label
    end
end

-- Fungsi utama untuk memantau damage pada LocalPlayer
function monitorDamage()
    local player = game.Players.LocalPlayer

    repeat task.wait() until player.Character and player.Character:FindFirstChild("Humanoid")
    local humanoid = player.Character:WaitForChild("Humanoid")
    lastHealth = humanoid.Health

    while task.wait(0.1) do
        local currentHealth = humanoid.Health
        if currentHealth < lastHealth then
            local damage = math.floor(lastHealth - currentHealth)
            showAccumulatedDamage(damage)
        end
        lastHealth = currentHealth

        -- Hapus label jika sudah expired
        if activeLabel and activeLabel:GetAttribute("ExpireTime") and tick() > activeLabel:GetAttribute("ExpireTime") then
            activeLabel:Destroy()
            activeLabel = nil
        end
    end
end

monitorDamage()
