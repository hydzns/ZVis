-- Tabel untuk menyimpan health sebelumnya
local lastHealth = {}

-- Fungsi untuk membuat BillboardGui damage text
function showDamageGui(player, damage)
    local head = player.Character and player.Character:FindFirstChild("Head")
    if not head then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 100, 0, 40)

    --  Perubahan: offset acak biar teks tersebar
    local offsetX = math.random(-15, 15) / 10  -- antara -1.5 sampai 1.5
    local offsetY = math.random(20, 30) / 10   -- antara 2.0 sampai 3.0
    billboard.StudsOffset = Vector3.new(offsetX, offsetY, 0)

    billboard.AlwaysOnTop = true
    billboard.Name = "DamageText_" .. tostring(math.random(1000, 9999))

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "-" .. tostring(damage)
    textLabel.TextColor3 = Color3.new(1, 0, 0)
    textLabel.TextStrokeTransparency = 0
    textLabel.TextScaled = true
	textLabel.Font = Enum.Font.Arcade
    textLabel.Parent = billboard

    --  Tetap dipasang di PlayerGui, seperti versi kamu yang stabil
    billboard.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    -- Hapus otomatis setelah 1.5 detik
    game:GetService("Debris"):AddItem(billboard, 1.5)
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
                        showDamageGui(player, damage)
                    end
                    lastHealth[player] = currentHealth
                end
            end
        end
    end
end

monitorDamage()
