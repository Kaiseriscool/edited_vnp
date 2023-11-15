local PANEL = {}

function PANEL:Init() // A little bit aids but hey it works perfectly
    self:SetTitle("Enhance")
    self:SetAlpha( 0 )
	self:AlphaTo( 255, 0.1, 0, function() end ) // little bit of animation :3 
    local scrw, scrh = ScrW(), ScrH()

    local w,h = 650, 450

    self:SetSize(scrw * .35, scrh * .45)

    self:Center()
    self:SetY(VNP:resFormatH(120))

    self.canEnhance = true

    local itemSlotSize = 180
    self.itemSlot = vgui.Create("VNPInvSlot", self)
    self.itemSlot:SetResSize(itemSlotSize,itemSlotSize)
    self.itemSlot:SetResPos((w * .53)-(itemSlotSize/2),70)
    self.itemSlot:SetAllowOptions(false)

    self.itemSlot:Receiver("Swap Inventory Item", function(s,p,b)
        if !b then return end

        local sender = p[1].Slot

        if !p[1].Data and !s.Data then return end

        local t = p[1].Data.Type

        if t == "SCROLL" or t == "UPGRADEGEM" then return end

        self.ItemIsUpgrade = VNP.Inventory:IsUpgrade(t) or false

        self.iSlot = sender
        self.iData = p[1].Data

        if self.sData then
            local func = VNP.Inventory:GetItemData(self.sData.Name, "CanEnhance")

            if func then
                self.canEnhance = func(self.sData, self.iData)
            else
                self.canEnhance = true
            end
        end

        if VNP.Inventory.Menu && VNP.Inventory.Menu.upgrades && t ~= "GEM" then
            local upgrades = VNP.Inventory.Menu.upgrades
            upgrades.DoClick(upgrades)
        end
    end)

    self.itemSlot.GetItemData = function(s)
        if self.ItemIsUpgrade then
            return LocalPlayer()._vInventory["UPGRADES"][self.iSlot]
        end

        return LocalPlayer()._vInventory[self.iSlot]
    end

    local scrollSlotSize = 150
    self.scrollSlot = vgui.Create("VNPInvSlot", self)
    self.scrollSlot:SetResSize(scrollSlotSize,scrollSlotSize)
    self.scrollSlot:SetResPos((w * 0.5)-itemSlotSize-(scrollSlotSize/2),70+(itemSlotSize-scrollSlotSize)/2)
    self.scrollSlot:SetAllowOptions(false)

    self.scrollSlot:Receiver("Swap Inventory Item", function(s,p,b)
        if !b then return end

        local sender = p[1].Slot

        if !p[1].Data and !s.Data then return end

        local t = p[1].Data.Type

        if t ~= "SCROLL" then return end

        self.sSlot = sender
        self.sData = p[1].Data
        if string.find(self.sData.Name, "Upgrade Scroll") then
            self.sMods = table.Copy(VNP.Inventory:GetRarityValue(self.sData.Rarity.Name, "UpgradeChance"))
            for k,v in pairs(self.sMods) do
                if !v.val then self.sMods[k] = nil continue end
                self.sMods[k] = v.val
            end
        end

        if self.iData then
            local func = VNP.Inventory:GetItemData(self.sData.Name, "CanEnhance")

            if func then
                self.canEnhance = func(self.sData, self.iData)
            else
                self.canEnhance = true
            end
        end

        local cost = VNP.Inventory:GetRarityValue(self.sData.Rarity.Name, "EnhanceCost")

        if cost then
            self.enhanceConfirm:SetText("Enhance - $"..VNP:FormatNumber(cost))
        end
    end)

    self.scrollSlot.GetItemData = function(s)
        local data = LocalPlayer()._vInventory["UPGRADES"][self.sSlot]

        if !data then
            self.sSlot = nil 
            self.sData = nil
        end

        return data
    end
    local x,y = self:LocalToScreen(0,0)
    self.gemSlot = vgui.Create("VNPInvSlot", self)

    self.gemSlot:SetResSize(scrollSlotSize,scrollSlotSize)
    self.gemSlot:SetResPos((w * 0.55)+itemSlotSize-(scrollSlotSize/2),70+(itemSlotSize-scrollSlotSize)/2)
    self.gemSlot:SetAllowOptions(false)

    self.gemSlot:Receiver("Swap Inventory Item", function(s,p,b)
        if !b then return end

        local sender = p[1].Slot

        if !p[1].Data and !s.Data then return end

        local t = p[1].Data.Type

        if t ~= "UPGRADEGEM" then return end

        self.gSlot = sender
        self.gData = p[1].Data
        self.gData.Amount = nil
    end)

    
    self.gemSlot.GetItemData = function(s)
        local data = LocalPlayer()._vInventory["UPGRADES"][self.gSlot]

        if !data then
            self.gSlot = nil 
            self.gData = nil
        end

        return data
    end

    self.enhanceConfirm = vgui.Create("EliteUI.TextButton", self)
    self.enhanceConfirm:SetResSize(w*.55,40)
    self.enhanceConfirm:SetResPos(w/2-(w*.78)/3, h-(15))
    self.enhanceConfirm:SetText("Enhance")

    self.enhanceConfirm.DoClick = function(s)
        if !self.canEnhance then return end

        if !self.sSlot or !self.iSlot then return end

        local cost = VNP.Inventory:GetRarityValue(self.sData.Rarity.Name, "EnhanceCost")
        VNP:Broadcast("VNP.UseScroll", {scrollSlot = self.sSlot, itemSlot = self.iSlot, gemSlot = self.gSlot, isUpgrade = self.ItemIsUpgrade})

     --   VNP.Inventory:CreateConfirm("Confirm Enhance", "$"..VNP:FormatNumber(cost), "Cancel", function()
    --        VNP:Broadcast("VNP.UseScroll", {scrollSlot = self.sSlot, itemSlot = self.iSlot, gemSlot = self.gSlot, isUpgrade = self.ItemIsUpgrade})
    ----    end, function()
    --    end)
    end

    self:MakePopup()
end
// VNP:DrawText(self:GetTitle(), 22, w*.025,h/2-y/2, color_white, 0)



function PANEL:PostPaint(w,h) // I'm having a stroke WTF

    if !IsValid(self.scrollSlot) then return end

    local tW,tH = VNP:GetTextSize("Scroll", 24)

    local x,y = self.scrollSlot:GetPos()
    local pW,pH = self.scrollSlot:GetSize()
    VNP:DrawText("Scroll", 24, x+(pW/2),y-tH*1.3, color_WHite, 1)

    x,y = self.gemSlot:GetPos()
    pW,pH = self.gemSlot:GetSize()
    VNP:DrawText("Gem", 24, x+(pW/2),y-tH*1.3, color_WHite, 1)

    x,y = self.itemSlot:GetPos()
    pW,pH = self.itemSlot:GetSize()
    VNP:DrawText("Item", 24, x+(pW/2),y-tH*1.3, color_WHite, 1)

    if self.sData && self.canEnhance && self.sMods then

        local mods = table.Copy(self.sMods) -- Fucking aids

        if self.gSlot && self.gData then
            for stat,val in pairs(self.gData.Modifiers) do
                if !mods[stat] then continue end

                mods[stat] = math.Clamp(mods[stat]+val,0,100)
            end
        end

        local success = mods["upgrMinorSuccess"]
        local majorSuccess = mods["upgrMajorSuccess"]
        local minorFail = mods["upgrMinorFail"]
        local majorFail = mods["upgrMajorFail"]
        local a,b

        tW,tH = VNP:DrawText("Success: "..success.."% // Fail: "..100-success.."%", 26, w/2,(y+pH)+h*.05, color_white, 1)

        if minorFail then
            a,b = VNP:DrawText("Minor Fail: "..minorFail.."%", 26, w/2,((y+pH)+h*.05)+tH, color_white, 1)
            tH = tH + b
        end
        
        if majorFail then
            a,b = VNP:DrawText("Major Fail: "..majorFail.."%", 26, w/2,((y+pH)+h*.05)+tH, color_white, 1)
            tH = tH + b
        end

        if majorSuccess then
            tW,tH = VNP:DrawText("Major Success: "..majorSuccess.."%", 26, w/2,((y+pH)+h*.05)+tH, color_white, 1)
        end
    elseif self.iData && self.sData && !self.canEnhance then
        VNP:DrawText("Invalid Scroll for Item", 26, w/2,(y+pH)+h*.15, Color(200,55,55), 1)
    elseif !self.iData then
        VNP:DrawText("nil", 26, w/2,(y+pH)+h*.15, Color(200,55,55), 1)
    elseif !self.sData then
        VNP:DrawText("INSERT SCROLL", 26, w/2,(y+pH)+h*.15, Color(200,55,55), 1)
    end
end

vgui.Register( "VNPEnhance", PANEL, "VNPFrame")