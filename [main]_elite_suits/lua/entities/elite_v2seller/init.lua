AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )



function ENT:Initialize()
	self:SetModel( "models/Combine_Soldier_PrisonGuard.mdl" )
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal()
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid( SOLID_BBOX )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE )
	self:CapabilitiesAdd( CAP_TURN_HEAD )
	self:SetMaxYawSpeed( 90 )
	self:SetUseType( SIMPLE_USE )
	self:DropToFloor()
	self:SetTrigger( true )
	local phys = self:GetPhysicsObject()
	if ( phys:IsValid() ) then
		phys:Wake()
	end
end

-- damn lweo doing some trashy coding!! 

function ENT:Use( p, data )
	if ( p:IsPlayer() ) then
     if p:GetSuit() then

		local moneyneeded = 500000000

		local moneyspent = -500000000

		local money = p:getDarkRPVar("money") or 0

		local item = p:GetSuit()

		local name = VNP.Inventory:GetItemData(item.Name, "Name")


		-- a table just to check if it's an admin suit or not

		local simpletable = {

			["Admin Suit"] = true,
			
		  }

		if !simpletable[name] then
			p:ChatPrint("<color=255,0,0>[ADMIN SUIT UPGRADER]</color>".." The suit you currently have on isn't an admin suit!")
			return 
		end

		-- just to check if they even have enough money

		if money < moneyneeded then 
			p:ChatPrint("<color=255,0,0>[ADMIN SUIT UPGRADER]</color>".." You don't have enough money to upgrade your suit!")
			return 
		end

		-- returns true instead of end if the suit has 40k HP

        if item["SuitHealth"] > 40000 then
			p:ChatPrint("<color=255,0,0>[ADMIN SUIT UPGRADER]</color>".." The suit you currently have on has 40k HP!")
		end

		-- checks if the suit doesn't have 40k HP

		if item["SuitHealth"] < 40000 then
			p:ChatPrint("<color=255,0,0>[ADMIN SUIT UPGRADER]</color>".." The suit you currently have on doesn't have 40k HP!")
			return 
		end

		-- checks if it's an admin suit with the right requirements 

		if item && item["SuitHealth"] > 40000 then
			p:ChatPrint("<color=255,0,0>[ADMIN SUIT UPGRADER]</color>".." This is an admin suit, with the right requirements!")
		end


		 p:RemoveSuit()
		 p:ChatPrint("<color=255,0,0>[ADMIN SUIT UPGRADER]</color>".." You have a 40k HP admin suit, you spent 500 million dollars on the upgrade! The upgraded suit is in your inventory.")
		 p:addMoney(moneyspent)
		 print( Entity(1), "has a suit and successfully used the upgrader." )
		 
		 -- adds the entity to the inventory, instead of dropping it to the player on the ground

		 additem = VNP.Inventory:CreateItem("Admin Suit V2", "Common")
		 p:AddInventoryItem(additem)


    else
         print( Entity(1), "has no suit and is attempting to use the upgrader." )
		 p:ChatPrint("<color=255,0,0>[ADMIN SUIT UPGRADER]</color>".." You have no suit, you need an admin suit that has 40k HP and 500 million dollars for this upgrade! ")

     end
	end
end