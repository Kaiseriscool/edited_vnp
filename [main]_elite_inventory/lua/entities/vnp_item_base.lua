AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Author = ""
ENT.Contact = ""
ENT.AdminOnly = false
ENT.Spawnable = false
ENT.PrintName = "VNP Item Base"
ENT.Category = "VNP"
ENT.DisableDuplicator = true
ENT.VNPItemName = nil
ENT.isVNPItem = true


function ENT:Initialize()

	self:AddEFlags(EFL_NO_THINK_FUNCTION)

    if !SERVER then return end

	self:SetUseType( SIMPLE_USE )
    self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:DrawShadow(false)

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)


    local Phys = self:GetPhysicsObject()
   
    if IsValid(Phys) then
        Phys:Wake() 
    end
	
	self.LockEntity = false
	self.BeingUsed = false
	
    local d = VNP.Inventory.ItemDeletion or 60

    timer.Simple(d, function()
        if IsValid(self) && !self:forSale() then self:Remove() end
    end)

    if self.VNPItemName then
        local rarity = self.ItemRarity or "Common"
        local item = VNP.Inventory:CreateItem(self.VNPItemName, rarity)

        if item then
           self:SetItemData(item)

           self:PhysicsInit(SOLID_VPHYSICS)
           self:SetMoveType(MOVETYPE_VPHYSICS)
           self:SetSolid(SOLID_VPHYSICS)
           self:SetCollisionGroup(COLLISION_GROUP_NONE)
           
           local Phys = self:GetPhysicsObject()
          
           if IsValid(Phys) then
               Phys:Wake() 
           end
        end
    end
end

function ENT:Use(ply)
    if CLIENT then return end
    if !IsValid(ply) or !ply:IsPlayer() then return end
    if ply:Crouching() then return end

	if self.LockEntity then return end
	if self.BeingUsed then return end
    local item = self:GetItemData()

    if !item then return end

    local idata = VNP.Inventory:GetItemData(item.Name)

    if self:forSale() then
        ply:SendData("VNP.BuyItem", {ent = self, price = self:getPrice(), idata = idata.Name}) -- i'm so stupid..
        return 
    end

    if idata.UseFunctions && idata.UseFunctions["Equip"] then
		self.LockEntity = true
        local doRemove = idata.UseFunctions["Equip"](ply, item)
        if doRemove then
            self:Remove()
        else
			timer.Simple(5, function()
				if IsValid(self) then
					self.LockEntity = false
				end
			end)
		end
    end
end
/*
function ENT:Initialize()

	self:AddEFlags(EFL_NO_THINK_FUNCTION)

    if !SERVER then return end

	self:SetUseType( SIMPLE_USE )
    self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:DrawShadow(false)

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    
    local Phys = self:GetPhysicsObject()
   
    if IsValid(Phys) then
        Phys:Wake() 
    end

    local d = VNP.Inventory.ItemDeletion or 60

    timer.Simple(d, function()
        if IsValid(self) && !self:forSale() then self:Remove() end
    end)

    if self.VNPItemName then
        local rarity = self.ItemRarity or "Common"
        local item = VNP.Inventory:CreateItem(self.VNPItemName, rarity)

        if item then
           self:SetItemData(item)

           self:PhysicsInit(SOLID_VPHYSICS)
           self:SetMoveType(MOVETYPE_VPHYSICS)
           self:SetSolid(SOLID_VPHYSICS)
           self:SetCollisionGroup(COLLISION_GROUP_NONE)
           
           local Phys = self:GetPhysicsObject()
          
           if IsValid(Phys) then
               Phys:Wake() 
           end
        end
    end
end

function ENT:Use(ply)
    if CLIENT then return end
    if !IsValid(ply) or !ply:IsPlayer() then return end
    if ply:Crouching() then return end
    if self:forSale() then
        ply:SendData("VNP.BuyItem", {ent = self, price = self:getPrice()})
        return 
    end

    local item = self:GetItemData()

    if !item then return end

    local idata = VNP.Inventory:GetItemData(item.Name)

    if idata.UseFunctions && idata.UseFunctions["Equip"] then
        local doRemove = idata.UseFunctions["Equip"](ply, item)
        if doRemove then
            self:Remove()
        end
    end
end

*/
function ENT:forSale()
    return self:GetNWBool("VNP.ForSale", false)
end

function ENT:getPrice()
    return self:GetNWInt("VNP.Price", 0)
end

if CLIENT then

    local function drawCircle( x, y, radius, seg )
        local cir = {}
    
        table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
        for i = 0, seg do
            local a = math.rad( ( i / seg ) * -360 )
            table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
        end
    
        local a = math.rad( 0 )
        table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
    
        surface.DrawPoly( cir )
    end

    local radius = VNP:resFormatW(75)

    function ENT:Draw()
        self:DrawModel()

        local dist = LocalPlayer():GetPos():DistToSqr(self:GetPos())

        if !IsValid(self.iteminfo) && dist > 50000 then return end

        local entity = LocalPlayer():GetEyeTrace().Entity

        if !IsValid(self.iteminfo) && self:forSale() then
            local ppos = LocalPlayer():GetPos()
            local peyepos = LocalPlayer():EyePos()

            local pos = self:GetPos() + Vector( 0, 0, 35 )
            local angs = self:GetAngles()
            local dir = (pos - peyepos):Angle()

            dir:RotateAroundAxis( dir:Right(), 90 )
            dir:RotateAroundAxis( dir:Up(), -90 )

            cam.Start3D2D( pos + Vector( 0, 0, math.sin(CurTime())*-5 ), dir, .1 )
                surface.SetDrawColor( Color( 45, 45, 45, 255 ) )
                draw.NoTexture()
                drawCircle( 0, 0, (radius-2)+4, 32 )
                surface.SetDrawColor( Color( 255, 255, 255, 5 ) )
                drawCircle( 0, 0, (radius-2), 32 )

                draw.SimpleText( "$", "VNP.Font.46", 0, -4, Color( 75, 200, 75, 255 ), 1, 1 )
            cam.End3D2D()
        end

        if entity ~= self then
            if IsValid(self.iteminfo) then self.iteminfo:Remove() end
            return 
        end
        
        if IsValid(self.iteminfo) then return end


        local data = self:GetItemData()

        if !data then return end

        self.iteminfo = vgui.Create("VNPItemInfo")
        self.iteminfo._parent = self
        self.iteminfo:SetItemData(data)
        self.iteminfo:Center()

        local x,y = self.iteminfo:GetPos()

        self.iteminfo:SetPos(x,y-VNP:resFormatH(250)) 




        if self:forSale() then
            local text = "FOR SALE  $"..VNP:FormatNumber(self:getPrice())

            local w,h = VNP:GetTextSize(text, 22)

            
            local gap = VNP:resFormatH(30)

            self.iteminfo.salePrice = vgui.Create("DPanel")
            self.iteminfo.salePrice:SetSize(w*1.1,h*1.7)


            local x,y = self.iteminfo.salePrice:GetPos()

            self.iteminfo.salePrice:SetPos(x,y-VNP:resFormatH(30))

            self.iteminfo.OnSizeChanged = function(panel, w, h) -- change pos 
                self.iteminfo.salePrice:SetPos(0, self.iteminfo:GetTall() + VNP:resFormatH(150))
                self.iteminfo.salePrice:CenterHorizontal()
            end


            self.iteminfo.salePrice.Paint = function(s,w,h)
                if !IsValid(self) then return end
                draw.RoundedBox(0,0,0,w,h,Color(0,0,0,245))
                
                local xW, xH = VNP:DrawText("FOR SALE  ", 22, w*.05,h/6, Color(50, 150, 50, 255), 0, 1)
                VNP:DrawText("$"..VNP:FormatNumber(self:getPrice()), 22, w*.05+xW,h/6, Color(75, 200, 75, 255), 0, 1)
            end

            self.iteminfo.OnRemove = function(s)
                if IsValid(s.salePrice) then s.salePrice:Remove() end
            end
        end
    end
end