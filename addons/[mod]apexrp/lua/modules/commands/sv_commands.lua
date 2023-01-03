#NoSimplerr#
local oocTags = {
    ["superadmin"] = "Super Admin",
    ["securitystaff"] = "Security Staff",
    ["admin"] = "Admin",
    ["gamemaster"] = "Game Master",
    ["moderator"] = "Mod",
    ["vip"] = "VIP",
	["user"] = "User",
    ["pacuser"] = "PACUSER",
    ["senioradmin"] = "Senior Admin",
    ["operative"] = "Operative",
    ["servermanager"] = "Server Manager",
    ["eventmanager"] = "Event Manager",
    ["trial-moderator"] = "Trial Moderator",
}

local ooccolour = {
    ["superadmin"] = Color(0, 127, 31),
    ["admin"] = Color(0, 17, 255),
    ["gamemaster"] = Color(242, 0, 255),
    ["moderator"] = Color(0, 140, 255),
    ["vip"] = Color(212, 185, 9),
    ["user"] = Color(211, 211, 211),
    ["pacuser"] = Color(200, 200, 200),
    ["senioradmin"] = Color(127, 0, 0),
    ["operative"] = Color(222, 0, 0),
    ["servermanager"] = Color(0, 127, 31),
    ["eventmanager"] = Color(128, 255, 170),
    ["trial-moderator"] = Color(115, 255, 255),
    ["rpdirector"] = Color(127, 0, 255),
    ["securitystaff"] = Color(255, 186, 235)
}

local function prefixname(ply)
    return oocTags[ply:GetUserGroup()]
end

local function prefixc(ply)
    return ooccolour[ply:GetUserGroup()]
end

-- Admin chat 

local function adminChat(ply, args)
	if not (ply:IsAdmin()) then return "" end 

	local text = args;
	
	for _, target in ipairs(player.GetAll()) do 
		if not (target:IsAdmin()) then continue; end 
		
		target:sendMsg({font = "RobotoMono20"}, Color(124,252,0), "[@] ", prefixc(ply), "[", string.upper(ply:GetUserGroup()), "] ", ply:SteamName(), ": ", Color(124,252, 0), text)
	end 
	
	return "";
end 

DarkRP.defineChatCommand( "adminchat", adminChat, 1.5 );
DarkRP.defineChatCommand( "ac", adminChat, 1.5 ); 

-- Combine radio

local function radio( ply, args )
    if not ( ply:isCombine() ) and not (ply:Team() == TEAM_ADMINISTRATOR) then
        DarkRP.notify( ply, 1, 4, "You are not allowed to use the combine radio." );
            
        return ""; 
    end 
    
    if (ply:GetNWBool("noBiosignal")) then 
        DarkRP.notify( ply, 1, 4, "The radio is bio-locked!" );
            
        return ""; 
	end 

    local text = args; 

    if not ( text ) then 
        DarkRP.notify( ply, 1, 4, "Invalid arguments." );
    
        return ""; 
    end 

    for _, target in ipairs( player.GetAll() ) do 
        if ( target:isCombine() and not target:GetNWBool("noBiosignal")) or ( target:Team() == TEAM_ADMINISTRATOR) then 
            target:sendMsg( { font = "RobotoMono28" }, Color( 100, 255, 46 ),  ply:Name() .. " radios in <:: " .. text .. " ::>" );
        else 
            if ( target:isCombine() and not target:GetNWBool("noBiosignal")) or ( target == ply ) then continue; end 

            if ( target:GetPos():DistToSqr( ply:GetPos() ) <= GAMEMODE.Config.talkDistance * GAMEMODE.Config.talkDistance ) then 
                target:sendMsg( { font = "RobotoMono28" }, Color( 100, 255, 46 ),  ply:Name() .. " radios in <:: " .. text .. " ::>" );
            end     
        end 
    end 

    return "";
end 

DarkRP.defineChatCommand( "radio", radio, 1.5 );
DarkRP.defineChatCommand( "r", radio, 1.5 ); 

-- Troll nuke.

local prefixes = {
	'<3 ',
	'0w0 ',
	'H-hewwo?? ',
	'HIIII! ',
	'Haiiii! ',
	'Huohhhh. ',
	'OWO ',
	'OwO ',
	'UwU '
}

local suffixes = {
	' :3',
	' UwU',
	' (✿ ♡‿♡)',
	' ÙωÙ',
	' ʕʘ‿ʘʔ',
	' ʕ•̫͡•ʔ',
	' >_>',
	' ^_^',
	'..',
	' Huoh.',
	' ^-^',
	' ;_;',
	' ;-;',
	' xD',
	' x3',
	' :D',
	' :P',
	' ;3',
	' XDDD',
	', fwendo',
	' ㅇㅅㅇ',
	' (人◕ω◕)',
	'（＾ｖ＾）',
	' x3',
	' ._.',
	' (　\'◟ \')',
	' (• o •)',
	' (；ω；)',
	' (◠‿◠✿)',
	' >_<'
}

local substitutions = {
	['r'] = 'w',
	['l'] = 'w',
	['R'] = 'W',
	['L'] = 'W',
	['no'] = 'nu',
	['has'] = 'haz',
	['have'] = 'haz',
	['you'] = 'uu',
	['the'] = 'da',
	['The'] = 'Da'
}

local viggerPeople = {
--    ["STEAM_0:0:157932073"] = true,
   -- ["STEAM_0:0:57759180"] = true, -- blazing
   -- ["STEAM_0:1:79277566"] = true, -- blitz
   -- ["STEAM_0:1:69136884"] = true, -- binbows
};

local function OwOifyText(text, doPrefix, doSuffix)
	if doPrefix then
		text = prefixes[math.random(1, #prefixes)] .. text
	end

	for v,k in pairs(substitutions) do -- probably slow
	    text = string.Replace(text, v, k)
	end

	if doSuffix then
		text = text .. suffixes[math.random(1, #suffixes)]
	end

	return text
end

-- OOC

local function ooc( ply, args )
    local text = string.Trim( args ); 

    if not ( text ) or ( text == "" ) then 
        DarkRP.notify( ply, 1, 4, "Invalid arguments." );

        return ""; 
    end 

    if not ( ply:IsSuperAdmin() ) then
        local text2 = text;
        local lagCheck = string.Explode( " ", text2 );
            
        for k, v in pairs( lagCheck ) do
            _, amount = string.gsub(v, "^%s?[Ll]+.?[AaÄä]+.?[Gg]+", "") 
            if (amount > 0) then return "" end
        end
    end
	
	local col = prefixc(ply);
    local rank = prefixname(ply);
    
    if (viggerPeople[ply:SteamID()]) then 
        text = OwOifyText(text, true, true)
    end 
	
    for _, target in ipairs( player.GetAll() ) do 
        target:sendMsg( Color(153, 0, 0),  "[OOC] ", col, ply:SteamName(), Color( 255, 255, 255 ), ": " .. text );
    end 

    return "";
end 

DarkRP.defineChatCommand( "/", ooc, 5 );
DarkRP.defineChatCommand( "ooc", ooc, 5 ); 
DarkRP.defineChatCommand( "a", ooc, 5 );

-- LOOC 

local function looc( ply, args )
    local text = string.Trim( args ); 

    if not ( text ) or ( text == "" ) then 
        DarkRP.notify( ply, 1, 4, "Invalid arguments." );

        return ""; 
    end 

    if not ( ply:IsSuperAdmin() ) then
        local text2 = text;
        local lagCheck = string.Explode( " ", text2 );
        
        for k, v in pairs( lagCheck ) do
            _, amount = string.gsub(v, "^%s?[Ll]+.?[AaÄä]+.?[Gg]+", "") 
            if (amount > 0) then return "" end
        end
    end
    
    if (viggerPeople[ply:SteamID()] ) then 
        text = OwOifyText(text, true, true)
    end 

    for _, target in ipairs( player.GetAll() ) do 
        if ( target:GetPos():DistToSqr( ply:GetPos() ) <= GAMEMODE.Config.talkDistance * GAMEMODE.Config.talkDistance ) then 

            local prefixColor = GAMEMODE.Config.loocPrefixColor or Color( 204, 102, 0 );
            local rankColor;

            if ( GAMEMODE.Config.rankColor ) and ( GAMEMODE.Config.rankColor[ ply:GetUserGroup() ] ) then 
                rankColor = GAMEMODE.Config.rankColor[ ply:GetUserGroup() ];
            else     
                rankColor = Color( 64, 64, 64 );
            end 

            target:sendMsg( prefixColor,  "[LOOC] ", rankColor, ply:Name(), Color( 255, 255, 255 ), ": " .. text );
        end 
    end 

    return "";
end 

DarkRP.defineChatCommand( "looc", looc, 3 );

-- Me

local function me( ply, args )
    local text = args; 

    if not ( text ) then 
        DarkRP.notify( ply, 1, 4, "Invalid arguments." );

        return ""; 
    end 

    for _, target in ipairs( player.GetAll() ) do 
        if ( target:GetPos():DistToSqr( ply:GetPos() ) <= GAMEMODE.Config.meDistance * GAMEMODE.Config.meDistance ) then 

            target:sendMsg( { font = "RobotoMono24Italic" }, Color( 225, 212, 132 ), "[ACTION] " .. ply:Name() ..  " " ..  text );
        end 
    end 

    return "";
end

DarkRP.defineChatCommand( "me", me, 1.5 );

-- Yell.

local function yell( ply, args )
    local text = args; 

    if not ( text ) then 
        DarkRP.notify( ply, 1, 4, "Invalid arguments." );

        return ""; 
    end 

    for _, target in ipairs( player.GetAll() ) do 
        if ( target:GetPos():DistToSqr( ply:GetPos() ) <= GAMEMODE.Config.yellDistance * GAMEMODE.Config.yellDistance ) then 

            target:sendMsg( { font = "RobotoMono28" }, Color( 153, 76, 0 ), ply:Name() ..  " yells " ..  text );
        end 
    end 

    return "";
end

DarkRP.defineChatCommand( "yell", yell, 1.5 );
DarkRP.defineChatCommand( "y", yell, 1.5 );

-- Roll

local function roll( ply, args )
    for _, target in ipairs( player.GetAll() ) do 
        if ( target:GetPos():DistToSqr( ply:GetPos() ) <= GAMEMODE.Config.meDistance * GAMEMODE.Config.meDistance ) then 

            target:sendMsg( { font = "RobotoMono24Italic" }, Color( 225, 212, 132 ), "[ROLL] " .. ply:Name() ..  " has rolled " .. math.random( 1, 100 ) .. " out of 100." );
        end 
    end 

    return "";
end

DarkRP.defineChatCommand( "roll", roll, 1.5 );

-- It

local function it( ply, args )
    local text = args; 

    if not ( text ) then 
        DarkRP.notify( ply, 1, 4, "Invalid arguments." );

        return ""; 
    end 

    for _, target in ipairs( player.GetAll() ) do 
        if ( target:GetPos():DistToSqr( ply:GetPos() ) <= GAMEMODE.Config.meDistance * GAMEMODE.Config.meDistance ) then 

            target:sendMsg( { font = "RobotoMono24Italic" }, Color( 225, 212, 132 ), "[DESCRIPTION] " ..  text );
        end 
    end 

    return "";
end

DarkRP.defineChatCommand( "it", it, 1.5 );

-- Door kick

local function doorKick( ply )
    if ( ply.doorKick ) then 
        DarkRP.notify( ply, 1, 4, "You are already kicking a door!" );
    
        return "";
    end

    local door = ply:GetEyeTrace().Entity;
	
    if not ( door:isDoor() ) then 
        DarkRP.notify( ply, 1, 4, "You must look at a door!" );

        return "";
    end   
   --[[ 
    if not ( door:isLocked() ) then 
        DarkRP.notify( ply, 1, 4, "This door is already unlocked." );

        return "";
    end 
	]]
    if ( door.isBeingKicked ) then 
        DarkRP.notify( ply, 1, 4, "This door is already being kicked" )

        return "";
    end 

    if( door:GetPos():DistToSqr( ply:GetPos() ) > 100 ^ 2 ) then 
        DarkRP.notify( ply, 1, 4, "You are too far from the door!" );

        return "";
    end 

    ply.doorKick = true;
    door.isBeingKicked = true; 

    if ( ply:isWepRaised() ) then 
        ply:toggleWepRaised();
    end

    if ( ply:isCombine() ) and not (ply:Team() == TEAM_CONSCRIPT) then 
        if ( ply:Team() == TEAM_CP ) then
            ply:forceSequence( "adoorkick", function() 
                if not ( IsValid( door ) ) then return; end 
                if not ( IsValid( ply ) ) then return; end 

                door:EmitSound( "physics/wood/wood_panel_break1.wav" ); 
                
                if (door:GetClass() == "func_door") then         
                	door:Fire( "open" );  
				else                        
                    door:Fire( "unlock" );
                    door:Fire( "openawayfrom", ply );
				end
					
                ply:EmitSound( "npc/metropolice/vo/movetoarrestpositions.wav" );
                ply:toggleWepRaised();
            end, .7 );  
        elseif ( ply:Team() == TEAM_OVERWATCH ) then 
            if not ( ply:GetActiveWeapon():GetClass():find("fl_")) then 
                DarkRP.notify( ply, 1, 4, "You must have a weapon in order to kick the door open." );
                ply.doorKick = nil;
   				door.isBeingKicked = nil; 

                return "";
            end
            
            ply:forceSequence( "melee_gunhit", function() 
                if not ( IsValid( door ) ) then return; end 
                if not ( IsValid( ply ) ) then return; end 
                
                door:EmitSound( "physics/wood/wood_panel_break1.wav" );
                    
                if (door:GetClass() == "func_door") then         
                	door:Fire( "open" );  
				else                         
                    door:Fire( "unlock" );
                    door:Fire( "openawayfrom", ply );
				end   
                
                ply:forceSequence( "signal_advance", function() 
                    if not ( IsValid( ply ) ) then return; end 

                    ply:EmitSound( "npc/combine_soldier/vo/movein.wav" );
                    ply:toggleWepRaised()
                end, .5 ); 
            end, .58 ); 
        end 
    else
        if ( ply:Team() == TEAM_CITIZEN ) or (ply:Team() == TEAM_CONSCRIPT) then 
            if not ( ply:GetActiveWeapon():GetClass():find("fl_")) then 
                DarkRP.notify( ply, 1, 4, "You must have a weapon in order to kick the door open." );
                ply.doorKick = nil;
   				door.isBeingKicked = nil; 

                return "";
            end 
          
            if (ply:Team() == TEAM_CITIZEN) and not ( door:GetClass() == "prop_door_rotating" ) then 
                DarkRP.notify( ply, 1, 4, "You can't open this kind of door!" );
				ply.doorKick = nil;
   				door.isBeingKicked = nil; 
                
                return "";
            end 

            ply:forceSequence( "MeleeAttack01", function()
                if not ( IsValid( door ) ) then return; end 
                if not ( IsValid( ply ) ) then return; end 

                door:EmitSound( "physics/wood/wood_panel_break1.wav" );  
            
                if ( math.random( 1, 5 ) > 4 ) then 
                    door:Fire( "unlock" );
                    door:Fire( "openawayfrom", ply );
                    ply:toggleWepRaised();
                else 
                    DarkRP.notify( ply, 1, 4, "You failed opening the door." ); 
                end 
            end, .4 );
        end
    end  

    ply.doorKick = false; 
    door.isBeingKicked = false;
end 

DarkRP.defineChatCommand( "doorkick", doorKick, 1.5 );
DarkRP.defineChatCommand( "kickdoor", doorKick, 1.5 );

-- Search 

local NoStripWeapons = {"weapon_physgun", "weapon_physcannon", "keys", "gmod_camera", "gmod_tool", "weaponchecker", "med_kit", "pocket", "weapon_keypadchecker", "weapon_handcuffed"}

function searchPlayer(ply, args)
    local trace = ply:GetEyeTrace()
    local P = trace.Entity

    if ply:IsPlayer() and (ply:isCombine() or ply:GetNWBool("IsRebelScum", false)) then
        if not IsValid(P) and not P:IsPlayer() and P:GetPos():DistToSqr(ply:GetPos()) > 80 * 80 then
            ply:notify("You need to be looking at a player")

            return
        end

        if (P:isCombine()) and not ply:GetNWBool("IsRebelScum", false) then
            ply:notify("You can't search this person!")

            return
        end

        ply:EmitSound("buttons/lever8.wav")
        ply:notify("Searching..")

        timer.Simple(5, function()
            local trace = ply:GetEyeTrace()

            if trace.Entity == P and P:GetPos():DistToSqr(ply:GetPos()) <= 80 * 80 then
                ply:EmitSound("buttons/blip1.wav")
                local result = ""
                local weapon = ""

                for k, v in pairs(trace.Entity:GetWeapons()) do
                    if v:IsValid() then
                        if not table.HasValue(NoStripWeapons, string.lower(v:GetClass())) then
                            result = result .. ", " .. v:GetClass()

                            if not P:GetNWBool("IsSpy", false) and downtimemode != true and not ply:GetNWBool("IsRebelScum") then
                                trace.Entity:StripWeapon(v:GetClass())
                                ply:AddMoney(100)
                                ply:notify("You have been rewarded T100 for confiscating a " .. v:GetClass() .. "!")
                            end
                        end
                    end
                end

                ply:ChatPrint(trace.Entity:Nick() .. "'s weapons:")

                if result == "" then
                    ply:ChatPrint(trace.Entity:Nick() .. " has no weapons")
                else
                    local endresult = string.sub(result, 3)
                    ply:ChatPrint(string.sub(result, 3))
                end

                if P:getPocketItems() and P:getPocketItems() ~= {} then
                    ply:ChatPrint(trace.Entity:Nick() .. " has the following items in his pocket:")

                    for pockID, pockEnt in pairs(P:getPocketItems()) do                        
						if pockEnt.class == "spawned_weapon" then
							ply:ChatPrint(pockEnt.class)

							if not P:GetNWBool("IsSpy", false) and downtimemode != true and not ply:GetNWBool("IsRebelScum", false) then
								ply:notify("You have been given T100 for confiscating a " .. pockEnt.class .. "!")
								ply:AddMoney(100)
							end
							if not P:GetNWBool("IsSpy") then
								ply:removePocketItem(pockID);
							end
						elseif pockEnt.class == "spawned_food" then
							ply:ChatPrint("Food Item")
						else
							ply:ChatPrint(pockEnt.class)
						end               
                    end
                else
                    ply:ChatPrint(trace.Entity:Nick() .. " has nothing in his !")
                end

                if P:GetNWBool("IsSpy", false) then
                    ply:ChatPrint(trace.Entity:Nick() .. " has an Universal Union badge on him. This person is an informant! Try not to blow his cover and make sure to keep contact with him to keep taps on rebel bases!")
                    net.Start("AddSpyHalo")
                    net.WriteEntity(P)
                    net.Send(ply)
                end
            else
                ply:notify("You need to be looking at a player")
            end
        end)
    else
        ply:notify("You can't run this command!")

        return
    end
end

DarkRP.defineChatCommand("search", searchPlayer, 1.5);

-- Vortcall 

local vortsnd = {
	'vo/outland_01/intro/ol01_vortcall01.wav',
    'vo/outland_01/intro/ol01_vortcall02c.wav',
    'vo/outland_01/intro/ol01_vortresp04.wav'
};

local function vortCall(ply, args)
	if (ply:Team() == TEAM_VORTIGAUNT) then 
        if ply:GetModel() == 'models/vortigaunt.mdl' then
            local text = args;
			if not (text) or (text == "") then return ""; end 
              
			for k, v in pairs(player.GetAll()) do
				if v:Team() == TEAM_VORTIGAUNT and v:GetModel() == 'models/vortigaunt.mdl' then
					v:sendMsg({font = "RobotoMono20Italic"}, Color(172,156,11), "[VORT-CALL] ", Color(255,255,255), ply:Name(), Color(255,0,255), ": " .. text);
				end
			end

            local ran = math.random(1, 3);
            ply:EmitSound(vortsnd[ran]);
			ply:ConCommand("say /me calls vortigaunts");
			return "";
        else
            ply:notify('You must be un-shackled todo this.')
			return "";
        end
    else
        ply:notify('You must be a vort todo this.');
		return "";
    end
end 

DarkRP.defineChatCommand("vortcall", vortCall, 1.5);

local function PlayerAdvertise(ply, args)
    if args == "" then return "" end

    if ply:Team() ~= TEAM_CWU then
        ply:notify("Your team can't advert!")

        return ""
    end

    local text = args;
	if not text or text == "" then return "" end
	
	ply:notify(string.format("Your announcement has been sent and will be displayed shortly."))

	for k, v in pairs(player.GetAll()) do
		local col = team.GetColor(ply:Team())

		timer.Simple(15, function()
			-- v:ApexChat([[Color(226,162,13), "[ADVERT] ", teamCOL, plyNAME, Color(255,255,255),": ", message]], ply, text)
			v:sendMsg({font = "RobotoMono24" }, Color(226, 162, 13), "[ADVERT] ", team.GetColor(ply:Team()), ply:Name(), Color(255, 255, 255), ": ", text)
		end)
		--GAMEMODE:TalkToPerson(v, col, LANGUAGE.advert .." "..ply:Nick(), Color(255,255,0,255), text, ply)
	end
	
	return "";
end

DarkRP.defineChatCommand("announce", PlayerAdvertise, 1.5);

timer.Simple(1, function()
	DarkRP.chatCommands["advert"] = nil;
	
	DarkRP.defineChatCommand("advert", PlayerAdvertise, 1.5);

	DarkRP.declareChatCommand{
		command = "advert",
		description = "Advertise shit",
		delay = 1.5,
	};
end );

DarkRP.declareChatCommand{
	command = "announce",
	description = "Advertise shit",
	delay = 1.5,
};

local function DispatchMsg(ply, args)
    if args == "" then
        ply:notify(DarkRP.getPhrase("invalid_x", "argument", ""))

        return ""
    end

    if (ply:Team() ~= TEAM_DISPATCH) and (ply:getDivision() ~= DIVISION_SECTORIAL) and (ply:getDivision() ~= DIVISION_PCMD) then 
        ply:notify("Only Dispatch units can use the dispatch radio.")

        return ""
    end

    local text = args;
	
    if not text or text == "" then
		ply:notify(DarkRP.getPhrase("invalid_x", "argument", ""))

		return "";
	end

	text = hook.Call("DispatchTalk", nil, ply, text) or text;
	
	for _, target in pairs(player.GetAll()) do
		target:sendMsg({font = "VCR28"}, Color(0, 0, 128), "[DISPATCH] ", Color(255, 255, 255), text);
	end
	
	return "";
end

DarkRP.defineChatCommand("dispatch", DispatchMsg, 1.5);
DarkRP.declareChatCommand{
	command = "dispatch",
	description = "Dispatch chat message",
	delay = 1.5,
};

local function DispatchRadioMsg(ply, args)
    if args == "" then
        ply:notify(DarkRP.getPhrase("invalid_x", "argument", ""))

        return ""
    end

    if (ply:Team() ~= TEAM_DISPATCH) and (ply:getDivision() ~= DIVISION_SECTORIAL) and (ply:getDivision() ~= DIVISION_PCMD) then
        ply:notify("Only Dispatch units can use the dispatch radio.")

        return ""
    end

    local text = args;
    
	if not text or text == "" then
		ply:notify(DarkRP.getPhrase("invalid_x", "argument", ""))

		return "";
	end
	
	text = hook.Call("DispatchRadioTalk", nil, ply, text) or text;

	for _, target in pairs(player.GetAll()) do
		if target:isCombine() or target:Team() == TEAM_ADMINISTRATOR then 
			target:sendMsg({font = "VCR28"}, Color(153, 0, 0), "[DISPATCH DIRECTIVES] ", Color(255, 255, 255), text);
		end
	end
	
    return "";
end

DarkRP.defineChatCommand("dradio", DispatchRadioMsg, 1.5);
DarkRP.declareChatCommand{
	command = "dradio",
	description = "Dispatch directives",
	delay = 1.5,
};

-- Apply 

local function ShowID(ply, args)		
	local currentteamname = ply:getDarkRPVar("job")
	DarkRP.talkToRange(ply, ply:Nick() .. " shows their ID containing: Name: " .. ply:GetName() .. " Job: " .. currentteamname, "", 250)
	
	return "";
end
DarkRP.defineChatCommand("apply", ShowID, 1.5);
DarkRP.declareChatCommand{
	command = "apply",
	description = "Show your id.",
	delay = 1.5,
};

-- Whisper

local function Whisper(ply, args)
   local text = args;
    if not text or text == "" then
        ply:notify(DarkRP.getPhrase("invalid_x", "argument", ""))

        return ""
    end

    for v, k in pairs(ents.FindInSphere(ply:GetPos(), 90)) do
        if k:IsPlayer() then
            k:sendMsg({font = "RobotoMono18"}, Color(0,102,204), ply:Name(), " whispers",  ": ", args)
        end
    end
    
    return "";
end

DarkRP.defineChatCommand("w", Whisper, 1.5);
DarkRP.defineChatCommand("whisper", Whisper, 1.5);
DarkRP.declareChatCommand{
	command = "w",
	description = "Whispers.",
	delay = 1.5,
};
DarkRP.declareChatCommand{
	command = "whisper",
	description = "Whispers.",
	delay = 1.5,
};