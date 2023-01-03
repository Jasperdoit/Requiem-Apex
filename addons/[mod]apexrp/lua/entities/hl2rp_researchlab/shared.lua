ENT.Type = "anim"
ENT.Base = "base_anim"
 
ENT.Category = "Universal Union"

ENT.PrintName= "Research lab"
ENT.Author= "Watermelon"
ENT.Purpose= "A factory"
ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.FactoryHealth = 250

ENT.UpgCost = 1000
ENT.UpgIncrAmount = 500
ENT.MaxLevel = 5

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "FactoryLevel")
end

DarkRP.declareChatCommand{
    command = "upgrade",
    description = "Upgrade your research machine.",
    delay = 1.5
};