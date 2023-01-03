ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Packaging item"
ENT.Spawnable = true
ENT.Category = "Universal Union"

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "IngredientName")
end
