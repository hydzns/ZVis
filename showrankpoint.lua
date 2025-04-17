local Rayfield = _G.Rayfield

local player = game.Players.LocalPlayer
local data = player:FindFirstChild("Data")
local rank = data and data:FindFirstChild("Christmas_Coins")
local value = rank and math.floor(rank.Value + 0.5) or "N/A"

if Rayfield then
    Rayfield:Notify({
        Title = "Ranked Points",
        Content = "Current Ranked Points: " .. tostring(value),
        Duration = 5,
        Image = 4483362458,
    })
end
