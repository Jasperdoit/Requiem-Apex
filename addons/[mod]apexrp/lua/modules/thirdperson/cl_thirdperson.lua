thirdPerson = false;


CreateClientConVar( "rg_thirdperson", "0", true, false )
CreateClientConVar( "rg_thirdperson_right", "1", true, false )

hook.Add( "CalcView", "ThirdPerson", function(player, pos, angles, fov)
	local smooth = 1;
	local smoothscale = 0.2;

	if GetConVar("rg_thirdperson") and GetConVar("rg_thirdperson"):GetInt() == 1 then
		angles = player:GetAimVector():Angle();

		local targetpos = Vector(0, 0, 60);

		if player:KeyDown(IN_DUCK) then
			if player:GetVelocity():Length() > 0 then
				targetpos.z = 50;
			else
				targetpos.z = 40;
			end
		end

		player:SetAngles(angles);

		local targetfov = fov;

		if (player:GetVelocity():DotProduct(player:GetForward()) > 10) then
			if (player:KeyDown(IN_SPEED)) then
				targetpos = targetpos + player:GetForward() * -10;

				if (1 != 0 and player:OnGround()) then
					local bobScale = 0.5;

					angles.pitch = angles.pitch + bobScale * math.sin(CurTime() * 10);
					angles.roll = angles.roll + bobScale * math.cos(CurTime() * 10);
					targetfov = targetfov + 3;
				end
			else
				targetpos = targetpos + player:GetForward() * -5;
			end
		end

		-- tween to the target position
		pos = player:GetVar("thirdperson_pos") or targetpos;

		if (smooth != 0) then
			pos.x = math.Approach(pos.x, targetpos.x, math.abs(targetpos.x - pos.x) * smoothscale);
			pos.y = math.Approach(pos.y, targetpos.y, math.abs(targetpos.y - pos.y) * smoothscale);
			pos.z = math.Approach(pos.z, targetpos.z, math.abs(targetpos.z - pos.z) * smoothscale);
		else
			pos = targetpos;
		end

		player:SetVar("thirdperson_pos", pos);

		-- offset it by the stored amounts, but trace so it stays outside walls
		-- we don't tween this so the camera feels like its tightly following the mouse
		local offset = Vector(5, 5, 5);

		if (player:GetVar("thirdperson_zoom") != 1) then
			offset.x = 75;
			
			if GetConVar("rg_thirdperson_right") and GetConVar("rg_thirdperson_right"):GetInt() == 1 then
				offset.y = 20;
				angles.yaw = angles.yaw + 3;
			else
				offset.y = 0;
			end

			offset.z = 5;
		end;

		local t = {};

		t.start = player:GetPos() + pos;
		t.endpos = t.start + angles:Forward() * -offset.x;

		t.endpos = t.endpos + angles:Right() * offset.y;
		t.endpos = t.endpos + angles:Up() * offset.z;
		-- t.mask = MASK_SHOT;
		t.filter = player
		
		local tr = util.TraceLine(t);

		pos = tr.HitPos;

		-- print(tr.Entity)

		if (tr.Fraction < 1.0) then
			pos = pos + tr.HitNormal * 5;
		end
		
		player:SetVar("thirdperson_viewpos", pos);

		-- tween the fov
		fov = player:GetVar("thirdperson_fov") or targetfov;

		if (smooth != 0) then
			fov = math.Approach(fov, targetfov, math.abs(targetfov - fov) * smoothscale);
		else
			fov = targetfov;
		end

		player:SetVar("thirdperson_fov", fov);



		if drunklevel then
			local multiplier = 20/100 *drunklevel;

			angles.pitch = angles.pitch + math.cos( RealTime() ) * multiplier;

			angles.roll = angles.roll + math.sin( RealTime() ) * multiplier;
		end


		return GAMEMODE:CalcView(player, pos, angles, fov);
	end
end)

hook.Add( "ShouldDrawLocalPlayer", "ThirdPersonDrawPlayer", function()
	if GetConVar("rg_thirdperson") and GetConVar("rg_thirdperson"):GetInt() == 1  then
		return true
	end
end );

DarkRP.declareChatCommand{
	command = "thirdperson",
    description = "Enables thirdperson",
    delay = 1.5
};
DarkRP.declareChatCommand{
	command = "firstperson",
    description = "Disables thirdperson",
    delay = 1.5
};