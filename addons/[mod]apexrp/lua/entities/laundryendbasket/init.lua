AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/props_wasteland/laundry_cart002.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
end

function ENT:Think()
	local pos = self:GetPos()
	for v,k in pairs(ents.FindByClass("laundryitem")) do
		if k.isFolded and k:GetPos():DistToSqr(pos) < 20 ^ 2 then
			local totalWorkers = table.Count(k.workers)
			local reward = math.floor(10 / totalWorkers)

			for ply,a in pairs(k.workers) do
				-- if IsValid(ply) and ply:IsPlayer() and ply:Team() == TEAM_CWU and ply:GetTeamClass() == CLASS_INDUST then
				if IsValid(ply) and ply:IsPlayer() and ply:Team() == TEAM_CWU and ply:GetNWInt("citopt") == 5 then
					ply:AddMoney(reward)
					ply:notify("You have received "..reward.." for working in the factory.")
					-- ply:ChatPrint("You have received "..reward.." for working in the factory.")
				end
			end

			k:Remove()
		end
	end
	self:NextThink(CurTime() + 2)
end
