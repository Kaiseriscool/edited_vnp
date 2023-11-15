VNP.Inventory = VNP.Inventory or {}

local inv

VNP:AddNetworkString("VNP.UpdateClientInventory", function(ply, data)
    if !data.Inventory then return end

    if !IsValid(ply) then
        inv = data.Inventory
    else
        ply._vInventory = data.Inventory
    end
end)

VNP:AddNetworkString("VNP.StreamStat", function(ply, data)
    local name = data.name
    local val = data.val
    local weapon = data.weapon

    if !IsValid(weapon) then return end

    weapon:StreamStat(name, val)
end)

VNP:AddNetworkString("VNP.ScrollResult", function(ply, data)
    local msg = data.msg
    local delay = .1

    if IsValid(VNP.Inventory.EnhanceMenu) then VNP.Inventory.Menu:SetParent(nil) end

  /*

 if msg == "Failed" then
    print("hi")
    end */

    local scrw, scrh = ScrW(), ScrH()
    local notify = vgui.Create("EliteUI.Message")
    notify:SetTitle("Good Work!")
    notify:SetSize(scrw * .15, scrh * .5)
    notify:Center()
    notify:MakePopup()
    notify:SetText(msg)
    notify:SetButtonText("Okay!")
end)

VNP:AddNetworkString("VNP.UpdateAdminMenu", function(ply, data)
    local inv = data.inv

    if !IsValid(VNP.Inventory.AdminMenu) then return end

    VNP.Inventory.AdminMenu:SetInvData(inv)
end)

hook.Add("InitPostEntity", "VNP.InitializedEnts", function()
    LocalPlayer()._vInventory = inv
end)

VNP:AddNetworkString("VNP.EntityItemData", function(ply, data)
    local ent = data.ent
    local item = data.item

    print(item)
    

    if !IsValid(ent) or !item then return end
    
    ent.VNPItemData = item
end)

VNP:AddNetworkString("VNP.BuyItem", function(ply, data)
    local ent = data.ent -- get the entity from the data table
    local price = data.price
    local name = data.idata

    -- Your (item name here) was purchased for (price here)!
    local money = ply:getDarkRPVar("money") or 0
    
    if price > money then
        return
    end

    local panel = Derma_Query("Are you sure you want to buy:" .. name .. "\nFor: $" .. VNP:FormatNumber(price), "Elite Shops", "Yes", function()
        VNP:Broadcast("VNP.BuyItem", {ent = ent})
        ply:ChatPrint("Bought " .. name .. " for" .. " $" .. VNP:FormatNumber(price) .. "!")
    end, "No", function()
        if not IsValid(panel) then return end
        panel:Close()        
    end)
end)

local function getBone(ply)
	local used = {}

	local boneCount = ply:GetBoneCount()
	local numTried = 0

	local pos

	repeat
		local idx = math.random(0, boneCount - 1)
		numTried = numTried + 1

		pos = ply:GetBonePosition(idx)
	until pos || (numTried >= boneCount)

	return pos || ply:EyePos()
end

VNP:AddNetworkString("VNP.DOTParticle", function(ply, data)
    local target = data.target
    local color = data.color
    
    if !IsValid(target) then return end

    local emitter = ParticleEmitter(Vector())
	for i = 1, 50 do
		timer.Simple(0.5 * math.random(), function()
			if(!IsValid(emitter)) then return end
			local prt = emitter:Add("particles/flamelet"..math.random(1, 5), getBone(target) + VectorRand() * 5)
			prt:SetVelocity(Vector(0, 0, -i))
			prt:SetColor(color.r,color.g,color.b)
			prt:SetDieTime(0.3 + math.random())
			prt:SetStartAlpha(250)
			prt:SetEndAlpha(0)
			prt:SetStartSize(2)
			prt:SetEndSize(5)
		end)
	end
	timer.Simple(0.6, function()
		if(IsValid(emitter)) then emitter:Finish() end
	end)
end)

VNP:AddNetworkString("VNP.ItemNotification", function(ply, data)
    local item = data.item

  --  if !item then return end 

    VNP.Inventory:CreateItemNotification(item)
end)





local electricMat = Material( "cable/blue_elec" )

local tazePlayers = {}

local function randpos( ply, amplifier )
	local amplifier = amplifier or 25
	local pos = ply:GetPos()
	return Vector( pos.x + math.Rand( -amplifier, amplifier ), pos.y + math.Rand( -amplifier, amplifier ), pos.z )
end

local function drawTaze(ply)
    render.SetMaterial( electricMat )

	local midpoint = randpos( ply ) + Vector( 0, 0, math.Rand(20,60) )
	render.DrawBeam( randpos( ply, 10 ), midpoint, math.Rand(5,10), math.Rand(5,15), 0, Color( 255, 255, 255, 255 ) )
	render.DrawBeam( midpoint, randpos( ply, 10 ) + Vector( 0, 0, 70 ), math.Rand(5,5), math.Rand(5,5), 0, Color( 255, 255, 255, 255 ) )
end

hook.Add("PostDrawOpaqueRenderables", "VNP.Inventory.DrawEffects", function()
	for _,ply in pairs(player.GetAll()) do
        if !ply:GetNW2Bool("VNP.Tazed", false) or !ply:Alive() then continue end

        drawTaze(ply)
    end
end)

local useDelay = 0

local function handleItemPickup(ent)
    if ent:forSale() then
        local price = ent:getPrice()
        local ply = LocalPlayer()
        local money = ply:getDarkRPVar("money") or 0

        local panel = Derma_Query("Would you like to pick up this item?", "Elite Shops", "Yes", function()
            VNP:Broadcast("VNP.BuyItem", {ent = ent})
        end, "No", function()
            if not IsValid(panel) then return end
            panel:Close()        
        end) 

        if not IsValid(panel) then return end
    else
        VNP:Broadcast("VNP.PickupItem", {ent = ent})
    end
end

hook.Add("Think", "VNP.UseEntity", function() -- He wanted CTRL E for using...
    local keydown = input.IsKeyDown(KEY_LCONTROL)
    local epressed = input.IsKeyDown(KEY_E)

    if keydown && epressed && CurTime() >= useDelay then

        useDelay = CurTime() + 1

        local ent = LocalPlayer():GetEyeTrace().Entity

        if !IsValid(ent) then return end
        if !ent.isVNPItem then return end

        handleItemPickup(ent) 
    end
end)