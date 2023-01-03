hook.Add("ScalePlayerDamage", "MyLeg!", function(ply, hitgroup, dmg)
    if (hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG) and ply:Armor() <= 10 and dmg:GetDamage() >= 5 and not (ply.legslowcooldown) then
        ply.prelegbreakspeed = ply:GetRunSpeed()
        ply.legslowcooldown = true
        ply:EmitSound("player/pl_fallpain3.wav")
        ply:SetRunSpeed(ply.prelegbreakspeed * 0.7)
        timer.Create("stopslowdown" .. ply:SteamID(), 4, 1, function()
            ply:SetRunSpeed(ply.prelegbreakspeed)
        end)
        timer.Create("Breaklegcooldown" .. ply:SteamID(), 8, 1, function()
            ply.legslowcooldown = false
            ply:SetRunSpeed(ply.prelegbreakspeed)
            ply.prelegbreakspeed = nil
        end)
    end
end)