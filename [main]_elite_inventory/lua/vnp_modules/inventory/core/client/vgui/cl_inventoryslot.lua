local PANEL = {}
OUTLINE_WIDTH = EliteUI.Scale(2)


local Lerp = Lerp

AccessorFunc( PANEL, "m_AllowOptions", "AllowOptions" )

function PANEL:Init()
    self:SetText("")
    self.lerp = 0
    self.hoverDelay = 0.5
    self.hoverStartTime = 0
    self.iteminfo = nil 
    self.itemDataLast = nil

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

    if data.Rarity.Name == "Common" then -- whoever thought about this is stupid.
        self.Color = Color(100,100,100)
    end
end

function PANEL:Paint(w,h) 

    local color = self.Color or Color(78,78,78)

    if !IsColor(color) && color == "rainbow" then
        color = HSVToColor( CurTime()%11.25*32, .65, 1 )
    end

    if self.Data then
        color.a = 150
    else
        color.a = 50
    
    end

    local c = VNP:resFormatW(2.5)

    draw.RoundedBox(4,0,0,w,h,color)

    color.a = 255

    color = self.Color or Color(0, 0, 0, 100)

    surface.SetDrawColor(Color(0, 0, 0, 100))
    surface.DrawRect(OUTLINE_WIDTH, OUTLINE_WIDTH, w - OUTLINE_WIDTH * 2, h - OUTLINE_WIDTH * 2)

    if self.Data && self.Data.Type == "SUIT" then

        local suitMaxHealth = self.Data["SuitHealthMax"]
        local suitMaxArmor = self.Data["SuitArmorMax"]

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
        VNP:DrawText(self.Data.Amount, 16, w*0.075,h*.7,Color(255, 255, 255, 125),0)
    end

    self:PostPaint(w,h)



    local hovered = self:IsHovered()

    if (self.lerp < 0.05 and not hovered) then return end

    self.lerp = math.Round(Lerp(.075 * FrameTime() * 100, self.lerp, hovered && 20 or 0), 2)
    draw.RoundedBox(4, 0, 0, w, h, Color(255, 255, 255, self.lerp ))
end


function PANEL:PostPaint(w,h)
end

function PANEL:OnCursorEntered()
    if (not self.item) then return end
    self.timestamp_cursorentered = CurTime()
    
end

function PANEL:OnCursorExited()
    self.timestamp_cursorentered = nil
end


function PANEL:DoClick()
    self.clickCount = self.clickCount or 0
    self.clickCount = self.clickCount + 1

    if self.clickCount == 2 then
        if self.Data == nil then return end -- just to make sure if that data even exists
        
        local data = VNP.Inventory:GetItemData(self.Data.Name)
     

        if data.UseFunctions then
            for name, func in pairs(data.UseFunctions) do
                VNP:Broadcast("VNP.UseItem", {slot = self.Slot, useType = name, args = {}})
                func()
                self.weaponUsed = true -- basically like if the weapon gets used, the func happens and it does its thing
            end
        end

        self.clickCount = 0 
    end
end

 

function PANEL:Think()
    local hovered = self:IsHovered()

    if hovered and self.Data and not IsValid(self.iteminfo) then
        if not self.hoverStartTime then
            self.hoverStartTime = CurTime() 
        end

        local hoverTimeElapsed = CurTime() - self.hoverStartTime
        if hoverTimeElapsed >= self.hoverDelay then
            self.iteminfo = vgui.Create("VNPItemInfo")
            self.iteminfo:SetItemData(self.Data)
            self.iteminfo._parent = self

            local x, y = self:LocalToScreen(0, 0)
            local screenWidth = ScrW()
            local infoWidth = self.iteminfo:GetWide()
            local xOffset = self:GetWide()

            if x + xOffset + infoWidth > screenWidth then
                xOffset = -infoWidth
            end

            if x + xOffset >= 0 then
                local yOffset = -self.iteminfo:GetTall() * 0.01

                self.iteminfo:SetPos(x + xOffset, y + yOffset)
                self.iteminfo:AlphaTo( 255, 0.15, 0, function() end ) // little bit of animation :3 

                self.iteminfo:MoveTo(x + xOffset, y + yOffset - 10, 0.15, 0.1, 0.3)
            end
        end
    elseif not hovered then
        self.hoverStartTime = nil 

        if IsValid(self.iteminfo) then
            self.iteminfo:Remove()
            self.iteminfo = nil
        end
    end

    if self.Data ~= self.itemDataLast then -- if the data is different when hovered over then
        self.itemDataLast = self.Data

        if IsValid(self.iteminfo) then
            self.iteminfo:SetItemData(self.Data)
        end
    end


    if self:IsDragging() && !self.Data then
        dragndrop.StopDragging() -- Aids but ya know
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))  
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
       --PrintTable(itemData)
       --local item_class = {data = itemData.Class}
       --print(item_class.data , "item_class.data")
        --print("itemData.Class = " , itemData.Class) // works here
        --print(itemData.Class)
       --print(itemData.Name)
       if !itemData then return end
       if !itemData.Model then return end

       local color = itemData.Color or itemData.ColorModel && self.Color
       local mat = self.Data.LSkins or itemData.Material or false

        // some reason i cant thinker itemData.Class nolonger works?
       self.Model = VNP.Inventory:CreateModel(itemData.Name ,itemData.Class, 0,0, self:GetWide(), self:GetTall(), self, itemData.Model, IsColor(color) && color or false, mat) 
    end
        if self.weaponUsed then
            
        if IsValid(self.iteminfo) then
            self.iteminfo:Remove()
            self.iteminfo = nil 
        end
        self.weaponUsed = false
    end
end

function PANEL:DoRightClick()
    if !self.Data then return end
    if !self.Slot then return end

    if self.m_AllowOptions then
        if IsValid(self.options) then self.options:Remove() end

        self.options = vgui.Create("EliteUI.Menu")

        local data = VNP.Inventory:GetItemData(self.Data.Name)
        local scrapAmt = VNP.Inventory:GetRarityValue(self.Data.Rarity.Name, "Scrap") or 0

        if data.UseFunctions then
            for name, func in pairs(data.UseFunctions) do
                self.options:AddOption("Use", function()
                    VNP:Broadcast("VNP.UseItem", {slot = self.Slot, useType = name, args = {}})
                    func()
                    self.weaponUsed = true -- basically like if the wepaon gets used, the func happens and it does it's thing
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
                if self.Data.Rarity.Name != "Glitched" then -- if it isn't glitched then yeahh
                    VNP:Broadcast("VNP.ScrapItem", {slot = self.Slot})
                end
                
                if self.Data.Rarity.Name == "Glitched" then -- if it's glitched then just a make sure omg
                    
                local panel = Derma_Query("Are you sure you want to scrap this glitched weapon: " .. self.Data.Name, "Inventory", "Yes", function()
                    VNP:Broadcast("VNP.ScrapItem", {slot = self.Slot})

                end, "No", function()
                    if not IsValid(panel) then return end
                    panel:Close()
            end)
        end
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

vgui.Register( "VNPInvSlot", PANEL, "DButton")