concommand.Add("rg_restart", function(ply)
    if not IsValid(ply) then
        BroadcastLua([[RCountDown()]])

        timer.Simple(60, function()
            RunConsoleCommand("changelevel", game.GetMap())
        end)
    end
end)

concommand.Add("rg_fullrestart", function(ply)
    if not IsValid(ply) then
        BroadcastLua([[RCountDown()]])

        timer.Simple(60, function()
            RunConsoleCommand("_restart")
        end)
    end
end)