AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include('shared.lua') -- At this point the contents of shared.lua are ran on the server only.

--This function is run when the entity is created so it's a good place to setup our entity.
function ENT:Initialize()
    self:SetModel("models/props_combine/combine_dispenser.mdl") -- Sets the model of the NPC. // 
    self:SetSolid(SOLID_BBOX)
    self:SetUseType(SIMPLE_USE)
    self:SetPlaybackRate(1.0)
end

function ENT:OnTakeDamage()
    return false
end

function ENT:Use(Activator, Caller)
    local sequencedispense = self:LookupSequence("dispense_package")
    local pos = self:GetPos() + self:GetForward() * 15 + self:GetRight() * -6 + self:GetUp() * -6
    local ang = self:GetAngles()

    if Caller:GetNWBool("HasRewardRation", false) then
        self:ResetSequence(sequencedispense)
        self:SetSequence(sequencedispense)
        self:SequenceDuration(sequencedispense)
        Caller:notify("Dispensing ration...")
        self:EmitSound("ambient/machines/combine_terminal_idle4.wav")

        if Caller:IsCP() then
            Caller:SetNWBool("HasRewardRation", false)
            local rationcp = ents.Create("ration_cp_loyal")
            timer.Simple(1, function()
                if (not IsValid(rationcp)) then return end -- Check whether we successfully made an entity, if not - bail
                rationcp:SetPos(pos)
                rationcp:SetAngles(ang)
                rationcp:Spawn()
            end)
        end
        return
    end

    if CanGetRationTable[Caller:SteamID64()] then
        if Caller:IsCP() or caller:Team() == TEAM_ADMINISTRATOR then
            self:ResetSequence(sequencedispense)
            self:SetSequence(sequencedispense)
            self:SequenceDuration(sequencedispense)
            CanGetRationTable[Caller:SteamID64()] = false
            Caller:SetNWString("ration", "no")
            Caller:notify("Dispensing ration...")
            self:EmitSound("ambient/machines/combine_terminal_idle4.wav")

            if Caller:IsCP() then
                local rationcp = ents.Create("ration_cp")

                timer.Simple(1, function()
                    if (not IsValid(rationcp)) then return end -- Check whether we successfully made an entity, if not - bail
                    rationcp.owner = Caller:SteamID()
                    rationcp:SetPos(pos)
                    rationcp:SetAngles(ang)
                    rationcp:Spawn()
                end)
            end
        else
            Caller:notify"Your team cannot retrieve rations from here."
            self:EmitSound("buttons/combine_button2.wav")
        end
    else
        Caller:notify("Your ration is currently, unavailable. Please wait another " .. math.Round(NextRationTime - CurTime()) .. " seconds for your next ration!")
        self:EmitSound("buttons/combine_button2.wav")
    end
end