local PANEL = {}


if IsValid("VNPItemSocketMenu") then return end

local spacer = VNP:resFormatH(10)

function PANEL:Init()
    local w,h = ScrW() * .145, ScrH() * .235

    local H = self:GetTitleBarSize()
    self._Slot = -1 
    self:SetSize(w,h+H)
    self:SetTitle("Item Upgrades")

    self:Center()
    self:CenterVertical(0.4)

    self.Sockets = vgui.Create("VNPGrid", self)
    self.Sockets:SetPos(w,(h-h*0.95)/2+H)
    self.Sockets:SetColWide(w*0.2)
    self.Sockets:SetRowHeight(w*0.2)
    self.Sockets:SetHorizontalSpacing(VNP:resFormatW(5))
    self.Sockets:SetVerticalSpacing(VNP:resFormatH(5))
    self.Sockets.Socket = false
    self.Sockets.Slot = false
    self.Sockets.Paint = function()
    end
    self.Sockets:SetSize(w*0.2,h*0.95)
    //local bar = self.Sockets:GetVBar()
    //bar:SetWide(1)
    //bar.Paint = function(s, w, h)end
    //bar.btnUp.Paint = function(s, w, h)end
    //bar.btnDown.Paint = function(s, w, h)end
    //bar.btnGrip.Paint = function(s, w, h)end

    self.Item = vgui.Create("VNPInvSlot", self)
    self.Item:SetSize(w*0.95,h*0.95)
    self.Item:SetPos((w-w*0.95)/2,(h-h*0.95)/2+H)
    self.Item:SetText("Drag Items \nto upgrade")
    self.Item.GetItemData = function(s)
        return self:GetItemData()
    end
    self.Item:Receiver("Swap Inventory Item", function(s,p,b)
        if !b then return end

        local sender = p[1].Slot

        if !p[1].Data and !s.Data then return end

        if p[1].Data.Type ~= "WEAPON" && p[1].Data.Type ~= "SUIT" && p[1].Data.Type ~= "SCROLL" then return end
        if self._Data then return end

        self:SetSlot(sender)
        self.isUpgrade = VNP.Inventory:IsUpgrade(p[1].Data.Type)

        if p[1].Data.Type == "WEAPON" or self.DoSockets then
            self:SetSize(w*2.75,h+H)
            self:Center()
            self:CenterVertical(0.4)

            for k,v in pairs(self.Sockets.Items) do
                v:Remove()
            end
            
            local wide = ((w*0.2+VNP:resFormatW(5))*table.Count(p[1].Data.Sockets))
            local cols = math.ceil(wide/h*0.95)
            
            self.socketsWide = (w*0.2)*cols

            self.Sockets:SetWide(wide)
            self.Sockets:SetCols(cols)

            for socket,gem in ipairs(p[1].Data.Sockets) do
                local invslot = vgui.Create("VNPInvSlot")

                self.Sockets:AddItem(invslot)

                self.Sockets.Items[socket]:SetSize(w*0.2, w*0.2)
                //self.Sockets.Items[socket]:Dock(TOP)
                //self.Sockets.Items[socket]:DockMargin(0,1,0,1)
                
                if gem then
                    self.Sockets.Items[socket].GetItemData = function()
                        return self._Data.Sockets[socket]
                    end

                    self.Sockets.Items[socket].DoRightClick = function(s)
                        if !s.Data or !s.Data.Name then return end
                        if !self._Slot then return end
                        
                        
                        s.options = vgui.Create("EliteUI.Menu")

                        local cost = VNP.Inventory.GemSlotUpgrades[socket] or socket*VNP.Inventory.GemSlotIncrement
    
                        cost = cost*(VNP.Inventory.GemSlotUnsocket/100)

                        s.options:AddOption("Remove", function()
                            VNP.Inventory:CreateConfirm("Confirm Unsocket", cost, "Cancel", function()
                                VNP:Broadcast("VNP.UnsocketGem", {slot = self._Slot, socket = socket})
                            end, function()
                        self:Close() // shouldn't remove, no point to do so

                            end)
                        end)
                        s.options:Open()
                    end
                elseif !self.Sockets.Socket then
                    self.Sockets.Socket = socket

                    self.Sockets.Items[socket].GetItemData = function(s)
                        return LocalPlayer()._vInventory["UPGRADES"][self.Sockets.Slot]
                    end

                    self.Sockets.Items[socket]:Receiver("Swap Inventory Item", function(s,p,b)
                        if !b then return end
    
                        local sender = p[1].Slot
                
                        if !p[1].Data and !s.Data then return end
                
                        if p[1].Data.Type ~= "GEM" then return end
    
                        self.Sockets.Slot = sender
                    end)
                    self.Sockets.Items[socket].DoClick = function(s)
                        self.Sockets.Slot = nil
                    end

                    self.Sockets.Items[socket].PostPaint = function(s,w,h)
                        local color = Color(255,250,0)
                        color.a = math.Round(math.abs((math.sin(RealTime()*2)*10)), 2)
                        draw.RoundedBox(4, 0, 0, w, h, color)
                    end
                end

            end

            if IsValid(self.SocketGem) then self.SocketGem:Remove() end
            if !self.Sockets.Socket then return end
            self.SocketGem = vgui.Create("EliteUI.TextButton", self)
            self.SocketGem:SetSize((w*2.75)*.4, h*.15)
            self.SocketGem:SetPos((w*2.75)*.5, (h+H)*.825)

            local cost = VNP.Inventory.GemSlotUpgrades[self.Sockets.Socket] or self.Sockets.Socket*VNP.Inventory.GemSlotIncrement or 0
            local text = "Slot - $"..VNP:FormatNumber(cost)

            self.SocketGem:SetText(text)

            self.SocketGem.DoClick = function()
                VNP.Inventory:CreateConfirm("Confirm Socket", cost, "Cancel", function()
                    VNP:Broadcast("VNP.SocketGem", {slot1 = self._Slot, slot2 = self.Sockets.Slot, socket = self.Sockets.Socket})
                end, function()
                    self.SocketGem:Close() // shouldn't remove, no point to do so
                end)
            end
        elseif p[1].Data.Type == "SCROLL" then

            self:SetSize(w,(h+H)+h*.15)
            self:Center()
            self:CenterVertical(0.4)

            if IsValid(self.UpgradeScroll) then self.UpgradeScroll:Remove() end
            self.UpgradeScroll = vgui.Create("EliteUI.TextButton", self)
            self.UpgradeScroll:SetTall(h*.15)
            self.UpgradeScroll:Dock(BOTTOM)

            local cost = 0
            local c = VNP.Inventory:GetItemData(p[1].Data.Name, "UpgradeCost") or 0
            local increment = VNP.Inventory:GetItemData(p[1].Data.Name, "UpgradeIncrement") or 1
            local order = VNP.Inventory:GetRarityValue(p[1].Data.Rarity.Name, "Order") or 1
            local shit = VNP.Inventory:GetRaritiesByOrder()

            cost = c * (increment*order)

            if p[1].Data.Amount then
                cost = cost * p[1].Data.Amount
            end

            local text = "Upgrade - $"..VNP:FormatNumber(cost)

            self.UpgradeScroll:SetText(text)

            self.UpgradeScroll.DoClick = function()
                VNP.Inventory:CreateConfirm("Upgrade Scroll", "$"..VNP:FormatNumber(cost), "Cancel", function()
                    VNP:Broadcast("VNP.UpgradeScroll", {slot = self._Slot})
                end)
            end
            self.UpgradeScroll.Think = function(s)
                s.NextThink = s.NextThink or CurTime() + 0.15
                if s.NextThink < CurTime() then return end -- Delay
                s.NextThink = CurTime() + 0.15
                
                local order = VNP.Inventory:GetRarityValue(self._Data.Rarity.Name, "Order") or 1

                if cost ~= c * (increment*order) then
                    local amt = self._Data.Amount or 1
                    cost = c * (increment*order) * amt
                end

                local text = "Upgrade - $"..VNP:FormatNumber(cost)

                if order >= #shit then text = "MAXED" end

                if text == s:GetText() then return end
                
                s:SetText(text)
            end
        elseif p[1].Data.Type == "SUIT" then
            local scrw, scrh = ScrW(), ScrH()

            self:SetSize(w,(h+H)+h*.15)
            self:Center()
            self:CenterVertical(0.4)

            if IsValid(self.RepairSuit) then self.RepairSuit:Remove() end
            self.RepairSuit = vgui.Create("EliteUI.TextButton", self)
            self.RepairSuit:SetTall(h*.15)
            self.RepairSuit:Dock(BOTTOM)

            local cost = VNP.Inventory:GetItemData(p[1].Data.Name, "RepairCost") or 0

            local text = "Repair $" .. VNP:FormatNumber(cost)

            --VNP:FormatNumber(cost)

            if cost == 0 then
                text = "Repair"
            end

            self.RepairSuit:SetText(text)

            self.RepairSuit.DoClick = function()
                VNP.Inventory:CreateConfirm(text, "Confirm", "Cancel", function()
                    VNP:Broadcast("VNP.RepairSuit", {slot = self._Slot})
                end)
            end
        end
        
    end)
    self.Item.DoClick = function(s)

        for k,v in pairs(self.Sockets.Items) do
            v:Remove()
        end

        if IsValid(self.SocketGem) then self.SocketGem:Remove() end
        if IsValid(self.UpgradeScroll) then self.UpgradeScroll:Remove() end
        
        self:SetSize(w,h+H) 
        self:Center()
        self:CenterVertical(0.4)
        self._Data = nil
        self._Slot = nil
        
    end
end

function PANEL:SetSlot(slot)
    self._Slot = slot
end

function PANEL:PostPaint(w,h)
    if !self._Data then return end
    if self._Data.Type ~= "WEAPON" && self._Data.Type ~= "SUIT" then return end
    if self._Data.Type == "SUIT" && !self.DoSockets then return end

    local W = VNP:resFormatW(275)

    w = w - W*.95 - self.socketsWide


    local name = self._Data.Label or self._Data.Name or VNP.Inventory:GetLanguageLabel(self._Data.Class)
    local amount = self._Data.Amount or 1
    local uid = self._Data.UID or math.random(9999)
    local sig = self._Data.Signature
    local rarity = self._Data.Rarity.Name
    local rColor = IsColor(self.rData.Color) && self.rData.Color or self.rData.Color == "rainbow" && HSVToColor( CurTime()%11.25*32, .65, 1 ) or color_white
    local x,y = W*.95+self.socketsWide, spacer+self:GetTitleBarSize()
    local tW,tH = 0,0
    local col = self._Data.Type == "UPGRADEGEM" && Color(0,200,0) or Color(255, 46, 46)

    if amount > 1 then name = amount.."x "..name end

    tW,tH = VNP:DrawText(name, 22, x+w/2, y, color_white, 1)
    y=y+tH
    

    
    tW,tH = VNP:DrawText(rarity, 22, x+w/2, y*1.1, rColor, 1)
    y=y+tH+spacer*0.5

    if self.iData.Description then
        local str = self.iData.Description

        tW,tH = VNP:DrawText(str, 18, x+w/2, y, color_white, 1)
        y=y+tH
    end

    
if self._Data.Type == "SUIT" then self._Data.UID = false end

if self._Data.Type == "GEM" then self._Data.UID = false end 

if self._Data.Type == "UPGRADEGEM" then self._Data.UID = false end 


if self._Data.Type == "SCROLL" then self._Data.UID = false end 

if self._Data.Type == "WEAPON" && self.rData.Color == "rainbow" then 
    col = Color(47, 255, 47) -- if glitched then green color instead of red :3 
end


    --if self._Data.Type ~= "GEM" then

    --if self._Data.Type ~= "GEM" then

    for stat,val in SortedPairs(self.Stats, false) do
        local label = VNP.Inventory:GetLanguageLabel(stat) or stat
        local suffix = VNP.Inventory:GetLanguageSuffix(stat) or "%"
        local prefix = VNP.Inventory:GetLanguagePrefix(stat) or "+"

        tW,tH = VNP:DrawText(label, 22, x+w*.2, y+spacer*1.5, color_white, 0)


        if self._Data.Type == "SUIT" && self.iData.BaseModifiers[stat] then
            local v = ( self.iData.BaseModifiers[stat].val)
            local spacing = 1.5 
            local size = 28
            if v then

                VNP:DrawText(val .. suffix, 26, x+w*.9, y+spacer*spacing, Color(255, 46, 46), 2)
            else
                VNP:DrawText(val .. suffix, 26, x+w*.9, y+spacer*spacing, Color(255, 46, 46), 2)

            end
        end

        if self._Data.Type == "WEAPON" && self.iData.Modifiers[stat] then
            local v = self.iData.Modifiers[stat] > 0.99 and self.iData.Modifiers[stat] or 1
            local p = self.iData.Modifiers[stat] > 0.99 and self.iData.Modifiers[stat] or 1
            local spacing = 1.5 
            local size = 28
            v = prefix..math.floor((v * val)/100) -- credits to argon networks fully, i don't take credit for it.
            VNP:DrawText(p, size, x+w*.6, y+spacer*spacing, color_white, 2)

            VNP:DrawText(v, size, x+w*.9, y+spacer*spacing, col, 2)
        end
        y=y+tH*1.1
    end
end

function PANEL:SetItemData(data)
    self._Data = data

    if !self._Data then return end
    self.Stats = {}

    self.iData = VNP.Inventory:GetItemData(data.Name)
    self.rData = VNP.Inventory:GetRarity(data.Rarity.Name)

    if data.Rarity.Modifiers then
        for stat,val in pairs(data.Rarity.Modifiers) do
            self.Stats[stat] = val
        end
    end
    
    if data.Sockets then
        for socket,gem in pairs(data.Sockets) do
            if !gem then continue end

            if !gem.Modifiers then continue end

            local mods = gem.Modifiers

            if mods[data.Rarity.Name] then
                mods = mods[data.Rarity.Name]
            end

            for stat,val in pairs(mods) do
                if !self.Stats[stat] then continue end

                local rVal = mods[stat]

                if rVal then
                    local mod = val*(1+rVal/100)
                    self.Stats[stat] = self.Stats[stat]+mod
                end
            end
        end
    end

    if data.Modifiers then
        for stat,val in pairs(data.Modifiers) do
            self.Stats[stat] = val
        end
    end
end

function PANEL:GetItemData()
    if self.isUpgrade then
        return LocalPlayer()._vInventory["UPGRADES"][self._Slot] 
    end
    return LocalPlayer()._vInventory[self._Slot]
end

function PANEL:Think()
    self.NextThink = self.NextThink or CurTime() + 0.15
	if self.NextThink < CurTime() then return end -- Delay
    self.NextThink = CurTime() + 0.15


    if IsValid(self.SocketGem) then
        if self.Sockets.Slot then
            self.SocketGem:SetVisible(true)
        else
            self.SocketGem:SetVisible(false)
        end
    end

    local data = self:GetItemData()

    if self._Data == data then return end

    self:SetItemData(data)
end

vgui.Register( "VNPItemSocketMenu", PANEL, "VNPFrame" )