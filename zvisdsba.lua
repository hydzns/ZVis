local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
_G.Rayfield = Rayfield

local Window = Rayfield:CreateWindow({
    Name = "ZVision - DSBA",
    Icon = 0,
    LoadingTitle = "By ZVision",
    LoadingSubtitle = "ONLY VISUAL",
    Theme = "Abyss",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "ZVis"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Untitled",
        Subtitle = "Key System",
        Note = "No method of obtaining the key is provided",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"Hello"}
    }
})

local Tab = Window:CreateTab("Utility", 4483362458)
local Section = Tab:CreateSection("Virtual HUD - ONLY TOGGLE 1 OR THE TEXT BUG!")

Tab:CreateButton({
    Name = "Run Health Bar [GUI]",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hydzns/ZVis/main/healthbargui.lua"))()
    end
})

Tab:CreateButton({
    Name = "Run Damage Indicator [GUI]",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hydzns/ZVis/main/hitindicatorgui.lua"))()
    end
})

Tab:CreateButton({
    Name = "Run Damage Indicator [HEAD]",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hydzns/ZVis/main/hitindicatorhead.lua"))()
    end
})

local espConnection = nil
local espEnabled = false

Tab:CreateToggle({
    Name = "Toggle ESP Item",
    CurrentValue = false,
    Flag = "ToggleESPItem",
    Callback = function(Value)
        if Value then
            _G.ESPItemEnabled = true
            loadstring(game:HttpGet("https://raw.githubusercontent.com/hydzns/ZVis/main/ESPitem.lua"))()
        else
            _G.ESPItemEnabled = false
        end
    end,
})

local AdvTab = Window:CreateTab("Adv Menu", 4483362458)
AdvTab:CreateSection("Player Info")

AdvTab:CreateButton({
    Name = "Show Player Level",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/hydzns/ZVis/main/showlevel.lua"))()
        end)
        if not success then
            warn("Failed to load showlevel.lua:", err)
        end
    end,
})

AdvTab:CreateButton({
    Name = "Show Ranked Points (Rounded)",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/hydzns/ZVis/main/showrankpoint.lua"))()
        end)
        if not success then
            warn("Failed to load showrankpoint.lua:", err)
        end
    end,
})

Rayfield:LoadConfiguration()
