local PANEL = {}

function PANEL:Init()
    self:SetTitle("Inventory Admin Menu - Don't be a baka..")

    local pad = VNP:resFormatW(400)
    
    self:SetResSize(600,800)
    self:SetDraggable(false)
    self:Center()

    self.playerList = vgui.Create("EliteUI.ScrollPanel", self)
    self.playerList:Dock(FILL)
    self.playerList.Paint = function()
    end


    local height = VNP:resFormatH(100)

    for _,ply in ipairs(player.GetHumans()) do
        local panel = self.playerList:Add("DPanel")
        panel:SetTall(height)
        panel:Dock(TOP)
        panel:DockMargin(5,5,5,5)

        local avatar = vgui.Create("AvatarImage", panel)
        avatar:SetResSize(90,90)
        avatar:SetResPos(5,5)
        avatar:SetPlayer(ply, 100)

        local tW,tH = VNP:GetTextSize(ply:Nick(), 30)

        panel.Paint = function(s,w,h)
            draw.RoundedBox( 5, 0, 0, w, h, Color( 50, 50, 54, 50 ) )
            
            VNP:DrawText(ply:Nick(), 30,height*1.1,height/2-tH, color_white, 0) -- name
            VNP:DrawText(ply:SteamID(), 20,height*1.1,height/2, Color(150,150,150), 0) -- steamid
            VNP:DrawText(ply:GetUserGroup(), 20, height*1.1, height -30, Color(150,150,150), 0) -- rank
        end

        panel:DockPadding(pad,10,10,0)     

        local openUpgrades = vgui.Create("EliteUI.TextButton", panel)
        openUpgrades:SetTall(height/4)
        openUpgrades:Dock(TOP)
        openUpgrades:DockMargin(0,0,0,0)
        openUpgrades:SetText("Open Upgrades")

        local openInventory = vgui.Create("EliteUI.TextButton", panel)
        openInventory:SetTall(height/4)
        openInventory:Dock(TOP)
        openInventory:DockMargin(0,5,0,0)
        openInventory:SetText("Open Inventory")

        local clearScrap = vgui.Create("EliteUI.TextButton", panel)
        clearScrap:SetTall(height/4)
        clearScrap:Dock(TOP)
        clearScrap:DockMargin(0,5,0,5)
        clearScrap:SetText("Clear Scrap")   

        openInventory.DoClick = function(s)
            
            if IsValid(self.InventoryView.itemList) then
                self.InventoryView.itemList:Remove()
            end

            self.Player = ply

            openUpgrades:SetText("Open Upgrades")
            
            self._Data = nil
            self.viewUpgrades = false
            VNP:Broadcast("VNP.GetInventory", {ply = ply})
            self.InventoryView:SetTitle(ply:Nick().." | "..ply:SteamID())

            if !self.InventoryView.Opened then
                self.InventoryView.Open(self.InventoryView)
            end
        end
        openUpgrades.DoClick = function(s)

            if IsValid(self.InventoryView.itemList) then
                self.InventoryView.itemList:Remove()
            end

            self.Player = ply

            openInventory:SetText("Open Inventory")

            self._Data = nil
            self.viewUpgrades = true
            VNP:Broadcast("VNP.GetInventory", {ply = ply})

            self.InventoryView:SetTitle(ply:Nick().." | "..ply:SteamID())
            
            if !self.InventoryView.Opened then
                self.InventoryView.Open(self.InventoryView)
            end

        end

        clearScrap.DoClick = function(s)
            VNP:Broadcast("VNP.AdminClearScrap", {ply = ply})            
        end

    end

    self.InventoryView = vgui.Create("EliteUI.Frame")
    self.InventoryView:SetResSize(600,800)
    self.InventoryView:Center()
    self.InventoryView:SetVisible(false)

    local iconSize = VNP:resFormatW(50)

    self.InventoryView.PostPaint = function(s,w,h)
        if !self._Data then
            local color = Color(255,255,255)

            color.a = math.Round(math.abs((math.sin(RealTime()*1.5)*255)), 2)

            VNP:DrawText("Loading", 40, w/2,h/2,color, 1)
        elseif table.Count(self._Data) < 1 then
            VNP:DrawText("No Items", 40, w/2,h/2,color_white, 1)
        end
    end

    self.InventoryView.Think = function(s)
        if !IsValid(self) then s:Remove() end
        if !IsValid(s.itemList) then s.RefreshList(s) end
    end

    self.InventoryView.Open = function(s, onOpened)
        self.InventoryView.Opened = true

        s:SetVisible(true)

        local x,y = s:GetPos()
        local w = s:GetWide()
        s:SetVisible(true)
        s:MoveTo(ScrW()/2+w*.1,y,1,0,-1,onOpened)

        x,y = self:GetPos()
        w = self:GetWide()
        self:MoveTo((ScrW()/2)-w*1.1,y,1,0)
    end

    self.InventoryView.RefreshList = function(s)

        if IsValid(s.itemList) then s.itemList:Remove() end
        if !self._Data then return end

        s.itemList = vgui.Create("EliteUI.ScrollPanel", self.InventoryView)
        s.itemList:Dock(FILL)
      
    
        for slot,item in pairs(self._Data) do
            if !isnumber(slot) then continue end

            local panel = s.itemList:Add("DPanel")
            panel:SetTall(height)
            panel:Dock(TOP)
            panel:DockMargin(5,5,5,5)

            local name = item.Label or item.Name

            local tW,tH = VNP:GetTextSize(name, 30)
            local color = VNP.Inventory:GetRarityValue(item.Rarity.Name, "Color")

            panel.Paint = function(s,w,h)
                local rColor = IsColor(color) && color or color == "rainbow" && HSVToColor( CurTime()%11.25*32, .65, 1 ) or color_white

                draw.RoundedBox( 5, 0, 0, w, h, Color( 50, 50, 54, 50 ) )
                
                VNP:DrawText(name, 18,height*1.1,height - 55 -tH, color_white, 0)
                tW,tH = VNP:DrawText(item.Rarity.Name, 18,height*1.1,height/2, rColor, 0)
                VNP:DrawText(item.UID or "nil",20,height*1.1,height/2+tH, Color(150,150,150), 0)
            end

            local s = vgui.Create("VNPInvSlot", panel)
            s:SetResSize(90,90)
            s:SetResPos(5,5)
            s.GetItemData = function(s)
                return item
            end

            panel:DockPadding(pad,10,10,0)

            local takeItem = vgui.Create("EliteUI.TextButton", panel)
            takeItem:SetTall(height/3)
            takeItem:Dock(TOP)
            takeItem:DockMargin(0,0,0,5)
            takeItem:SetText("Yoink Item")
            takeItem.DoClick = function(s)
                VNP:Broadcast("VNP.AdminStealItem", {ply = self.Player, slot = slot, isUpgrade = self.viewUpgrades})
            end

            local deleteItem = vgui.Create("EliteUI.TextButton", panel)
            deleteItem:SetTall(height/3)
            deleteItem:Dock(TOP)
            deleteItem:DockMargin(0,5,0,0)
            deleteItem:SetText("Delete Item")
            deleteItem.DoClick = function(s)
                VNP:Broadcast("VNP.AdminDeleteItem", {ply = self.Player, slot = slot, isUpgrade = self.viewUpgrades})
            end
        end
    end

    self:MakePopup()
end

function PANEL:OnRemove()
    if LocalPlayer():IsAdmin() then
        VNP:Broadcast("VNP.CloseAdminMenu", {})
    end

    if IsValid(self.InventoryView) then self.InventoryView:Remove() end
end

function PANEL:SetInvData(data, delay)
    if !data then return end

    if self.viewUpgrades then
        self._Data = data["UPGRADES"]
    else
        for k,v in pairs(table.GetKeys(data)) do
            if isnumber(v) then continue end
            data[v] = nil
        end 
        
        self._Data = data
    end

    self.InventoryView.RefreshList(self.InventoryView)
end



vgui.Register( "VNPAdminMenu", PANEL, "EliteUI.Frame")