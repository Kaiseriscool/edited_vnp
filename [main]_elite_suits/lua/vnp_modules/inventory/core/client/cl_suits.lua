VNP:AddNetworkString("VNP.SyncSuit", function(ply, data)
    local suit = data.item

    if !suit then 
        ply:RemoveSuit()
        return 
    end

    ply:SetSuit(suit)
end)

VNP:AddNetworkString("VNP.UpdateSuit", function(ply, data)
    local key = data.key
    local value = data.value

    if !key or !value then return end

    ply:UpdateSuit(key, value)
end)

local heart = Material("icon16/heart.png")
local armor = Material("icon16/shield.png")

local sHealth = 0
local sArmor = 0
local max = sArmor + sHealth
local barBG = EliteUI.Colors.Background 
local health_perc = math.Round( sHealth/max, 3 )
local armor_perc = math.Round( sArmor/max, 3 ) -- not used but yeah

local Lerp = Lerp


hook.Add("HUDPaint", "VNP.Suits.DrawHud", function()
 
    local suit = LocalPlayer():GetSuit()

    if !suit then return end
    
    local sW,sH = ScrW(), ScrH()
    local w,h = VNP:resFormatW(300), VNP:resFormatH(110)


    draw.RoundedBox(8, sW/2-w/2, sH*.015, w,h, barBG)

    local tW, tH = VNP:DrawText(suit.Name, 26, sW/2, sH*.015, Color(255,255,255))

    local barX,barY = sW/2-(w*3)/2,sH*.015+tH
    local barW,barH = w*3,h*.2

    local c = 2

    sHealth = Lerp(0.08, sHealth, suit["SuitHealth"])
    sArmor = Lerp(0.09, sArmor, suit["SuitArmor"])

    local suitHealth = math.Round(sHealth)
    local suitArmor = math.Round(sArmor)
    
    local suitMaxHealth = suit["SuitHealthMax"]
    local suitMaxArmor = suit["SuitArmorMax"]

    draw.RoundedBox(8, barX,barY,barW,barH, barBG)
    
    local size = math.Round((suitMaxHealth/(suitMaxHealth+suitMaxArmor))*0.7, 2)

    local healthW =  math.min(suitHealth*(barW*size/suitMaxHealth), barW*size)
    local armorW = math.min(suitArmor*(barW*(1-size)/suitMaxArmor), barW*(1-size))

    draw.RoundedBoxEx(8, barX+c,barY+c, healthW-c*2,barH-c*2, Color(66, 197, 66),true,false,true,false)
    draw.RoundedBoxEx(8, barX+healthW-c,barY+c, armorW,barH-c*2, Color(0, 155, 255),false,true,false,true)

    local iconSize = VNP:resFormatH(15)

    VNP:DrawIcon(heart, sW/2-w/2.5,sH*.065,iconSize,iconSize)
    VNP:DrawIcon(armor, sW/2-w/2.5,sH*.09,iconSize,iconSize)

    VNP:DrawText(suitHealth.."/"..suitMaxHealth, 26, sW/2, sH*.06, Color(255,255,255))
    VNP:DrawText(suitArmor.."/"..suitMaxArmor, 26, sW/2, sH*.085, Color(255,255,255))

end)