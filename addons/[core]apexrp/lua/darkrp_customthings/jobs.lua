TEAM_CITIZEN = DarkRP.createJob("Citizen", {
    color = Color(20, 150, 20, 255),
    model = {
        "models/hl2rp/female_01.mdl",
		"models/hl2rp/female_02.mdl",
		"models/hl2rp/female_03.mdl",
		"models/hl2rp/female_04.mdl",
		"models/hl2rp/female_06.mdl",
		"models/hl2rp/female_07.mdl",
		"models/hl2rp/male_01.mdl",
		"models/hl2rp/male_02.mdl",
		"models/hl2rp/male_03.mdl",
		"models/hl2rp/male_04.mdl",
		"models/hl2rp/male_05.mdl",
		"models/hl2rp/male_06.mdl",
		"models/hl2rp/male_07.mdl",
		"models/hl2rp/male_08.mdl",
		"models/hl2rp/male_09.mdl"
    },
    description = [[The lowest class of Universal Union society. They are forced to follow the UU's dictatorship with absolute obedience, or face punishments and even execution. The UU keeps citizens weak and malnourished, and it is all they can do to try and survive. However, some brave citizens dare to stand against the UU]],
    weapons = {"weapon_physcannon", "gmod_tool", "weapon_physgun", "keys", "pocket"},
    command = "civilian",
    max = 0,
    salary = 0,
    admin = 0,
	xp = 0,
    vote = false,
    category = "Lambda", -- Using this for the event capture point 
    rations = {
        enabled = true, 
        amount = 1, 
    },
    hasLicense = false,
    candemote = false,
    menu_materials = { -- This property is used by the F4 menu.
        background = "f4menu/citizen_background.png", -- Material path here.
        logo = "f4menu/citizen_logo.png",
    },
})

TEAM_CWU = DarkRP.createJob("Civil Workers Union", {
    color = Color(123, 147, 163, 255),
    model = {
        "models/hl2rp/female_01.mdl",
		"models/hl2rp/female_02.mdl",
		"models/hl2rp/female_03.mdl",
		"models/hl2rp/female_04.mdl",
		"models/hl2rp/female_06.mdl",
		"models/hl2rp/female_07.mdl",
		"models/hl2rp/male_01.mdl",
		"models/hl2rp/male_02.mdl",
		"models/hl2rp/male_03.mdl",
		"models/hl2rp/male_04.mdl",
		"models/hl2rp/male_05.mdl",
		"models/hl2rp/male_06.mdl",
		"models/hl2rp/male_07.mdl",
		"models/hl2rp/male_08.mdl",
		"models/hl2rp/male_09.mdl"
    },
    description = [[The lowest class of Universal Union society. They are forced to follow the UU's dictatorship with absolute obedience, or face punishments and even execution. The UU keeps citizens weak and malnourished, and it is all they can do to try and survive. However, some brave citizens dare to stand against the UU]],
    weapons = {"weapon_physcannon", "gmod_tool", "weapon_physgun", "keys", "pocket"},
    command = "cwu",
    max = 0,
    salary = 0,
    admin = 0,
	xp = 15,
    vote = false,
    category = "Lambda",
    rations = {
        enabled = true, 
        amount = 1, 
    },
    hasLicense = false,
    candemote = false,
    menu_materials = { -- This property is used by the F4 menu.
        background = "f4menu/citizen_background.png", -- Material path here.
        logo = "f4menu/citizen_logo.png",
    },
})

TEAM_CONSCRIPT = DarkRP.createJob("Conscript", {
	combine = true, -- This property signifies that this job is a part of the combine.
    color = Color(255, 128, 0),
    model = {
        "models/jessev92/hl2/conscripts/f01_npccit.mdl",
		"models/jessev92/hl2/conscripts/f02_npccit.mdl",
		"models/jessev92/hl2/conscripts/f03_npccit.mdl",
		"models/jessev92/hl2/conscripts/f04_npccit.mdl",
		"models/jessev92/hl2/conscripts/f06_npccit.mdl",
		"models/jessev92/hl2/conscripts/f07_npccit.mdl",
		"models/jessev92/hl2/conscripts/m01_npccit.mdl",
		"models/jessev92/hl2/conscripts/m02_npccit.mdl",
		"models/jessev92/hl2/conscripts/m03_npccit.mdl",
		"models/jessev92/hl2/conscripts/m04_npccit.mdl",
		"models/jessev92/hl2/conscripts/m06_npccit.mdl",
		"models/jessev92/hl2/conscripts/m07_npccit.mdl",
		"models/jessev92/hl2/conscripts/m08_npccit.mdl",
		"models/jessev92/hl2/conscripts/m09_npccit.mdl",
		"models/jessev92/hl2/conscripts/m10_npccit.mdl",
		"models/jessev92/hl2/conscripts/m11_npccit.mdl"
    },
    description = [[The conscripts are a human military combine unit. They are the cannon-fodder of the universal union, consisting of captured former earth forces and prisoners requisitioned and unwillingly reincorporated, however there are also loyalists and average citizens amongst them, enlisting voluntarily in order to acquire benefits and to fulfill their civic duty towards the universal union. As such, they are usually poorly armed compared to the rest of the combine's forces, armed with low-grade weaponry and weak kevlar vests. Most civil protection treat them with little to no respect.]],
    weapons = {"keys"},
    command = "conscript",
    max = 5,
    salary = 20,
    admin = 0,
    vote = false,
	xp = 35,
    hasLicense = false,
    category = "Lambda", -- For the event
    candemote = false,
    menu_materials = { -- This property is used by the F4 menu.
        background = "f4menu/cp_background.png", -- Material path here.
        logo = "f4menu/cp_logo.png",
    },
})

TEAM_CP = DarkRP.createJob("Civil Protection", {
	combine = true, -- This property signifies that this job is a part of the combine.
	nameTemplate = "<city>.<rank>:<division>-<digits>", -- This property is used by divisions. Remove if divisions module was removed.
    color = Color(25, 25, 170, 255),
    model = {
        "models/dpfilms/metropolice/hdpolice.mdl",
    },
    description = [[The CPs are the Universal Union`s human police force. They are responsible for the enforcement of the UU`s laws, and controlling the population. The CPs consists of multiple divisions, each with a specific role. Many join the CPs in hopes of getting better rations, or simply for the power it brings over their fellow citizens.]],
    weapons = {"keys"},
    command = "cp",
    max = 20,
    salary = 30,
    admin = 0,
    vote = false,
	xp = 35,
    hasLicense = false,
    category = "Combine",
    candemote = false,
    menu_materials = { -- This property is used by the F4 menu.
        background = "f4menu/cp_background.png", -- Material path here.
        logo = "f4menu/cp_logo.png",
    },
})

TEAM_OVERWATCH = DarkRP.createJob("Overwatch Soldier", {
	combine = true, -- This property signifies that this job is a part of the combine.
	nameTemplate = "OTA.<rank>:<division>-<digits>", -- This property is used by divisions. Remove if divisions module was removed.
    color = Color(40, 40, 40),
    model = {
        "models/player/soldier_stripped.mdl",
    },
    description = [[The OTA are the transhuman military wing of the Universal Union`s forces. They are highly trained and extensively modified super soldiers, far stronger than any normal human. They are entirely without fear or emotion of any kind, called on to the streets only when  circumstances are at their most dire. Otherwise, they emain in the Nexus or guarding hardpoints around the city. They are completely obedient to  their commander, following orders without regard to their own safety. Operating in small squads, the OTA are a force to be reckoned with, and haunt the dreams of any citizen with common sense.]],
    weapons = {"keys"},
    command = "ota",
    max = 12,
    salary = 50,
    admin = 0,
    vote = false,
    category = "Combine",
	xp = 600,
    hasLicense = false,
    candemote = false,
    menu_materials = { -- This property is used by the F4 menu.
        background = "f4menu/ota_background.png", -- Material path here.
        logo = "f4menu/ota_logo.png",
    },
})

TEAM_VORTIGAUNT = DarkRP.createJob("Vortigaunt", {
    color = Color(172, 156, 11, 255),
    model = {
        "models/vortigaunt_slave.mdl",
    },
    description = [[A mysterious alien race, enslaved by the Universal Union. They are a wise and mainly peaceful race, forced into servitude by other races for centuries. Most are treated poorly by the Combine, forced to clean the streets and Nexus. However, once freed they are able to harness a mysterious energy, known as the Vortessence, that connects them with each other.]],
    weapons = {"weapon_physcannon", "gmod_tool", "weapon_physgun", "keys", "pocket"},
    command = "vortigaunt",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
	xp = 1200,
    hasLicense = false,
    category = "Lambda",
    candemote = false,
    menu_materials = { -- This property is used by the F4 menu.
        background = "f4menu/xen_background.png", -- Material path here.
        logo = "f4menu/xen_logo.png",
    },
	cook = true,
    PlayerSpawn = function(ply)
       	ply:SetMaxHealth(250);
		ply:SetHealth(250);
   end 
})

TEAM_ADMINISTRATOR = DarkRP.createJob("CAB Member", {
    color = Color(150, 20, 20, 255),
    model = {
        "models/hl2rp/female_01.mdl",
		"models/hl2rp/female_02.mdl",
		"models/hl2rp/female_03.mdl",
		"models/hl2rp/female_04.mdl",
		"models/hl2rp/female_06.mdl",
		"models/hl2rp/female_07.mdl",
		"models/hl2rp/male_01.mdl",
		"models/hl2rp/male_02.mdl",
		"models/hl2rp/male_03.mdl",
		"models/hl2rp/male_04.mdl",
		"models/hl2rp/male_05.mdl",
		"models/hl2rp/male_06.mdl",
		"models/hl2rp/male_07.mdl",
		"models/hl2rp/male_08.mdl",
		"models/hl2rp/male_09.mdl"
    },
    description = [[The civil administration board is an unmodified human party  appointed to run the city by the universal union. It has been chosen because of it's fierce support of and loyalty for the universal union. They are given a great deal of authority and given full control over the conscripts, during a military situation however, formal command passes fully to the OWC. Despite this power, their main role is that of management of the city's population. They will broadcast propaganda messages to the citizens of the city, ensuring them of their safety and the righteousness of our benefactors. Others would set up research projects to provide benefits to the universal union or manage the taxes over the populace's additional salary, in order to fund such projects, OR managing the city's status. They spend most of their time in their office, managing the piles of paperwork a bustling city produces, and rarely take to the streets.]],
    weapons = {"keys"},
    command = "cab",
    max = 5,
    salary = 50,
    admin = 0,
    vote = false,
	xp = 1000,
	mayor = true,
    hasLicense = false,
    candemote = false,
    menu_materials = { -- This property is used by the F4 menu.
        background = "f4menu/cp_background.png", -- Material path here.
        logo = "f4menu/cp_logo.png",
    },
    bodygroup = {
        [1] = 40,
        [2] = 18,
    },
    PlayerSpawn = function(ply)
        for bodygroupi, bodygroupv in pairs((RPExtraTeams[ply:Team()] and RPExtraTeams[ply:Team()].bodygroup) or {}) do
            ply:SetBodygroup(bodygroupi, bodygroupv)
        end

    end,
})

TEAM_DISPATCH = DarkRP.createJob("The Dispatch", {
	combine = true, -- This property signifies that this job is a part of the combine.
    color = Color(25, 25, 170, 255),
    model = {
        "models/dpfilms/metropolice/hdpolice.mdl",
    },
    description = [[Restricted job.]],
    weapons = {"keys"},
    command = "disp",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
	xp = 99999,
    hasLicense = false,
    candemote = false,
    menu_materials = { -- This property is used by the F4 menu.
        background = "f4menu/cp_background.png", -- Material path here.
        logo = "f4menu/cp_logo.png",
    },
})

GAMEMODE.DefaultTeam = TEAM_CITIZEN

--[[
GM.CivilProtection = {
	[TEAM_CP] = true,
	[TEAM_OVERWATCH] = true,
	[TEAM_ADMINISTRATOR] = true,
	[TEAM_DISPATCH] = true,
	[TEAM_CONSCRIPT] = true,
}
]]

-- Default categories
DarkRP.createCategory{
    name = "Lambda",
    categorises = "jobs",
	startExpanded = true,
    color = Color(252, 136, 3),
    canSee = fp{fn.Id, true},
    sortOrder = 100,
}

DarkRP.createCategory{
    name = "Combine",
    categorises = "jobs",
	startExpanded = true,
    color = Color(3, 144, 252),
    canSee = fp{fn.Id, true},
    sortOrder = 101,
}

