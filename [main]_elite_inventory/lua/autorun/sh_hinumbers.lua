if SERVER then
    util.AddNetworkString("Snx:HitMarkers:Send")

    hook.Add("EntityTakeDamage", "Snx:Hitmarker:OnTakeDamage", function(target, dmginfo)
        target.infoHit = target.infoHit or {}
        local hits = {}
        hits.p = dmginfo:GetReportedPosition() + target:GetPos() + Vector(math.random(40) - 20, math.random(40) - 20, math.random(20) + 80)
        hits.s = target.infoHit.status
        hits.n = math.floor(dmginfo:GetDamage())
        hits.c = target.infoHit.color

        if dmginfo:GetAttacker() and dmginfo:GetAttacker():IsPlayer() then
            net.Start("Snx:HitMarkers:Send")
            net.WriteTable(hits)
            net.Send(dmginfo:GetAttacker())
        end

        target.infoHit = {}
    end)
end

Snx = Snx or {}
Snx.Config = Snx.Config or {}

Snx.Config = {
    Time = 3.5, -- Seconds that the damage is displayed
    Font = "Roboto Medium",
    FontSize = 36,
    FontWeight = 500
}