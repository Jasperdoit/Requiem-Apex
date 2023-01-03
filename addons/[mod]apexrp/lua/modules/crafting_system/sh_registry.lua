WeaponCraftingTableItems = WeaponCraftingTableItems or {}
WeaponCraftingTableAmmo = WeaponCraftingTableAmmo or {}
WeaponCraftingTable = WeaponCraftingTable or {}
WeaponCraftingTable.maxtier = 15

WeaponCraftingTableItems[1] = {
    weaponname = "USP Match",
    classname = "fl_usp",
    description =
    [[The USP Match pistol.
A simple 9mm pistol given to
most units of the Civil Protection forces.]],
    model = "models/weapons/w_pistol.mdl",
    tier = 1,
    time = 300,
}
WeaponCraftingTableItems[2] = {
    weaponname = "MP7",
    classname = "fl_mp7",
    description = [[The MP7. A simple 9mm
SMG given to most units of the Civil
Protection forces.]],
    model = "models/weapons/w_smg1.mdl",
    tier = 2,
    time = 1200,
}
WeaponCraftingTableItems[3] = {
    weaponname = "Colt 1911",
    classname = "fl_colt",
    description = [[The Colt 1911. A reliable pistol with good accuracy.]],
    model = "models/tnb/weapons/colt1911/w_1911.mdl",
    tier = 2,
    time = 600,
}
WeaponCraftingTableItems[4] = {
    weaponname = "AKM",
    classname = "fl_ak",
    description = [[The AKM. A pre-war weapon,
many have been found and reproduced
by the resistance.]],
    model = "models/weapons/tfa_ins2/w_akm_bw.mdl",
    tier = 3,
    time = 2100,
}
WeaponCraftingTableItems[5] = {
    weaponname = "DH PPSH-41",
    classname = "fl_ppsh",
    description = [[The PPSH-41. An old relic of a weapon.]],
    model = "models/weapons/w_smg_ump45.mdl",
    tier = 3,
    time = 2300,
}
WeaponCraftingTableItems[6] = {
    weaponname = "SPAS-12",
    description = [[The SPAS-12. A pre-war 
weapon, a strong shotgun useful for CQC.]],
    model = "models/weapons/w_shotgun.mdl",
    classname = "fl_spas12",
    tier = 3,
    time = 3600,
}
WeaponCraftingTableItems[7] = {
    weaponname = "Colt Python",
    description = [[The Colt Python.
Using .357 ammo it is a strong weapon
capable of dealing major damage.]],
    model = "models/weapons/w_357.mdl",
    classname = "fl_magnum",
    tier = 4,
    time = 5200,
}
WeaponCraftingTableItems[8] = {
    weaponname = "Mosin-Nagant",
    description = [[The Mosin-Negant. A very
strong long-range weapon that is as 
deadly as it is accurate.]],
    model = "models/apexwep/weapons/w_mosin.mdl",
    classname = "fl_mosin",
    tier = 4,
    time = 6000,
}
WeaponCraftingTableItems[9] = {
    weaponname = "Radio",
    description = [[A handheld radio.]],
    model = "models/props_trainstation/payphone_reciever001a.mdl",
    classname = "dradio",
    tier = 1,
    time = 360,
}
WeaponCraftingTableItems[10] = {
    weaponname = "EMP Tool",
    description = [[An electric enigma
that is capable of opening any door.]],
    model = "models/alyx_emptool_prop.mdl",
    classname = "alyx_emptool",
    tier = 5,
    time = 9000,
}
WeaponCraftingTableItems[11] = {
    weaponname = "Health Vial",
    description = [[A UU Health Vial.]],
    model = "models/healthvial.mdl",
    classname = "weapon_healthvial",
    tier = 3,
    time = 240,
}
WeaponCraftingTableItems[12] = {
    weaponname = "Pistol ammunition",
    description = [[simple magazine of
9mm bullets.]],
    isammo = true,
    ammoamount = 36,
    model = "models/Items/BoxSRounds.mdl",
    classname = "Pistol",
    tier = 1,
    time = 120,
}
WeaponCraftingTableItems[13] = {
    weaponname = "SMG ammunition",
    description = [[simple magazine of
SMG bullets.]],
    isammo = true,
    ammoamount = 180,
    model = "models/Items/BoxMRounds.mdl",
    classname = "SMG1",
    tier = 2,
    time = 300,
}
WeaponCraftingTableItems[14] = {
    weaponname = "AR ammunition",
    description = [[simple magazine of
AR bullets.]],
    isammo = true,
    ammoamount = 90,
    model = "models/Items/combine_rifle_cartridge01.mdl",
    classname = "AR2",
    tier = 3,
    time = 500,
}
WeaponCraftingTableItems[15] = {
    weaponname = "00 Buckshot",
    description = [[A few cartridges
of 00 Buckshot ammunition.]],
    isammo = true,
    ammoamount = 24,
    model = "models/Items/BoxBuckshot.mdl",
    classname = "Buckshot",
    tier = 4,
    time = 800,
}
WeaponCraftingTableItems[16] = {
    weaponname = "Magnum ammunition",
    description = [[simple pair of
.357 Magnum bullets]],
    isammo = true,
    ammoamount = 18,
    model = "models/Items/357ammobox.mdl",
    classname = "357",
    tier = 4,
    time = 800,
}