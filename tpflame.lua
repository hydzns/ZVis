local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local hrp = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
hrp = hrp:WaitForChild("HumanoidRootPart")

local start = hrp.Position
local target = Vector3.new(-843, 1108, -145)
local time = 2
local elapsed = 0

local conn
conn = RunService.RenderStepped:Connect(function(dt)
	elapsed += dt
	local alpha = math.clamp(elapsed / time, 0, 1)
	hrp.CFrame = CFrame.new(start:Lerp(target, alpha))
	if alpha >= 1 then conn:Disconnect() end
end)
