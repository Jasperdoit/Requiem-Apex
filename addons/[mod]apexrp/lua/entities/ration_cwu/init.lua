AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent. 
include('shared.lua')
 

function ENT:Initialize()
 
	self:SetModel( "models/weapons/w_packatl.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType(SOLID_VPHYSICS)   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:SetUseType( SIMPLE_USE )
timer.Simple( 120, function() if self:IsValid() then
self:Remove() end end )
        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		timer.Simple(1.4,function() phys:Wake() end)
	end
end

function ENT:Use(ply)

if ply:Team() == TEAM_CWU then
	if not self.owner == ply:SteamID64() then
		return
	end
		ply:setDarkRPVar("Energy", math.Clamp((ply:getDarkRPVar("Energy") or 100) + (math.random(30,40)), 0, 100))
		local Jobmoney = 250
		money = Jobmoney - Jobmoney * (GetGlobalInt("tax") / 100)
		ply:AddMoney(money)
		SetGlobalInt("UUMoney", GetGlobalInt("UUMoney",0) + Jobmoney * (GetGlobalInt("tax") / 100))
		ply:notify("You received your hourly paycheck (T" .. money .. ") for this ration. Since the tax was " .. GetGlobalInt("tax") .. "%, you were taxed T" .. Jobmoney * (GetGlobalInt("tax") / 100) .. "!")
		ply:notify("You may come back in one hour to recive your next ration.")


	umsg.Start("AteFoodIcon", ply)
	umsg.End()

	ply:EmitSound("Eat.mp3", 100, 100)
	self:Remove()

end
end