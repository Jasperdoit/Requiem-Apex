util.AddNetworkString("playsoundonclientviaconcommand")
util.AddNetworkString("stopsoundonclientviaconcommand")

concommand.Add("rg_playsound", function(ply, cmd, args)
    if (ply.nextrgcommandtime or 0) > CurTime() then return end
    ply.nextrgcommandtime = CurTime() + 1
    if ply:IsValid() and not ply:IsAdmin() then return end
    if not args[1] then return end
    if string.find(args[1], " ") then return end
    local songstring = args[1]
    local stepvolume = args[2] or 55
    local pitch = args[3] or 100
    local volume = args[4] or 1
    local playername = "Console"

    volume = math.Round(volume, 3)

    if ply:IsValid() then
        playername = ply:Name()
    end
    net.Start("playsoundonclientviaconcommand")
        net.WriteString(songstring)
        net.WriteInt(stepvolume, 32)
        net.WriteInt(pitch, 32)
        net.WriteFloat(volume)
        net.WriteString(playername)
    net.Broadcast()
end)

concommand.Add("rg_stopsound", function(ply, cmd, args)
    if (ply.nextrgcommandtime or 0) > CurTime() then return end
    ply.nextrgcommandtime = CurTime() + 1
    if ply:IsValid() and not ply:IsAdmin() then return end
    if not args[1] then return end
    if string.find(args[1], " ") then return end
    local songstring = args[1]
    net.Start("stopsoundonclientviaconcommand")
        net.WriteString(songstring)
    net.Broadcast()
end)