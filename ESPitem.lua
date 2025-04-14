-- ESP Gabungan + Jarak Meter
local itemNames = {
    ["Flute"] = Color3.fromRGB(255, 255, 0),
    ["Frozen Demon Horn"] = Color3.fromRGB(0, 255, 255),
    ["Katana Shard"] = Color3.fromRGB(255, 100, 100),
    ["Thread Of Denial"] = Color3.fromRGB(200, 0, 255),
    ["Obi Sash Thing"] = Color3.fromRGB(255, 170, 0)
}

local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local function createESP(part, itemName, color)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ItemESP"
    billboard.Adornee = part
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.Parent = part

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0.6, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = itemName
    label.TextColor3 = color
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0.4, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.6, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "0m away"
    distanceLabel.TextColor3 = Color3.new(1, 1, 1)
    distanceLabel.TextScaled = true
    distanceLabel.TextStrokeTransparency = 0.5
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.Parent = billboard

    -- Perbarui jarak secara real-time
    game:GetService("RunService").RenderStepped:Connect(function()
        if hrp and part and part:IsDescendantOf(workspace) then
            local dist = math.floor((hrp.Position - part.Position).Magnitude)
            distanceLabel.Text = tostring(dist) .. "m away"
        end
    end)
end

local function checkAndCreateESP(tool)
    local color = itemNames[tool.Name]
    if color then
        local handle = tool:FindFirstChild("Handle")
        if handle and not handle:FindFirstChild("ItemESP") then
            createESP(handle, tool.Name, color)
        end
    end
end

-- Cek yang sudah ada di workspace
for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("Tool") and itemNames[obj.Name] then
        checkAndCreateESP(obj)
    end
end

-- Deteksi item baru
workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("Tool") and itemNames[obj.Name] then
        task.delay(0.1, function()
            checkAndCreateESP(obj)
        end)
    end
end)
