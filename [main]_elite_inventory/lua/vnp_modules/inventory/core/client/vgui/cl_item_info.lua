local function Createv1_v2()
    VNP.Inventory:OpenInventory()
    local frame = vgui.Create("EliteUI.Frame")
    frame:MakePopup()
    frame:SetTitle("ITEM INFOER")
    local scrw, scrh = ScrW(), ScrH()
    frame:SetSize(scrw * .35, scrh * .45)
    frame:Center()
    frame:SetY(VNP:resFormatH(120))
    local w, h = frame:GetSize()
    local itemSlotSize = 180
    local itemSlot = vgui.Create("VNPInvSlot", frame)
    itemSlot:SetResSize(itemSlotSize, itemSlotSize)
    itemSlot:SetResPos(w * .2, h / 3.9 - itemSlotSize / 2)
    itemSlot:SetAllowOptions(false)

    itemSlot:Receiver("Swap Inventory Item", function(s, p, b)
        if not b then return end
        local sender = p[1].Slot
        if not p[1].Data and not s.Data then return end
        local t = p[1].Data.Type
        itemSlot.iSlot = sender
        itemSlot.iData = p[1].Data
        if itemSlot.sData then end --print("Real?")
    end)

    itemSlot.GetItemData = function(s)
        if itemSlot.ItemIsUpgrade then return LocalPlayer()._vInventory["UPGRADES"][itemSlot.iSlot] end

        return LocalPlayer()._vInventory[itemSlot.iSlot]
    end

    local labels = {"Creator : ?" , 'PlayerNick : ?'}

    local labelPanel = vgui.Create("Panel", frame)
    labelPanel:SetPos(w * .2, h / 6 + itemSlotSize / 2)
    labelPanel:SetSize(w * 0.6, h)

    local function RefreshLabels()
        labelPanel:Clear()
        local yPos = 0

        for i, text in ipairs(labels) do
            local label = vgui.Create("DLabel", labelPanel)
            label:SetText(text)
            label:SetPos(0, yPos)
            --label:SetFont("DermaDefaultBold")
            label:SizeToContents()

            if itemSlot:GetItemData() and i == 1 then
                --print(" Real ?")
                itemSlot:GetItemData().creator = itemSlot:GetItemData().creator or "Pre-Inv Update"
                txt = "   Creator SID: "..itemSlot:GetItemData().creator or "Pre-Inv Update"
                label:SetText(txt)
                label:SizeToContents()
            end
            if itemSlot:GetItemData() and i == 2 then
                itemSlot:GetItemData().creator = itemSlot:GetItemData().creator or "Pre-Inv Update"
                if itemSlot:GetItemData().creator == "Pre-Inv Update" then
                    txt = "   Player Name: Pre-Inv Update :("
                    label:SetText(txt)
                    label:SizeToContents()
                    return 
                end
                txt = "   Player Name: "..player.GetBySteamID64(itemSlot:GetItemData().creator):Nick() or "Pre-Inv Update"
                label:SetText(txt)
                label:SizeToContents()
            end

            yPos = yPos + label:GetTall() + 5
        end
    end

    RefreshLabels()


    frame.OnClose = function()
        local delay = 0.1 -- cringe?

        if IsValid(VNP.Inventory.Menu) then
            VNP.Inventory.Menu:AlphaTo(0, delay, 0, function()
                VNP.Inventory.Menu:Remove()
            end)
        end
    end

    frame.Think = function()
        RefreshLabels()
    end
end

concommand.Add("vnp_admin_thinker", function()
    Createv1_v2()
end)