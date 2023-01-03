AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	-- self:SetModel("models/props_junk/wood_crate001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	if self.DisplayName then
		self:SetIngredientName(self.DisplayName)
	end
	if self.TableData and self.TableData.Amount then
		self:SetAmount(self.TableData.Amount)
	end
	if phys:IsValid() then

		phys:Wake()
	end
	self.Damage = 40
end

function ENT:OnTakeDamage(dmg)
	self.Damage = self.Damage - dmg:GetDamage()
	if self.Damage <= 0 then
		local Attacker = dmg:GetAttacker()
		if Attacker:IsValid() and Attacker:IsPlayer() and Attacker:Team(TEAM_CITIZEN) and Attacker:GetNWBool("IsRebelScum", false) then
			Attacker:AddMoney(math.Round(self.TableData.sellprice * (20 / math.Clamp(GetGlobalInt(self.Classname), 1, 50)) * 0.6))
			Attacker:notify("You have destroyed good worth T" .. (math.Round(self.TableData.sellprice * (20 / math.Clamp(GetGlobalInt(self.Classname), 1, 50)) * 0.6)) .. "!")
			self:Remove()
		end
	end
end

function ENT:Use( activator, ply)
	ply:PickupObject(self)
end
