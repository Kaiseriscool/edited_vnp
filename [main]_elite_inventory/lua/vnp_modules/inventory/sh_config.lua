VNP.Inventory = VNP.Inventory or {}

-- 5x12 inventory slots
VNP.Inventory.SlotsY = 5 -- Number of slots going down
VNP.Inventory.SlotsX = 12 -- Number of slots going right

VNP.Inventory.SlotSize = 70

VNP.Inventory.ItemDeletion = 120 -- Time it takes for a dropped item to delete

VNP.Inventory.Pages = { -- The config for buying pages for the inventory (increases inventory size)
    [1] = 0,
    [2] = 10000,
    [3] = 150000,
    [4] = 300000,
} 

VNP.Inventory.GemSlotUpgrades = { -- Price to socket a gem in these slots on an item
    [1] = 5000,
    [2] = 15000,
    [3] = 30000,
    [4] = 50000,
}
VNP.Inventory.GemSlotUnsocket = 120 -- 120% of the slot price to unsocket a gem
VNP.Inventory.GemSlotIncrement = 5000 -- If there isn't a value above for the specified socket it will use this increment socket number * this value

VNP.Inventory.EnergyWeapons = { -- Put classes of energy weapons here
    "weapon_gblaster",
    --"weapon_gblaster_asriel_rainbow",
    "weapon_gblaster_badtime",
    "weapon_gblaster_pistol",
    "weapon_supreme_badtime_bm_gblaster",
    "weapon_bm_rifle",
    "weapon_bm_rifle_nonadmin",
    "weapon_bm_rifle_admin",
    "weapon_ginseng_babyrailgun",
    "weapon_ginseng_beamgun",
    "weapon_ginseng_adminrailgun",
    "weapon_ginseng_railgun",
    "weapon_nrgbeam",
    "inferno_blue",
    "inferno_purple",
    "inferno",
}

VNP.Inventory.GemBlacklist = {

    ["ryry_m134"] = {
        "vnp_gem_void", "vnp_gem_double_tap"
    },

}

VNP.Inventory.WeaponWhitelist = { -- Weapons that you cant invholster normally
    "weapon_banhammer",
    "weapon_asmd",
    "riot_shield",
    "heavy_shield",
    "blue_gaster",
    "shared",
    "stungun_new",
    "weapon_ginseng_babyrailgun",
    "weapon_ginseng_beamgun",
    "weapon_ginseng_adminrailgun",
    "weapon_plasmagrenade",
    "weapon_plasmanadelauncher",
    "weapon_ginseng_railgun",
    "weapon_cuff_elastic",
    "weapon_cuff_police",
    "weapon_hpwr_stick",
    "noxious_trap",
    "weapon_mastersword",
    "weapon_camo",
    "weapon_jackhammer",
    "weapon_radar",
    "weapon_freezeray",
    "weapon_hexshield",
    "weapon_nrgbeam",
    "inferno_blue",
    "inferno_purple",
    "inferno",
    "weapon_lightsaber",
    "weapon_sh_detector",
    "weapon_sh_keypadcracker_deploy",
    "x-8",
    "broken_lockpick",
    "factory_lockpick",
    "god_lockpick",
    "rusty_lockpick",
    "staff_lockpick",
    "weapon_grapplehook",
    "weapon_thrusterpack",
    "trap_placer",
    "cp_flaregun",
    "zwf_bong01",
    "zwf_bong03",
    "zwf_bong02",
    "weapon_flechettegun",
    "deployable_shield",
    "weapon_cuff_elastic",
    "weapon_cuff_police",
    "weapon_kurome_hypersonicthunderblaster"
}

VNP.Inventory.WeaponBlacklist = {
    ["m9k_fists"] = true,
    ["weapon_fists"] = true,
}

VNP.Inventory.SpawnLocation = Vector(1014,-401,-71)
VNP.Inventory.StaffRanks = {

}

VNP.Inventory.AdminSuitUpgrader = {
    Health = 400,
    Price = 10,
}


VNP.Inventory.SuitCurve = VNP.Inventory.SuitCurve or {}
VNP.Inventory.SuitCurve.Health = {
    [1] = {min = 1 , max = 1},
    [2] = {min = 1 , max = 1.5},
    [3] = {min = 1.01 , max = 1.1},
    [4] = {min = 1 , max = 1.1},
    [5] = {min = 1 , max = 1.1},
    [6] = {min = 1.05 , max = 1.1},
    [7] = {min = 1, max = 1.1},
    [8] = {min = 1.1 , max = 1.5},
}

VNP.Inventory.SuitCurve.Armor = {
    [1] = {min = 1 , max = 1},
    [2] = {min = 1 , max = 1.5},
    [3] = {min = 1.01 , max = 1.1},
    [4] = {min = 1 , max = 1.1},
    [5] = {min = 1 , max = 1.1},
    [6] = {min = 1.05 , max = 1.1},
    [7] = {min = 1, max = 1.1},
    [8] = {min = 1.1 , max = 1.5},
}

VNP.Inventory.GemCurve = {
    --[1] = { min = 1, max = 1 }, -- 10% = {10%, 10%}, 9.5% = {9.5%, 9.5%}
    [2] = { min = 2, max = 2 }, -- 10% = {18%, 20%}, 9.5% = {17.1%, 19%}
    [3] = { min = 2, max = 2 }, -- 10% = {27%, 40%}, 9.5% = {25.65%, 38%}
    [4] = { min = 1.5, max = 1.5 }, -- 10% = {28.35%, 60%}, 9.5% = {30.08%, 57%}
    [5] = { min = 1.2, max = 1.2 }, -- 10% = {28.35, 72%}, 9.5% = {30.8%, 68.4%}
    [6] = { min = 1.1, max = 1.1 }, -- 10% = {28.35, 79.2%}, 9.5% = {30.8%, 75.6%}
    [7] = { min = 1.1, max = 1.1 }, -- 10% = {28.35, 86.1%}, 9.5% = {30.8%, 82.8%}
    [8] = { min = 1.05, max = 1.2 }, -- 10% = {28.35, 95.15%}, 9.5% = {30.8%, 89.1%}
    --[9] = { min = 1.08, max = 1.1 }, -- 10% = {28.35, 100%}, 9.5% = {30.8%, 95.4%}
}


//Math
/*
    19.25% , 20
    36.57% , 40
    50.4% , 60
    59.724 , 72
    65% , 79.2%
    70% , 86.1%
    78% , 100%
*/