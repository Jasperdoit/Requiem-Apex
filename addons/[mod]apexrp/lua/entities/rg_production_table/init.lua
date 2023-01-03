AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	self:SetModel("models/props_wasteland/controlroom_desk001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self:SetProductionStage(0)
	self:SetPackagingname("nil")
	self:SetIngredient1Name("nil")
	self:SetIngredient2Name("nil")
	self:SetIngredient1Amount(0)
	self:SetIngredient2Amount(0)
	self:SetCraftingTime(0)
	self.LastInputTime = CurTime()
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:Touch(object)
	-- Always check if we are dealing with a correct entity
	if not object:IsValid() or not object.Classname then return end
	-- See if the object has tabledata and if all waiting is done.
	if object.TableData and CurTime() > self.LastInputTime + 2 and self:GetCraftingTime() == 0 then
		self.LastInputTime = CurTime()
		local data = object.TableData
		-- If it's a packaging item and we have none, then we add it.
		if self:GetProductionStage() == 0 and data.id == 0 and self:GetPackagingname() == "nil" and self:GetCraftingTime() == 0 then
			self:SetPackagingname(object.Classname)
			self:SetProductionStage(1)
			object:Remove()
		end
		-- Yes, that is one very long if statement. No, I can't make it any shorter. I'll try and explain what it does:
		-- Check if we have the right stage with the right itemtype, right classname, no other item is present, it is a crafting recipe, it doesn't have enough items yet, has the right packageitem that goes along with the recipe, and is currently not making anything.
		if self:GetProductionStage() == 1 and data.id == 1 and (self:GetIngredient1Name() == "nil" or self:GetIngredient1Name() == object.Classname) and StockSystem.CraftingRecipes[object.Classname] and StockSystem.CraftingRecipes[object.Classname].requireditemamount > self:GetIngredient1Amount() and StockSystem.IngredientList[self:GetPackagingname()].packagingtype == data.requirespackagingtype and self:GetCraftingTime() == 0 then
			self:SetIngredient1Name(object.Classname)
			self:SetIngredient1Amount(self:GetIngredient1Amount() + 1)
			if StockSystem.CraftingRecipes[object.Classname].requireditem and StockSystem.CraftingRecipes[object.Classname].requireditemamount == self:GetIngredient1Amount() then
				self:SetProductionStage(2)
			end
			object:Remove()
		end
		if self:GetProductionStage() == 2 and data.id == 2 and (self:GetIngredient2Name() == "nil" or self:GetIngredient2Name() == object.Classname) and StockSystem.CraftingRecipes[self:GetIngredient1Name()].requiredadditionalitemamount > self:GetIngredient2Amount() and StockSystem.IngredientList[self:GetPackagingname()].packagingtype == data.requirespackagingtype and self:GetCraftingTime() == 0 then
			self:SetIngredient2Name(object.Classname)
			object:Remove()
			self:SetIngredient2Amount(self:GetIngredient2Amount() + 1)
		end
	end
end

function ENT:Use( activator, ply)
	if ply:IsPlayer() and (ply:Team() == TEAM_CP or ply:Team() == TEAM_CONSCRIPT) then
		ply:SetNWInt("RGStockCPHelpTime", CurTime() + 180)
		ply:notify("You have clocked on duty to guard deliveries for " .. ply:GetNWInt("RGStockCPHelpTime", 0) - CurTime() .. " Seconds!")
		timer.Create(ply:SteamID64() .. "CPGuardTime", 180, 1, function()
			if ply:IsValid() and ply:IsPlayer() and (ply:Team() == TEAM_CP or ply:Team() == TEAM_CONSCRIPT) then
				ply:notify("Your clock time has expired!")
			end
		end)
	end
    if (ply:Team() ~= TEAM_CITIZEN and ply:Team() ~= TEAM_VORT) or ply:GetNWBool("IsRebelscum", false) or not ply:IsPlayer() then return end
	if self:GetProductionStage() >= 1 and (self:GetIngredient1Name() ~= "nil" or self:GetPackagingname() ~= nil) and self:GetCraftingTime() == 0 then
		if StockSystem.CraftingRecipes[self:GetIngredient1Name()] and StockSystem.CraftingRecipes[self:GetIngredient1Name()].requireditemamount == self:GetIngredient1Amount() and self:GetProductionStage() == 1 then
			self:SetCraftingTime(CurTime() + StockSystem.CraftingRecipes[self:GetIngredient1Name()].requiredtime or 1)
			timer.Simple(StockSystem.CraftingRecipes[self:GetIngredient1Name()].requiredtime or 1, function()
				local product = ents.Create("rg_product")
				product.TableData = StockSystem.ShipmentList[StockSystem.CraftingRecipes[self:GetIngredient1Name()].product]
				product.Classname = StockSystem.CraftingRecipes[self:GetIngredient1Name()].product
				product.DisplayName = product.TableData.displayname .. " Shipment"
				product.Amount = StockSystem.CraftingRecipes[self:GetIngredient1Name()].amount
				product:SetModel(product.TableData.model)
				product:SetPos(self:GetPos() + Vector(0, 0, 50))
				product:Spawn()
				self:SetCraftingTime(0)
				self:SetIngredient1Amount(0)
				self:SetIngredient1Name("nil")
				self:SetIngredient2Amount(0)
				self:SetIngredient2Name("nil")
				self:SetProductionStage(0)
				self:SetPackagingname("nil")
			end)
		elseif StockSystem.CraftingRecipes[self:GetIngredient1Name()] and StockSystem.CraftingRecipes[self:GetIngredient1Name()].requireditemamount == self:GetIngredient1Amount() and StockSystem.CraftingRecipes[self:GetIngredient1Name()].requiredadditionalitemamount == self:GetIngredient2Amount() and self:GetProductionStage() == 2 then
			self:SetCraftingTime(CurTime() + StockSystem.CraftingRecipes[self:GetIngredient1Name()].requiredtime or 1)
			timer.Simple(StockSystem.CraftingRecipes[self:GetIngredient1Name()].requiredtime or 1, function()
				local product = ents.Create("rg_product")
				product.TableData = StockSystem.ShipmentList[StockSystem.CraftingRecipes[self:GetIngredient1Name()].product]
				product.Classname = StockSystem.CraftingRecipes[self:GetIngredient1Name()].product
				product.DisplayName = product.TableData.displayname .. " Shipment"
				product.Amount = StockSystem.CraftingRecipes[self:GetIngredient1Name()].amount
				product:SetModel(product.TableData.model)
				product:SetPos(self:GetPos() + Vector(0, 0, 50))
				product:Spawn()
				self:SetCraftingTime(0)
				self:SetIngredient1Amount(0)
				self:SetIngredient1Name("nil")
				self:SetIngredient2Amount(0)
				self:SetIngredient2Name("nil")
				self:SetProductionStage(0)
				self:SetPackagingname("nil")
			end)
		end
	end
end

local function Dropallshit(ply)
	if not ply:IsValid() or not ply:IsPlayer() or not ply:Team() == TEAM_CITIZEN then
		return
	end
	local trace = ply:GetEyeTrace()
	if trace.Entity:GetClass() == "rg_production_table" and ply:GetPos():DistToSqr(trace.Entity:GetPos()) < 100*100 then
		local craftingtable = trace.Entity
		while craftingtable:GetIngredient1Amount() > 0 and (craftingtable:GetIngredient1Name() ~= "nil") do
			local ingredient = ents.Create("rg_ingredient")
			ingredient.Classname = craftingtable:GetIngredient1Name()
			ingredient.TableData = StockSystem.IngredientList[ingredient.Classname]
			ingredient.DisplayName = ingredient.TableData.displayname
			ingredient:SetModel(ingredient.TableData.model)
			ingredient:SetPos(ply:GetPos() + Vector(0, 0, 30))
			ingredient:Spawn()
			craftingtable:SetIngredient1Amount(craftingtable:GetIngredient1Amount() - 1)
		end
		while craftingtable:GetIngredient2Amount() > 0 and (craftingtable:GetIngredient2Name() ~= "nil") do
			local ingredient = ents.Create("rg_ingredient")
			ingredient.Classname = craftingtable:GetIngredient2Name()
			ingredient.TableData = StockSystem.IngredientList[ingredient.Classname]
			ingredient.DisplayName = ingredient.TableData.displayname
			ingredient:SetModel(ingredient.TableData.model)
			ingredient:SetPos(ply:GetPos() + Vector(0, 0, 30))
			ingredient:Spawn()
			craftingtable:SetIngredient2Amount(craftingtable:GetIngredient2Amount() - 1)
		end
		craftingtable:SetIngredient1Name("nil")
		craftingtable:SetIngredient2Amount(0)
		craftingtable:SetIngredient2Name("nil")
		if craftingtable:GetPackagingname() ~= "nil" then
			local packageingredient = ents.Create("rg_ingredient")
			packageingredient.Classname = craftingtable:GetPackagingname()
			packageingredient.TableData = StockSystem.IngredientList[packageingredient.Classname]
			packageingredient.DisplayName = packageingredient.TableData.displayname
			packageingredient:SetModel(packageingredient.TableData.model)
			packageingredient:SetPos(ply:GetPos() + Vector(0, 0, 30))
			packageingredient:Spawn()
			craftingtable:SetPackagingname("nil")
			craftingtable:SetProductionStage(0)
		end
	end
end

DarkRP.defineChatCommand("empty", Dropallshit, 1.5);
DarkRP.declareChatCommand{
    command = "empty",
    description = "Empty vendor!",
    delay = 1.5
};