VNP.Inventory.Items["SCROLL"] = {}

-- Scrolls are items that directly affect items whether it be rarity or stats

local SCROLL = {}

function VNP.Inventory:RegisterScroll(data)
    if !data.Name then return end

    data.CanEnhance = data.CanEnhance or function()
        return true
    end

    self.Items["SCROLL"][data.Name] = data

    SCROLL = {}
end

SCROLL.Name = "Upgrade Scroll"

SCROLL.UpgradeCost = 5000 -- Cost per rarity
SCROLL.UpgradeIncrement = 2.5 -- Price above multiplies by this increment for every rarity

SCROLL.Description = "Use this on an item to increase it's rarity."

SCROLL.ColorModel = true -- Whether or not to apply the rarity color to the model
SCROLL.Model = "models/Items/combine_rifle_ammo01.mdl"

SCROLL.CanEnhance = function(scroll, item)
    local prevRarity = VNP.Inventory:GetPreviousRarity(scroll.Rarity.Name, "Name")
    if item.Rarity.Name ~= prevRarity then return false end

    return true
end

SCROLL.OnEnhance = function(ply, scroll, item, gem) -- Return item, DoRemoveScroll, DoRemoveGem, DoRemoveItem
    if !item or !item.Name then return end
    if !scroll or !scroll.Name then return end
    
    if item.Rarity.Name ~= VNP.Inventory:GetPreviousRarity(scroll.Rarity.Name, "Name") then return end

    local data = VNP.Inventory:GetItemData(item.Name)

    if !data then return end

    if !item.Signature then
        item.Signature = ply:Nick()
    end

    local chance = table.Copy(VNP.Inventory:GetRarityValue(scroll.Rarity.Name, "UpgradeChance"))

    for k,v in pairs(chance) do
        if !v.val then chance[k] = nil continue end
        chance[k] = v.val
    end

    local r = math.random(10000)/100

    if gem && gem.Modifiers then -- Modifies the chances based off of the upgrade gem...
        for stat, val in pairs(chance) do
            if gem.Modifiers[stat] then
                chance[stat] = chance[stat] + gem.Modifiers[stat]
            end
        end
    end
    
    local function doStuff(item,rarity)
        item.Rarity.Name = rarity

        if VNP.Inventory:IsUpgrade(item.Type) && item.Modifiers then
            item.Modifiers = {}

            local mods = data.Modifiers

            if mods[rarity] then
                mods = mods[rarity]
            end

            for stat,data in pairs(mods) do
                if data.min && data.max then
                    item.Modifiers[stat] = math.random(data.min, data.max)
                elseif data.val then
                    item.Modifiers[stat] = data.val
                end
            end
        elseif item.Rarity.Modifiers then
            item.Rarity.Modifiers = VNP.Inventory:CalcRarityMods(item)
        end
        return item
    end

    -- Success code
    if chance["upgrMajorSuccess"] && r < chance["upgrMajorSuccess"] then
        
        item = doStuff(item,VNP.Inventory:GetRarityValue(nextRarity, scroll.Rarity.Name))

        return item, true, "Major Success"
    elseif chance["upgrMinorSuccess"] && r < chance["upgrMinorSuccess"] then

        item = doStuff(item,scroll.Rarity.Name)
        
        return item, true, "Success"
    end

    -- Fail Code
    if chance["upgrMajorFail"] && (100-chance["upgrMajorFail"]) < r then

       -- item = doStuff(item,"Uncommon")

        return item, true, "Major Fail"
    elseif chance["upgrMinorFail"] && (100-chance["upgrMinorFail"]) < r then
        return nil, true, "Minor Fail"
    end

    return nil, true, "Failed"
end

VNP.Inventory:RegisterScroll(SCROLL)

--

SCROLL.Name = "Upgrade Scroll (Universal)"

SCROLL.Rarity = "Glitched"

SCROLL.UpgradeCost = 5000 -- Cost per rarity
SCROLL.UpgradeIncrement = 2.5 -- Price above multiplies by this increment for every rarity

SCROLL.Description = "Use this on an item to increase it's rarity."

SCROLL.ColorModel = true -- Whether or not to apply the rarity color to the model
SCROLL.Model = "models/Items/combine_rifle_ammo01.mdl"

SCROLL.CanEnhance = function(scroll, item)
    return true
end

SCROLL.OnEnhance = function(ply, scroll, item, gem) -- Return item, DoRemoveScroll, DoRemoveGem, DoRemoveItem
    if !item or !item.Name then return end
    if !scroll or !scroll.Name then return end

    local data = VNP.Inventory:GetItemData(item.Name)

    if !data then return end

    if !item.Signature then
        item.Signature = ply:Nick()
    end

    local nextRarity = VNP.Inventory:GetNextRarity(item.Rarity.Name, "Name")

    

    local chance = table.Copy(VNP.Inventory:GetRarityValue(nextRarity, "UpgradeChance"))

    for k,v in pairs(chance) do
        if !v.val then chance[k] = nil continue end
        chance[k] = v.val
    end

    local r = math.random(10000)/100

    if gem && gem.Modifiers then -- Modifies the chances based off of the upgrade gem...
        for stat, val in pairs(chance) do
            if gem.Modifiers[stat] then
                chance[stat] = chance[stat] + gem.Modifiers[stat]
            end
        end
    end
    
    local real_gay = {
        ["Common"] = 1,
        ["Uncommon"] = 2,
        ["Rare"] = 3,
        ["Epic"] = 4,
        ["Legendary"] = 5,
        ["Celestial"] = 6,
        ["God"] = 7,
        ["Glitched"] = 8,
    }

    local function doStuff(item,rarity)
        item.Rarity.Name = rarity
        local int = real_gay[rarity]


        if VNP.Inventory:IsUpgrade(item.Type) && item.Modifiers then
            item.Modifiers = {}

            local mods = data.Modifiers

            if mods[rarity] then
                mods = mods[rarity]
                PrintTable(mods)
            end
            VNP.Inventory:UpgradeGem(0 , int , item.Name , item.Modifiers , item)
            if item.Type == "GEM" then
                for stat , _ in pairs(mods) do
                    --item.Modifiers[stat] = 100.0
                end
            end
            if item.Type ~= "GEM" then
            for stat,data in pairs(mods) do
                print("Stat" , stat , "Data" , data)
                if data.min && data.max then
                    item.Modifiers[stat] = math.random(data.min, data.max)
                elseif data.val then
                    item.Modifiers[stat] = data.val
                end
            end
            end
        elseif item.Rarity.Modifiers then
            PrintTable(item)
            if item.Type == "SUIT" then
            --item.Rarity.Modifiers = VNP.Inventory:CalcRarityMods(item)
            local success, tbl = cangetsuitother(item.Rarity.Modifiers)
            print(success , tbl)
            local real , real2 = item["SuitHealthMax"] , item["SuitArmorMax"]
                if int == 2 then
                    real = item["SuitHealth"]
                end
                local suit_hp = VNP.Inventory:GetRealSuitHP(real or 1 , int)
                item["SuitHealthMax"] = suit_hp
                item["SuitHealth"] = suit_hp or 100
                local suit_armor = VNP.Inventory:GetRealSuitArmor(real2 or 1 , int)
                item["SuitArmorMax"] = suit_armor
                item["SuitArmor"] = suit_armor or 100
            if success then
                for _, stat in ipairs(tbl) do
                    print("We did it!")
                    item[stat[1]] = stat[2]
                    print(item[stat[1]] , " Item[key]" , stat[2] , " Value")
                end
            end
        else
            --print("Else????")
            item.Rarity.Modifiers = VNP.Inventory:CalcRarityMods(item)
        end
        end

        if item.Type == "WEAPON" then
            item.Sockets = VNP.Inventory:CalcRaritySockets(rarity)
        elseif item.Type == "SUIT" then
            --item["SuitHealth"] = VNP.Inventory:CalculateMaxStat(item, "SuitHealth")
            --item["SuitArmor"] = VNP.Inventory:CalculateMaxStat(item, "SuitArmor")
            --local suit_hp = VNP.Inventory:GetRealSuitHP(item["SuitHealthMax"] or 1 , int)
            --item["SuitHealthMax"] = 2
            --item["SuitHealth"] = suit_hp or 100

            item.Sockets = VNP.Inventory:CalcRaritySockets(rarity)
        end

        return item
    end

    -- Success code
    if chance["upgrMajorSuccess"] && r < chance["upgrMajorSuccess"] then
        
        item = doStuff(item,VNP.Inventory:GetNextRarity(nextRarity, "Name"))
        if nextRarity == "Glitched" then -- should return end omgg
            return
        end
        return item, true, "Major Success"
    elseif chance["upgrMinorSuccess"] && r < chance["upgrMinorSuccess"] then

        item = doStuff(item,nextRarity)
        
        return item, true, "Success"
    end

    -- Fail Code
    if chance["upgrMajorFail"] && (100-chance["upgrMajorFail"]) < r then

     --   item = doStuff(item,"Uncommon")

        return nil, true, "Major Fail"
    elseif chance["upgrMinorFail"] && (100-chance["upgrMinorFail"]) < r then
        return nil, true, "Minor Fail"
    end

    return nil, true, "Failed"
end

VNP.Inventory:RegisterScroll(SCROLL)

--[[
    Reroll Scroll
]]--
SCROLL.Name = "Reroll Scroll"

SCROLL.Rarity = "Glitched"

SCROLL.UpgradeCost = 1000 -- Cost per rarity
SCROLL.UpgradeIncrement = 1.2 -- Price above multiplies by this increment for every rarity

SCROLL.ColorModel = true -- Whether or not to apply the rarity color to the model
SCROLL.Model = "models/Items/combine_rifle_ammo01.mdl"

SCROLL.Description = "Use this on an item to increase it's rarity."

SCROLL.CanEnhance = function(scroll, item)
    return true
end

SCROLL.OnEnhance = function(ply, scroll, item, gem)
    if !item then return end
    if !scroll then return end

    if VNP.Inventory:IsUpgrade(item.Type) && item.Modifiers then
        item.Modifiers = {}

        local d = VNP.Inventory:GetItemData(item.Name)

        local mods = d.Modifiers

        if mods[rarity] then
            mods = mods[rarity]
        end

        for stat,data in pairs(mods) do
            if data.min && data.max then
                item.Modifiers[stat] = math.random(data.min, data.max)
            elseif data.val then
                item.Modifiers[stat] = data.val
            end
        end
    elseif item.Rarity.Modifiers then
        item.Rarity.Modifiers = VNP.Inventory:CalcRarityMods(item, true)
    end

    return item, true, "Success"
end

VNP.Inventory:RegisterScroll(SCROLL)
--