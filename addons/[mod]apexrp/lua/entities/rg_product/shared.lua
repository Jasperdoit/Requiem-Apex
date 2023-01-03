ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Product"
ENT.Spawnable = false
ENT.Category = "Universal Union"

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "IngredientName")
    self:NetworkVar("Int", 0, "Amount")
end
