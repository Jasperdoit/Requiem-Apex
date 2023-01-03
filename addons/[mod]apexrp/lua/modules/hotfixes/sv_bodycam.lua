concommand.Add("rg_bodycam", function(ply, cmd, args)
    if (ply.nextdispatchtime or 0) > CurTime() or not ply:IsValid() then return end
    ply.nextdispatchtime = CurTime() + 1
    if not args[1] then return end
    if ply:isDispatchUnit() then
        local target = nil
        for _, targets in pairs(player.GetHumans()) do
            if string.find(string.lower(targets:Name()), string.lower(args[1])) and (targets:Team() == TEAM_CP or targets:Team() == TEAM_OVERWATCH) then
                target = targets
                break
            end
        end
        if not target then return ply:notify("invalid player!") end
        local targetname = target:Name()
        local targethp = target:Health()
        local targetarmor = target:Armor()

        if (target:Team() == TEAM_CP or target:Team() == TEAM_OVERWATCH) then
            ply:notify("<:: You are now watching unit ::>")
            ply:ChatPrint("<:: DATABASE START ::>")
            ply:ChatPrint("Unit Status: On-Duty")
            ply:ChatPrint("Name: " .. targetname)
            ply:ChatPrint("Vital Signs:")
            ply:ChatPrint("Armor: " .. targetarmor)
            ply:ChatPrint("Health: " .. targethp)
            ply:ChatPrint("<:: DATABASE END ::>")
            ply:Spectate(OBS_MODE_IN_EYE)
            ply:SpectateEntity(target)
            ply:ConCommand("pp_mat_overlay effects/combine_binocoverlay")
            ply:StripWeapons()
            ply:SetNWBool("isinbodycam", true)
        end
    end
end)