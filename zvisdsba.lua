local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
_G.Rayfield = Rayfield

local Window = Rayfield:CreateWindow({
    Name = "ZVision - DSBA",
    Icon = 0,
    LoadingTitle = "By ZVision",
    LoadingSubtitle = "ONLY VISUAL",
    Theme = "Blood",
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
    Name = "Health Bar [Multi-Player]",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hydzns/ZVis/main/healthbargui.lua"))()
    end
})

Tab:CreateButton({
    Name = "Run Damage Indicator [Screen]",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hydzns/ZVis/main/hitindicatorgui.lua"))()
    end
})

Tab:CreateButton({
    Name = "Run Damage Indicator [Player-Head]",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hydzns/ZVis/main/hitindicatorhead.lua"))()
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

Rayfield:LoadConfiguration()
