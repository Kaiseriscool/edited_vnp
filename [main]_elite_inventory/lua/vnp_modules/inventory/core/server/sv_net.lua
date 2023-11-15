VNP.Inventory = VNP.Inventory or {}

local mvTbl = {
    "UPGRADEGEM",
    "SCROLL",
    "GEM"
}

VNP:AddNetworkString("VNP.ScrapItem", function(ply, data)
    local slot = data.slot or -1

    local item = ply._vInventory[slot]

    if !item then return end

    ply:SetInventorySlot(slot, nil)
    
    ply._vInventory["SCRAP"] = ply._vInventory["SCRAP"] or 0
    ply._vInventory["SCRAP"] = ply._vInventory["SCRAP"] + VNP.Inventory:GetRarityValue(item.Rarity.Name, "Scrap")

    ply:UpdateClientInventory()
end)

VNP:AddNetworkString("VNP.MoveItem", function(ply, data)
    local slot1 = data.slot1
    local slot2 = data.slot2
    local isUpgrade = data.isUpgrade or false

    local maxSlots = ply:GetInventoryPages()*VNP.Inventory:SlotsPerPage()

    if (isUpgrade && slot1 > 60) or (slot1 > maxSlots) then return end
    if (isUpgrade && slot2 > 60) or (slot2 > maxSlots) then return end

    local data1 = isUpgrade && ply._vInventory["UPGRADES"][slot1] or !isUpgrade && ply._vInventory[slot1]
    local data2 = isUpgrade && ply._vInventory["UPGRADES"][slot2] or !isUpgrade && ply._vInventory[slot2]

    if !isUpgrade && ((data1 && table.HasValue(mvTbl, data1.Type)) or (data2 && table.HasValue(mvTbl, data2.Type))) then return end

    ply:SetInventorySlot(slot1, data2, isUpgrade)
    ply:SetInventorySlot(slot2, data1, isUpgrade)
end)

VNP:AddNetworkString("VNP.UseItem", function(ply, data) -- Needs more work and TESTING
    local slot = data.slot
    local useType = data.useType
    local args = data.args

    if !slot or !useType or !args then return end
    
    if !ply._vInventory[slot] then return end

    local item = ply._vInventory[slot]

    if !item then return end

    local data = VNP.Inventory:GetItemData(item.Name)

    if data.UseFunctions && data.UseFunctions[useType] then
        print(useType , item)
        local remove = data.UseFunctions[useType](ply, item, args)

        if remove then
            ply:RemoveInventoryItem(slot, nil)
        end
    end
end)

VNP:AddNetworkString("VNP.UseScroll", function(ply, data)
    local scroll = ply._vInventory["UPGRADES"][data.scrollSlot]
    local isUpgrade = data.isUpgrade or false
    
    local item = !isUpgrade && ply._vInventory[data.itemSlot] or ply._vInventory["UPGRADES"][data.itemSlot]
    local gem = ply._vInventory["UPGRADES"][data.gemSlot]

    if !scroll or !item then return end

    local sdata = VNP.Inventory:GetItemData(scroll.Name)

    if sdata.CanEnhance && !sdata.CanEnhance(scroll,item) then return end

    if sdata.OnEnhance then
        local item, doRemoveScroll, notify = sdata.OnEnhance(ply, scroll, item, gem)

        if doRemoveScroll then
            ply:RemoveInventoryItem(data.scrollSlot, true)

            if gem ~= nil then
                ply:RemoveInventoryItem(data.gemSlot, true)
            end
        end

        if item then
            ply:SetInventorySlot(data.itemSlot, item, isUpgrade)

            VNP:Broadcast("VNP.ItemNotification", {item = item})
        end

        if notify then
            ply:SendData("VNP.ScrollResult", {msg = notify})
        end
    end
    
    ply:UpdateClientInventory()
end)

VNP:AddNetworkString("VNP.UpgradeScroll", function(ply, data)
    local slot = data.slot
    local item = ply._vInventory["UPGRADES"][slot]

    if !item then return end
    if item.Type ~= "SCROLL" then return end

    local nextRarity = VNP.Inventory:GetNextRarity(item.Rarity.Name, "Name")

    if !nextRarity then return end

    local money = ply:getDarkRPVar("money") or 0
    local cost = VNP.Inventory:GetItemData(item.Name, "UpgradeCost") or 0
    local increment = VNP.Inventory:GetItemData(item.Name, "UpgradeIncrement") or 1
    local order = VNP.Inventory:GetRarityValue(item.Rarity.Name, "Order") or 1
    local amt = item.Amount or 1

    cost = cost * (increment*order) * amt

    if money < cost then return end

    ply:addMoney(-cost)

    item.Rarity.Name = nextRarity

    if item.Rarity.Modifiers then
        item.Rarity.Modifiers = self:CalcRarityMods(item.Name, item.Rarity.Name)
    end

    ply:SetInventorySlot(slot, item, true)
end)

VNP:AddNetworkString("VNP.UnsocketGem", function(ply, data) -- Needs more work and TESTING
    local slot = data.slot
    local socket = data.socket

    if !slot or !socket then return end
    
    local money = ply:getDarkRPVar("money") or 0
    local cost = VNP.Inventory.GemSlotUpgrades[socket] or socket*VNP.Inventory.GemSlotIncrement
    
    cost = cost*(VNP.Inventory.GemSlotUnsocket/100)
    
    if !cost or money < cost then return end

    ply:addMoney(-cost)
    ply:UnsocketGem(slot, socket)
end)

VNP:AddNetworkString("VNP.SocketGem", function(ply, data) -- Needs more work and TESTING
    local slot1 = data.slot1
    local slot2 = data.slot2
    local socket = data.socket

    if !slot1 or !slot2 or !socket then return end
    
    local money = ply:getDarkRPVar("money") or 0
    local cost = VNP.Inventory.GemSlotUpgrades[socket] or socket*VNP.Inventory.GemSlotIncrement

    if !cost or money < cost then return end
    
    local success = ply:SocketGem(slot1, slot2, socket)

    if success then
        ply:addMoney(-cost)
    end
end)

VNP:AddNetworkString("VNP.BuyPage", function(ply, data)
    ply:BuyInventoryPage()
end)

VNP:AddNetworkString("VNP.DropItem", function(ply, data)
    local slot = data.slot or -1
    local isUpgrade = data.IsUpgrade

    local item = !isUpgrade && ply._vInventory[slot] or isUpgrade && ply._vInventory["UPGRADES"][slot]

    if !item then return end
    --PrintTable(item)
    hook.Run("Kawiser::LOG::ItemDrooped:2" , ply , item.Name , item.UID , item.LSkins , "Inv" )
    ply:RemoveInventoryItem(slot, isUpgrade)

    item = table.Copy(item)
    item.Amount = 1

    local ent = ents.Create("vnp_item_base")
    ent:SetPos(ply:GetPos()+(ply:GetForward()*3)+Vector(0,0,5)) -- will make it do something different later
    ent:Spawn()
    ent:SetCollisionGroup(COLLISION_GROUP_WORLD) -- just so the player can go through the entity, also to prevent crashes and all that
    ent:SetItemData(item)
    ent:SetOwner(ply)
end)

VNP:AddNetworkString("VNP.GetInventory", function(ply, data)
    if !ply:IsAdmin() then return end

    local pl = data.ply

    if !IsValid(pl) then return end

    pl.AdminsViewing = pl.AdminsViewing or {}
    pl.AdminsViewing[ply:SteamID64()] = ply

    if IsValid(ply.ViewingInventory) && ply.ViewingInventory ~= pl then
        ply.ViewingInventory.AdminsViewing[ply:SteamID64()] = nil
    end
    ply.ViewingInventory = pl

    ply:SendData("VNP.UpdateAdminMenu", {inv = pl._vInventory})
end)

VNP:AddNetworkString("VNP.CloseAdminMenu", function(ply, data)
    if !ply:IsAdmin() then return end

    ply.ViewingInventory = nil

    for _,pl in ipairs(player.GetHumans()) do
        if pl.AdminsViewing && pl.AdminsViewing[ply:SteamID64()] then
            pl.AdminsViewing[ply:SteamID64()] = nil
        end
    end
end)

VNP:AddNetworkString("VNP.AdminStealItem", function(ply, data)
    if !ply:IsAdmin() then return end
    local pl = data.ply
    local slot = data.slot
    local isUpgrade = data.isUpgrade or false

    if !pl or !slot then return end

    local item = isUpgrade && pl._vInventory["UPGRADES"][slot] or pl._vInventory[slot]
    --hook.Run("Kawiser::LOG::AdminThiefed" , ply , pl , item.Name , item.UID , item.LSkin)
    if !item then return end

    pl:SetInventorySlot(slot, nil, isUpgrade)
    hook.Run("Kawiser::LOG::AdminThiefed" , ply , pl , item.Name , item.UID , item.LSkin)
    ply:AddInventoryItem(item)
end)

VNP:AddNetworkString("VNP.AdminDeleteItem", function(ply, data)
    if !ply:IsAdmin() then return end
    local pl = data.ply
    local slot = data.slot
    local isUpgrade = data.isUpgrade or false

    if !pl or !slot then return end

    local item = isUpgrade && pl._vInventory["UPGRADES"][slot] or pl._vInventory[slot]
    
    if !item then return end
    hook.Run("Kawiser::LOG::AdminDeleted" , ply , pl , item.Name , item.UID , item.LSkin)
    pl:SetInventorySlot(slot, nil, isUpgrade)
end)

VNP:AddNetworkString("VNP.AdminClearScrap", function(ply, data)
    if !ply:IsAdmin() then return end
    
    local pl = data.ply

    pl._vInventory["SCRAP"] = 0

    pl:UpdateClientInventory()
end)

VNP:AddNetworkString("VNP.BuyItem", function(ply, data)
    local ent = data.ent

    if ent.BeingUsed then return end

    local dist = ply:GetPos():DistToSqr(ent:GetPos())

    if dist > 5000 then return end

    ent.BeingUsed = true

    if ent:GetOwner() == ply then
        ply:HandleItemBuying(ent)
    else
        ply:HandleItemBuying(ent)
    end
end)

VNP:AddNetworkString("VNP.PickupItem", function(ply, data)
	if ply.LatestPickup and ply.LatestPickup > CurTime() then return  end
    local ent = data.ent
	if ent.LockEntity then return end
    if not IsValid(ent) then return end
    if not ent.isVNPItem then return end
    if ent:forSale() then return end
    if ent.BeingUsed then return end
    if not IsValid(ply) then return end
    local dist = ply:GetPos():DistToSqr(ent:GetPos())
    if dist > 5000 then return end
    ent.BeingUsed = true
		timer.Simple(0.25, function()
    --hook.Run("Kawiser::LOG::ItemPickedup:2" , ent.Name , ent.LSkins , ply , ent.UID , "INV")
    ply:HandleItemPickup(ent)
    end)
	ply.LatestPickup = CurTime() + 0.45
end)


VNP:AddNetworkString("VNP.Upgradev1", function(ply, data)
    --if !ply:IsAdmin() then return end
    local pl = ply
    --local pl = data.ply
    local slot = data.slot
    --local isUpgrade = data.isUpgrade or false

    if !pl or !slot then return end
    print(slot)
    local item = pl._vInventory[slot]

    if !item then return end
    --print(item)
    --PrintTable(item)
    if item.Type ~= "SUIT" then return end
    if item.Name ~= "Admin Suit" then return end
    if item.SuitHealth < VNP.Inventory.AdminSuitUpgrader.Health then return end
    local money = ply:getDarkRPVar("money") or 0
    local cost = VNP.Inventory.AdminSuitUpgrader.Price
    if money < cost then return end
    ply:addMoney(-cost)
    // Can begin the "upgrade" process
    --print(item:GetItemData())

    pl:SetInventorySlot(slot, nil, false)
    local e = VNP.Inventory:CreateItem("Admin Suit V2" , "Common")
    e.creator = ply:SteamID64()
    pl:AddInventoryItem(e)
end)