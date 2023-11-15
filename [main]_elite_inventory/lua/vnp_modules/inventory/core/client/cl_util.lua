VNP.Inventory = VNP.Inventory or {}

function VNP.Inventory:MoveItem(itemSlot, toSlot, isUpgrade)
	if IsValid(self.EnhanceMenu) then return end
	if IsValid(self.ItemUpgrades) then return end
	isUpgrade = isUpgrade or false
	VNP:Broadcast("VNP.MoveItem", {slot1 = itemSlot, slot2 = toSlot, isUpgrade = isUpgrade})
end



local weaponoffsets = {
    ["m9k_tar21"] = {
        x = -2,
        z = -3
    },
    ["inferno_blue"] = {
        zoom = 50
    },
    ["m9k"] = {
        x = 0,
        y = 0,
        z = 0,
        yaw = -8,
        pitch = 5
    },
}

local function findoffsets(input)
	if input == nil then return end
	if string.match(input, "m9k") then
		return "m9k" end
	if string.match(input, "weapon_glock2") then
		return "darkrp" end
	
end

local mat_lightning = CLIENT and Material("icon16/lightning.png", "noclamp, smooth")
local function GenerateView(modelpanel, entity , name , suit)
	local tempModel = IsEntity(entity) and entity or ClientsideModel(entity)
	--print(tempModel)
	local issuit = false
	if suit == nil then issuit = true end
	if issuit then 
	local center = tempModel:OBBCenter()
	modelpanel:SetFOV(35)
	center.z = center.z
	modelpanel:SetLookAt( Vector( 0, 0, 7 ) )
	modelpanel:SetCamPos( Vector( 70, -70, 55 ) )
	else
	--entity = "models/weapons/w_rif_ak47.mdl"
    --local tempModel = ClientsideModel(entity)
    if not IsValid(tempModel) then
        return
    end
	print(suit , "Suit")
	--print(tempModel , "tempModel")
    tempModel:SetAngles(Angle(-45, 0, 0))
    local min, max = tempModel:GetRenderBounds()
    --print(min, max)
    local ism9k = false

    local offset = {
        x = 0,
        y = 0,
        z = 0,
        yaw = 0,
		zoom = 90
    }

	local rainbow_six = findoffsets(suit)
	if rainbow_six == "m9k" then
		offset = weaponoffsets["m9k"]
	elseif rainbow_six == "darkrp" then
		offset.zoom = 105
		offset.yaw = -3
		offset.pitch = 2
	end


    local lookat = (min + max) / 2 + Vector(offset.yaw or 0, 0, offset.pitch or 0)
    modelpanel:SetCamPos(Vector(0 + offset.x, 0.75 * min:Distance(max) + offset.y, lookat.z + offset.z))
    modelpanel:SetLookAt(lookat)
	--print(offset.zoom or 90)
	modelpanel:SetFOV(offset.zoom or 90)
	findoffsets(name)
	// i have fallen into madness
	modelpanel.Paint = function(self, w, h)
        DModelPanel.Paint(self, w, h)
		--print(entity , "FUCKING ENTITY")
		--print(modelpanel , "Real?")
		if !table.HasValue(VNP.Inventory.EnergyWeapons, suit) then return end
        surface.SetMaterial(mat_lightning)
        surface.SetDrawColor(Color(0, 0, 0, 175))
        surface.DrawTexturedRect(4, 4, 8, 12)
    end


end
    --tempModel:Remove()
end



/*


VNP.IconCache = VNP.IconCache or {}
hook.Add("InitPostEntity", "InitInventory", function() 
	if file.Exists("materials/invitems/", "GAME") then
		local files, directories = file.Find("materials/invitems/*", "GAME")
		for k, v in ipairs(files) do
			local class = string.StripExtension(v)
			VNP.IconCache[class] = v
		end
	end
end)


local function Icon(class, x, y, w, h, parent, model, col, mat, bone)

    parent.itemModel = vgui.Create("DImage", parent)
	parent.itemModel:SetSize(w, h)
	parent.itemModel:SetPos(x, y)


    

	parent.itemModel:SetImage("invitems/"..VNP.IconCache[class])
	return parent.itemModel

	
	
end
*/

/*local function Icon(class, x, y, w, h, parent, model, col, mat, bone)

    parent.itemModel = vgui.Create("DPanel", parent)
	parent.itemModel:SetSize(w, h)
	parent.itemModel:SetPos(x, y)
	local ourMat = Material("invitems/"..VNP.IconCache[class])
	parent.itemModel.Paint = function(self, w, h)
		surface.SetMaterial( ourMat ) -- Use our cached material
		surface.DrawTexturedRect( x, y, w, h )
		surface.SetDrawColor( 255, 255, 255, 255 ) -- Set the drawing color


	end
	--parent.itemModel:SetImage("invitems/"..VNP.IconCache[class])
	return parent.itemModel
	
end */

local function ModelPanel(class , cz , x, y, w, h, parent, model, col, mat, bone)
	parent.itemModel = vgui.Create("DModelPanel", parent)
	parent.itemModel:SetSize(w, h)
	parent.itemModel:SetPos(x, y) // no need to change these
	parent.itemModel:SetModel(model)

	if !parent.itemModel.Entity then
		parent.itemModel:Remove()
	    
    end

	parent.itemModel.Think = function()
		if !parent.itemModel.Entity then return end
		local color = parent.itemModel.Entity:GetColor()
		parent.itemModel:SetColor(Color(color.r,color.g,color.b, 255))
		parent.itemModel.Entity:SetRenderMode(RENDERMODE_TRANSALPHA)
		
	end

	if mat then
		parent.itemModel.Entity:SetMaterial(mat)
	end

	if col then
		parent.itemModel.Entity:SetColor(col)
	end
	parent.itemModel:SetMouseInputEnabled(false)

	local mn, mx = parent.itemModel.Entity:GetRenderBounds()
	local size = h
	size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
	size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
	size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
	parent.itemModel:SetFOV(bone and 50 or 47)


	if bone and parent.itemModel then
		centre = parent.itemModel.Entity:GetBonePosition(parent.itemModel.Entity:LookupBone(bone))
		local PrevMins, PrevMaxs = parent.itemModel.Entity:GetRenderBounds()
		parent.itemModel:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(0.75, 0, 0.5))
		parent.itemModel:SetLookAt(centre)
		parent.itemModel.Entity:SetEyeTarget(PrevMins:Distance(PrevMaxs) * Vector(0.75, 0, 0.1))
	else
		GenerateView(parent.itemModel , parent.itemModel.Entity , class , cz)
	end

	parent.itemModel.LayoutEntity = function(ent) end

	return parent.itemModel
end

function VNP.Inventory:CreateModel(class , real_class, x, y, w, h, parent, model, col, mat, bone)
	
  --  if VNP.IconCache[class] then
   --     Icon(class, x, y, w, h, parent, model, col, mat, bone)
		
 --   else
		print("Class/Name -> " .. class)
		if real_class == nil then
			print("Suit mabye?")
		end
        ModelPanel(class , real_class, x, y, w, h, parent, model, col, mat, bone)
  --  end
    return parent.itemModel
end