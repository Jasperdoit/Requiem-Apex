local map = game.GetMap()
spawnpositions = {}

-- Configs
spawnpositions["rp_cellar_city8"] = {
    [TEAM_CONSCRIPT] = Vector(-7278.153320, -289.116119, 52.031250),
    [TEAM_OVERWATCH] = Vector(-5314.738281, 10523.116211, 295.894440),
    [TEAM_CP] = Vector(-4838.789551, 9770.357422, 312.031250),
    [TEAM_ADMINISTRATOR] = Vector(2937.573242, -14631.495117, -2527.968750)
}

spawnpositions["rp_apex_industrial17_b10"] = {
    [TEAM_CONSCRIPT] = Vector(4200.584961, 4275.900879, 440.031250),
    [TEAM_OVERWATCH] = Vector(3047.672119, 3861.950928, -239.968750),
    [TEAM_CP] = Vector(1903.730469, 2096.176514, -537.744019),
    [TEAM_ADMINISTRATOR] = Vector(3256.832031, 4048.471680, 3480.031250)
}

spawnpositions["rp_city17_sectorialdistrict"] = {
    [TEAM_CONSCRIPT] = Vector(3327.312988, -1228.219604, 128.031250),
    [TEAM_OVERWATCH] = Vector(6624.096191, 2783.717529, 448.031250),
    [TEAM_CP] = Vector(7391.186523, 3422.791504, 448.031250),
    [TEAM_ADMINISTRATOR] = Vector(8480.921875, 3494.330078, 7008.031250)
}

spawnpositions["rp_ineu_valley2_v1a"] = {
    [TEAM_CITIZEN] = Vector(-9819.000000, -13375.221680, 1020.031250),
    [TEAM_CONSCRIPT] = Vector(-9744.286133, -13388.847656, 1088.031250),
    [TEAM_OVERWATCH] = Vector(10078.049805, 14988.296875, 1288.031250),
    [TEAM_CP] = Vector(10105.480469, 15080.679688, 1288.031250),
    [TEAM_ADMINISTRATOR] = Vector(8480.921875, 3494.330078, 6900.031250)
}

-- Functionality

hook.Add("PlayerSpawn", "[Base] : Spawnpositions", function(ply)
    timer.Simple(0.1, function()
        if not mapconfigs[map] or not mapconfigs[map].SpawnPositions then return end
        if not mapconfigs[map].SpawnPositions[ply:Team()] then return end
        ply:SetPos(mapconfigs[map].SpawnPositions[ply:Team()])
    end)
end)