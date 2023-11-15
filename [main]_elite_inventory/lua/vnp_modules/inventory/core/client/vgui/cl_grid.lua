local draw_RoundedBox, vgui_Register = draw.RoundedBox, vgui.Register

local PANEL = {}

AccessorFunc( PANEL, "m_iCols", "Cols" )
AccessorFunc( PANEL, "m_iColWide", "ColWide" )
AccessorFunc( PANEL, "m_iRowHeight", "RowHeight" )
AccessorFunc( PANEL, "m_iSpacingH", "HorizontalSpacing" )
AccessorFunc( PANEL, "m_iSpacingV", "VerticalSpacing" )

function PANEL:Init()

	self.Items = {}

	self:SetCols( 4 )
	self:SetColWide( 32 )
	self:SetRowHeight( 32 )
	self:SetHorizontalSpacing( 5 )
	self:SetVerticalSpacing( 5 )

	self:SetMouseInputEnabled( true )

end

function PANEL:GetItems()
	return self.Items
end

function PANEL:AddItem( item )

	if ( !IsValid( item ) ) then
		print( "Attempted to add a NULL Panel" )
	return end

	item:SetVisible( true )
	item:SetParent( self )

	table.insert( self.Items, item )

	self:InvalidateLayout()

end

function PANEL:RemoveItem( item, bDontDelete )

	for k, panel in pairs( self.Items ) do

		if ( panel == item ) then

			table.remove( self.Items, k )

			if ( !bDontDelete ) then
				panel:Remove()
			end

			self:InvalidateLayout()

		end

	end

end

function PANEL:EnableBorder( bool )
	self.m_bBorder = bool
end

function PANEL:Paint( w, h )
	if self.m_bShouldDrawBlur then self:DrawBlur( 8 ) end
	draw_RoundedBox( 0, 0, 0, w, h, self:GetDrawColour( "Background" ) )

	if self.m_bBorder then self:DrawBorder( 0, 0, w, h, self:GetDrawColour( "Select" ) ) end

	self:PostPaint( w, h )
end

function PANEL:PostPaint( w, h )

end

function PANEL:PerformLayout()

	local i = 0

	self.m_iCols = math.floor( self.m_iCols )

	for k, panel in pairs( self.Items ) do
		if !panel.OrgWide then panel.OrgWide = panel:GetWide() end
		if !panel.OrgTall then panel.OrgTall = panel:GetTall() end

		panel:SetSize( panel.OrgWide - self.m_iSpacingH, panel.OrgTall - self.m_iSpacingV )

		local x = ( ( i % self.m_iCols ) * self.m_iColWide )
		local y = ( math.floor( i / self.m_iCols ) * self.m_iRowHeight )

		panel:SetPos( x, y )

		i = i + 1
	end

	self:SetWide( self.m_iColWide * self.m_iCols )
	self:SetTall( math.ceil( i / self.m_iCols ) * self.m_iRowHeight )

end

function PANEL:SortByMember( key, desc )

	if ( desc == nil ) then 
		desc = true
	end

	table.sort( self.Items, function( a, b )

		if ( desc ) then

			local ta = a
			local tb = b

			a = tb
			b = ta

		end

		if ( a[ key ] == nil ) then return false end
		if ( b[ key ] == nil ) then return true end

		return a[ key ] > b[ key ]

	end )

end



vgui_Register( "VNPGrid", PANEL, "DPanel")