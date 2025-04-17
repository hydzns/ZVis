local player = game.Players.LocalPlayer
local data = player:FindFirstChild("Data")
local level = data and data:FindFirstChild("Level")
local value = level and level.Value or "N/A"

if Rayfield then
    Rayfield:Notify({
        Title = "Player Level",
        Content = "Current Level: " .. tostring(value),
        Duration = 5,
        Image = 4483362458,
    })
end
