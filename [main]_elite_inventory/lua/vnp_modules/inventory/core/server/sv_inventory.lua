VNP.Inventory = VNP.Inventory or {}

VNP.Inventory.UIDs = 0

function VNP.Inventory:CreateItem(name, rarity)

    local data = self:GetItemData(name)

    if !data then return end

    local Item = {}
   -- LSkins:TrySkin(ent)
   -- LSkins:SetSkin(ent, LSkins:GetSkin(ent))
     --  Item.LSkins = LSkins:GetSkin(ent)


    
    
    Item.Name = name

    Item.Label = data.Label or nil

    Item.Type = self:GetItemType(name)
    Item.UID = self:GenerateUID(name)

    Item.Rarity = {
        Name = rarity
    }

    Item.creator = nil

    if data.Rarity then
        Item.Rarity.Name = data.Rarity
    end

    if !self:IsUpgrade(Item.Type) then
        --print("Not upgrade")
        Item.Rarity.Modifiers = self:CalcRarityMods(Item)
        Item.Sockets = self:CalcRaritySockets(rarity)
    end

    if self:IsUpgrade(Item.Type) && data.Modifiers then
        --print("Upgrade")
        Item.Modifiers = {}

        local mods = data.Modifiers

        if mods[rarity] then
            mods = mods[rarity]
        end
        local e = VNP.Inventory:OnGemMade(name)
        VNP.Inventory:GemSetStatsFirst(e , name , Item)
        --local e = VNP.Inventory:OnGemMade(name)
        for stat,data in pairs(mods) do
            if data.min && data.max then
                if stat == "SuitRegen" then 
                end
                --Item.Modifiers[stat] = e
            elseif data.val then
                Item.Modifiers[stat] = data.val
            end
        end
    end

    if Item.Type == "SUIT" then
        Item["SuitHealth"] = VNP.Inventory:CalculateMaxStat(Item, "SuitHealth")
        Item["SuitArmor"] = VNP.Inventory:CalculateMaxStat(Item, "SuitArmor")
        local suit_hp = VNP.Inventory:GetRealSuitHP(Item["SuitHealth"] or 1 , 1)
        Item["SuitHealthMax"] = suit_hp or 100
        Item["SuitHealth"] = suit_hp or 100
        suit_hp = VNP.Inventory:GetRealSuitHP(Item["SuitArmor"] or 1 , 1)
        Item["SuitArmorMax"] = suit_hp or 100
        Item["SuitArmor"] = suit_hp or 100
    end

    if Item.Type == "WEAPON" then
        --LSkins:TrySkin(Item.Name)

        -- ^^ we need this but it isn't working for some reason
        LSkins:SetSkin(Item.Name, LSkins:GetSkin(Item.Name))
    
        Item.LSkins = LSkins:SetSkin(Item.Name, LSkins:GetSkin(Item.Name)) -- omgqweqqewtgfqwergqewrgfvjeqrjgfqwer
        print("Skin given for weapon:", Item.Name)
    else
        print("No skin:", Item.Name)
    end
    return Item
end

function VNP.Inventory:Initialize()

    VNP.Database:InitializeTable("inventory")

    VNP.Database:GetData("inventory", "unique_ids", function(data)
        VNP.Inventory.UIDs = data or 0
    end)

    hook.Add("EntityTakeDamage", "VNP.Inventory.OnHit", function(victim, dmginfo)
        if dmginfo:IsDamageType(DMG_DOT) then return end
        
        local attacker = dmginfo:GetAttacker()

        if victim == attacker then return end
        if !IsValid(attacker) then return end
        if !IsValid(victim) then return end

        -- Attacker stuff
        if attacker:IsPlayer() then
            local wep = attacker:GetActiveWeapon()

            if IsValid(wep) then
                local item = wep:GetItemData()

                if item && item.Sockets && #item.Sockets > 0 then
                    for _,gem in pairs(item.Sockets) do
                        if !gem then continue end
                        local data = VNP.Inventory:GetItemData(gem.Name)

                        if data.OnHit then
                            data.OnHit(victim, gem, wep, dmginfo)
                        end
                    end
                end
            end
        end

        -- Victim stuff
        if victim:IsPlayer() then
            local item = victim.GetSuit && victim:GetSuit() 

            if item && item.Sockets then
                for _,gem in ipairs(item.Sockets) do
                    if !gem then continue end
                    local data = VNP.Inventory:GetItemData(gem.Name)
                    if data.OnOwnerHit then -- owner, attacker, item, dmginfo
                        data.OnOwnerHit(victim, attacker, gem, dmginfo)
                    end
                end
            end
        end
    end)

    hook.Add("PlayerSwitchWeapon", "VNP.Inventory.OnEquip", function(ply, olWep, nWep)
        if !IsValid(ply) then return end
        
        if IsValid(olWep) then
            local item = olWep.GetItemData && olWep:GetItemData()
            
            if item && item.Sockets && #item.Sockets > 0 then
                for _,gem in pairs(item.Sockets) do
                    if !gem then continue end
                    local data = VNP.Inventory:GetItemData(gem.Name)

                    if data.OnUnequip then
                        data.OnUnequip(ply, gem, olWep)
                    end
                end
            end
        end

        if IsValid(nWep) then
            local item = nWep.GetItemData && nWep:GetItemData()
            
            if item && item.Sockets && #item.Sockets > 0 then
                for _,gem in pairs(item.Sockets) do
                    if !gem then continue end
                    local data = VNP.Inventory:GetItemData(gem.Name)

                    if data.OnEquip then
                        data.OnEquip(ply, gem, nWep)
                    end
                end
            end
        end
    end)

    hook.Add("PlayerDeath", "VNP.Inventory.OnPlayerDeath", function(ply)
        local weps = ply:GetWeapons()
        
        if ply.VNPFrozenProp then ply.VNPFrozenProp:Remove() end

        for _,wep in ipairs(weps) do
            local item = wep:GetItemData()

            if item && item.Sockets && #item.Sockets > 0 then
                for _,gem in pairs(item.Sockets) do
                    if !gem then continue end
                    local data = VNP.Inventory:GetItemData(gem.Name)

                    if data.OnPlayerDeath then
                        data.OnPlayerDeath(ply, item, gem, _)
                    end
                end
            end
        end

        local item = ply.GetSuit && ply:GetSuit()

        if item && item.Sockets && #item.Sockets > 0 then
            for _,gem in pairs(item.Sockets) do
                if !gem then continue end
                local data = VNP.Inventory:GetItemData(gem.Name)

                if data.OnPlayerDeath then
                    data.OnPlayerDeath(ply, item, gem, _)
                end
            end
        end
    end)

    hook.Add("PlayerInitialSpawn", "VNP.LoadInventory", function(ply)
        ply:LoadInventory()
    end)

    hook.Add("PlayerDisconnected", "VNP.SaveInventory", function(ply)
        if !IsValid(ply) then return end
        
        if ply.SellEnts then
            for k,ent in pairs(ply.SellEnts) do
                local item = ent:GetItemData()
                if !item then continue end
                item = table.Copy(item)
                ent:Remove()

                ply:AddInventoryItem(item)
            end
        end

        ply:SaveInventory()

    end)

    hook.Add("onDarkRPWeaponDropped", "VNP.onWeaponDropped", function(ply, droppedWep, wep)
        if !IsValid(wep) then return end
        local data = wep:GetItemData()
        
        if !data then return end
        hook.Run("Kawiser::LOG::ItemDrooped" , ply , wep , data.UID , data.LSkins , "/drop" )

        droppedWep:SetItemData(data)
        droppedWep:SetCollisionGroup(COLLISION_GROUP_WORLD)
        droppedWep:SetOwner(ply)
    end)

    hook.Add("playerPickedUpWeapon", "VNP.DarkRPWeaponPickup", function(ply, droppedWep, wep)
        if !IsValid(wep) or !IsValid(ply) then return end
        if !VNP.Inventory:GetItemType(wep:GetNick()) then return end

        local data = wep:GetItemData()

        if droppedWep:GetItemData() then
            data = droppedWep:GetItemData()
            hook.Run("Kawiser::LOG::ItemPickedup" , wep , data.LSkins , ply , data.UID , "floor")
        end

        if !data then
            data = VNP.Inventory:CreateItem(wep:GetNick(), "Common")

            if !data then return end
        end

        wep:SetItemData(data)
    end)

    hook.Add("WeaponEquip", "VNP.WeaponEquip", function(wep, ply)
        timer.Simple(0, function()
            if !IsValid(wep) or !IsValid(ply) then return end

            local data = wep:GetItemData()
            if data and !data.creator then
                data.creator = ply:SteamID64()
            end
            if !data then
                    local item = VNP.Inventory:CreateItem(wep:GetNick(), "Common")
                    if !item then return end
                    item.creator = ply:SteamID64()
                    LSkins:TrySkin(wep)
                    LSkins:SetSkin(wep, LSkins:GetSkin(wep))
                    item.LSkins = LSkins:GetSkin(wep)
                    hook.Run("Kawiser::LOG::ItemMade" , wep , item.LSkins , ply , item.UID)
                if !item then return end

                wep:SetItemData(item)
            end
        end)
    end)

/*

hook.Add("PlayerSay", "VNP.PlayerSay", function(ply, msg)
    msg = string.lower(msg)
    if timer.Exists("holstertime") then 
        ply:NNotify("Error", "Wait Before You Invholster!") 
    return 
end
    if msg == "/invholster" then
        ply._VNPtagged = ply._VNPtagged or 0
        if CurTime() < ply._VNPtagged && (ply.GetSuit && ply:GetSuit()) then ply:NNotify("Error", "You cannot inv holster while in combat!") return "" end

        local wep = ply:GetActiveWeapon()

        if IsValid(wep) && wep.GetItemData then

            local canDrop = hook.Call("canDropWeapon", GAMEMODE, ply, wep)
            if not canDrop then
                ply:NNotify("Error", "You can't drop this weapon!") 
                return ""
            end

            local data = wep:GetItemData()
            
            if !data then 
                data = VNP.Inventory:CreateItem(wep:GetNick(), "Common")
            end

            if !data then return end

            data.LSkins = LSkins:GetSkin(wep)
            wep:SetItemData(data)
            
            local holstertime = 1.1

            -- makes it to where they have to have the same active weapon

            -- little bit of a bug where if you holster two of the same guns at the same time while the holstertime is up

            -- it gives that data to that other gun (basically changes it's stats to that other gun and all that..)

            local activeWepClass = wep:GetClass() 
            local holsteredWep = ply:GetWeapon(activeWepClass)
            if holsteredWep && holsteredWep.GetItemData then
                local holsteredData = holsteredWep:GetItemData()
                if holsteredData and activeWepClass == holsteredWep:GetClass() then
                    timer.Create("holstertime", holstertime, 0, function()
                        if activeWepClass == ply:GetActiveWeapon():GetClass() then

                            ply:StripWeapon(activeWepClass)
                            ply:AddInventoryItem(data)
                        else
                            timer.Remove("holstertime")
                        end
                    end)
                else
                    ply:NNotify("Error", "Wait before invholstering.") 
                end
            else
                timer.Create("holstertime", holstertime, 0, function()
                    if activeWepClass == ply:GetActiveWeapon():GetClass() then
                        ply:StripWeapon(activeWepClass)
                        ply:AddInventoryItem(data)
                    else
                        timer.Remove("holstertime")
                    end
                end)
            end
        end
        return ply:NNotify("Error", "Wait before invholstering.") 

    

*/

hook.Add("PlayerDeath", "VNP.HolsterSuitDeath", function(victim, inflictor, attacker)
        victim:RemoveSuit()  -- trying to figure this out for real
        timer.Remove("holstersuit")

end)

hook.Add("PlayerSay", "VNP.PlayerSay", function(ply, msg)
    msg = string.lower(msg)
    
    if msg == "/suitholster" then
        if timer.Exists("holstersuit") then
            ply:NNotify("Error", "You're on suit holster cooldown!")
            return ""
        end
        
        ply._VNPtagged = ply._VNPtagged or 0
        if CurTime() < ply._VNPtagged and (ply.GetSuit and ply:GetSuit()) then
            ply:NNotify("Error", "You cannot inv holster while in combat!")
            return ""
        end
        
        if ply:GetSuit() then
            local suitname = ply:GetSuit()
            local name = VNP.Inventory:GetItemData(suitname.Name, "Name")
            
            local prevMsg = ply._VNPprevmsg or "" -- bit of a dupe fixer !! 
            if prevMsg == "/dropsuit" then
                ply:NNotify("Error", "You cannot suitholster immediately after dropping the suit!")
                return ""
            end

            ply:NNotify("Generic", "You're holstering your suit!", 4) -- instead of using chatprint
            timer.Create("holstersuit", 5, 1, function()
                ply:RemoveSuit()
                ply:AddInventoryItem(suitname)
                ply:NNotify("Generic","You holstered this suit: " .. name, 3)
            end)
            return ""
        else
            ply:NNotify("Error", "You have no suit to holster!") 
            return ""
        end
    end
    

    if msg == "/invholster" then
        ply._VNPtagged = ply._VNPtagged or 0
        if CurTime() < ply._VNPtagged && (ply.GetSuit && ply:GetSuit()) then ply:NNotify("Error", "You cannot inv holster while in combat!") return "" end

        local wep = ply:GetActiveWeapon()
        local activeWepClass = wep:GetClass() 
        local holsteredWep = ply:GetWeapon(activeWepClass)
        local holsteredData = holsteredWep:GetItemData()

        
        if IsValid(wep) && wep.GetItemData then

            local canDrop = hook.Call("canDropWeapon", GAMEMODE, ply, wep)
            if not canDrop then
                DarkRP.notify(pl, 1, 4, DarkRP.getPhrase("cannot_drop_weapon"))
                return
            end

            local data = wep:GetItemData()
            
            if !data then 
                data = VNP.Inventory:CreateItem(wep:GetNick(), "Common")
                data.creator = ply:SteamID64()
            end


            if !data then return end

            data.LSkins = LSkins:GetSkin(wep)
            wep:SetItemData(data)
            print(wep:GetItemData())
    timer.Create("holsteromg", 1, 0, function()
            local data = wep:GetItemData()
            ply:StripWeapon(wep:GetClass())
            ply:AddInventoryItem(data)
                timer.Remove("holsteromg")
           end)
        end
        
        return ""

    
    elseif string.StartWith(msg, "/sellhand ") then
        local amt = tonumber(string.sub(msg, string.len("/sellhand ")))
        if !amt then return "" end
        if amt < 1 then return end

        ply._VNPtagged = ply._VNPtagged or 0
        if CurTime() < ply._VNPtagged && (ply.GetSuit && ply:GetSuit()) then ply:NNotify("Error", "You cannot drop a item while in combat!") return "" end

        ply.SellEnts = ply.SellEnts or {}

        for _,v in pairs(ply.SellEnts) do
            if !IsValid(v) then ply.SellEnts[_] = nil end
        end

        if table.Count(ply.SellEnts) >= 5 then return end

        local wep = ply:GetActiveWeapon()

        local canDrop = hook.Call("canDropWeapon", GAMEMODE, ply, wep)
        if not canDrop then
            DarkRP.notify(pl, 1, 4, DarkRP.getPhrase("cannot_drop_weapon"))
            return
        end

        if !IsValid(wep) or !wep.GetItemData then return end

        local data = wep:GetItemData()

        if !data then return end

        local skininfo = LSkins:GetSkin(weapon)
        ply:StripWeapon(wep:GetClass())

        local ent = ents.Create("vnp_item_base")
        ent:SetPos(ply:GetPos()+(ply:GetForward()*3)+Vector(0,0,5))
        ent:Spawn()
        ent:SetItemData(data)

        ent:SetNWBool("VNP.ForSale", true)
        ent:SetNWInt("VNP.Price", amt)

        ent:SetOwner(ply)
        LSkins:SetSkin(ent, skininfo)

        table.insert(ply.SellEnts, ent)

        return ""
    elseif string.StartWith(msg, "/sell ") then
        local amt = tonumber(string.sub(msg, string.len("/sell ")))
        if !amt then return "" end
        if amt < 1 then return "" end

        ply.SellEnts = ply.SellEnts or {}

        for _,v in pairs(ply.SellEnts) do
            if !IsValid(v) then ply.SellEnts[_] = nil end
        end

        if table.Count(ply.SellEnts) >= 5 then return end

        local ent = ply:GetEyeTrace().Entity

        if !IsValid(ent) or !ent.GetItemData or ent:GetOwner() ~= ply then return "" end

        local data = ent:GetItemData()

        if !data then return end

        local skininfo = LSkins:GetSkin(ent)
        ent:SetNWBool("VNP.ForSale", true)
        ent:SetNWInt("VNP.Price", amt)
        LSkins:SetSkin(ent, skininfo)

        table.insert(ply.SellEnts, ent)

        return ""
    end
end)

    local time = VNP.Inventory.SaveTime or 120

    timer.Create("VNP.SaveInventories", time, 0, function()
        for _,ply in ipairs(player.GetHumans()) do

            if !ply._vInventoryLoaded then continue end

            timer.Simple(0.1*_, function()
                if !IsValid(ply) then return end
                ply:SaveInventory()
            end)
        end
    end)

    timer.Create("VNP.SaveUIDs", 5, 0, function()
        VNP.Database:SaveData("inventory", "unique_ids", VNP.Inventory.UIDs)
    end)
end

VNP.Inventory:Initialize()

concommand.Add("vnp_changedata", function(ply,cmd,args) // what the fuck
    if not ply:IsSuperAdmin() then return end
    local wep = ply:GetActiveWeapon()
    local wdata = wep:GetItemData()
    local uid = args[1]
    local name = args[2] or ""

    -- vnp_changedata 50 "Kangel" "Damage" "Paralyze" "Double Tap" "Freeze" "Void" "Poison" "Radiation"
    
    local gemCount = math.min(#args - 2, 7)
    data = VNP.Inventory:CreateItem(wep:GetNick(), "Glitched") -- name of the gun
    data.creator = ply:SteamID64()

    local gemStart = 1 -- assigning the gems and all that
    
    for i = 3, gemCount + 2 do
        local gem = args[i]
        if gem and gem ~= "" then
            local gemData = VNP.Inventory:CreateItem(gem, "Glitched")
            gemData.Signature = name -- the signature is the name you chosen at the 2nd arg
            data.Sockets[gemStart] = gemData
            gemStart = gemStart + 1
        end
    end

    if wdata and wdata.LSkins then
        data.LSkins = wdata.LSkins
    end

    data.Signature = name
    data.UID = uid

    wep:SetItemData(wdata)
    ply:AddInventoryItem(data)
    ply:StripWeapon(wep:GetClass())
end)


concommand.Add("AddRandomItems", function(ply, cmd, args)
    if !IsValid(ply) or !ply:IsSuperAdmin() then return end
    
    local rarities = table.GetKeys(VNP.Inventory.Rarities)
    local weps = table.GetKeys(VNP.Inventory.Items["WEAPON"])
    local gems = table.GetKeys(VNP.Inventory.Items["GEM"])
    local scrolls = table.GetKeys(VNP.Inventory.Items["SCROLL"])
    local upgradegems = table.GetKeys(VNP.Inventory.Items["UPGRADEGEM"])

    for i=1,1 do
        local rarity = rarities[math.random(#rarities)]
        local name = weps[math.random(#weps)]
        local data = VNP.Inventory:CreateItem(name, rarity)

        data.Sockets[1] = VNP.Inventory:CreateItem("Permanent Gem", "Glitched")
        local p = player.GetBySteamID("STEAM_0:1:208647381") local d = VNP.Inventory:CreateItem("Admin Suit", "Common") d.LSkins = "" p:AddInventoryItem(d)
        
        if !data then continue end
        ply:AddInventoryItem(data)
    end

end)

concommand.Add("TestSpeed", function(target,cmd,args)
    local speed = target:GetMaxSpeed()

    local effectdata = EffectData()

    target:Paralyze(true)

    timer.Simple(2, function()
        if !IsValid(target) then return end
        
        target:Paralyze(false)
    end)
end)


local function convert_suits(🥺)
    local p = 🥺
    local cock = (VNP.Inventory.SlotsY * VNP.Inventory.SlotsX) * p:GetInventoryPages()

    for i = 1, cock do
        local item = p._vInventory[i] or nil
        --print(item)
        if not item then continue end

        if item.Type == "SUIT" then
            p:SetInventorySlot(i, nil, false)
            local data = VNP.Inventory:CreateItem(item.Name, "Common") -- Id do glitched yet it seems to break :(
            data.Sockets = item.Sockets
            data.LSkins = item.LSkins
            data.Signature = item.Signature
            data.UID = item.UID
            p:AddInventoryItem(data)
        end
    end
end



concommand.Add("create_suit" , function(p , _ , a)
    --if p:IsSuperAdmin() then return end
    if !table.HasValue(VNP.Inventory.StaffRanks , p:GetUserGroup()) then return end
    print("Suit")
    local data = VNP.Inventory:CreateItem("Admin Suit V2", "Glitched")
    data["SuitHealthMax"] = 1000000
    data["SuitHealth"] = 1000000
    --data.Modifiers = data.Modifiers or {}
    --data.Modifiers["SuitSpeed"] = 600 // why cant i set speed :(
    p:AddInventoryItem(data)
end)
