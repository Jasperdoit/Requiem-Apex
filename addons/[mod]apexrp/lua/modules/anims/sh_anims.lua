--if (anim) then return; end 

anim = {}

anim.citizen_male = {
    normal = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_LOW, ACT_COVER_LOW},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN},
		[ACT_LAND] = {ACT_RESET, ACT_RESET}
	},
	pistol = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_RANGE_ATTACK_PISTOL},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_LOW, ACT_RANGE_ATTACK_PISTOL_LOW},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		[ACT_LAND] = {ACT_RESET, ACT_RESET},
		attack = ACT_GESTURE_RANGE_ATTACK_PISTOL,
		reload = ACT_RELOAD_PISTOL
	},
	smg = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_SMG1_RELAXED, ACT_IDLE_ANGRY_SMG1},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_LOW, ACT_RANGE_AIM_SMG1_LOW},
		[ACT_MP_WALK] = {ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH_RIFLE, ACT_WALK_CROUCH_AIM_RIFLE},
		[ACT_MP_RUN] = {ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED},
		[ACT_LAND] = {ACT_RESET, ACT_RESET},
		attack = ACT_GESTURE_RANGE_ATTACK_SMG1,
		reload = ACT_GESTURE_RELOAD_SMG1
	},
	shotgun = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_SHOTGUN_RELAXED, ACT_IDLE_ANGRY_SMG1},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_LOW, ACT_RANGE_AIM_SMG1_LOW},
		[ACT_MP_WALK] = {ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH_RIFLE, ACT_WALK_CROUCH_RIFLE},
		[ACT_MP_RUN] = {ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED},
		[ACT_LAND] = {ACT_RESET, ACT_RESET},
		attack = ACT_GESTURE_RANGE_ATTACK_SHOTGUN
	},
	grenade = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE_MANNEDGUN},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_LOW, ACT_RANGE_AIM_SMG1_LOW},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN_RIFLE_STIMULATED},
		[ACT_LAND] = {ACT_RESET, ACT_RESET},
		attack = ACT_RANGE_ATTACK_THROW
	},
	melee = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_LOW, ACT_COVER_LOW},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN},
		[ACT_LAND] = {ACT_RESET, ACT_RESET},
		attack = ACT_MELEE_ATTACK_SWING
	},
	glide = ACT_GLIDE,
	vehicle = {
		["prop_vehicle_prisoner_pod"] = {"podpose", Vector(-3, 0, 0)},
		["prop_vehicle_jeep"] = {ACT_BUSY_SIT_CHAIR, Vector(14, 0, -14)},
		--["prop_vehicle_airboat"] = {ACT_BUSY_SIT_CHAIR, Vector(28, 0, -20)},
		--chair = {ACT_BUSY_SIT_CHAIR, Vector(1, 0, -23)}
	},
}

anim.citizen_female = {
	normal = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_LOW, ACT_COVER_LOW},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN}

	},
	pistol = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_RANGE_ATTACK_PISTOL},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_LOW, ACT_COVER_LOW},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack = ACT_GESTURE_RANGE_ATTACK_PISTOL,
		reload = ACT_RELOAD_PISTOL
	},
	smg = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_SMG1_RELAXED, ACT_IDLE_ANGRY_SMG1},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_LOW, ACT_COVER_LOW},
		[ACT_MP_WALK] = {ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH_RIFLE, ACT_WALK_CROUCH_AIM_RIFLE},
		[ACT_MP_RUN] = {ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack = ACT_GESTURE_RANGE_ATTACK_SMG1,
		reload = ACT_GESTURE_RELOAD_SMG1
	},

	shotgun = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_SHOTGUN_RELAXED, ACT_IDLE_ANGRY_SMG1},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_LOW, ACT_COVER_LOW},
		[ACT_MP_WALK] = {ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH_RIFLE, ACT_WALK_CROUCH_RIFLE},
		[ACT_MP_RUN] = {ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack = ACT_GESTURE_RANGE_ATTACK_SHOTGUN,
	},
	grenade = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE_MANNEDGUN},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_LOW, ACT_COVER_LOW},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN_RIFLE_STIMULATED},
		attack = ACT_RANGE_ATTACK_THROW
	},
	melee = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_SUITCASE, ACT_IDLE_ANGRY_MELEE},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_LOW, ACT_COVER_LOW},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN},
		attack = ACT_MELEE_ATTACK_SWING
	},
	glide = ACT_GLIDE,
	vehicle = {
		["prop_vehicle_prisoner_pod"] = {"podpose", Vector(-3, 0, 0)},
		["prop_vehicle_jeep"] = {ACT_BUSY_SIT_CHAIR, Vector(14, 0, -14)},
		--["prop_vehicle_airboat"] = {ACT_BUSY_SIT_CHAIR, Vector(28, 0, -20)},
		--chair = {ACT_BUSY_SIT_CHAIR, Vector(1, 0, -23)}
	},
}
anim.metrocop = {
	normal = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_PISTOL_LOW, ACT_COVER_PISTOL_LOW},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN}
	},
	pistol = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_PISTOL, ACT_IDLE_ANGRY_PISTOL},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_PISTOL_LOW, ACT_COVER_PISTOL_LOW},
		[ACT_MP_WALK] = {ACT_WALK_PISTOL, ACT_WALK_AIM_PISTOL},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		[ACT_MP_RUN] = {ACT_RUN_PISTOL, ACT_RUN_AIM_PISTOL},
		attack = ACT_GESTURE_RANGE_ATTACK_PISTOL,
		reload = ACT_GESTURE_RELOAD_PISTOL
	},
	smg = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_SMG1, ACT_IDLE_ANGRY_SMG1},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_SMG1_LOW, ACT_COVER_SMG1_LOW},
		[ACT_MP_WALK] = {ACT_WALK_RIFLE, ACT_WALK_AIM_RIFLE},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		[ACT_MP_RUN] = {ACT_RUN_RIFLE, ACT_RUN_AIM_RIFLE}
	},
	shotgun = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_SMG1, ACT_IDLE_ANGRY_SMG1},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_SMG1_LOW, ACT_COVER_SMG1_LOW},
		[ACT_MP_WALK] = {ACT_WALK_RIFLE, ACT_WALK_AIM_RIFLE},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		[ACT_MP_RUN] = {ACT_RUN_RIFLE, ACT_RUN_AIM_RIFLE}
	},
	grenade = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_PISTOL_LOW, ACT_COVER_PISTOL_LOW},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_ANGRY},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN},
		attack = ACT_COMBINE_THROW_GRENADE
	},
	melee = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_PISTOL_LOW, ACT_COVER_PISTOL_LOW},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_ANGRY},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN},
		attack = ACT_MELEE_ATTACK_SWING_GESTURE
	},
	glide = ACT_GLIDE,
	vehicle = {
		chair = {ACT_COVER_PISTOL_LOW, Vector(5, 0, -5)},
		["prop_vehicle_airboat"] = {ACT_COVER_PISTOL_LOW, Vector(10, 0, 0)},
		["prop_vehicle_jeep"] = {ACT_COVER_PISTOL_LOW, Vector(18, -2, 4)},
		["prop_vehicle_prisoner_pod"] = {ACT_IDLE, Vector(-4, -0.5, 0)}
	}
}
anim.overwatch = {
	normal = {
		[ACT_MP_STAND_IDLE] = {"idle_unarmed", "idle_unarmed"},
		[ACT_MP_CROUCH_IDLE] = {ACT_CROUCHIDLE, ACT_CROUCHIDLE},
		[ACT_MP_WALK] = {"walkunarmed_all", "walkunarmed_all"},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH_RIFLE, ACT_WALK_CROUCH_RIFLE},
		[ACT_MP_RUN] = {ACT_RUN_AIM_RIFLE, ACT_RUN_AIM_RIFLE},
		[ACT_LAND] = {ACT_RESET, ACT_RESET}
	},
	pistol = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_PISTOL, ACT_IDLE_ANGRY_PISTOL},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_PISTOL_LOW, ACT_COVER_PISTOL_LOW},
		[ACT_MP_WALK] = {ACT_WALK_PISTOL, ACT_WALK_AIM_PISTOL},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH_RIFLE, ACT_WALK_CROUCH_RIFLE},
		[ACT_MP_RUN] = {ACT_RUN_PISTOL, ACT_RUN_AIM_PISTOL},
		attack = ACT_GESTURE_RANGE_ATTACK_PISTOL,
		reload = ACT_GESTURE_RELOAD_PISTOL
	},
	smg = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_SMG1, ACT_IDLE_ANGRY_SMG1},
		[ACT_MP_CROUCH_IDLE] = {ACT_CROUCHIDLE, ACT_CROUCHIDLE},
		[ACT_MP_WALK] = {ACT_WALK_RIFLE, ACT_WALK_AIM_RIFLE},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH_RIFLE, ACT_WALK_CROUCH_RIFLE},
		[ACT_MP_RUN] = {ACT_RUN_RIFLE, ACT_RUN_AIM_RIFLE}
	},
	shotgun = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_SMG1, ACT_IDLE_ANGRY_SHOTGUN},
		[ACT_MP_CROUCH_IDLE] = {ACT_CROUCHIDLE, ACT_CROUCHIDLE},
		[ACT_MP_WALK] = {ACT_WALK_RIFLE, ACT_WALK_AIM_SHOTGUN},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH_RIFLE, ACT_WALK_CROUCH_RIFLE},
		[ACT_MP_RUN] = {ACT_RUN_RIFLE, ACT_RUN_AIM_SHOTGUN}
	},
	grenade = {
		[ACT_MP_STAND_IDLE] = {"idle_unarmed", ACT_IDLE_ANGRY},
		[ACT_MP_CROUCH_IDLE] = {ACT_CROUCHIDLE, ACT_CROUCHIDLE},
		[ACT_MP_WALK] = {"walkunarmed_all", ACT_WALK_RIFLE},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH_RIFLE, ACT_WALK_CROUCH_RIFLE},
		[ACT_MP_RUN] = {ACT_RUN_AIM_RIFLE, ACT_RUN_AIM_RIFLE}
	},
	melee = {
		[ACT_MP_STAND_IDLE] = {"idle_unarmed", ACT_IDLE_ANGRY},
		[ACT_MP_CROUCH_IDLE] = {ACT_CROUCHIDLE, ACT_CROUCHIDLE},
		[ACT_MP_WALK] = {"walkunarmed_all", ACT_WALK_RIFLE},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH_RIFLE, ACT_WALK_CROUCH_RIFLE},
		[ACT_MP_RUN] = {ACT_RUN_AIM_RIFLE, ACT_RUN_AIM_RIFLE},
		attack = ACT_MELEE_ATTACK_SWING_GESTURE
	},
	glide = ACT_GLIDE,
	vehicle = {
		chair = {ACT_CROUCHIDLE, Vector(5, 0, -5)},
		["prop_vehicle_airboat"] = {ACT_CROUCHIDLE, Vector(10, 0, 0)},
		["prop_vehicle_jeep"] = {ACT_CROUCHIDLE, Vector(18, -2, 4)},
        ["sim_fphys_combineapc_armed"] = {ACT_CROUCHIDLE, Vector(18, -2, 4)},
		["prop_vehicle_prisoner_pod"] = {ACT_CROUCHIDLE, Vector(-4, -0.5, 0)}
	}
}
anim.vort = {
	melee = {
		["attack"] = ACT_MELEE_ATTACK1,
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, "ActionIdle"},
		[ACT_MP_CROUCH_IDLE] = {"crouchidle", "crouchidle"},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN_AIM},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_AIM},
	},
	grenade = {
		["attack"] = ACT_MELEE_ATTACK1,
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_ANGRY, ACT_IDLE_ANGRY},
		[ACT_MP_CROUCH_IDLE] = {"crouchidle", "crouchidle"},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK}
	},
	normal = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_CROUCH_IDLE] = {"crouchidle", "crouchidle"},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK},
		["attack"] = ACT_MELEE_ATTACK1
	},
	pistol = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_ANGRY, ACT_IDLE_ANGRY,},
		[ACT_MP_CROUCH_IDLE] = {"crouchidle", "crouchidle"},
		["reload"] = ACT_IDLE,
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK},
        --["attack"] = "Zapattack1"
	},
	shotgun = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, "TCidlecombat"},
		[ACT_MP_CROUCH_IDLE] = {"crouchidle", "crouchidle"},
		["reload"] = ACT_IDLE,
		[ACT_MP_RUN] = {ACT_RUN, "run_all_TC"},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_WALK] = {ACT_WALK, "Walk_all_TC"}
	},
	smg = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_SMG1, ACT_IDLE_ANGRY_SMG1},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_SMG1_LOW, ACT_COVER_SMG1_LOW},
		[ACT_MP_WALK] = {ACT_WALK_RIFLE, ACT_WALK_AIM_RIFLE},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		[ACT_MP_RUN] = {ACT_RUN_RIFLE, ACT_RUN_AIM_RIFLE}
	},
	beam = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_ANGRY, ACT_IDLE_ANGRY},
		[ACT_MP_CROUCH_IDLE] = {"crouchidle", "crouchidle"},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN_AIM},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_AIM},
		["attack"] = ACT_GESTURE_RANGE_ATTACK1,
		["reload"] = ACT_IDLE,
		["glide"] = {ACT_RUN, ACT_RUN}
	},
	glide = ACT_GLIDE,
}
anim.player = {
	normal = {
		[ACT_MP_STAND_IDLE] = ACT_HL2MP_IDLE,
		[ACT_MP_CROUCH_IDLE] = ACT_HL2MP_IDLE_CROUCH,
		[ACT_MP_WALK] = ACT_HL2MP_WALK,
		[ACT_MP_RUN] = ACT_HL2MP_RUN
	},
	passive = {
		[ACT_MP_STAND_IDLE] = ACT_HL2MP_IDLE_PASSIVE,
		[ACT_MP_WALK] = ACT_HL2MP_WALK_PASSIVE,
		[ACT_MP_CROUCHWALK] = ACT_HL2MP_WALK_CROUCH_PASSIVE,
		[ACT_MP_RUN] = ACT_HL2MP_RUN_PASSIVE
	}
}
anim.zombie = {
	[ACT_MP_STAND_IDLE] = ACT_HL2MP_IDLE_ZOMBIE,
	[ACT_MP_CROUCH_IDLE] = ACT_HL2MP_IDLE_CROUCH_ZOMBIE,
	[ACT_MP_CROUCHWALK] = ACT_HL2MP_WALK_CROUCH_ZOMBIE_01,
	[ACT_MP_WALK] = ACT_HL2MP_WALK_ZOMBIE_02,
	[ACT_MP_RUN] = ACT_HL2MP_RUN_ZOMBIE
}
anim.fastZombie = {
	[ACT_MP_STAND_IDLE] = ACT_HL2MP_WALK_ZOMBIE,
	[ACT_MP_CROUCH_IDLE] = ACT_HL2MP_IDLE_CROUCH_ZOMBIE,
	[ACT_MP_CROUCHWALK] = ACT_HL2MP_WALK_CROUCH_ZOMBIE_05,
	[ACT_MP_WALK] = ACT_HL2MP_WALK_ZOMBIE_06,
	[ACT_MP_RUN] = ACT_HL2MP_RUN_ZOMBIE_FAST
}

local translations = translations or {};

function anim.setModelClass(model, class)
	if (!anim[class]) then
		error("'"..tostring(class).."' is not a valid animation class!")
	end
	
	translations[model:lower()] = class
end

-- Add models to have NPC animations below 

--[[
giving models npc animations
]]

anim.setModelClass( "models/police.mdl", "metrocop" );
anim.setModelClass( "models/dpfilms/metropolice/hdpolice.mdl", "metrocop" );
anim.setModelClass( "models/dpfilms/metropolice/civil_medic.mdl", "metrocop" );
anim.setModelClass( "models/dpfilms/metropolice/policetrench.mdl", "metrocop" );
anim.setModelClass( "models/dpfilms/metropolice/pm_phoenix_police.mdl", "metrocop" );
anim.setModelClass( "models/dpfilms/metropolice/pm_tron_police_or.mdl", "metrocop" );
--anim.setModelClass( "models/vortigaunt_slave.mdl", "metrocop" );
anim.setModelClass( "models/combine_super_soldier.mdl", "overwatch" );
anim.setModelClass( "models/ar_combine_soldier03b.mdl", "overwatch" );
anim.setModelClass( "models/combine_soldier_prisonGuard.mdl", "overwatch" );
anim.setModelClass( "models/combine_soldier.mdl", "overwatch" );
anim.setModelClass( "models/romka_npcs/romka/romka_combine_soldier.mdl", "overwatch" );
anim.setModelClass( "models/romka_npcs/romka/romka_combine_super_soldier.mdl", "overwatch" );
anim.setModelClass( "models/romka_npcs/romka/rtb_elite.mdl", "overwatch" );
anim.setModelClass( "models/synth/elite_green.mdl", "overwatch" );
anim.setModelClass( "models/synth/elite_brown.mdl", "overwatch" );
anim.setModelClass( "models/vortigaunt.mdl", "vort" );
anim.setModelClass( "models/vortigaunt_blue.mdl", "vort" );
anim.setModelClass( "models/vortigaunt_doctor.mdl", "vort" );
anim.setModelClass( "models/vortigaunt_slave.mdl", "vort" );
anim.setModelClass( "models/Humans/Group01/Male_01.mdl", "citizen_male" );
anim.setModelClass( "models/Humans/Group01/male_02.mdl", "citizen_male" );
anim.setModelClass( "models/Humans/Group01/male_03.mdl", "citizen_male" );
anim.setModelClass( "models/Humans/Group01/Male_04.mdl", "citizen_male" );
anim.setModelClass( "models/Humans/Group01/Male_05.mdl", "citizen_male" );
anim.setModelClass( "models/Humans/Group01/male_06.mdl", "citizen_male" );
anim.setModelClass( "models/Humans/Group01/male_07.mdl", "citizen_male" );
anim.setModelClass( "models/Humans/Group01/male_08.mdl", "citizen_male" );
anim.setModelClass( "models/Humans/Group01/male_09.mdl", "citizen_male" );
anim.setModelClass( "models/Humans/Group01/Male_Cheaple.mdl", "citizen_male" );
anim.setModelClass( "models/Humans/Group01/Female_01.mdl", "citizen_female" );
anim.setModelClass( "models/Humans/Group01/Female_02.mdl", "citizen_female" );
anim.setModelClass( "models/Humans/Group01/Female_03.mdl", "citizen_female" );
anim.setModelClass( "models/Humans/Group01/Female_06.mdl", "citizen_female" );
anim.setModelClass( "models/Humans/Group01/Female_07.mdl", "citizen_female" );

-- Micro-optimization since the get class function gets called a lot.
local stringLower = string.lower
local stringFind = string.find

function anim.getModelClass(model)
	model = stringLower(model)
	local class = translations[model]

	if (!class and stringFind(model, "/player")) then
		return "player"
	end

	class = class or "citizen_male"

	if (class == "citizen_male" and (stringFind(model, "female") or stringFind(model, "alyx") or stringFind(model, "mossman"))) then
		class = "citizen_female"
	end
	
	return class
end

do
	if ( SERVER ) then 
		util.AddNetworkString( "animSequence" );
	end 

	local playerMeta = FindMetaTable("Player")

	function playerMeta:forceSequence(sequence, callback, time, noFreeze)
		hook.Run("OnPlayerEnterSequence", self, sequence, callback, time, noFreeze)

		if (!sequence) then
			--if ( SERVER ) then 
				net.Start( "animSequence" );
					net.WriteEntity( self );
					net.WriteBool(true)
					net.WriteUInt(0, 16)
				net.Broadcast();
			---end 

			return;
		end

		local sequence = self:LookupSequence(sequence)

		if (sequence and sequence > 0) then
			time = time or self:SequenceDuration(sequence)

			self.nutSeqCallback = callback
			self.nutForceSeq = sequence

			if (!noFreeze) then
				self:SetMoveType(MOVETYPE_NONE)
			end

			if (time > 0) then
				timer.Create("nutSeq"..self:EntIndex(), time, 1, function()
					if (IsValid(self)) then
						self:leaveSequence()
					end
				end)
			end

			--if ( SERVER ) then 
				net.Start( "animSequence" );
					net.WriteEntity( self );
					net.WriteBool( false );
					net.WriteUInt( sequence, 16 );
					if ( time ) then 
						net.WriteUInt( time, 16 );
					end 
				net.Broadcast();
			--end 

			return time
		end

		return false
	end

	function playerMeta:leaveSequence()
		hook.Run("OnPlayerLeaveSequence", self)

		if ( SERVER ) then 
	 		net.Start( "animSequence" );
				net.WriteEntity( self );
				net.WriteBool( true );
				net.WriteUInt( 0, 16 );
			net.Broadcast();
		end

		self:SetMoveType(MOVETYPE_WALK)
		self.nutForceSeq = nil

		if (self.nutSeqCallback) then
			self:nutSeqCallback()
		end
	end

	if (CLIENT) then
		net.Receive( "animSequence", function()
			local entity = net.ReadEntity();
			local reset = net.ReadBool();
			local sequence = net.ReadUInt( 16 );
			local time = net.ReadUInt( 16 );

			if ( IsValid( entity ) ) then
				if ( reset ) then
					entity.nutForceSeq = nil;
					return
				end

				entity:SetCycle( 0 );
				entity:SetPlaybackRate( 1 );
				entity.nutForceSeq = sequence;

				if (time > 0) then
					timer.Create("nutSeq"..entity:EntIndex(), time, 1, function()
						if ( IsValid( entity ) ) then
							entity:leaveSequence()
						end
					end)
				end
			end
		end );
	end
end

HOLDTYPE_TRANSLATOR = {}
HOLDTYPE_TRANSLATOR[""] = "normal"
HOLDTYPE_TRANSLATOR["physgun"] = "smg"
HOLDTYPE_TRANSLATOR["ar2"] = "smg"
HOLDTYPE_TRANSLATOR["crossbow"] = "shotgun"
HOLDTYPE_TRANSLATOR["rpg"] = "shotgun"
HOLDTYPE_TRANSLATOR["slam"] = "normal"
HOLDTYPE_TRANSLATOR["grenade"] = "grenade"
HOLDTYPE_TRANSLATOR["fist"] = "normal"
HOLDTYPE_TRANSLATOR["melee2"] = "melee"
HOLDTYPE_TRANSLATOR["passive"] = "normal"
HOLDTYPE_TRANSLATOR["knife"] = "melee"
HOLDTYPE_TRANSLATOR["duel"] = "pistol"
HOLDTYPE_TRANSLATOR["camera"] = "smg"
HOLDTYPE_TRANSLATOR["magic"] = "normal"
HOLDTYPE_TRANSLATOR["revolver"] = "pistol"

PLAYER_HOLDTYPE_TRANSLATOR = {}
PLAYER_HOLDTYPE_TRANSLATOR[""] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["fist"] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["pistol"] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["grenade"] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["melee"] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["slam"] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["melee2"] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["passive"] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["knife"] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["duel"] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["bugbait"] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["pistol"] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["revolver"] = "normal"

--local getModelClass = anim.getModelClass
local IsValid = IsValid
local string = string
local type = type

local PLAYER_HOLDTYPE_TRANSLATOR = PLAYER_HOLDTYPE_TRANSLATOR
local HOLDTYPE_TRANSLATOR = HOLDTYPE_TRANSLATOR

local CHAIR_CACHE = {}

-- Add chair models to the cache by checking if its vehicle category is a class.
for k, v in pairs(list.Get("Vehicles")) do
	if (v.Category == "Chairs") then
		CHAIR_CACHE[v.Model] = true
	end
end

function GAMEMODE:TranslateActivity(client, act)
	local model = string.lower(client.GetModel(client))
	local class = anim.getModelClass(model) or "player"
	local weapon = client.GetActiveWeapon(client)
	if (class == "player") then
		if ( ( GAMEMODE.Config.weaponsAlwaysRaised or false ) and IsValid(weapon) and !client.isWepRaised(client) and client.OnGround(client)) then
			if (string.find(model, "zombie")) then
				local tree = anim.zombie

				if (string.find(model, "fast")) then
					tree = anim.fastZombie
				end

				if (tree[act]) then
					return tree[act]
				end
			end

			local holdType = IsValid(weapon) and (weapon.HoldType or weapon.GetHoldType(weapon)) or "normal"

			if (!(GAMEMODE.Config.weaponsAlwaysRaised or false) and IsValid(weapon) and !client.isWepRaised(client) and client:OnGround()) then
				holdType = PLAYER_HOLDTYPE_TRANSLATOR[holdType] or "passive"
			end

			local tree = anim.player[holdType]

			if (tree and tree[act]) then
				if (type(tree[act]) == "string") then
					print(tree[act])

					client.CalcSeqOverride = client.LookupSequence(client, tree[act])

					return
				else
					return tree[act]
				end
			end
		end

		return self.BaseClass.TranslateActivity(self.BaseClass, client, act)
	end

	local tree = anim[class]

	if (tree) then
		local subClass = "normal"

		if (client.InVehicle(client)) then
			local vehicle = client.GetVehicle(client)
			local class = CHAIR_CACHE[vehicle:GetModel()] and "chair" or vehicle:GetClass()

			if (tree.vehicle and tree.vehicle[class]) then
				local act = tree.vehicle[class][1]
				local fixvec = tree.vehicle[class][2]
				--local fixang = tree.vehicle[class][3]

				if (fixvec) then
					client:SetLocalPos(Vector(16.5438, -0.1642, -20.5493))
				end

				if (type(act) == "string") then
					client.CalcSeqOverride = client.LookupSequence(client, act)

					return
				else
					return act
				end
			else
				act = tree.normal[ACT_MP_CROUCH_IDLE][1]

				if (type(act) == "string") then
					client.CalcSeqOverride = client:LookupSequence(act)
				end

				return
			end
		elseif (client.OnGround(client)) then
			client.ManipulateBonePosition(client, 0, vector_origin)

			if (IsValid(weapon)) then
				subClass = weapon.HoldType or weapon.GetHoldType(weapon)
				subClass = HOLDTYPE_TRANSLATOR[subClass] or subClass
			end

			if (tree[subClass] and tree[subClass][act]) then
				local act2 = tree[subClass][act][client.isWepRaised(client) and 2 or 1]

				if (type(act2) == "string") then
					client.CalcSeqOverride = client.LookupSequence(client, act2)

					return
				end

				return act2
			end
		elseif (tree.glide) then
			return tree.glide
		end
	end
end

function GAMEMODE:DoAnimationEvent(client, event, data)
	local model = client:GetModel():lower()
	local class = anim.getModelClass(model)

	if (class == "player") then
		return self.BaseClass:DoAnimationEvent(client, event, data)
	else
		local weapon = client:GetActiveWeapon()

		if (IsValid(weapon)) then
			local holdType = weapon.HoldType or weapon:GetHoldType()
			holdType = HOLDTYPE_TRANSLATOR[holdType] or holdType

			local animation = anim[class][holdType]

			if (event == PLAYERANIMEVENT_ATTACK_PRIMARY) then
				client:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, animation.attack or ACT_GESTURE_RANGE_ATTACK_SMG1, true)

				return ACT_VM_PRIMARYATTACK
			elseif (event == PLAYERANIMEVENT_ATTACK_SECONDARY) then
				client:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, animation.attack or ACT_GESTURE_RANGE_ATTACK_SMG1, true)

				return ACT_VM_SECONDARYATTACK
			elseif (event == PLAYERANIMEVENT_RELOAD) then
				client:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, animation.reload or ACT_GESTURE_RELOAD_SMG1, true)

				return ACT_INVALID
			elseif (event == PLAYERANIMEVENT_JUMP) then
				client.m_bJumping = true
				client.m_bFistJumpFrame = true
				client.m_flJumpStartTime = CurTime()

				client:AnimRestartMainSequence()

				return ACT_INVALID
			elseif (event == PLAYERANIMEVENT_CANCEL_RELOAD) then
				client:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)

				return ACT_INVALID
			end
		end
	end

	return ACT_INVALID
end

local vectorAngle = FindMetaTable("Vector").Angle
local normalizeAngle = math.NormalizeAngle

function GAMEMODE:CalcMainActivity(client, velocity)
	local eyeAngles = client.EyeAngles(client)
	local yaw = vectorAngle(velocity)[2]
	local normalized = normalizeAngle(yaw - eyeAngles[2])

	client.SetPoseParameter(client, "move_yaw", normalized)

	if CLIENT then
		client.SetIK(client, false)
	end
	
	local oldSeqOverride = client.CalcSeqOverride

	local seqIdeal, seqOverride = self.BaseClass.CalcMainActivity(self.BaseClass, client, velocity)
	--client.CalcSeqOverride is being -1 after this line.

	return seqIdeal, client.nutForceSeq or oldSeqOverride or client.CalcSeqOverride
end

anim.setModelClass("models/hl2rp/female_01.mdl", "citizen_female")
anim.setModelClass("models/hl2rp/female_02.mdl", "citizen_female")
anim.setModelClass("models/hl2rp/female_03.mdl", "citizen_female")
anim.setModelClass("models/hl2rp/female_04.mdl", "citizen_female")
anim.setModelClass("models/hl2rp/female_06.mdl", "citizen_female")
anim.setModelClass("models/hl2rp/female_07.mdl", "citizen_female")
anim.setModelClass("models/hl2rp/male_01.mdl", "citizen_male")
anim.setModelClass("models/hl2rp/male_02.mdl", "citizen_male")
anim.setModelClass("models/hl2rp/male_03.mdl", "citizen_male")
anim.setModelClass("models/hl2rp/male_04.mdl", "citizen_male")
anim.setModelClass("models/hl2rp/male_05.mdl", "citizen_male")
anim.setModelClass("models/hl2rp/male_06.mdl", "citizen_male")
anim.setModelClass("models/hl2rp/male_07.mdl", "citizen_male")
anim.setModelClass("models/hl2rp/male_08.mdl", "citizen_male")
anim.setModelClass("models/hl2rp/male_09.mdl", "citizen_male")
anim.setModelClass("models/jessev92/hl2/conscripts/f01_npccit.mdl", "citizen_female")
anim.setModelClass("models/jessev92/hl2/conscripts/f02_npccit.mdl", "citizen_female")
anim.setModelClass("models/jessev92/hl2/conscripts/f03_npccit.mdl", "citizen_female")
anim.setModelClass("models/jessev92/hl2/conscripts/f04_npccit.mdl", "citizen_female")
anim.setModelClass("models/jessev92/hl2/conscripts/f06_npccit.mdl", "citizen_female")
anim.setModelClass("models/jessev92/hl2/conscripts/f07_npccit.mdl", "citizen_female")
anim.setModelClass("models/jessev92/hl2/conscripts/m01_npccit.mdl", "citizen_male")
anim.setModelClass("models/jessev92/hl2/conscripts/m02_npccit.mdl", "citizen_male")
anim.setModelClass("models/jessev92/hl2/conscripts/m03_npccit.mdl", "citizen_male")
anim.setModelClass("models/jessev92/hl2/conscripts/m04_npccit.mdl", "citizen_male")
anim.setModelClass("models/jessev92/hl2/conscripts/m05_npccit.mdl", "citizen_male")
anim.setModelClass("models/jessev92/hl2/conscripts/m06_npccit.mdl", "citizen_male")
anim.setModelClass("models/jessev92/hl2/conscripts/m07_npccit.mdl", "citizen_male")
anim.setModelClass("models/jessev92/hl2/conscripts/m08_npccit.mdl", "citizen_male")
anim.setModelClass("models/jessev92/hl2/conscripts/m09_npccit.mdl", "citizen_male")
anim.setModelClass("models/jessev92/hl2/conscripts/m10_npccit.mdl", "citizen_male")
anim.setModelClass("models/jessev92/hl2/conscripts/m11_npccit.mdl", "citizen_male")
anim.setModelClass("models/jessev92/hl2/conscripts/hazmat_npccit.mdl", "citizen_male")
anim.setModelClass("models/player/cremator_player.mdl", "metrocop")
anim.setModelClass("models/police.mdl", "metrocop")
anim.setModelClass("models/cremator.mdl", "metrocop")
anim.setModelClass("models/dpfilms/metropolice/hdpolice.mdl", "metrocop")
anim.setModelClass("models/dpfilms/metropolice/police_bt.mdl", "metrocop")
anim.setModelClass("models/dpfilms/metropolice/elite_police.mdl", "metrocop")
anim.setModelClass("models/dpfilms/metropolice/civil_medic.mdl", "metrocop")
anim.setModelClass("models/dpfilms/metropolice/hl2concept.mdl", "metrocop")
anim.setModelClass("models/dpfilms/metropolice/c08cop.mdl", "metrocop")
anim.setModelClass("models/dpfilms/metropolice/phoenix_police.mdl", "metrocop")
anim.setModelClass("models/dpfilms/metropolice/policetrench.mdl", "metrocop")
anim.setModelClass("models/dpfilms/metropolice/hl2beta_police.mdl", "metrocop")
anim.setModelClass("models/dpfilms/metropolice/resistance_police.mdl", "metrocop");
anim.setModelClass("models/dpfilms/metropolice/retrocop.mdl", "metrocop")
anim.setModelClass("models/dpfilms/metropolice/biopolice.mdl", "metrocop")
anim.setModelClass("models/dpfilms/metropolice/blacop.mdl", "metrocop")
anim.setModelClass("models/dpfilms/metropolice/urban_police.mdl", "metrocop")
anim.setModelClass("models/dpfilms/metropolice/rtb_police.mdl", "metrocop")
anim.setModelClass("models/dpfilms/metropolice/24nebcop.mdl", "metrocop")
anim.setModelClass("models/combine_super_soldier.mdl", "overwatch")
anim.setModelClass("models/combine_soldier_prisonGuard.mdl", "overwatch")
anim.setModelClass("models/combine_soldier.mdl", "overwatch")
anim.setModelClass("models/combine_soldier_vsr.mdl", "overwatch")
anim.setModelClass("models/combine_soldier_white.mdl", "overwatch")
anim.setModelClass("models/combine_soldier_blue.mdl", "overwatch")
anim.setModelClass("models/sirgibs/ragdolls/vance/combine_assassin_npc.mdl", "metrocop")
anim.setModelClass("models/vortigaunt.mdl", "vort")
anim.setModelClass("models/vortigaunt.mdl", "vort")
anim.setModelClass("models/vortigaunt_blue.mdl", "vort")
anim.setModelClass("models/vortigaunt_doctor.mdl", "vort")
anim.setModelClass("models/vortigaunt_slave.mdl", "vort")
anim.setModelClass("models/combinesoldiersheet_police.mdl", "overwatch")
anim.setModelClass("models/combine_soldier_beta.mdl", "overwatch")
anim.setModelClass("models/player/combine_soldier04.mdl", "overwatch")
anim.setModelClass("models/tai/heavy_combine/combine_soldier.mdl", "overwatch")
anim.setModelClass("models/blackar_super_soldier.mdl", "overwatch")
anim.setModelClass("models/combine_heavy.mdl", "overwatch")
anim.setModelClass("models/combine_super_soldier_armored.mdl", "overwatch")
anim.setModelClass("models/combine_soldierproto.mdl", "overwatch")
anim.setModelClass("models/combine_darkelite1_soldier.mdl", "overwatch")
anim.setModelClass("models/combine_darkelite_soldier.mdl", "overwatch")
anim.setModelClass("models/combine_soldier2000.mdl", "overwatch")
anim.setModelClass("models/combine_soldiergrunt.mdl", "overwatch")
anim.setModelClass("models/combine_soldieros.mdl", "overwatch")
anim.setModelClass("models/combine_soldierproto_drt.mdl", "overwatch")
anim.setModelClass("models/combine_soldiersnow.mdl", "overwatch")
anim.setModelClass("models/combine_super_soldierproto.mdl", "overwatch")
anim.setModelClass("models/combine_super_soldierprotodirt.mdl", "overwatch")