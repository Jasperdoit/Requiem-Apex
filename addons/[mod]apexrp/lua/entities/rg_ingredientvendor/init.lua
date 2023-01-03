AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include("shared.lua")
util.AddNetworkString("Ingredient_openmenu")
util.AddNetworkString("Ingredient_Purchase")


function ENT:Initialize()

	self:SetModel("models/props_junk/wood_crate002a.mdl")
	self:PhysicsInit( SOLID_VPHYSICS ) 
	self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType( SIMPLE_USE )
	-- self:SetPos(self:GetPos() + Vector(0, 0, -12))
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(false)
	end
end

function ENT:Use(ply)
	net.Start("Ingredient_openmenu")
	net.Send(ply)
end

function ENT:AllowPlayerPickup(ply, ent)
	if not ply:IsAdmin() or ply:IsSuperAdmin() then return true
		else return false
	end
end

net.Receive("Ingredient_Purchase", function(len, ply)
	local ingredientvendornearby = false
	local ingredientvendor = nil
	for _, ent in pairs(ents.FindInSphere(ply:GetPos(), 64)) do
		if ent:GetClass() == "rg_ingredientvendor" then
			ingredientvendornearby = true
			ingredientvendor = ent
		end
	end
	if not ingredientvendornearby or not (ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_VORT) or ply:GetNWBool("IsRebelscum", false) then
		ply:notify("You may not fetch this at this time!")
	return end
	ply.nextingredientbuytime = ply.nextingredientbuytime or CurTime()
	if ply.nextingredientbuytime > CurTime() then
		return
	end
	local count = 0
	for _, ingredientitem in pairs(ents.FindByClass("rg_ingredient")) do
		count = count + 1
	end
	if count > 20 then
		ply:notify("The ingredient limit has been reached!")
		return
	end
	local count = 0
	for _, ingredientitem in pairs(ents.FindByClass("rg_packageitem")) do
		count = count + 1
	end
	if count > 20 then
		ply:notify("The ingredient limit has been reached!")
		return
	end

	local id = net.ReadString()
	local itemdata = StockSystem.IngredientList[id]
	if not itemdata then return end
	-- if ply.DarkRPVars.money  <= itemdata.price then
		
	-- 	ply:notify("You don't have enough money.")

	-- return end
	-- ply:AddMoney(-itemdata.price)
	-- ply:Give(itemdata.classname)
	-- ArcCW:PlayerGiveAtt(ply, itemdata.classname)
	-- ArcCW:PlayerSendAttInv(ply)
	local IngredientData = nil
	local ingredient = nil
	if itemdata then
		IngredientData = itemdata
		if IngredientData.id == 0 then
			ingredient = ents.Create("rg_packageitem")
		elseif IngredientData.id == 1 or IngredientData.id == 2 then
			ingredient = ents.Create("rg_ingredient")
		end
	end
	if IngredientData == nil or ingredient == nil then return end
	ingredient:SetModel(IngredientData.model)
	ingredient.Classname = id
	ingredient.DisplayName = IngredientData.displayname
	ingredient.TableData = IngredientData
	local trace = util.TraceLine({
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:EyeAngles():Forward() * 100
	})
	ingredient:SetPos(ingredientvendor:GetPos() + Vector(0,0,35))
	ingredient:Spawn()
	ply.nextingredientbuytime = CurTime() + .5
	-- ply:notify("You have successfully purchased a " .. itemdata.name .. "!")
end)
