local PANEL = {}



EliteUI.RegisterFont("Inventory.Title", "Roboto Medium", 26)
EliteUI.RegisterFont("Inventory.Amount", "Roboto Medium", 18)

EliteUI.RegisterFont("Inventory.ItemDrop1", "Roboto Medium", 24)
EliteUI.RegisterFont("Inventory.ItemDrop2", "Roboto Medium", 24)

EliteUI.RegisterFont("Inventory.ToolTip1", "Roboto Medium", 24)
EliteUI.RegisterFont("Inventory.ToolTip2", "Roboto Medium", 24)
EliteUI.RegisterFont("Inventory.ToolTip3", "Roboto Medium", 18, 400)
EliteUI.RegisterFont("Inventory.ToolTipPower", "Roboto Medium", 30)

EliteUI.RegisterFont("Inventory.Pages", "Roboto Medium", 20)
EliteUI.RegisterFont("Inventory.AddPage", "Roboto Medium", 32)

EliteUI.RegisterFont("Inventory.26", "Roboto Medium", 26)
EliteUI.RegisterFont("Inventory.24", "Roboto Medium", 24)
EliteUI.RegisterFont("Inventory.22", "Roboto Medium", 22)

/*
	EL_INV.VGUI.TooltipPanel:SetPos( -EL_INV.VGUI.TooltipPanel:GetWide(), -EL_INV.VGUI.TooltipPanel:GetTall() )

 */

 /*
    local innerCol = Color(18, 18, 20)

*/

function PANEL:Init()


    --VNP:resFormatW(VNP.Inventory.SlotSize)
    local w,h = self:GetSize()

	self:AlphaTo( 255, 0.1, 0, function() end ) // little bit of animation :3 (adds a bit of a bug at sv_util line 155, i just need it to where it doesn't do anything when you hit 4 pages.)
    self:MakePopup()
    self:SetDraggable(false)
    
    --self:SetTitle("Inventory ")
    
    self:SetAlpha( 0 )
    self:SetVisible(1)

    local scrw, scrh = ScrW(), ScrH()
    local d = VNP:resFormatW(VNP.Inventory.SlotSize)
    local p = VNP:resFormatH(VNP.Inventory.SlotSize)
    self._grid = vgui.Create("VNPGrid", self)
    self._grid:Dock(FILL)
    self._grid:SetColWide(d)
    self._grid:SetRowHeight(p)
    self._grid:SetCols(VNP.Inventory.SlotsX)
    
    local screenWidth = ScrW()
    local screenHeight = ScrH()
    if screenWidth >= 1920 then
        self._grid:SetHorizontalSpacing(VNP:resFormatW(10))
        self._grid:SetVerticalSpacing(VNP:resFormatH(10)) -- oh my god please
    elseif screenWidth >= 1280 then
        self._grid:SetHorizontalSpacing(VNP:resFormatW(15))
        self._grid:SetVerticalSpacing(VNP:resFormatH(15))
    else
        self._grid:SetColWide(d * 1.2)
        self._grid:SetHorizontalSpacing(VNP:resFormatW(5))
        self._grid:SetVerticalSpacing(VNP:resFormatH(10))
    end
   -- self._grid:SizeToContents()

    self._grid.Paint = function()end

    local pages = LocalPlayer():GetInventoryPages()

    local x,y = VNP:GetTextSize(self:GetTitle(), 22)

    local normalrec = function(s,p,b)
        if !b then return end

        local sender, receiver = p[1].Slot, LocalPlayer():GetAvailableSlot(self.page)

        if !p[1].Data and !s.Data then return end

        VNP.Inventory:MoveItem(sender, receiver)
    end
    
    if pages then
        
        self._pageButtons = {}

        for i=1,pages do
            self._pageButtons[i] = vgui.Create("DButton", self)
            self._pageButtons[i]:SetResSize(20,20)
            self._pageButtons[i]:SetText(i)
            self._pageButtons[i]:SetFont("VNP.Font.20")
            self._pageButtons[i]:SetColor(color_white)
            self._pageButtons[i].Paint = function(s,w,h)
                local color = self.selectedPage == s && Color(0,0,0,150) or Color(0,0,0,100)

                draw.RoundedBox(10,0,0,w,h,color)
            end

            self._pageButtons[i]:SetResPos(x+(VNP:resFormatW(30)*i), self:GetTitleBarSize()/4)

            self._pageButtons[i].DoClick = function(s,w,h)
                self.selectedPage = s

                local slotsPerPage = VNP.Inventory.SlotsY*VNP.Inventory.SlotsX

                for _,pnl in ipairs(self._grid.Items) do
                    local slot = (slotsPerPage*i)-(slotsPerPage-_)

                    pnl:SetSlot(slot)

                    pnl.GetItemData = function(s)
                        return LocalPlayer()._vInventory[slot]        
                    end
                end
            end
            self._pageButtons[i]:Receiver("Swap Inventory Item", function(s,p,b)
                if !b then return end
        
                local sender, receiver = p[1].Slot, LocalPlayer():GetAvailableSlot(i)
        
                if !p[1].Data and !s.Data then return end
        
                VNP.Inventory:MoveItem(sender, receiver)
            end)
        end
        self.selectedPage = self._pageButtons[1]

        self.buyPage = vgui.Create("DButton", self)
            
        self.buyPage:SetResSize(30,22)
        self.buyPage:SetResPos(x+(30*(#VNP.Inventory.Pages+1)), y/2-(10/4))
        self.buyPage:SetText("+")
        self.buyPage:SetFont("VNP.Font.32")
        self.buyPage:SetColor(color_white)
        self.buyPage.Paint = function(s,w,h)
            local color = s:IsHovered() && Color(150,150,150) or color_white

            if color ~= s:GetFGColor() then
                s:SetFGColor(color)
            end
        end

        self.buyPage.DoClick = function(s)
            VNP:Broadcast("VNP.BuyPage", {})
            //VNP.Inventory:OpenInventory()
        end
    end

    self.upgrades = vgui.Create("EliteUI.TextButton", self)
    self.upgrades:SetText("Upgrades")
    self.upgrades:SetFont("VNP.Font.18")
    self.upgrades:SetResSize(90,25)
    self.upgrades:SetResPos(0, self:GetTitleBarSize()  )
    self.upgrades.toggled = false

    self.upgrades.DoClick = function(s)
        if !self.upgrades.toggled then
            for i,pnl in ipairs(self._pageButtons) do
                pnl:SetVisible(false)
            end
            self.buyPage:SetVisible(false)
            self:SetTitle("Upgrades")

            for d,pnl in ipairs(self._grid.Items) do
                pnl:SetSlot(d)

                pnl.IsUpgrade = true

                pnl.GetItemData = function(s)
                    return LocalPlayer()._vInventory["UPGRADES"][d]
                end
            end

            s:SetText("Back")
        else
            for i,pnl in ipairs(self._pageButtons) do
                pnl:SetVisible(true)
            end
            self.buyPage:SetVisible(true)
            self:SetTitle("Inventory")
            
            for _,pnl in ipairs(self._grid.Items) do
                pnl:SetSlot(_)
                
                pnl.IsUpgrade = false

                pnl.GetItemData = function(s)
                    return LocalPlayer()._vInventory[_]
                end
            end
            s:SetText("Upgrades")
        end

        self.upgrades.toggled = !self.upgrades.toggled
    end

    local amt = VNP.Inventory.Pages[pages+1] or nil

    if amt then
        self.buyPage:SetTooltip("Upgrade Inventory \n $"..VNP:FormatNumber(amt).." for +60 slots")
    end





    self:MakePopup()
end

function PANEL:AddPanel(pnl)
    if !IsValid(pnl) then return end

    self._grid:AddItem(pnl)
end

--function PANEL:PostPaint(w,h) end

function PANEL:PerformLayout(w,h)
	local headerH = EliteUI.Scale(30)

	if IsValid(self.CloseButton) then
        self.CloseButton:Hide()
    end

	if IsValid(self.SideBar) then
		self.SideBar:SetPos(0, headerH)
		self.SideBar:SetSize(EliteUI.Scale(200), h - headerH)
	end

	local padding = EliteUI.Scale(6)
	self:DockPadding(self.SideBar and EliteUI.Scale(200) + padding or padding, headerH + padding, padding, padding)

	self:LayoutContent(w, h)

    local x,y = VNP:GetTextSize(self:GetTitle(), 22)

    local titlebarSize = self:GetTitleBarSize()

    if IsValid(self.upgrades) then
        self.upgrades:SetPos(w-VNP:resFormatW(90)-2-2, (titlebarSize/2)-(VNP:resFormatH(25)/2))
    end


    if !IsValid(self.buyPage) then return end

    self.buyPage:SetPos(x+(VNP:resFormatW(30)*(#VNP.Inventory.Pages+1)), titlebarSize/2-VNP:resFormatH(20)/2)

    for i,pnl in ipairs(self._pageButtons) do
        self._pageButtons[i]:SetPos(w*.1+(VNP:resFormatW(30)*i), titlebarSize/2-VNP:resFormatH(20)/2)
    end
end



function PANEL:GetTitleBarSize()
    return EliteUI.Scale(30)
end

vgui.Register( "VNPInventory", PANEL, "EliteUI.FrameInven")