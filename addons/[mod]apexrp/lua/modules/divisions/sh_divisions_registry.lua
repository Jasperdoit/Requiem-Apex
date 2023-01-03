local function registry()
--------------------------------------------------------------------------
        -- Add divisions below.
    ---------------------------------------------------------------------------
    divisions.Data = {}
	DIVISION_UNION = divisions:Add( { 
        name = "UNION",
        model = "models/dpfilms/metropolice/hdpolice.mdl",
        desc = "The UNION division is the most common within the CP. Their job is to patrol the city and man checkpoints. They will often carry out searches of the apartment complex and other buildings. They the frontline of the CP, and all other divisions are designed to support them. This division may go rogue.",
        xp = 35,
        sc = 0,
		armor = 50,
        access = {
            [ TEAM_CP ] = true,
        },
        loadout = {
            "ls_stunbaton",
            "dradio",
            "weapon_cuff_elastic",
            "weapon_physgun",
            "weapon_physcannon",
            "gmod_tool",
        },
        ranks = {
            {    
                name = "RECRUIT",
                xp = 0,
                additional_sc = -1000,
                cangorogue = true,
            },
            {
                name = "00",
                xp = 25,
                additional_sc = 10,
                additional_loadout = {
                    "fl_usp"
                },
                cangorogue = true,
            },
            {
                name = "25",
                xp = 150,
                additional_sc = 15,
                cangorogue = true,
            },
            {
                name = "50",
                xp = 350,
                additional_sc = 20,
                additional_loadout = {
                    "fl_mp7"
                },
            },
            {
                name = "75",
                xp = 500,
                additional_sc = 25,
                additional_loadout = {
                    "gmod_flashbang"
                },
            },
            {
                name = "RL",
                xp = 1000,
                additional_sc = 35,
				additional_health = 0,
				additional_armor = 0,
                slots = 1,
                leader = true,
            }
        },
    } );
    
    DIVISION_HELIX = divisions:Add( { 
        name = "HELIX",
        model = "models/dpfilms/metropolice/civil_medic.mdl",
        desc = "The HELIX division is made up of medically trained units and are responsible for the general health of the city and Civil Protection. This division may go rogue.",
        xp = 300,
        sc = 0,
        armor = 40,
        access = {
            [ TEAM_CP ] = true,
        },
        loadout = {
            "ls_stunbaton",
            "dradio",
            "weapon_cuff_elastic",
            "weapon_medkit",
            "weapon_physgun",
            "weapon_physcannon",
            "gmod_tool",
        },
        ranks = {
            {    
                name = "RECRUIT",
                xp = 0,
                additional_sc = -1000,
                cangorogue = true,
            },
            {
                name = "00",
                xp = 25,
                additional_sc = 10,
                additional_loadout = {
                    "fl_usp"
                },
                cangorogue = true,
            },
            {
                name = "25",
                xp = 150,
                additional_sc = 15,
            },
            {
                name = "50",
                xp = 350,
                additional_sc = 20,
            },
            {
                name = "75",
                xp = 500,
                additional_sc = 25,
                additional_loadout = {
                    "fl_smg3"
                },
            },
            {
                name = "RL",
                xp = 1000,
                additional_sc = 35,
                slots = 1,
                leader = true,
            }
        },
    } );
	
	DIVISION_GRID = divisions:Add( { 
        name = "GRID",
        model = "models/dpfilms/metropolice/hl2concept.mdl",
        desc = "The GRID division are mechanics, responsible for the maintenance of the Universal Union's technology, vehicles, and weaponry. This division may go rogue.",
        xp = 400,
		armor = 40,
        sc = 0,
        access = {
            [ TEAM_CP ] = true,
        },
        loadout = {
            "ls_stunbaton",
            "dradio",
            "weapon_cuff_elastic",
            "weapon_physgun",
            "weapon_physcannon",
            "gmod_tool",
        },
        ranks = {
            {    
                name = "RECRUIT",
                xp = 0,
                additional_sc = -1000,
                cangorogue = true,
            },
            {
                name = "00",
                xp = 25,
                additional_sc = 10,
                additional_loadout = {
                    "fl_usp"
                },
                cangorogue = true,
            },
            {
                name = "25",
                xp = 150,
                additional_sc = 15,
                cangorogue = true,
            },
            {
                name = "50",
                xp = 350,
                additional_sc = 20,
                additional_loadout = {
                    "keypad_cracker",
                    "weapon_breachingcharge"
                },
            },
            {
                name = "75",
                xp = 500,
                additional_sc = 25,
                additional_loadout = {
                    "fl_smg3"
                },
            },
            {
                name = "RL",
                xp = 1000,
                additional_sc = 30,
				additional_armor = 0,
				additional_health = 0,
                slots = 1,
                leader = true,
            }
        },
    } );
	
	DIVISION_JURY = divisions:Add( { 
        name = "JURY",
        model = "models/dpfilms/metropolice/policetrench.mdl",
        desc = "The JURY division manages the Nexus prison, and is trained to interrogate captives. Their uniforms are often covered in the blood and viscera of their victims.",
        xp = 500,
        sc = 0,
		armor = 40,
        access = {
            [ TEAM_CP ] = true,
        },
        loadout = {
            "ls_stunbaton",
            "dradio",
            "weapon_cuff_elastic",
            "weapon_physgun",
            "weapon_physcannon",
            "gmod_tool",
        },
        ranks = {
            {    
                name = "RECRUIT",
                xp = 0,
                additional_sc = -1000,
                cangorogue = true,
            },
            {
                name = "00",
                xp = 25,
                additional_sc = 10,
                additional_loadout = {
                    "fl_usp"
                },
                cangorogue = true,
            },
            {
                name = "25",
                xp = 150,
                additional_sc = 15,
            },
                cangorogue = true,
            {
                name = "50",
                xp = 350,
                additional_sc = 20,
            },
            {
                name = "75",
                xp = 500,
                additional_sc = 25,
                additional_loadout = {
                    "fl_spas12"
                },
            },
            {
                name = "RL",
                xp = 1000,
                additional_sc = 35,
				additional_health = 0,
				additional_armor = 0,
                slots = 1,
                leader = true,
            }
        },
    } );
	
	DIVISION_SPEAR = divisions:Add( { 
        name = "SPEAR",
        model = "models/dpfilms/metropolice/elite_police.mdl",
        desc = "The SPEAR division is an elite division, tasked with patrolling 404 zones in small squads and locating rogue units. Members of SPEAR are highly trained and hardened by the harsh conditions of the 404 zones they patrol.",
        xp = 600,
        sc = 0,
        slots = 3,
		armor = 40,
        access = {
            [ TEAM_CP ] = true,
        },
        loadout = {
            "ls_stunbaton",
            "dradio",
            "weapon_cuff_elastic",
            "weapon_physgun",
            "weapon_physcannon",
            "gmod_tool",
        },
        ranks = {
            {    
                name = "RECRUIT",
                xp = 0,
                additional_sc = -1000,
            },
            {
                name = "00",
                xp = 25,
                additional_sc = 10,
                additional_loadout = {
                    "fl_usp"
                },
            },
            {
                name = "25",
                xp = 150,
                additional_sc = 15,
            },
            {
                name = "50",
                xp = 350,
                additional_sc = 20,
                additional_loadout = {
                    "fl_spas12"
                },
            },
            {
                name = "75",
                xp = 500,
                additional_sc = 25,
            },
            {
                name = "RL",
                xp = 1000,
                additional_sc = 35,
                slots = 1,
				additional_health = 0,
				additional_armor = 0,
                leader = true,
            }
        },
    } );
    
     DIVISION_COMMANDER = divisions:Add( { 
        name = "COMMANDER",
        model = "models/dpfilms/metropolice/police_bt.mdl",
        desc = "Acting as a Field Commander for the Universal Union's assets within the city, the Commander is often seen leading from the frontlines while reporting back to the Sectorial Commander.",
        xp = 2800,
        sc = 50,
		slots = 1,
		armor = 40,
        loadout = {
          	"dradio",
            "weapon_cuff_elastic",
            "weapon_physgun",
            "fl_mp7",
            "ls_stunbaton",
            "fl_usp",
            "weapon_physcannon",      
            "gmod_tool",
        },   
        access = {
            [ TEAM_CP ] = true,
        },
	} );

    DIVISION_SECTORIAL = divisions:Add( { 
        name = "SECTORIAL",
        model = "models/dpfilms/metropolice/phoenix_police.mdl",
        desc = "Much too valuable to be lost at the frontlines, the Sectorial Commander is responsible for the management and control of all Universal Union assets within the city.",
        xp = 1000,
        sc = 100,
		slots = 1,
		armor = 40,
        loadout = {
          	"dradio",
            "weapon_cuff_elastic",
            "weapon_physgun",
            "weapon_physcannon",      
            "fl_magnum",
            "gmod_tool",
        },   
        access = {
            [ TEAM_CP ] = true,
        },
		custom_check = function(ply)  
            if (SERVER) then 
                    local whitelisttable = util.JSONToTable(file.Read("whitelist.txt", "DATA"))
                    if not (whitelisttable[ply:SteamID()] and whitelisttable[ply:SteamID()] == true) then
                        ply:notify("You are not whitelisted to this Division!")
                        return false;
                    end 
                    
                    return true;
            else 
                return true;
            end 
        end
     } );
    
    if (SERVER) then 
        CreateConVar("rg_deploypcmd", 0)
    end 
    
     DIVISION_PCMD = divisions:Add( { 
        name = "PCMD",
        model = "models/dpfilms/metropolice/rtb_police.mdl",
        desc = "The planetary commander itself.",
        xp = 0,
        sc = 10000,
		slots = 0,
		armor = 250,
       	health = 250,
        loadout = {
        },   
        access = {
            [ TEAM_CP ] = true,
        },
		custom_check = function(ply)  
            if (SERVER) then 
                    return ply:IsSuperAdmin() and GetConVar("rg_deploypcmd"):GetInt() == 1;
            else 
                    return true;
            end 
        end
    } );
	
	DIVISION_ECHO = divisions:Add( { 
        name = "ECHO",
        model = "models/Combine_Soldier.mdl",
        desc = "ECHO are the footsoldiers of the OTA. They make up the bulk of the Universal Union's military forces on Earth, and often function in small squads of two or three units, led by an Elite unit.",
        xp = 600,
        sc = 0,
		armor = 100,
        access = {
            [ TEAM_OVERWATCH ] = true,
        },
        loadout = {
            "dradio",
            "weapon_cuff_elastic",
            "weapon_physgun",
            "weapon_physcannon",
            "gmod_tool",
        },
        ranks = {
            {
                name = "OWS",
                xp = 0,
                additional_sc = 25,
                additional_loadout = {
                    "fl_mp7",
                    "fl_usp",
                    "gmod_flashbang"
                },
            },
            {
                name = "EOW",
                xp = 300,
                additional_sc = 35,
                additional_armor = 25,
                additional_loadout = {
                    "fl_ar2",
                    "weapon_frag"
				},
                slots = 3,
            }
        },
    } );
	
	DIVISION_XRAY = divisions:Add( { 
        name = "X-RAY",
        model = "models/Combine_Soldier.mdl",
        desc = "X-RAY are OTA field medics, trained in treating transhuman soldiers for wounds sustained on the battlefield. They will often accompany a standard OTA squad, functioning as a field medic.",
        xp = 800,
        sc = 0,
		armor = 100,
        access = {
            [ TEAM_OVERWATCH ] = true,
        },
        loadout = {
            "dradio",
            "weapon_cuff_elastic",
            "weapon_medkit",
            "weapon_physgun",
            "weapon_physcannon",
            "gmod_tool",
        },
        ranks = {
            {
                name = "OWS",
                xp = 0,
                additional_sc = 25,
                additional_loadout = {
                    "fl_mp7",
                    "fl_usp",
                    "gmod_flashbang"
                },
            },
            {
                name = "EOW",
                xp = 300,
                additional_sc = 35,
                additional_armor = 25,
                additional_loadout = {
                    "weapon_frag"
				},
                slots = 3,
            }
        },
    } );
	
    DIVISION_RANGER = divisions:Add( { 
        name = "RANGER",
        model = "models/Combine_Soldier.mdl",
        desc = "The RANGER division are OTA trained in the use of sniper rifles and are intended to engage the enemy at long ranges. They will almost never accompany a squad and will mostly remain in vantage points with good sight lines.",
        xp = 1000,
        sc = 0,
		armor = 100,
        access = {
            [ TEAM_OVERWATCH ] = true,
        },
        loadout = {
            "dradio",
            "weapon_cuff_elastic",
            "weapon_physgun",
            "weapon_physcannon",
            "gmod_tool",
        },
        ranks = {
            {
                name = "OWS",
                xp = 0,
                additional_sc = 25,
                additional_loadout = {
                    "fl_cmbsniper",
                    "fl_usp",
                    "gmod_flashbang"
                },
            },
            {
                name = "EOW",
                xp = 300,
                additional_sc = 35,
                additional_armor = 25,
                additional_loadout = {
                    "weapon_frag"
				},
                slots = 3,
            }
        },
    } );
    
	DIVISION_MACE = divisions:Add( { 
        name = "MACE",
        model = "models/Combine_Soldier.mdl",
        desc = "MACE division are OTA trained and augmented to perform in extreme close quarters. They are specialists, and often only one will accompany a squad. MACE are trained to use aggressive tactics.",
        xp = 1200,
        sc = 0,
		armor = 125,
        skin = 1,
		health = 100,
        access = {
            [ TEAM_OVERWATCH ] = true,
        },
        loadout = {
            "dradio",
            "weapon_cuff_elastic",
            "weapon_breachingcharge",
            "weapon_physgun",
            "weapon_physcannon",
            "gmod_tool",
        },
        ranks = {
            {
                name = "OWS",
                xp = 0,
                additional_sc = 25,
                additional_loadout = {
                    "fl_spas12",
                    "fl_usp",
                    "gmod_flashbang"
                },
            },
            {
                name = "EOW",
                xp = 300,
                additional_sc = 35,
                additional_armor = 25,
                additional_loadout = {
                    "weapon_frag"
				},
                slots = 3,
            }
        },
    } );
	
	DIVISION_KING = divisions:Add( { 
        name = "KING",
        model = "models/combine_super_soldier.mdl",
        desc = "KING are elite OTA units, having been moved from other divisions due to their exemplary performance. KING are intimidating figures, feared even by their comrades in the CCA.",
        xp = 1400,
        sc = 0,
		armor = 150,
		health = 100,
        access = {
            [ TEAM_OVERWATCH ] = true,
        },
        loadout = {
            "dradio",
            "weapon_cuff_elastic",
            "weapon_physgun",
            "weapon_physcannon",
            "gmod_tool",
        },
        ranks = {
            {
                name = "EOW",
                xp = 0,
                additional_sc = 35,
                additional_loadout = {
                    "fl_ar2",
                     "fl_usp",
                    "weapon_frag"
				},
                slots = 3,
            }
        },
    } );
    
   
    DIVISION_STORM = divisions:Add( {
        name = "STORM",
        desc = "The STORM are the BNP of Overwatch. Theese guys are not to be messed with (they are even feared by KING's and the OWC). They only deploy when AJ is active or worse.",
        xp = 2000,
		sc = 200,
		armor = 250,
		health = 250,
        slots = 3,
        access = {
             [TEAM_OVERWATCH] = true,        
        },
        model = "models/combine_heavy.mdl",
        loadout = {
            "fl_pulse_mg",
           	"dradio",
            "weapon_cuff_elastic",
            "weapon_physgun",
            "weapon_physcannon", 
            "fl_ar2",
            "weapon_frag",
            "fl_magnum",
            "gmod_tool",
		},  
        custom_check = function(ply)
			if (SERVER) then 
                    return GetGlobalInt("code") >= 8 or ply:IsAdmin();
            else 
                    return true;
            end
		end 
    } );
   

	DIVISION_CONSCRIPT = divisions:Add( { 
        name = "CONSCRIPT",
        desc = "Conscripts are the trash of the Universal Union, being made up largely of conscripted pre-war military units. They are treated badly by their cohorts in the Civil Protection, and are typically given poor duties as a result.",
        xp = 35,
        sc = 0,
		armor = 30,
        access = {
            [ TEAM_CONSCRIPT ] = true,
        },
        loadout = {
            "ls_stunbaton",
            "dradio",
            "weapon_cuff_elastic",
            "weapon_physgun",
            "weapon_physcannon",
            "gmod_tool",
        },
        ranks = {
             {    
                name = "RECRUIT",
                xp = 0,
				model = "models/jessev92/hl2/conscripts/m02_npccit.mdl",
            },
            {    
                name = "PRIVATE",
                xp = 100,
				model = "models/jessev92/hl2/conscripts/m02_npccit.mdl",
                additional_loadout = {
                        "fl_usp"
                 },       
            },
            {
                name = "CORPORAL",
                xp = 200,
                additional_sc = 10,
				model = "models/jessev92/hl2/conscripts/m08_npccit.mdl",
                additional_loadout = {
                    "fl_smg3"
                },
            },
            {
                name = "SERGEANT",
                xp = 300,
                additional_sc = 15,
				model = "models/jessev92/hl2/conscripts/m07_npccit.mdl",
                additional_loadout = {
                    "gmod_flashbang"
                },
                slots = 2
            },
            {
                name = "CAPTAIN",
                xp = 500,
                additional_sc = 25,
				model = "models/jessev92/hl2/conscripts/m08_npccit.mdl",
                additional_loadout = {
                    "fl_m4a1"
                },
                slots = 1,
                leader = true,
            }
        },
    } );
    
    hook.Run("divisionsLoaded");
end 

timer.Simple(.1, registry)

local function registry()
    divisions.Tags = {}
    divisions.Vendor = {}
	divisions.Tags[TEAM_CP] = {"VICTOR", "VICE", "PATROL", "HERO", "QUICK", "DEFENDER", "TAP", "APEX", "KILO", "SWIFT", "ION", "LINE", "YELLOW", "UNIFORM", "ICE"};
	divisions.Tags[TEAM_OVERWATCH] = {"JUDGE", "GHOST", "REAPER", "HAMMER", "PAYBACK", "PHANTOM", "PRESSURE", "DASH", "SWORD", "NOVA", "SWEEPER", "DAGGER", "SHADOW", "BLADE", "STRIKER", "RAZOR"};
	divisions.Tags[-1] = {"VICTOR", "VICE", "PATROL", "HERO", "QUICK", "DEFENDER", "TAP", "APEX", "KILO", "SWIFT", "ION", "LINE", "YELLOW", "UNIFORM", "ICE", "JUDGE", "GHOST", "REAPER", "HAMMER", "PAYBACK", "PHANTOM", "PRESSURE", "DASH", "SWORD", "NOVA", "SWEEPER", "DAGGER", "SHADOW", "BLADE", "STRIKER", "RAZOR"};
	
	divisions.Vendor = {
		{ name = "Improved Kevlar Vest", class = function(ply) ply:SetMaxArmor(ply:GetMaxArmor() + 15); ply:SetArmor(ply:GetMaxArmor()); end, cost = 30, model = "models/pac3/cmbarmor_chest.mdl", },
		{ name = "Colt Magnum", class = "fl_magnum", cost = 45, model = "models/weapons/w_357.mdl", },
        { name = "MP5K", class = "fl_smg3", cost = 15, model = "models/weapons/apexwep/w_mp5.mdl", },
		{ name = "MP7", class = "fl_mp7", cost = 15, model = "models/weapons/w_smg1.mdl", },
        --{ name = "O.I.C.W", class = "fl_oicw", cost = 20, model = "models/weapons/tfa_misc/w_oicw.mdl"},
		{ name = "SPAS-12", class = "fl_spas12", cost = 30, model = "models/weapons/w_shotgun.mdl", },
		{ name = "USP", class = "fl_usp", cost = 5, model = "models/weapons/apexwep/w_pistol.mdl", },
		{ name = "Frag Grenade", class = "weapon_frag", cost = 30, model = "models/weapons/w_grenade.mdl", },
		{ name = "Flashbang", class = "gmod_flashbang", cost = 15, model = "models/weapons/w_eq_flashbang.mdl", },
		{ name = "Health Vial", class = "weapon_healthvial", cost = 5, model = "models/healthvial.mdl", },
		{ name = "Breaching Charge", class = "weapon_breachingcharge", cost = 15, model = "models/minic23/csgo/breach_charge.mdl", },
        { name = "Combine Mine", class = "fl_cmbmine", cost = 30, model = "models/props_combine/combine_mine01.mdl", },
	};
end

hook.Add("divisionsLoaded", "[divisions] Load Vendor", registry)