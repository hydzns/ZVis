local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "ZVis - DSBA",
    Icon = 0,
    LoadingTitle = "ZVis - DSBA",
    LoadingSubtitle = "ONLY VISUAL AND NO HACKS!",
    Theme = "Default",

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

-- 👾 Tab: Utility
local Tab = Window:CreateTab("Utility", 4483362458)
local Section = Tab:CreateSection("Virtual HUD - ONLY TOGGLE 1 OR THE TEXT BUG!")

Tab:CreateButton({
    Name = "Run Health Bar [GUI]",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hydzns/ZVis/refs/heads/main/healthbargui.lua"))()
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

-- 🔁 Toggle ESP Item
local espConnection = nil
local espEnabled = false

Tab:CreateToggle({
    Name = "Toggle ESP Item",
    CurrentValue = false,
    Flag = "ToggleESPItem",
    Callback = function(Value)
        if Value then
            _G.ESPItemEnabled = true
            loadstring(game:HttpGet("https://raw.githubusercontent.com/hydzns/ZVis/refs/heads/main/ESPitem.lua"))()
        else
            _G.ESPItemEnabled = false
        end
    end,
})

-- 🌟 Tab Baru: Adv Menu
local AdvTab = Window:CreateTab("Adv Menu", 4483362458)
AdvTab:CreateSection("Player Info")

AdvTab:CreateButton({
    Name = "Show Ranked Points (Rounded)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hydzns/ZVis/refs/heads/main/showlevel.lua"))()
    end,
})

AdvTab:CreateButton({
    Name = "Show Ranked Points (Rounded)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hydzns/ZVis/refs/heads/main/showrankpoint.lua"))()
    end,
})

Rayfield:LoadConfiguration()
