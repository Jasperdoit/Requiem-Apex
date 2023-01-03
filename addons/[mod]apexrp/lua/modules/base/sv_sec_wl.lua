hook.Add("InitPostEntity", "fuckingulxcommands", function()
    function ulx.addsecwhitelist(calling_ply, target_ply)
        if not SERVER then return end

        if target_ply:IsListenServerHost() or target_ply:IsBot() then
            ULib.tsayError( calling_ply, "This player is immune to whitelisting!", true )
            return
        end

        if not file.Exists("whitelist.txt", "DATA") then
            file.Write("whitelist.txt", "[]")
        end

        local whitelisttable = util.JSONToTable(file.Read("whitelist.txt", "DATA"))

        if whitelisttable[target_ply:SteamID()] and whitelisttable[target_ply:SteamID()] == true then
            ULib.tsayError( calling_ply, "You cannot whitelist this person, as he is already on the whitelist!", true )

            return
        else
            whitelisttable[target_ply:SteamID()] = true
            file.Write("whitelist.txt", util.TableToJSON(whitelisttable))
            ulx.fancyLogAdmin( calling_ply, "#A added #T to the sectorial whitelist!", target_ply )
        end
    end

    local addsecwhitelist = ulx.command("Utility", "ulx addsec", ulx.addsecwhitelist, "!addsec");
    addsecwhitelist:addParam{type = ULib.cmds.PlayerArg};

    function ulx.addsecidwhitelisting(calling_ply, steamid)
        if not SERVER then return end

        if not file.Exists("whitelist.txt", "DATA") then
            file.Write("whitelist.txt", "[]")
        end

        local whitelisttable = util.JSONToTable(file.Read("whitelist.txt", "DATA"))

        if whitelisttable[steamid] and whitelisttable[steamid] == true then
            ULib.tsayError( calling_ply, "You cannot whitelist this person, as he is already on the whitelist!", true )

            return
        else
            whitelisttable[steamid] = true
            file.Write("whitelist.txt", util.TableToJSON(whitelisttable))
            ulx.fancyLogAdmin( calling_ply, "#A added #s to the sectorial whitelist!", steamid )
        end
    end

    local addsecidwhitelisting = ulx.command("Utility", "ulx addsecid", ulx.addsecidwhitelisting, "!addsecid");
    addsecidwhitelisting:addParam{type=ULib.cmds.StringArg, hint="steamid"};

    function ulx.removesecidwhitelisting(calling_ply, steamid)
        if not SERVER then return end

        if not file.Exists("whitelist.txt", "DATA") then
            file.Write("whitelist.txt", "[]")
        end

        local whitelisttable = util.JSONToTable(file.Read("whitelist.txt", "DATA"))

        if not whitelisttable[steamid] or whitelisttable[steamid] == false then
            ULib.tsayError( calling_ply, "You cannot whitelist this person, as he isn't whitelisted to begin with!", true )

            return
        else
            whitelisttable[steamid] = false
            file.Write("whitelist.txt", util.TableToJSON(whitelisttable))
            ulx.fancyLogAdmin( calling_ply, "#A removed #s from the sectorial whitelist!", steamid )
        end
    end

    local removesecidwhitelisting = ulx.command("Utility", "ulx removesecid", ulx.removesecidwhitelisting, "!removesecid");
    removesecidwhitelisting:addParam{type=ULib.cmds.StringArg, hint="steamid"};

    function ulx.removesecwhitelist(calling_ply, target_ply)
        if not SERVER then return end

        if target_ply:IsListenServerHost() or target_ply:IsBot() then
            ULib.tsayError( calling_ply, "This player is immune to banning", true )
            return
        end

        if not file.Exists("whitelist.txt", "DATA") then
            file.Write("whitelist.txt", "[]")
        end

        local whitelisttable = util.JSONToTable(file.Read("whitelist.txt", "DATA"))

        if not whitelisttable[target_ply:SteamID()] or whitelisttable[target_ply:SteamID()] == false then
            ULib.tsayError( calling_ply, "You cannot whitelist this person, as he isn't whitelisted to begin with!", true )

            return
        else
            whitelisttable[target_ply:SteamID()] = false
            file.Write("whitelist.txt", util.TableToJSON(whitelisttable))
            ulx.fancyLogAdmin( calling_ply, "#A removed #T from the sectorial whitelist!", target_ply )
        end
    end

    local removesecwhitelist = ulx.command("Utility", "ulx removesec", ulx.removesecwhitelist, "!removesec");
    removesecwhitelist:addParam{type = ULib.cmds.PlayerArg};
end)