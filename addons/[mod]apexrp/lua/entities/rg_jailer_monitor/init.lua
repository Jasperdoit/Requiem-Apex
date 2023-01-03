AddCSLuaFile( "cl_init.lua" ) -- This means the client will download these files
AddCSLuaFile( "shared.lua" )

include('shared.lua') -- At this point the contents of shared.lua are ran on the server only.

util.AddNetworkString("rg_jailmonitor_open")

function ENT:Initialize( ) --This function is run when the entity is created so it's a good place to setup our entity.
	
	self:SetModel( "models/props_combine/combine_interface001.mdl" ) -- Sets the model of the NPC.
	self:PhysicsInit( SOLID_VPHYSICS ) 
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(false)
	end
end

function ENT:OnTakeDamage()
	return false
end 

function ENT:Use(ply)
	if (ply:Team() == TEAM_CP and (ply:getDivision() == DIVISION_JURY or ply:getDivision() == DIVISION_SECTORIAL or ply:getDivision() == DIVISION_OCMD)) or ply:Team() == TEAM_DISPATCH then
		net.Start("rg_jailmonitor_open")
		net.Send(ply)
	else
		ply:notify("You must be a Jury, CmD or SeC to use this terminal!")
	end
end