hook.Add("PlayerSpawnProp", "CustomPropLimit", function(ply, model)
    if ply:GetUserGroup() == "user" and ply:GetCount("props") >= 170 then
        ply:notify("You have hit the max props limit!")
        return false
   elseif ply:GetUserGroup() == "vip" and ply:GetCount("props") >= 250 then
        ply:notify("You have hit the max props limit!")
       return false
    end
	
	if not ent then return end
	
    if ent:GetModelScale() >= 5 then
        for _, admins in pairs(player.GetAll()) do
            if admins:IsAdmin() then
                admins:ChatPrint(ply:Name() .. " just tried to crash the server with an entity sized: " .. ent:GetModelScale() .. " . SteamID=" .. ply:SteamID())
            end
        end
        ent:Remove()
        ply:Kick("Nice try!")
    end
end)