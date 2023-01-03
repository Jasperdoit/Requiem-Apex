AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	-- self:SetModel("models/props_junk/wood_crate001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self.DespawnTime = CurTime() + 120
	local phys = self:GetPhysicsObject()
	if self.DisplayName then
		self:SetIngredientName(self.DisplayName)
	end
	if phys:IsValid() then

		phys:Wake()
	end
end


function ENT:Use( activator, ply)
	ply:PickupObject(self)
end

function ENT:Think()
	if CurTime() >= self.DespawnTime then
		self:Remove()
	end
	self:NextThink(10)
end