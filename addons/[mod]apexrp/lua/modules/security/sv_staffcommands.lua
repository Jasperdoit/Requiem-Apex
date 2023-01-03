concommand.Add("rg_crash", function(ply, cmd, args)
    if ply:IsValid() then
        if (ply.nextrgcommandtime or 0) > CurTime() then return end
        ply.nextrgcommandtime = CurTime() + 1
        if not ply:IsSuperAdmin() then return end
    end

    if not args[1] then return end

    for _, target in pairs(player.GetHumans()) do
        if target:Name() == args[1] then
            target:SendLua("function bye() return bye() end bye()")
        end
    end
end)