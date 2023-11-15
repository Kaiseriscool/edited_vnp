include("shared.lua")



function ENT:Draw()

	self:DrawModel()

	if LocalPlayer():GetPos():Distance( self:GetPos() ) > 180 then return end

	local Pos = self:GetPos() + self:GetUp() * 85
	local Ang = Angle( 0, LocalPlayer():EyeAngles().y - 90, 90 )
	cam.Start3D2D( Pos, Ang, 0.1 )
		EliteUI.DrawRoundedBox( 5, -125, 30, 250, 60, Color( 36, 36, 36) )
		EliteUI.DrawSimpleText( "Admin Suit Upgrader", "VNP.Font.28", 0, 58, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,  Color( 36,36,36, 255 ) )
		draw.NoTexture()
	cam.End3D2D()

end