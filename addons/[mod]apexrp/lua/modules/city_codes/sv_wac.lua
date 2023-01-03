util.AddNetworkString("fcode")

local CITY_CODE = 2
local CITY_TIME = CurTime()

function FCodeChange(str, ply)
    if not CODE_LIST[str] then return end
    if CODE_LIST[str] == CODE_LIST[CITY_CODE] then return end

    if ply then
        if ((CODE_LIST[str].admin or CODE_LIST[CITY_CODE].admin)) and not ply:IsAdmin() then
            ply:notify("You cannot change the city code that is set to an admin code")
            return
        elseif not ((ply:Team() == TEAM_ADMINISTRATOR and string.find(ply:getDarkRPVar("job"), "Defense")) or ply:IsAdmin() or ply:Team() == TEAM_DISPATCH or (divisions and ply:getDivision() == DIVISION_SECTORIAL)) then
            ply:notify("You are not permitted to change city codes!")
            return
        end
    end

    if isfunction(CODE_LIST[str].onActivated) then
        CODE_LIST[str].onActivated(CODE_LIST[CITY_CODE], tonumber(str))
    end
    
    if isfunction(CODE_LIST[CITY_CODE].onDisabled) then
        CODE_LIST[CITY_CODE].onDisabled(CODE_LIST[CITY_CODE], tonumber(str))
    end

    if CODE_LIST[CITY_CODE].onHooks then
        for k, v in pairs(CODE_LIST[CITY_CODE].onHooks) do
            hook.Remove(k, "cityCodeHook")
        end
    end

    if CODE_LIST[str].onHooks then
        local code = CODE_LIST[str]
        for k, v in pairs(CODE_LIST[str].onHooks) do
            hook.Add(k, "cityCodeHook", function(...)
                v(code, ...)
            end)
        end
    end

    CITY_TIME = CurTime()
	SetGlobalInt("codetime", CurTime())
    SetGlobalInt("code", tonumber(str))
    CITY_CODE = tonumber(str)

    if CODE_LIST[str].timer && isfunction(CODE_LIST[str].onTimerEnd) then
        timer.Create("CityCodeThing", CODE_LIST[str].timer, 1, CODE_LIST[str].onTimerEnd)
    else
        timer.Remove("CityCodeThing")
    end
end

function ZCodeChange(str, code, ply)
    if not CITY_ZONES[str] or not CODE_ZONES[code] then return end
    if CITY_ZONES[str].code == code then return end

    if ply then
        CITY_ZONES[str].code = GetGlobalString("code_"..str, "func")

        if (CODE_ZONES[code].admin or CODE_ZONES[CITY_ZONES[str].code].admin or CITY_ZONES[str].admin ) and !ply:IsAdmin() then
            ply:notify("You cannot change the zone code that is set to an admin code")
            return
        elseif not ((ply:Team() == TEAM_ADMINISTRATOR and string.find(ply:getDarkRPVar("job"), "Defense")) or ply:IsAdmin() or ply:Team() == TEAM_DISPATCH or (divisions and ply:getDivision() == DIVISION_SECTORIAL)) then
            ply:notify("You are not permitted to change city codes!")
            return
        end

        if CITY_ZONES[str].blacklisted[code] then
            if not CODE_ZONES[CITY_ZONES[str].code].whitelist and not CITY_ZONES[str].isWhitelist then
                ply:notify("This code is blacklisted for this sector!")
                ply:ChatPrint("This code is blacklisted for this sector!")
                return
            end
        elseif CODE_ZONES[CITY_ZONES[str].code].whitelist or CITY_ZONES[str].isWhitelist then
            ply:notify("This sector has not whitelisted this code!")
            ply:ChatPrint("This code is blacklisted for this sector!")
            return
        end
    end

    SetGlobalString("code_"..str, code)
    CITY_ZONES[str].code = tonumber(code)
end

concommand.Add("fcode", function(ply, cmd, args, argStr)
    if 
        -- not WHITELISTED_TEAMS[ply:Team()] && 
        -- not ply:IsAdmin() 
        not (
            ply:Team() == TEAM_ADMINISTRATOR ||
            string.find(ply:getDarkRPVar("job"), "Defense") || 
            !ply:GetNWBool("restricted", false) ||
            ply:Team() == TEAM_DISPATCH
        ) 
        then
            ply:notify("You are not allowed to use this!")
            return
    end
        for k,v in pairs(player.GetAll()) do
            if v:IsAdmin() then
                v:ChatPrint("FCODE changed by: " .. ply:Name())
            end
        end
    if args[1] then
        FCodeChange(tonumber(args[1]) or args[1], ply)
    end

end)

concommand.Add("fcode_zone", function(ply, cmd, args, argStr)

    if 
        -- (WHITELISTED_TEAMS[ply:Team()] || ply:IsAdmin()) ||
        ply:IsAdmin() || ply:Team() == TEAM_DISPATCH || (ply:Team() == TEAM_CP and CPMenuPlyTable[ply:SteamID64()] and CPMenuPlyTable[ply:SteamID64()]["Division"] == 7) || (ply:Team() == TEAM_ADMINISTRATOR && string.find(ply:getDarkRPVar("job"), "Defense") && !ply:GetNWBool("restricted", false)) 
    then

        if args[1] && args[2] then
            ZCodeChange(
                args[1],
                tonumber(args[2]) or args[2],
                ply
            )
        end
    else
        -- ply:notify("Due to recent meanies, this command has been disabled for CA's.")
    end

end)

concommand.Add("desc_add", function(ply, cmd, args, argStr)
    if !IsValid(ply) then return end

    local trace = ply:GetEyeTrace()
    if trace.Entity:IsPlayer() || trace.Entity:IsWorld() || !ply:IsAdmin() then return end
    
    local desc = table.concat(args, " ")

    trace.Entity:SetNWString("description", desc)

    return true
end)

concommand.Add("desc_remove", function(ply, cmd, args, argStr)
    if !IsValid(ply) then return end

    local trace = ply:GetEyeTrace()
    if trace.Entity:IsPlayer() || trace.Entity:IsWorld() || !ply:IsAdmin() then return end

    trace.Entity:SetNWString("description", "")

    return true
end)