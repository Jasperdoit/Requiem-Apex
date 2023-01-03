AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')


	function ENT:Initialize()
		self.buttons = {}

		local position = self:GetPos()
		local f, r, u = self:GetForward(), self:GetRight(), self:GetUp()

		self.buttons[1] = position + f*18 + r*-24.4 + u*5.3
		self.buttons[2] = position + f*18 + r*-24.4 + u*3.35
		self.buttons[3] = position + f*18 + r*-24.4 + u*1.35

		self:SetModel("models/props_interiors/VendingMachineSoda01a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		self:SetStocks(util.TableToJSON({10, 5, 5}));
		self:SetActive(1);

		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(false)
			physObj:Sleep()
		end

	end

	function ENT:Use(activator)
		activator:EmitSound("buttons/lightswitch2.wav", 55, 125)

		if ((self.nextUse or 0) < CurTime()) then
			self.nextUse = CurTime() + 2
		else
			return
		end

		local button = self:getNearestButton(activator)
		local stocks = util.JSONToTable(self:GetStocks());

		if (activator:isCombine()) or ( activator:Team() == TEAM_CWU) then
			if (activator:KeyDown(IN_SPEED) and button and stocks[button]) then
				if (stocks[button] > 0) then
					return activator:notify("NO REFILL IS REQUIRED FOR THIS MACHINE.")
				end

				self:EmitSound("buttons/button5.wav")
					activator:notify("You have been rewarded 25 tokens for refilling this machine!")
					activator:addMoney(25)

				timer.Simple(1, function()
					if (!IsValid(self)) then return end

					stocks[button] = button == 1 and 10 or 5
					self:SetStocks(util.TableToJSON(stocks));
				end)

				return
			-- else

			-- 	self:EmitSound("buttons/combine_button1.wav" or "buttons/combine_button2.wav")

			-- 	return
			end
		end

		if (self:GetActive() == 0) then
			return
		end

		if (button and stocks and stocks[button] and stocks[button] > 0) then
			local item = "water"
			local price = 5
			local power = 1
			local skin = 0
			local brewing = false

			if (button == 2) then
				item = "water_sparkling"
				price = price + 10
				power = 3
				skin = 2
			elseif (button == 3) then
				item = "water_special"
				price = price + 15
				power = 5
				skin = 1
				brewing = true;
			end

			if (!activator:canAfford(price)) then
				self:EmitSound("buttons/button2.wav")

				return activator:notify("You need "..price.." tokens to purchase this selection.")
			end

			local position = self:GetPos()
			local f, r, u = self:GetForward(), self:GetRight(), self:GetUp()

--			nut.item.spawn(item, position + f*19 + r*4 + u*-26, function(item, entity)

				local SpawnedFood = ents.Create("spawned_food")
				SpawnedFood.ShareGravgun = true
				SpawnedFood:SetPos(position + f*9 + r*4 + u*-12)
				SpawnedFood.onlyremover = true
				SpawnedFood:SetModel("models/props_junk/PopCan01a.mdl")
				SpawnedFood:SetSkin(skin)
				SpawnedFood:GetTable().FoodEnergy = power;
				SpawnedFood.foodItem = {};
				SpawnedFood.brewing = brewing;
				SpawnedFood:Spawn();

				stocks[button] = stocks[button] - 1

				if (stocks[button] < 1) then
					self:EmitSound("buttons/button6.wav")
				end

				self:SetStocks(util.TableToJSON(stocks));
				self:EmitSound("buttons/button4.wav")

				activator:addMoney(-price)
				activator:notify("You have spent "..price.." tokens on this vending machine.")

		end
	end
