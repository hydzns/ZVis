local player = game.Players.LocalPlayer
        local data = player:FindFirstChild("Data")
        local coins = data and data:FindFirstChild("Christmas_Coins")
        local value = coins and coins.Value or "N/A"

        -- Format ke 1 angka di belakang koma
        local formatted = type(value) == "number" and string.format("%.1f", value) or "N/A"

        Rayfield:Notify({
            Title = "Ranked Points",
            Content = "Current Ranked Points: " .. tostring(formatted),
            Duration = 5,
            Image = 4483362458,
        })
    end,
})
