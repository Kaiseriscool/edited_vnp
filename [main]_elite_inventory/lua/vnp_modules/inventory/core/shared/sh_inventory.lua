VNP.Inventory = VNP.Inventory or {}
VNP.Inventory.Items = VNP.Inventory.Items or {}
VNP.Inventory.Rarities = VNP.Inventory.Rarities or {}
VNP.Inventory.Language = VNP.Inventory.Language or {}


function VNP.Inventory:RegisterLanguage(key, l, t, suffix, prefix)
    self.Language[key] = {l = l, t = t, s = suffix, p = prefix}
end

function VNP.Inventory:GetLanguageLabel(key)
    if !self.Language[key] then return nil end

    return self.Language[key].l
end

function VNP.Inventory:GetLanguageType(key)
    if !self.Language[key] then return nil end

    return self.Language[key].t
end

function VNP.Inventory:GetLanguageSuffix(key)
    if !self.Language[key] then return "%" end

    return self.Language[key].s
end

function VNP.Inventory:GetLanguagePrefix(key)
    if !self.Language[key] then return "+" end

    return self.Language[key].p
end

function VNP.Inventory:GetItemData(name, val)
    for t,_ in pairs(self.Items) do
        if val && self.Items[t][name] && self.Items[t][name][val] then return self.Items[t][name][val] end
        if self.Items[t][name] then return self.Items[t][name] end
    end

    return false
end

function VNP.Inventory:GetItemType(name)
    for t,_ in pairs(self.Items) do
        if self.Items[t][name] then return t end
    end

    return false
end

function VNP.Inventory:GetRarity(name)
    return self.Rarities[name]
end

function VNP.Inventory:GetRarityValue(name, key)
    if !self.Rarities[name] then return end
    if !self.Rarities[name][key] then return end

    return self.Rarities[name][key]
end

function VNP.Inventory:GetSlotPage(slot)
    local slotsPerPage = self.SlotsY*self.SlotsX

    for p,a in pairs(self.Pages) do
       if slot < (p+1)*slotsPerPage then return p end
    end
end

function VNP.Inventory:GetRaritiesByOrder()
    local newTbl = {}

    for k,v in SortedPairsByMemberValue(self.Rarities, "Order") do
        newTbl[v.Order] = v
    end

    return newTbl
end

function VNP.Inventory:GetPreviousRarity(name, key)
    local rarity

    local order = self.Rarities[name].Order

    rarity = self:GetRaritiesByOrder()[order-1]

    if !rarity then return end

    if key then
        rarity = rarity[key]
    end

    return rarity
end

function VNP.Inventory:GetNextRarity(name, key)
    local rarity

    local order = self.Rarities[name].Order

    rarity = self:GetRaritiesByOrder()[order+1]

    if !rarity then return end

    if key then
        rarity = rarity[key]
    end

    return rarity
end

local upgradeTypes = {
    "SCROLL",
    "UPGRADEGEM",
    "GEM",
}

function VNP.Inventory:IsUpgrade(t)
    if table.HasValue(upgradeTypes, t) then return true end

    return false
end

function VNP.Inventory:IsEnergyWeapon(class)
    if table.HasValue(self.EnergyWeapons, class) then return true end

    return false
end

function VNP.Inventory:SlotsPerPage()
    return self.SlotsY*self.SlotsX
end

local PLAYER = FindMetaTable("Player")

function PLAYER:GetItemsByType(t)
    local tbl = {}
    
    if VNP.Inventory:IsUpgrade(t) then
        for k,v in pairs(self._vInventory["UPGRADES"]) do
            if v.Type ~= t then continue end
            tbl[k] = v
        end
    else
        for k,v in ipairs(self._vInventory) do
            if v.Type ~= t then continue end
            tbl[k] = v
        end
    end
    return tbl
end

function PLAYER:GetScrap()
    return self._vInventory["SCRAP"] or nil
end

function PLAYER:GetInventory()
    return self._vInventory or nil
end

function PLAYER:GetInventoryPages() // returns the total number of pages the player has bought
    self._vInventory["PAGES"] = self._vInventory["PAGES"] or 1
    return self._vInventory["PAGES"]
end

function PLAYER:GetAvailableSlot(page)
    local slotsPerPage = VNP.Inventory.SlotsY*VNP.Inventory.SlotsX
    local min,max
    
    if page then
        min,max = 1+(page*slotsPerPage)-slotsPerPage, (page*slotsPerPage)
    else
        min,max = 1,(self:GetInventoryPages()*slotsPerPage)
    end

    for i=min,max do
        if self._vInventory[i] ~= nil then continue end
        
        return i
    end
end

function PLAYER:GetAvailableUpgradeSlot()
    local slotsPerPage = VNP.Inventory.SlotsY*VNP.Inventory.SlotsX

    for i=1,slotsPerPage do
        if self._vInventory["UPGRADES"][i] ~= nil then continue end
        
        return i
    end
end

local WEAPON = FindMetaTable("Weapon")

function WEAPON:StreamStat(name, val) -- ME no steal
	if (self.Primary and self.Primary[name]) then
		self.Primary[name] = val
	end
    
    if self[name] then
        self[name] = val
    end

 /*   if (self.Secondary and self.Secondary[name]) then
		self.Secondary[name] = val
        print("a")
    end */ -- made it to where weapons that had secondary shots had the same accuracy as the primary shots

	if SERVER && self.Primary[name] or self.Secondary[name] or self[name] then
        VNP:Broadcast("VNP.StreamStat", {name = name, val = val, weapon = self})
    end
end

function WEAPON:GetStat(name)
	if (self.Primary and self.Primary[name]) then
		return self.Primary[name]
	end
	
	return self[name]
end

function WEAPON:GetNick()
    if self.PrintName == "Scripted Weapon" then return self.ClassName end
    
    return self.PrintName or self.ClassName
end

local ENTITY = FindMetaTable("Entity")

function ENTITY:GetItemData()
    return self.VNPItemData
end

hook.Add("InitPostEntity", "VNP.Inventory.CreateEntities", function()

    local gems = table.GetKeys(VNP.Inventory.Items["GEM"])
    local scrolls = table.GetKeys(VNP.Inventory.Items["SCROLL"])
    local upgradegems = table.GetKeys(VNP.Inventory.Items["UPGRADEGEM"])
    local rarities = table.GetKeys(VNP.Inventory.Rarities)

    for i,name in ipairs(gems) do
        local BASE = scripted_ents.Get("vnp_item_base")

        BASE.PrintName = name
        BASE.Spawnable = true
        BASE.VNPItemName = name
        BASE.Category = "VNP Gems"

        scripted_ents.Register(BASE, "vnp_gem_"..string.lower(string.Replace(name, " ", "_")))
    end

    for _,rarity in ipairs(rarities) do
        local name = "Upgrade Scroll"
        local BASE = scripted_ents.Get("vnp_item_base")

        BASE.PrintName = name.." ("..rarity..")"
        BASE.Spawnable = true
        BASE.VNPItemName = name
        BASE.ItemRarity = rarity
        BASE.Category = "VNP Scrolls"

        scripted_ents.Register(BASE, "vnp_scroll_"..string.lower(string.Replace(name.."_"..rarity, " ", "_")))
    end

    for i,name in ipairs(upgradegems) do
        local BASE = scripted_ents.Get("vnp_item_base")

        BASE.PrintName = name
        BASE.Spawnable = true
        BASE.VNPItemName = name
        BASE.Category = "VNP Upgrade Gems"

        scripted_ents.Register(BASE, "vnp_upgradegem_"..string.lower(string.Replace(name, " ", "_")))
    end

    if CLIENT then
        RunConsoleCommand("spawnmenu_reload")
    end

    local BASE = scripted_ents.Get("vnp_item_base")
    local name = "Upgrade Scroll (Universal)"
    BASE.PrintName = name
    BASE.Spawnable = true
    BASE.VNPItemName = name
    BASE.Category = "VNP Scrolls"
    
    scripted_ents.Register(BASE, "vnp_scroll_"..string.lower(string.Replace(name, " ", "_")))
    BASE = scripted_ents.Get("vnp_item_base")
    name = "Reroll Scroll"    BASE.PrintName = name
    BASE.Category = "VNP Scrolls"
    BASE.Spawnable = true
    BASE.VNPItemName = name
    scripted_ents.Register(BASE, "vnp_scroll_"..string.lower(string.Replace(name, " ", "_")))


end)

hook.Add("EntityFireBullets", "VNP.Inventory.OnBulletFire", function(ply, bullet)
    if !IsValid(ply) or !ply:IsPlayer() then return end

    local wep = ply:GetActiveWeapon()

    if IsValid(wep) then
        local item = wep:GetItemData()

        if item && item.Sockets && #item.Sockets > 0 then
            for _,gem in pairs(item.Sockets) do
                if !gem then continue end
                
                local data = VNP.Inventory:GetItemData(gem.Name)

                if data.OnBulletFire then
                    data.OnBulletFire(ply, gem, wep, bullet)
                end
            end
        end

        return true
    end
end)

function VNP.Inventory:CreateExplosion(pos, damage, damageRadius, effectRadius, duration, attacker) // Totally didn't steal
    if(SERVER) then
		if(!IsValid(attacker) || !attacker:IsPlayer()) then return end
		
		local wep = attacker:GetActiveWeapon()
		if(!IsValid(wep)) then return end

		util.BlastDamage(wep, attacker, pos, damageRadius, damage)
	else
        local dist = LocalPlayer():GetPos():DistToSqr(pos)

        if dist > 1000000 then return end

		local emitter = ParticleEmitter(Vector())
		local offset = Vector(0, 0, 3)

		for i = 1, 20 do
			local prt = emitter:Add(("particle/smokesprites_%04d"):format(math.random(1, 16)), pos + offset)
			prt:SetVelocity(VectorRand() * effectRadius * 5)
			prt:SetDieTime(duration)
			prt:SetStartAlpha(20)
			prt:SetEndAlpha(0)
			prt:SetStartSize(effectRadius * 2)
			prt:SetEndSize(effectRadius * 5)
			prt:SetLighting(true)
			prt:SetColor(Color(0, 0, 0))
		end

		for i = 1, 40 do
			local prt = emitter:Add("particles/flamelet"..math.random(1,5), pos + offset)
			prt:SetVelocity(VectorRand() * effectRadius * 5)
			prt:SetDieTime(duration)
			prt:SetStartAlpha(50)
			prt:SetEndAlpha(0)
			prt:SetStartSize(0)
			prt:SetEndSize(effectRadius * 2)
		end

		timer.Simple(duration, function()
			if(IsValid(emitter)) then emitter:Finish() end
		end)
	end
end

DMG_DOT = 32768

// I feel pain
/*
    Create an curve system fo suit hp
*/

RunString([[
 /*
  Copyright notice:
  This code is the property of Kaiser and Titanium Networks. It may not be used or reproduced without written permission from the authors.
  Any unauthorized use of this code is strictly prohibited.

  For inquiries or permissions, please contact Kaiser or Titanium Networks.

  Legal Disclaimer:
  This code is provided as-is, without any warranty or guarantee of its functionality or suitability for any purpose. The authors shall not be held responsible for any damages or liabilities arising from the use of this code.

  Additional Notice:
  The modified portions of this code are the exclusive property of Kaiser. Any use of the modified code without written permission is strictly prohibited. If you require further clarification, it is advised to seek legal counsel.
/*

/*
    Addon note for kevin sanchez
    (THIS IS NOT LEGAL ADIVE NOR SHALL BE TAKEN AS SUCH)
    Hi Kevin!👋 Yes you kevin sanchez! Let me give you a great note. You can not dmca me as i am on great legal standing for the use of these addons and anything else barry bennet gave me :) If you think you have a case take a second get legal counsel and ask them "if someone is in charge of everything for vnp and your damn lead dev and all others thought he owned it"
    Even you said "barry deals with everything you just pay" damn.
    Sucks to suck? IG?
    Anyways your dmca will be ingored and fought with some counter action tbh if you even try
    Biarry doesnt exists schizo retard
*/

/*
    Note for lukas!
    (THIS IS NOT LEGAL ADIVE NOR SHALL BE TAKEN AS SUCH)
    First of all why are you lua stealing?Skid paster!
    KAC >> All ur code
    Second.Why do you need to take everything i say out of context? Is it to make you feel better?
    Third. I live rent free in ur head and you know it
    And to finsh it off
    You are a skid and a paster Who is failing english and only has a C in critical thinking(makes sense doesnt it?)
*/

]] , "Copyright Notice © Kaiser & Titanium Networks")

function VNP.Inventory:FindTimesCurve(key , type , real) // Returns {min = int , max = int}
    if type == "suit" then
        return VNP.Inventory.SuitCurve[real][key]
    elseif (type == "gem") then
        return VNP.Inventory.GemCurve[key]
    end
        
end

function VNP.Inventory:GetTheTimes(curve)
    local min,max = curve.min,curve.max
    local times = math.Rand(min , max)
    return times
end


function cangetsuitother(current_stats) // cringe since 1452
    --PrintTable(current_stats)
    local chance1,chance2 = 5,math.random(10000)/100
    local suitpower = {
        'SuitRegen',
        'SuitResist',
        'SuitSpeed',
        --'SuitEnergyResist',
        --'SuitArrestHits',
        --'SuitJump'
    }

    function notacustomranom(max_value, bias_factor)
        bias_factor = bias_factor or 2
        return math.random(max_value)
    end

    local hard_caps = {
        ['SuitRegen'] = 85,
        ['SuitResist'] = 60,
        ['SuitSpeed'] = 1000,
        --['SuitEnergyResist'] = 95,
        --['SuitArrestHits'] = 10,
        --['SuitJump'] = 500
    }

    local per_upgrade = {
        ['SuitRegen'] = 15,
        ['SuitResist'] = 10,
        ['SuitSpeed'] = 300,
        --['SuitEnergyResist'] = 25,
        --['SuitArrestHits'] = 2,
        --['SuitJump'] = 200
    }

    local stats = {}

    for k , v in pairs(suitpower) do
        --print(k ,"Key" , v , "Value")
        local suit_thinger = v
        if chance1 > math.random(10000)/100 then
            --print("We should set stats here")
            local up = notacustomranom(per_upgrade[v] , per_upgrade[v]/2)
            if up == 0 then
                up = 1
            end
            current_stats[v] = current_stats[v] or 0
            --print(current_stats[v] , up)
            current_stats[v] = current_stats[v] + up
            if current_stats[v] > hard_caps[v] then
                current_stats[v] = hard_caps[v]
            end
            --print(true , suit_thinger , current_stats[v] ," <--")
            table.insert(stats, {suit_thinger, current_stats[v]})
        end
    end
    return #stats > 0, stats
end
local function erm(input) // to lazy to do math.round each time
    return math.Round(input , 2)
end


function VNP.Inventory:GetRealSuitHP(current , level)
    local curve = VNP.Inventory:FindTimesCurve(level , "suit" , "Health")
    local times = VNP.Inventory:GetTheTimes(curve)
    return math.Round(current * times)
end
function VNP.Inventory:GetRealSuitArmor(current , level)
    local curve = VNP.Inventory:FindTimesCurve(level , "suit" , "Armor")
    local times = VNP.Inventory:GetTheTimes(curve)
    return math.Round(current * times)
end

/*
    Semirushed
*/

function VNP.Inventory:UpgradeGem(base_value, level, gem_class, real, e)
    gem_class = string.lower(gem_class)
    --print("base_value" , base_value)
    local curve = VNP.Inventory:FindTimesCurve(level, "gem")
    local times = VNP.Inventory:GetTheTimes(curve)

    if gem_class == "damage" then
        local backup = VNP.Inventory:OnGemMade("Damage")
        real["Damage"] = e["MaxDamage"] or backup
        local _per = math.Round(real["Damage"] * times, 2)
        real["SuitRegen"] = e["MaxSuitRegen"] or (backup / 2)
        print("Damage == ", _per * real["Damage"])

        if _per > 100 then
            _per = 100
        end

        real["Damage"] = _per
        e["MaxDamage"] = real["Damage"]
        real["SuitRegen"] = math.Round(_per / 2, 2)
        e["MaxSuitRegen"] = real["SuitRegen"]
    elseif gem_class == "permanent gem" then
        local backup = VNP.Inventory:OnGemMade("Permanent Gem")
        real["regainchance"] = e["MaxRegainChange"] or backup
        local _per = math.Round(real["regainchance"] * times, 2)
        if _per > 100 then
            _per = 100
        end
        real["regainchance"] = _per
        e["MaxRegainChange"] = real["regainchance"]
    elseif (gem_class == "overload") then
        local backup = VNP.Inventory:OnGemMade("Overload")
        real["Damage"] = e["MaxDamage"] or backup
        real["RPM"] = e["MaxRPM"] or backup
        real["SuitResist"] = e["MaxSuitResist"] or backup
        local _per = math.Round(real["Damage"] * times, 2)
        real["Damage"] = _per
        e["MaxDamage"] = real["Damage"]
        real["RPM"] = _per
        e["MaxRPM"] = real["RPM"]
        real["SuitResist"] = erm(_per / 2)
        e["MaxSuitResist"] = real["SuitResist"]
    elseif (gem_class == "fire") then
        local backup = VNP.Inventory:OnGemMade("Fire")
        real["firechance"] = e["MaxFireChance"] or backup
        local _per = math.Round(real["firechance"] * times, 2)
        real["firechance"] = _per
        e["MaxFireChance"] = real["firechance"]
        real["fireresist"] = _per
        e["MaxFireResist"] = real["fireresist"]
    elseif (gem_class == "infinite gem") then
        local backup = VNP.Inventory:OnGemMade("Infinite Gem")
        real["ClipSize"] = e["MaxClipSize"] or backup
        local _per = math.Round(real["ClipSize"] * times, 2)
        real["ClipSize"] = _per
        e["MaxClipSize"] = real["ClipSize"]
        real["SuitRegen"] = erm(_per / 2)
        e["MaxSuitRegen"] = real["SuitRegen"]
    elseif (gem_class == "accuracy") then
        local backup = VNP.Inventory:OnGemMade("Accuracy")
        real["Spread"] = e["MaxSpread"] or backup
        local _per = math.Round(real["Spread"] * times, 2)
        real["Spread"] = _per
        e["MaxSpread"] = real["Spread"]
    elseif (gem_class == "arrest immunity") then
        local backup = VNP.Inventory:OnGemMade("Arrest Immunity")
        real["SuitArrestHits"] = e["MaxSuitArrestHits"] or backup
        local _per = real["SuitArrestHits"] + 1
        real["SuitArrestHits"] = _per
        e["MaxSuitArrestHits"] = real["SuitArrestHits"]
        
    elseif (gem_clas == "electrocute") then
        local backup = VNP.Inventory:OnGemMade("Electrocute")
        real["electrocuteresist"] = e["Maxelectrocuteresist"] or backup
        local _per = math.Round(real["electrocuteresist"] * times, 2)
        if _per > 100 then
            _per = 100
        end
        real["electrocuteresist"] = _per
        e["Maxelectrocuteresist"] = real["electrocuteresist"]
        real["electrocutechance"] = erm(_per / 2)
        e["Maxelectrocutechance"] = real["electrocutechance"]
    elseif (gem_class == "energy") then
        local backup = VNP.Inventory:OnGemMade("Energy")
        real["SuitEnergyResist"] = e["MaxSuitEnergyResist"] or backup
        local _per = math.Round(real["SuitEnergyResist"] * times, 2)
        if _per > 100 then
            _per = 100
        end
        real["SuitEnergyResist"] = _per
        e["MaxSuitEnergyResist"] = real["SuitEnergyResist"]
        real["energydamage"] = _per
        e["Maxenergydamage"] = real["energydamage"]
    elseif (gem_class == "explosive") then
        local backup = VNP.Inventory:OnGemMade("Explosive")
        real["explosivechance"] = e["Maxexplosivechance"] or backup
        local _per = math.Round(real["explosivechance"] * times, 2)
        if _per > 100 then
            _per = 100
        end
        real["explosivechance"] = _per
        e["Maxexplosivechance"] = real["explosivechance"]
        real["explosivedamage"] = _per
        e["Maxexplosivedamage"] = real["explosivedamage"]
        real["explosiveresist"] = _per
        e["Maxexplosiveresist"] = real["explosiveresist"]
        real["explosiveresistamt"] = _per
        e["Maxexplosiveresistamt"] = real["explosiveresistamt"]

    elseif gem_class == "freeze" then
        local backup = VNP.Inventory:OnGemMade("Freeze")
        real["freezeresist"] = e["Maxfreezeresist"] or backup
        local _per = math.Round(real["freezeresist"] * times, 2)
        if _per > 100 then
            _per = 100
        end
        real["freezeresist"] = _per
        e["Maxfreezeresist"] = real["freezeresist"]
        real["freezechance"] = erm(_per / 2)
        e["Maxfreezechance"] = real["freezechance"]
        real["freezetime"] = erm(_per * 3)
        e["Maxfreezetime"] = real["freezetime"]
    elseif (gem_class == "knockback") then
    local backup = VNP.Inventory:OnGemMade("Knockback")
        real["knockbackchance"] = e["Maxknockbackchance"] or backup
        local _per = math.Round(real["knockbackchance"] * times, 2)
        if _per > 100 then
            _per = 100
        end
        real["knockbackchance"] = _per
        e["Maxknockbackchance"] = real["knockbackchance"]
        real["resistknockback"] = _per
        e["Maxresistknockback"] = real["resistknockback"]
    elseif (gem_class == "lifesteal") then
        local backup = VNP.Inventory:OnGemMade("Lifesteal")
        real["lifesteal"] = e["Maxlifesteal"] or backup
        local _per = math.Round(real["lifesteal"] * times, 2)
        if _per > 100 then
            _per = 100
        end
        real["lifesteal"] = _per
        e["Maxlifesteal"] = real["lifesteal"]
        real["lifestealperc"] = erm(_per / 2)
        e["Maxlifestealperc"] = real["lifestealperc"]
        real["resistlifesteal"] = _per
        e["Maxresistlifesteal"] = real["resistlifesteal"]
    elseif (gem_class == "paralyze") then
        local backup = VNP.Inventory:OnGemMade("Paralyze")
        real["paralyzeresist"] = e["Maxparalyzeresist"] or backup
        local _per = math.Round(real["paralyzeresist"] * times, 2)
        if _per > 100 then
            _per = 100
        end
        real["paralyzeresist"] = _per
        e["Maxparalyzeresist"] = real["paralyzeresist"]
        real["paralyzechance"] = erm(_per / 2)
        e["Maxparalyzechance"] = real["paralyzechance"]
    elseif (gem_class == "poison") then
        local backup = VNP.Inventory:OnGemMade("Poison")
        real["poisonresist"] = e["Maxpoisonresist"] or backup
        local _per = math.Round(real["poisonresist"] * times, 2)
        if _per > 100 then
            _per = 100
        end
        real["poisonresist"] = _per
        e["Maxpoisonresist"] = real["poisonresist"]
        real["poisonchance"] = erm(_per / 2)
        e["Maxpoisonchance"] = real["poisonchance"]
    elseif (gem_class == "recoil") then
        local backup = VNP.Inventory:OnGemMade("Recoil")
        real["KickUp"] = e["MaxKickUp"] or backup
        local _per = math.Round(real["KickUp"] * times, 2)
        if _per < -100 then
            _per = -100
        end
        real["KickUp"] = _per
        e["MaxKickUp"] = real["KickUp"]
        real["SuitArmor"] = math.abs(_per)
        e["MaxSuitArmor"] = real["SuitArmor"]
    end
end

function VNP.Inventory:OnGemMade(gem_class)
    gem_class = string.lower(gem_class)

    if gem_class == "accuracy" then
        local base = math.Rand(-11, -1)
        if base < -10 then
            base = -10
        end
        --base = 10
        return math.Round(base , 2)
    elseif gem_class == "arrest immunity" then
        base = math.Rand(0, 3)
        return math.Round(base , 2)
    elseif (gem_class == "overload") then
        local base = math.Rand(1, 7) // should be kinda like the old overload
        --base = 10
        return math.Round(base , 2)
    elseif (gem_class == "recoil") then
        local base = math.Rand(-11, -1)
        if base < -10 then
            base = -10
        end
        --base = 10
        return math.Round(base , 2)
    end
    local base = math.Rand(1, 11)
    if base > 10 then
        base = 10
    end
    return erm(base)
end




function VNP.Inventory:GemSetStatsFirst(base, gem_class, Item)
    gem_class = string.lower(gem_class)
    if gem_class == "damage" then
        Item["MaxDamage"] = base
        local real = Item.Modifiers
        Item["MaxSuitRegen"] = erm(base / 2)
        real["Damage"] = base
        real["SuitRegen"] = erm(base / 2)
    elseif gem_class == "permanent gem" then
        Item["MaxRegainChange"] = base
        local real = Item.Modifiers
        real["regainchance"] = base
    elseif gem_class == "double tap" then
        Item["Maxdoublechance"] = base
        Item["Maxhalfdamage"] = base
        local real = Item.Modifiers
        real["doublechance"] = base
        real["halfdamage"] = base
    elseif gem_class == "overload" then
        Item["MaxDamage"] = base
        Item["MaxRPM"] = base
        Item["MaxSuitResist"] = erm(base / 2)
        local real = Item.Modifiers
        real["Damage"] = base
        real["RPM"] = base
        real["SuitResist"] = erm(base / 2)
    elseif gem_class == "fire" then
        --print("is fire")
        Item["Maxfirechance"] = base
        Item["Maxfireresist"] = base
        local real = Item.Modifiers
        real["firechance"] = base
        real["fireresist"] = base
    elseif (gem_class == "infinite gem") then
        Item["MaxClipSize"] = base
        Item["MaxSuitRegen"] = erm(base / 2)
        local real = Item.Modifiers
        real["ClipSize"] = base
        real["SuitRegen"] = erm(base / 2)
        
    elseif (gem_class == "accuracy") then
        Item["MaxSpread"] = base
        local real = Item.Modifiers
        real["Spread"] = base
    elseif (gem_class == "arrest immunity") then
        Item["MaxSuitArrestHits"] = base
        local real = Item.Modifiers
        real["SuitArrestHits"] = base
    elseif (gem_class == "electrocute") then
        Item["Maxelectrocutechance"] = erm(base / 2)
        Item["Maxelectrocuteresist"] = base
        local real = Item.Modifiers
        real["electrocutechance"] = erm(base / 2)
        real["electrocuteresist"] = base
    elseif (gem_class == "energy") then
        Item["MaxSuitEnergyResist"] = base
        Item["Maxenergydamage"] = base
        local real = Item.Modifiers
        real["SuitEnergyResist"] = base
        real["energydamage"] = base
    elseif (gem_class == "explosive") then
        Item["Maxexplosivechance"] = base
        Item["Maxexplosivedamage"] = base
        Item["Maxexplosiveresist"] = base
        Item["Maxexplosiveresistamt"] = base
        local real = Item.Modifiers
        real["explosivechance"] = base
        real["explosivedamage"] = base
        real["explosiveresist"] = base
        real["explosiveresistamt"] = base
    elseif (gem_class == "freeze") then
        Item["Maxfreezeresist"] = base
        Item["Maxfreezechance"] = erm(base / 2)
        Item["Maxfreezetime"] = erm( base * 3)
        local real = Item.Modifiers
        real["freezeresist"] = base
        real["freezechance"] = erm(base / 2)
        real["freezetime"] = erm( base * 3)
    elseif (gem_class == "knockback") then
        Item["Maxknockbackchance"] = base
        Item["Maxresistknockback"] = base
        local real = Item.Modifiers
        real["knockbackchance"] = base
        real["resistknockback"] = base
    elseif (gem_class == "lifesteal") then
        Item["Maxlifesteal"] = base
        Item["Maxlifestealperc"] = erm(base / 2)
        Item["Maxresistlifesteal"] = base
        local real = Item.Modifiers
        real["lifesteal"] = base
        real["lifestealperc"] = erm(base / 2)
        real["resistlifesteal"] = base
    elseif (gem_class == "paralyze") then
        Item["Maxparalyzechance"] = erm(base / 2)
        Item["Maxparalyzeresist"] = base
        local real = Item.Modifiers
        real["paralyzechance"] = erm(base / 2)
        real["paralyzeresist"] = base
    elseif (gem_class == "poison") then
        Item["Maxpoisonchance"] = erm(base / 2)
        Item["Maxpoisonresist"] = base
        local real = Item.Modifiers
        real["poisonchance"] = erm(base / 2)
        real["poisonresist"] = base
    elseif (gem_class == "radiation") then
        Item["Maxradiateresist"] = base
        Item["Maxradiatechance"] = erm(base / 2)
        local real = Item.Modifiers
        real["radiateresist"] = base
        real["radiatechance"] = erm(base / 2)
    elseif (gem_class == "recoil") then
        Item["MaxKickUp"] = base
        Item["MaxSuitArmor"] = math.abs(base)
        local real = Item.Modifiers
        real["KickUp"] = base
        real["SuitArmor"] = math.abs(base)
    elseif (gem_clsas == "void") then
        Item["Maxresistvoid"] = base
        Item["Maxvoidchance"] = erm(base / 2)
        local real = Item.Modifiers
        real["resistvoid"] = base
        real["voidchance"] = erm(base / 2)
    end
end
