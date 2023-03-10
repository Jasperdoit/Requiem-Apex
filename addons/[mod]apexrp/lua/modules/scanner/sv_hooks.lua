local SCANNER_SOUNDS = {
    "npc/scanner/scanner_blip1.wav",
    "npc/scanner/scanner_scan1.wav",
    "npc/scanner/scanner_scan2.wav",
    "npc/scanner/scanner_scan4.wav",
    "npc/scanner/scanner_scan5.wav",
    "npc/scanner/combat_scan1.wav",
    "npc/scanner/combat_scan2.wav",
    "npc/scanner/combat_scan3.wav",
    "npc/scanner/combat_scan4.wav",
    "npc/scanner/combat_scan5.wav",
    "npc/scanner/cbot_servoscared.wav",
    "npc/scanner/cbot_servochatter.wav"
}

function scanner:createScanner(client, isClawScanner)
    if (IsValid(client.nutScn)) then
        return
    end

    local entity = ents.Create("nut_scanner")
    if (not IsValid(entity)) then
        return
    end

    for _, scanner in ipairs(ents.FindByClass("nut_scanner")) do
        if (scanner:GetPilot() == client) then
            scanner:SetPilot(NULL)
        end
    end
    
    entity:SetPos(client:GetPos())
    entity:SetAngles(client:GetAngles())
    entity:SetColor(client:GetColor())
    entity:Spawn()
    entity:Activate()
    entity:setPilot(client)

    if (isClawScanner) then
        entity:setClawScanner()
    end

    -- Draw the player info when looking at the scanner.
    entity:SetNWEntity("player", client)
    client.nutScn = entity

    return entity
end

hook.Add( "PlayerSpawn", "hl2rp: scanner", function( client )
    if (IsValid(client.nutScn)) then
        client.nutScn.noRespawn = true
        client.nutScn.spawn = client:GetPos()
        client.nutScn:Remove()
        client.nutScn = nil
        client:SetViewEntity(NULL)
    else 
        net.Start("nutScannerClearPicture")
        net.Send(client)
    end 

end );

hook.Add( "DoPlayerDeath", "hl2rp: scanner", function( client )
    if (IsValid(client.nutScn)) then
        client:AddDeaths(1)
        return false -- Suppress ragdoll creation.
    end
end );

hook.Add( "PlayerDeath", "hl2rp: scanner", function( client )
    if (IsValid(client.nutScn) and client.nutScn.health > 0) then
        client.nutScn:die()
        client.nutScn = nil
    end
end );

hook.Add("PlayerSilentDeath", "hl2rp: scanner", function(client)   
	if (IsValid(client.nutScn)) then
        client.nutScn:die()
        client.nutScn = nil
    end    
end );

hook.Add( "KeyPress", "hl2rp: scanner", function( client, key )
    if (IsValid(client.nutScn) and (client.nutScnDelay or 0) < CurTime()) then
        local source

        if (key == IN_USE) then
            source = table.Random(SCANNER_SOUNDS)
            client.nutScnDelay = CurTime() + 1.75
        elseif (key == IN_RELOAD) then
            source = "npc/scanner/scanner_talk"..math.random(1, 2)..".wav"
            client.nutScnDelay = CurTime() + 10
        elseif (key == IN_WALK) then
            if (client:GetViewEntity() == client.nutScn) then
                client:SetViewEntity(NULL)
            else
                client:SetViewEntity(client.nutScn)
            end
        end

        if (source) then
            client.nutScn:EmitSound(source)
        end
    end
end);

hook.Add("PlayerNoClip", "hl2rp: scanner", function(client)
    if (IsValid(client.nutScn)) then
        return false
    end
end )

hook.Add( "PlayerUse", "hl2rp: scanner", function(client, entity)
    if (IsValid(client.nutScn)) then
        return false
    end
end )

hook.Add("CanPlayerReceiveScan", "hl2rp: scanner", function (client, photographer)
    return client:isCombine()
end )

hook.Add("PlayerSwitchFlashlight", "hl2rp: scanner", function(client, enabled)
    local scanner = client.nutScn
    if (not IsValid(scanner)) then return end

    if ((scanner.nextLightToggle or 0) >= CurTime()) then return false end
    scanner.nextLightToggle = CurTime() + 0.5

    local pitch
    if (scanner:isSpotlightOn()) then
        scanner:disableSpotlight()
        pitch = 240
    else
        scanner:enableSpotlight()
        pitch = 250
    end

    scanner:EmitSound("npc/turret_floor/click1.wav", 50, pitch)
    return false
end );

hook.Add( "PlayerCanPickupWeapon", "hl2rp: scanner", function(client, weapon)
    if (IsValid(client.nutScn)) then
        return false
    end
end )

hook.Add( "PlayerCanPickupItem", "hl2rp: scanner", function(client, item)
    if (IsValid(client.nutScn)) then
        return false
    end
end )

hook.Add( "PlayerFootstep", "hl2rp: scanner", function(client)
    if (IsValid(client.nutScn)) then
        return true
    end
end )