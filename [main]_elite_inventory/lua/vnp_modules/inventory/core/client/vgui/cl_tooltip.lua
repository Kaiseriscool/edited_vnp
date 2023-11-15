hook.Add("InitPostEntity", "VNP.OverwriteTooltip", function()
    DTooltip.Paint = function(s,w,h)
        draw.RoundedBox(5,0,0,w,h,Color(30,30,34,255))
    
        if s:GetFGColor() ~= color_white then
            s:SetFGColor(color_white)
        end
    end
    
    DTooltip.Init = function(s)
        s:SetDrawOnTop( true )
        s.DeleteContentsOnClose = false
        s:SetText("")
        s:SetFont("VNP.Font.22")
    
    end
end)