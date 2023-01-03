----------------------------------------------------------------------------
	-- Disabling HL2 HUD.
---------------------------------------------------------------------------	

local hide = {
	[ "CHudHealth" ] = true,
	[ "CHudBattery" ] = true,
	[ "CHudAmmo" ] = true, 
	[ "CHudSecondaryAmmo" ] = true,
	[ "DarkRP_HUD" ] = true,
	[ "CHudDamageIndicator" ] = true,
};

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if ( hide[ name ] ) then
		return false;
	end
end );

hook.Add("DrawDeathNotice", "DisableKills", function()
	return 0, 0;
end );

hook.Add( "HUDDrawTargetID", "HidePlayerInfo", function()
	return false;
end );

---------------------------------------------------------------------------
	-- Functions.
---------------------------------------------------------------------------


local voiceChatTexture = surface.GetTextureID("voice/icntlk_pl")
local function drawVoiceChat()
	if LocalPlayer().DRPIsTalking then
		local chbxX, chboxY = chat.GetChatBoxPos()

		local Rotating = math.sin(CurTime()*3)
		local backwards = 0
		if Rotating < 0 then
			Rotating = 1-(1+Rotating)
			backwards = 180
		end
		surface.SetTexture(voiceChatTexture)
		surface.SetDrawColor(153, 0, 0)
		surface.DrawTexturedRectRotated(ScrW() - 100, chboxY, Rotating*96, 96, backwards)
	end
end 

local function drawAmmo()
	local ply = LocalPlayer();

	if not ( ply:Alive() ) then return; end 
	if not ( ply:GetActiveWeapon() ) then return; end 
	if ( GAMEMODE.Config.shouldNotDrawHud ) then return; end 
	
	local weapon = ply:GetActiveWeapon();

	if not ( IsValid( weapon ) ) then return; end 

	local clip = weapon:Clip1()
	local clipMax = weapon:GetMaxClip1()
	local count = ply:GetAmmoCount( weapon:GetPrimaryAmmoType() );
	local secondary = ply:GetAmmoCount( weapon:GetSecondaryAmmoType() );

	local w, h = nil, 30;
	local x, y = nil, ScrH() - 40; 

	local fontW, fontH;
	surface.SetFont( "RobotoMono32" );

	if ( secondary > 0 ) then
		fontW, fontH = surface.GetTextSize( secondary );

		w = fontW; 
		x = ScrW() - 15 - w;

		surface.SetDrawColor( 32, 32, 32, 150 );
		surface.DrawRect( x - 5, y, w + 10, h );
		surface.SetDrawColor( 32, 32, 32, 255 );
		surface.DrawOutlinedRect( x - 5, y, w + 10, h );

		draw.SimpleText( secondary, "RobotoMono32", x , y - 1 );
	end

	if ( weapon:GetClass() ~= "weapon_slam" ) and ( clip > 0 ) or ( count > 0 ) then
		local text;

		if ( clip == -1 ) then 
			text = count; 
		else 
			text = clip .. "/" .. count; 
		end 

		fontW = surface.GetTextSize( text );
		w = fontW;

		if ( secondary > 0 ) then 
			x = x - ( 15 + w ) 
		else 
			x = ScrW() - 15 - fontW; 
		end 
		
		surface.SetDrawColor( 32, 32, 32, 150 );
		surface.DrawRect( x - 5, y, w + 10, h );
		surface.SetDrawColor( 32, 32, 32, 255 );
		surface.DrawOutlinedRect( x - 5, y, w + 10, h );

		draw.SimpleText( text, "RobotoMono32", x, y - 1);
	end

end 

local healthLerp = 100;
local armorLerp = 100;
local foodLerp = 100;

local function drawHealthStats()
    if not (IsValid(LocalPlayer())) then return; end
	if not ( LocalPlayer():Alive() ) then return; end 
	if ( GAMEMODE.Config.shouldNotDrawHud ) then return; end 

	local ply = LocalPlayer();
	local health = ply:Health();
	local armor = ply:Armor();
	local maxHealth = ply:GetMaxHealth();
	local food = math.Round(ply:getDarkRPVar("Energy", 0) or 0);
	
	local x, y = 10, ScrH() - 20;
	local w, h = ScrW() * .3, 10;
	local offsetX, offsetY = 1, 1;

	-- Health

	surface.SetDrawColor( 32, 32, 32, 150 );
	surface.DrawRect( x, y, w, h);
	
	healthLerp = Lerp( 0.01, healthLerp, ( health / maxHealth ) * w );

	surface.SetDrawColor( 133, 0, 0 );
	surface.DrawRect( x, y, math.Clamp( healthLerp, 0, w ), h );

	surface.SetDrawColor( 32, 32, 32 );
	surface.DrawOutlinedRect( x - offsetX, y - offsetY, w + offsetX, h + offsetY + 1 );

	surface.SetFont( "RobotoMono12" );
	local fontW, fontH = surface.GetTextSize( "HEALTH: " .. health );
	draw.SimpleText( "HEALTH: " .. health, "RobotoMono12", x + ( w / 2 ) - ( fontH / 2 ), y - offsetY - 1, Color (255,255,255,255 ) );
	
	-- Armor

	if ( armor > 0 ) then 
		y = y - 20; 

		surface.SetDrawColor( 32, 32, 32, 150 );
		surface.DrawRect( x, y, w, h);
		
		armorLerp = Lerp( 0.01, armorLerp, ( armor / 100 ) * w );

		surface.SetDrawColor( 0, 0, 153 );
		surface.DrawRect( x, y, math.Clamp( armorLerp, 0, w ), h );

		surface.SetDrawColor( 32, 32, 32 );
		surface.DrawOutlinedRect( x - offsetX, y - offsetY, w + offsetX, h + offsetY + 1 );
		
        fontW, fontH = surface.GetTextSize( "ARMOR: " .. armor );
		draw.SimpleText( "ARMOR: " .. armor, "RobotoMono12", x + ( w / 2 ) - ( fontH / 2 ), y - offsetY - 1, Color (255,255,255,255 ) );
	end 
	
	-- Energy 
	
	y = y - 20;

	surface.SetDrawColor( 32, 32, 32, 150 );
	surface.DrawRect( x, y, w, h);
	
	foodLerp = Lerp( 0.01, foodLerp, ( food / 100 ) * w );

	surface.SetDrawColor( 0, 100, 0 );
	surface.DrawRect( x, y, math.Clamp( foodLerp, 0, w ), h );

	surface.SetDrawColor( 32, 32, 32 );
	surface.DrawOutlinedRect( x - offsetX, y - offsetY, w + offsetX, h + offsetY + 1 );

	fontW, fontH = surface.GetTextSize( "HUNGER: " .. food );
	draw.SimpleText( "HUNGER: " .. food, "RobotoMono12", x + ( w / 2 ) - ( fontH / 2 ), y - offsetY - 1, Color (255,255,255,255 ) );
end 

local overlay = Material( "effects/combine_binocoverlay" );
CreateClientConVar("rg_overlay", 1, true)

local function drawCombineOverlay()
	if ( LocalPlayer():Team() != TEAM_CP) and (LocalPlayer():Team() != TEAM_OVERWATCH) then return; end 
	if not (GetConVar("rg_overlay"):GetBool()) then return; end
     
	overlay:SetFloat( "$alpha", "0.3" );
	overlay:Recompute();
    
	surface.SetDrawColor( 255, 255, 255 );
	surface.SetMaterial( overlay );
	surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() );
end 

local function drawCrosshair()
	if !LocalPlayer():Alive() then return end
	if !IsValid(LocalPlayer()) then return end

	if GetConVar("rg_thirdperson") and GetConVar("rg_thirdperson"):GetInt() == 0 then
		if LocalPlayer():GetActiveWeapon():IsValid() then
			   local x,y = ScrW()/2,ScrH()/2
			   local gap = 5
			   local length = gap + 5	    

			   surface.SetDrawColor( 255, 255,255, 155 )
				
			   surface.DrawLine( x - length, y, x - gap, y )
			   surface.DrawLine( x + length, y, x + gap, y )
			   surface.DrawLine( x, y - length, x, y - gap )
			   surface.DrawLine( x, y + length, x, y + gap )
		end
	else 
		local p = LocalPlayer():GetEyeTrace().HitPos:ToScreen()
		local x,y = p.x, p.y
			
		surface.SetDrawColor( 255, 255,255, 155 )
			
		local gap = 5
		local length = gap + 5
			
		surface.DrawLine( x - length, y, x - gap, y )
		surface.DrawLine( x + length, y, x + gap, y )
		surface.DrawLine( x, y - length, x, y - gap )
		surface.DrawLine( x, y + length, x, y + gap )
	end 
end 

local function drawHealthStatus(ply)
	local pos = ply:EyePos()

	pos.z = pos.z + 5 -- The position we want is a bit above the position of the eyes
	pos = pos:ToScreen()
	pos.y = pos.y - 50 -- Move the text up a few pixels to compensate for the height of the text

	if ply:GetNoDraw() == true then 
		return 
	else
		draw.DrawText(ply:Nick(), "RobotoMono24Bold", pos.x, pos.y, team.GetColor(ply:Team()), 1)
	end

	if ply:Health() == 0 then
		draw.DrawText("Dead", "RobotoMono18Italic", pos.x + 1, pos.y + 24, Color(255, 0, 0, 255), 1)
	elseif ply:Health() < 20 then
		draw.DrawText("Near death", "RobotoMono18Italic", pos.x + 1, pos.y + 24, Color(204, 0, 0, 255), 1)        
    elseif ply:Health() < 40 then
        draw.DrawText("Heavily wounded", "RobotoMono18Italic", pos.x + 1, pos.y + 24, Color(255, 153, 51, 255), 1)
    elseif ply:Health() < 60 then
        draw.DrawText("Wounded", "RobotoMono18Italic", pos.x + 1, pos.y + 24, Color(255, 200, 51, 255), 1)
    elseif ply:Health() < 80 then
        draw.DrawText("Hurt", "RobotoMono18Italic", pos.x + 1, pos.y + 24, Color(200, 200, 0, 255), 1)
    else
        draw.DrawText("Healthy", "RobotoMono18Italic", pos.x + 1, pos.y + 24, Color(0, 200, 0, 255), 1)
	end
end 

local uiForeground, uiBackground = Color(240, 240, 255, 255), Color(20, 20, 20, 120)

CreateConVar("rg_cpesp", 1, FCVAR_NONE, "Toggles the combine ESP.");

local function drawEntityDisplay()
	local localplayer = LocalPlayer()
	local shootPos = localplayer:GetShootPos()
	local aimVec = localplayer:GetAimVector()

	for k, ply in ipairs(player.GetAll()) do
		if not ply:Alive() then continue end
		local hisPos = ply:GetShootPos()
        local canSee = false;
			
		if hisPos:DistToSqr(shootPos) < 400^2 then
			local pos = hisPos - shootPos
			local unitPos = pos:GetNormalized()
			if unitPos:Dot(aimVec) > 0.95 then
				local trace = util.QuickTrace(shootPos, pos, localplayer)
				if trace.Hit and trace.Entity ~= ply then return end
				if not ply:FAdmin_GetGlobal("FAdmin_cloaked") and not ply:GetNoDraw() then
					drawHealthStatus(ply)
                    canSee = true;
				end
			end
		end
        
        -- Combine ESP part shit code
        if (GetConVar("rg_cpesp"):GetInt() == 0) then return; end
        
        local localDivision = localplayer:getDivision()
        local plyDivision = ply:getDivision()
        
        if localplayer != ply and (localplayer:isCombine() and localplayer:Team() != TEAM_CONSCRIPT and localDivision > 0 and not localplayer:GetNWBool("HasbeenDefunct") and not localplayer:GetNWBool("noBiosignal")) or (localplayer:Team() == TEAM_DISPATCH) then
            if canSee then continue; end 
            if not (ply:isCombine()) then continue; end 
      		if (ply:Team() == TEAM_DISPATCH) or (ply:GetNoDraw()) or (ply:GetNWBool("noBiosignal")) then continue; end
            if ((localplayer:Team() != TEAM_OVERWATCH and localDivision != plyDivision and not ply:GetNWBool("HasbeenDefunct") and plyDivision != DIVISION_COMMANDER) and (localDivision != DIVISION_SECTORIAL and localDivision != DIVISION_PCMD and localplayer:Team() != TEAM_DISPATCH and localDivision != DIVISION_COMMANDER)) then continue; end
            
			local pos = ply:GetShootPos():ToScreen()
            if not pos.visible then continue end
            local x, y = pos.x, pos.y
            local col = team.GetColor(ply:Team())
            local text = ply:Nick()
            
            if (ply:GetNWBool("HasbeenDefunct")) then 
            	col = Color(153, 0, 0);
                text = "DESERVICED: " .. ply:Nick()
			end 
            
            text = " " .. text .. " "
            
            draw.RoundedBox(2, x, y - 6, 12, 22, col)
            draw.WordBox(2, x + 12, y - 6, text, "VCR18", uiBackground, uiForeground)
       end 
	end
	
	local tr = localplayer:GetEyeTrace()
	if IsValid(tr.Entity) and tr.Entity:isKeysOwnable() and tr.Entity:GetPos():DistToSqr(localplayer:GetPos()) < 200^2 then
		tr.Entity:drawOwnableInfo()
	end
end 

---------------------------------------------------------------------------
	-- Drawing shit on the HUD.
---------------------------------------------------------------------------

local function hudPaint()
	drawCombineOverlay();
	drawHealthStats();
	drawAmmo();
	drawVoiceChat();
	drawCrosshair();
	drawEntityDisplay();
end 

hook.Add( "HUDPaint", "hl2rp: hud paint", hudPaint );
hook.Remove("HUDDrawTargetID", "HMHUD");

local black = color_black
local white = Color(255, 255, 255, 200)
local red = Color(128, 30, 30, 255)
local changeDoorAccess = false

local function doorPaint(door)
    local self = door;
    local blocked = self:getKeysNonOwnable()
    local doorTeams = self:getKeysDoorTeams()
    local doorGroup = self:getKeysDoorGroup()
    local playerOwned = self:isKeysOwned() or table.GetFirstValue(self:getKeysCoOwners() or {}) ~= nil
    local owned = playerOwned or doorGroup or doorTeams

    local doorInfo = {}

    local title = self:getKeysTitle()
    if title then table.insert(doorInfo, title) end

    if owned then
        table.insert(doorInfo, DarkRP.getPhrase("keys_owned_by"))
    end

    if playerOwned then
        if self:isKeysOwned() then table.insert(doorInfo, self:getDoorOwner():Nick()) end
        for k in pairs(self:getKeysCoOwners() or {}) do
            local ent = Player(k)
            if not IsValid(ent) or not ent:IsPlayer() then continue end
            table.insert(doorInfo, ent:Nick())
        end

        local allowedCoOwn = self:getKeysAllowedToOwn()
        if allowedCoOwn and not fn.Null(allowedCoOwn) then
            table.insert(doorInfo, DarkRP.getPhrase("keys_other_allowed"))

            for k in pairs(allowedCoOwn) do
                local ent = Player(k)
                if not IsValid(ent) or not ent:IsPlayer() then continue end
                table.insert(doorInfo, ent:Nick())
            end
        end
    elseif doorGroup then
        table.insert(doorInfo, doorGroup)
    elseif doorTeams then
        for k, v in pairs(doorTeams) do
            if not v or not RPExtraTeams[k] then continue end

            table.insert(doorInfo, RPExtraTeams[k].name)
        end
    elseif blocked and changeDoorAccess then
        table.insert(doorInfo, DarkRP.getPhrase("keys_allow_ownership"))
    elseif not blocked then
        table.insert(doorInfo, DarkRP.getPhrase("keys_unowned"))
        if changeDoorAccess then
            table.insert(doorInfo, DarkRP.getPhrase("keys_disallow_ownership"))
        end
    end

    if self:IsVehicle() then
        local driver = self:GetDriver()
        if driver:IsPlayer() then
            table.insert(doorInfo, DarkRP.getPhrase("driver", driver:Nick()))
        end
    end

    local x, y = ScrW() / 2, ScrH() / 2
    local text = table.concat(doorInfo, "\n")
    draw.DrawNonParsedText(text, "RobotoMono24", x , y + 1 , black, 1)
    draw.DrawNonParsedText(text, "RobotoMono24", x, y, (blocked or owned) and white or red, 1)
    
    return true;
end 

hook.Add("HUDDrawDoorData", "hl2rp: door paint", doorPaint);