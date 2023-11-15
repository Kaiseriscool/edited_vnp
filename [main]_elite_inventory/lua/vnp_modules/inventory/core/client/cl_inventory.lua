VNP.Inventory = VNP.Inventory or {}

function VNP.Inventory:OpenInventory()

    if !IsValid(g_ContextMenu) then return end
    if IsValid(self.Menu) then self.Menu:Remove() end
    if IsValid(self.EnhanceMenu) then self.EnhanceMenu:Remove() end
    if IsValid(self.ItemUpgrades) then self.ItemUpgrades:Remove()end



    LocalPlayer()._vInventory = LocalPlayer()._vInventory or {}

    local width, height = self.SlotsX*self.SlotSize, self.SlotsY*self.SlotSize


    local width2, height2 = self.SlotsX*self.SlotSize * 1.2, self.SlotsY*self.SlotSize * 1.1

    local totalSlots = self.SlotsX*self.SlotsY

    height = height+((self.SlotsY-1)*10)
    local screenWidth = ScrW()
    local screenHeight = ScrH()
    self.Menu = vgui.Create("VNPInventory") -- do not use g_ContextMenu here please..
    self.Menu:SetResSize(width,height)
    --self.Menu:SetResPos((1920/2)-(width/2), 1080-(height*1.1))

    if screenWidth >= 1920 then
        self.Menu:SetResSize(width,height)

    elseif screenWidth >= 1280 then -- i hate elitelupus
        self.Menu:SetResSize(width,height)

    else
        self.Menu:SetResSize(width2,height2)
        self.Menu:SetResPos((1920/2)-(width/2), 1080-(height*1.1))

    end

    if screenWidth >= 1920 then
        self.Menu:SetResPos((1920/2)-(width/2), 1080-(height*1.1))


    elseif screenWidth >= 1280 then -- i hate elitelupus
        self.Menu:SetResPos((1920/2)-(width/2), 1080-(height*1.1))


    else
        self.Menu:SetResPos((885)-(width/2), 1080-(height*1.1))

    end

    for i=1,totalSlots do
        local slot = vgui.Create("VNPInvSlot",self.Menu)
        //slot:SetText(i)
       slot:SetResSize(self.SlotSize,self.SlotSize)
        slot:SetVisible(false)

        slot:Receiver("Swap Inventory Item", function(s,p,b)
            if !b then return end

			local sender, receiver = p[1].Slot, s.Slot

			if !p[1].Data and !s.Data then return end
            
            local IsUpgrade = p[1].IsUpgrade or s.IsUpgrade or false

            VNP.Inventory:MoveItem(sender, receiver, IsUpgrade)
        end)
        slot:Droppable("Swap Inventory Item")

        slot:SetSlot(i)

        slot.GetItemData = function(s)
            return LocalPlayer()._vInventory[i]        
        end

        self.Menu:AddPanel(slot)
    end
end

function VNP.Inventory:CreateItemNotification(item)
    self.ItemNotifications = self.ItemNotifications or {}
    table.insert(self.ItemNotifications, item)

    if #self.ItemNotifications > 0 and not IsValid(self.ItemNotification) then
        self:CreateNotificationPanel()
    end
end

function VNP.Inventory:CreateNotificationPanel()

    for i, item in ipairs(self.ItemNotifications) do
        local scrh, scrw = ScrH(), ScrW()
        local padding = scrw * 0.022

        local notification = vgui.Create("DPanel")

        notification:SetSize(400,100)
    
        notification:SetPos(ScrW() - 500, ScrH() - 900 + i * 40) -- WHY ISN'T THIS WORKING :c 

        item.NotificationPanel = notification

          
/*

   if rarity == "Uncommon" then -- should work??
            return
        end */     

        notification.Paint = function(s, w, h)
            local idata = VNP.Inventory:GetItemData(item.Name)
            draw.RoundedBox(0, 0, 0, w-2, h-2, Color(25, 25, 25, 255))
            surface.SetDrawColor(Color(50, 50, 50, 255))
            surface.DrawOutlinedRect(0, 0, w, h, 2)
            
            local name = item.Label or item.Name
            local signature = item.Signature
            local rarity = item.Rarity and item.Rarity.Name or "unknown" or self.ItemNotifications[1].Rarity.Name


           -- print("item", item.Name, "rarity", rarity, "signature", signature)
    
            local rcolor = VNP.Inventory:GetRarityValue(rarity, "Color")
            rcolor = IsColor(rcolor) && rcolor or rcolor == "rainbow" && HSVToColor( CurTime()%11.25*32, .65, 1 ) or color_white
    
            if idata && idata.Class then
                name = VNP.Inventory:GetLanguageLabel(idata.Class) or name
            end
    
            local x,y = VNP:resFormatW(105), VNP:resFormatH(5)
    
            local tW,tH = VNP:DrawText(name,22,x,y, color_white, 0)
    
            y = y + tH
    
            VNP:DrawText(rarity,22,x,y,rcolor,0)
            if signature then
                    tW,tH = VNP:GetTextSize(signature, 18)
                    VNP:DrawText(signature,18,x,h-tH*1.5,color_white,0)
                end
            end

        notification.AnimShit = function(s)
            local x, y = s:GetPos()
            local w, h = s:GetWide(), s:GetTall()
            local endX = ScrW() + w
            local endX2 = ScrW() - w
            local endY = y
                
            s:MoveTo(endX2, endY, 0, 0, 0, function() 
                s:MoveTo(endX, endY, 0.1, 1, 5, function()
                  --  s:AlphaTo(0, 1, 0, function()
                        s:Remove()
                    
                        if #self.ItemNotifications > 0 then
                            for i, notif in ipairs(self.ItemNotifications) do
                                local notifPanel = notif.NotificationPanel
                                if IsValid(notifPanel) then
                                    local newY = notifPanel.y - (h + padding)
                                    local oldY = notifPanel.y
                                    notifPanel.NotificationIndex = i
                                    notif.NotificationPanel = notifPanel
                                end
                            end
                        end
                    end)
                end)
             end
        
    
        

        local sW,sH = VNP:resFormatW(5),VNP:resFormatH(5)

        local invSlot = vgui.Create("VNPInvSlot", notification)
        invSlot:SetResSize(90,90)
        invSlot:Dock(LEFT)
        invSlot:DockMargin(sW,sH,sW,sH)
        invSlot.GetItemData = function(s)
            return item
        end
        notification.AnimShit(notification)
    end

    self.ItemNotifications = {}
end

function VNP.Inventory:OpenEnhanceMenu()

    if !IsValid(g_ContextMenu) then return end

    if IsValid(self.EnhanceMenu) then self.EnhanceMenu:Close() end
    self.EnhanceMenu = vgui.Create("VNPEnhance", g_ContextMenu)


end



function VNP.Inventory:OpenAdminMenu()

    if IsValid(self.AdminMenu) then self.AdminMenu:Close() end

    self.AdminMenu = vgui.Create("VNPAdminMenu")

end

function VNP.Inventory:CreateConfirm(title, confirmTitle, declineTitle,func,onClose)
    self.Confirm = vgui.Create("EliteUI.Frame")
    self.Confirm:SetTitle(title)
    self.Confirm:MakePopup()
    self.Confirm:SetBackgroundBlur(true)
    local w,h = VNP:resFormatW(350), VNP:resFormatH(75)

    self.Confirm:SetSize(w+w*.045,h)
    self.Confirm:Center()

    confirmTitle = confirmTitle or "Confirm"
    declineTitle = declineTitle or "Decline"

    local confirm = vgui.Create("EliteUI.TextButton", self.Confirm)
    confirm:SetText(confirmTitle)
    confirm:SetSize(w*.45, h*.5)
    confirm:SetPos(w*.045, h-(h*.55))
    confirm.DoClick = function()
        func()

        self.Confirm:Close(true)
    end

    local decline = vgui.Create("EliteUI.TextButton", self.Confirm)
    decline:SetText(declineTitle)
    decline:SetSize(w*.45, h*.5)
    decline:SetPos(w/2+w*.045, h-(h*.55))
    decline.DoClick = function(s)
        self.Confirm:Close(true) // makes the animation??       
        
    end
end

hook.Add("ContextMenuOpened", "VNP.OpenInventory", function()
    VNP.Inventory:OpenInventory()

    
end)

hook.Add("ContextMenuClosed", "VNP.CloseInventory", function()
    
    
    /*local menuValid = false
    
    if IsValid(VNP.Inventory.EnhanceMenu) then
        
        VNP.Inventory.EnhanceMenu:SetParent(nil)
        VNP.Inventory.EnhanceMenu.OnRemove = function(s)
            if IsValid(VNP.Inventory.Menu) then VNP.Inventory.Menu:Remove() end
        end
        menuValid = true 
    end */
 
    
     
    local menuValid = false
    local delay = .1
        if IsValid(VNP.Inventory.Menu)  then 
            VNP.Inventory.Menu:AlphaTo(0, delay, 0) 
            timer.Create("InventoryDelay", delay, 1, function() VNP.Inventory.Menu:Remove()  end) -- stupid animation thingy just to close it..
            
            menuValid = true // fixes error when you spam C
        end 
 
    
 if IsValid(VNP.Inventory.EnhanceMenu)   then
        timer.Remove( "InventoryDelay" )
        VNP.Inventory.Menu:AlphaTo(255, delay, 0) 

        VNP.Inventory.EnhanceMenu:SetParent(nil)

        

        VNP.Inventory.EnhanceMenu.OnRemove = function(s)
            if IsValid(VNP.Inventory.Menu) then VNP.Inventory.Menu:Close() end
            
        end
        menuValid = true
    end 


    if IsValid(VNP.Inventory.ItemUpgrades) then
        timer.Remove( "InventoryDelay" )
        VNP.Inventory.Menu:AlphaTo(255, delay, 0) 
        VNP.Inventory.ItemUpgrades:SetParent(nil)
        VNP.Inventory.ItemUpgrades.OnRemove = function(s)
            if IsValid(VNP.Inventory.Menu) then VNP.Inventory.Menu:Close() end
        end
        menuValid = true 
    end
    if IsValid(VNP.Inventory.Confirm) then
        timer.Remove( "InventoryDelay" )
        VNP.Inventory.Menu:AlphaTo(255, delay, 0) 
        VNP.Inventory.Confirm:SetParent(nil)
        VNP.Inventory.Confirm.OnRemove = function(s)
            if IsValid(VNP.Inventory.Menu) then VNP.Inventory.Menu:Close() end
        end
        menuValid = true
    end

    if IsValid(VNP.Inventory.Menu) && !menuValid then 
        VNP.Inventory.Menu:Remove() 
    elseif menuValid then
        VNP.Inventory.Menu:SetParent(nil)
    end
end)



concommand.Add("vnp_adminmenu", function(ply, cmd, args)
    if !ply:IsAdmin() then return end

    VNP.Inventory:OpenAdminMenu()
end)

concommand.Add("vnp_testweapons", function(ply, cmd, args)
    if !ply:IsAdmin() then return end

    for k,pl in pairs(player.GetAll()) do
        local wep = pl:GetActiveWeapon()

        if !IsValid(wep) then continue end

        local data = wep:GetItemData()

        if !data then continue end

        PrintTable(data)
    end
end)

concommand.Add("vnp_closeinventory", function(ply)
    if !ply:IsAdmin() then return end
    VNP.Inventory.Menu:Remove() 
end)