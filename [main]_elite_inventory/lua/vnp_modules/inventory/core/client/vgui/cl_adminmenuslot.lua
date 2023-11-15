
local PANEL = {}


local Lerp = Lerp

AccessorFunc( PANEL, "m_AllowOptions", "AllowOptions" )

function PANEL:Init()
    self:SetText("")
    
    
    self.SetText = function(s, text)
        self.m_Text = text
    end

    self.m_AllowOptions = true
    self.lerp = 0
    self.IsUpgrade = false
end

function PANEL:SetSlot(slot)
    self.Slot = slot
end

function PANEL:GetItemData()
end

function PANEL:SetItemData(data)
    self.Data = data
    if !data then self.Color = nil return end
    self.Color = VNP.Inventory:GetRarityValue(data.Rarity.Name, "Color")
end

function PANEL:Paint(w,h)

    local color = self.Color && self.Color or Color(150,150,150)

    if !IsColor(color) && color == "rainbow" then
        color = HSVToColor( CurTime()%11.25*32, .65, 1 )
    end

    if self.Data then
        color.a = 20
    else
        color.a = 10
    end

    local c = VNP:resFormatW(2.5)

    draw.RoundedBox(4,0,0,w,h,color)

    color.a = 100

    color = self.Color && VNP:Darken(color, 2) or Color(0, 0, 0, 100)

    surface.SetDrawColor(color)
    surface.DrawRect(c, c, w - c * EliteUI.Scale(2), h - c * EliteUI.Scale(2))

    if self.Data && self.Data.Type == "SUIT" then

        local suitMaxHealth = VNP.Inventory:CalculateMaxStat(self.Data, "SuitHealth")
        local suitMaxArmor = VNP.Inventory:CalculateMaxStat(self.Data, "SuitArmor")

        local suitHealth = math.Round(self.Data["SuitHealth"])
        local suitArmor = math.Round(self.Data["SuitArmor"])

        local width = w-c*4


        surface.SetDrawColor(Color(10,10,10,100))
        surface.DrawRect(c*2, h-c*3, width, c*1.5)

        surface.SetDrawColor(Color(65,198,65))
        surface.DrawRect(c*2, h-c*3, math.min(suitHealth*(width/suitMaxHealth), width), c*1.5)

        surface.SetDrawColor(Color(10,10,10,100))
        surface.DrawRect(c*2, h-c*4.5, width, c*1.5)

        surface.SetDrawColor(Color(1,156,254))
        surface.DrawRect(c*2, h-c*4.5, math.min(suitArmor*(width/suitMaxArmor), width), c*1.5)
    end

    if !self.Data && self.m_Text then
        local tW,tH = VNP:GetTextSize(self.m_Text, 24)
        VNP:DrawText(self.m_Text, 24, w/2-tW/2,h/2-tH/2,color_white,0)
    end

    if self.Data && self.Data.Amount && self.Data.Amount > 1 then
        VNP:DrawText(self.Data.Amount, 16, w*0.075,h*.7,Color(150,150,150),0)
    end

    self:PostPaint(w,h)


    if self:IsDragging() then return end -- Do hover stuff below
    local hovered = self:IsHovered()

    if (self.lerp < 0.05 and not hovered) then return end

    self.lerp = math.Round(Lerp(.075 * FrameTime() * 100, self.lerp, hovered && 20 or 0), 2)
    draw.RoundedBox(4, 0, 0, w, h, Color(255, 255, 255, self.lerp ))
end

function PANEL:PostPaint(w,h)
end



function PANEL:Think()

    if self:IsDragging() && !self.Data then
        dragndrop.StopDragging() -- Aids but ya know
    end

    local hovered = self:IsHovered()  
    if hovered && self.Data  && !IsValid(self.iteminfo) then
        self.iteminfo = vgui.Create("VNPAdminItemInfo")
        self.iteminfo:SetItemData(self.Data)
        self.iteminfo._parent = self
        
        local x,y = self:LocalToScreen(0,0)
        self.iteminfo:SetPos(x+self:GetWide(),y ) 

    elseif !hovered && IsValid(self.iteminfo) then
            self.iteminfo:Remove()


    end




    self.NextThink = self.NextThink or CurTime() + 0.1
	if self.NextThink < CurTime() then return end -- Delay
    self.NextThink = CurTime() + 0.1
    
    local data = self:GetItemData()

    if self.Data == data then return end

    self:SetItemData(data)

    if self.Model then self.Model:Remove() end
    if self.Data and (!self.Model or !IsValid(self.Model)) then
       local itemData = VNP.Inventory:GetItemData(self.Data.Name)
       if !itemData then return end
       if !itemData.Model then return end

       local color = itemData.Color or itemData.ColorModel && self.Color
       local mat = itemData.Material or false
       self.Model = VNP.Inventory:CreateModel(itemData.Class, 0,0, self:GetWide(), self:GetTall(), self, itemData.Model, IsColor(color) && color or false, mat) 
    end
end

function PANEL:DoRightClick()
    if !self.Data then return end
    if !self.Slot then return end

    if self.m_AllowOptions then
        if IsValid(self.options) then self.options:Remove() end

        self.options = vgui.Create("VNPOptionMenu")

        local data = VNP.Inventory:GetItemData(self.Data.Name)
        local scrapAmt = VNP.Inventory:GetRarityValue(self.Data.Rarity.Name, "Scrap") or 0

        if data.UseFunctions then
            for name, func in pairs(data.UseFunctions) do
                self.options:AddOption(name, function()
                    VNP:Broadcast("VNP.UseItem", {slot = self.Slot, useType = name, args = {}})
                end)
            end
        end

        if self.Data.Type == "SCROLL" then
            self.options:AddOption("Upgrade Scroll", function() // Long name ;o
                if IsValid(VNP.Inventory.Menu.ItemUpgrades) then VNP.Inventory.Menu.ItemUpgrades:Remove() end

                VNP.Inventory.ItemUpgrades = vgui.Create("VNPItemSocketMenu")
            end)
        end

        if VNP.Inventory:IsUpgrade(self.Data.Type) then -- Aids since I'm doing it below but it has to be exactly to specification and they want it this way so
            self.options:AddOption( "Enhance", function()
                VNP.Inventory:OpenEnhanceMenu()
            end)
        end

        self.options:AddOption( "Drop", function()
            VNP:Broadcast("VNP.DropItem", {slot = self.Slot, IsUpgrade = self.IsUpgrade})
        end)

        if self.Data.Type == "WEAPON" then
            self.options:AddOption( "Enhance", function()
                VNP.Inventory:OpenEnhanceMenu()
            end)

            self.options:AddOption( "Sockets", function() // Long name ;o
                if IsValid(VNP.Inventory.Menu.ItemUpgrades) then VNP.Inventory.Menu.ItemUpgrades:Remove() end

                VNP.Inventory.ItemUpgrades = vgui.Create("VNPItemSocketMenu")
            end)

            self.options:AddOption( "Scrap x"..scrapAmt, function()
                VNP:Broadcast("VNP.ScrapItem", {slot = self.Slot})
            end)
        elseif self.Data.Type == "SUIT" then
            self.options:AddOption( "Enhance", function()
                VNP.Inventory:OpenEnhanceMenu()
            end)

            self.options:AddOption( "Sockets", function() // Long name ;o
                if IsValid(VNP.Inventory.Menu.ItemUpgrades) then VNP.Inventory.Menu.ItemUpgrades:Remove() end

                VNP.Inventory.ItemUpgrades = vgui.Create("VNPItemSocketMenu")
                VNP.Inventory.ItemUpgrades.DoSockets = true
            end)

            self.options:AddOption( "Repair", function() // Long name ;o
                if IsValid(VNP.Inventory.Menu.ItemUpgrades) then VNP.Inventory.Menu.ItemUpgrades:Remove() end

                VNP.Inventory.ItemUpgrades = vgui.Create("VNPItemSocketMenu")
            end)
        end


		self.options:Open()
    end
end

vgui.Register( "VNPAdminMenuSlot", PANEL, "DButton")