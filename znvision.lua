Util:CreateToggle({
    Name = "Auto Parry [Strong Attack Only]",
    CurrentValue = false,
    Flag = "AutoParryToggle",
    Callback = function(state)
        _G.AutoParryEnabled = state

        if state then
            if _G.AutoParryConnection then
                _G.AutoParryConnection:Disconnect()
            end

            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local VirtualInputManager = game:GetService("VirtualInputManager")
            local LocalPlayer = Players.LocalPlayer
            local debounce = {}
            local cooldown = 5.2

            local function smartParry()
                if _G.ParryLock then return end
                _G.ParryLock = true

                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                task.wait(0.6)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)

                _G.ParryLock = false
            end

            _G.AutoParryConnection = RunService.Heartbeat:Connect(function()
                if not _G.AutoParryEnabled then return end

                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local theirHRP = plr.Character:FindFirstChild("HumanoidRootPart")
                        if myHRP and theirHRP then
                            local dist = (theirHRP.Position - myHRP.Position).Magnitude
                            if dist < 10 then
                                local cds = plr:FindFirstChild("cds")
                                if cds then
                                    local strong = cds:FindFirstChild("StrongAttack")
                                    if strong and strong.Value > 0 then
                                        local now = tick()
                                        local last = debounce[plr] or 0

                                        if now - last > cooldown then
                                            debounce[plr] = now
                                            task.delay(0.15, smartParry)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        else
            if _G.AutoParryConnection then
                _G.AutoParryConnection:Disconnect()
                _G.AutoParryConnection = nil
            end
        end
    end
})
