if (SERVER) then 
	local function openF1Menu( ply )
		ply:ConCommand( "rg_f1menu" );
	end 

	hook.Add( "ShowHelp", "hl2rp: open f1", openF1Menu );

	local function openF4Menu( ply )
		ply:ConCommand( "rg_f4menu" );
	end 

	hook.Add( "ShowSpare2", "hl2rp: open f4", openF4Menu );
    
    local function sendMaterials()
		local path = "materials/f4menu/"
		local mats = file.Find(path .. "*", "GAME");
		
		resource.AddSingleFile(path .. "misc/l_arrow.png");
		resource.AddSingleFile(path .. "misc/r_arrow.png");
		
		for _, mat in pairs(mats) do 
			resource.AddSingleFile(path .. mat)
			print("material 1: " .. path .. mat);
		end	
	end 
	
	sendMaterials();
else    
	local panelMeta = FindMetaTable("Panel");
	
	local blur = Material( "pp/blurscreen" );
	function panelMeta:drawBlur( a, d )
		local x, y = self:LocalToScreen( 0, 0 );
    
    	surface.SetDrawColor( 255, 255, 255 );
    	surface.SetMaterial( blur );
    
    	for i = 1, d do
			blur:SetFloat( "$blur", (i / d ) * ( a ) );
			blur:Recompute();
			render.UpdateScreenEffectTexture();
			surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() );
    	end
	end 

	function panelMeta:getCharacterOverview()
		return self.bCharacterOverview;
	end 

	function panelMeta:setCharacterOverview( bValue, length )
		bValue = tobool( bValue );
		length = length or animationTime;

		if ( bValue ) then
			self.bOverviewOut = false;
			self.bCharacterOverview = true;

			if not ( hook.GetTable()[ "CalcView" ][ self ] ) and not (GetConVar("hl2rp_thirdperson") and GetConVar("hl2rp_thirdperson"):GetInt() == 1) then 
				hook.Add( "CalcView", self, function( panel, client, origin, angles, fov )
					local view = { client, origin, angles, fov };
										
					if ( IsValid( self ) and self:IsVisible() and self:getCharacterOverview() ) then
						local newOrigin, newAngles, newFOV, bDrawPlayer = self:getOverviewInfo( origin, angles, fov );
						
						view.drawviewer = bDrawPlayer;
						view.fov = newFOV;
						view.origin = newOrigin;
						view.angles = newAngles;
					end 
				
					return view
				end );
			end 
		else
			self.bOverviewOut = true;

			hook.Remove( "CalcView", self );
		end
	end 

	function panelMeta:getOverviewInfo( origin, angles, fov )
		local originAngles = Angle( 0, angles.yaw, angles.roll );
		local target = LocalPlayer():GetObserverTarget();
		local fraction = self.overviewFraction or 1;
		local bDrawPlayer = ( ( fraction > 0.2 ) or not ( self.bOverviewOut and ( fraction > 0.2 ) ) ) and not IsValid( target );
		local forward = originAngles:Forward() * 58 - originAngles:Right() * 16;
		forward.z = 0;

		local newOrigin;

		if ( IsValid ( target ) ) then
			newOrigin = target:GetPos() + forward;
		else
			newOrigin = origin - LocalPlayer():OBBCenter() * 0.6 + forward;
		end

		local newAngles = originAngles + ( self.rotationOffset or Angle( 0, 180, 0 ) );
		newAngles.pitch = 5;
		newAngles.roll = 0;

		return LerpVector( fraction, origin, newOrigin ), LerpAngle( fraction, angles, newAngles ), Lerp( fraction, fov, 90 ), bDrawPlayer;
	end 
end 