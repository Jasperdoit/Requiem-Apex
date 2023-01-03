AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include('shared.lua') -- At this point the contents of shared.lua are ran on the server only.

--This function is run when the entity is created so it's a good place to setup our entity.
function ENT:Initialize()
    self:SetModel("models/props_combine/combine_dispenser.mdl") -- Sets the model of the NPC. // 
    self:SetSolid(SOLID_BBOX)
    self:SetUseType(SIMPLE_USE)
    self:SetPlaybackRate(1.0)
    NextRationTime = NextRationTime or CurTime() + 3600
    CanGetRationTable = CanGetRationTable or {}
    HasNotifiedCps = HasNotifiedCps or false
end

function ENT:OnTakeDamage()
    return false
end

function ENT:Think()

    if NextRationTime and NextRationTime - 300 < CurTime() and not HasNotifiedCps then
    HasNotifiedCps = true
    for _, cp in pairs(player.GetAll()) do
        if cp:IsValid() and cp:IsPlayer() and cp:Alive() and (cp:Team() == TEAM_CP or cp:Team() == TEAM_CONSCRIPT) then
            cp:notify("Attention, Rations will be dispensed in 5 minutes, make your way to the RDC to oversee distribution.")
        end
    end

    end
    if NextRationTime and NextRationTime < CurTime() then
        for _,ply in pairs(player.GetAll()) do
            if ply:IsValid() and ply:IsPlayer() then
                CanGetRationTable[ply:SteamID64()] = true
                -- ply:ConCommand("play industrial17/rationsonline.mp3")
                ply:SendLua("LocalPlayer():EmitSound('industrial17/rationsonline.mp3', 55, 100, 1)")
                ply:notify("\"Attention Resident, You may now get your hourly ration. You have 10 minutes to do so!\"")
            end
        end
        NextRationTime = CurTime() + 4200
        HasNotifiedCps = false
        timer.Create("Stoprationcollection", 300, 1, function()
            for _, ply in pairs(player.GetAll()) do
                if not ply:IsValid() or not ply:IsPlayer() then return end
                CanGetRationTable[ply:SteamID64()] = false
                ply:SendLua("LocalPlayer():EmitSound('industrial17/rationsoffline.mp3', 55, 100, 1)")
                -- ply:ConCommand("play industrial17/rationsoffline.mp3")
                ply:notify("\"Attention Resident, the ration distribution terminal has now closed!\"")
            end
        end)
    end
    self:NextThink(CurTime() + 10)
end


function ENT:Use(Activator, Caller)
    local id = Caller:SteamID64()
    local sequencedispense = self:LookupSequence("dispense_package")
    local pos = self:GetPos() + self:GetForward() * 15 + self:GetRight() * -6 + self:GetUp() * -6
    local ang = self:GetAngles()

    if CanGetRationTable[Caller:SteamID64()] then
        if Caller:Team() == TEAM_CITIZEN or Caller:Team() == TEAM_CWU or Caller:Team() == TEAM_VORT or Caller:Team() == TEAM_CONSCRIPT then
            CanGetRationTable[Caller:SteamID64()] = false
            Caller:notify("Dispensing ration...")
            self:EmitSound("ambient/machines/combine_terminal_idle4.wav")
            self:ResetSequence(sequencedispense)
            self:SetSequence(sequencedispense)
            self:SequenceDuration(sequencedispense)

            if Caller:Team() == TEAM_CWU then
                local ration = ents.Create("ration_cwu")

                timer.Simple(1, function()
                    if (not IsValid(ration)) then return end -- Check whether we successfully made an entity, if not - bail
                    ration.owner = Caller:SteamID64()
                    ration:SetPos(pos)
                    ration:SetAngles(ang)
                    ration:Spawn()
                end)
            end

            if Caller:Team() == TEAM_CITIZEN then
                local ration = ents.Create("ration_cit")

                timer.Simple(1, function()
                    if (not IsValid(ration)) then return end -- Check whether we successfully made an entity, if not - bail
                    ration.owner = Caller:SteamID64()
                    ration:SetPos(pos)
                    ration:SetAngles(ang)
                    ration:Spawn()
                end)
            end

            if Caller:Team() == TEAM_CONSCRIPT then
            local ration = ents.Create("ration_cp")

                timer.Simple(1, function()
                    if (not IsValid(ration)) then return end -- Check whether we successfully made an entity, if not - bail
                    ration.owner = Caller:SteamID64()
                    ration:SetPos(pos)
                    ration:SetAngles(ang)
                    ration:Spawn()
                end)
            end

            if Caller:Team() == TEAM_VORT then
                local ration = ents.Create("ration_vort")

                timer.Simple(3, function()
                    if (not IsValid(ration)) then return end -- Check whether we successfully made an entity, if not - bail
                    ration.owner = Caller:SteamID64()
                    ration:SetPos(pos)
                    ration:SetAngles(ang)
                    ration:Spawn()
                end)
            end
        else
            Caller:notify"Your team cannot retrieve rations from here."
            self:EmitSound("buttons/combine_button2.wav")
        end
    elseif Caller:GetNWString("ration") == "reward" then
        local ration3 = ents.Create("ration_loyal")
        Caller:SetNWString("ration", "no")
        Caller:notify("Dispensing ration...")
        self:EmitSound("ambient/machines/combine_terminal_idle4.wav")
        self:ResetSequence(sequencedispense)
        self:SetSequence(sequencedispense)
        self:SequenceDuration(sequencedispense)
        timer.Simple(3, function()
            if (not IsValid(ration3)) then return end -- Check whether we successfully made an entity, if not - bail
            ration3.owner = Caller:SteamID64()
            ration3:SetPos(pos)
            ration3:SetAngles(ang)
            ration3:Spawn()
        end)
    else
        Caller:notify("Your ration is currently, unavailable. Please wait another " .. math.Round(NextRationTime - CurTime()) .. " seconds for your next ration!")
        -- Caller:notify "If you have recently joined, you must wait 10 minutes."
        self:EmitSound("buttons/combine_button2.wav")
    end
end

hook.Add("PlayerInitialSpawn", "Norationwhenyoujustrejoined!", function(ply)
    if CanGetRationTable then
        CanGetRationTable[ply:SteamID64()] = false
    end
end)