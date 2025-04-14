-- ESP Gabungan Toggleable
_G.ESPItemEnabled = true

local itemNames = {
    ["Flute"] = Color3.fromRGB(255, 255, 0),
    ["Frozen Demon Horn"] = Color3.fromRGB(0, 255, 255),
    ["Katana Shard"] = Color3.fromRGB(255, 100, 100),
    ["Thread Of Denial"] = Color3.fromRGB(200, 0, 255),
    ["Obi Sash Thing"] = Color3.fromRGB(255, 170, 0),
    ["Use Earring"] = Color3.fromRGB(255, 255, 255)
}

local player = game:GetService("Players").LocalPlayer
local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart") or nil
if not hrp then player.CharacterAdded:Wait() hrp = player.Character:WaitForChild("HumanoidRootPart") end

local function createESP(part, name, color)
    local bb = Instance.new("BillboardGui")
    bb.Name = "ItemESP"
    bb.Adornee = part
    bb.Size = UDim2.new(0, 100, 0, 50)
    bb.AlwaysOnTop = true
    bb.Parent = part

    local label = Instance.new("TextLabel", bb)
    label.Size = UDim2.new(1, 0, 0.6, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = color
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.TextStrokeTransparency = 0

    local distance = Instance.new("TextLabel", bb)
    distance.Size = UDim2.new(1, 0, 0.4, 0)
    distance.Position = UDim2.new(0, 0, 0.6, 0)
    distance.BackgroundTransparency = 1
    distance.TextColor3 = Color3.new(1, 1, 1)
    distance.Font = Enum.Font.Gotham
    distance.TextScaled = true
    distance.Text = "..."

    game:GetService("RunService").RenderStepped:Connect(function()
        if _G.ESPItemEnabled and hrp and part then
            local dist = math.floor((hrp.Position - part.Position).Magnitude)
            distance.Text = tostring(dist) .. "m away"
        elseif not _G.ESPItemEnabled and bb then
            bb:Destroy()
        end
    end)
end

local function scan(tool)
    local color = itemNames[tool.Name]
    if color and _G.ESPItemEnabled then
        local handle = tool:FindFirstChild("Handle")
        if handle and not handle:FindFirstChild("ItemESP") then
            createESP(handle, tool.Name, color)
        end
    end
end

for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("Tool") and itemNames[obj.Name] then
        scan(obj)
    end
end

workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("Tool") and itemNames[obj.Name] then
        task.wait(0.1)
        scan(obj)
    end
end)
