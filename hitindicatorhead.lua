-- Tabel untuk menyimpan health sebelumnya dan damage stacking
local lastHealth = {}
local activeBillboards = {}

-- Fungsi untuk membuat atau update BillboardGui damage text
function showAccumulatedDamage(player, damage)
    local head = player.Character and player.Character:FindFirstChild("Head")
    if not head then return end

    local id = player.UserId
    local billboard = activeBillboards[id]

    if billboard and billboard.Parent then
        local label = billboard:FindFirstChild("DamageLabel")
        if label then
            -- Tambahkan damage ke yang sudah ada
            local currentDamage = tonumber(string.match(label.Text, "%d+")) or 0
            local newDamage = currentDamage + damage
            label.Text = "-" .. tostring(newDamage)

            -- Ganti warna jika damage total > 80
            if newDamage > 272 then
                label.TextColor3 = Color3.fromRGB(170, 0, 255)
            else
                label.TextColor3 = Color3.new(1, 0, 0)
            end

            -- Reset timer untuk menghapus
            if billboard:FindFirstChild("RemoveAt") then
                billboard.RemoveAt.Value = tick() + 1.5
            end
        end
    else
        -- Buat baru
        billboard = Instance.new("BillboardGui")
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 100, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.AlwaysOnTop = true
        billboard.Name = "AccumulatedDamage_" .. id

        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "DamageLabel"
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = "-" .. tostring(damage)
        textLabel.TextColor3 = damage > 80 and Color3.fromRGB(170, 0, 255) or Color3.new(1, 0, 0)
        textLabel.TextStrokeTransparency = 0
        textLabel.TextScaled = true
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.Parent = billboard

        -- Waktu penghapusan
        local removeTime = Instance.new("NumberValue")
        removeTime.Name = "RemoveAt"
        removeTime.Value = tick() + 1.5
        removeTime.Parent = billboard

        billboard.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        activeBillboards[id] = billboard
    end
end

-- Fungsi utama pemantauan
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

        -- Hapus billboard jika waktunya habis
        for id, billboard in pairs(activeBillboards) do
            if billboard and billboard:FindFirstChild("RemoveAt") then
                if tick() > billboard.RemoveAt.Value then
                    billboard:Destroy()
                    activeBillboards[id] = nil
                end
            end
        end
    end
end

monitorDamage()
