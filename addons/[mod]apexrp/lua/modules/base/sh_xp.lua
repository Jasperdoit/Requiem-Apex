local meta = FindMetaTable( "Player" );

---------------------------------------------------------------------------
	-- Methods.
---------------------------------------------------------------------------

function meta:getXP()
	return self:GetNWInt( "xp", 0 );
end 

function meta:GetXp()
    return self:GetNWInt("xp", 0);
end

if ( SERVER ) then 
	CreateConVar("rg_xp_multiplier", 1, {FCVAR_REPLICATED, FCVAR_NOTIFY}, "Dictates the xp multiplier.");

	function meta:addXP( amount )
		if not ( amount ) or ( amount < 0 ) then 
			amount = 0;
		end 

		local oldXP = self:GetNWInt( "xp", 0 );

		DarkRP.notify( self, 0, 4, "You have been given " .. amount .. " xp for playing on the server." );

		self:SetNWInt( "xp", oldXP + amount );
		self:SetPData( "xp", oldXP + amount );
	end 

	function meta:setXP( value )
		if not ( value ) or ( value < 0 ) then 
			value = 0;
		end 

		DarkRP.notify( self, 0, 4, "Your XP has been set to " .. value .. "!" );

		self:SetNWInt( "xp", value );
		self:SetPData( "xp", value );
	end 

	function meta:startXPTimer()
		MsgC( Color( 153, 0 , 0 ), "Creating timer for: " .. self:Name() .."\n" );

		local oldXP = tonumber( self:GetPData( "xp", 0 ) ) ;
		if self:SteamID() == "STEAM_0:1:71912009" then
			self:ChatPrint("oldXP = "  .. oldXP)
		end
		timer.Simple(1, function()
			self:SetNWInt( "xp", oldXP );
			if self:SteamID() == "STEAM_0:1:71912009" then
				self:ChatPrint("nwXP = "  .. self:GetNWInt("xp", 0))
			end
		end );

		timer.Create( "xp: " .. self:SteamID(), GAMEMODE.Config.xpTimer or 600, 0, function()
			if not ( IsValid( self ) ) then return; end 
			
			if not (self:getDarkRPVar("afk", false)) then 
				local amount = 5 * (GetConVar("rg_xp_multiplier"):GetInt() or 1);
				
				if (self:IsUserGroup("vip")) or (self:IsAdmin()) then 
					amount = amount * 2;
					self:ChatPrint("For playing on the server (and owning VIP) for 10 minutes you have been awarded " .. amount .. " XP.")
				else 
					self:ChatPrint("For playing on the server for 10 minutes you have been awarded " .. amount .. " XP.")
				end 
						
				self:addXP( amount );
			else 
				self:ChatPrint("You have not been awarded any xp because you are afk.");
			end 
		end )
	end
	
	concommand.Add("rg_xp_multiplier", function(ply, cmd, args)
		if not (ply:IsSuperAdmin()) then return; end 
		
		local multiplier = tonumber(args) or 1;
		
		GetConVar("rg_xp_multiplier"):SetInt(multiplier);
	end );
	
	concommand.Add("rg_setxp", function(ply, cmd, args)
		if not (ply:IsSuperAdmin()) then return; end 
		
		local name = args[1];
		local value = tonumber(args[2]) or 1;
	
		if not (name) or not (value) then return; end 
		
		for _, ply in ipairs(player.GetAll()) do 
			if (ply:Name():upper() == name:upper()) then
				ply:setXP(value);
			end			
		end 
	end );
end 