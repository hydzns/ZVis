-- ESP untuk item bernama "Obi Sash Thing"
local function createESP(part, name)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ItemESP"
    billboard.Adornee = part
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.AlwaysOnTop = true

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 0)
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard

    billboard.Parent = part
end

-- Cek semua item di Workspace
for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("Tool") and obj.Name == "Obi Sash Thing" then
        local handle = obj:FindFirstChild("Handle")
        if handle and not handle:FindFirstChild("ItemESP") then
            createESP(handle, "Obi Sash Thing")
        end
    end
end

-- Tambahkan listener jika spawn baru
workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("Tool") and obj.Name == "Obi Sash Thing" then
        local handle = obj:WaitForChild("Handle", 5)
        if handle and not handle:FindFirstChild("ItemESP") then
            createESP(handle, "Obi Sash Thing")
        end
    end
end)
