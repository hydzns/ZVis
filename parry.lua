local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

local parryCooldown = 5.2
local activeParry = {} -- Menyimpan siapa yang sudah diparry

local function smartParry()
    if _G.ParryLock then return end
    _G.ParryLock = true
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
    task.wait(0.6)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
    _G.ParryLock = false
end

RunService.Heartbeat:Connect(function()
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end

    for _, enemy in ipairs(Players:GetPlayers()) do
        if enemy ~= LocalPlayer and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (enemy.Character.HumanoidRootPart.Position - myHRP.Position).Magnitude
            if dist < 10 then
                local cds = enemy:FindFirstChild("cds")
                if cds then
                    local strong = cds:FindFirstChild("StrongAttack")
                    if strong and strong.Value > 0 and not activeParry[enemy] then
                        activeParry[enemy] = true
                        task.delay(0.1, smartParry)

                        -- Reset status setelah cooldown normalnya selesai (dengan buffer)
                        task.delay(parryCooldown, function()
                            activeParry[enemy] = nil
                        end)
                    end
                end
            end
        end
    end
end)
