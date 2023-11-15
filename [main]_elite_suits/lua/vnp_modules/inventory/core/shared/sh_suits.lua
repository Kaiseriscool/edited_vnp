local PLAYER = FindMetaTable("Player")

function PLAYER:RemoveSuit()

    self._SuitData = nil

    

    if self._PriorSuit && SERVER then
        self:SetMaterial("")
        self:SetModel(self._PriorSuit.Model)
        self:SetRunSpeed(self._PriorSuit.RunSpeed)
        self:SetJumpPower(self._PriorSuit.JumpPower)

        self._PriorSuit = nil

        self:SendData("VNP.SyncSuit", {})
    end
end

function PLAYER:SetSuit(data)

    local idata = VNP.Inventory:GetItemData(data.Name)

    if !idata then return end

    self._SuitData = data

    if SERVER then
        if !self._PriorSuit then
            self._PriorSuit = {}
            self._PriorSuit.Model = self:GetModel()
            self._PriorSuit.RunSpeed = self:GetRunSpeed()
            self._PriorSuit.JumpPower = self:GetJumpPower()
        end

        self:SetModel(idata.SuitModel)

        local baseMods = idata["BaseModifiers"]

        if data["SuitSpeed"] or (data.Rarity.Modifiers && data.Rarity.Modifiers["SuitSpeed"]) then
            local mod = data.Rarity.Modifiers["SuitSpeed"] && data.Rarity.Modifiers["SuitSpeed"]/100 or 0

            if baseMods["SuitSpeed"] then
                local val =  (istable(baseMods["SuitSpeed"]) && baseMods["SuitSpeed"].val) or (isnumber(baseMods["SuitSpeed"]) && baseMods["SuitSpeed"] )or 0
                if val then
                    mod = mod + (val/100)
                end
            end


            if mod > 0 then
                local speed = self:GetRunSpeed()*(4+mod)

                self:SetRunSpeed(speed)
            end
        end

        if data["SuitJump"] or (data.Rarity.Modifiers && data.Rarity.Modifiers["SuitJump"]) then
            local mod = data.Rarity.Modifiers["SuitJump"] && data.Rarity.Modifiers["SuitJump"]/100 or 0
            local jump = data["SuitJump"] && data["SuitJump"]*(100+mod) or mod

            if data.LSkins then
                self:SetMaterial(data.LSkins)
            end
            

            if jump > 200 then
                jump = self:GetJumpPower()+jump

                self:SetJumpPower(jump) 
            end
        end

        if data.LSkins then
            self:SetMaterial(data.LSkins)
        end

        self:SendData("VNP.SyncSuit", {item = data})
        
        timer.Simple(3, function()
            if !IsValid(self) then return end
            self._DoSuitRegen = true
            self:RegenSuit()
        end)
    end
end

function PLAYER:UpdateSuit(key, value)
    if !self._SuitData then return end

    if self._SuitData[key] then
        self._SuitData[key] = value
    end

    if SERVER then
        self:SendData("VNP.UpdateSuit", {key = key, value = value})
    end
end

function PLAYER:GetSuit()
    return self._SuitData or false
end
hook.Add("InitPostEntity", "VNP.Suits.CreateEnts", function()
    local suits = table.GetKeys(VNP.Inventory.Items["SUIT"])



    for i,name in ipairs(suits) do
        local BASE = scripted_ents.Get("vnp_item_base")

        BASE.PrintName = name
        BASE.Spawnable = true
        BASE.VNPItemName = name
        BASE.Category = "VNP Suits"

        scripted_ents.Register(BASE, "vnp_suit_"..string.lower(string.Replace(name, " ", "_")))
    end
end)

function VNP.Inventory:CalculateMaxStat(suit, stat)
    local baseMods = VNP.Inventory:GetItemData(suit.Name, "BaseModifiers")

    if !baseMods then return end
    if !baseMods[stat] && !suit.Rarity.Modifiers[stat] then return end

    local baseStat = istable(baseMods[stat]) && baseMods[stat].val or isnumber(baseMods[stat]) && baseMods[stat] or 0
    local suitMaxStat = suit.Rarity.Modifiers[stat] && baseStat && baseStat*(1+suit.Rarity.Modifiers[stat]/100) or baseStat or suit.Rarity.Modifiers[stat]

    return math.Round(suitMaxStat)
end