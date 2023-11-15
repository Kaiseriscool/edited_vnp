local PANEL = {}

/*
    	EliteUI.DrawRoundedBox(EliteUI.Scale(6), 0, 0, w, h, EliteUI.Colors.Background)

*/


function PANEL:Init()
    self:SetAlpha( 0 )
	self:AlphaTo( 255, 0.12, 0, function() end ) // little bit of animation :3 
    self:SetDrawOnTop(true)
    self:SetAutoDelete(true)
    self:SetResSize(550,300)
    
end



function PANEL:Paint(w,h) -- Welp this is where the code starts to become spaghetti but its aight
    EliteUI.DrawRoundedBox(EliteUI.Scale(6), 0, 0, w, h, EliteUI.Colors.Background)

    if !self._itemData then return end
    if !self.rData then return end

    local altDown = input.IsKeyDown(KEY_LALT)

    local spacer = VNP:resFormatH(7)

    local name = self._itemData.Label or self._itemData.Name
    local kills = self._itemData.Kills or 0
    local amount = self._itemData.Amount or 1
    local uid = self._itemData.UID or math.random(9999)
    local sig = self._itemData.Signature
    local rarity = self._itemData.Rarity.Name
    local rColor = IsColor(self.rData.Color) && self.rData.Color or self.rData.Color == "rainbow" && HSVToColor( CurTime()%11.25*32, .65, 1 ) or color_white
    local x,y = 0,spacer
    local tW,tH = 0,0

    if sig == "Lweo" && altDown then
        print("hi")
    end

    if self.iData.Class then
        name = VNP.Inventory:GetLanguageLabel(self.iData.Class) or name
    end

    if altDown && sig then name = name.." / "..sig end

    if amount > 1 then name = amount.."x "..name end

    tW,tH = VNP:DrawText(name, 22, w/2, y, color_white, 1) // was 26
    y=y+tH
    
    if self._itemData.UID then
        VNP:DrawText(uid, 30, w*.1, y, color_white, 0)
    end

if self._itemData.Type == "SUIT" then self._itemData.UID = false end

if self._itemData.Type == "GEM" then self._itemData.UID = false end 

if self._itemData.Type == "UPGRADEGEM" then self._itemData.UID = false end 


if self._itemData.Type == "SCROLL" then self._itemData.UID = false end 

if self._itemData.Type == "SCROLL" then
   -- print("hi")
  --  VNP:DrawText("hi", 30, w*.9-tW, y, color_white, 3)
    
end

    if self.HasKillCounter then
        tW,tH = VNP:GetTextSize(kills.." kills", 30)
        VNP:DrawText(kills.." kills", 30, w*.9-tW, y, color_white, 3)
    end

    -- skins :3 
    local lskintext = ""
    if self._itemData.LSkins and self._itemData.LSkins ~= "" then
        lskintext = string.Explode("/", self._itemData.LSkins)
        lskintext = lskintext[#lskintext]
        lskintext = string.Replace(lskintext, "_", " ")
    end
    if lskintext and lskintext ~= "" then
        if self._itemData.LSkins and LSkins.Rarity[self._itemData.LSkins] then
            local rarityInfo = LSkins.Rarity[self._itemData.LSkins]
                if rarityInfo.rarity == "Unattainable" then
                    local r2Color = rarityInfo.color or Color(255, 255, 255)
                    local w1, w2 = VNP:DrawText(rarity.." - ", 22, (w/2), y*1.1, Color(0,0,0,0), 0, true) -- shows actually rarity of gun
                    tW,tH = VNP:DrawText(rarity .. " - ", 22, (w/2)-w1, y*1.15, rColor, 0)
                    if lskintext and lskintext ~= "" then
                        tW,tH = VNP:DrawText(lskintext.."("..(rarityInfo.rarity or "")..")", 22, (w/2), y*1.2, HSVToColor((CurTime() * 300), 0.7, 1), 0)
                    end
                end
                if rarityInfo.rarity != "Unattainable" then
                
                local r2Color = rarityInfo.color or Color(255, 255, 255)
                local w1, w2 = VNP:DrawText(rarity.." - ", 22, (w/2), y*1.1, Color(0,0,0,0), 0, true) -- shows actually rarity of gun
                tW,tH = VNP:DrawText(rarity .. " - ", 22, (w/2)-w1, y*1.15, rColor, 0)
                if lskintext and lskintext ~= "" then
                    tW,tH = VNP:DrawText(lskintext.."("..(rarityInfo.rarity or "")..")", 22, (w/2), y*1.2, r2Color, 0)
                end
            end
            end
        else
            tW,tH = VNP:DrawText(rarity, 22, (w/2), y*1.1, rColor, 1) -- if no skin then just show as this <3 
    end
    y=y+tH+spacer*0.5

    if self.iData.Description then
        local str = self.iData.Description

        tW,tH = VNP:DrawText(str, 18, w/2, y, color_white, 1)
        y=y+tH
    end 

    
    

 
    --if self._itemData.Type ~= "GEM" then
        for stat,val in SortedPairs(self.Stats, false) do // sorting the stats on weapons out

            local label = VNP.Inventory:GetLanguageLabel(stat) or stat
            local suffix = VNP.Inventory:GetLanguageSuffix(stat) or "%"
            local prefix = VNP.Inventory:GetLanguagePrefix(stat) or "+"
            local col = self._itemData.Type == "UPGRADEGEM" && Color(0,200,0) or Color(255, 46, 46)
            

            
            if !label then 
                continue
            end
            tW,tH = VNP:DrawText(label, 22, w*.1, y+spacer*1.5, color_white, 0)

            if self._itemData.Type == "WEAPON" && self.rData.Color == "rainbow" then 
                col = Color(47, 255, 47) -- if glitched then green color instead of red :3 
            end

            if self._itemData.Type == "GEM" then 
                
            end



            if self._itemData.Type ~= "SUIT" then
                local value = 1
                if istable(self.iData.Modifiers[stat]) then
                    value = (self.iData.Modifiers[stat].val or 0) > 0.99 and self.iData.Modifiers[stat].val or 1
                else
                    value = (self.iData.Modifiers[stat] or 0) > 0.99 and self.iData.Modifiers[stat] or 1
                end



            if self._itemData.Type == "WEAPON" then
                
                local p = self.iData.Modifiers[stat] > 0.99 and self.iData.Modifiers[stat] or 1

                value = prefix..math.floor((p * val)/ 100) -- credits to argon networks fully, i don't take credit for it.
                


                VNP:DrawText(value, 26, w*.9, y+spacer*1.5, col, 2)   
            else
                
                value = "+" ..val.."%" 
                VNP:DrawText(value, 26, w*.9, y+spacer*1.5, col, 2)        
            end
        end

            
            if self._itemData.Type == "WEAPON" && self.iData.Modifiers[stat] then
                local value = self.iData.Modifiers[stat] > 0.99 and self.iData.Modifiers[stat] or 1
                value = math.ceil(value)
                VNP:DrawText( value, 26, w*.6, y+spacer*1.5, color_white, 2)

            end


            if self._itemData.Type == "SUIT" && self.iData.BaseModifiers[stat] then
                --PrintTable(self._itemData.Rarity.Modifiers)
                --print(self._itemData)
                --PrintTable(self._itemData)
                --PrintTable(self)
                --print(self)
                local v = (istable(self.iData.BaseModifiers[stat]) && self.iData.BaseModifiers[stat].val) or (isnumber(self.iData.BaseModifiers[stat]) && self.iData.BaseModifiers[stat])
                if stat == "SuitHealth" then
                    local amt = self._itemData["SuitHealthMax"] or 1
                    print(amt)
                    v = amt
                end
                if stat == "SuitArmor" then
                    local amt = self._itemData["SuitArmorMax"] or 1
                    print(amt)
                    v = amt
                end
                if v and stat != "SuitSpeed" or stat == "SuitArmor" then
                    --v = v * (1+val/100)
                    VNP:DrawText(v, 26, w*.9, y+spacer*1.5, color_white, 2)
                else
                    --print(v , stat)
                    --print(self._itemData.Rarity.Modifiers.stat)
                    --PrintTable(self._itemData.Rarity.Modifiers)
                    v = v or self._itemData.Rarity.Modifiers[stat] or 1
                    --print(v)
                    
                    if stat == "SuitResist" or stat == "SuitRegen" or stat == "SuitEnergyResist" then
                        v = v.."%"
                    elseif stat == "SuitSpeed" then
                        v = "x"..((val/100)) + 1
                    elseif stat == "SuitHealth" then
                        v = v
                    else
                        v = "x"..(val/100)
                    end
                    VNP:DrawText(v, 26, w*.9, y+spacer*1.5, color_white, 2)
                end
            end

            y=y+tH+(spacer*0.5)
        end 
    --else
    --end
    --else
    --end


    if self._itemData.Sockets && #self._itemData.Sockets > 0 && (self._itemData.Type == "WEAPON" or self._itemData.Type == "SUIT") then
        local hasGems = false
        for s,g in ipairs(self._itemData.Sockets) do
            if g then hasGems = true break end
        end

        if hasGems then

            tW,tH = VNP:DrawText("Equipped Gems", 24, w/2, y+spacer*2.5, color_white, 1)
            VNP:DrawText("Info - Hold Alt", 18, w*.9, y+spacer*2.5+(tH/4), Color(120,120,120), 2)
            y=y+tH+(spacer*.5)

            local swap = true

            for socket, gem in ipairs(self._itemData.Sockets) do
                if !gem then continue end
                local color = VNP.Inventory:GetRarityValue(gem.Rarity.Name, "Color") or Color(120,120,120)
                color = IsColor(color) && color or color == "rainbow" && HSVToColor( CurTime()%11.25*32, .65, 1 ) or Color(138,138,138)
                swap = !swap
                tW,tH = VNP:GetTextSize(gem.Name, 18)

                if !altDown then
                    VNP:DrawText(gem.Name, 18, swap && w*.75+tW or w*.1+tW, y+spacer*2.5, color, 2)
                end
               -- VNP:DrawText(gem.Name, 18, swap && w*.65+tW or w*.1+tW, y+spacer*2.5, color, 2) 
               if altDown then
                    local mods = VNP.Inventory:GetItemData(gem.Name, "Modifiers")

                    if mods[self._itemData.Rarity.Name] then
                        mods = mods[self._itemData.Rarity.Name]
                    end

                    local tPos = swap && w*.8+tH+spacer or w*.17+tH+spacer

/*
                            VNP:DrawText("("..mod.."%)", 18, tPos, y+spacer*2.5, Color(70,200,50), 0) // should be changed on the percentage, but who cares?
                            VNP:DrawText(gem.Rarity.Name, 18, swap && w*.8+tH or w*.17+tH, y+spacer*2.5, color, 2)
                            if mod > 80 then
                        VNP:DrawText("("..mod.."%)", 18, tPos, y+spacer*2.5, Color(70,200,50), 0) // should be changed on the percentage, but who cares?
                        VNP:DrawText(gem.Rarity.Name, 18, swap && w*.8+tH or w*.17+tH, y+spacer*2.5, color, 2)
                        break
                    end
                end
*/

 
                    if gem.Modifiers then
                        for stat,mod in pairs(gem.Modifiers) do
                            if altDown then
                             tw1, th1 = surface.GetTextSize( gem.Name )


                            local t = VNP.Inventory:GetLanguageType(stat)
                            if t && t ~= self._itemData.Type then continue end
                            VNP:DrawText("("..mod.."%)", 18, tPos, y+spacer*2.5, Color(70,200,50), 0) // should be changed on the percentage, but who cares?
                            VNP:DrawText(gem.Rarity.Name, 18, swap && w*.8+th1 or w*.17+tH, y+spacer*2.5, color, 2)
                         
                         
                            if mod >= 80 then
                        VNP:DrawText("("..mod.."%)", 18, tPos, y+spacer*2.5, Color(70,200,50), 0) // should be changed on the percentage, but who cares?
                        VNP:DrawText(gem.Rarity.Name, 18, swap && w*.8+th1 or w*.17+th1, y+spacer*2.5, color, 2)
                        break
                    end
                end

                    if mod >= 60 then
                        VNP:DrawText("("..mod.."%)", 18, tPos, y+spacer*2.5, Color(255, 175, 0, 255), 0) // should be changed on the percentage, but who cares?
                        VNP:DrawText(gem.Rarity.Name, 18, swap && w*.8+th1 or w*.17+th1, y+spacer*2.5, color, 2)
                        break
                end

                if mod <= 20 then
                    VNP:DrawText("("..mod.."%)", 18, tPos, y+spacer*2.5, Color(150, 150, 150, 255), 0) // should be changed on the percentage, but who cares?
                    VNP:DrawText(gem.Rarity.Name, 18, swap && w*.8+th1 or w*.17+th1, y+spacer*2.5, color, 2)
                    break
            end


                            break
                        end
                    end
                

                end  
                if swap then
                    y=y+tH+(spacer*0.15) -- spaces out the gems
                end
            end
            y = y + spacer*0.8 + tH -- fix the stupid amount of space for when there is a lot of gems..
        end
    end

    if y ~= self:GetTall() then
        self:SetTall(y*1.22)
    end
    
end


function PANEL:SetItemData(data)
    self._itemData = data

    self.Stats = {}

    if self._itemData.Rarity.Modifiers then
        for stat,val in pairs(self._itemData.Rarity.Modifiers) do
            self.Stats[stat] = val
        end
    end
    
    if self._itemData.Sockets then
        self.GemCount = 0
        for socket,gem in pairs(self._itemData.Sockets) do
            if !gem then continue end

            self.GemCount = self.GemCount+1

            if gem.Name == "Kill Counter" then self.HasKillCounter = true end

            if !gem.Modifiers then continue end

            for stat,val in pairs(gem.Modifiers) do
                if !self.Stats[stat] then continue end

                local rVal = gem.Modifiers[stat]

                if rVal then
                    local mod = val*(1+rVal/100)
                    self.Stats[stat] = self.Stats[stat]+mod
                end
            end
        end
    end

    if self._itemData.Modifiers then
        for stat,val in pairs(self._itemData.Modifiers) do
            self.Stats[stat] = val
        end
    end
    self.iData = VNP.Inventory:GetItemData(self._itemData.Name)
    self.rData = VNP.Inventory:GetRarity(self._itemData.Rarity.Name)
end

function PANEL:Think()

    local x,y = self:GetPos()
    local height = self:GetTall()

    if y+height > ScrH() then self:SetPos(x,ScrH()-height-4) end

    if !IsValid(self._parent) then self:Remove() end

    if !ispanel(self._parent) then return end

    if self._parent && !self._itemData then self:Remove() end
    if !vgui.CursorVisible() then self:Remove() end

    if !self._parent:IsVisible() then self:Remove() end
end




vgui.Register( "VNPItemInfo", PANEL, "DPanel")