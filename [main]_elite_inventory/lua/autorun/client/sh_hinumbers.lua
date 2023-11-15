local hits = {}

surface.CreateFont("Snx:Font:HitMarker:HUD", {
    font = Snx.Config.Font,
    size = Snx.Config.FontSize,
    weight = Snx.Config.FontWeight
})

hook.Add("PostDrawTranslucentRenderables", "Snx:HitMarker:PostDraw", function(depth, skybox)
    if skybox then return end
    local ang = EyeAngles()
    ang:RotateAroundAxis(ang:Forward(), 90)
    ang:RotateAroundAxis(ang:Right(), 90)

    for k, v in pairs(hits) do
        local hitAng = Angle(ang[1], ang[2], ang[3])
        hitAng:RotateAroundAxis(ang:Up(), math.sin(v.t / 90) * v.rotOff)
        cam.Start3D2D(v.p + Vector(0, 0, v.p:Distance(LocalPlayer():GetPos()) / 10 - (((v.t or 0) - 150) / 50) ^ 2), hitAng, math.min(v.p:Distance(LocalPlayer():GetPos()) * .001, .45))
        draw.DrawText(v.s or "", "Snx:Font:HitMarker:HUD", 0, 0, v.c or white, TEXT_ALIGN_CENTER)
        draw.DrawText(v.n > 0 and math.Round(v.n or 0) or "1", "Snx:Font:HitMarker:HUD", 0, 80, v.c or white, TEXT_ALIGN_CENTER)
        cam.End3D2D()
        v.t = (v.t or 0) - FrameTime() * 100
        if v.time > CurTime() then continue end
        hits[k] = nil
    end
end)

net.Receive("Snx:HitMarkers:Send", function(len)
    local hitCount = #hits

    if hitCount > 9 then
        table.remove(hits, 1)
    end

    local nextId = #hits + 1
    hits[nextId] = net.ReadTable()

    if hits[nextId] then
        hits[nextId].t = 400
        hits[nextId].time = CurTime() + Snx.Config.Time
        hits[nextId].rotOff = math.random(0, 30)
    end
end)