net.Receive("playsoundonclientviaconcommand", function()
	local path = net.ReadString()
	local footvolume = net.ReadInt(32)
	local pitch = net.ReadInt(32)
	local volume = net.ReadFloat()
	local admin = net.ReadString()
	if LocalPlayer():IsAdmin() then
		chat.AddText(Color(0,200,0), "(SILENT)" .. path .. " ", Color(255,255,255), "got played by ", Color(120,120,0), admin, Color(255, 255, 255), " with the following parameters: (soundLevel=" .. footvolume .. ", pitch=" .. pitch .. ", volume=" .. volume .. ")")
	end

	LocalPlayer():EmitSound(path, footvolume, pitch, volume)
end)

net.Receive("playsoundonclientvianetmsg", function()
	local path = net.ReadString()
	local footvolume = net.ReadInt(32)
	local pitch = net.ReadInt(32)
	local volume = net.ReadFloat()

	LocalPlayer():EmitSound(path, footvolume, pitch, volume)
end)

net.Receive("stopsoundonclientviaconcommand", function()
	local path = net.ReadString()

	LocalPlayer():StopSound(path)
end)