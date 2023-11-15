local PANEL = {}

local padding = VNP:resFormatW(10)
local height = VNP:resFormatH(50)
local minus = -25
function PANEL:Init()

end

function PANEL:Paint(w,h)

    draw.RoundedBox(5,0,0,w + minus,h,EliteUI.Colors.MenuBackground)
end

function PANEL:PerformLayout( w, h )

    DMenu.PerformLayout( self, w, h )

    local y = 0

    self:GetCanvas().Paint = function(s,w,h)

    end

    for k, pnl in pairs( self:GetCanvas():GetChildrenRecursive() ) do

        if pnl:GetText() && !pnl.m_Text then
            pnl.m_Text = pnl:GetText()

            pnl:SetText("")
        end
        pnl.lerp = 0
        pnl.Paint = function(s,w,h) 

            draw.RoundedBox(5,0,0,w + minus,h,EliteUI.Colors.MenuBackground)
            local x,y = VNP:GetTextSize(pnl.m_Text, 16)
            VNP:DrawText(pnl.m_Text, 16, w*.12, h/2-y/2, color_white, 0)
            local hovered = s:IsHovered()

            if !hovered && s.lerp < 1 then return end
            s.lerp = Lerp(0.15, s.lerp, hovered && 20 or 0)
            draw.RoundedBox(0, 0, 0, w + minus, h, Color(255, 255, 255, s.lerp))
        end
    end
end

vgui.Register( "VNPOptionMenu", PANEL, "DMenu")