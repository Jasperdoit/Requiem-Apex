StockSystem.StocksList = StockSystem.StocksList or {}

-- concommand.Add("rg_ingredient_create", function(ply, _, args)
--     if not ply:IsValid() or not ply:IsValid() or not ply:Alive() then return end
--     if not args then return end
--     if StockSystem.IngredientList then
--         local IngredientData = nil
--         local ingredient = nil
--         if StockSystem.IngredientList[args[1]] then
--             IngredientData = StockSystem.IngredientList[args[1]]
--             if IngredientData.id == 0 then
--                 ingredient = ents.Create("rg_packageitem")
--             elseif IngredientData.id == 1 then
--                 ingredient = ents.Create("rg_packageitem")
--             end
--         end
--         if IngredientData == nil or ingredient == nil then return end
--         ingredient:SetModel(IngredientData.model)
--         ingredient.Classname = args[1]
--         ingredient.DisplayName = IngredientData.displayname
--         ingredient.TableData = IngredientData
--         ingredient:SetPos(ply:GetPos() + Vector(0, 0, 30))
--         ingredient:Spawn()
--     end
-- end)

for index, item in pairs(StockSystem.ShipmentList) do
    SetGlobalInt( index, GetGlobalInt(index, 10))
    -- SetGlobalInt( index, 5)
end

concommand.Add("rg_economicdepression", function(ply)
    if not ply:IsSuperAdmin() then return end
    for index, item in pairs(StockSystem.ShipmentList) do
        SetGlobalInt( index, math.random(5, 8))
    end
end)

timer.Create("ProductResetTimer", 7200, 0, function()
    for index, item in pairs(StockSystem.ShipmentList) do
        SetGlobalInt( index, math.random(8, 14))
    end
end)