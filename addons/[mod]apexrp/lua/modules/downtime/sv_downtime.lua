downtimemode = downtimemode or false

local locations = {
    {Vector(-10599.968750, 7142.234863, -415.968750), Angle(-1.210036, -2.056853, 0.000000)},
    {Vector(-6184.004883, 7417.514648, -415.968750), Angle(0.677574, 178.863129, 0.000000)},
    {Vector(-8184.310547, 11340.448242, -883.968750), Angle(0.483946, -0.266026, 0.000000)},
    {Vector(-3900.895020, -5368.873535, 88.031250), Angle(0.580797, 91.064285, 0.000000)}
}

local function SpawnRebelNPC()
    if not mapconfigs or not mapconfigs[game.GetMap()] or not mapconfigs[game.GetMap()].DowntimeNPCPositions then return end
    for _, location in pairs(mapconfigs[game.GetMap()].DowntimeNPCPositions) do
        local vendor = ents.Create("rebel_npc")
        vendor:SetPos(location[1])
        vendor:SetAngles(location[2])
        vendor:Spawn()
    end
end

local function DespawnRebelNPC()
    for _, vendors in pairs(ents.FindByClass("rebel_npc")) do
        vendors:Remove()
    end
end

hook.Add("PlayerSpawn", "Determinedowntime", function(ply)
    local playercount = player.GetCount()

    if playercount < 15 and not downtimemode then
        downtimemode = true
        SetGlobalBool("DownTime", true)
        SpawnRebelNPC()
        for _, ply in pairs(player.GetHumans()) do
            ply:ChatPrint("Downtime mode has been activated!")
        end
    elseif playercount >= 16 and downtimemode then
        downtimemode = false
        SetGlobalBool("DownTime", false)
        DespawnRebelNPC()
        for _, ply in pairs(player.GetHumans()) do
            ply:ChatPrint("Downtime mode has been deactivated!")
        end
    end
end)

