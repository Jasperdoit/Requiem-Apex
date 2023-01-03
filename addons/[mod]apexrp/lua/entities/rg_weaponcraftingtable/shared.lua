ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Weapon Crafting Table"
ENT.Spawnable = true
ENT.Category = "Universal Union"

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "WeaponClass")
    self:NetworkVar("String", 1, "WeaponsModel")
    self:NetworkVar("Int", 0, "WeaponTime")
    self:NetworkVar("Int", 1, "TableTier")
    self:NetworkVar("Int", 2, "Progress")
    self:NetworkVar("Int", 3, "WeaponItemIndex")
    self:NetworkVar("Bool", 0, "DoneCrafting")
end