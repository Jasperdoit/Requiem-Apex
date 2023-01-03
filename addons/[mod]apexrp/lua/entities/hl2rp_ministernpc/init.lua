AddCSLuaFile( "cl_init.lua" ) -- This means the client will download these files
AddCSLuaFile( "shared.lua" )

include('shared.lua') -- At this point the contents of shared.lua are ran on the server only.

util.AddNetworkString("BecomeMinister")
util.AddNetworkString("OpenMinisterMenu")

function ENT:Initialize( ) --This function is run when the entity is created so it's a good place to setup our entity.

	self:SetModel( "models/hl2rp/male_09.mdl" ) -- Sets the model of the NPC.
	self:SetHullType( HULL_HUMAN ) -- Sets the hull type, used for movement calculations amongst other things.
	self:SetHullSizeNormal( )
	self:SetNPCState( NPC_STATE_SCRIPT )
    self:SetBodygroup( 1, 40)
    self:SetBodygroup( 2, 18 )
    self:SetSkin(2)
	self:SetSolid(  SOLID_BBOX ) -- This entity uses a solid bounding box for collisions.
	self:CapabilitiesAdd( CAP_ANIMATEDFACE, CAP_TURN_HEAD ) -- Adds what the NPC is allowed to do ( It cannot move in this case ).
	self:SetUseType( SIMPLE_USE ) -- Makes the ENT.Use hook only get called once at every use.
	self:DropToFloor()
	self:SetPersistent( false )
	self:SetMaxYawSpeed( 90 ) --Sets the angle by which an NPC can rotate at once.

end

/*
    FUNCTIONS
*/

function ENT:OnTakeDamage()

    return false -- This NPC won't take damage from anything.
    
end

function ENT:AcceptInput(i, a, c, d) -- What to do upon input

    if i == "Use" then -- Checks if the input is Use

        if c:Team() == TEAM_ADMINISTRATOR && c:IsPlayer() then -- Checks if the callers team is TEAM_ADMINISTRATOR and if the caller is a player

            c:ConCommand("minister_open");

        else

            c:notify("You need to be a CA in order to use me.")

        end

    end

end

net.Receive("BecomeMinister", function(len, ply)

    local plyn = ply:Name()
    local id = net.ReadInt(8)

    for k, v in pairs(MinisterRanks) do

        if k == id then

            if ply:IsAdmin() || ply:getXP() >= v.XP || GetConVar("hl2rp_gamenight"):GetInt() == 1 || GetConVar("hl2rp_noxp"):GetInt() == 1 then
                for k, XD in pairs(team.GetPlayers(TEAM_ADMINISTRATOR)) do
                    if XD:Team() == TEAM_ADMINISTRATOR && XD:getDarkRPVar("job") == v.NAME then
                        ply:notify("There is already a " .. v.NAME)
                        return
                    end
                end
				ply:SetBodygroup(1, 40)
				ply:SetBodygroup(2, 18)
				ply:UpdateJob(v.NAME)
				ply:notify("You successfully became a " .. v.NAME)
				return
            else
                ply:notify("Not enough XP.")
            end
        end
    end
end)