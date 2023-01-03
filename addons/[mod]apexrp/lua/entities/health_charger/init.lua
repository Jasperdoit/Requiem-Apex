AddCSLuaFile( "cl_init.lua" ) -- This means the client will download these files
AddCSLuaFile( "shared.lua" )

include('shared.lua') -- At this point the contents of shared.lua are ran on the server only.

HealthChargerCooldown = HealthChargerCooldown or {}

function ENT:Initialize( ) --This function is run when the entity is created so it's a good place to setup our entity.

	self:SetModel( "models/props_combine/health_charger001.mdl" ) -- Sets the model of the NPC.
	self:SetSolid( SOLID_VPHYSICS )
    self:PhysicsInit( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
end

function ENT:OnTakeDamage()
	return false
end

function ENT:Use( Name, Activator, Caller )
    if HealthChargerCooldown[Activator:SteamID64()] and HealthChargerCooldown[Activator:SteamID64()] > CurTime() then
        Activator:notify("You cannot use this health charger for another " .. math.Round(HealthChargerCooldown[Activator:SteamID64()] - CurTime()) .. " seconds!")
        return
    end
    if Activator:Health() < 100 then
        if Activator:Team() == TEAM_OVERWATCH then
            Activator:SetHealth( 100 )
            Activator:notify("Your health has been restocked because you are an Overwatch unit.")
            HealthChargerCooldown[Activator:SteamID64()] = CurTime() + 60
        elseif Activator:Team() == TEAM_CP then
            Activator:SetHealth( 100 )
            Activator:notify("Your health has been restocked because you are an Civil Protection unit.")
            HealthChargerCooldown[Activator:SteamID64()] = CurTime() + 60
        elseif Activator:Team() == TEAM_CONSCRIPT then
            Activator:SetHealth( 100 )
            Activator:notify("Your health has been restocked because you are a Conscript unit.")
            HealthChargerCooldown[Activator:SteamID64()] = CurTime() + 60
        else
            if Activator:Health() < 65 then
                Activator:SetHealth( 65 )
                Activator:notify("Your health has been partially restocked.")
                HealthChargerCooldown[Activator:SteamID64()] = CurTime() + 60
            end
        end
    end
end
