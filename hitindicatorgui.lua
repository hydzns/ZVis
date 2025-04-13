local lastHealth = {}
local activeLabels = {}
local damageLogGui = nil
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local targetEnemy = nil
local lastAttackTime = 0

-- Coba deteksi target (bisa kamu ubah sesuai sistem combat gamemu)
function trackTarget()
	local char = LocalPlayer.Character
	if not char then return end

	local mouse = LocalPlayer:GetMouse()
	mouse.Button1Down:Connect(function()
		local target = mouse.Target
		if target and target.Parent and target.Parent:FindFirstChild("Humanoid") then
			local player = Players:GetPlayerFromCharacter(target.Parent)
			if player and player ~= LocalPlayer then
				targetEnemy = player
				lastAttackTime = tick()
			end
		end
	end)
end

-- GUI setup
function setupGui()
	local gui = LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("DamageLogGui")
	if gui then return gui end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "DamageLogGui"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

	damageLogGui = screenGui
	return screenGui
end

-- Atur posisi label agar tidak tumpuk
function updateLabelPositions()
	local baseY = -300
	local spacing = 35
	local index = 0

	for _, entry in pairs(activeLabels) do
		if entry.label and entry.label.Parent then
			entry.label.Position = UDim2.new(0, 350, 1, baseY - (index * spacing))
			index += 1
		end
	end
end

-- Show damage per enemy
function showAccumulatedDamage(player, damage)
	local id = player.UserId
	local entry = activeLabels[id]

	if entry and entry.label and entry.label.Parent then
		entry.damage = entry.damage + damage
		entry.label.Text = "-" .. tostring(entry.damage)
		entry.label.TextColor3 = damage > 272 and Color3.fromRGB(170, 0, 255) or Color3.new(1, 0, 0)
		entry.expireTime = tick() + 1.5
	else
		local screenGui = setupGui()
		local label = Instance.new("TextLabel")
		label.Name = "DamageLabel_" .. id
		label.Size = UDim2.new(0, 200, 0, 30)
		label.Position = UDim2.new(0, 350, 1, -300)
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
		updateLabelPositions()
	end
end

-- Main monitoring
function monitorDamage()
	while task.wait(0.1) do
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character then
				local humanoid = player.Character:FindFirstChild("Humanoid")
				if humanoid then
					local currentHealth = humanoid.Health
					local previousHealth = lastHealth[player] or currentHealth

					if currentHealth < previousHealth then
						-- Hanya tampilkan jika player ini adalah target kita, dan baru saja kita serang
						if targetEnemy == player and (tick() - lastAttackTime <= 2) then
							local damage = math.floor(previousHealth - currentHealth)
							showAccumulatedDamage(player, damage)
						end
					end

					lastHealth[player] = currentHealth
				end
			end
		end

		-- Hapus label jika expired
		for id, entry in pairs(activeLabels) do
			if tick() > entry.expireTime then
				if entry.label then
					entry.label:Destroy()
				end
				activeLabels[id] = nil
				updateLabelPositions()
			end
		end
	end
end

trackTarget()
monitorDamage()
