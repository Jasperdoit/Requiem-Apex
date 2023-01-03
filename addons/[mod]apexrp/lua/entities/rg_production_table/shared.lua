ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Production Table"
ENT.Spawnable = true
ENT.Category = "Universal Union"

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "Packagingname")
    self:NetworkVar("String", 1, "Ingredient1Name")
    self:NetworkVar("String", 2, "Ingredient2Name")
    self:NetworkVar("String", 3, "ProductName")
    self:NetworkVar("Int", 0, "ProductionStage")
    self:NetworkVar("Int", 1, "Ingredient1Amount")
    self:NetworkVar("Int", 2, "Ingredient2Amount")
    self:NetworkVar("Int", 3, "ProductAmount")
    self:NetworkVar("Int", 4, "CraftingTime")
end
