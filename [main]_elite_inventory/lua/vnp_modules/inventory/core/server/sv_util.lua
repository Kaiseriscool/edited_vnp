VNP.Inventory = VNP.Inventory or {}

function VNP.Inventory:GenerateUID(name)
    
    self.UIDs = self.UIDs or 0
    self.UIDs = self.UIDs + 1

    return self.UIDs
end

function VNP.Inventory:CalcRarityMods(item, overwrite)

    local name = item.Name
    local rarity = item.Rarity.Name
    local curMods = item.Rarity.Modifiers or {}

    local idata = self:GetItemData(name)
    local stats


    if !idata then return end
    if !idata.Modifiers && !idata.BaseModifiers then return end

    if idata.BaseModifiers then
        stats = idata.BaseModifiers
    else
        stats = idata.Modifiers
    end

    local mods = self:GetRarityValue(rarity, "Modifiers")

    if idata.BaseModifiers && idata.Modifiers && idata.Modifiers[rarity] then
        mods = idata.Modifiers[rarity]
    end

    if !mods then return end

    local modTbl = {}

    for stat, data in pairs(mods) do
        if stats[stat] then
            if istable(stats[stat]) && stats[stat].chance && !curMods[stat] then
                local r = math.random(100)

                if r > stats[stat].chance then continue end
            end

            if data.min && data.max then
                modTbl[stat] = math.random(data.min,data.max)
            elseif data.val then
                modTbl[stat] = data.val
            end
        end
    end

    return modTbl
end

function VNP.Inventory:CalcRaritySockets(rarity)
    local amt = VNP.Inventory:GetRarityValue(rarity, "Sockets")

    if amt < 1 then return {} end

    local tbl = {}

    for i=1,amt do
        tbl[i] = false -- False means the socket is not being used!
    end

    return tbl
end

local PLAYER = FindMetaTable("Player")

function PLAYER:IsParalyzed()
    return istable(self._prevspeed)
end

function PLAYER:Paralyze(bool)
    if bool && self:IsParalyzed() then return end

    if bool then
        self._prevspeed = {}
        self._prevspeed["walk"] = self:GetWalkSpeed()
        self._prevspeed["run"] = self:GetRunSpeed()
        self._prevspeed["slowwalk"] = self:GetSlowWalkSpeed()

        self:SetWalkSpeed(1)
        self:SetRunSpeed(1)
        self:SetSlowWalkSpeed(1)
    elseif self._prevspeed then
        self:SetWalkSpeed(self._prevspeed["walk"])
        self:SetRunSpeed(self._prevspeed["run"])
        self:SetSlowWalkSpeed(self._prevspeed["slowwalk"])

        self._prevspeed = nil
    end
end

function PLAYER:UpdateClientInventory()
    self:SendData("VNP.UpdateClientInventory", {Inventory = self._vInventory})
    
    if self.AdminsViewing then
        for steamid, ply in pairs(self.AdminsViewing) do
            if !IsValid(ply) then continue end

            ply:SendData("VNP.UpdateAdminMenu", {inv = self._vInventory})
        end
    end
end

function PLAYER:SocketGem(slot1, slot2, socket)
    local item = self._vInventory[slot1]
    local gem = self._vInventory["UPGRADES"][slot2]

    local class = VNP.Inventory:GetItemData(item, "Class")

    if class && VNP.Inventory.GemBlacklist[class] && table.HasValue(VNP.Inventory.GemBlacklist[class], gem.Name) then return end
    
    if item.Type ~= "WEAPON" && item.Type ~= "SUIT" then return end
    if item.Sockets[socket] == nil then return end

    for i,g in pairs(item.Sockets) do
        if !g then continue end
        if g.Name == gem.Name then return end 
    end

    item.Sockets[socket] = gem

    self:SetInventorySlot(slot2, nil, true)
    self:SetInventorySlot(slot1, item, false)

    return true
end

function PLAYER:UnsocketGem(slot, socket)
    local item = self._vInventory[slot]
    local gem = item.Sockets[socket]
    
    if item.Type ~= "WEAPON" && item.Type ~= "SUIT" then return end
    if item.Sockets[socket] == nil then return end

    item.Sockets[socket] = false

    self:AddInventoryItem(gem)
    self:SetInventorySlot(slot1, item, false)
end

function PLAYER:BuyInventoryPage()
    local cur = self._vInventory["PAGES"] or 1
    local price = VNP.Inventory.Pages[cur+1]
    local money = self:getDarkRPVar("money") or 0

    if price && money < price then return end

    
if self._vInventory["PAGES"] == 4 then
    return
end

    self:addMoney(-price)

    self._vInventory["PAGES"] = cur + 1

    self:UpdateClientInventory()
end

function PLAYER:AddInventoryItem(item)
    if !item or !item.Name then return end

    local isUpgrade = false 

    if VNP.Inventory:IsUpgrade(item.Type) then
        isUpgrade = true
    end
    
    local slot

    if !isUpgrade then
        slot = self:GetAvailableSlot()
    else
        slot = self:GetAvailableUpgradeSlot()
    end

    if item.Type == "SCROLL" or item.Type == "UPGRADEGEM" then
        local items = self:GetItemsByType(item.Type)

        for s, i in pairs(items) do
            if item.Name ~= i.Name then continue end
            if item.Rarity.Name ~= i.Rarity.Name then continue end
            slot = s
            break
        end
        
        if !slot then return end

        if self._vInventory["UPGRADES"][slot] then 
            local curAmt = self._vInventory["UPGRADES"][slot].Amount
            local addAmt = item.Amount or 1

            if curAmt then
                self._vInventory["UPGRADES"][slot].Amount = self._vInventory["UPGRADES"][slot].Amount + addAmt
            else
                self._vInventory["UPGRADES"][slot].Amount = 1 + addAmt
            end

            item = self._vInventory["UPGRADES"][slot]
        end
    end

    self:SetInventorySlot(slot, item, isUpgrade)

    self:UpdateClientInventory()
    
    return slot
end

function PLAYER:RemoveInventoryItem(slot, isUpgrade)
    if !slot then return end

    isUpgrade = isUpgrade or false

    local item = isUpgrade && self._vInventory["UPGRADES"][slot] or self._vInventory[slot]

    if item.Amount then
        item.Amount = item.Amount - 1

        if item.Amount < 1 then
            item = nil
        end
    else
        item = nil
    end

    self:SetInventorySlot(slot, item, isUpgrade)
end

function PLAYER:SetInventorySlot(slot, data, isUpgrade)
    if !slot then return end
    
    isUpgrade = isUpgrade or false
    data = data or nil

    if !isUpgrade then
        self._vInventory[slot] = data
    else
        self._vInventory["UPGRADES"][slot] = data
    end

    self:UpdateClientInventory()
end

function PLAYER:SaveInventory()
    if !IsValid(self) then return end
    if !self._vInventoryLoaded then return end

    local id64 = self:SteamID64()

    if !id64 then return end

    VNP.Database:SaveData("inventory", id64, self._vInventory)
end

function PLAYER:LoadInventory() -- Laziness
    if !IsValid(self) then return end

    local id64 = self:SteamID64()

    if !id64 then return end

    local exists = VNP.Database:GetData("inventory", id64, function(data)
        data = data or {}

        for slot,item in ipairs(data) do
            if VNP.Inventory:GetItemType(item.Name) then continue end
            data[slot] = nil
        end
        for slot,item in ipairs(data["UPGRADES"]) do
            if VNP.Inventory:GetItemType(item.Name) then continue end
            data["UPGRADES"][slot] = nil
        end


        self._vInventory = data
        self._vInventory["PAGES"] = self._vInventory["PAGES"] or 1
        self._vInventory["UPGRADES"] = self._vInventory["UPGRADES"] or {}
        self._vInventory["SCRAP"] = self._vInventory["SCRAP"] or 0
        self._vInventoryLoaded = true

        self:UpdateClientInventory()
    end)

    if !exists then
        self._vInventory = {}
        self._vInventory["PAGES"] = 1
        self._vInventory["UPGRADES"] = self._vInventory["UPGRADES"] or {}
        self._vInventory["SCRAP"] = self._vInventory["SCRAP"] or 0

        self._vInventoryLoaded = true

        self:UpdateClientInventory()
    end
end

local entWhitelist = {
    "vnp_item_base",
}

function PLAYER:HandleItemPickup(ent) 
    if !ent.isVNPItem && !table.HasValue(entWhitelist, ent:GetClass()) then return end
    if !ent.GetItemData then return end

    local data = ent:GetItemData()
    --hook.Run("Kawiser::LOG::ItemPickedup:2" , data.Name , data.LSkins , data.UID , self , "Inv")
    if !data then return end
    hook.Run("Kawiser::LOG::ItemPickedup:2" , data.Name , data.LSkins , data.UID , self , "Inv")
    if !data.creator or data.creator == nil then
        data.creator = self:SteamID64()
    end
    ent:Remove()

    self:AddInventoryItem(data)
end

 
function comma_value(amount) -- formats into comma's, since the vnp one is being weird in here
    local formatted = amount
    while true do  
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
      if (k==0) then
        break
      end
    end
    return formatted
  end

  function PLAYER:HandleItemBuying(ent)
    print("HandleItemBuying | Called")
    if not ent.isVNPItem and not table.HasValue(entWhitelist, ent:GetClass()) then  print("No whitelist") return end
    if not ent.GetItemData then print("GetItemData") return end
    local seller = ent:GetOwner()
    if not IsValid(seller) then return end
    local money = self:getDarkRPVar("money") or 0
    local cost = ent:getPrice()
    if money < cost then print("no money") return end
    local data = ent:GetItemData()
    if not data then print("no data") return end
    hook.Run("Kawiser::LOG:ItemBought", data.Name or "No name?", data.LSkins or "No skin?", self, data.UID or "No UID?", seller, comma_value(cost) or cost or "No cost?")
    ent:Remove()
    self:addMoney(-cost)
    seller:ChatPrint("Your " .. data.Name .. " was purchased for $" .. comma_value(cost) .. "!")
    seller:addMoney(cost)
    local slot = self:GetAvailableSlot()
    local isUpgrade = false
    if data.Type ~= "WEAPON" and data.Type ~= "SUIT" then
        slot = self:GetAvailableUpgradeSlot()
        isUpgrade = true
    else
        slot = self:GetAvailableSlot()
    end

    if not slot then return end
    self:SetInventorySlot(slot, data, isUpgrade)
end

local ENTITY = FindMetaTable("Entity")

function ENTITY:SetItemData(data, bool)
    if !data then return end

    self.VNPItemData = data

    local iData = VNP.Inventory:GetItemData(data.Name)

    if !iData then return end

    local color = iData.ColorModel && VNP.Inventory:GetRarityValue(data.Rarity.Name, "Color") or iData.Color

    if !self:IsWeapon() then 

        if iData.Model then
            self:SetModel(iData.Model)

            
            local mins,maxes = self:GetModelBounds()
            local z = maxes.z-mins.z


            local pos = self:GetPos()

            self:SetPos(pos+Vector(0,0,z))
        end

        if iData.Material then
            self:SetMaterial(iData.Material)
        end

        if color && IsColor(color) then
            self:SetColor(color)
        end
        
        timer.Simple(0.5, function()
            if !IsValid(self) then return end
            VNP:Broadcast("VNP.EntityItemData", {ent = self, item = self.VNPItemData})
        end)

        return 
    end

    if bool then return end
    if self.AppliedStats then return end
    
    self.AppliedStats = true

    local stats = {}

    if data.Rarity && data.Rarity.Modifiers then
        for stat,val in pairs(data.Rarity.Modifiers) do
            if !iData.Modifiers[stat] then
                continue
            end
            stats[stat] = iData.Modifiers[stat]*(1+val/100)
        end
    end

    local networked = false

    for slot,gem in pairs(data.Sockets) do
        if !gem then continue end
        if !gem.Modifiers then continue end

        local ShouldNetwork = VNP.Inventory:GetItemData(gem.Name, "OnBulletFire")

        if ShouldNetwork && !networked then
            networked = true
            timer.Simple(0.5, function()
                if !IsValid(self) then return end
                VNP:Broadcast("VNP.EntityItemData", {ent = self, item = self.VNPItemData})
            end)
        end

        local mods = gem.Modifiers

        if mods[data.Rarity.Name] then
            mods = mods[data.Rarity.Name]
        end

        for stat,val in pairs(mods) do
            if !stats[stat] then continue end

            if mods[stat] then
                stats[stat] = stats[stat]*(1+(mods[stat]/100))
                if stats[stat] < 0 then stats[stat] = 0 end
            end
        end
    end

    timer.Simple(0, function()
        if !IsValid(self) then return end
        for stat,val in pairs(stats) do
            self:StreamStat(stat, val)
            if stat == "ClipSize" then
                self:SetClip1(val)
                //print(self)
                //self:GiveAmmo(val * 2, self:GetPrimaryAmmoType(), true)
            end
        end
    end)
end