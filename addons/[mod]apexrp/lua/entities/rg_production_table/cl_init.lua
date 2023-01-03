include("shared.lua")
surface.CreateFont("Arial28", {
	font = "Arial",
	size = 28,
	extended = false
})
surface.CreateFont("Helvetica20", {
	font = "Helvetica",
	size = 40,
	extended = false,
	outline = true,
	shadow = false,
})
surface.CreateFont("Helvetica30", {
	font = "Helvetica",
	size = 30,
	extended = false,
	outline = true,
})
surface.CreateFont("Helvetica22", {
	font = "Helvetica",
	size = 22,
	extended = false,
	outline = true,
})

DarkRP.declareChatCommand{
    command = "empty",
    description = "Empty vendor!",
    delay = 1.5
};

local color_white = Color( 255, 255, 255 )
local color_grey = Color( 91, 91, 91 )
local color_red = Color( 212, 52, 52 )
local color_yellow = Color(255, 255, 0)
local color_green = Color( 33, 255, 0 )

function ENT:Draw()
	local name = nil
	self:DrawModel()
	-- Labels
	local pos, ang = self:GetPos(), self:GetAngles()
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 270)
	cam.Start3D2D(pos + ang:Right()*-16 + ang:Forward()*-50 + ang:Up()*21, ang, 0.11)
		draw.SimpleText("Universal-Union", "Arial28", 0, 0, color_white, 1,1)
	cam.End3D2D()
	cam.Start3D2D(pos + ang:Right()*-16 + ang:Forward()*50 + ang:Up()*21, ang, 0.11)
		draw.SimpleText("Production Table", "Arial28", 0, 0, color_white, 1,1)
	cam.End3D2D()
	-- Overview
	local pos, ang = self:GetPos(), self:GetAngles()
	ang:RotateAroundAxis(ang:Up(), 90)
	cam.Start3D2D(pos + ang:Up()*17 + ang:Right()*-15, ang, 0.11)
		draw.SimpleText("Overview", "Helvetica20", 0, 0, color_grey, TEXT_ALIGN_CENTER,1)
	cam.End3D2D()
	if self:GetCraftingTime() ~= 0 then
		cam.Start3D2D(pos + ang:Up()*17 + ang:Right()*-10, ang, 0.11)
			draw.SimpleText("Crafting: " .. math.Round(self:GetCraftingTime() - CurTime()), "Helvetica20", 0, 0, color_white, TEXT_ALIGN_CENTER,1)
		cam.End3D2D()
	end
	-- Packaging item
	if self:GetPackagingname() ~= "nil" and StockSystem.IngredientList[self:GetPackagingname()].displayname then
		name = StockSystem.IngredientList[self:GetPackagingname()].displayname
		cam.Start3D2D(pos + ang:Forward()*-60 + ang:Up()*17 + ang:Right()*-2, ang, 0.11)
			draw.SimpleText("Packaging item: ", "Helvetica20", 0, 0, color_grey, TEXT_ALIGN_LEFT,1)
		cam.End3D2D()
		cam.Start3D2D(pos + ang:Forward()*-60 + ang:Up()*17 + ang:Right()*2, ang, 0.11)
			draw.SimpleText(name, "Helvetica30", 0, 0, color_green, TEXT_ALIGN_LEFT,1)
		cam.End3D2D()
	else
		cam.Start3D2D(pos + ang:Forward()*-60 + ang:Up()*17 + ang:Right()*-2, ang, 0.11)
			draw.SimpleText("Packaging item: ", "Helvetica20", 0, 0, color_grey, TEXT_ALIGN_LEFT,1)
		cam.End3D2D()
		cam.Start3D2D(pos + ang:Forward()*-60 + ang:Up()*17 + ang:Right()*2, ang, 0.11)
			draw.SimpleText("Empty Packaging", "Helvetica30", 0, 0, color_red, TEXT_ALIGN_LEFT,1)
		cam.End3D2D()
		cam.Start3D2D(pos + ang:Forward()*-60 + ang:Up()*17 + ang:Right()*6, ang, 0.11)
			draw.SimpleText("Empty Bottle", "Helvetica30", 0, 0, color_red, TEXT_ALIGN_LEFT,1)
		cam.End3D2D()
	end
	-- Stage1item
	if self:GetProductionStage() >= 1 then
		cam.Start3D2D(pos + ang:Forward()*-20 + ang:Up()*17 + ang:Right()*-2, ang, 0.11)
			draw.SimpleText("Supplement/Item: ", "Helvetica20", 0, 0, color_grey, TEXT_ALIGN_LEFT,1)
		cam.End3D2D()
		if self:GetIngredient1Name() ~= "nil" and StockSystem.IngredientList[self:GetIngredient1Name()].displayname and StockSystem.CraftingRecipes[self:GetIngredient1Name()] then
			local recipe = StockSystem.CraftingRecipes[self:GetIngredient1Name()]
			if recipe.requireditemamount > self:GetIngredient1Amount() then
				cam.Start3D2D(pos + ang:Forward()*-20 + ang:Up()*17 + ang:Right()*2, ang, 0.11)
					draw.SimpleText(StockSystem.IngredientList[self:GetIngredient1Name()].displayname .. "(" .. StockSystem.CraftingRecipes[self:GetIngredient1Name()].requireditemamount - self:GetIngredient1Amount() .. ")", "Helvetica22", 0, 0, color_yellow, TEXT_ALIGN_LEFT,1)
				cam.End3D2D()
			else
				cam.Start3D2D(pos + ang:Forward()*-20 + ang:Up()*17 + ang:Right()*2, ang, 0.11)
					draw.SimpleText(StockSystem.IngredientList[self:GetIngredient1Name()].displayname, "Helvetica22", 0, 0, color_green, TEXT_ALIGN_LEFT,1)
				cam.End3D2D()
			end
		else
			if self:GetPackagingname() == "packaging" then
				cam.Start3D2D(pos + ang:Forward()*-20 + ang:Up()*17 + ang:Right()*2, ang, 0.11)
					draw.SimpleText("Corn Supplement", "Helvetica22", 0, 0, color_red, TEXT_ALIGN_LEFT,1)
				cam.End3D2D()
				cam.Start3D2D(pos + ang:Forward()*-20 + ang:Up()*17 + ang:Right()*6, ang, 0.11)
					draw.SimpleText("Sardine Supplement", "Helvetica22", 0, 0, color_red, TEXT_ALIGN_LEFT,1)
				cam.End3D2D()
				cam.Start3D2D(pos + ang:Forward()*-20 + ang:Up()*17 + ang:Right()*10, ang, 0.11)
					draw.SimpleText("Tobaco Supplement", "Helvetica22", 0, 0, color_red, TEXT_ALIGN_LEFT,1)
				cam.End3D2D()
				cam.Start3D2D(pos + ang:Forward()*-20 + ang:Up()*17 + ang:Right()*14, ang, 0.11)
					draw.SimpleText("Crisp Supplement", "Helvetica22", 0, 0, color_red, TEXT_ALIGN_LEFT,1)
				cam.End3D2D()
				cam.Start3D2D(pos + ang:Forward()*-20 + ang:Up()*17 + ang:Right()*18, ang, 0.11)
					draw.SimpleText("Cereal Supplement", "Helvetica22", 0, 0, color_red, TEXT_ALIGN_LEFT,1)
				cam.End3D2D()
				--Rightside
				cam.Start3D2D(pos + ang:Forward() + ang:Up()*17 + ang:Right()*2, ang, 0.11)
					draw.SimpleText("Popcans", "Helvetica22", 0, 0, color_red, TEXT_ALIGN_LEFT,1)
				cam.End3D2D()
				cam.Start3D2D(pos + ang:Forward() + ang:Up()*17 + ang:Right()*6, ang, 0.11)
					draw.SimpleText("Popcorn holder", "Helvetica22", 0, 0, color_red, TEXT_ALIGN_LEFT,1)
				cam.End3D2D()
				cam.Start3D2D(pos + ang:Forward() + ang:Up()*17 + ang:Right()*10, ang, 0.11)
					draw.SimpleText("Coffee holder", "Helvetica22", 0, 0, color_red, TEXT_ALIGN_LEFT,1)
				cam.End3D2D()
				cam.Start3D2D(pos + ang:Forward() + ang:Up()*17 + ang:Right()*14, ang, 0.11)
					draw.SimpleText("Cheese Supplement", "Helvetica22", 0, 0, color_red, TEXT_ALIGN_LEFT,1)
				cam.End3D2D()
				cam.Start3D2D(pos + ang:Forward() + ang:Up()*17 + ang:Right()*18, ang, 0.11)
					draw.SimpleText("Chinese Supplement", "Helvetica22", 0, 0, color_red, TEXT_ALIGN_LEFT,1)
				cam.End3D2D()
				cam.Start3D2D(pos + ang:Forward() + ang:Up()*17 + ang:Right()*4, ang, 0.11)
					draw.SimpleText("Chocolate Mix Supplement", "Helvetica22", 0, 0, color_red, TEXT_ALIGN_LEFT,1)
				cam.End3D2D()
			elseif self:GetPackagingname() == "bottle" then
				cam.Start3D2D(pos + ang:Forward()*-20 + ang:Up()*17 + ang:Right()*2, ang, 0.11)
					draw.SimpleText("Wine Supplement", "Helvetica22", 0, 0, color_red, TEXT_ALIGN_LEFT,1)
				cam.End3D2D()
				cam.Start3D2D(pos + ang:Forward()*-20 + ang:Up()*17 + ang:Right()*6, ang, 0.11)
					draw.SimpleText("Tea Supplement", "Helvetica22", 0, 0, color_red, TEXT_ALIGN_LEFT,1)
				cam.End3D2D()
			end
		end
	end
	-- Stage2item
	if self:GetProductionStage() == 2 then
		cam.Start3D2D(pos + ang:Forward()*40 + ang:Up()*17 + ang:Right()*-2, ang, 0.11)
			draw.SimpleText("Additional Item: ", "Helvetica20", 0, 0, color_grey, TEXT_ALIGN_LEFT,1)
		cam.End3D2D()
		if self:GetIngredient1Name() ~= "nil" and StockSystem.CraftingRecipes[self:GetIngredient1Name()].requireditem then
			local neededitem = StockSystem.CraftingRecipes[self:GetIngredient1Name()].requireditem
			local neededitemname = StockSystem.IngredientList[neededitem].displayname
			if self:GetIngredient2Name() == neededitem and self:GetIngredient2Amount() < StockSystem.CraftingRecipes[self:GetIngredient1Name()].requiredadditionalitemamount then
				cam.Start3D2D(pos + ang:Forward()*40 + ang:Up()*17 + ang:Right()*2, ang, 0.11)
						draw.SimpleText(neededitemname .. "(" .. StockSystem.CraftingRecipes[self:GetIngredient1Name()].requiredadditionalitemamount - self:GetIngredient2Amount() .. ")", "Helvetica22", 0, 0, color_yellow, TEXT_ALIGN_LEFT,1)
				cam.End3D2D()
			elseif self:GetIngredient2Name() == neededitem and self:GetIngredient2Amount() == StockSystem.CraftingRecipes[self:GetIngredient1Name()].requiredadditionalitemamount then
				cam.Start3D2D(pos + ang:Forward()*40 + ang:Up()*17 + ang:Right()*2, ang, 0.11)
						draw.SimpleText(neededitemname, "Helvetica22", 0, 0, color_green, TEXT_ALIGN_LEFT,1)
				cam.End3D2D()
			else
				cam.Start3D2D(pos + ang:Forward()*40 + ang:Up()*17 + ang:Right()*2, ang, 0.11)
						draw.SimpleText(neededitemname .. "(" .. StockSystem.CraftingRecipes[self:GetIngredient1Name()].requiredadditionalitemamount - self:GetIngredient2Amount() .. ")", "Helvetica22", 0, 0, color_red, TEXT_ALIGN_LEFT,1)
				cam.End3D2D()
			end
		end
	end
end
