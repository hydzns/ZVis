local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
_G.Rayfield = Rayfield

local Window = Rayfield:CreateWindow({
    Name = "ZVision - DSBA",
    Icon = 0,
    LoadingTitle = "By ZVision",
    LoadingSubtitle = "Visual Enchancer",
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
    KeySystem = true,
    KeySettings = {
        Title = "ZVision",
        Subtitle = "Key System",
        Note = "Only one knows the key",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"ZEN"}
    }
})

local Util = Window:CreateTab("Utility", 4483362458)
Util:CreateSection("Visual")

Util:CreateButton({
    Name = "Health Bar [Multi-Player]",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hydzns/ZVis/main/healthbargui.lua"))()
    end
})

Util:CreateButton({
    Name = "Damage Indicator NPC + Player [Screen]",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hydzns/ZVis/main/hitindicatorgui.lua"))()
    end
})

Util:CreateButton({
    Name = "Damage Indicator [Player-Head-Only]",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hydzns/ZVis/main/hitindicatorhead.lua"))()
    end
})

Util:CreateButton({
    Name = "Better Cooldowns",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hydzns/ZVis/refs/heads/main/bettercd.lua"))()
    end
})

local AdvTab = Window:CreateTab("Info Menu", 4483362458)
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
    Name = "Show Ranked Points",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/hydzns/ZVis/main/showrankpoint.lua"))()
        end)
        if not success then
            warn("Failed to load showrankpoint.lua:", err)
        end
    end,
})

local Hacks = Window:CreateTab("TP", 4483362458)
Hacks:CreateSection("USE TP SLOWLY!")

Hacks:CreateButton({
    Name = "TP Flame",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/znhacks/znvision/main/tpflame.lua"))()
        end)
    end,
})

Hacks:CreateButton({
    Name = "TP Passive",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/znhacks/znvision/main/tppassive.lua"))()
        end)
    end,
})

Hacks:CreateButton({
    Name = "TP Yori",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/znhacks/znvision/main/tpyori.lua"))()
        end)
    end,
})

Hacks:CreateButton({
    Name = "TP Yukioni",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/znhacks/znvision/main/tpyukioni.lua"))()
        end)
    end,
})


Rayfield:LoadConfiguration()
