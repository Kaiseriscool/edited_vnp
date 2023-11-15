VNP.Inventory.Items["SUIT"] = VNP.Inventory.Items["SUIT"] or {}

-- val does some stuff to the suits for some reason, suffixes are weird and stuff.

local SUIT = {}

function VNP.Inventory:RegisterSuit(data)
    if !data.Name then return end

    if !SUIT.Model then
        SUIT.Model = "models/Items/item_item_crate.mdl"
    end
    
    SUIT.UseFunctions = SUIT.UseFunctions or {}

    SUIT.UseFunctions["Equip"] = function(ply, item, skins)
        if !SERVER then return end
        local suit = ply:GetSuit()
        if suit then return end
        
        if ply:Crouching() then return end
        if ply.didcrouch then return end


        ply:SetSuit(item)
        
        return true
    end

    self.Items["SUIT"][data.Name] = data
    
    if SERVER then
        if data.Hooks then
            for name, func in pairs(data.Hooks) do
                hook.Add(name, "VNP.Inventory."..data.Name, func)
            end
        end
    end

    SUIT = {}
end


--[[
    Tier 1
]]--

SUIT.Name = "Tier 1"

SUIT.SuitModel = "models/auditor/r6s/rook/chr_gign_lifeline_ash_engset.mdl"

SUIT.RepairCost = 1000

SUIT.BaseModifiers = {
    ["SuitHealth"] = {val = 100},
    ["SuitArmor"] = {val = 350},
    ["SuitRegen"] = {chance = 10},
    ["SuitResist"] = {chance = 10},
    ["SuitSpeed"] = {chance = 10},
    ["SuitEnergyResist"] = {chance = 10},
    //["SuitArrestHits"] = {chance = 10},
    //["SuitJump"] = {chance = 10},
}

SUIT.Modifiers = { // the modifiers per rarity if there is no base value for a modifier it will use the below otherwise its a % multiplier
    ["Common"] = {
        ["SuitHealth"] = {min = 0, max = 100},
        ["SuitArmor"] = {min = 0, max = 100},
        ["SuitRegen"] = {min = 1, max = 2},
        ["SuitResist"] = {min = 1, max = 2},
        ["SuitSpeed"] = {min = 1, max = 7},
        //["SuitArrestHits"] = {min = 1, max = 2},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Uncommon"] = {
        ["SuitHealth"] = {min = 100, max = 125},
        ["SuitArmor"] = {min = 100, max = 125},
        ["SuitRegen"] = {min = 3, max = 4},
        ["SuitResist"] = {min = 3, max = 4},
        ["SuitSpeed"] = {min = 1, max = 7},
        //["SuitArrestHits"] = {min = 1, max = 2},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Rare"] = {
        ["SuitHealth"] = {min = 125, max = 150},
        ["SuitArmor"] = {min = 125, max = 150},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 7},
        //["SuitArrestHits"] = {min = 1, max = 2},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Epic"] = {
        ["SuitHealth"] = {min = 150, max = 175},
        ["SuitArmor"] = {min = 150, max = 175},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 7},
        //["SuitArrestHits"] = {min = 1, max = 2},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Legendary"] = {
        ["SuitHealth"] = {min = 175, max = 200},
        ["SuitArmor"] = {min = 175, max = 200},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 7},
        //["SuitArrestHits"] = {min = 1, max = 2},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Celestial"] = {
        ["SuitHealth"] = {min = 200, max = 225},
        ["SuitArmor"] = {min = 200, max = 225},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 7},
        //["SuitArrestHits"] = {min = 1, max = 2},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["God"] = {
        ["SuitHealth"] = {min = 225, max = 250},
        ["SuitArmor"] = {min = 225, max = 250},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 7},
        //["SuitArrestHits"] = {min = 1, max = 2},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Glitched"] = {
        ["SuitHealth"] = {min = 250, max = 300},
        ["SuitArmor"] = {min = 250, max = 300},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 7},
        //["SuitArrestHits"] = {min = 1, max = 2},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
}

SUIT.Hooks = {} // If ya want any hooks

VNP.Inventory:RegisterSuit(SUIT)

--[[
    Tier 2
]]--

SUIT.Name = "Tier 2"

SUIT.SuitModel = "models/arachnit/csgoheavyphoenix/tm_phoenix_heavyplayer.mdl"

SUIT.RepairCost = 1000

SUIT.BaseModifiers = {
    ["SuitHealth"] = {val = 500},
    ["SuitArmor"] = {val = 250},
    ["SuitRegen"] = {chance = 10},
    ["SuitResist"] = {chance = 10},
    ["SuitSpeed"] = { chance = 10},
    ["SuitEnergyResist"] = {chance = 10},
    //["SuitArrestHits"] = {chance = 10},
    //["SuitJump"] = {chance = 10},
}

SUIT.Modifiers = { // the modifiers per rarity if there is no base value for a modifier it will use the below otherwise its a % multiplier
    ["Common"] = {
        ["SuitHealth"] = {min = 0, max = 100},
        ["SuitArmor"] = {min = 0, max = 100},
        ["SuitRegen"] = {min = 1, max = 2},
        ["SuitResist"] = {min = 1, max = 2},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Uncommon"] = {
        ["SuitHealth"] = {min = 100, max = 125},
        ["SuitArmor"] = {min = 100, max = 125},
        ["SuitRegen"] = {min = 3, max = 4},
        ["SuitResist"] = {min = 3, max = 4},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Rare"] = {
        ["SuitHealth"] = {min = 125, max = 150},
        ["SuitArmor"] = {min = 125, max = 150},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Epic"] = {
        ["SuitHealth"] = {min = 150, max = 175},
        ["SuitArmor"] = {min = 150, max = 175},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Legendary"] = {
        ["SuitHealth"] = {min = 175, max = 200},
        ["SuitArmor"] = {min = 175, max = 200},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Celestial"] = {
        ["SuitHealth"] = {min = 200, max = 225},
        ["SuitArmor"] = {min = 200, max = 225},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["God"] = {
        ["SuitHealth"] = {min = 225, max = 250},
        ["SuitArmor"] = {min = 225, max = 250},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Glitched"] = {
        ["SuitHealth"] = {min = 250, max = 300},
        ["SuitArmor"] = {min = 250, max = 300},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
}

SUIT.Hooks = {} // If ya want any hooks

VNP.Inventory:RegisterSuit(SUIT)

--[[
    Tier 3
]]--

SUIT.Name = "Tier 3"

SUIT.SuitModel = "models/kryptonite/inf_war_machine/inf_war_machine.mdl"

SUIT.RepairCost = 1000

SUIT.BaseModifiers = {
    ["SuitHealth"] = {val = 800},
    ["SuitArmor"] = {val = 250},
    ["SuitRegen"] = {chance = 10},
    ["SuitResist"] = {chance = 10},
    ["SuitSpeed"] = { chance = 100},
    ["SuitEnergyResist"] = {chance = 10},
    //["SuitArrestHits"] = {chance = 10},
    //["SuitJump"] = {chance = 10},
}

SUIT.Modifiers = { // the modifiers per rarity if there is no base value for a modifier it will use the below otherwise its a % multiplier
    ["Common"] = {
        ["SuitHealth"] = {min = 0, max = 100},
        ["SuitArmor"] = {min = 0, max = 100},
        ["SuitRegen"] = {min = 1, max = 2},
        ["SuitResist"] = {min = 1, max = 2},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Uncommon"] = {
        ["SuitHealth"] = {min = 100, max = 125},
        ["SuitArmor"] = {min = 100, max = 125},
        ["SuitRegen"] = {min = 3, max = 4},
        ["SuitResist"] = {min = 3, max = 4},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Rare"] = {
        ["SuitHealth"] = {min = 125, max = 150},
        ["SuitArmor"] = {min = 125, max = 150},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Epic"] = {
        ["SuitHealth"] = {min = 150, max = 175},
        ["SuitArmor"] = {min = 150, max = 175},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Legendary"] = {
        ["SuitHealth"] = {min = 175, max = 200},
        ["SuitArmor"] = {min = 175, max = 200},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Celestial"] = {
        ["SuitHealth"] = {min = 200, max = 225},
        ["SuitArmor"] = {min = 200, max = 225},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["God"] = {
        ["SuitHealth"] = {min = 225, max = 250},
        ["SuitArmor"] = {min = 225, max = 250},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Glitched"] = {
        ["SuitHealth"] = {min = 250, max = 300},
        ["SuitArmor"] = {min = 250, max = 300},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
}

SUIT.Hooks = {} // If ya want any hooks

VNP.Inventory:RegisterSuit(SUIT)

--[[
    Tier 4
]]--

SUIT.Name = "Tier 4"

SUIT.SuitModel = "models/models/frix/x01/xo1_powerarmor.mdl"

SUIT.RepairCost = 1000

SUIT.BaseModifiers = {
    ["SuitHealth"] = {val = 1000},
    ["SuitArmor"] = {val = 250},
    ["SuitRegen"] = {chance = 10},
    ["SuitResist"] = {chance = 10},
    ["SuitSpeed"] = {chance = 10},
    ["SuitEnergyResist"] = {chance = 10},
    //["SuitArrestHits"] = {chance = 10},
    //["SuitJump"] = {chance = 10},
}

SUIT.Modifiers = { // the modifiers per rarity if there is no base value for a modifier it will use the below otherwise its a % multiplier
    ["Common"] = {
        ["SuitHealth"] = {min = 0, max = 100},
        ["SuitArmor"] = {min = 0, max = 100},
        ["SuitRegen"] = {min = 1, max = 2},
        ["SuitResist"] = {min = 1, max = 2},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Uncommon"] = {
        ["SuitHealth"] = {min = 100, max = 125},
        ["SuitArmor"] = {min = 100, max = 125},
        ["SuitRegen"] = {min = 3, max = 4},
        ["SuitResist"] = {min = 3, max = 4},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Rare"] = {
        ["SuitHealth"] = {min = 125, max = 150},
        ["SuitArmor"] = {min = 125, max = 150},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Epic"] = {
        ["SuitHealth"] = {min = 150, max = 175},
        ["SuitArmor"] = {min = 150, max = 175},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Legendary"] = {
        ["SuitHealth"] = {min = 175, max = 200},
        ["SuitArmor"] = {min = 175, max = 200},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Celestial"] = {
        ["SuitHealth"] = {min = 200, max = 225},
        ["SuitArmor"] = {min = 200, max = 225},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["God"] = {
        ["SuitHealth"] = {min = 225, max = 250},
        ["SuitArmor"] = {min = 225, max = 250},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Glitched"] = {
        ["SuitHealth"] = {min = 250, max = 300},
        ["SuitArmor"] = {min = 250, max = 300},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
}

SUIT.Hooks = {} // If ya want any hooks

VNP.Inventory:RegisterSuit(SUIT)

--[[
    Tier 5
]]--

SUIT.Name = "Tier 5"

SUIT.SuitModel = "models/mailer/characters/blackknight.mdl"

SUIT.RepairCost = 1000

SUIT.BaseModifiers = {
    ["SuitHealth"] = {val = 3000},
    ["SuitArmor"] = {val = 250},
    ["SuitRegen"] = {chance = 10},
    ["SuitResist"] = {chance = 10},
    ["SuitSpeed"] = { chance = 10},
    ["SuitEnergyResist"] = {chance = 10},
    //["SuitArrestHits"] = {chance = 10},
    //["SuitJump"] = {chance = 10},
}

SUIT.Modifiers = { // the modifiers per rarity if there is no base value for a modifier it will use the below otherwise its a % multiplier
    ["Common"] = {
        ["SuitHealth"] = {min = 0, max = 100},
        ["SuitArmor"] = {min = 0, max = 100},
        ["SuitRegen"] = {min = 1, max = 2},
        ["SuitResist"] = {min = 1, max = 2},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Uncommon"] = {
        ["SuitHealth"] = {min = 100, max = 125},
        ["SuitArmor"] = {min = 100, max = 125},
        ["SuitRegen"] = {min = 3, max = 4},
        ["SuitResist"] = {min = 3, max = 4},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Rare"] = {
        ["SuitHealth"] = {min = 125, max = 150},
        ["SuitArmor"] = {min = 125, max = 150},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Epic"] = {
        ["SuitHealth"] = {min = 150, max = 175},
        ["SuitArmor"] = {min = 150, max = 175},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Legendary"] = {
        ["SuitHealth"] = {min = 175, max = 200},
        ["SuitArmor"] = {min = 175, max = 200},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Celestial"] = {
        ["SuitHealth"] = {min = 200, max = 225},
        ["SuitArmor"] = {min = 200, max = 225},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["God"] = {
        ["SuitHealth"] = {min = 225, max = 250},
        ["SuitArmor"] = {min = 225, max = 250},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Glitched"] = {
        ["SuitHealth"] = {min = 250, max = 300},
        ["SuitArmor"] = {min = 250, max = 300},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
}

SUIT.Hooks = {} // If ya want any hooks

VNP.Inventory:RegisterSuit(SUIT)

--[[
    Horror Suit
]]--

SUIT.Name = "Horror Suit"

SUIT.SuitModel = "models/splinks/jeff_the_killer/jeff.mdl"

SUIT.RepairCost = 1000

SUIT.BaseModifiers = {
    ["SuitHealth"] = {val = 100},
    ["SuitArmor"] = {val = 250},
    ["SuitRegen"] = {chance = 10},
    ["SuitResist"] = {chance = 10},
    ["SuitSpeed"] = { chance = 10},
    ["SuitEnergyResist"] = {chance = 10},
    //["SuitArrestHits"] = {chance = 10},
    //["SuitJump"] = {chance = 10},
}

SUIT.Modifiers = { // the modifiers per rarity if there is no base value for a modifier it will use the below otherwise its a % multiplier
    ["Common"] = {
        ["SuitHealth"] = {min = 0, max = 100},
        ["SuitArmor"] = {min = 0, max = 100},
        ["SuitRegen"] = {min = 1, max = 2},
        ["SuitResist"] = {min = 1, max = 2},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Uncommon"] = {
        ["SuitHealth"] = {min = 100, max = 125},
        ["SuitArmor"] = {min = 100, max = 125},
        ["SuitRegen"] = {min = 3, max = 4},
        ["SuitResist"] = {min = 3, max = 4},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Rare"] = {
        ["SuitHealth"] = {min = 125, max = 150},
        ["SuitArmor"] = {min = 125, max = 150},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Epic"] = {
        ["SuitHealth"] = {min = 150, max = 175},
        ["SuitArmor"] = {min = 150, max = 175},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Legendary"] = {
        ["SuitHealth"] = {min = 175, max = 200},
        ["SuitArmor"] = {min = 175, max = 200},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Celestial"] = {
        ["SuitHealth"] = {min = 200, max = 225},
        ["SuitArmor"] = {min = 200, max = 225},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["God"] = {
        ["SuitHealth"] = {min = 225, max = 250},
        ["SuitArmor"] = {min = 225, max = 250},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Glitched"] = {
        ["SuitHealth"] = {min = 250, max = 300},
        ["SuitArmor"] = {min = 250, max = 300},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
}

SUIT.Hooks = {} // If ya want any hooks

VNP.Inventory:RegisterSuit(SUIT)

--[[
    Horror Suit Tier 2
]]--

SUIT.Name = "Horror Suit Tier 2"

SUIT.SuitModel = "models/player/scp096.mdl"

SUIT.RepairCost = 1000

SUIT.BaseModifiers = {
    ["SuitHealth"] = {val = 500},
    ["SuitArmor"] = {val = 250},
    ["SuitRegen"] = {chance = 10},
    ["SuitResist"] = {chance = 10},
    ["SuitSpeed"] = {chance = 100},
    ["SuitEnergyResist"] = {chance = 10},
    //["SuitArrestHits"] = {chance = 10},
    //["SuitJump"] = {chance = 10},
}

SUIT.Modifiers = { // the modifiers per rarity if there is no base value for a modifier it will use the below otherwise its a % multiplier
    ["Common"] = {
        ["SuitHealth"] = {min = 0, max = 100},
        ["SuitArmor"] = {min = 0, max = 100},
        ["SuitRegen"] = {min = 1, max = 2},
        ["SuitResist"] = {min = 1, max = 2},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Uncommon"] = {
        ["SuitHealth"] = {min = 100, max = 125},
        ["SuitArmor"] = {min = 100, max = 125},
        ["SuitRegen"] = {min = 3, max = 4},
        ["SuitResist"] = {min = 3, max = 4},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Rare"] = {
        ["SuitHealth"] = {min = 125, max = 150},
        ["SuitArmor"] = {min = 125, max = 150},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Epic"] = {
        ["SuitHealth"] = {min = 150, max = 175},
        ["SuitArmor"] = {min = 150, max = 175},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Legendary"] = {
        ["SuitHealth"] = {min = 175, max = 200},
        ["SuitArmor"] = {min = 175, max = 200},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Celestial"] = {
        ["SuitHealth"] = {min = 200, max = 225},
        ["SuitArmor"] = {min = 200, max = 225},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["God"] = {
        ["SuitHealth"] = {min = 225, max = 250},
        ["SuitArmor"] = {min = 225, max = 250},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Glitched"] = {
        ["SuitHealth"] = {min = 250, max = 300},
        ["SuitArmor"] = {min = 250, max = 300},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
}

SUIT.Hooks = {} // If ya want any hooks

VNP.Inventory:RegisterSuit(SUIT)

--[[
    Horror Suit Tier 3
]]--

SUIT.Name = "Horror Suit Tier 3"

SUIT.SuitModel = "models/siren_head_player_jq1991.mdl"

SUIT.RepairCost = 1000

SUIT.BaseModifiers = {
    ["SuitHealth"] = {val = 100},
    ["SuitArmor"] = {val = 350},
    ["SuitRegen"] = {chance = 10},
    ["SuitResist"] = {chance = 10},
    ["SuitSpeed"] = { chance = 10},
    ["SuitEnergyResist"] = {chance = 10},
    //["SuitArrestHits"] = {chance = 10},
    //["SuitJump"] = {chance = 10},
}

SUIT.Modifiers = { // the modifiers per rarity if there is no base value for a modifier it will use the below otherwise its a % multiplier
    ["Common"] = {
        ["SuitHealth"] = {min = 0, max = 100},
        ["SuitArmor"] = {min = 0, max = 100},
        ["SuitRegen"] = {min = 1, max = 2},
        ["SuitResist"] = {min = 1, max = 2},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Uncommon"] = {
        ["SuitHealth"] = {min = 100, max = 125},
        ["SuitArmor"] = {min = 100, max = 125},
        ["SuitRegen"] = {min = 3, max = 4},
        ["SuitResist"] = {min = 3, max = 4},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Rare"] = {
        ["SuitHealth"] = {min = 125, max = 150},
        ["SuitArmor"] = {min = 125, max = 150},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Epic"] = {
        ["SuitHealth"] = {min = 150, max = 175},
        ["SuitArmor"] = {min = 150, max = 175},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Legendary"] = {
        ["SuitHealth"] = {min = 175, max = 200},
        ["SuitArmor"] = {min = 175, max = 200},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Celestial"] = {
        ["SuitHealth"] = {min = 200, max = 225},
        ["SuitArmor"] = {min = 200, max = 225},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["God"] = {
        ["SuitHealth"] = {min = 225, max = 250},
        ["SuitArmor"] = {min = 225, max = 250},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Glitched"] = {
        ["SuitHealth"] = {min = 250, max = 300},
        ["SuitArmor"] = {min = 250, max = 300},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
}

SUIT.Hooks = {} // If ya want any hooks

VNP.Inventory:RegisterSuit(SUIT)

--[[
    Tier God
]]--

SUIT.Name = "Tier God"

SUIT.SuitModel = "models/kryptonite/inf_thanos/inf_thanos.mdl"

SUIT.RepairCost = 1000

SUIT.BaseModifiers = {
    ["SuitHealth"] = {val = 10000},
    ["SuitArmor"] = {val = 450},
    ["SuitRegen"] = {chance = 10},
    ["SuitResist"] = {chance = 10},
    ["SuitSpeed"] = { chance = 10},
    ["SuitEnergyResist"] = {chance = 10},
    //["SuitArrestHits"] = {chance = 10},
    //["SuitJump"] = {chance = 10},
}

SUIT.Modifiers = { // the modifiers per rarity if there is no base value for a modifier it will use the below otherwise its a % multiplier
    ["Common"] = {
        ["SuitHealth"] = {min = 0, max = 100},
        ["SuitArmor"] = {min = 0, max = 100},
        ["SuitRegen"] = {min = 1, max = 2},
        ["SuitResist"] = {min = 1, max = 2},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Uncommon"] = {
        ["SuitHealth"] = {min = 100, max = 125},
        ["SuitArmor"] = {min = 100, max = 125},
        ["SuitRegen"] = {min = 3, max = 4},
        ["SuitResist"] = {min = 3, max = 4},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Rare"] = {
        ["SuitHealth"] = {min = 125, max = 150},
        ["SuitArmor"] = {min = 125, max = 150},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Epic"] = {
        ["SuitHealth"] = {min = 150, max = 175},
        ["SuitArmor"] = {min = 150, max = 175},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Legendary"] = {
        ["SuitHealth"] = {min = 175, max = 200},
        ["SuitArmor"] = {min = 175, max = 200},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Celestial"] = {
        ["SuitHealth"] = {min = 200, max = 225},
        ["SuitArmor"] = {min = 200, max = 225},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["God"] = {
        ["SuitHealth"] = {min = 225, max = 250},
        ["SuitArmor"] = {min = 225, max = 250},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Glitched"] = {
        ["SuitHealth"] = {min = 250, max = 300},
        ["SuitArmor"] = {min = 250, max = 300},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
}

SUIT.Hooks = {} // If ya want any hooks

VNP.Inventory:RegisterSuit(SUIT)

--[[
    Tier Ultra God
]]--

SUIT.Name = "Tier Ultra God"

SUIT.SuitModel = "models/epangelmatikes/mtu/mtultimate.mdl"

SUIT.RepairCost = 1000

SUIT.BaseModifiers = {
    ["SuitHealth"] = {val = 25000},
    ["SuitArmor"] = {val = 1000},
    ["SuitRegen"] = {chance = 10},
    ["SuitResist"] = {chance = 10},
    ["SuitSpeed"] = { chance = 10},
    ["SuitEnergyResist"] = {chance = 10},
    //["SuitArrestHits"] = {chance = 10},
    //["SuitJump"] = {chance = 10},
}

SUIT.Modifiers = { // the modifiers per rarity if there is no base value for a modifier it will use the below otherwise its a % multiplier
    ["Common"] = {
        ["SuitHealth"] = {min = 0, max = 100},
        ["SuitArmor"] = {min = 0, max = 100},
        ["SuitRegen"] = {min = 1, max = 2},
        ["SuitResist"] = {min = 1, max = 2},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Uncommon"] = {
        ["SuitHealth"] = {min = 100, max = 125},
        ["SuitArmor"] = {min = 100, max = 125},
        ["SuitRegen"] = {min = 3, max = 4},
        ["SuitResist"] = {min = 3, max = 4},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Rare"] = {
        ["SuitHealth"] = {min = 125, max = 150},
        ["SuitArmor"] = {min = 125, max = 150},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Epic"] = {
        ["SuitHealth"] = {min = 150, max = 175},
        ["SuitArmor"] = {min = 150, max = 175},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Legendary"] = {
        ["SuitHealth"] = {min = 175, max = 200},
        ["SuitArmor"] = {min = 175, max = 200},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Celestial"] = {
        ["SuitHealth"] = {min = 200, max = 225},
        ["SuitArmor"] = {min = 200, max = 225},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["God"] = {
        ["SuitHealth"] = {min = 225, max = 250},
        ["SuitArmor"] = {min = 225, max = 250},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Glitched"] = {
        ["SuitHealth"] = {min = 250, max = 300},
        ["SuitArmor"] = {min = 250, max = 300},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
}

SUIT.Hooks = {} // If ya want any hooks

VNP.Inventory:RegisterSuit(SUIT)

--[[
    Tier Fallen God
]]--

SUIT.Name = "Tier Fallen God"

SUIT.SuitModel = "models/mailer/characters/cordana.mdl"

SUIT.RepairCost = 1000

SUIT.BaseModifiers = {
    ["SuitHealth"] = {val = 35000},
    ["SuitArmor"] = {val = 1000},
    ["SuitRegen"] = {chance = 10},
    ["SuitResist"] = {chance = 10},
    ["SuitSpeed"] = { chance = 10},
    ["SuitEnergyResist"] = {chance = 10},
    //["SuitArrestHits"] = {chance = 10},
    //["SuitJump"] = {chance = 10},
}

SUIT.Modifiers = { // the modifiers per rarity if there is no base value for a modifier it will use the below otherwise its a % multiplier
    ["Common"] = {
        ["SuitHealth"] = {min = 0, max = 100},
        ["SuitArmor"] = {min = 0, max = 100},
        ["SuitRegen"] = {min = 1, max = 2},
        ["SuitResist"] = {min = 1, max = 2},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Uncommon"] = {
        ["SuitHealth"] = {min = 100, max = 125},
        ["SuitArmor"] = {min = 100, max = 125},
        ["SuitRegen"] = {min = 3, max = 4},
        ["SuitResist"] = {min = 3, max = 4},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Rare"] = {
        ["SuitHealth"] = {min = 125, max = 150},
        ["SuitArmor"] = {min = 125, max = 150},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Epic"] = {
        ["SuitHealth"] = {min = 150, max = 175},
        ["SuitArmor"] = {min = 150, max = 175},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Legendary"] = {
        ["SuitHealth"] = {min = 175, max = 200},
        ["SuitArmor"] = {min = 175, max = 200},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Celestial"] = {
        ["SuitHealth"] = {min = 200, max = 225},
        ["SuitArmor"] = {min = 200, max = 225},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["God"] = {
        ["SuitHealth"] = {min = 225, max = 250},
        ["SuitArmor"] = {min = 225, max = 250},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Glitched"] = {
        ["SuitHealth"] = {min = 250, max = 300},
        ["SuitArmor"] = {min = 250, max = 300},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
}

SUIT.Hooks = {} // If ya want any hooks

VNP.Inventory:RegisterSuit(SUIT)

--[[
    Tier God Slayer
]]--

SUIT.Name = "Tier God Slayer"

SUIT.SuitModel = "models/reverse/ironman_endgame/ironman_endgame.mdl"

SUIT.RepairCost = 1000

SUIT.BaseModifiers = {
    ["SuitHealth"] = {val = 45000},
    ["SuitArmor"] = {val = 1000},
    ["SuitRegen"] = {chance = 10},
    ["SuitResist"] = {chance = 10},
    ["SuitSpeed"] = { chance = 10},
    ["SuitEnergyResist"] = {chance = 10},
    //["SuitArrestHits"] = {chance = 10},
    //["SuitJump"] = {chance = 10},
}

SUIT.Modifiers = { // the modifiers per rarity if there is no base value for a modifier it will use the below otherwise its a % multiplier
    ["Common"] = {
        ["SuitHealth"] = {min = 0, max = 100},
        ["SuitArmor"] = {min = 0, max = 100},
        ["SuitRegen"] = {min = 1, max = 2},
        ["SuitResist"] = {min = 1, max = 2},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Uncommon"] = {
        ["SuitHealth"] = {min = 100, max = 125},
        ["SuitArmor"] = {min = 100, max = 125},
        ["SuitRegen"] = {min = 3, max = 4},
        ["SuitResist"] = {min = 3, max = 4},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Rare"] = {
        ["SuitHealth"] = {min = 125, max = 150},
        ["SuitArmor"] = {min = 125, max = 150},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Epic"] = {
        ["SuitHealth"] = {min = 150, max = 175},
        ["SuitArmor"] = {min = 150, max = 175},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Legendary"] = {
        ["SuitHealth"] = {min = 175, max = 200},
        ["SuitArmor"] = {min = 175, max = 200},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Celestial"] = {
        ["SuitHealth"] = {min = 200, max = 225},
        ["SuitArmor"] = {min = 200, max = 225},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["God"] = {
        ["SuitHealth"] = {min = 225, max = 250},
        ["SuitArmor"] = {min = 225, max = 250},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Glitched"] = {
        ["SuitHealth"] = {min = 250, max = 300},
        ["SuitArmor"] = {min = 250, max = 300},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
}

SUIT.Hooks = {} // If ya want any hooks

VNP.Inventory:RegisterSuit(SUIT)

--[[
    Flash Suit
]]--

SUIT.Name = "Flash Suit"

SUIT.SuitModel = "models/reverse/playermodels/futureflash/futureflash.mdl"

SUIT.RepairCost = 1000

SUIT.BaseModifiers = {
    ["SuitHealth"] = {val = 200},
    ["SuitArmor"] = {val = 100},
    ["SuitRegen"] = {chance = 10},
    ["SuitResist"] = {chance = 10},
    ["SuitSpeed"] = {chance = 100},
    ["SuitEnergyResist"] = {chance = 10},
    //["SuitArrestHits"] = {chance = 10},
    //["SuitJump"] = {chance = 10},
}

SUIT.Modifiers = { // the modifiers per rarity if there is no base value for a modifier it will use the below otherwise its a % multiplier
    ["Common"] = {
        ["SuitHealth"] = {min = 0, max = 100},
        ["SuitArmor"] = {min = 0, max = 100},
        ["SuitRegen"] = {min = 1, max = 2},
        ["SuitResist"] = {min = 1, max = 2},
        ["SuitSpeed"] = {min = 1, max = 7},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Uncommon"] = {
        ["SuitHealth"] = {min = 100, max = 125},
        ["SuitArmor"] = {min = 100, max = 125},
        ["SuitRegen"] = {min = 3, max = 4},
        ["SuitResist"] = {min = 3, max = 4},
        ["SuitSpeed"] = {min = 1, max = 7},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Rare"] = {
        ["SuitHealth"] = {min = 125, max = 150},
        ["SuitArmor"] = {min = 125, max = 150},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 7},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Epic"] = {
        ["SuitHealth"] = {min = 150, max = 175},
        ["SuitArmor"] = {min = 150, max = 175},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 7},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Legendary"] = {
        ["SuitHealth"] = {min = 175, max = 200},
        ["SuitArmor"] = {min = 175, max = 200},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 7},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Celestial"] = {
        ["SuitHealth"] = {min = 200, max = 225},
        ["SuitArmor"] = {min = 200, max = 225},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 7},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["God"] = {
        ["SuitHealth"] = {min = 225, max = 250},
        ["SuitArmor"] = {min = 225, max = 250},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 7},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Glitched"] = {
        ["SuitHealth"] = {min = 250, max = 300},
        ["SuitArmor"] = {min = 250, max = 300},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 7},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
}

SUIT.Hooks = {} // If ya want any hooks

VNP.Inventory:RegisterSuit(SUIT)

--[[
    Admin Suit
]]--

SUIT.Name = "Admin Suit"

SUIT.SuitModel = "models/player/Combine_Super_Soldier.mdl"

SUIT.RepairCost = 1000

SUIT.BaseModifiers = {
    ["SuitHealth"] = {val = 10200},
    ["SuitArmor"] = {val = 1000},
    ["SuitRegen"] = {chance = 10},
    ["SuitResist"] = {chance = 10},
    ["SuitSpeed"] = {chance = 10},
    ["SuitEnergyResist"] = {chance = 10},
    //["SuitArrestHits"] = {chance = 10},
    //["SuitJump"] = {chance = 10},
}

SUIT.Modifiers = { // the modifiers per rarity if there is no base value for a modifier it will use the below otherwise its a % multiplier
    ["Common"] = {
        ["SuitHealth"] = {min = 0, max = 100},
        ["SuitArmor"] = {min = 0, max = 100},
        ["SuitRegen"] = {min = 1, max = 2},
        ["SuitResist"] = {min = 1, max = 2},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Uncommon"] = {
        ["SuitHealth"] = {min = 100, max = 125},
        ["SuitArmor"] = {min = 100, max = 125},
        ["SuitRegen"] = {min = 3, max = 4},
        ["SuitResist"] = {min = 3, max = 4},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Rare"] = {
        ["SuitHealth"] = {min = 125, max = 150},
        ["SuitArmor"] = {min = 125, max = 150},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Epic"] = {
        ["SuitHealth"] = {min = 150, max = 175},
        ["SuitArmor"] = {min = 150, max = 175},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Legendary"] = {
        ["SuitHealth"] = {min = 175, max = 200},
        ["SuitArmor"] = {min = 175, max = 200},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Celestial"] = {
        ["SuitHealth"] = {min = 200, max = 225},
        ["SuitArmor"] = {min = 200, max = 225},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["God"] = {
        ["SuitHealth"] = {min = 225, max = 250},
        ["SuitArmor"] = {min = 225, max = 250},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Glitched"] = {
        ["SuitHealth"] = {min = 250, max = 300},
        ["SuitArmor"] = {min = 250, max = 300},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
}

SUIT.Resistances = { -- Damage types and weapons this weapon is resistant to
    [DMG_FALL] = 0, -- resistant amount in %

    ["awpdragon"] = 55,

    ["amr11"] = 55, -- just here so it balances out
    
    ["ryry_m134"] = 55,
    
    ["weapon_glock2"] = 55,
    
    ["ls_sniper"] = 55,
    
    ["m9k_usas"] = 55,
    
    ["m9k_m60"] = 55,

    ["weapon_gblaster_badtime"] = 0, // only energy weapon to kill the admin suit

    ["weapon_gblaster_onehit"] = 100,

    ["weapon_gblaster"] = 100,
 
	["weapon_gblaster_badtime_tokyo"] = 100,

	["weapon_gblaster_aqua"] = 100,

	["weapon_gblaster_badtime_orange"] = 100,

	["weapon_gblaster_badtime_bp1"] = 100,

	["weapon_gblaster_asriel_rainbow_onehit"] = 100,

	["weapon_gblaster_asriel_rainbow"] = 100,
	
	["weapon_supreme_badtime_bm_gblaster"] = 100,

	["weapon_gblaster_badtime_onehit"] = 0,

	["weapon_gblaster_pistol"] = 100,

	["weapon_gblaster_badtime_glitched"] = 100,

	["weapon_gblaster_badtime_green"] = 100,

	["weapon_bm_ams"] = 100,

	["weapon_gblaster_badtime_pink"] = 100,

	["weapon_gblaster_badtime_platinum"] = 100,

	["weapon_purple_supreme_badtime_bm_gblaster"] = 100,

	["weapon_supreme_badtime_bm_gblaster_onehit"] = 100,

	["weapon_bm_rifle"] = 100,

	["weapon_bm_rifle_nonadmin"] = 100,

	["weapon_bm_rifle_admin"] = 100,

	["weapon_supremelaser_badtime_bm_gblaster"] = 100,

	["weapon_gold_badtime_bm_gblaster"] = 100,

	["weapon_purple_badtime_gblaster"] = 100,

	["weapon_bms_gluon"] = 100,

	["weapon_dababy_gaster"] = 100,

	["weapon_gblaster_gravy"] = 100,

	["weapon_gblaster_nation"] = 100,

	["weapon_gblaster_sun"] = 100,

	["weapon_gblaster_badtime_shark"] = 100,

	["weapon_gblaster_badtime_batt"] = 100,

	["weapon_gblaster_badtime_cop"] = 100,

	["weapon_gblaster_badtime_fortnite"] = 100,

	["weapon_gblaster_badtime_fgood"] = 100,

	["weapon_gblaster_badtime_customone"] = 100,

	["weapon_gblaster_badtime_floid"] = 100,

	["weapon_gblaster_badtime_hed"] = 100,
	
	["weapon_gblaster_badtime_gey"] = 100,
	
	["weapon_gblaster_badtime_hom"] = 100,
	
	["weapon_gblaster_badtime_phub"] = 100,
	
	["weapon_gblaster_badtime_kiss"] = 100,

	["weapon_gblaster_badtime_anishit"] = 100,
	
	["weapon_gblaster_badtime_oero"] = 100,
	
	["weapon_gblaster_badtime_party"] = 100,
	
	["weapon_gblaster_badtime_pepsi"] = 100,
	
	["weapon_gblaster_badtime_danger"] = 100,
	
	["weapon_gblaster_badtime_akemi"] = 100,
	
	["weapon_gblaster_badtime_web"] = 100,
	
	["weapon_zilla_gaster"] = 100,
	
	["weapon_gblaster_badtime_zero"] = 100,
	
	["weapon_green_gaster"] = 100,

	["weapon_gblaster_orange"] = 100,
	
	["weapon_pink_gaster"] = 100,
	
	["weapon_sugarcrash"] = 100,
	
	["weapon_travisscottburger"] = 100,
	
	["weapon_wumbo"] = 100,

	["weapon_reaper_gaster"] = 100,
	
	["weapon_nightmare_gaster"] = 100,
	
	["weapon_black_gaster"] = 100,
	
	["weapon_nyan"] = 100,
	
	["weapon_halloweengaster"] = 100,

	["weapon_amongussus"] = 100,
	
	["weapon_supreme_dl"] = 100,
	
	["weapon_nrgbeam"] = 100,
	
	["weapon_masterspark_gluon"] = 100,

	["weapon_bm_qe_zapper"] = 100,

	["weapon_woofer_cannon"] = 100,

	["weapon_bm_aimbot"] = 100,
	
	["weapon_nrgbeam_admin	"] = 100,

	["weapon_unoreverse"] = 100,
	
	["weapon_gblaster_badtime_goat"] = 100,
	
	["weapon_gblaster_badtime_godly"] = 100,
	
	["weapon_gblaster_badtime_gopnik"] = 100,
	
	["weapon_gblaster_badtime_laststand"] = 100,

	["weapon_gblaster_badtime_horizon"] = 100,
	
	["weapon_gblaster_badtime_horror"] = 100,
	
	["weapon_gblaster_badtime_hunter"] = 100,
	
	["weapon_gblaster_badtime_killer"] = 100,
	
	["weapon_supreme_badtime_revenge"] = 100,

	["weapon_gblaster_badtime_madtime"] = 100,
	
	["weapon_gblaster_badtime_murder"] = 100,
	
	["weapon_gblaster_badtime_pin"] = 100,
	
	["weapon_gblaster_badtime_rainbownightmare"] = 100,
	
	["weapon_gblaster_badtime_ret"] = 100,

	["weapon_gblaster_badtime_revenge"] = 100,
	
	["weapon_gblaster_badtime_hardmode"] = 100,
	
	["weapon_gblaster_badtime_titanium"] = 100,
	
	["weapon_gblaster_badtime_crimson"] = 100,
	
	["weapon_gblaster_badtime_ultra"] = 100,

	["weapon_gblaster_xmas"] = 100,

	["weapon_nrgbeam_admin"] = 100,
	
	["weapon_gblaster_badtime_bp2cc"] = 100,

	["weapon_gblaster_badtime_bp2dd"] = 100,

	["weapon_gblaster_badtime_bp2ff"] = 100,

	["weapon_gblaster_badtime_bp2aa"] = 100,

	["weapon_gblaster_badtime_bp2ee"] = 100,

	["weapon_gblaster_badtime_bp2bb"] = 100,

	["weapon_vaporizer_hardcore"] = 100,

	["weapon_zero_dissolver_penetrator"] = 100,

	["weapon_greenheartray"] = 100,

	["weapon_dissolver_rifle"] = 100,

	["weapon_blacksisterblaster"] = 100,

	["weapon_darkness_blaster"] = 100,

	["weapon_gblaster_badtime_stewie"] = 100,

	["weapon_gblaster_badtime_boombastic"] = 100,

	["weapon_gblaster_badtime_bust"] = 100,

	["weapon_gblaster_badtime_covid"] = 100,

	["weapon_gblaster_badtime_cell"] = 100,

	["weapon_gblaster_badtime_death"] = 100,

	["weapon_gblaster_badtime_tunsumi"] = 100,

	["weapon_gblaster_badtime_tap"] = 100,

	["weapon_gblaster_badtime_emotion"] = 100,

	["weapon_gblaster_badtime_fall"] = 100,

	["weapon_gblaster_badtime_bitchboy"] = 100,

	["weapon_gblaster_badtime_gator"] = 100,

	["weapon_gblaster_badtime_ghoul"] = 100,

	["weapon_gblaster_badtime_soon"] = 100,

	["weapon_gblaster_badtime_goose"] = 100,

	["weapon_gblaster_badtime_gurenge"] = 100,

	["weapon_gblaster_badtime_heart"] = 100,

	["weapon_gblaster_badtime_drain"] = 100,

	["weapon_gblaster_badtime_japan"] = 100,

	["weapon_gblaster_badtime_kingly"] = 100,

	["weapon_gblaster_badtime_meow"] = 100,

	["weapon_gblaster_badtime_moon"] = 100,

	["weapon_gblaster_badtime_manners"] = 100,

	["weapon_gblaster_badtime_memphis"] = 100,

	["weapon_gblaster_badtime_shimmy"] = 100,

	["weapon_gblaster_badtime_sos"] = 100,

	["weapon_gblaster_badtime_squishy"] = 100,

	["weapon_gblaster_badtime_stoppa"] = 100,

	["weapon_gblaster_badtime_sussy"] = 100,

	["weapon_gblaster_badtime_odd"] = 100,

	["weapon_gblaster_lightning"] = 100,

	["weapon_gblaster_badtime_lweo"] = 100,

	["weapon_shockgaster"] = 100,

	["weapon_animegaster"] = 100,

	["weapon_banjogaster"] = 100,

	["weapon_berserkergaster"] = 100,

	["weapon_dealergaster"] = 100,

	["weapon_deathgblaster"] = 100,

	["weapon_demongaster"] = 100,

	["weapon_diamondgaster"] = 100,

	["weapon_discordgaster"] = 100,

	["weapon_supreme_fucktheworld_gblaster"] = 100,

	["weapon_goatgaster"] = 100,

	["weapon_godgaster"] = 100,
	
	["weapon_maskoff"] = 100,

	["weapon_oreogaster"] = 100,

	["weapon_supreme_loading"] = 100,

	["weapon_spygaster"] = 100,

	["weapon_weebgaster"] = 100,

	["weapon_hid"] = 100,

    ["weapon_gblaster_judgement_chaingun"] = 90,

    ["weapon_gblaster_gaster"] = 95,

    ["awpdragon"] = 45,
}

SUIT.Hooks = {} // If ya want any hooks

VNP.Inventory:RegisterSuit(SUIT)

--[[
    Admin Suit V2
]]--

SUIT.Name = "Admin Suit V2"

SUIT.SuitModel = "models/bloocobalt/combine/fg_com.mdl"

SUIT.RepairCost = 1000

SUIT.BaseModifiers = {
    ["SuitHealth"] = {val = 50000},
    ["SuitArmor"] = {val = 1000},
    ["SuitRegen"] = {chance = 10},
    ["SuitResist"] = {chance = 10},
    ["SuitSpeed"] = {chance = 20},
    //["SuitEnergyResist"] = {chance = 10},
    //["SuitArrestHits"] = {chance = 10},
    //["SuitJump"] = {chance = 10},
}

SUIT.Modifiers = { // the modifiers per rarity if there is no base value for a modifier it will use the below otherwise its a % multiplier
    ["Common"] = {
        ["SuitHealth"] = {min = 0, max = 100},
        ["SuitArmor"] = {min = 0, max = 100},
        ["SuitRegen"] = {min = 1, max = 2},
        ["SuitResist"] = {min = 1, max = 2},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Uncommon"] = {
        ["SuitHealth"] = {min = 100, max = 125},
        ["SuitArmor"] = {min = 100, max = 125},
        ["SuitRegen"] = {min = 3, max = 4},
        ["SuitResist"] = {min = 3, max = 4},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Rare"] = {
        ["SuitHealth"] = {min = 125, max = 150},
        ["SuitArmor"] = {min = 125, max = 150},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Epic"] = {
        ["SuitHealth"] = {min = 150, max = 175},
        ["SuitArmor"] = {min = 150, max = 175},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Legendary"] = {
        ["SuitHealth"] = {min = 175, max = 200},
        ["SuitArmor"] = {min = 175, max = 200},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Celestial"] = {
        ["SuitHealth"] = {min = 200, max = 225},
        ["SuitArmor"] = {min = 200, max = 225},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["God"] = {
        ["SuitHealth"] = {min = 225, max = 250},
        ["SuitArmor"] = {min = 225, max = 250},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Glitched"] = {
        ["SuitHealth"] = {min = 250, max = 300},
        ["SuitArmor"] = {min = 250, max = 300},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
}

SUIT.Resistances = { -- Damage types and weapons this weapon is resistant to
    [DMG_FALL] = 0, -- resistant amount in %

    ["awpdragon"] = 55,

    ["amr11"] = 55, -- just here so it balances out
    
    ["ryry_m134"] = 55,
    
    ["weapon_glock2"] = 55,
    
    ["ls_sniper"] = 55,
    
    ["m9k_usas"] = 55,
    
    ["m9k_m60"] = 55,

    ["weapon_gblaster_badtime"] = 100,

    ["weapon_gblaster_onehit"] = 100,

    ["weapon_gblaster_judgement_chaingun"] = 90,

    ["weapon_gblaster_gaster"] = 95,

    ["weapon_gblaster"] = 100,
 
	["weapon_gblaster_badtime_tokyo"] = 100,

	["weapon_gblaster_aqua"] = 100,

	["weapon_gblaster_badtime_orange"] = 100,

	["weapon_gblaster_badtime_bp1"] = 100,

	["weapon_gblaster_asriel_rainbow_onehit"] = 100,

	["weapon_gblaster_asriel_rainbow"] = 100,
	
	["weapon_supreme_badtime_bm_gblaster"] = 100,

	["weapon_gblaster_badtime_onehit"] = 100,

	["weapon_gblaster_pistol"] = 100,

	["weapon_gblaster_badtime_glitched"] = 100,

	["weapon_gblaster_badtime_green"] = 100,

	["weapon_bm_ams"] = 100,

	["weapon_gblaster_badtime_pink"] = 100,

	["weapon_gblaster_badtime_platinum"] = 100,

	["weapon_purple_supreme_badtime_bm_gblaster"] = 100,

	["weapon_supreme_badtime_bm_gblaster_onehit"] = 100,

	["weapon_bm_rifle"] = 100,

	["weapon_bm_rifle_nonadmin"] = 100,

	["weapon_bm_rifle_admin"] = 100,

	["weapon_supremelaser_badtime_bm_gblaster"] = 100,

	["weapon_gold_badtime_bm_gblaster"] = 100,

	["weapon_purple_badtime_gblaster"] = 100,

	["weapon_bms_gluon"] = 100,

	["weapon_dababy_gaster"] = 100,

	["weapon_gblaster_gravy"] = 100,

	["weapon_gblaster_nation"] = 100,

	["weapon_gblaster_sun"] = 100,

	["weapon_gblaster_badtime_shark"] = 100,

	["weapon_gblaster_badtime_batt"] = 100,

	["weapon_gblaster_badtime_cop"] = 100,

	["weapon_gblaster_badtime_fortnite"] = 100,

	["weapon_gblaster_badtime_fgood"] = 100,

	["weapon_gblaster_badtime_customone"] = 100,

	["weapon_gblaster_badtime_floid"] = 100,

	["weapon_gblaster_badtime_hed"] = 100,
	
	["weapon_gblaster_badtime_gey"] = 100,
	
	["weapon_gblaster_badtime_hom"] = 100,
	
	["weapon_gblaster_badtime_phub"] = 100,
	
	["weapon_gblaster_badtime_kiss"] = 100,

	["weapon_gblaster_badtime_anishit"] = 100,
	
	["weapon_gblaster_badtime_oero"] = 100,
	
	["weapon_gblaster_badtime_party"] = 100,
	
	["weapon_gblaster_badtime_pepsi"] = 100,
	
	["weapon_gblaster_badtime_danger"] = 100,
	
	["weapon_gblaster_badtime_akemi"] = 100,
	
	["weapon_gblaster_badtime_web"] = 100,
	
	["weapon_zilla_gaster"] = 100,
	
	["weapon_gblaster_badtime_zero"] = 100,
	
	["weapon_green_gaster"] = 100,

	["weapon_gblaster_orange"] = 100,
	
	["weapon_pink_gaster"] = 100,
	
	["weapon_sugarcrash"] = 100,
	
	["weapon_travisscottburger"] = 100,
	
	["weapon_wumbo"] = 100,

	["weapon_reaper_gaster"] = 100,
	
	["weapon_nightmare_gaster"] = 100,
	
	["weapon_black_gaster"] = 100,
	
	["weapon_nyan"] = 100,
	
	["weapon_halloweengaster"] = 100,

	["weapon_amongussus"] = 100,
	
	["weapon_supreme_dl"] = 100,
	
	["weapon_nrgbeam"] = 100,
	
	["weapon_masterspark_gluon"] = 100,

	["weapon_bm_qe_zapper"] = 100,

	["weapon_woofer_cannon"] = 100,

	["weapon_bm_aimbot"] = 100,
	
	["weapon_nrgbeam_admin	"] = 100,

	["weapon_unoreverse"] = 100,
	
	["weapon_gblaster_badtime_goat"] = 100,
	
	["weapon_gblaster_badtime_godly"] = 100,
	
	["weapon_gblaster_badtime_gopnik"] = 100,
	
	["weapon_gblaster_badtime_laststand"] = 100,

	["weapon_gblaster_badtime_horizon"] = 100,
	
	["weapon_gblaster_badtime_horror"] = 100,
	
	["weapon_gblaster_badtime_hunter"] = 100,
	
	["weapon_gblaster_badtime_killer"] = 100,
	
	["weapon_supreme_badtime_revenge"] = 100,

	["weapon_gblaster_badtime_madtime"] = 100,
	
	["weapon_gblaster_badtime_murder"] = 100,
	
	["weapon_gblaster_badtime_pin"] = 100,
	
	["weapon_gblaster_badtime_rainbownightmare"] = 100,
	
	["weapon_gblaster_badtime_ret"] = 100,

	["weapon_gblaster_badtime_revenge"] = 100,
	
	["weapon_gblaster_badtime_hardmode"] = 100,
	
	["weapon_gblaster_badtime_titanium"] = 100,
	
	["weapon_gblaster_badtime_crimson"] = 100,
	
	["weapon_gblaster_badtime_ultra"] = 100,

	["weapon_gblaster_xmas"] = 100,

	["weapon_nrgbeam_admin"] = 100,
	
	["weapon_gblaster_badtime_bp2cc"] = 100,

	["weapon_gblaster_badtime_bp2dd"] = 100,

	["weapon_gblaster_badtime_bp2ff"] = 100,

	["weapon_gblaster_badtime_bp2aa"] = 100,

	["weapon_gblaster_badtime_bp2ee"] = 100,

	["weapon_gblaster_badtime_bp2bb"] = 100,

	["weapon_vaporizer_hardcore"] = 100,

	["weapon_zero_dissolver_penetrator"] = 100,

	["weapon_greenheartray"] = 100,

	["weapon_dissolver_rifle"] = 100,

	["weapon_blacksisterblaster"] = 100,

	["weapon_darkness_blaster"] = 100,

	["weapon_gblaster_badtime_stewie"] = 100,

	["weapon_gblaster_badtime_boombastic"] = 100,

	["weapon_gblaster_badtime_bust"] = 100,

	["weapon_gblaster_badtime_covid"] = 100,

	["weapon_gblaster_badtime_cell"] = 100,

	["weapon_gblaster_badtime_death"] = 100,

	["weapon_gblaster_badtime_tunsumi"] = 100,

	["weapon_gblaster_badtime_tap"] = 100,

	["weapon_gblaster_badtime_emotion"] = 100,

	["weapon_gblaster_badtime_fall"] = 100,

	["weapon_gblaster_badtime_bitchboy"] = 100,

	["weapon_gblaster_badtime_gator"] = 100,

	["weapon_gblaster_badtime_ghoul"] = 100,

	["weapon_gblaster_badtime_soon"] = 100,

	["weapon_gblaster_badtime_goose"] = 100,

	["weapon_gblaster_badtime_gurenge"] = 100,

	["weapon_gblaster_badtime_heart"] = 100,

	["weapon_gblaster_badtime_drain"] = 100,

	["weapon_gblaster_badtime_japan"] = 100,

	["weapon_gblaster_badtime_kingly"] = 100,

	["weapon_gblaster_badtime_meow"] = 100,

	["weapon_gblaster_badtime_moon"] = 100,

	["weapon_gblaster_badtime_manners"] = 100,

	["weapon_gblaster_badtime_memphis"] = 100,

	["weapon_gblaster_badtime_shimmy"] = 100,

	["weapon_gblaster_badtime_sos"] = 100,

	["weapon_gblaster_badtime_squishy"] = 100,

	["weapon_gblaster_badtime_stoppa"] = 100,

	["weapon_gblaster_badtime_sussy"] = 100,

	["weapon_gblaster_badtime_odd"] = 100,

	["weapon_gblaster_lightning"] = 100,

	["weapon_gblaster_badtime_lweo"] = 100,

	["weapon_shockgaster"] = 100,

	["weapon_animegaster"] = 100,

	["weapon_banjogaster"] = 100,

	["weapon_berserkergaster"] = 100,

	["weapon_dealergaster"] = 100,

	["weapon_deathgblaster"] = 100,

	["weapon_demongaster"] = 100,

	["weapon_diamondgaster"] = 100,

	["weapon_discordgaster"] = 100,

	["weapon_supreme_fucktheworld_gblaster"] = 100,

	["weapon_goatgaster"] = 100,

	["weapon_godgaster"] = 100,
	
	["weapon_maskoff"] = 100,

	["weapon_oreogaster"] = 100,

	["weapon_supreme_loading"] = 100,

	["weapon_spygaster"] = 100,

	["weapon_weebgaster"] = 100,

	["weapon_hid"] = 100,
}

local stuckDelay = 0
local offset = Vector(2,2,2)

SUIT.Hooks = { // Aids but works
    ["PhysgunPickup"] = function(ply, ent)
        if !ent:IsPlayer() then return end
        if !IsValid(ply) then return end
        if ent._V2PickedUp then return end
        if table.HasValue(VNP.Inventory.StaffRanks, ply:GetUserGroup()) then return end
        local suit = ply:GetSuit()

        if !suit then return end
        if suit.Name ~= "Admin Suit V2" then return end
        
        ent:SetCollisionGroup(COLLISION_GROUP_PLAYER)
        ent:SetMoveType(MOVETYPE_NONE)
        ent._V2PickedUp = ply 

        return true
    end,
    ["PhysgunDrop"] = function(ply, ent)
        if !ent:IsPlayer() then return end
        if !IsValid(ply) then return end
        if table.HasValue(VNP.Inventory.StaffRanks, ply:GetUserGroup()) then return end
        local suit = ply:GetSuit()

        if !suit then return end
        if suit.Name ~= "Admin Suit V2" then return end
        
        ent:Freeze(false)
        ent:SetMoveType(MOVETYPE_WALK)
        ent:RemoveEFlags(FL_FROZEN)
        ent:UnLock()
        
        ent._V2PickedUp = false
    end,
    ["Think"] = function()
        if CurTime() < stuckDelay then return end
        stuckDelay = CurTime() + 0.1
        
        for i,ply in ipairs(player.GetAll()) do
            if !ply._V2PickedUp then continue end

            for _,ent in pairs(ents.FindInBox(ply:GetPos()+ply:OBBMins()+offset, ply:GetPos()+ply:OBBMaxs()-offset)) do
                if IsValid(ent) && ply ~= ent && ent:GetClass() == "prop_physics" && ply._V2PickedUp then
                    ply:Freeze(false)
                    ply:SetMoveType(MOVETYPE_WALK)
                    ply:RemoveEFlags(FL_FROZEN)
                    ply:UnLock()
                    ply:SetPos(VNP.Inventory.SpawnLocation or Vector(0,0,0))

                    if IsValid(ply._V2PickedUp) && ply._V2PickedUp:IsPlayer() && ply._V2PickedUp.SetActiveWeapon then 
                        ply._V2PickedUp:SetActiveWeapon(NULL)
                    end

                    ply._V2PickedUp = nil
                    
                    break
                end
            end
        end
    end
} // If ya want any hooks

VNP.Inventory:RegisterSuit(SUIT)

--[[
    Godly Armour
]]--

SUIT.Name = "Godly Armour"

SUIT.SuitModel = "models/player/alyx.mdl"

SUIT.RepairCost = 1000

SUIT.BaseModifiers = {
    ["SuitHealth"] = {val = 1000},
    ["SuitArmor"] = {val = 500},
    ["SuitRegen"] = {chance = 10},
    ["SuitResist"] = {chance = 10},
    ["SuitSpeed"] = {chance = 10},
    ["SuitEnergyResist"] = {chance = 10},
    //["SuitArrestHits"] = {chance = 10},
    //["SuitJump"] = {chance = 10},
}

SUIT.Modifiers = { // the modifiers per rarity if there is no base value for a modifier it will use the below otherwise its a % multiplier
    ["Common"] = {
        ["SuitHealth"] = {min = 0, max = 100},
        ["SuitArmor"] = {min = 0, max = 100},
        ["SuitRegen"] = {min = 1, max = 2},
        ["SuitResist"] = {min = 1, max = 2},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Uncommon"] = {
        ["SuitHealth"] = {min = 100, max = 125},
        ["SuitArmor"] = {min = 100, max = 125},
        ["SuitRegen"] = {min = 3, max = 4},
        ["SuitResist"] = {min = 3, max = 4},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Rare"] = {
        ["SuitHealth"] = {min = 125, max = 150},
        ["SuitArmor"] = {min = 125, max = 150},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Epic"] = {
        ["SuitHealth"] = {min = 150, max = 175},
        ["SuitArmor"] = {min = 150, max = 175},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Legendary"] = {
        ["SuitHealth"] = {min = 175, max = 200},
        ["SuitArmor"] = {min = 175, max = 200},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Celestial"] = {
        ["SuitHealth"] = {min = 200, max = 225},
        ["SuitArmor"] = {min = 200, max = 225},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["God"] = {
        ["SuitHealth"] = {min = 225, max = 250},
        ["SuitArmor"] = {min = 225, max = 250},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Glitched"] = {
        ["SuitHealth"] = {min = 250, max = 300},
        ["SuitArmor"] = {min = 250, max = 300},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
}

SUIT.Hooks = {} // If ya want any hooks

VNP.Inventory:RegisterSuit(SUIT)

--[[
    Santa Suit
]]--

SUIT.Name = "Santa Suit"

SUIT.SuitModel = "models/player/christmas/santa.mdl"

SUIT.RepairCost = 1000

SUIT.BaseModifiers = {
    ["SuitHealth"] = {val = 10000},
    ["SuitArmor"] = {val = 5000},
    ["SuitRegen"] = {chance = 10},
    ["SuitResist"] = {chance = 10},
    ["SuitSpeed"] = {chance = 10},
    ["SuitEnergyResist"] = {chance = 10},
    //["SuitArrestHits"] = {chance = 10},
    //["SuitJump"] = {chance = 10},
}

SUIT.Modifiers = { // the modifiers per rarity if there is no base value for a modifier it will use the below otherwise its a % multiplier
    ["Common"] = {
        ["SuitHealth"] = {min = 0, max = 100},
        ["SuitArmor"] = {min = 0, max = 100},
        ["SuitRegen"] = {min = 1, max = 2},
        ["SuitResist"] = {min = 1, max = 2},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Uncommon"] = {
        ["SuitHealth"] = {min = 100, max = 125},
        ["SuitArmor"] = {min = 100, max = 125},
        ["SuitRegen"] = {min = 3, max = 4},
        ["SuitResist"] = {min = 3, max = 4},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Rare"] = {
        ["SuitHealth"] = {min = 125, max = 150},
        ["SuitArmor"] = {min = 125, max = 150},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Epic"] = {
        ["SuitHealth"] = {min = 150, max = 175},
        ["SuitArmor"] = {min = 150, max = 175},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Legendary"] = {
        ["SuitHealth"] = {min = 175, max = 200},
        ["SuitArmor"] = {min = 175, max = 200},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Celestial"] = {
        ["SuitHealth"] = {min = 200, max = 225},
        ["SuitArmor"] = {min = 200, max = 225},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["God"] = {
        ["SuitHealth"] = {min = 225, max = 250},
        ["SuitArmor"] = {min = 225, max = 250},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Glitched"] = {
        ["SuitHealth"] = {min = 250, max = 300},
        ["SuitArmor"] = {min = 250, max = 300},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
}

SUIT.Hooks = {} // If ya want any hooks

VNP.Inventory:RegisterSuit(SUIT)

--[[
    Elf Suit
]]--

SUIT.Name = "Elf Suit"

SUIT.SuitModel = "models/tsbb/elf.mdl"

SUIT.RepairCost = 1000

SUIT.BaseModifiers = {
    ["SuitHealth"] = {val = 5000},
    ["SuitArmor"] = {val = 2500},
    ["SuitRegen"] = {chance = 10},
    ["SuitResist"] = {chance = 10},
    ["SuitSpeed"] = { chance = 10},
    ["SuitEnergyResist"] = {chance = 10},
    //["SuitArrestHits"] = {chance = 10},
    //["SuitJump"] = {chance = 10},
}

SUIT.Modifiers = { // the modifiers per rarity if there is no base value for a modifier it will use the below otherwise its a % multiplier
    ["Common"] = {
        ["SuitHealth"] = {min = 0, max = 100},
        ["SuitArmor"] = {min = 0, max = 100},
        ["SuitRegen"] = {min = 1, max = 2},
        ["SuitResist"] = {min = 1, max = 2},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Uncommon"] = {
        ["SuitHealth"] = {min = 100, max = 125},
        ["SuitArmor"] = {min = 100, max = 125},
        ["SuitRegen"] = {min = 3, max = 4},
        ["SuitResist"] = {min = 3, max = 4},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Rare"] = {
        ["SuitHealth"] = {min = 125, max = 150},
        ["SuitArmor"] = {min = 125, max = 150},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Epic"] = {
        ["SuitHealth"] = {min = 150, max = 175},
        ["SuitArmor"] = {min = 150, max = 175},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Legendary"] = {
        ["SuitHealth"] = {min = 175, max = 200},
        ["SuitArmor"] = {min = 175, max = 200},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Celestial"] = {
        ["SuitHealth"] = {min = 200, max = 225},
        ["SuitArmor"] = {min = 200, max = 225},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["God"] = {
        ["SuitHealth"] = {min = 225, max = 250},
        ["SuitArmor"] = {min = 225, max = 250},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Glitched"] = {
        ["SuitHealth"] = {min = 250, max = 300},
        ["SuitArmor"] = {min = 250, max = 300},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
}

SUIT.Hooks = {} // If ya want any hooks

VNP.Inventory:RegisterSuit(SUIT)

--[[
    Compensation Suit
]]--

SUIT.Name = "Compensation Suit"

SUIT.SuitModel = "models/mailer/characters/wow_doomguard.mdl"

SUIT.RepairCost = 1000

SUIT.BaseModifiers = {
    ["SuitHealth"] = {val = 50000},
    ["SuitArmor"] = {val = 5000},
    ["SuitRegen"] = {chance = 10},
    ["SuitResist"] = {chance = 10},
    ["SuitSpeed"] = { chance = 10},
    ["SuitEnergyResist"] = {chance = 10},
    //["SuitArrestHits"] = {chance = 10},
    //["SuitJump"] = {chance = 10},
}

SUIT.Modifiers = { // the modifiers per rarity if there is no base value for a modifier it will use the below otherwise its a % multiplier
    ["Common"] = {
        ["SuitHealth"] = {min = 0, max = 100},
        ["SuitArmor"] = {min = 0, max = 100},
        ["SuitRegen"] = {min = 1, max = 2},
        ["SuitResist"] = {min = 1, max = 2},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Uncommon"] = {
        ["SuitHealth"] = {min = 100, max = 125},
        ["SuitArmor"] = {min = 100, max = 125},
        ["SuitRegen"] = {min = 3, max = 4},
        ["SuitResist"] = {min = 3, max = 4},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Rare"] = {
        ["SuitHealth"] = {min = 125, max = 150},
        ["SuitArmor"] = {min = 125, max = 150},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Epic"] = {
        ["SuitHealth"] = {min = 150, max = 175},
        ["SuitArmor"] = {min = 150, max = 175},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Legendary"] = {
        ["SuitHealth"] = {min = 175, max = 200},
        ["SuitArmor"] = {min = 175, max = 200},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Celestial"] = {
        ["SuitHealth"] = {min = 200, max = 225},
        ["SuitArmor"] = {min = 200, max = 225},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["God"] = {
        ["SuitHealth"] = {min = 225, max = 250},
        ["SuitArmor"] = {min = 225, max = 250},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Glitched"] = {
        ["SuitHealth"] = {min = 250, max = 300},
        ["SuitArmor"] = {min = 250, max = 300},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 80, max = 160},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
}

SUIT.Hooks = {} // If ya want any hooks

VNP.Inventory:RegisterSuit(SUIT)

/*


--[[
    Evo Suit
]]--

SUIT.Name = "Evo Suit"

SUIT.SuitModel = "models/kryptonite/inf_war_machine/inf_war_machine.mdl"

SUIT.RepairCost = 1000

SUIT.BaseModifiers = {
    ["SuitHealth"] = {val = 15000},
    ["SuitArmor"] = {val = 1250},
    ["SuitRegen"] = {chance = 10},
    ["SuitResist"] = {chance = 10},
    ["SuitSpeed"] = { chance = 10},
    ["SuitEnergyResist"] = {chance = 10},
    //["SuitArrestHits"] = {chance = 10},
    //["SuitJump"] = {chance = 10},
}

SUIT.Modifiers = { // the modifiers per rarity if there is no base value for a modifier it will use the below otherwise its a % multiplier
    ["Common"] = {
        ["SuitHealth"] = {min = 0, max = 100},
        ["SuitArmor"] = {min = 0, max = 100},
        ["SuitRegen"] = {min = 1, max = 2},
        ["SuitResist"] = {min = 1, max = 2},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Uncommon"] = {
        ["SuitHealth"] = {min = 100, max = 125},
        ["SuitArmor"] = {min = 100, max = 125},
        ["SuitRegen"] = {min = 3, max = 4},
        ["SuitResist"] = {min = 3, max = 4},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Rare"] = {
        ["SuitHealth"] = {min = 125, max = 150},
        ["SuitArmor"] = {min = 125, max = 150},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Epic"] = {
        ["SuitHealth"] = {min = 150, max = 175},
        ["SuitArmor"] = {min = 150, max = 175},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Legendary"] = {
        ["SuitHealth"] = {min = 175, max = 200},
        ["SuitArmor"] = {min = 175, max = 200},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Celestial"] = {
        ["SuitHealth"] = {min = 200, max = 225},
        ["SuitArmor"] = {min = 200, max = 225},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["God"] = {
        ["SuitHealth"] = {min = 225, max = 250},
        ["SuitArmor"] = {min = 225, max = 250},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitEnergyResist"] = {min = 0, max = 0},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
    ["Glitched"] = {
        ["SuitHealth"] = {min = 250, max = 300},
        ["SuitArmor"] = {min = 250, max = 300},
        ["SuitRegen"] = {min = 4, max = 5},
        ["SuitResist"] = {min = 4, max = 5},
        ["SuitSpeed"] = {min = 80, max = 160},
        ["SuitSpeed"] = {min = 1, max = 5},
        //["SuitArrestHits"] = {min = 0, max = 0},
        //["SuitJump"] = {min = 0, max = 0},
    },
}


SUIT.Hooks = {

    hook.Add("HUDPaint", "ESP", function()
        if (esp) then
            local ents = ents.FindInSphere(ply:GetPos(), whRadius)

            for i, v in pairs(ents) do
                if (not IsValid(v)) then continue end
                if (v == ply) then continue end

                if (v:GetClass() == "oneprint" or (v:IsPlayer() and v:Alive())) then -- name of entity of printer 
                    local center = v:LocalToWorld(v:OBBCenter())
                    local dist = math.floor(v:GetPos():Distance(ply:GetPos()) * (0.0254 * (4 / 3)))
                    local toScreen = center:ToScreen()
                    local x, y = toScreen.x, toScreen.y
                    if (x < -50 or y < -50 or x > w + 50 or y > ScrH() + 50) then continue end
                    surface.SetFont("Armor.3DHUD")
                    local tw = surface.GetTextSize(dist .. " m") + 10
                    ply.m_pulseSize = ply.m_pulseSize or 1
                    ply.m_pulseSize = ply.m_pulseSize - FrameTime() * 1.67 -- 1.67 is best

                    if (ply.m_pulseSize <= 0) then
                        ply.m_pulseSize = 1
                    end

                    tw = tw * ply.m_pulseSize
                    surface.SetDrawColor(255,153,235)
                    surface.SetMaterial(circleMat) -- from my workshop
                    surface.DrawTexturedRect(x - tw / 2, y - tw / 2, tw, tw)
                    draw.SimpleText(dist .. "m", "Armor.3DHUD", x, y, Color(253,154,232), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    draw.SimpleText(v:IsPlayer() and v:Nick() .. "!" or "printer uwu", "Armor.3DHUDName", x, y - 55, Color(255,66,214), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- change the text by just changing it..
                end
            end
        end
    end)

    

} // If ya want any hooks
 */ 
VNP.Inventory:RegisterSuit(SUIT)