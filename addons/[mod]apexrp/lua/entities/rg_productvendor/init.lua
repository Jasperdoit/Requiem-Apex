AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include("shared.lua")
util.AddNetworkString("Product_openmenu")
util.AddNetworkString("Product_Purchase")


function ENT:Initialize()

	self:SetModel("models/props_junk/wood_crate002a.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType(SOLID_VPHYSICS)
	self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType( SIMPLE_USE )
	if self.SID then
		for _, ply in pairs(player.GetAll()) do
			if self.SID == ply:SteamID() then
			print(ply:Name() .. " owns this!")
			self:Setowning_ent(ply)
			end
		end
	end
	self.ShareGravgun = true
	-- self:SetPos(self:GetPos() + Vector(0, 0, -12))
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(false)
	end
end

function ENT:Use(ply)
	if not ply:IsPlayer() or ply:Team() ~= TEAM_CWU then
		ply:notify("You must go CWU Cook to use this!")
		return
	end
	net.Start("Product_openmenu")
	net.Send(ply)
end

function ENT:AllowPlayerPickup(ply, ent)
	if not ply:IsAdmin() or ply:IsSuperAdmin() then return true
		else return false
	end
end

net.Receive("Product_Purchase", function(len, ply)
	local ingredientvendornearby = false
	local ingredientvendor = nil
	for _, ent in pairs(ents.FindInSphere(ply:GetPos(), 64)) do
		if ent:GetClass() == "rg_productvendor" then
			ingredientvendornearby = true
			ingredientvendor = ent
		end
	end
	if not ingredientvendornearby or ply:GetNWBool("IsRebelscum", false) then
		ply:notify("You may not fetch this at this time!")
	return end
	if ply:Team() != TEAM_CWU or ply:GetNWInt("citopt") != 2 then
		ply:notify("You are not the right job!")
	return end
	ply.nextproductbuytime = ply.nextproductbuytime or CurTime()
	if ply.nextproductbuytime > CurTime() then
		return
	end
	local id = net.ReadString()
	local itemdata = StockSystem.ShipmentList[id]
	if not itemdata then return end
    local itemcost = math.Round(itemdata.sellprice * math.Clamp(20 / GetGlobalInt(id), 1, 50))
	itemcostvat = math.Round(itemcost + itemcost * (GetGlobalInt("tax", 0) / 100))
	if ply.DarkRPVars.money <= itemcostvat then
		ply:notify("You don't have enough money.")
	return end
	ply:AddMoney(-itemcostvat)
	SetGlobalInt("uumoney", GetGlobalInt("uumoney") + math.Round(itemcost * (GetGlobalInt("tax", 0) / 100)))
	
	ply:notify("You have bought, " .. id .. " for T" .. itemcostvat .. "!")
	-- ArcCW:PlayerGiveAtt(ply, itemdata.classname)
	-- ArcCW:PlayerSendAttInv(ply)
	if GetGlobalInt(id) > 0 then
		SetGlobalInt(id, GetGlobalInt(id) - 1)
	end
	local SpawnedFood = ents.Create("spawned_food")
	SpawnedFood:Setowning_ent(ply)
	SpawnedFood.ShareGravgun = true
	SpawnedFood:SetPos(ingredientvendor:GetPos() + Vector(0,0,30))
	SpawnedFood.onlyremover = true
	SpawnedFood.SID = ply.SID
	SpawnedFood:SetModel(itemdata.foodmodel)
	SpawnedFood:GetTable().FoodEnergy = itemdata.foodamount
	SpawnedFood.foodItem = {}
	SpawnedFood:Spawn()
	print(SpawnedFood:GetClass())

	ply.nextproductbuytime = CurTime() + 1
	-- ply:notify("You have successfully purchased a " .. itemdata.name .. "!")
end)
