local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function smoothTeleport(targetPosition, duration)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart", 5)
    if not hrp then return end

    local start = hrp.Position
    local elapsed = 0

    local connection
    connection = RunService.RenderStepped:Connect(function(delta)
        elapsed += delta
        local alpha = math.clamp(elapsed / duration, 0, 1)
        local newPos = start:Lerp(targetPosition, alpha)
        hrp.CFrame = CFrame.new(newPos)

        if alpha >= 1 then
            connection:Disconnect()
        end
    end)
end

-- Teleport lebih cepat: 0.5 detik
smoothTeleport(Vector3.new(-843, 1108, -145), 0.5)
