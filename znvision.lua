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
Util:CreateSection("Tools")

Util:CreateButton({
    Name = "Auto Parry [Strong Attack Only]",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/znhacks/znvision/refs/heads/main/parry.lua"))()
    end
})

Util:CreateButton({
    Name = "Health Bar [Multi-Player]",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/znhacks/znvision/main/healthbargui.lua"))()
    end
})

Util:CreateButton({
    Name = "Damage Indicator NPC + Player [Screen]",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/znhacks/znvision/main/hitindicatorgui.lua"))()
    end
})

Util:CreateButton({
    Name = "Damage Indicator [Player-Head-Only]",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/znhacks/znvision/main/hitindicatorhead.lua"))()
    end
})

Util:CreateButton({
    Name = "Better Cooldowns",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/znhacks/znvision/refs/heads/main/bettercd.lua"))()
    end
})

local AdvTab = Window:CreateTab("Info Menu", 4483362458)
AdvTab:CreateSection("Player Info")

AdvTab:CreateButton({
    Name = "Show Player Level",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/znhacks/znvision/main/showlevel.lua"))()
    end,
})

AdvTab:CreateButton({
    Name = "Show Ranked Points",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/znhacks/znvision/main/showrankpoint.lua"))()
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
