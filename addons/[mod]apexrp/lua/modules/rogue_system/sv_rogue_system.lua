util.AddNetworkString("OpenRogueMenu")
util.AddNetworkString("MarkRogue")
util.AddNetworkString("CancelRogue")
util.AddNetworkString("DenyRogue")

RogueMenu.RogueRequestCooldown = RogueMenu.RogueRequestCooldown or {}

net.Receive("CancelRogue", function(len, caller)
    if not caller:IsAdmin() then return end
    local ply = net.ReadEntity()
    if not ply:IsValid() or not ply:IsPlayer() or not ply:Alive() then return end
    if ply:GetNWBool("IsRogue", false) then
        ply:SetNWBool("IsRogue", false)
        caller:notify("You have cancelled " .. ply:Name() .. " rogue perms!")
        ply:notify("Your Rogue permissions have been revoked! You are NO LONGER ROGUE!")
        RoguenotifyStaff(ply:Name() .. "'s Rogue perms have been revoked!")
    else
        caller:notify("This player wasn't rogue to begin with!")
        return
    end
end)

net.Receive("DenyRogue", function(len, caller)
    if not caller:IsAdmin() then return end
    local ply = net.ReadEntity()
    if not ply:IsValid() or not ply:IsPlayer() or not ply:Alive() then return end
    if ply:GetNWBool("SentRogueRequest", false) then
        ply:SetNWBool("SentRogueRequest", false)
        caller:notify("You have denied " .. ply:Name() .. " rogue perms!")
        ply:notify("Your Rogue request has been denied!")
        RoguenotifyStaff(ply:Name() .. "'s Rogue request has been denied!")
        RogueMenu.RogueRequestCooldown[ply:SteamID()] = CurTime() + 300

    else
        caller:notify("This player didn't have a roguerequest to begin with!")
    end
end)

net.Receive("MarkRogue", function(len, caller)
    if not caller:IsAdmin() then return end
    local ply = net.ReadEntity()
    if not ply:IsValid() or not ply:IsPlayer() or not ply:Alive() then return end
    if not ply:Team() == TEAM_CP or not ply:Team() == TEAM_CWU or ply:GetNWBool("IsRogue", false) then return end
    ply:SetNWBool("IsRogue", true)
    ply:SetNWBool("SentRogueRequest", false)
    caller:notify("You have given " .. ply:Name() .. " rogue perms!")
    ply:notify("Your Rogue request has been accepted! You are now ROGUE!")
    RoguenotifyStaff(ply:Name() .. " Has been made a Rogue!")
    RogueMenu.RogueRequestCooldown[ply:SteamID()] = CurTime() + 600
end)

function RoguenotifyStaff(text)
    for _, admins in pairs(player.GetHumans()) do
        if admins:IsValid() and admins:IsAdmin() then
            admins:ChatPrint("[ROGUESYSTEM]: " .. text)
        end
    end
end

local function IsRogueDivision(ply)
    for _, divisions in pairs(RogueMenu.Divisions) do
        if string.find(string.lower(ply:Name()), divisions) then
            return true
        end
    end
    return false
end

local function IsRightRank(ply)
    if ply:getDivisionRankData() == 0 then return false end
    return ply:getDivisionRankData().cangorogue
end

local function requestRogue(ply, args)
    if not (ply:IsValid() and ply:IsPlayer() and ply:Alive()) then
        ply:notify("This is not a valid player.")
        return ""
    end

    if not (ply:Team() == TEAM_CP or ply:Team() == TEAM_CWU) then
        ply:notify("You may not make a rogue request at this time.")
        return ""
    end

    if ply:Team() == TEAM_CP and not IsRightRank(ply) then
        ply:notify("You can't go rogue as this rank!")
        return ""
    end

    if ply:GetNWBool("IsRogue", false) then
        ply:notify("You have already gone rogue!")
        return ""
    end

    if ply:GetNWBool("SentRogueRequest", false) then
        ply:notify("You have already requested going rogue!")
        return ""
    end

    local team = ply:Team()
    local roguerequestcount = 0
    local roguecount = 0
    for _, player in pairs(player.GetHumans()) do
        if player:GetNWBool("SentRogueRequest", false) and player:Team() == team then
            roguerequestcount = roguerequestcount + 1
        end
        if player:GetNWBool("IsRogue", false) and player:Team() == team then
            roguecount = roguecount + 1
        end
    end
    local roguesum = roguecount + roguerequestcount
    if roguesum >= 2 then
        ply:notify("There are too many Rogue Requests at this time! Please try again later.")
        return ""
    end

    if RogueMenu.RogueRequestCooldown[ply:SteamID()] and RogueMenu.RogueRequestCooldown[ply:SteamID()] > CurTime() then
        ply:notify(string.format("You must wait another %d seconds before making a rogue request!", math.Round(RogueMenu.RogueRequestCooldown[ply:SteamID()] - CurTime())))
        return ""
    end

    ply:SetNWBool("SentRogueRequest", true)
    ply:notify("You have been added to the rogue queue!")
    RoguenotifyStaff(string.format("%s has made a rogue request!", ply:Name()))
    return ""
end

DarkRP.defineChatCommand("requestrogue", requestRogue, 1.5);

local function cancelRogue(ply, args)
	local text = args;
	if not ply:IsValid() and ply:IsPlayer() and ply:Alive() then return end
	if ply:GetNWBool("IsRogue", false) then
		ply:notify("You have already gone rogue!")
		return ""
	end
	if not ply:GetNWBool("SentRogueRequest", false) then
		ply:notify("You haven't sent a rogue request!")
		return ""
	else
		ply:SetNWBool("SentRogueRequest", false)
		ply:notify("You are no longer on the rogue queue!")
		RoguenotifyStaff(ply:Name() .. " has cancelled their rogue request!")
		return ""
	end
end

DarkRP.defineChatCommand("cancelroguerequest", cancelRogue, 1.5);

local function cancelRoguePerms(ply, args)
	if not ply:IsValid() and ply:IsPlayer() and ply:Alive() then return end
	if ply:GetNWBool("IsRogue", false) then
		ply:SetNWBool("IsRogue", false)
		ply:notify("You are no longer rogue!")
		return ""
	else
		ply:notify("You weren't rogue to begin with!")
		return ""
	end
end 

DarkRP.defineChatCommand("cancelrogueperms", cancelRoguePerms, 1.5);

hook.Add("PlayerSpawn", "ResetRoguestatus", function(ply)
    ply:SetNWBool("IsRogue", false)
    ply:SetNWBool("SentRogueRequest", false)
end)

concommand.Add("rg_roguemenu_mark", function(ply, cmd, args)
    if not args or not args[1] or not ply:IsAdmin() then return end
    for _, target in pairs(player.GetHumans()) do
        if args[1] == target:Name() then
            target:SetNWBool("IsRogue", true)
            target:SetNWBool("SentRogueRequest", false)
            ply:notify("You have given " .. target:Name() .. " rogue perms!")
            target:notify("Your Rogue request has been accepted! You are now ROGUE!")
            RoguenotifyStaff(target:Name() .. " Has been made a Rogue!")
            RogueMenu.RogueRequestCooldown[target:SteamID()] = CurTime() + 600
            return
        end
    end
end)

concommand.Add("rg_roguemenu_revoke", function(ply, cmd, args)
    if not args or not args[1] or not ply:IsAdmin() then return end
    for _, target in pairs(player.GetHumans()) do
        if args[1] == target:Name() then
            target:SetNWBool("IsRogue", false)
            target:SetNWBool("SentRogueRequest", false)
            ply:notify("You have revoked " .. target:Name() .. "'s rogue perms!")
            target:notify("Your Rogue permissions have been revoked! You are NO LONGER ROGUE!")
            return
        end
    end
end)

concommand.Add("rg_roguemenu", function(ply)
    if not ply:IsAdmin() then return end
    net.Start("OpenRogueMenu")
    net.Send(ply)
end)