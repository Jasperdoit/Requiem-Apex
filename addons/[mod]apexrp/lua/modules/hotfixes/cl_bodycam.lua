hook.Add( "KeyPress", "Dispatch_Leave_Spectate2", function( ply, key )
	if ( key == IN_JUMP ) and ply:GetNWBool("isinbodycam") then
		ply:SetNWBool("isinbodycam", false)
		net.Start("dispatch_bodycam_off")
		net.SendToServer()
	end
end )