ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Ingredient"
ENT.Spawnable = false
ENT.Category = "Universal Union"

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "IngredientName")
end
