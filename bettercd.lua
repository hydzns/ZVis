local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local cdsFolder = LocalPlayer:WaitForChild("cds")

local ignoreList = {
	["NormalAttack"] = true,
	["Dash"] = true,
	["Execute"] = true,
	["blockstart"] = true
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CooldownDisplay"
screenGui.Parent = PlayerGui

local container = Instance.new("Frame")
container.Name = "CooldownContainer"
container.AnchorPoint = Vector2.new(0.5, 1)
container.Position = UDim2.new(0.5, 0, 1, -80)
container.Size = UDim2.new(0.6, 0, 0.1, 0)
container.BackgroundTransparency = 1
container.Parent = screenGui

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Horizontal
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 10)
layout.Parent = container

-- Fungsi pewarnaan teks CD
local function getColorCode(percent)
	if percent > 0.6 then
		return "rgb(255, 60, 60)" -- Merah
	elseif percent > 0.3 then
		return "rgb(255, 200, 0)" -- Kuning
	else
		return "rgb(0, 255, 0)" -- Hijau
	end
end

-- Fungsi membuat label cooldown
local function createCooldownLabel(cdObject)
	if ignoreList[cdObject.Name] then return end

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0, 160, 1, 0)
	label.BackgroundTransparency = 0.2
	label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	label.Font = Enum.Font.Arcade
	label.TextScaled = true
	label.RichText = true
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Text = ""
	label.Name = cdObject.Name
	label.Parent = container

	local startTime = os.clock()
	local duration = cdObject.Value

	local connection
	connection = RunService.RenderStepped:Connect(function()
		if not cdObject or not cdObject.Parent then
			label:Destroy()
			connection:Disconnect()
			return
		end

		local elapsed = os.clock() - startTime
		local remaining = math.max(0, duration - elapsed)

		if remaining <= 0 then
			label:Destroy()
			connection:Disconnect()
			return
		end

		local percentLeft = remaining / duration
		local colorCode = getColorCode(percentLeft)
		local rounded = math.ceil(remaining)

		label.Text = cdObject.Name .. "\n<font color=\"" .. colorCode .. "\" size=\"20\">" .. rounded .. "s</font>"
	end)
end

-- Saat ada cooldown baru
cdsFolder.ChildAdded:Connect(function(child)
	if child:IsA("NumberValue") then
		createCooldownLabel(child)
	end
end)

-- Tampilkan cooldown yang sudah ada
for _, cd in pairs(cdsFolder:GetChildren()) do
	if cd:IsA("NumberValue") then
		createCooldownLabel(cd)
	end
end
