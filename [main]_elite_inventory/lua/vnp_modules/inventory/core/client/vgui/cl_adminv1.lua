local function Createv1_v2()
    VNP.Inventory:OpenInventory()
    local frame = vgui.Create("EliteUI.Frame")
    frame:MakePopup()
    frame:SetTitle("Admin Suit Upgrader?")
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
        if t ~= "SUIT" then return end
        itemSlot.iSlot = sender
        itemSlot.iData = p[1].Data
        if itemSlot.sData then end --print("Real?")
    end)

    itemSlot.GetItemData = function(s)
        if itemSlot.ItemIsUpgrade then return LocalPlayer()._vInventory["UPGRADES"][itemSlot.iSlot] end

        return LocalPlayer()._vInventory[itemSlot.iSlot]
    end

    local needed_hp = string.Comma(VNP.Inventory.AdminSuitUpgrader.Health)
    local price = string.Comma(VNP.Inventory.AdminSuitUpgrader.Price)
    local player_networth = string.Comma(LocalPlayer():getDarkRPVar("money")) -- real pooron

    local labels = {"   Admin Suit ✖", "   0 HP / " .. needed_hp .. " HP", "   " .. player_networth .. "$ / " .. price .. "$"}

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

            if itemSlot:GetItemData() and itemSlot:GetItemData().Name == "Admin Suit" and i == 1 then
                --print(" Real ?")
                txt = "   Admin Suit ✔"
                label:SetText(txt)
                label:SizeToContents()
            end

            if itemSlot:GetItemData() and itemSlot:GetItemData().Name == "Admin Suit" and i == 2 then
                --print(" Real ?")
                e = "✖"
                local hp = itemSlot:GetItemData().SuitHealth

                if hp > VNP.Inventory.AdminSuitUpgrader.Health then
                    e = "✔"
                end

                hp = string.Comma(itemSlot:GetItemData().SuitHealth)
                txt = "   " .. hp .. " / " .. needed_hp .. " HP" .. e
                label:SetText(txt)
                label:SizeToContents()
            end

            if i == 3 then
                local e = "✖"

                if LocalPlayer():getDarkRPVar("money") >= VNP.Inventory.AdminSuitUpgrader.Price then
                    e = "✔"
                end

                price = string.Comma(VNP.Inventory.AdminSuitUpgrader.Price)
                txt = "   " .. player_networth .. "$ / " .. price .. "$" .. e
                label:SetText(txt)
                label:SizeToContents()
            end

            yPos = yPos + label:GetTall() + 5
        end
    end

    RefreshLabels()
    local upgradeButton = vgui.Create("EliteUI.TextButton", frame)
    upgradeButton:SetText("Upgrade")
    upgradeButton:SetSize(100, 30)
    upgradeButton:SetPos(w * 0.5 - 50, h * 0.9)

    upgradeButton.DoClick = function()
        if itemSlot:GetItemData() then
            --PrintTable(itemSlot:GetItemData())
            local slot = itemSlot.iSlot

            --print("Slot:", slot)
            VNP:Broadcast("VNP.Upgradev1", {
                slot = slot
            })
        end
    end

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

concommand.Add("vnp_upgrade_menu", function()
    Createv1_v2()
end)