local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function smoothTeleportWithSink(targetPos)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")

    local start = hrp.Position
    local downPos = Vector3.new(start.X, start.Y - 10, start.Z)
    local targetBelow = Vector3.new(targetPos.X, targetPos.Y - 10, targetPos.Z)

    local function moveTo(pos1, pos2, duration)
        local elapsed = 0
        local conn
        conn = RunService.RenderStepped:Connect(function(dt)
            elapsed += dt
            local alpha = math.clamp(elapsed / duration, 0, 1)
            local newPos = pos1:Lerp(pos2, alpha)
            hrp.CFrame = CFrame.new(newPos)
            if alpha >= 1 then
                conn:Disconnect()
            end
        end)
    end

    moveTo(start, downPos, 0.3)
    task.wait(0.35)

    hrp.CFrame = CFrame.new(targetBelow)
    task.wait(0.1)

    moveTo(targetBelow, targetPos, 0.4)
end

smoothTeleportWithSink(Vector3.new(-1667, 1006, -1606))
