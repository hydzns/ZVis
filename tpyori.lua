local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local function teleportSmooth(pos)
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart", 5)
	if hrp then
		local goal = {}
		goal.CFrame = CFrame.new(pos)

		local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Linear) -- 1.5 detik, bisa kamu ubah
		local tween = TweenService:Create(hrp, tweenInfo, goal)
		tween:Play()
	end
end

teleportSmooth(Vector3.new(180, 1067, 1985))
