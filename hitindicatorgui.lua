if _G.HitIndicatorConnection then
    _G.HitIndicatorConnection:Disconnect()
    _G.HitIndicatorConnection = nil
end

_G.HitIndicatorEnabled = true

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local screenGui = player:WaitForChild("PlayerGui"):FindFirstChild("DamageScreenGui") or Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "DamageScreenGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

local trackedTargets = {}
local lastHealth = {}
local activeLabels = {}

local function getStyle(damage)
    if damage >= 450 then
        return Color3.fromRGB(120, 0, 0), 200
    elseif damage >= 350 then
        return Color3.fromRGB(100, 0, 150), 150
    elseif damage >= 250 then
        return Color3.fromRGB(170, 0, 255), 100
    else
        return Color3.new(1, 0, 0), 50
    end
end

local function showDamage(damage)
    local existingLabel = activeLabels["Main"]
    if existingLabel and existingLabel.Parent then
        local old = tonumber(existingLabel.Text:match("%d+")) or 0
        local newDamage = old + damage
        existingLabel.Text = "-" .. tostring(newDamage)

        local color, size = getStyle(newDamage)
        existingLabel.TextColor3 = color
        existingLabel.TextSize = size
    else
        local label = Instance.new("TextLabel")
        label.Name = "DamageLabel_Main"
        label.Size = UDim2.new(0, 250, 0, 50)
        label.Position = UDim2.new(0.5, -125, 0.7, 0)
        label.AnchorPoint = Vector2.new(0.5, 0)
        label.BackgroundTransparency = 1
        label.Text = "-" .. tostring(damage)

        local color, size = getStyle(damage)
        label.TextColor3 = color
        label.TextStrokeTransparency = 0
        label.TextScaled = true
        label.Font = Enum.Font.Arcade
        label.TextSize = size
        label.Parent = screenGui

        activeLabels["Main"] = label

        delay(5, function()
            if label then label:Destroy() end
            activeLabels["Main"] = nil
        end)
    end
end

local function trackHumanoid(model)
    if not model:IsA("Model") or model == player.Character then return end
    local humanoid = model:FindFirstChildWhichIsA("Humanoid")
    if humanoid and not trackedTargets[model] then
        trackedTargets[model] = humanoid
        lastHealth[model] = humanoid.Health
    end
end

-- Inisialisasi semua NPC dan player di workspace
for _, inst in ipairs(workspace:GetDescendants()) do
    trackHumanoid(inst)
end

-- Jika NPC/player baru muncul
workspace.DescendantAdded:Connect(function(child)
    task.defer(function()
        trackHumanoid(child)
    end)
end)

_G.HitIndicatorConnection = RunService.Heartbeat:Connect(function()
    if not _G.HitIndicatorEnabled then return end

    for model, humanoid in pairs(trackedTargets) do
        if humanoid and humanoid.Parent then
            local current = humanoid.Health
            local previous = lastHealth[model] or current

            if current < previous then
                local damage = math.floor(previous - current)

                -- Creator tag validasi
                local tag = humanoid:FindFirstChild("creator")
                if not tag then
                    -- fallback delay
                    for _, obj in ipairs(humanoid:GetChildren()) do
                        if obj.Name == "creator" then
                            tag = obj
                            break
                        end
                    end
                end

                local isFromLocalPlayer = false
                if tag and tag.Value then
                    local val = tag.Value
                    isFromLocalPlayer =
                        (val == player) or
                        (typeof(val) == "Instance" and val:IsA("Tool") and val.Parent == player.Character) or
                        (typeof(val) == "string" and val == player.Name)
                end

                if isFromLocalPlayer then
                    showDamage(damage)
                end
            end

            lastHealth[model] = current
        end
    end
end)
