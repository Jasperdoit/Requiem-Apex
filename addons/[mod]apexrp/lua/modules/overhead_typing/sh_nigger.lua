if SERVER then
	--AddCSLuaFile()
	function cTyping( ply, cmd, args )
		ply:SetNWBool( "Typing", true )
	end
	concommand.Add( "c_typing", cTyping )

	function cNotTyping( ply, cmd, args )
		ply:SetNWBool( "Typing", false )
	end
	concommand.Add( "c_nottyping", cNotTyping )
end

local UnPredictedCurTime = UnPredictedCurTime;
local string = string;
local pairs = pairs;

hook.Add("PostDrawTranslucentRenderables", "DisplayTypingStuff", function()
	for k, player in pairs(player.GetAll()) do
			local eyeAngles = LocalPlayer():EyeAngles();
			local plyPos = player:GetPos();
			local clientPos = LocalPlayer():GetPos();
			
			if (player:GetNWBool("Typing") and player:GetMoveType() != MOVETYPE_NOCLIP and player:Alive()) then		
				local fadeDistance = 350;
				
				if ((plyPos and clientPos) and plyPos:Distance(clientPos) <= fadeDistance) then
					local color = player:GetColor();	
					local curTime = UnPredictedCurTime();

					if (player:GetMaterial() != "sprites/heatwave" and (a != 0 or player:IsRagdolled())) then
						local distance = EyePos():Distance( plyPos );
						local alpha = math.Clamp( 255 - distance / fadeDistance * 255, 0, 255 );
						--local position = cwPlugin:Call("GetPlayerTypingDisplayPosition", player);
						local headBone = "ValveBiped.Bip01_Head1";
						if (string.find(player:GetModel(), "vortigaunt")) then
							headBone = "ValveBiped.Head";
						end;
						
							local bonePosition = nil;
							local offset = Vector(0, 0, 80);
							local physBone = player:LookupBone(headBone);
							if (physBone) then
								bonePosition = player:GetBonePosition(physBone);
							end;
							if (player:InVehicle()) then
								offset = Vector(0, 0, 128);
							elseif (player:Crouching()) then
								offset = Vector(0, 0, 64);
							end;

							if (bonePosition) then
								position = bonePosition + Vector(0, 0, 15);
							else
								position = player:GetPos() + offset;
							end;

						if (position) then
							position = position + eyeAngles:Up();
							eyeAngles:RotateAroundAxis(eyeAngles:Forward(), 90);
							eyeAngles:RotateAroundAxis(eyeAngles:Right(), 90);
								local textWidth, textHeight = surface.GetTextSize("Typing...");
								
								if (textWidth and textHeight) then
									cam.Start3D2D(position, Angle(0, eyeAngles.y, 90), 0.1);
										draw.DrawText("Typing...", "Trebuchet24", -textWidth/2, 0, Color(255,255,255, alpha))
									cam.End3D2D();
								end;
						end;
					end;
				end;	
			end;
	end;
end)

hook.Add("StartChat", "StartTypingDisplay", function()
	RunConsoleCommand( "c_typing", "" )
end)

hook.Add("FinishChat", "FinishTypingDisplay", function()
	RunConsoleCommand( "c_nottyping", "" )
end)