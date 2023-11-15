local PANEL = {}

local xMat = VNP:GetMaterial("https://i.imgur.com/XP4L6rC.png")
local padding = VNP:resFormatW(5)

function PANEL:Init()
	self:SetAlpha(0)

	self:AlphaTo(255, .1, 0)
    self:SetTitleBarSize(5)
    self:ShowCloseButton(false)
    self:SetTitle("")
    self.SetTitle = function(s, name)
        s.m_Title = name

        local x,y = VNP:GetTextSize(name, 22)

        self.m_titleW, self.m_titleH = x,y

        self:DockPadding(padding, self:GetTitleBarSize() + padding, padding, padding)
    end

    //self:SetDraggable(false)
    self:SetTitle("Frame")

    //self.btnClose:SetVisible(false)
	self.btnMinim:SetVisible(false)

	self.btnClose = vgui.Create("EliteUI.ImgurButton", self) // sorry elitelupus gaming :c 
	self.btnClose:SetImgurID("z1uAU0b") 
	self.btnClose:SetNormalColor(EliteUI.Colors.CloseButtonBackground)
	self.btnClose:SetHoverColor(EliteUI.Colors.CloseButtonBackgroundHover)
	self.btnClose:SetClickColor(EliteUI.Colors.CloseButtonBackgroundClicked)
	self.btnClose:SetDisabledColor(EliteUI.Colors.ImageButtonDisabled)
	
    self.btnClose.DoClick = function(s)
		self:Close()
	end

    self:MakePopup()
end

function PANEL:GetTitle()
    return self.m_Title or ""
end

function PANEL:GetTitleTextSize()
    return self.m_titleW, self.m_titleH
end

function PANEL:GetTitleBarSize()
    local x,y = VNP:GetTextSize(self:GetTitle(), 22)

    return y+self.m_titleBarH
end

function PANEL:SetTitleBarSize(size)
    size = tonumber(size) or 5

    self.m_titleBarH = VNP:resFormatH(size)

    self:DockPadding(padding, self:GetTitleBarSize() + padding, padding, padding)
end

function PANEL:Paint(w,h)
    draw.RoundedBox(5,0,0,w,h,Color(15,15,17,255))

    local H = self:GetTitleBarSize()

    local x,y = self:GetTitleTextSize()

    if self:GetTitle() ~= "" then
		draw.RoundedBox( 6, 0, 0, w, H, Color(30,30,34) )
	end
    VNP:DrawText(self:GetTitle(), 22, w*.005,H/2-y/2, color_white, 0) // baka thingy

    self:PostPaint(w,h)
end

function PANEL:PostPaint()end

function PANEL:PerformLayout()

    DFrame.PerformLayout( self, w, h )

    local x,y = self:GetTitleTextSize()

    local size = self:GetTitleBarSize()

    self.btnClose:SetPos( self:GetWide()-(size*.75), (size*.5)/2 )
	self.btnClose:SetSize( size*.62, size*.62 )

end



vgui.Register( "VNPFrame", PANEL, "DFrame")