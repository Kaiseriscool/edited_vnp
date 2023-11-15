VNP.Inventory = VNP.Inventory or {}
local PLAYER = FindMetaTable("Player")

function PLAYER:RegenSuit()
    if not self._SuitData then return end
    if not self._DoSuitRegen then return end
    local data = self._SuitData
    local mod = data.Rarity.Modifiers and data.Rarity.Modifiers["SuitRegen"] or 0
    local amt = mod and (1 + (mod / 100)) or 0
    if amt <= 0 then return end
    local suitMaxArmor = data["SuitArmorMax"]
    self:UpdateSuit("SuitArmor", math.min(data["SuitArmor"] + amt, suitMaxArmor))

    timer.Simple(0.1, function()
        if not IsValid(self) then return end
        self:RegenSuit()
    end)
end

function VNP.Inventory:InitializeSuits()
    hook.Add("EntityTakeDamage", "VNP.SuitDamage", function(ply, dmginfo)
        if not IsValid(ply) or not ply:IsPlayer() then return end
        if SH_SZ and SH_SZ:GetSafeStatus(ply) == SH_SZ.PROTECTED then return end
        if !ply:GetSuit() then return end
        ply._VNPtagged = CurTime() + 60
        local item = ply.GetSuit and ply:GetSuit()
        if not item then return end
        local Resistances = VNP.Inventory:GetItemData(item.Name, "Resistances")
        local resist = 1

        if Resistances[dmginfo:GetDamageType()] then
            resist = resist - (Resistances[dmginfo:GetDamageType()] / 100)
        end

        local attacker = dmginfo:GetAttacker()
        local wep = IsValid(attacker) and attacker:IsPlayer() and attacker:GetActiveWeapon()

        if IsValid(wep) then
            if Resistances[wep:GetClass()] and item["SuitHealth"] > 0 then
                resist = resist - (Resistances[wep:GetClass()] / 100)
            end

            if table.HasValue(VNP.Inventory.EnergyWeapons, wep:GetClass()) and item.Rarity.Modifiers and item.Rarity.Modifiers["SuitEnergyResist"] and item["SuitHealth"] > 0 then
                resist = resist - (item.Rarity.Modifiers["SuitEnergyResist"] / 100)
            end
        end

        if item["SuitResist"] or (item.Rarity.Modifiers and item.Rarity.Modifiers["SuitResist"]) and item["SuitHealth"] > 0 then
            local mod = item.Rarity.Modifiers["SuitResist"] / 100 or 0
            resist = resist - mod
        end

        if resist < 0 then
            resist = 0
        end

        local damage = math.Round(dmginfo:GetDamage() * resist)

        if damage <= 0 then
            dmginfo:SetDamage(0)

            return
        end

        ply._DoSuitRegen = false

        if item["SuitArmor"] then
            item["SuitArmor"] = item["SuitArmor"] - damage

            if item["SuitArmor"] <= 0 then
                damage = math.abs(item["SuitArmor"])
            else
                damage = 0
            end

            ply:UpdateSuit("SuitArmor", math.max(item["SuitArmor"], 0))
        end

        if item["SuitHealth"] then
            item["SuitHealth"] = item["SuitHealth"] - damage

            if item["SuitHealth"] <= 0 and !ply:HasShields() then
                damage = math.abs(item["SuitHealth"])
               // ply:RemoveSuit()
            else
                damage = 0
            end

            ply:UpdateSuit("SuitHealth", math.max(item["SuitHealth"], 0))
        end

        dmginfo:SetDamage(damage)

        if item.Rarity.Modifiers["SuitRegen"] then
            timer.Simple(1, function()
                if not IsValid(ply) then return end
                ply._DoSuitRegen = true
                ply:RegenSuit()
            end)
        end
    end)

    hook.Add("VNP.DoArrestHit", "VNP.Suits.ArrestHits", function(ply, hits, numb, limit)
        local suit = ply:GetSuit()
        if not suit then return end
        local basemods = VNP.Inventory:GetItemData(suit.Name, "BaseModifiers")
        local mods = suit.Rarity.Modifiers
        local amt = basemods and basemods["SuitArrestHits"] or 0

        if mods and mods["SuitArrestHits"] then
            amt = amt + mods["SuitArrestHits"]
        end

        if suit.Sockets then
            for _, gem in ipairs(suit.Sockets) do
                if not gem then continue end

                if gem.Rarity.Modifiers and gem.Rarity.Modifiers["SuitArrestHits"] then
                    amt = amt + gem.Rarity.Modifiers["SuitArrestHits"]
                end

                if gem.Modifiers and gem.Modifiers["SuitArrestHits"] then
                    amt = amt + gem.Modifiers["SuitArrestHits"]
                end
            end
        end

        if amt <= 0 then
            amt = 3
        end

        ply._SuitResistedHits = ply._SuitResistedHits or amt or limit
        ply._SuitResistedHits = ply._SuitResistedHits - 1
        if ply._SuitResistedHits < 0 then return hits, limit end

        return 0, 1
    end)

    hook.Add("PlayerDeath", "VNP.Suits.ClearSuit", function(ply)
        if not IsValid(ply) then return end
       -- ply:RemoveSuit()
        ply.LSkins = false
    end)

    hook.Add("playerArrested", "VNP.Suits.ClearSuit", function(ply)
        if not IsValid(ply) then return end
        ply:RemoveSuit()
    end)

    hook.Add("OnPlayerChangedTeam", "VNP.Suits.ClearSuit", function(ply)
        if not IsValid(ply) then return end
        ply:RemoveSuit()
    end)

    hook.Add("PlayerSay", "VNP.Suits.PlayerSay", function(ply, msg)
        msg = string.lower(msg)

        if msg == "/dropsuit" then
            if not ply:GetSuit() then
                ply:NNotify("Error", "You aren't wearing a suit!")

                return ""
            end

            ply._VNPtagged = ply._VNPtagged or 0

            if CurTime() < ply._VNPtagged then
                ply:NNotify("Error", "You cannot drop a suit/gun while in combat!")

                return ""
            end

            DarkRP.notify(ply, 1, 5, "Dropping suit in 5 seconds!")
            ply._VNPprevmsg = "/dropsuit"

            timer.Simple(5, function()
                if not IsValid(ply) then return end
                local item = ply:GetSuit()
                if not item then return end
                ply:RemoveSuit()
                ply:SetMaterial()
                local ent = ents.Create("vnp_item_base")
                ent:SetPos(ply:GetPos() - Vector(0, 0, 25))
                ent:Spawn()
                if item.LSkins then 
                    ent:SetMaterial(item.LSkins)
                end
                ent:SetItemData(item)
                ent:SetOwner(ply)
                ply._VNPprevmsg = nil
                if ply:GetSuit() then ply:Kill() return end -- sadly a temp fix to a dupe bug
            end)

            return ""
        elseif string.StartWith(msg, "/sellsuit ") then
            local amt = tonumber(string.sub(msg, string.len("/sellsuit ")))
            if not amt then return "" end
            if amt < 1 then return "" end

            if not ply:GetSuit() then
                ply:NNotify("Error", "You aren't wearing a suit!")

                return ""
            end

            ply._VNPtagged = ply._VNPtagged or 0

            if CurTime() < ply._VNPtagged then
                ply:NNotify("Error", "You cannot sell a suit while in combat!")

                return ""
            end

            ply:NNotify("Generic", "Selling suit in 5 seconds!")

            timer.Simple(5, function()
                if not IsValid(ply) then return end
                if !ply:Alive() then ply:NNotify("Error", "Your dead...") return end
                ply.SellEnts = ply.SellEnts or {}

                for _, v in pairs(ply.SellEnts) do
                    if not IsValid(v) then
                        ply.SellEnts[_] = nil
                    end
                end

                if table.Count(ply.SellEnts) >= 5 then return end
                local data = ply:GetSuit()
                if not data then return end
                ply:RemoveSuit()
                local ent = ents.Create("vnp_item_base")
                ent:SetPos(ply:GetPos() - Vector(0, 0, 25))
                ent:Spawn()
                ent:SetItemData(data)
                ent:SetNWBool("VNP.ForSale", true)
                ent:SetNWInt("VNP.Price", amt)
                ent:SetOwner(ply)
                table.insert(ply.SellEnts, ent)
            end)

            return ""
        end
    end)
end

hook.Add("PlayerSpawn", "FixDupe#2:OnDeathSuit", function(ply)
    timer.Simple(0, function()
        if ply:GetSuit() then
        ply:RemoveSuit() -- should be good
        --local p_nick = p_nick or "BOT"
        --local p_sid = p_sid or "BOT_"
       -- p_nick = ply:Nick()
      --  p_sid = ply:SteamID()
       -- print(" [ ANTI-DUPE ] -- Stoped [" .. p_nick .. " ] From duping a suit Method#2.0 ")

        --for k, v in pairs(player.GetAll()) do
          --  if v:IsAdmin() then
             --   v:ChatPrint(" [ ANTI-DUPE ] -- Stoped [ " .. p_nick .. " ] -  [ " .. p_sid .. " ] From duping a suit Method#2.0 ")
           -- end
        end
    end)
end)

VNP:AddNetworkString("VNP.RepairSuit", function(ply, data)
    local slot = data.slot
    if not ply._vInventory[slot] then return end
    local item = ply._vInventory[slot]
    local cost = VNP.Inventory:GetItemData(item.Name, "RepairCost") or 0
    local money = ply:getDarkRPVar("money") or 0
    if cost > money then return end
    ply:addMoney(-cost)
    item["SuitHealth"] = item["SuitHealthMax"]
    item["SuitArmor"] = item["SuitArmorMax"]
    ply:SetInventorySlot(slot, item, false)
end)

VNP.Inventory:InitializeSuits()