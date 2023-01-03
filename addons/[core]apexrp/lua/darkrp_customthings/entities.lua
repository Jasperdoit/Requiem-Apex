--[[---------------------------------------------------------------------------
DarkRP custom entities
---------------------------------------------------------------------------

This file contains your custom entities.
This file should also contain entities from DarkRP that you edited.

Note: If you want to edit a default DarkRP entity, first disable it in darkrp_config/disabled_defaults.lua
    Once you've done that, copy and paste the entity to this file and edit it.

The default entities can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua

For examples and explanation please visit this wiki page:
https://darkrp.miraheze.org/wiki/DarkRP:CustomEntityFields

Add entities under the following line:
---------------------------------------------------------------------------]]
DarkRP.createEntity("Health Vial", {
    ent = "models/healthvial.mdl",
    model = "models/healthvial.mdl",
    price = 40,
    max = 0,
    cmd = "healthvial",
    allowed = {TEAM_CWU},
	customCheck = function(ply)
		return ply:GetNWInt("citopt") and ply:GetNWInt("citopt") == 4 and ply:Team() == TEAM_CWU
	end
});

DarkRP.createEntity("Medical Kit", {
    ent = "weapon_disposal_medkit",
    model = "models/Items/HealthKit.mdl",
    price = 100,
    max = 0,
    cmd = "medkit",
    allowed = {TEAM_CWU},
	customCheck = function(ply)
		return ply:GetNWInt("citopt") and ply:GetNWInt("citopt") == 4 and ply:Team() == TEAM_CWU
	end
});

DarkRP.createEntity("Pliers", {
    ent = "hl2rp_vortfree",
    model = "models/props_c17/tools_wrench01a.mdl",
    price = 100,
    max = 0,
    cmd = "pliers",
    allowed = {TEAM_CITIZEN},
	customCheck = function(ply)
		return ply:GetNWInt("citopt") and ply:GetNWInt("citopt") == 3 and ply:Team() == TEAM_CITIZEN
	end
});

DarkRP.createEntity("Lockpick", {
    ent = "lockpick",
    model = "models/weapons/w_crowbar.mdl",
    price = 300,
    max = 0,
    cmd = "lockpick",
    allowed = {TEAM_CITIZEN},
	customCheck = function(ply)
		return ply:GetNWInt("citopt") and ply:GetNWInt("citopt") == 3 and ply:Team() == TEAM_CITIZEN
	end
});

DarkRP.createEntity("Rebel Brewing Barrel", {
    ent = "hl2rp_beerbrewer",
    model = "models/props/de_inferno/wine_barrel.mdl",
    price = 100,
    max = 3,
    cmd = "barrel",
    allowed = {TEAM_CITIZEN},
	customCheck = function(ply)
		return ply:GetNWBool("IsRebelScum", false) and ply:Team() == TEAM_CITIZEN and ((SERVER and !ply:hasMaxBarrels()) or CLIENT)
	end
});

DarkRP.createEntity("Can of yeast", {
    ent = "hl2rp_yeast",
    model = "models/props_junk/plasticbucket001a.mdl",
    price = 60,
    max = 20,
    cmd = "yeast",
    allowed = {TEAM_CITIZEN},
	customCheck = function(ply)
		return ply:GetNWBool("IsRebelScum", false) and ply:Team() == TEAM_CITIZEN
	end
});

DarkRP.createEntity("UU Alcohol", {
    ent = "hl2rp_uualcohol",
    model = "models/bioshockinfinite/jin_bottle.mdl",
    price = 75,
    max = 1,
    cmd = "alcohol",
    allowed = {TEAM_CWU},
	customCheck = function(ply)
		return ply:GetNWInt("citopt") and ply:GetNWInt("citopt") == 2 and ply:Team() == TEAM_CWU
	end
});

DarkRP.createEntity("UU Grade Yeast", {
    ent = "hl2rp_yeast",
    model = "models/props_junk/plasticbucket001a.mdl",
    price = 60,
    max = 4,
    cmd = "uuyeast",
    allowed = {TEAM_CWU},
	customCheck = function(ply)
		return ply:GetNWInt("citopt") and ply:GetNWInt("citopt") == 2 and ply:Team() == TEAM_CWU
	end
});

DarkRP.createEntity("Research Factory", {
    ent = "hl2rp_researchlab",
    model = "models/props_wasteland/laundry_washer003.mdl",
    price = 500,
    max = 3,
    cmd = "lab",
    allowed = {TEAM_CWU},
	customCheck = function(ply)
		return ply:GetNWInt("citopt") and ply:GetNWInt("citopt") == 6 and ply:Team() == TEAM_CWU and ((SERVER and !ply:hasResearchMachines()) or CLIENT)
	end
});

DarkRP.createEntity("Weapon Crafting Table", {
    ent = "rg_weaponcraftingtable",
    model = "models/props_wasteland/controlroom_desk001a.mdl",
    price = 1200,
    max = 2,
    cmd = "craftingtable",
    allowed = {TEAM_CITIZEN},
	customCheck = function(ply)
		return ply:GetNWBool("IsRebelScum", false) and ply:Team() == TEAM_CITIZEN and ply:GetNWInt("citopt") and ply:GetNWInt("citopt") == 3 and ((SERVER and !ply:hasMaxCraftingtables()) or CLIENT)
	end
});