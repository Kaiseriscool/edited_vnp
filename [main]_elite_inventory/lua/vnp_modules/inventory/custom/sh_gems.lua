

VNP.Inventory.Items["GEM"] = {}

local GEM = {}

function VNP.Inventory:RegisterGem(data)
    if !data.Name then return end

    data.Material = "models/debug/debugwhite"
    data.Color = data.Color or Color(255,255,255)

    VNP.Inventory.Items["GEM"][data.Name] = data

    if data.Hooks then
        for name, func in pairs(data.Hooks) do
            hook.Add(name, "VNP.Inventory."..data.Name, func)
        end
    end

    GEM = {}
end

local function damageDOT(target, attacker, damage, time, reps, color, canDoDamage, onEnd) // Aight
    
    local name = "VNP.DOT.Timer."..target:SteamID64()
    
    local delay = 0

    local func = function()
        if !IsValid(target) then return end
        if canDoDamage(target) then return end

        if SERVER then
            local d = DamageInfo()
            d:SetDamage(damage)
            d:SetAttacker(attacker)
            d:SetDamageType(DMG_DOT) 
        
            target:TakeDamageInfo(d)

            if color && CurTime() > delay then
                delay = CurTime()+0.6
                VNP:Broadcast("VNP.DOTParticle", {target = target, color = color})
            end
        end

        if timer.RepsLeft(name) < 1 && onEnd then
            onEnd(target)
        end
    end

    if timer.Exists(name) then
        timer.Adjust(name, time, reps, func)
    else
        timer.Create(name, time, reps, func)
    end
end
 


--[[
    Example Gem

GEM.Name = "Example Gem"
GEM.Description = "Increases Fire rate on hit"

GEM.Model = "models/props_phx2/garbage_metalcan001a.mdl" -- model for display when dropped or display in inventory

GEM.Icon  = "" -- If you wish to use an icon to display in inventory instead then you can use an imgur link

GEM.Modifiers = { -- This will be modifiers that define the base modifications for the weapon if there is a stat that lines up with the weapon it will multiply it by this value/100
    ["firedelay"] = {min = 5, max = 20} -- Allows you to modify any weapon table
}

GEM.OnHit = function(target, gem, wep) -- The function that runs when you hit your enemy...
    local chance = math.random(10000)/100
    
    if chance <= gem.Modifier["firedmg"] then
        target:Ignite(5)
    end
end

GEM.OnOwnerHit = function(owner, attacker, item, dmginfo) -- function that runs when the owner is hit...
    if !item:IsSuit() then return end
    
end

GEM.OnEquip = function(owner, gem, wep) -- function that runs when the owner equips this item...
end

GEM.OnUnequip = function(owner, gem, wep) -- function that runs when the owner unequips this item...
end

GEM.OnPlayerDeath = function(ply, item, gem, socket)
end

GEM.Hooks = { -- Add any hook with a ply argument
}

VNP.Inventory:RegisterGem(GEM)
]]--
------------------------------

--[[
    Fire Gem
]]--

GEM.Name = "Fire"
GEM.Description = "Chance to ignite your enemy"

GEM.Color = Color(225, 100, 50, 255)
GEM.Model = "models/props_phx2/garbage_metalcan001a.mdl" -- model for display when dropped or display in inventory

GEM.Modifiers = { -- This will be modifiers that define the base modifications for the weapon if there is a stat that lines up with the weapon it will multiply it by this value/100
    ["Common"] = {
        ["firechance"] = {min = 1, max = 10},
        ["fireresist"] = {min = 1, max = 10},
    },
    ["Uncommon"] = {
        ["firechance"] = {min = 10, max = 20},
        ["fireresist"] = {min = 10, max = 20},
    },
    ["Rare"] = {
        ["firechance"] = {min = 20, max = 30},
        ["fireresist"] = {min = 20, max = 30},
    },
    ["Epic"] = {
        ["firechance"] = {min = 30, max = 40},
        ["fireresist"] = {min = 30, max = 40},
    },
    ["Legendary"] = {
        ["firechance"] = {min = 40, max = 60},
        ["fireresist"] = {min = 40, max = 60},
    },
    ["Celestial"] = {
        ["firechance"] = {min = 60, max = 75},
        ["fireresist"] = {min = 60, max = 75},
    },
    ["God"] = {
        ["firechance"] = {min = 75, max = 85},
        ["fireresist"] = {min = 75, max = 85},
    },
    ["Glitched"] = {
        ["firechance"] = {min = 85, max = 100},
        ["fireresist"] = {min = 85, max = 100},
    },
}

GEM.OnHit = function(target, item, wep, dmginfo) -- The function that runs when you hit your enemy...
    local chance = math.random(10000)/100

    if chance <= item.Modifiers["firechance"] && target:IsPlayer() then
        local shouldIgnite = hook.Run("ShouldIgnite", target)

        if shouldIgnite then return end

        target:Ignite(5)
    end
end

GEM.Hooks = {
    ["ShouldIgnite"] = function(ply)
        local data = ply.GetSuit and ply:GetSuit()

        if !data then return end
        if !data.Sockets then return end

        local chance = math.random(10000)/100

        for name, gem in pairs(data.Sockets) do
            if gem and gem.Modifiers and gem.Modifiers["fireresist"] then
                local fireResistChance = gem.Modifiers["fireresist"]
                if chance <= fireResistChance then return true end
            end
        end
    end,
}

VNP.Inventory:RegisterGem(GEM)

--[[
    Overload
]]--

GEM.Name = "Overload"
GEM.Description = "Increases Damage, firerate or resistance."

GEM.Color = Color(100, 225, 100, 255)
GEM.Model = "models/props_phx2/garbage_metalcan001a.mdl" -- model for display when dropped or display in inventory

GEM.Modifiers = { -- Aids but works
    ["Common"] = {
        ["Damage"] = {min = 1, max = 5},
        ["RPM"] = {min = 1, max = 5},
        ["SuitResist"] = {min = 1, max = 2},
    },
    ["Uncommon"] = {
        ["Damage"] = {min = 5, max = 10},
        ["RPM"] = {min = 5, max = 10},
        ["SuitResist"] = {min = 2, max = 4},
    },
    ["Rare"] = {
        ["Damage"] = {min = 10, max = 15},
        ["RPM"] = {min = 10, max = 15},
        ["SuitResist"] = {min = 4, max = 6},
    },
    ["Epic"] = {
        ["Damage"] = {min = 15, max = 20},
        ["RPM"] = {min = 15, max = 20},
        ["SuitResist"] = {min = 6, max = 8},
    },
    ["Legendary"] = {
        ["Damage"] = {min = 20, max = 30},
        ["RPM"] = {min = 20, max = 30},
        ["SuitResist"] = {min = 8, max = 12},
    },
    ["Celestial"] = {
        ["Damage"] = {min = 30, max = 40},
        ["RPM"] = {min = 30, max = 40},
        ["SuitResist"] = {min = 12, max = 15},
    },
    ["God"] = {
        ["Damage"] = {min = 40, max = 50},
        ["RPM"] = {min = 40, max = 50},
        ["SuitResist"] = {min = 15, max = 20},
    },
    ["Glitched"] = {
        ["Damage"] = {min = 50, max = 70},
        ["RPM"] = {min = 50, max = 70},
        ["SuitResist"] = {min = 20, max = 30},
    },
}

VNP.Inventory:RegisterGem(GEM)

--[[
    Poison Gem
]]--

GEM.Name = "Poison"
GEM.Description = "Chance to infect your enemies."

GEM.Color = Color(0, 255, 0, 255)
GEM.Model = "models/props_phx2/garbage_metalcan001a.mdl" -- model for display when dropped or display in inventory

GEM.Modifiers = { -- This will be modifiers that define the base modifications for the weapon if there is a stat that lines up with the weapon it will multiply it by this value/100
    ["Common"] = {
        ["poisonchance"] = {min = 1, max = 5},
        ["poisonresist"] = {min = 1, max = 10},
    },
    ["Uncommon"] = {
        ["poisonchance"] = {min = 5, max = 10},
        ["poisonresist"] = {min = 10, max = 20},
    },
    ["Rare"] = {
        ["poisonchance"] = {min = 10, max = 25},
        ["poisonresist"] = {min = 20, max = 30},
    },
    ["Epic"] = {
        ["poisonchance"] = {min = 25, max = 30},
        ["poisonresist"] = {min = 30, max = 40},
    },
    ["Legendary"] = {
        ["poisonchance"] = {min = 30, max = 40},
        ["poisonresist"] = {min = 40, max = 60},
    },
    ["Celestial"] = {
        ["poisonchance"] = {min = 40, max = 45},
        ["poisonresist"] = {min = 60, max = 75},
    },
    ["God"] = {
        ["poisonchance"] = {min = 45, max = 55},
        ["poisonresist"] = {min = 75, max = 85},
    },
    ["Glitched"] = {
        ["poisonchance"] = {min = 55, max = 60},
        ["poisonresist"] = {min = 85, max = 100},
    },
}

GEM.OnHit = function(target, item, wep, dmginfo) -- The function that runs when you hit your enemy...
    local chance = math.random(10000)/100
    local ply = dmginfo:GetAttacker()


    if chance <= item.Modifiers["poisonchance"] && target:IsPlayer() then

        -- target, attacker, damage, time, reps, canDoDamage

        damageDOT(target, ply, 1, 0.2, 25, Color(100, 200 + math.random() * 55, 100), function(pl)
            if !IsValid(pl) then return end

            local data = pl.GetSuit and pl:GetSuit()

            if !data then return end
            if !data.Sockets then return end

            local chance = math.random(10000)/100

            for name, gem in pairs(data.Sockets) do
                if gem and gem.Modifiers and gem.Modifiers["poisonresist"] then
                    local poisonResistChance = gem.Modifiers["poisonresist"]
                    if chance <= poisonResistChance then return false end
                end
            end
            return true
        end)
    end
end

GEM.Hooks = {
    ["PlayerDeath"] = function(ply)
        local name = "VNP.DOT.Timer."..ply:SteamID64()
        timer.Remove(name)
    end,
}

VNP.Inventory:RegisterGem(GEM)

--[[
    Lifesteal Gem
]]--

GEM.Name = "Lifesteal"
GEM.Description = "Using on weapons grants lifesteal.\n Using on armor will resist it sometimes."

GEM.Color = Color(150, 0, 0, 255)
GEM.Model = "models/props_phx2/garbage_metalcan001a.mdl" -- model for display when dropped or display in inventory

GEM.Modifiers = { -- This will be modifiers that define the base modifications for the weapon if there is a stat that lines up with the weapon it will multiply it by this value/100
    ["Common"] = {
        ["lifesteal"] = {min = 1, max = 20},
        ["lifestealperc"] = {min = 1, max = 10},
        ["resistlifesteal"] = {min = 1, max = 20},
    },
    ["Uncommon"] = {
        ["lifesteal"] = {min = 20, max = 30},
        ["lifestealperc"] = {min = 5, max = 10},
        ["resistlifesteal"] = {min = 20, max = 30},
    },
    ["Rare"] = {
        ["lifesteal"] = {min = 30, max = 40},
        ["lifestealperc"] = {min = 10, max = 15},
        ["resistlifesteal"] = {min = 30, max = 40},
    },
    ["Epic"] = {
        ["lifesteal"] = {min = 40, max = 50},
        ["lifestealperc"] = {min = 15, max = 20},
        ["resistlifesteal"] = {min = 40, max = 50},
    },
    ["Legendary"] = {
        ["lifesteal"] = {min = 50, max = 60},
        ["lifestealperc"] = {min = 20, max = 30},
        ["resistlifesteal"] = {min = 50, max = 60},
    },
    ["Celestial"] = {
        ["lifesteal"] = {min = 60, max = 70},
        ["lifestealperc"] = {min = 30, max = 35},
        ["resistlifesteal"] = {min = 60, max = 70},
    },
    ["God"] = {
        ["lifesteal"] = {min = 70, max = 80},
        ["lifestealperc"] = {min = 35, max = 40},
        ["resistlifesteal"] = {min = 70, max = 80},
    },
    ["Glitched"] = {
        ["lifesteal"] = {min = 80, max = 90},
        ["lifestealperc"] = {min = 40, max = 50},
        ["resistlifesteal"] = {min = 80, max = 90},
    },
}

GEM.OnHit = function(target, item, wep, dmginfo) -- The function that runs when you hit your enemy...
    local chance = math.random(10000)/100
    local ply = dmginfo:GetAttacker()

    if chance <= item.Modifiers["lifesteal"] && target:IsPlayer() then
        local shouldLifeSteal = hook.Run("shouldLifeSteal", target)

        if shouldLifeSteal then return end

        local healAmt = dmginfo:GetDamage()*(item.Modifiers["lifesteal"]/100)

        local health = ply:Health()

        ply:SetHealth(math.min(health+healAmt, ply:GetMaxHealth()))
    end
end

GEM.Hooks = {
    ["shouldLifeSteal"] = function(ply)
        local data = ply.GetSuit and ply:GetSuit()

        if !data then return end
        if !data.Sockets then return end

        local chance = math.random(10000)/100

        for name, gem in pairs(data.Sockets) do
            if gem and gem.Modifiers and gem.Modifiers["resistlifesteal"] then
                local lifestealResistChance = gem.Modifiers["resistlifesteal"]
                if chance <= lifestealResistChance then return true end
            end
        end
    end
}

VNP.Inventory:RegisterGem(GEM)

--[[
    Void Gem
]]--

GEM.Name = "Void"
GEM.Description = "Chance to void your enemies."

GEM.Color = Color(85, 85, 85, 255)
GEM.Model = "models/props_phx2/garbage_metalcan001a.mdl" -- model for display when dropped or display in inventory

GEM.Modifiers = { -- This will be modifiers that define the base modifications for the weapon if there is a stat that lines up with the weapon it will multiply it by this value/100
    ["Common"] = {
        ["voidchance"] = {min = 1, max = 5},
        ["resistvoid"] = {min = 1, max = 10},
    },
    ["Uncommon"] = {
        ["voidchance"] = {min = 5, max = 10},
        ["resistvoid"] = {min = 10, max = 20},
    },
    ["Rare"] = {
        ["voidchance"] = {min = 10, max = 25},
        ["resistvoid"] = {min = 20, max = 30},
    },
    ["Epic"] = {
        ["voidchance"] = {min = 25, max = 30},
        ["resistvoid"] = {min = 30, max = 40},
    },
    ["Legendary"] = {
        ["voidchance"] = {min = 30, max = 40},
        ["resistvoid"] = {min = 40, max = 60},
    },
    ["Celestial"] = {
        ["voidchance"] = {min = 40, max = 45},
        ["resistvoid"] = {min = 60, max = 75},
    },
    ["God"] = {
        ["voidchance"] = {min = 45, max = 55},
        ["resistvoid"] = {min = 75, max = 85},
    },
    ["Glitched"] = {
        ["voidchance"] = {min = 55, max = 60},
        ["resistvoid"] = {min = 85, max = 100},
    },
}

GEM.OnHit = function(target, item, wep, dmginfo) -- The function that runs when you hit your enemy...
    local chance = math.random(10000)/100
    local ply = dmginfo:GetAttacker()

    if chance <= item.Modifiers["voidchance"] && target:IsPlayer() then
        local shouldVoid = hook.Run("shouldVoid", target)

        if shouldVoid then return end

        local pos = (ply:GetPos() - target:GetPos())
		pos = pos/pos:Length()
		target:SetVelocity(pos*500+Vector(0, 0, 100))
    end
end

GEM.Hooks = {
    ["shouldVoid"] = function(ply)
        local data = ply.GetSuit and ply:GetSuit()

        if !data then return end
        if !data.Sockets then return end

        local chance = math.random(10000)/100

        for name,gem in pairs(data.Sockets) do
            if gem and gem.Modifiers and gem.Modifiers["resistvoid"] then
                local voidResistChance = gem.Modifiers["resistvoid"] -- probably..??!?!@!?@?!#??!@#?
                if chance <= voidResistChance then return true end
            end
        end
    end,
}

VNP.Inventory:RegisterGem(GEM)

--[[
    Knockback Gem
]]--

GEM.Name = "Knockback"
GEM.Description = "Add knockback to your shots."

GEM.Color = Color(100, 100, 100, 255)
GEM.Model = "models/props_phx2/garbage_metalcan001a.mdl" -- model for display when dropped or display in inventory

GEM.Modifiers = { -- This will be modifiers that define the base modifications for the weapon if there is a stat that lines up with the weapon it will multiply it by this value/100
    ["Common"] = {
        ["knockbackchance"] = {min = 1, max = 5},
        ["resistknockback"] = {min = 1, max = 10},
    },
    ["Uncommon"] = {
        ["knockbackchance"] = {min = 5, max = 10},
        ["resistknockback"] = {min = 10, max = 20},
    },
    ["Rare"] = {
        ["knockbackchance"] = {min = 10, max = 25},
        ["resistknockback"] = {min = 20, max = 30},
    },
    ["Epic"] = {
        ["knockbackchance"] = {min = 25, max = 30},
        ["resistknockback"] = {min = 30, max = 40},
    },
    ["Legendary"] = {
        ["knockbackchance"] = {min = 30, max = 40},
        ["resistknockback"] = {min = 40, max = 60},
    },
    ["Celestial"] = {
        ["knockbackchance"] = {min = 40, max = 45},
        ["resistknockback"] = {min = 60, max = 75},
    },
    ["God"] = {
        ["knockbackchance"] = {min = 45, max = 55},
        ["resistknockback"] = {min = 75, max = 85},
    },
    ["Glitched"] = {
        ["knockbackchance"] = {min = 55, max = 70},
        ["resistknockback"] = {min = 85, max = 100},
    },
}

GEM.OnHit = function(target, item, wep, dmginfo) -- The function that runs when you hit your enemy...
    local chance = math.random(10000)/100
    local ply = dmginfo:GetAttacker()

    if chance <= item.Modifiers["knockbackchance"] then
        local shouldKnockback = hook.Run("shouldKnockback", target)

        if shouldKnockback then return end

        local pos = (ply:GetPos() - target:GetPos())
		pos = pos/pos:Length()
		target:SetVelocity(pos*-500+Vector(0, 0, 100))
    end
end

GEM.Hooks = {
    ["shouldKnockback"] = function(ply)
        local data = ply.GetSuit and ply:GetSuit()

        if !data then return end
        if !data.Sockets then return end

        local chance = math.random(10000)/100
        for name, gem in pairs(data.Sockets) do
            if gem and gem.Modifiers and gem.Modifiers["resistknockback"] then
                local knockbackResistChance = gem.Modifiers["resistknockback"] -- probably..??!?!@!?@?!#??!@#?
                if chance <= knockbackResistChance then return true end
            end
        end
    end,
}

VNP.Inventory:RegisterGem(GEM)

--[[
    Doubletap Gem
]]--

GEM.Name = "Double Tap"
GEM.Description = "Chance to double your bullets."

GEM.Color = Color(225, 205, 0, 255)
GEM.Model = "models/props_phx2/garbage_metalcan001a.mdl" -- model for display when dropped or display in inventory

GEM.Modifiers = { -- This will be modifiers that define the base modifications for the weapon if there is a stat that lines up with the weapon it will multiply it by this value/100
    ["Common"] = {
        ["doublechance"] = {min = 1, max = 10},
        ["halfdamage"] = {min = 1, max = 10},
    },
    ["Uncommon"] = {
        ["doublechance"] = {min = 10, max = 20},
        ["halfdamage"] = {min = 10, max = 20},
    },
    ["Rare"] = {
        ["doublechance"] = {min = 20, max = 30},
        ["halfdamage"] = {min = 20, max = 30},
    },
    ["Epic"] = {
        ["doublechance"] = {min = 30, max = 40},
        ["halfdamage"] = {min = 30, max = 40},
    },
    ["Legendary"] = {
        ["doublechance"] = {min = 40, max = 60},
        ["halfdamage"] = {min = 40, max = 60},
    },
    ["Celestial"] = {
        ["doublechance"] = {min = 60, max = 75},
        ["halfdamage"] = {min = 60, max = 75},
    },
    ["God"] = {
        ["doublechance"] = {min = 75, max = 85},
        ["halfdamage"] = {min = 75, max = 85},
    },
    ["Glitched"] = {
        ["doublechance"] = {min = 85, max = 100},
        ["halfdamage"] = {min = 85, max = 100},
    },
}

GEM.OnBulletFire = function(ply, gem, wep, bullet) -- will need to test may be too op
    local chance = math.random(10000)/100

    if chance <= gem.Modifiers["doublechance"] then
        bullet.Num = bullet.Num*2
    end
end

GEM.OnOwnerHit = function(owner, attacker, item, dmginfo) -- function that runs when the owner is hit...
    local chance = math.random(10000)/100

    if chance <= item.Modifiers["halfdamage"] then
        dmginfo:ScaleDamage(0.5)
    end
end

VNP.Inventory:RegisterGem(GEM)

--[[
    Explosive Gem
]]--

GEM.Name = "Explosive"
GEM.Description = "Add explosive damage to your bullets."

GEM.Color = Color(20, 20, 20, 255)
GEM.Model = "models/props_phx2/garbage_metalcan001a.mdl" -- model for display when dropped or display in inventory

GEM.Modifiers = { -- This will be modifiers that define the base modifications for the weapon if there is a stat that lines up with the weapon it will multiply it by this value/100
    ["Common"] = {
        ["explosivechance"] = {min = 1, max = 10},
        ["explosivedamage"] = {min = 1, max = 10},

        ["explosiveresist"] = {min = 1, max = 10},
        ["explosiveresistamt"] = {min = 1, max = 10},
    },
    ["Uncommon"] = {
        ["explosivechance"] = {min = 5, max = 10},
        ["explosivedamage"] = {min = 5, max = 10},

        ["explosiveresist"] = {min = 5, max = 10},
        ["explosiveresistamt"] = {min = 5, max = 10},
    },
    ["Rare"] = {
        ["explosivechance"] = {min = 10, max = 15},
        ["explosivedamage"] = {min = 10, max = 15},

        ["explosiveresist"] = {min = 10, max = 20},
        ["explosiveresistamt"] = {min = 10, max = 20},
    },
    ["Epic"] = {
        ["explosivechance"] = {min = 15, max = 20},
        ["explosivedamage"] = {min = 15, max = 20},

        ["explosiveresist"] = {min = 20, max = 30},
        ["explosiveresistamt"] = {min = 15, max = 20},
    },
    ["Legendary"] = {
        ["explosivechance"] = {min = 20, max = 30},
        ["explosivedamage"] = {min = 20, max = 30},

        ["explosiveresist"] = {min = 30, max = 40},
        ["explosiveresistamt"] = {min = 20, max = 30},
    },
    ["Celestial"] = {
        ["explosivechance"] = {min = 30, max = 35},
        ["explosivedamage"] = {min = 30, max = 35},

        ["explosiveresist"] = {min = 40, max = 60},
        ["explosiveresistamt"] = {min = 30, max = 40},
    },
    ["God"] = {
        ["explosivechance"] = {min = 35, max = 40},
        ["explosivedamage"] = {min = 35, max = 40},

        ["explosiveresist"] = {min = 60, max = 70},
        ["explosiveresistamt"] = {min = 40, max = 50},
    },
    ["Glitched"] = {
        ["explosivechance"] = {min = 40, max = 50},
        ["explosivedamage"] = {min = 40, max = 50},

        ["explosiveresist"] = {min = 70, max = 90},
        ["explosiveresistamt"] = {min = 50, max = 60},
    },
}

GEM.OnBulletFire = function(ply, gem, wep, bullet) -- will need to test may be too op
    local chance = math.random(10000)/100

    if chance <= gem.Modifiers["explosivechance"] then
        bullet.Callback = function(attacker, tr, dmginfo)
            local damage = dmginfo:GetDamage()*(1-gem.Modifiers["explosivedamage"]/100)
            VNP.Inventory:CreateExplosion(tr.HitPos, damage, 50, 5, 0.3, attacker)
        end
    end
end

GEM.OnOwnerHit = function(owner, attacker, item, dmginfo) -- function that runs when the owner is hit...
    local chance = math.random(10000)/100

    if dmginfo:IsDamageType(DMG_BLAST) or chance > item.Modifiers["explosiveresist"] then return end

    dmginfo:ScaleDamage((1-item.Modifiers["explosiveresistamt"]/100))
end

VNP.Inventory:RegisterGem(GEM)

--[[
    Damage Gem
]]--

GEM.Name = "Damage"
GEM.Description = "Adds damage to weapon."

GEM.Model = "models/props_phx2/garbage_metalcan001a.mdl" -- model for display when dropped or display in inventory

GEM.Modifiers = { -- Aids but works
    ["Common"] = {
        ["Damage"] = {min = 1, max = 10},
        ["SuitRegen"] = {min = 1, max = 5},
    },
    ["Uncommon"] = {
        ["Damage"] = {min = 10, max = 15},
        ["SuitRegen"] = {min = 5, max = 10},
    },
    ["Rare"] = {
        ["Damage"] = {min = 15, max = 20},
        ["SuitRegen"] = {min = 10, max = 15},
    },
    ["Epic"] = {
        ["Damage"] = {min = 20, max = 30},
        ["SuitRegen"] = {min = 15, max = 20},
    },
    ["Legendary"] = {
        ["Damage"] = {min = 30, max = 50},
        ["SuitRegen"] = {min = 20, max = 30},
    },
    ["Celestial"] = {
        ["Damage"] = {min = 50, max = 70},
        ["SuitRegen"] = {min = 30, max = 40},
    },
    ["God"] = {
        ["Damage"] = {min = 70, max = 80},
        ["SuitRegen"] = {min = 40, max = 50},
    },
    ["Glitched"] = {
        ["Damage"] = {min = 60, max = 79},
        ["SuitRegen"] = {min = 50, max = 65},
    },
}

VNP.Inventory:RegisterGem(GEM)

--[[
    Recoil Gem
]]--

GEM.Name = "Recoil"
GEM.Description = "Reduces weapon recoil."

GEM.Model = "models/props_phx2/garbage_metalcan001a.mdl" -- model for display when dropped or display in inventory

GEM.Modifiers = { -- Aids but works
    ["Common"] = {
        ["KickUp"] = {min = -1, max = -10},
        ["SuitArmor"] = {min = 1, max = 10},
    },
    ["Uncommon"] = {
        ["KickUp"] = {min = -10, max = -15},
        ["SuitArmor"] = {min = 10, max = 15},
    },
    ["Rare"] = {
        ["KickUp"] = {min = -15, max = -20},
        ["SuitArmor"] = {min = 15, max = 20},
    },
    ["Epic"] = {
        ["KickUp"] = {min = -20, max = -30},
        ["SuitArmor"] = {min = 20, max = 30},
    },
    ["Legendary"] = {
        ["KickUp"] = {min = -30, max = -50},
        ["SuitArmor"] = {min = 30, max = 50},
    },
    ["Celestial"] = {
        ["KickUp"] = {min = -50, max = -70},
        ["SuitArmor"] = {min = 50, max = 70},
    },
    ["God"] = {
        ["KickUp"] = {min = -70, max = -80},
        ["SuitArmor"] = {min = 70, max = 80},
    },
    ["Glitched"] = {
        ["KickUp"] = {min = -100, max = -110},
        ["SuitArmor"] = {min = 80, max = 100},
    },
}

VNP.Inventory:RegisterGem(GEM)

--[[
    Infinite Gem
]]--

GEM.Name = "Infinite Gem"
GEM.Description = "Increase weapon clip size."

GEM.Model = "models/props_phx2/garbage_metalcan001a.mdl" -- model for display when dropped or display in inventory

GEM.Modifiers = { -- Aids but works
    ["Common"] = {
        ["ClipSize"] = {min = 1, max = 10},
        ["SuitRegen"] = {min = 1, max = 10},
    },
    ["Uncommon"] = {
        ["ClipSize"] = {min = 10, max = 15},
        ["SuitRegen"] = {min = 10, max = 15},
    },
    ["Rare"] = {
        ["ClipSize"] = {min = 15, max = 20},
        ["SuitRegen"] = {min = 15, max = 20},
    },
    ["Epic"] = {
        ["ClipSize"] = {min = 20, max = 30},
        ["SuitRegen"] = {min = 20, max = 25},
    },
    ["Legendary"] = {
        ["ClipSize"] = {min = 30, max = 50},
        ["SuitRegen"] = {min = 25, max = 30},
    },
    ["Celestial"] = {
        ["ClipSize"] = {min = 50, max = 70},
        ["SuitRegen"] = {min = 30, max = 35},
    },
    ["God"] = {
        ["ClipSize"] = {min = 70, max = 80},
        ["SuitRegen"] = {min = 35, max = 40},
    },
    ["Glitched"] = {
        ["ClipSize"] = {min = 80, max = 100},
        ["SuitRegen"] = {min = 40, max = 50},
    },
}

VNP.Inventory:RegisterGem(GEM)

--[[
    Accuracy Gem
]]--

GEM.Name = "Accuracy"
GEM.Description = "Increase weapon accuracy."

GEM.Model = "models/props_phx2/garbage_metalcan001a.mdl" -- model for display when dropped or display in inventory

GEM.Modifiers = { -- Aids but works
    ["Common"] = {
        ["Spread"] = {min = -1, max = -10},
    },
    ["Uncommon"] = {
        ["Spread"] = {min = -10, max = -15},
    },
    ["Rare"] = {
        ["Spread"] = {min = -15, max = -20},
    },
    ["Epic"] = {
        ["Spread"] = {min = -20, max = -30},
    },
    ["Legendary"] = {
        ["Spread"] = {min = -30, max = -50},
    },
    ["Celestial"] = {
        ["Spread"] = {min = -50, max = -70},
    },
    ["God"] = {
        ["Spread"] = {min = -70, max = -80},
    },
    ["Glitched"] = {
        ["Spread"] = {min = -80, max = -100},
    },
}

VNP.Inventory:RegisterGem(GEM)

--[[
    Energy Gem
]]--

GEM.Name = "Energy"
GEM.Description = "Increase Energy Damage."

GEM.Model = "models/props_phx2/garbage_metalcan001a.mdl" -- model for display when dropped or display in inventory

GEM.Modifiers = { -- This will be modifiers that define the base modifications for the weapon if there is a stat that lines up with the weapon it will multiply it by this value/100
    ["Common"] = {
        ["energydamage"] = {min = 1, max = 10},
        ["SuitEnergyResist"] = {min = 1, max = 10},
    },
    ["Uncommon"] = {
        ["energydamage"] = {min = 10, max = 15},
        ["SuitEnergyResist"] = {min = 10, max = 15},
    },
    ["Rare"] = {
        ["energydamage"] = {min = 15, max = 20},
        ["SuitEnergyResist"] = {min = 15, max = 20},
    },
    ["Epic"] = {
        ["energydamage"] = {min = 20, max = 25},
        ["SuitEnergyResist"] = {min = 20, max = 30},
    },
    ["Legendary"] = {
        ["energydamage"] = {min = 25, max = 40},
        ["SuitEnergyResist"] = {min = 30, max = 50},
    },
    ["Celestial"] = {
        ["energydamage"] = {min = 40, max = 55},
        ["SuitEnergyResist"] = {min = 50, max = 70},
    },
    ["God"] = {
        ["energydamage"] = {min = 55, max = 60},
        ["SuitEnergyResist"] = {min = 70, max = 80},
    },
    ["Glitched"] = {
        ["energydamage"] = {min = 60, max = 70},
        ["SuitEnergyResist"] = {min = 80, max = 100},
    },
}

GEM.OnHit = function(target, item, wep, dmginfo) -- The function that runs when you hit your enemy...
    if !VNP.Inventory:IsEnergyWeapon(wep:GetClass()) or !item.Modifiers["energydamage"] then return end

    dmginfo:ScaleDamage(1+(item.Modifiers["energydamage"]/100))
end

GEM.OnOwnerHit = function(owner, attacker, item, dmginfo) -- function that runs when the owner is hit...
    if !VNP.Inventory:IsEnergyWeapon(attacker:GetActiveWeapon():GetClass()) or !item.Modifiers["SuitEnergyResist"] then return end
    dmginfo:ScaleDamage((1-item.Modifiers["SuitEnergyResist"]/100))
end

VNP.Inventory:RegisterGem(GEM)

--[[
    Arrest Gem
]]--

GEM.Name = "Arrest Immunity"
GEM.Description = "Arrest Hits."

GEM.Model = "models/props_phx2/garbage_metalcan001a.mdl" -- model for display when dropped or display in inventory

GEM.Modifiers = { -- Aids but works
    ["Common"] = {
        ["SuitArrestHits"] = {val = 1},
    },
    ["Uncommon"] = {
        ["SuitArrestHits"] = {val = 2},
    },
    ["Rare"] = {
        ["SuitArrestHits"] = {val = 3},
    },
    ["Epic"] = {
        ["SuitArrestHits"] = {val = 4},
    },
    ["Legendary"] = {
        ["SuitArrestHits"] = {val = 5},
    },
    ["Celestial"] = {
        ["SuitArrestHits"] = {val = 6},
    },
    ["God"] = {
        ["SuitArrestHits"] = {val = 7},
    },
    ["Glitched"] = {
        ["SuitArrestHits"] = {val = 8},
    },
}

VNP.Inventory:RegisterGem(GEM)

--[[
    Permanent Gem
]]--

GEM.Name = "Permanent Gem"
GEM.Description = "Chance to regain after death."

GEM.Model = "models/props_phx2/garbage_metalcan001a.mdl" -- model for display when dropped or display in inventory

GEM.Modifiers = { -- Aids but works
    ["Common"] = {
        ["regainchance"] = {min = 1, max = 10},
    },
    ["Uncommon"] = {
        ["regainchance"] = {min = 10, max = 15},
    },
    ["Rare"] = {
        ["regainchance"] = {min = 15, max = 20},
    },
    ["Epic"] = {
        ["regainchance"] = {min = 20, max = 30},
    },
    ["Legendary"] = {
        ["regainchance"] = {min = 30, max = 50},
    },
    ["Celestial"] = {
        ["regainchance"] = {min = 50, max = 60},
    },
    ["God"] = {
        ["regainchance"] = {min = 60, max = 70},
    },
    ["Glitched"] = {
        ["regainchance"] = {min = 80, max = 100},
    },
}

GEM.OnPlayerDeath = function(ply, item, gem, socket)
    local chance = math.random(10000)/100

    if chance <= gem.Modifiers["regainchance"] then
            ply:AddInventoryItem(item)
    end
end


VNP.Inventory:RegisterGem(GEM)

--[[
    Paralyze Gem
]]--

GEM.Name = "Paralyze"
GEM.Description = "Chance to paralyze your enemy"

GEM.Color = Color(185, 165, 0, 255)
GEM.Model = "models/props_phx2/garbage_metalcan001a.mdl" -- model for display when dropped or display in inventory

GEM.Modifiers = { -- This will be modifiers that define the base modifications for the weapon if there is a stat that lines up with the weapon it will multiply it by this value/100
    ["Common"] = {
        ["paralyzechance"] = {min = 1, max = 10},
        ["paralyzeresist"] = {min = 1, max = 10},
    },
    ["Uncommon"] = {
        ["paralyzechance"] = {min = 5, max = 10},
        ["paralyzeresist"] = {min = 10, max = 20},
    },
    ["Rare"] = {
        ["paralyzechance"] = {min = 10, max = 15},
        ["paralyzeresist"] = {min = 20, max = 30},
    },
    ["Epic"] = {
        ["paralyzechance"] = {min = 15, max = 20},
        ["paralyzeresist"] = {min = 30, max = 40},
    },
    ["Legendary"] = {
        ["paralyzechance"] = {min = 20, max = 30},
        ["paralyzeresist"] = {min = 40, max = 60},
    },
    ["Celestial"] = {
        ["paralyzechance"] = {min = 30, max = 35},
        ["paralyzeresist"] = {min = 60, max = 75},
    },
    ["God"] = {
        ["paralyzechance"] = {min = 35, max = 40},
        ["paralyzeresist"] = {min = 75, max = 85},
    },
    ["Glitched"] = {
        ["paralyzechance"] = {min = 40, max = 50},
        ["paralyzeresist"] = {min = 85, max = 100},
    },
}

GEM.OnHit = function(target, item, wep, dmginfo) -- The function that runs when you hit your enemy...
    local chance = math.random(10000)/100

    if chance <= item.Modifiers["paralyzechance"] then
        local shouldParalyze = hook.Run("shouldParalyze", target)

        if shouldParalyze then return end
        if target:IsParalyzed() then return end

        target.Paralyzed = true

        timer.Simple(1, function()
            if !IsValid(target) then return end
            target.Paralyzed = false
        end)
    end
end

GEM.Hooks = {
    ["shouldParalyze"] = function(ply)
        local data = ply.GetSuit and ply:GetSuit()

        if !data then return end
        if !data.Sockets then return end

        local chance = math.random(10000)/100

        for name, gem in pairs(data.Sockets) do
            if gem and gem.Modifiers and gem.Modifiers["paralyzeresist"] then
                local paralyzeResistChance = gem.Modifiers["paralyzeresist"] -- probably..??!?!@!?@?!#??!@#?
                if chance <= paralyzeResistChance then return true end
            end
        end
    end,
    ["SetupMove"] = function(ply, mvd, cmd)
        if !ply.Paralyzed then return end
        mvd:SetVelocity(Vector(0,0,0))
    end,
    ["PlayerDeath"] = function(ply)
        ply.Paralyzed = false
    end,
}

VNP.Inventory:RegisterGem(GEM)

--[[
    Radiation Gem
]]--

GEM.Name = "Radiation"
GEM.Description = "Chance to irradiate your enemies."

GEM.Color = Color(100, 255, 100, 255)
GEM.Model = "models/props_phx2/garbage_metalcan001a.mdl" -- model for display when dropped or display in inventory

GEM.Modifiers = { -- This will be modifiers that define the base modifications for the weapon if there is a stat that lines up with the weapon it will multiply it by this value/100
    ["Common"] = {
        ["radiatechance"] = {min = 1, max = 5},
        ["radiateresist"] = {min = 1, max = 10},
    },
    ["Uncommon"] = {
        ["radiatechance"] = {min = 5, max = 10},
        ["radiateresist"] = {min = 10, max = 20},
    },
    ["Rare"] = {
        ["radiatechance"] = {min = 10, max = 25},
        ["radiateresist"] = {min = 20, max = 30},
    },
    ["Epic"] = {
        ["radiatechance"] = {min = 25, max = 30},
        ["radiateresist"] = {min = 30, max = 40},
    },
    ["Legendary"] = {
        ["radiatechance"] = {min = 30, max = 40},
        ["radiateresist"] = {min = 40, max = 60},
    },
    ["Celestial"] = {
        ["radiatechance"] = {min = 40, max = 45},
        ["radiateresist"] = {min = 60, max = 75},
    },
    ["God"] = {
        ["radiatechance"] = {min = 45, max = 55},
        ["radiateresist"] = {min = 75, max = 85},
    },
    ["Glitched"] = {
        ["radiatechance"] = {min = 55, max = 60},
        ["radiateresist"] = {min = 85, max = 100},
    },
}

GEM.OnHit = function(target, item, wep, dmginfo) -- The function that runs when you hit your enemy...
    local chance = math.random(10000)/100
    local ply = dmginfo:GetAttacker()


    if chance <= item.Modifiers["radiatechance"] && target:IsPlayer() then
        damageDOT(target, ply, 1, 0.1, 50, Color(200 + math.random() * 55, 100, 100), function(pl)
            if !IsValid(pl) then return end

            local data = pl.GetSuit and pl:GetSuit()

            if !data then return end
            if !data.Sockets then return end

            local chance = math.random(10000)/100

            for name,gem in pairs(data.Sockets) do
                if gem and gem.Modifiers and gem.Modifiers["radiatechance"] then
                    local radiateResistChance = gem.Modifiers["radiatechance"] -- probably..??!?!@!?@?!#??!@#?
                    if chance <= radiateResistChance then return true end
                end
            end
            
            return true
        end)
    end
end

VNP.Inventory:RegisterGem(GEM)

--[[
    Electrocute Gem
]]--

GEM.Name = "Electrocute"
GEM.Description = "Chance to electrocute your enemies."

GEM.Color = Color(100, 150, 200, 255)
GEM.Model = "models/props_phx2/garbage_metalcan001a.mdl" -- model for display when dropped or display in inventory

GEM.Modifiers = { -- This will be modifiers that define the base modifications for the weapon if there is a stat that lines up with the weapon it will multiply it by this value/100
    ["Common"] = {
        ["electrocutechance"] = {min = 1, max = 5},
        ["electrocuteresist"] = {min = 1, max = 10},
    },
    ["Uncommon"] = {
        ["electrocutechance"] = {min = 5, max = 10},
        ["electrocuteresist"] = {min = 10, max = 20},
    },
    ["Rare"] = {
        ["electrocutechance"] = {min = 10, max = 25},
        ["electrocuteresist"] = {min = 20, max = 30},
    },
    ["Epic"] = {
        ["electrocutechance"] = {min = 25, max = 30},
        ["electrocuteresist"] = {min = 30, max = 40},
    },
    ["Legendary"] = {
        ["electrocutechance"] = {min = 30, max = 40},
        ["electrocuteresist"] = {min = 40, max = 60},
    },
    ["Celestial"] = {
        ["electrocutechance"] = {min = 40, max = 45},
        ["electrocuteresist"] = {min = 60, max = 75},
    },
    ["God"] = {
        ["electrocutechance"] = {min = 45, max = 55},
        ["electrocuteresist"] = {min = 75, max = 85},
    },
    ["Glitched"] = {
        ["electrocutechance"] = {min = 55, max = 60},
        ["electrocuteresist"] = {min = 85, max = 100},
    },
}

GEM.OnHit = function(target, item, wep, dmginfo) -- The function that runs when you hit your enemy...
    local chance = math.random(10000)/100
    local ply = dmginfo:GetAttacker()


    if chance <= item.Modifiers["electrocutechance"] && target:IsPlayer() then
        local pos = target:GetPos()
        local players = ents.FindInBox(pos-Vector(150,150,150), pos+Vector(150,150,150))

        for _,pl in ipairs(players) do
            if !IsValid(pl) or !pl:IsPlayer() or !pl:Alive() then
                players[_] = nil
                continue 
            end

            pl:SetNW2Bool("VNP.Tazed", true)

            damageDOT(pl, ply, 6, 1, 3, nil, function(pl)
                if !IsValid(pl) then return end

                local data = pl.GetSuit and pl:GetSuit()

                if !data then return end
                if !data.Sockets then return end

                local chance = math.random(10000)/100

                for name, gem in pairs(data.Sockets) do
                    if gem and gem.Modifiers and gem.Modifiers["electrocuteresist"] then
                        local electrocuteResistChance = gem.Modifiers["electrocuteresist"]
                        if chance <= electrocuteResistChance then return false
                        end
                    end
                end
    
                return true
            end, function(pl)
                pl:SetNW2Bool("VNP.Tazed", false)
            end)
        end
    end
end

GEM.Hooks = {
    ["PlayerDeath"] = function(ply)
        ply:SetNW2Bool("VNP.Tazed", false)
    end
}

VNP.Inventory:RegisterGem(GEM)

--[[
    Freeze Gem
]]--

GEM.Name = "Freeze"
GEM.Description = "Chance to slow your enemies."

GEM.Color = Color(0, 200, 200, 255)
GEM.Model = "models/props_phx2/garbage_metalcan001a.mdl" -- model for display when dropped or display in inventory

GEM.Modifiers = { -- This will be modifiers that define the base modifications for the weapon if there is a stat that lines up with the weapon it will multiply it by this value/100
    ["Common"] = {
        ["freezechance"] = {min = 1, max = 10},
        ["freezetime"] = {min = 1, max = 50},

        ["freezeresist"] = {min = 1, max = 10},
    },
    ["Uncommon"] = {
        ["freezechance"] = {min = 5, max = 10},
        ["freezetime"] = {min = 50, max = 100},

        ["freezeresist"] = {min = 10, max = 20},
    },
    ["Rare"] = {
        ["freezechance"] = {min = 10, max = 15},
        ["freezetime"] = {min = 75, max = 100},

        ["freezeresist"] = {min = 20, max = 30},
    },
    ["Epic"] = {
        ["freezechance"] = {min = 15, max = 20},
        ["freezetime"] = {min = 100, max = 150},

        ["freezeresist"] = {min = 30, max = 40},
    },
    ["Legendary"] = {
        ["freezechance"] = {min = 20, max = 30},
        ["freezetime"] = {min = 150, max = 200},

        ["freezeresist"] = {min = 40, max = 60},
    },
    ["Celestial"] = {
        ["freezechance"] = {min = 30, max = 35},
        ["freezetime"] = {min = 200, max = 250},

        ["freezeresist"] = {min = 60, max = 75},
    },
    ["God"] = {
        ["freezechance"] = {min = 35, max = 40},
        ["freezetime"] = {min = 225, max = 250},

        ["freezeresist"] = {min = 75, max = 85},
    },
    ["Glitched"] = {
        ["freezechance"] = {min = 40, max = 50},
        ["freezetime"] = {min = 250, max = 300},

        ["freezeresist"] = {min = 85, max = 100},
    },
}

GEM.OnHit = function(target, item, wep, dmginfo) -- The function that runs when you hit your enemy...
    local chance = math.random(10000)/100
    local ply = dmginfo:GetAttacker()


    if chance <= item.Modifiers["freezechance"] && target:IsPlayer() then -- just to clear those errors on if they're even a player
        local shouldFreeze = hook.Run("shouldFreeze", target)

        if shouldFreeze then return end

        if !target:Alive() then return end

        if target:IsBot() then return end
        if IsValid(target.VNPFrozenProp) then return end
		
        local effectdata = EffectData()
		effectdata:SetEntity(target)
		effectdata:SetOrigin(target:GetPos())
		util.Effect("vnp_inv_freeze", effectdata, true, true)

		target:EmitSound("elitelupus/effect/freeze.wav", 75, 65, 1)
        
		target.VNPFrozenProp = ents.Create("prop_physics")
		local prop = target.VNPFrozenProp


        
		prop:SetModel("models/props_wasteland/rockcliff01g.mdl")
		prop:SetPos(target:GetPos() + Vector(0, 0, 50))
		prop:SetAngles(Angle(180, math.random(1, 360), 0))
		prop:SetMaterial("models/debug/debugwhite")
		prop:SetColor(Color(0, 185, 255, 150))
		prop:SetRenderMode(RENDERMODE_TRANSALPHA)
		prop:SetModelScale(.65)
		prop:Spawn()
		prop:Activate()

		prop:SetCollisionGroup(COLLISION_GROUP_WORLD)
		prop:SetParent(target)

        local oldws = target:GetWalkSpeed()
        local oldrs = target:GetRunSpeed()

        target:SetWalkSpeed(oldws * 0.45) -- no longer Freeze()
        target:SetRunSpeed(oldrs * 0.25)

        timer.Simple(1*(1+item.Modifiers["freezetime"]/100), function()
            if !IsValid(target) then return end

            local effectdata = EffectData()
		    effectdata:SetEntity(target)
		    effectdata:SetOrigin(target:GetPos())
		    util.Effect("vnp_inv_freeze", effectdata, true, true)

		    target:EmitSound("elitelupus/effect/freeze.wav", 75, 125, 1)

            if IsValid(target.VNPFrozenProp) then
                target.VNPFrozenProp:Remove()
            end
            target:SetWalkSpeed(oldws * 1)
            target:SetRunSpeed(oldrs * 1)
        end)
    end
end

GEM.Hooks = {
    ["shouldFreeze"] = function(ply)
        local data = ply.GetSuit and ply:GetSuit()

        if !data then return end
        if !data.Sockets then return end

        local chance = math.random(10000)/100
        for name, gem in pairs(data.Sockets) do
            if gem and gem.Modifiers and gem.Modifiers["freezeresist"] then
                local freezeResistChance = gem.Modifiers["freezeresist"] -- probably..??!?!@!?@?!#??!@#?
                if chance <= freezeResistChance then return true end
            end
        end
    end,
    ["PlayerDeath"] = function(ply)
        ply.Frozen = false
    end,
}

VNP.Inventory:RegisterGem(GEM)

--[[
    Kill Counter Gem
]]--

GEM.Name = "Kill Counter"
GEM.Description = "Counts kills."

GEM.Color = Color(50, 80, 200, 255) -- is sus
GEM.Model = "models/props_phx2/garbage_metalcan001a.mdl" -- model for display when dropped or display in inventory
GEM.Modifiers = { -- This will be modifiers that define the base modifications for the weapon if there is a stat that lines up with the weapon it will multiply it by this value/100
    ["Common"] = {
        ["killcounter"] = {min = 1, max = 5},
        ["killcountersuit"] = {min = 1, max = 10},
    },
    ["Uncommon"] = {
        ["killcounter"] = {min = 5, max = 10},
        ["killcountersuit"] = {min = 10, max = 20},
    },
    ["Rare"] = {
        ["killcounter"] = {min = 10, max = 25},
        ["killcountersuit"] = {min = 20, max = 30},
    },
    ["Epic"] = {
        ["killcounter"] = {min = 25, max = 30},
        ["killcountersuit"] = {min = 30, max = 40},
    },
    ["Legendary"] = {
        ["killcounter"] = {min = 30, max = 40},
        ["killcountersuit"] = {min = 40, max = 60},
    },
    ["Celestial"] = {
        ["killcounter"] = {min = 40, max = 45},
        ["killcountersuit"] = {min = 60, max = 75},
    },
    ["God"] = {
        ["killcounter"] = {min = 45, max = 55},
        ["killcountersuit"] = {min = 75, max = 85},
    },
    ["Glitched"] = {
        ["killcounter"] = {min = 55, max = 60},
        ["killcountersuit"] = {min = 85, max = 100},
    },
}
GEM.Hooks = {
    ["PlayerDeath"] = function(ply, inflictor, attacker)
        if !IsValid(attacker) or !attacker:IsPlayer() then return end
        
        local wep = attacker:GetActiveWeapon()

        if IsValid(wep) then
            local item = wep:GetItemData()

            if item then
                item.Kills = item.Kills && item.Kills + 1 or 1
            end

            wep:SetItemData(item, true)
        end
    end
}

VNP.Inventory:RegisterGem(GEM)

------------------------------

hook.Add("InitPostEntity", "Real:Suits", function()



    local gems = table.GetKeys(VNP.Inventory.Items["GEM"])
    local scrolls = table.GetKeys(VNP.Inventory.Items["SCROLL"])
    local upgradegems = table.GetKeys(VNP.Inventory.Items["UPGRADEGEM"])
    local rarities = table.GetKeys(VNP.Inventory.Rarities)
    local suits = table.GetKeys(VNP.Inventory.Items["SUIT"])


    for i,name in ipairs(gems) do
        ENT = {}
        ENT.Type = "anim"
        ENT.Base = "vnp_item_base"
        ENT.PrintName = name
        ENT.Spawnable = true
        ENT.Category = "el_gems"
        ENT.VNPItemName = name
        ENT.ItemRarity = "Common"
        scripted_ents.Register(ENT, "vnp_scroll_"..string.lower(string.Replace(name, " ", "_")))
    end

    if CLIENT then
        RunConsoleCommand("spawnmenu_reload")
    end

    for i,name in ipairs(scrolls) do
        ENT = {}
        ENT.Type = "anim"
        ENT.Base = "vnp_item_base"
        ENT.PrintName = name
        ENT.Spawnable = true
        ENT.Category = "el_scrolls"
        ENT.VNPItemName = name
        ENT.ItemRarity = "Common"
        scripted_ents.Register(ENT, "vnp_scroll_"..string.lower(string.Replace(name, " ", "_")))
    end
    for i,name in ipairs(suits) do
        local ENT = {}
        
        ENT.Type = "anim"
        ENT.Base = "vnp_item_base"
        ENT.PrintName = name
        ENT.Spawnable = true
        ENT.VNPItemName = name
        ENT.ItemRarity = "Common"
        ENT.Category = "el_suits"
    
        scripted_ents.Register(ENT, "vnp_suit_"..string.lower(string.Replace(name, " ", "_")))
    end
    for i,name in ipairs(upgradegems) do
        local ENT = {}
        
        ENT.Type = "anim"
        ENT.Base = "vnp_item_base"
        ENT.PrintName = string.lower(string.Replace(name, " ", "_"))
        ENT.Spawnable = true
        ENT.VNPItemName = name
        ENT.ItemRarity = "Common"
        ENT.Category = "el_upgrade_gem"
    
        scripted_ents.Register(ENT, "vnp_upgrade_gem_"..string.lower(string.Replace(name, " ", "_")))
    end
end)

------------------------------