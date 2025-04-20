local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function safeTeleport(targetPos)
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")

	local sinkY = -150
	local sunkenStart = Vector3.new(hrp.Position.X, sinkY, hrp.Position.Z)
	local sunkenEnd = Vector3.new(targetPos.X, sinkY, targetPos.Z)

	-- Step 1: Langsung tenggelam ke Y -150
	hrp.CFrame = CFrame.new(sunkenStart)
	task.wait(0.1)

	-- Step 2: Tween dari sunkenStart ke sunkenEnd (XZ doang)
	local elapsed = 0
	local travelTime = 5
	local conn
	conn = RunService.RenderStepped:Connect(function(dt)
		elapsed += dt
		local alpha = math.clamp(elapsed / travelTime, 0, 1)
		local newXZ = sunkenStart:Lerp(sunkenEnd, alpha)
		hrp.CFrame = CFrame.new(newXZ.X, sinkY, newXZ.Z)
		if alpha >= 1 then
			conn:Disconnect()
		end
	end)

	task.wait(travelTime + 0.2)

	-- Step 3: Naik ke posisi target Y asli
	elapsed = 0
	local riseTime = 0.5
	conn = RunService.RenderStepped:Connect(function(dt)
		elapsed += dt
		local alpha = math.clamp(elapsed / riseTime, 0, 1)
		local y = sinkY + ((targetPos.Y - sinkY) * alpha)
		hrp.CFrame = CFrame.new(targetPos.X, y, targetPos.Z)
		if alpha >= 1 then
			conn:Disconnect()
		end
	end)
end

-- Contoh pemakaian
safeTeleport(Vector3.new(180, 1067, 1985))
