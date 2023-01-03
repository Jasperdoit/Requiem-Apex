util.AddNetworkString("AddSpyHalo")
util.AddNetworkString("RemoveSpyHalo")
util.AddNetworkString("RemoveAllSpyHalo")

concommand.Add("rg_addspy", function(ply, cmd, args)
    if ply:IsValid() and ply:IsAdmin() and args[1] then
        for _, target in pairs(player.GetHumans()) do
            if args[1] == target:Name() and target:Team() == TEAM_CITIZEN then
                target:SetNWBool("IsSpy", true)
            end
        end
    end
end)
concommand.Add("rg_removespy", function(ply, cmd, args)
    if ply:IsValid() and ply:IsAdmin() and args[1] then
        for _, target in pairs(player.GetHumans()) do
            if args[1] == target:Name() then
                target:SetNWBool("IsSpy", false)
                net.Start("RemoveSpyHalo")
                net.WriteEntity(target)
                net.Send(target)
                for _, cp in pairs(player.GetHumans()) do
                    if cp:IsValid() and cp:Alive() and (cp:Team() == TEAM_CP or cp:Team() == TEAM_OVERWATCH or cp:GetNWBool("IsSpy", false)) then
                        net.Start("RemoveSpyHalo")
                        net.WriteEntity(target)
                        net.Send(cp)
                    end
                end
            end
        end
    end
end)

hook.Add("PlayerSpawn", "Getridofallhalos", function(ply)
    if ply:IsValid() then
        net.Start("RemoveAllSpyHalo")
        net.Send(ply)
    end
end)

local function showBadge(ply, args)
	local target = ply:GetEyeTrace().Entity
	
	if not target:IsValid() or not target:IsPlayer() or not (ply:GetPos():DistToSqr(target:GetPos())  <= 350*350) or not ((target:isCombine()) and (target:Team() ~= TEAM_ADMINISTRATOR)) then ply:notify("You must be looking at a CP or OTA unit!") return "" end
	if ply:GetNWBool("IsSpy", false) then
		ply:ChatPrint("You reach into your pocket and subtly show a badge!")
		target:ChatPrint(ply:Nick() .. " subtly waves a badge at you. " .. ply:Nick() .. " is an informant! Try to not blow his cover! Keep in contact with him to keep tabs on information about rebels.")
		net.Start("AddSpyHalo")
		net.WriteEntity(ply)
		net.Send(target)
	else
		ply:ChatPrint("You reach into your pocket and try to show a badge, but your pocket doesn't have one!")
	end
	
	return ""
end 

DarkRP.defineChatCommand("showbadge", showBadge, 1.5);