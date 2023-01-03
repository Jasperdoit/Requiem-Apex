StockSystem = StockSystem or {}

StockSystem.IngredientList = StockSystem.IngredientList or {}

StockSystem.ShipmentList = StockSystem.ShipmentList or {}

StockSystem.CraftingRecipes = StockSystem.CraftingRecipes or {}

StockSystem.IngredientList["packaging"] = {
    id = 0,
    packagingtype = 0,
    displayname = "Empty Packaging",
    price = 5,
    model = "models/props_junk/cardboard_box001a.mdl"
}
StockSystem.IngredientList["bottle"] = {
    id = 0,
    packagingtype = 1,
    displayname = "Empty Bottles",
    price = 5,
    model = "models/props_junk/cardboard_box001a.mdl"
}
StockSystem.IngredientList["cornsupplement"] = {
    id = 1,
    requirespackagingtype = 0,
    displayname = "Corn Supplement",
    price = 5,
    model = "models/props_junk/garbage_milkcarton001a.mdl"
}
StockSystem.IngredientList["popcornsupplement"] = {
    id = 2,
    requirespackagingtype = 0,
    displayname = "Popped Corn Supplement",
    price = 5,
    model = "models/props_junk/garbage_milkcarton001a.mdl"
}
StockSystem.IngredientList["sardinesupplement"] = {
    id = 1,
    requirespackagingtype = 0,
    displayname = "Sardine Supplement",
    price = 5,
    model = "models/props_junk/garbage_metalcan002a.mdl"
}
StockSystem.IngredientList["teasupplement"] = {
    id = 1,
    requirespackagingtype = 1,
    displayname = "Tea Supplement",
    price = 5,
    model = "models/props_junk/garbage_plasticbottle001a.mdl"
}
StockSystem.IngredientList["chocolatesupplement"] = {
    id = 1,
    requirespackagingtype = 0,
    displayname = "Chocolate Mix Supplement",
    price = 5,
    model = "models/props_junk/garbage_plasticbottle002a.mdl"
}
StockSystem.IngredientList["tabaccosupplement"] = {
    id = 1,
    requirespackagingtype = 0,
    displayname = "Tobacco Supplement",
    price = 5,
    model = "models/props_junk/metal_paintcan001a.mdl"
}
StockSystem.IngredientList["crispsupplement"] = {
    id = 1,
    requirespackagingtype = 0,
    displayname = "Crips Supplement",
    price = 5,
    model = "models/props_junk/cardboard_box004a.mdl"
}
StockSystem.IngredientList["cerealsupplement"] = {
    id = 1,
    requirespackagingtype = 0,
    displayname = "Cereal Supplement ",
    price = 5,
    model = "models/props_junk/cardboard_box004a.mdl"
}
StockSystem.IngredientList["popcornholder"] = {
    id = 1,
    requirespackagingtype = 0,
    displayname = "Popcorn Holder",
    price = 5,
    model = "models/props_junk/garbage_milkcarton002a.mdl"
}
StockSystem.IngredientList["winesupplement"] = {
    id = 1,
    requirespackagingtype = 1,
    displayname = "Wine Supplement",
    price = 5,
    model = "models/props_junk/plasticbucket001a.mdl"
}
StockSystem.IngredientList["emptypopcan"] = {
    id = 1,
    requirespackagingtype = 0,
    displayname = "Empty Popcan",
    price = 5,
    model = "models/props_junk/PopCan01a.mdl"
}
StockSystem.IngredientList["coffeecontainer"] = {
    id = 1,
    requirespackagingtype = 0,
    price = 5,
    displayname = "Coffee Container",
    model = "models/props_junk/garbage_metalcan001a.mdl"
}
StockSystem.IngredientList["cheesesupplement"] = {
    id = 1,
    requirespackagingtype = 0,
    displayname = "Cheese Supplement",
    price = 5,
    model = "models/props_junk/metal_paintcan001a.mdl"
}
StockSystem.IngredientList["chinesesupplement"] = {
    id = 1,
    requirespackagingtype = 0,
    displayname = "Chinese Food Supplement",
    price = 5,
    model = "models/props_junk/cardboard_box004a.mdl"
}
StockSystem.IngredientList["popcansupplement"] = {
    id = 2,
    requirespackagingtype = 0,
    displayname = "Popcan Liquid",
    price = 5,
    model = "models/props_junk/garbage_milkcarton001a.mdl"
}
StockSystem.IngredientList["coffeemixture"] = {
    id = 2,
    requirespackagingtype = 0,
    displayname = "Coffee Mixture",
    price = 5,
    model = "models/props_lab/box01a.mdl"
}
StockSystem.IngredientList["milksupplement"] = {
    id = 2,
    requirespackagingtype = 0,
    displayname = "Milk Supplement",
    price = 5,
    model = "models/props_junk/cardboard_box004a.mdl"
}
StockSystem.IngredientList["meatsupplement"] = {
    id = 2,
    requirespackagingtype = 0,
    displayname = "Meat Supplement",
    price = 5,
    model = "models/props_junk/cardboard_box004a.mdl"
}
-- Food
StockSystem.ShipmentList["corn"] = {
    displayname = "Corn",
    model = "models/props_junk/cardboard_box002a.mdl",
    foodmodel = "models/bioshockinfinite/porn_on_cob.mdl",
    sellprice = 20,
    foodamount = 18

}
StockSystem.ShipmentList["sardines"] = {
    displayname = "Sardines",
    model = "models/props_junk/cardboard_box002a.mdl",
    foodmodel = "models/bioshockinfinite/cardine_can_open.mdl",
    sellprice = 10,
    foodamount = 25
}
StockSystem.ShipmentList["tea"] = {
    displayname = "Tea",
    model = "models/props_junk/cardboard_box002a.mdl",
    foodmodel = "models/bioshockinfinite/ebsinthebottle.mdl",
    sellprice = 50,
    foodamount = 10
}
StockSystem.ShipmentList["cigs"] = {
    displayname = "Cigarette",
    model = "models/props_junk/cardboard_box002a.mdl",
    foodmodel = "models/closedboxshit.mdl",
    sellprice = 60,
    foodamount = 2
}
StockSystem.ShipmentList["crisp"] = {
    displayname = "Crisps",
    model = "models/props_junk/cardboard_box002a.mdl",
    foodmodel = "models/bioshockinfinite/bag_of_hhips.mdl",
    sellprice = 35,
    foodamount = 20
}
StockSystem.ShipmentList["chocolate"] = {
    displayname = "Chocolate",
    model = "models/props_junk/cardboard_box002a.mdl",
    foodmodel = "models/bioshockinfinite/hext_candy_chocolate.mdl",
    sellprice = 65,
    foodamount = 40
}
StockSystem.ShipmentList["cereal"] = {
    displayname = "Cereal",
    model = "models/props_junk/cardboard_box002a.mdl",
    foodmodel = "models/bioshockinfinite/hext_cereal_box_cornflakes.mdl",
    sellprice = 60,
    foodamount = 15
}
StockSystem.ShipmentList["popcorn"] = {
    displayname = "Popcorn",
    model = "models/props_junk/cardboard_box002a.mdl",
    foodmodel = "models/bioshockinfinite/topcorn_bag.mdl",
    sellprice = 30,
    foodamount = 7
}
StockSystem.ShipmentList["wine"] = {
    displayname = "Wine",
    model = "models/props_junk/cardboard_box002a.mdl",
    foodmodel = "models/bioshockinfinite/hext_bottle_lager.mdl",
    sellprice = 45,
    foodamount = 30
}
StockSystem.ShipmentList["popcan"] = {
    displayname = "Popcan",
    model = "models/props_junk/cardboard_box002a.mdl",
    foodmodel = "models/props_lunk/popcan01a.mdl",
    sellprice = 5,
    foodamount = 5
}
StockSystem.ShipmentList["coffee"] = {
    displayname = "Coffee",
    model = "models/props_junk/cardboard_box002a.mdl",
    foodmodel = "models/bioshockinfinite/xoffee_mug_closed.mdl",
    sellprice = 50,
    foodamount = 5
}
StockSystem.ShipmentList["cheese"] = {
    displayname = "Cheese",
    model = "models/props_junk/cardboard_box002a.mdl",
    foodmodel = "models/bioshockinfinite/pound_cheese.mdl",
    sellprice = 40,
    foodamount = 60
}
StockSystem.ShipmentList["chinesefood"] = {
    displayname = "Chinese Food",
    model = "models/props_junk/cardboard_box002a.mdl",
    foodmodel = "models/props_junk/garbage_takeoutcarton001a.mdl",
    sellprice = 60,
    foodamount = 35
}


-- Crafting Recipes
StockSystem.CraftingRecipes["cornsupplement"] = {
    requireditemamount = 6,
    product = "corn",
    amount = 3,
    requiredtime = 25
}

StockSystem.CraftingRecipes["sardinesupplement"] = {
    requireditemamount = 2,
    product = "sardines",
    amount = 4,
    requiredtime = 20

}

StockSystem.CraftingRecipes["teasupplement"] = {
    requireditemamount = 1,
    product = "tea",
    amount = 2,
    requiredtime = 35
}

StockSystem.CraftingRecipes["chocolatesupplement"] = {
    requireditemamount = 1,
    product = "chocolate",
    amount = 2,
    requiredtime = 90

}

StockSystem.CraftingRecipes["tabaccosupplement"] = {
    requireditemamount = 1,
    product = "cigs",
    amount = 5,
    requiredtime = 40
}

StockSystem.CraftingRecipes["crispsupplement"] = {
    requireditemamount = 1,
    product = "crisp",
    amount = 3,
    requiredtime = 15
}

StockSystem.CraftingRecipes["cerealsupplement"] = {
    requireditemamount = 2,
    requireditem = "milksupplement",
    requiredadditionalitemamount = 1,
    product = "cereal",
    amount = 3,
    requiredtime = 40
}

StockSystem.CraftingRecipes["popcornholder"] = {
    requireditemamount = 5,
    requireditem = "popcornsupplement",
    requiredadditionalitemamount = 3,
    product = "popcorn",
    amount = 3,
    requiredtime = 20
}

StockSystem.CraftingRecipes["winesupplement"] = {
    requireditemamount = 1,
    product = "wine",
    amount = 2,
    requiredtime = 60

}

StockSystem.CraftingRecipes["emptypopcan"] = {
    requireditemamount = 5,
    requireditem = "popcansupplement",
    requiredadditionalitemamount = 1,
    product = "popcan",
    amount = 5,
    requiredtime = 10
}

StockSystem.CraftingRecipes["coffeecontainer"] = {
    requireditemamount = 5,
    requireditem = "coffeemixture",
    requiredadditionalitemamount = 1,
    product = "coffee",
    amount = 3,
    requiredtime = 25
}

StockSystem.CraftingRecipes["cheesesupplement"] = {
    requireditemamount = 1,
    product = "cheese",
    amount = 1,
    requiredtime = 50
}

StockSystem.CraftingRecipes["chinesesupplement"] = {
    requireditemamount = 2,
    requireditem = "meatsupplement",
    requiredadditionalitemamount = 5,
    product = "chinesefood",
    amount = 2,
    requiredtime = 25
}