local deathSoundsCP = {
	"npc/metropolice/die1.wav",
	"npc/metropolice/die2.wav",
	"npc/metropolice/die3.wav",
	"npc/metropolice/die4.wav",
	"npc/metropolice/die5.wav"
};

local deathSoundsOTA = {
	"npc/combine_soldier/die1.wav",
	"npc/combine_soldier/die1.wav",
	"npc/combine_soldier/die3.wav",
};

local fireDamage = {
	"npc/metropolice/fire_scream1.wav",
	"npc/metropolice/fire_scream2.wav",
	"npc/metropolice/fire_scream3.wav",
};

local painCP = {
	"npc/metropolice/pain1.wav",
	"npc/metropolice/pain2.wav",
	"npc/metropolice/pain3.wav"
};

local painOTA = {
	"npc/combine_soldier/pain1.wav",
	"npc/combine_soldier/pain2.wav",
	"npc/combine_soldier/pain3.wav"
};

local painVort = {
	"vo/npc/vortigaunt/vortigese07.wav",
	"vo/npc/vortigaunt/vortigese04.wav",
	"vo/npc/vortigaunt/vortigese03.wav",
};

local painMale = {
	"vo/npc/male01/pain01.wav",
	"vo/npc/male01/pain02.wav",
	"vo/npc/male01/pain03.wav",
	"vo/npc/male01/pain04.wav",
	"vo/npc/male01/pain05.wav",
	"vo/npc/male01/pain06.wav",
	"vo/npc/male01/pain07.wav",
	"vo/npc/male01/pain08.wav",
	"vo/npc/male01/pain09.wav"
};

local painFemale = {
	"vo/npc/female01/pain01.wav",
	"vo/npc/female01/pain02.wav",
	"vo/npc/female01/pain03.wav",
	"vo/npc/female01/pain04.wav",
	"vo/npc/female01/pain05.wav",
	"vo/npc/female01/pain06.wav",
	"vo/npc/female01/pain07.wav",
	"vo/npc/female01/pain08.wav",
	"vo/npc/female01/pain09.wav"
};

-- Pain sounds

local function painSounds(client, attacker, health, damage)
	if damage > 3 then
		local sound;
	
		if client:Team() == TEAM_CITIZEN or client:Team() == TEAM_CWU or client:Team() == TEAM_ADMINISTRATOR or client:Team() == TEAM_CONSCRIPT then
			if string.find(client:GetModel(), "female") or string.find(client:GetModel(), "/f") then
				sound = painFemale[math.random(#painFemale)];
			else
				sound = painMale[math.random(#painMale)];
			end
		elseif client:Team() == TEAM_CP then
			sound = painCP[math.random(#painCP)];
		elseif client:Team() == TEAM_OVERWATCH then
			sound = painOTA[math.random(#painOTA)];
		elseif client:Team() == TEAM_VORT then
			sound = painVort[math.random(#painVort)];
		else
			sound = painMale[math.random(#painFemale)];
		end
		client:EmitSound(sound)
	end
end 
hook.Add("PlayerHurt", "[module] passive hurt voices", painSounds);

-- Death sounds

local function deathSounds(ply)
	if (ply:Team() == TEAM_CP and not ply:GetNWBool("noBiosignal")) then
		ply:EmitSound(deathSoundsCP[math.random(#deathSoundsCP)]);
	elseif (ply:Team() == TEAM_OVERWATCH) then 
		ply:EmitSound(deathSoundsOTA[math.random(#deathSoundsOTA)]);
	end 
	
	if ((ply:Team() == TEAM_CP and not ply:GetNWBool("noBiosignal")) or ply:Team() == TEAM_OVERWATCH) then 
		for _, cp in ipairs(player.GetAll()) do 
			if (cp:isCombine() and not cp:GetNWBool("noBiosignal")) and (cp != ply) then 
				cp:sendMsg({font = "RobotoMono24"}, Color(153, 0, 0), "Lost biosignal for protection team unit - " .. ply:GetName().." - All units BOL for 243 Suspect.");
				cp:EmitSound("npc/overwatch/radiovoice/lostbiosignalforunit.wav");
			end 
		end 
	end 
end 

hook.Add("DoPlayerDeath", "[module] passive death sounds", deathSounds);

-- Chat beep

util.AddNetworkString("combineChatBeep");

local function radioBeep( len, ply )
	if ( ply:isCombine() ) then 
		if not ( ply.alreadyBeeped ) then 
			ply.alreadyBeeped = true; 

			if ( ply:Team() == TEAM_CP ) then 
				ply:EmitSound( "npc/metropolice/vo/on" .. math.random( 1, 2 ) .. ".wav" );
			elseif ( ply:Team() == TEAM_OVERWATCH ) then 
				ply:EmitSound( "npc/combine_soldier/vo/on" .. math.random( 1, 2 ) .. ".wav" );
			end 
		else 
			ply.alreadyBeeped = nil;

			if ( ply:Team() == TEAM_CP ) then 
				ply:EmitSound( "npc/metropolice/vo/off" .. math.random( 1, 4 ) .. ".wav" );
			elseif ( ply:Team() == TEAM_OVERWATCH ) then 
				ply:EmitSound( "npc/combine_soldier/vo/off" .. math.random( 1, 3 ) .. ".wav" );
			end 
		end 
	end 
end

net.Receive( "combineChatBeep", radioBeep );

-- Changing up CP and OTA movement sounds.

local function movementSounds( ply, pos, foot, name, vol )
	if ( ply:IsSprinting() ) then 
		if ( ply:Team() == TEAM_CP ) then 
			ply:EmitSound( "npc/metropolice/gear" .. math.random( 1, 6 ) .. ".wav", 80 );

			return true;
		elseif ( ply:Team() == TEAM_OVERWATCH ) then 
			ply:EmitSound( "npc/combine_soldier/gear" .. math.random( 1, 6 ) .. ".wav", 90 );

			return true;
		elseif ( ply:Team() == TEAM_VORTIGAUNT ) then  
			ply:EmitSound( "npc/vort/vort_foot" .. math.random( 1, 4 ) .. ".wav", vol * 80 ); 

			return true;
		end 
	end 
end 

hook.Add( "PlayerFootstep", "hl2rp: movement sounds", movementSounds );