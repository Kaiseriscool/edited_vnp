VNP.Inventory.Rarities = VNP.Inventory.Rarities or {}

local RARITY = {}

function VNP.Inventory:RegisterRarity(data)
    if !data.Name then return end

    self.Rarities[data.Name] = data

    RARITY = {}
end

/*
RARITY.Name = "Example"

RARITY.Color = Color(200,200,200)

RARITY.Color2 = Color(255,0,0) -- Second color to fade between

RARITY.Effect = "Fade" -- Rainbow, Fade, Default

RARITY.Scrap = 0 -- Scrap amount for this rarity

 -- Percentage of increase in the stats below...
RARITY.Modifiers = {
    ["FireDelay"] = {min = 0, max = 5},
    ["Damage"] = {min = 0, max = 5},
    ["KickUp"] = {min = 0, max = 5},

}

RARITY.Sockets = 0 -- Number of sockets for this rarity.

VNP.Inventory:RegisterRarity(RARITY)
*/


--[[
    Common
]]--

RARITY.Name = "Common" -- the common rarity doesn't have a darker border around it :c 

RARITY.Color = Color(150, 150, 150, 255)

RARITY.Effect = "Defualt" -- Rainbow, Fade, Default

RARITY.Scrap = 7 -- Scrap amount for this rarity

 -- Percentage of increase in the stats below...
RARITY.Modifiers = {
    ["Damage"] =    {min = 0, max = 5},
    ["KickUp"] =    {min = 0, max = 5},
    ["Spread"] =  {min = 0, max = 5},
    ["RPM"] =  {min = 0, max = 5},
    ["ClipSize"] =  {min = 0, max = 10},
}

RARITY.Sockets = 0 -- Number of sockets for this rarity.

RARITY.Order = 1

RARITY.UpgradeChance = { -- this was added for scrolls
    ["upgrMajorSuccess"] = {val = 1},
    ["upgrMinorSuccess"] = {val = 50},

    ["upgrMajorFail"] = {val = 1},
    ["upgrMinorFail"] = {val = 2},
}
RARITY.EnhanceCost = 5000

VNP.Inventory:RegisterRarity(RARITY)
------------------------------------
--[[
    Uncommon
]]--

RARITY.Name = "Uncommon"

RARITY.Color = Color(20, 200, 80, 255)

RARITY.Scrap = 10

 -- Percentage of increase in the stats below...
RARITY.Modifiers = {
    ["Damage"] =    {min = 5, max = 10},
    ["KickUp"] =    {min = 5, max = 10},
    ["Spread"] =  {min = 5, max = 10},
    ["RPM"] =  {min = 5, max = 10},
    ["ClipSize"] =  {min = 5, max = 10},
}

RARITY.Sockets = 1 -- Number of sockets for this rarity.

RARITY.Order = 2

RARITY.UpgradeChance = { -- this was added for scrolls
    ["upgrMajorSuccess"] = {val = 1},
    ["upgrMinorSuccess"] = {val = 50},

    ["upgrMajorFail"] = {val = 1.5},
    ["upgrMinorFail"] = {val = 2},
}
RARITY.EnhanceCost = 10000

VNP.Inventory:RegisterRarity(RARITY)
------------------------------------
--[[
    Rare
]]--

RARITY.Name = "Rare"

RARITY.Color = Color(45, 140, 255, 255)

RARITY.Scrap = 15

 -- Percentage of increase in the stats below...
RARITY.Modifiers = {
    ["Damage"] =    {min = 20, max = 30},
    ["KickUp"] =    {min = 20, max = 30},
    ["Spread"] =  {min = 20, max = 30},
    ["RPM"] =  {min = 20, max = 30},
    ["ClipSize"] =  {min = 20, max = 30},
}

RARITY.Sockets = 2 -- Number of sockets for this rarity.

RARITY.Order = 3

RARITY.UpgradeChance = { -- this was added for scrolls
    ["upgrMajorSuccess"] = {val = 1},
    ["upgrMinorSuccess"] = {val = 25},

    ["upgrMajorFail"] = {val = 1.5},
    ["upgrMinorFail"] = {val = 2},
}
RARITY.EnhanceCost = 15000

VNP.Inventory:RegisterRarity(RARITY)
------------------------------------
--[[
    Epic
]]--

RARITY.Name = "Epic"

RARITY.Color = Color(190, 40, 190, 255)

RARITY.Scrap = 25

 -- Percentage of increase in the stats below...
RARITY.Modifiers = {
    ["Damage"] =    {min = 30, max = 40},
    ["KickUp"] =    {min = 30, max = 40},
    ["Spread"] =  {min = 30, max = 40},
    ["RPM"] =  {min = 30, max = 40},
    ["ClipSize"] =  {min = 30, max = 40},
}

RARITY.Sockets = 3 -- Number of sockets for this rarity.

RARITY.Order = 4

RARITY.UpgradeChance = { -- this was added for scrolls
    ["upgrMajorSuccess"] = {val = 1},
    ["upgrMinorSuccess"] = {val = 15},

    ["upgrMajorFail"] = {val = 2},
    ["upgrMinorFail"] = {val = 2},
}
RARITY.EnhanceCost = 30000

VNP.Inventory:RegisterRarity(RARITY)
------------------------------------
--[[
    Legendary
]]--

RARITY.Name = "Legendary"

RARITY.Color = Color(255, 130, 60, 255)

RARITY.Scrap = 30

 -- Percentage of increase in the stats below...
RARITY.Modifiers = {
    ["Damage"] =    {min = 50, max = 60},
    ["KickUp"] =    {min = 50, max = 60},
    ["Spread"] =  {min = 50, max = 60},
    ["RPM"] =  {min = 50, max = 60},
    ["ClipSize"] =  {min = 50, max = 60},
}

RARITY.Sockets = 4 -- Number of sockets for this rarity.

RARITY.Order = 5

RARITY.UpgradeChance = { -- this was added for scrolls
    ["upgrMajorSuccess"] = {val = 1},
    ["upgrMinorSuccess"] = {val = 10},

    ["upgrMajorFail"] = {val = 2},
    ["upgrMinorFail"] = {val = 2},
}
RARITY.EnhanceCost = 50000

VNP.Inventory:RegisterRarity(RARITY)
------------------------------------
--[[
    Celestial
]]--

RARITY.Name = "Celestial"

RARITY.Color = Color(255, 70, 70, 255)

RARITY.Scrap = 35

 -- Percentage of increase in the stats below...
RARITY.Modifiers = {
    ["Damage"] =    {min = 60, max = 70},
    ["KickUp"] =    {min = 60, max = 70},
    ["Spread"] =  {min = 60, max = 70},
    ["RPM"] =  {min = 60, max = 70},
    ["ClipSize"] =  {min = 60, max = 70},
}

RARITY.Sockets = 5 -- Number of sockets for this rarity.

RARITY.Order = 6

RARITY.UpgradeChance = { -- this was added for scrolls
    ["upgrMajorSuccess"] = {val = 1},
    ["upgrMinorSuccess"] = {val = 6},

    ["upgrMajorFail"] = {val = 2},
    ["upgrMinorFail"] = {val = 2},
}
RARITY.EnhanceCost = 75000

VNP.Inventory:RegisterRarity(RARITY)
------------------------------------
--[[
    God
]]--

RARITY.Name = "God"

RARITY.Color = Color(255, 160, 100, 255)

RARITY.Scrap = 40

 -- Percentage of increase in the stats below...
RARITY.Modifiers = {
    ["Damage"] =    {min = 70, max = 80},
    ["KickUp"] =    {min = 70, max = 80},
    ["Spread"] =  {min = 70, max = 80},
    ["RPM"] =  {min = 70, max = 80},
    ["ClipSize"] =  {min = 70, max = 80},
}

RARITY.Sockets = 6 -- Number of sockets for this rarity.

RARITY.Order = 7

RARITY.UpgradeChance = { -- this was added for scrolls
    ["upgrMajorSuccess"] = {val = 1},
    ["upgrMinorSuccess"] = {val = 3},

    ["upgrMajorFail"] = {val = 2.5},
    ["upgrMinorFail"] = {val = 3},
}
RARITY.EnhanceCost = 125000

VNP.Inventory:RegisterRarity(RARITY)
------------------------------------
--[[
    Glitched
]]--

RARITY.Name = "Glitched"

RARITY.Color = "rainbow"

RARITY.Scrap = 50

 -- Percentage of increase in the stats below...
RARITY.Modifiers = {
    ["Damage"] =    {min = 80, max = 90},
    ["KickUp"] =    {min = 80, max = 90},
    ["Spread"] =  {min = 80, max = 90},
    ["RPM"] =  {min = 80, max = 90},
    ["ClipSize"] =  {min = 80, max = 90},
}

RARITY.Sockets = 7 -- Number of sockets for this rarity.

RARITY.Order = 8

RARITY.UpgradeChance = { -- this was added for scrolls
    ["upgrMajorSuccess"] = {val = 1},
    ["upgrMinorSuccess"] = {val = 1},

    ["upgrMajorFail"] = {val = 3},
    ["upgrMinorFail"] = {val = 3.5},
}
RARITY.EnhanceCost = 250000

VNP.Inventory:RegisterRarity(RARITY)
------------------------------------