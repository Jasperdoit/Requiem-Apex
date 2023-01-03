local color_lightblue = Color(127, 255, 255)


net.Receive("AddSpyHalo", function()
	local target = net.ReadEntity()
	if not target:IsValid() or not target:IsPlayer() then return end
	hook.Add("PreDrawHalos", "SpyHalo" .. target:SteamID64(), function()
		halo.Add({target}, color_lightblue, 1, 1)
	end)
end)
net.Receive("RemoveSpyHalo", function()
	local target = net.ReadEntity()
	if not target:IsValid() or not target:IsPlayer() then return end
	hook.Remove("PreDrawHalos", "SpyHalo" .. target:SteamID64())
end)
net.Receive("RemoveAllSpyHalo", function()
    for _, ply in pairs(player.GetHumans()) do
        hook.Remove("PreDrawHalos", "SpyHalo" .. ply:SteamID64())
    end
end)