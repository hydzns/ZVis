local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function smoothTeleportWithSink(targetPos)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")

    local start = hrp.Position
    local sinkY = -20

    local downStart = Vector3.new(start.X, sinkY, start.Z)
    local downTarget = Vector3.new(targetPos.X, sinkY, targetPos.Z)

    local function tweenTo(pos1, pos2, duration)
        local elapsed = 0
        local conn
        conn = RunService.RenderStepped:Connect(function(dt)
            elapsed += dt
            local alpha = math.clamp(elapsed / duration, 0, 1)
            local newPos = pos1:Lerp(pos2, alpha)
            hrp.CFrame = CFrame.new(newPos)
            if alpha >= 1 then conn:Disconnect() end
        end)
    end

    tweenTo(start, downStart, 0.25)
    task.wait(0.3)
    hrp.CFrame = CFrame.new(downTarget)
    task.wait(0.2)
    tweenTo(downTarget, targetPos, 0.5)
end

smoothTeleportWithSink(Vector3.new(180, 1067, 1985))
