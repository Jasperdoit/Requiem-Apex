resource.AddFile( "materials/waypointmarker/wpmarker.vmt" )
resource.AddFile( "materials/waypointmarker/wpmarker.vtf" )
resource.AddSingleFile( "wpmarker.vmt");
resource.AddSingleFile("wpmarket.vtf");
util.AddNetworkString("waypointmarker")
util.AddNetworkString("distressmarker")
util.AddNetworkString("deathmarker")
util.AddNetworkString("requestmarker")
util.AddNetworkString("clearmarkers")


local function ClearWaypoint(ply, args)
	net.Start("clearmarkers")
	net.Send(ply)
	ply:notify("Waypoints cleared!")
	return ""
end

DarkRP.defineChatCommand("clearwaypoint", ClearWaypoint, 1.5);
DarkRP.defineChatCommand("clearwp", ClearWaypoint, 1.5);
DarkRP.declareChatCommand{
    command = "clearwaypoint",
    description = "Clears Waypoint",
    delay = 1.5
};
DarkRP.declareChatCommand{
    command = "clearwp",
    description = "Clear Waypoint",
    delay = 1.5
};

local function CreateWaypoint(ply,args)
	if not ply:IsCP() then return "" end
			local trace = ply:GetEyeTraceNoCursor()
			if (!trace.Hit) then return "" end
	-- print(args)
			local strings = {name = ply:Name(), msg = args or false, steamid = ply:SteamID()}
			local transmitstring = util.TableToJSON(strings)
			net.Start("waypointmarker")
				net.WriteVector(trace.HitPos)
				net.WriteString(transmitstring)
			net.Broadcast()
	ply:notify("Waypoint generated.")
	return ""
end

DarkRP.defineChatCommand("waypoint", CreateWaypoint, 1.5);
DarkRP.declareChatCommand{
    command = "waypoint",
    description = "Add a waypoint",
    delay = 1.5
};

local function CreateRequest(ply,args)
	if ply:IsCP() or ply:isArrested() or ply:Team() == TEAM_VORTIGAUNT then return "" end

			local strings = {name = ply:Name(), msg = args or false, steamid = ply:SteamID()}
			local transmitstring = util.TableToJSON(strings)
			net.Start("requestmarker")
				net.WriteVector(ply:GetPos())
				net.WriteString(transmitstring)
			net.Broadcast()
	ply:notify("Request sent.")
	return ""
end

DarkRP.defineChatCommand("request", CreateRequest, 1.5);
DarkRP.declareChatCommand{
    command = "request",
    description = "Request help from UU people",
    delay = 1.5
};


local function CreateDistressCall(ply, args)
	if ply:Team() ~= TEAM_CP and ply:Team() != TEAM_OVERWATCH and ply:Team() != TEAM_CONSCRIPT then return "" end
	net.Start("distressmarker")
		net.WriteVector(ply:GetPos())
		local strings = {name = ply:Name(), msg = "", steamid = ply:SteamID()}
		local transmitstring = util.TableToJSON(strings)
		net.WriteString(transmitstring)

	net.Broadcast()
	ply:notify("Distress Call generated!")
	
	return ""
end

DarkRP.defineChatCommand("distress",CreateDistressCall, 1.5);
DarkRP.defineChatCommand("11-99",CreateDistressCall, 1.5);
DarkRP.defineChatCommand("needhelp",CreateDistressCall, 1.5);
DarkRP.declareChatCommand{
    command = "distress",
    description = "Request backup!",
    delay = 1.5
};
DarkRP.declareChatCommand{
    command = "11-99",
    description = "Request backup!",
    delay = 1.5
};
DarkRP.declareChatCommand{
    command = "needhelp",
    description = "Request backup!",
    delay = 1.5
};

local function biosignalLoss(ply)
	if ((ply:isCombine() and not ply:GetNWBool("noBiosignal")) or ply:Team() == TEAM_ADMINISTRATOR) then 
		local pos = ply:GetPos();
		local strings = {
            name = ply:Name(),
			steamid = ply:SteamID()
        };
			
		net.Start("deathmarker");
			net.WriteVector(pos)
			net.WriteString(util.TableToJSON(strings));
		net.Broadcast();
	end 
end

hook.Add("DoPlayerDeath", "biosignal loss", biosignalLoss);
