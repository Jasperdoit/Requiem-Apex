ENT.Base = "base_ai" -- This entity is based on "base_ai"
ENT.Type = "ai" -- What type of entity is it, in this case, it's an AI.
ENT.PrintName		= "Rebel NPC"
ENT.Author			= "Nuke"
ENT.Contact			= "N/A"
ENT.Purpose			= "ATM Banker"
ENT.Instructions	= "Press E"
ENT.Category 		= "Universal Union"

ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.AutomaticFrameAdvance = true -- This entity will animate itself.
 

RebelRanks = {}
RebelDivision = {}
RebelRanks[1] = {
		id = 1,
		name = "Junior Rebel",
		description = [[Name: Junior Rebel (Junior)
Description:
The Junior Rebels are individuals who have just joined
the lambda resistance and are looking to climb up
the ranks]],
		xp = 35
}

RebelRanks[2] = {
		id = 2,
		name = "Senior Rebel",
		description = [[Name: Senior Rebels (Senior)
Description: 
Senior rebels are experienced members of the lambda
resistance who have fought for a long time ]],
		xp = 600
}

RebelRanks[3] = {
		id = 3,
		name = "CpL",
		description = [[Name: Corporal (CpL)
Description: 
Corporals are units within the Lambda Resistance that have proven
themselves enough to be trusted to perform the majority of duties, and as such
have been issued with basic weaponry.]],
		xp = 150
}

RebelRanks[4] = {
		id = 4,
		name = "Cpt",
		description = [[Name: Captain (Cpt)
Description: 
Captains are units within the Lambda Resistance that have proven
themselves to be capable of performing their duties to a high standard. 
Due to their performance, they have been issued with better weaponry.]],
		xp = 300
}

RebelRanks[5] = {
		id = 5,
		name = "Brig",
		description = [[Name: Brigadier (Brig)
Description: 
Brigadiers are senior units within the Lambda Resistance that have
shown their dedication to the Lambda Resistance's cause. To this end,
they have been issued with more advanaced equipment than other units.]],
		xp = 425
}

RebelRanks[6] = {
		id = 6,
		name = "Generals",
		description = [[Name: Generals (General)
Description: 
Generals are the senior-most Lambda Resistance units outside
of the General and Field Marshal. They are responsible 
for leading a singular division within the Lambda Resistance]],
		xp = 600
}

RebelDivision[1] = {
		id = 1,
		name = "INFANTRY",
		weapons = {},
		bodygroups = {
			[1] = {32, 33, 36, 37},
			[2] = {0, 1, 2, 3, 4, 6, 10, 11, 12, 14},
			[4] = {0, 1, 2, 3, 4},
		},
		description = [[Name: INFANTRY
Description: 
The INFANTRY division is main unit of the Lambda Resistance. Their job 
is to scout ahead and identify enemy positions. They will often carry 
out searches of the apartment complex and other buildings. They 
are the eyes and ears of the resistance, and all other divisions rely
on them.]],
		max = 64,
		xp = 35
}
RebelDivision[1].weapons[1] = {"fl_usp", "weapon_crowbar","lockpick"}
RebelDivision[1].weapons[2] = {"fl_usp", "weapon_cuff_elastic", "fl_ak"}

RebelDivision[2] = {
		id = 2,
		name = "MEDIC",
		weapons = {},
		bodygroups = {
			[1] = {26, 27, 30, 31},
			[2] = {12, 14},
			[3] = {0, 1, 2},
			[4] = {0, 1, 2, 3, 4},
		},
		description = [[Name: MEDIC
Description: 
The MEDIC division is made up of medically trained units and are 
responsible for the general health of the Lambda Resistance. MEDIC's
often use CWU medics as assistants and frequently set up health centres
to treat the injured and unwell. MEDIC units are able to provide 
additional medical supplies to those that require them, in exchange for 
tokens. Individual MEDIC units often join up with other Resistance 
Divisons and in order to function as a field medic.]],
		max = 10,
		xp = 60
}

RebelDivision[2].weapons[1] = {"weapon_crowbar", "fl_usp", "weapon_disposal_medkit"}
RebelDivision[2].weapons[2] = {"weapon_cuff_elastic","weapon_medkit", "fl_smg3"}

RebelDivision[3] = {
		id = 3,
		name = "ENGINEER",
		weapons = {},
		bodygroups = {
			[1] = {29, 32, 33},
			[2] = {12, 13, 14},
			[3] = {0, 1, 2},
			[4] = 9,
			[13] = 1,
			[14] = 1,
		},
		description = [[Name: ENGINEER
Description: 
The ENGINEER division are mechanics, responsible for the maintenance 
of the Lambda Resistance's technology, vehicles and weaponry. 
The main role of ENGINEER units is to provide mechanical 
and technological support of other divisions.]],
		max = 6,
		xp = 100
}

RebelDivision[3].weapons[1] = {"weapon_crowbar", "fl_usp"}
RebelDivision[3].weapons[2] = {"fl_usp", "weapon_cuff_elastic", "alyx_emptool", "lockpick", "keypad_cracker", "fl_smg3"}

RebelDivision[4] = {
		id = 4,
		name = "MARKSMAN",
		weapons = {},
		bodygroups = {
			[1] = 35,
			[2] = 15,
			[3] = {0, 1, 2},
			[4] = 3,
			[15] = 1,
		},
		description = [[Name: MARKSMAN
Description: 
The MARKSMAN divions is resonsible for long range combat within
the Lambda Resistance. They specialise in fighting over long ranges
and keeping the enemy suppressed with powerful but slow firing weapons.]],
		max = 8,
		xp = 200
}

RebelDivision[4].weapons[1] = {"weapon_crowbar", "fl_usp"}
RebelDivision[4].weapons[2] = {"fl_usp", "weapon_cuff_elastic", "fl_mosin"}


--RebelDivision[5] = {
--		id = 5,
--		name = "RAZOR",
--		model = "models/dpfilms/metropolice/playermodels/pm_urban_police.mdl",
--		weapons = {},
--		description = [[Name: RAZOR
--Description: 
--Razor units are the most elite Civil Protection Ground Units for 
--Close/Medium range combat and are deadly in squads against unarmoured 
--opponents. Razor's primary objectives are to eliminate insurgent 
--(rebel) presence within the districts. Razor Units are however 
--commonly ordered to guard district checkpoints such as the District 6 
--entrance. 

-- You CANNOT go rogue! --
--Max Units: 4]],
--		max = 4,
--		xp = 600
--}	

--RebelDivision[5].weapons[1] = {"stunstick"}
--RebelDivision[5].weapons[2] = {"ironsight_pistol", "weapon_r_handcuffs"}
--RebelDivision[5].weapons[3] = {"weapon_shotgun", "weapon_ar2", "weapon_smg1"}

RebelDivision[5] = {
		id = 5,
		name = "SHOTGUNNER",
		weapons = {},
		bodygroups = {
			[1] = {29, 30, 31, 32, 33},
			[2] = {12, 13, 14},
			[3] = {0, 1, 2},
			[4] = {1, 2, 4},
			[11] = 5,
			[14] = 1,
		},
		description = [[Name: SHOTGUNNER
Description: 
The SHOTGUNNER division is an elite division, tasked with fast
hard hitting shotguns. They are specialists in close quaters
combat and as such attract rather extreme individuals.]],
		max = 6,
		xp = 500
}

RebelDivision[5].weapons[1] = {"weapon_crowbar"}
RebelDivision[5].weapons[1] = {"weapon_cuff_elastic", "fl_spas12", "fl_usp", "door_ram"}

RebelDivision[6] = {
		id = 6,
		name = "GENERAL",
		weapons = {},
		bodygroups = {
			[1] = 37,
			[2] = 13,
			[3] = {0, 1, 2},
			[4] = 5	,
			[11] = 4,
		},
		description = [[Name: GENERAL
Description: 
The GENERAL is the field commander of the Lambda Resistance Forces. 
He is responsible for ensuring the Field Marshal's instructions 
are respected and obeyed within the Resistance. 
When there is no FIELD MARSHAL available, they are considered 
leaders of the Resistance. ]],
		xp = 1000,
		max = 5
}

RebelDivision[6].weapons[1] = {"weapon_crowbar", "fl_usp", "fl_mp7", "weapon_cuff_elastic","door_ram"}

RebelDivision[7] = {
		id = 7,
		name = "FIELD MARSHAL",
		weapons = {},
		bodygroups = {
			[1] = 35,
			[2] = 15,
			[3] = {0, 1, 2},
			[4] = 8	,
			[11] = 4,
			[14] = 1,
		},
		description = [[Name: FIELD MARSHAL
Description: 
The FIELD MARSHAL is the commanding officer of a sectors
Lambda Resistance forces.The FIELD MARSHAL has the final 
say on anything Resistance related and has undergone
extensive trainning. He is harder and smarter than 
any other Resistance units and is a fearsome. ]],
		xp = 1500,
		max = 5

}

RebelDivision[7].weapons[1] = {"weapon_crowbar","fl_magnum", "fl_mp7", "weapon_cuff_elastic"}

function ENT:SetAutomaticFrameAdvance( bUsingAnim ) -- This is called by the game to tell the entity if it should animate itself.
	self.AutomaticFrameAdvance = bUsingAnim
end

-- Since this file is ran by both the client and the server, both will share this information.