CreateConVar("rg_gamenight", 0, {FCVAR_REPLICATED, FCVAR_NOTIFY}, "Dictates whether or not the server is in gamenight mode. In this mode, all jobs may be used, regardless of XP.", 0, 1)
CreateConVar("rg_noxp", 0, {FCVAR_REPLICATED, FCVAR_NOTIFY}, "Dictates whether or not users need xp to join a job", 0, 1)
CreateConVar("rg_hunger", 1, {FCVAR_REPLICATED, FCVAR_NOTIFY}, "Dictates whether or not users need xp to join a job", 0, 1)
CreateConVar("rg_jobcooldown", 1, {FCVAR_REPLICATED, FCVAR_NOTIFY}, "Dictates whether or not users need xp to join a job", 0, 1)
CreateConVar("rg_joblimit", 1, {FCVAR_REPLICATED, FCVAR_NOTIFY}, "Dictates whether or not users need xp to join a job", 0, 1)

local ammo = {}

ammo["pistol"] = {
    ammoamount = 36,
    model = "models/Items/BoxSRounds.mdl",
    classname = "Pistol",
}
ammo["smg"] = {
    ammoamount = 60,
    model = "models/Items/BoxMRounds.mdl",
    classname = "SMG1",
}
ammo["ar2"] = {
    ammoamount = 60,
    model = "models/Items/combine_rifle_cartridge01.mdl",
    classname = "AR2",
}
ammo["shotgun"] = {
    ammoamount = 12,
    model = "models/Items/BoxBuckshot.mdl",
    classname = "Buckshot",
}
ammo["magnum"] = {
    ammoamount = 18,
    model = "models/Items/357ammobox.mdl",
    classname = "357",
}
local weapon = {}

weapon["usp"] = {
    model = "models/weapons/w_pistol.mdl",
    classname = "fl_usp",
}
weapon["smg"] = {
    model = "models/weapons/w_smg1.mdl",
    classname = "fl_mp7",
}
weapon["colt"] = {
    model = "models/tnb/weapons/colt1911/w_1911.mdl",
    classname = "fl_colt",
}
weapon["akm"] = {
    model = "models/weapons/tfa_ins2/w_akm_bw.mdl",
    classname = "fl_ak",
}
weapon["ppsh"] = {
    model = "models/weapons/w_smg_ump45.mdl",
    classname = "fl_ppsh",
}
weapon["spas12"] = {
    model = "models/weapons/w_shotgun.mdl",
    classname = "fl_spas12",
}
weapon["magnum"] = {
    model = "models/weapons/w_357.mdl",
    classname = "fl_magnum",
}
weapon["mosin"] = {
    model = "models/apexwep/weapons/w_mosin.mdl",
    classname = "fl_mosin",
}
weapon["health"] = {
    model = "models/healthvial.mdl",
    classname = "weapon_healthvial",
}

concommand.Add("rg_makeammo", function(ply, cmd, args)
    if (not ply or (ply:IsValid() and ply:IsSuperAdmin())) and args[1] then
        if not ammo[args[1]] then return end
        local ammotype = ammo[args[1]]
        local ammo = ents.Create("spawned_ammo")
        ammo:SetModel(ammotype.model)
		ammo.ammoType = ammotype.classname
        ammo.amountGiven = ammotype.ammoamount
        ammo.ShareGravgun = true
        local trace = util.TraceLine({
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:EyeAngles():Forward() * 100,
        filter = ply
	    })
        ammo:SetPos(trace.HitPos)
        ammo.nodupe = true
        function ammo:StartTouch()

        end
        ammo:Spawn()
    end
end)
concommand.Add("rg_makeweapon", function(ply, cmd, args)
    if (not ply or (ply:IsValid() and ply:IsSuperAdmin())) and args[1] then
        if not weapon[args[1]] then return end
        local ammotype = weapon[args[1]]
        local ammo = ents.Create("spawned_weapon")
        ammo:SetModel(ammotype.model)
        ammo.ShareGravgun = true
        ammo:SetWeaponClass(ammotype.classname);
        local trace = util.TraceLine({
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:EyeAngles():Forward() * 100,
        filter = ply
	    })
        ammo:SetPos(trace.HitPos)
        ammo.nodupe = true
        ammo:Spawn()
    end
end)

local goodguys = {
    ["moderator"] = true,
    ["admin"] = true,
    ["senioradmin"] = true,
    ["superadmin"] = true,
    ["securitystaff"] = true,
    ["trial-moderator"] = true,
}

concommand.Add("rg_feed", function(ply, cmd, args)
    if ply:IsValid() and goodguys[ply:GetUserGroup()] and args[1] then
        for _, target in pairs(player.GetHumans()) do
            if args[1] == target:Name() then
                target:setSelfDarkRPVar("Energy", 100)
            end
        end
    end
end)

concommand.Add("rg_feed_all", function(ply, cmd, args)
    if ply:IsValid() and ply:IsSuperAdmin() then
        for _, target in pairs(player.GetHumans()) do
            target:setSelfDarkRPVar("Energy", 100)
        end
    end
end)

concommand.Add("rg_search", function(ply, cmd, args)
    if (ply.NextBreakFreeTime or 0) > CurTime() then return end
    ply.NextBreakFreeTime = CurTime() + 1
    if not ply:IsSuperAdmin() or not args[1] then return end
    local searchee = nil
    for _, target in pairs(player.GetHumans()) do
        if target:Name() == args[1] then
            searchee = target
        end
    end
    if not searchee then return end
    if searchee:GetWeapons() == {} then ply:sendMsg(Color(120, 120,0), "This player has no weapons!") return end
    ply:sendMsg(Color(0, 120,0), "This player has the following weapons:")
    for _, weapon in pairs(searchee:GetWeapons()) do
        ply:sendMsg(Color(255, 255,255), weapon:GetClass())
    end
end)

function ConsoleOOC(ply, cmd, args)
    if ply:IsValid() then return end
    if not args[1] then return end
    text = args[1]
    for _, v in pairs(player.GetHumans()) do
        v:sendMsg({font = "RobotoMono20"}, Color(200, 0, 0), "[OOC] ", Color(0,0,0), "Console: ", Color(255, 220, 220), text)
    end

end

concommand.Add("rg_consoleooc", ConsoleOOC)

if not file.Exists("suslist.txt", "DATA") then
    file.Write("suslist.txt", "[]")
end
if not file.Exists("strikelist.txt", "DATA") then
    file.Write("strikelist.txt", "[]")
end

concommand.Add("rg_addsus", function(ply, cmd, args)
    if not ply:IsValid() or (ply:IsPlayer() and ply:IsSuperAdmin()) then
        if not args[1] then return end
        local suspeepstable = util.JSONToTable(file.Read("suslist.txt", "DATA"))
        if suspeepstable[args[1]] == true then
            if ply:IsValid() then
                ply:ChatPrint("You can't add a person that is already in the list!")
            else
                print("You can't add a person that is already in the list!")
            end
            return
        end
        suspeepstable[args[1]] = true
        file.Write("suslist.txt", util.TableToJSON(suspeepstable))
        if ply:IsValid() then
            ply:ChatPrint("You have added " .. args[1] .. " to big brother's watchlist!")
        else
            print("You have added " .. args[1] .. " to big brother's watchlist!")
        end
    end
end)

concommand.Add("rg_removesus", function(ply, cmd, args)
    if not ply:IsValid() or (ply:IsPlayer() and ply:IsSuperAdmin()) then
        if not args[1] then return end
        local suspeepstable = util.JSONToTable(file.Read("suslist.txt", "DATA"))
        if suspeepstable[args[1]] ~= true then
            if ply:IsValid() then
                ply:ChatPrint("You can't remove a person that isn't already in the list!")
            else
                print("You can't remove a person that isn't already in the list!")
            end
            return
        end
        suspeepstable[args[1]] = false
        file.Write("suslist.txt", util.TableToJSON(suspeepstable))
        if ply:IsValid() then
            ply:ChatPrint("You have removed " .. args[1] .. " from big brother's watchlist!")
        else
            print("You have removed " .. args[1] .. " from big brother's watchlist!")
        end
    end
end)

concommand.Add("rg_removestrike", function(ply, cmd, args)
    if not ply:IsValid() or (ply:IsPlayer() and ply:IsSuperAdmin()) then
        if not args[1] then return end
        local striketable = util.JSONToTable(file.Read("strikelist.txt", "DATA"))
        if not striketable[args[1]] or striketable[args[1]] <= 0 then
            if ply:IsValid() then
                ply:ChatPrint("You cannot remove a strike from a person who doesn't have any!")
            else
                print("You cannot remove a strike from a person who doesn't have any!")
            end
            return
        end
        striketable[args[1]] = striketable[args[1]] - 1
        if ply:IsValid() then
            ply:ChatPrint("You have removed 1 strike from this person! He is now on " .. striketable[args[1]] .. " strike(s).")
        else
            print("You have removed 1 strike from this person! He is now on " .. striketable[args[1]] .. " strike(s).")
        end
    end
end)

hook.Add("ScalePlayerDamage", "AntiCheatHeadshotCounter", function(victim, hitgroup, dmg)
    if not victim:IsValid() or not victim:IsPlayer() then return end
    local attacker = dmg:GetAttacker()
    if attacker:IsValid() and attacker:IsPlayer() then
        local suspeepstable = util.JSONToTable(file.Read("suslist.txt", "DATA"))
        -- if suspeepstable[attacker:SteamID()] and suspeepstable[attacker:SteamID()] == true then
            if hitgroup == HITGROUP_HEAD and attacker:GetPos():DistToSqr(victim:GetPos()) >= 190*190 and ((victim:GetVelocity():Length2DSqr() > 100 * 100) or not attacker:OnGround()) then
                local weaponclass = attacker:GetActiveWeapon():GetClass()
                if ((weaponclass == "fl_magnum" or weaponclass == "fl_mosin") and attacker:GetNWInt("consecutiveheadshotcount", 0) >= 3 ) or (attacker:GetNWInt("consecutiveheadshotcount", 0) >= 7) then
                    local striketable = util.JSONToTable(file.Read("strikelist.txt", "DATA"))
                    for _, admins in pairs(player.GetHumans()) do
                        if admins:IsAdmin() then
                            admins:ChatPrint("[RZ-AC] WARNING: " .. attacker:Name() .. "(" .. attacker:SteamID() .. ") has hit the consecutive headshots in a row limit! 1 STRIKE added! He is currently on " .. (striketable[attacker:SteamID()] or 0) + 1 .. " strikes!")
                        end
                    end
                    if striketable[attacker:SteamID()] then
                        striketable[attacker:SteamID()] = striketable[attacker:SteamID()] + 1
                    else
                        striketable[attacker:SteamID()] = 1
                    end
                    attacker:SetNWInt("consecutiveheadshotcount", 0)
                    file.Write("strikelist.txt", util.TableToJSON(striketable))
                    if striketable[attacker:SteamID()] >= 2 then
                        local playername = attacker:GetName()
                        RunConsoleCommand("ulx", "banid", attacker:SteamID(), 60 * 24 * 365 * 10, "[RZ-AC]: Strike limit reached!")
                        ULib.addBan(attacker:SteamID(), 60 * 24 * 365 * 10, "[RZ-AC]: Strike limit reached!", playername , "Requiem.Zone Anticheat")
				        ULib.refreshBans()
                    end
                end
                attacker:SetNWInt("consecutiveheadshotcount", attacker:GetNWInt("consecutiveheadshotcount", 0) + 1)
                timer.Create("Headshotcounterreset" .. attacker:SteamID(), 6, 1, function()
                    attacker:SetNWInt("consecutiveheadshotcount", attacker:GetNWInt("consecutiveheadshotcount", 0) -1)
                end)
            elseif hitgroup ~= HITGROUP_HEAD then
                attacker:SetNWInt("consecutiveheadshotcount", 0)
            end
        -- end
    end
end)

resource.AddFile("sound/industrial17/rationsonline.mp3")
resource.AddFile("sound/industrial17/rationsoffline.mp3")
resource.AddFile("sound/cpsounds/returntoyourhousingblock.wav")

concommand.Add("rg_settax", function(ply, cmd, args)
    if (ply.nextrgcommandtime or 0) > CurTime() then return end
    ply.nextrgcommandtime = CurTime() + 1
    if ply:IsValid() and not ply:IsSuperAdmin() then return end
    if not args[1] then return end
    SetGlobalInt("tax", tonumber(args[1]))
end)

concommand.Add("rg_hide", function(ply, cmd, args)
    if (ply.nextrgcommandtime or 0) > CurTime() then return end
    ply.nextrgcommandtime = CurTime() + 1
    if not ply:IsValid() or not ply:IsSuperAdmin() or not args[1] then return end

    for _, target in pairs(player.GetHumans()) do
        if target:Name() == args[1] then
            if target:GetNWBool("IsHidden", false) then
                target:SetNWBool("IsHidden", false)
                ply:notify("You have made " .. target:Name() .. " visible!")
            return
            else
                target:SetNWBool("IsHidden", true)
                ply:notify("You have made " .. target:Name() .. " hidden!")
            return
            end
        end
    end
end)

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

concommand.Add("rg_adduumoney", function(ply, cmd, args)
    if ply:IsValid() and ply:IsPlayer() and ply:IsSuperAdmin() and args[1] then
        SetGlobalInt("UUMoney", GetGlobalInt("UUMoney",0) + args[1])
        ply:notify("You added " .. args[1] .. " tokens to the UU's Tax money!")
    end
end)

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

concommand.Add("rg_breakmefree", function(ply, cmd, args)
    if (ply.NextBreakFreeTime or 0) > CurTime() then return end
    ply.NextBreakFreeTime = CurTime() + 1
    if not ply:IsSuperAdmin() then return end
    ply:StripWeapon("weapon_handcuffed")
end);

concommand.Add("rg_search", function(ply, cmd, args)
    if (ply.NextBreakFreeTime or 0) > CurTime() then return end
    ply.NextBreakFreeTime = CurTime() + 1
    if not ply:IsSuperAdmin() or not args[1] then return end
    local searchee = nil
    for _, target in pairs(player.GetHumans()) do
        if target:Name() == args[1] then
            searchee = target
        end
    end
    if not searchee then return end
    if searchee:GetWeapons() == {} then ply:sendMsg(Color(120, 120,0), "This player has no weapons!") return end
    ply:sendMsg(Color(0, 120,0), "This player has the following weapons:")
    for _, weapon in pairs(searchee:GetWeapons()) do
        ply:sendMsg(Color(255, 255,255), weapon:GetClass())
    end
end)

local function ConsoleOOC(ply, cmd, args)
    if ply:IsValid() then return end
    if not args[1] then return end
    text = args[1]
    for _, v in pairs(player.GetHumans()) do
        v:sendMsg({font = "RobotoMono20"}, Color(200, 0, 0), "[OOC] ", Color(0,0,0), "Console: ", Color(255, 220, 220), text)
    end
end

concommand.Add("rg_consoleooc", ConsoleOOC)

concommand.Add("getspawnpos", function(ply)
    if (ply.nextspawnposcommandtime or 0) > CurTime() then return end
    ply.nextspawnposcommandtime = CurTime() + 1
    if not ply:IsAdmin() then return end

    local position = ply:GetPos()

    ply:ChatPrint("Vector(" .. position.x .. ", " .. position.y .. ", " .. position.z .. ")")
end)

concommand.Add("getspawnposangles", function(ply)
    if (ply.nextspawnposcommandtime or 0) > CurTime() then return end
    ply.nextspawnposcommandtime = CurTime() + 1
    if not ply:IsAdmin() then return end

    local position = ply:GetPos()
    local angle = ply:GetAngles()

    ply:ChatPrint("Vector(" .. position.x .. ", " .. position.y .. ", " .. position.z .. "), " .. "Angle(" .. angle.x .. ", " .. angle.y .. ", " .. angle.z .. ")")
    -- ply:ChatPrint()
end)

-- ULX COMMANDS
hook.Add("InitPostEntity", "RequiemULXCommands", function()
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
        if not string.find(steamid, "STEAM") then
            ULib.tsayError(calling_ply, "This is not a valid SteamID!", true)
            return
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
        
        if not string.find(steamid, "STEAM") then
            ULib.tsayError(calling_ply, "This is not a valid SteamID!", true)
            return
        end

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