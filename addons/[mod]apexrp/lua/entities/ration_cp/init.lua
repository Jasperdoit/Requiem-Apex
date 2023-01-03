AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent. 
include('shared.lua')
 

function ENT:Initialize()
 
	self:SetModel( "models/weapons/w_packatm.mdl" )
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
	if not self.owner == ply:SteamID64() then
		return
	end

	local Jobmoney = 0
	local val1, val2 = 90, 100
	
	if ply:Team() == TEAM_CP then
		val1, val2 = 50,65
		Jobmoney = 300
	elseif ply:Team() == TEAM_CONSCRIPT then
		val1, val2 = 35,45
		Jobmoney = 200
	else
		Jobmoney = 350
	end
	
	ply:setDarkRPVar("Energy", math.Clamp((ply:getDarkRPVar("Energy") or 100) + math.random(val1,val2), 0, 100))

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