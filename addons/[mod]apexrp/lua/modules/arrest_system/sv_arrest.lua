-- Setup of Namespace
rg_arrest_system = rg_arrest_system or {}
rg_arrest_system.PlayerJailTime = rg_arrest_system.PlayerJailTime or {}
-- Net message init
util.AddNetworkString("GiveClientJailTime")

-- Meta Methods
local meta = FindMetaTable("Entity")

function meta:ArrestPlayer(time, reason)
    local map = game.GetMap()
    if not (mapconfigs and mapconfigs[map] and mapconfigs[map].JailPositions and mapconfigs[map].JailExit) then
        self:notify("WARNING: THIS MAP HAS NOT BEEN SET UP PROPERLY. PLEASE INFORM SUPERADMINS ASAP.")
        return
    end

    if not (self:IsValid() and self:IsPlayer()) or time > 10 or time <= 0 then return end
    local arresttime = time * 60
    local textreason = reason or "None given"

    rg_arrest_system.PlayerJailTime[self:SteamID64()] = CurTime() + arresttime
    self:SetNWInt("JailTimeRemaining", CurTime() + arresttime)
    self:SetNWString("arrestreason", textreason)
    self:SetPos(table.Random(mapconfigs[map].JailPositions))
    self:notify("You have been arrested for " .. time .. " cycle(s)!")
    self:StripWeapons()

    net.Start("GiveClientJailTime")
    net.WriteInt(rg_arrest_system.PlayerJailTime[self:SteamID64()], 32)
    net.Send(self)
end

-- Jailtime check
timer.Create("jailCheckHandler", 1, 0, function()
    for _, ply in pairs(player.GetAll()) do
        if not ply:IsPlayer() or not rg_arrest_system.PlayerJailTime[ply:SteamID64()] or rg_arrest_system.PlayerJailTime[ply:SteamID64()] == 0 then continue end
        if (ply:GetActiveWeapon() ~= NULL) then
            ply:StripWeapons()
        end

        if CurTime() > rg_arrest_system.PlayerJailTime[ply:SteamID64()] then
            rg_arrest_system.PlayerJailTime[ply:SteamID64()] = 0
            ply:Spawn()
            ply:notify("Your sentence has ended, you have been released!")
            ply:SetNWInt("JailTimeRemaining", 0)
            ply:SetPos(GAMEMODE.Config.JailExit)
            net.Start("GiveClientJailTime")
            net.WriteInt(rg_arrest_system.PlayerJailTime[ply:SteamID64()], 32)
            net.Send(ply)
        end
    end
end)
-- Hooks
hook.Add("PlayerSpawn", "Keepinjailevenifdie!", function(ply)
    if not ply:IsValid() or not ply:IsPlayer() or not rg_arrest_system.PlayerJailTime[ply:SteamID64()] then return end
    if rg_arrest_system.PlayerJailTime[ply:SteamID64()] ~= 0 and CurTime() <= rg_arrest_system.PlayerJailTime[ply:SteamID64()] then
        -- ply:Spawn() (For all that is holy DO NOT USE THIS)
        timer.Simple(0.1, function()
            ply:SetPos(table.Random(mapconfigs[game.GetMap()].JailPositions))
            ply:StripWeapons()
        end)
    end
end)

hook.Add("PlayerInitialSpawn", "Punishpeepsforavoidingjailtime!", function(ply)
    if not ply:IsValid() or not ply:IsPlayer() then return end
    if rg_arrest_system.PlayerJailTime[ply:SteamID64()] and rg_arrest_system.PlayerJailTime[ply:SteamID64()] ~= 0 then
        timer.Simple(5, function()
            ply:ArrestPlayer(10, "Trying to evade his jail sentence!")
            ply:ChatPrint("You have been arrested for 10 cycles for avoiding jail time, for shame!")
            ply:ConCommand("play music/stingers/hl1_stinger_song8.mp3")
        end)
    end
end)
-- Con commands
concommand.Add("rg_jail", function(ply, cmd, args)
    if not ply:IsValid() or not ply:IsPlayer() or not ply:IsAdmin() or not args[1] or not args[2] then return end

    if tonumber(args[2]) == nil then
        ply:notify("That isn't a number, dummy!")
        return
    end

    local reason = "None Given"

    if args[3] then
        reason = args[3]
    end

    local jailtime = tonumber(args[2])

    if jailtime <= 0 or jailtime > 10 then
        ply:notify("You cannot jail a player for that amount of time!")

        return
    end

    for _, target in pairs(player.GetAll()) do
        if target:IsPlayer() and args[1] == target:Name() then
            if rg_arrest_system.PlayerJailTime[ply:SteamID64()] and rg_arrest_system.PlayerJailTime[ply:SteamID64()] ~= 0 then
                ply:notify("You cannot jail a person that is already in jail!")
                return
            end

            target:ArrestPlayer(jailtime, reason)
            ply:notify("You have jailed " .. target:Name() .. " for " .. jailtime .. " cycle(s)!")
            target:notify("You have been jailed by staff!")
            return
        end
    end

    ply:notify("ERROR: Player either not found, or is immune!")
end)

concommand.Add("rg_unjail", function(ply, cmd, args)
    if not ply:IsValid() or not ply:IsPlayer() or not ply:IsAdmin() or not args[1] then return end
    for _, target in pairs(player.GetAll()) do
        if target:IsPlayer() and args[1] == target:Name() then
            if rg_arrest_system.PlayerJailTime[ply:SteamID64()] and rg_arrest_system.PlayerJailTime[ply:SteamID64()] == 0 then
                ply:notify("This person isn't in jail!")
                return
            end

            rg_arrest_system.PlayerJailTime[target:SteamID64()] = 0
            target:SetNWInt("JailTimeRemaining", 0)

            timer.Simple(0.1, function()
                target:Spawn()
            end)

            ply:notify("You have unjailed " .. target:Name() .. "!")
            target:notify("You have been unjailed by staff!")
            net.Start("GiveClientJailTime")
            net.WriteInt(rg_arrest_system.PlayerJailTime[target:SteamID64()], 32)
            net.Send(target)
            return
        end
    end

    ply:notify("ERROR: Player either not found")
end)

-- Functions
local function release(ply)
    if not (ply:IsValid() and ply:IsPlayer()) then return end
    local trace = ply:GetEyeTrace()
    local target = trace.Entity

    if not (target:IsValid() and target:IsPlayer() and ply:GetPos():DistToSqr(target:GetPos()) < 100 * 100) then
        ply:notify("You aren't looking at a valid player or you are not close enough!")
        return
    end

    if not rg_arrest_system.PlayerJailTime[target:SteamID64()] or rg_arrest_system.PlayerJailTime[target:SteamID64()] == 0 then
        ply:notify("This person is currently not jailed!")
        return
    end

    if (ply:Team() == TEAM_CP and (ply:getDivision() == DIVISION_JURY or ply:getDivision() == DIVISION_SECTORIAL or ply:getDivision() == DIVISION_OCMD)) or ply:Team() == TEAM_DISPATCH then
        ply:notify("You have released " .. target:Name() .. "!")
        rg_arrest_system.PlayerJailTime[target:SteamID64()] = 0
        target:SetNWInt("JailTimeRemaining", 0)

        timer.Simple(0.1, function()
            target:Spawn()
            target:SetPos(mapconfigs[game.GetMap()].JailExit)
        end)

        target:notify("You have been released early!")
        net.Start("GiveClientJailTime")
        net.WriteInt(rg_arrest_system.PlayerJailTime[target:SteamID64()], 32)
        net.Send(target)
    elseif (ply:Team() == TEAM_CITIZEN and ply:GetNWBool("IsRebelScum", false)) or ply:GetNWBool("isRogue") then
        local oldpos = target:GetPos()
        rg_arrest_system.PlayerJailTime[target:SteamID64()] = 0
        target:SetNWInt("JailTimeRemaining", 0)
        target:Spawn()
        target:SetPos(oldpos)
        target:notify("Your ties have been cut loose, you are now escaping!")
        net.Start("GiveClientJailTime")
        net.WriteInt(rg_arrest_system.PlayerJailTime[target:SteamID64()], 32)
        net.Send(target)
        ply:notify("You have uncut the ties of this player and may now escape!")
    else
        ply:notify("You are not the right job to release prisoners!")
    end

    return ""
end


-- Chat command
DarkRP.defineChatCommand("release", release, 1.5);
DarkRP.declareChatCommand{
    command = "release",
    description = "Releases the player you are looking at.",
    delay = 1.5
};