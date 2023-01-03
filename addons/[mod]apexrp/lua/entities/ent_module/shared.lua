
ENT.Base = "base_entity"
 
ENT.Category = "HL2RP"

ENT.PrintName= "ent_module"
ENT.Author= "Watermelon"
ENT.Purpose= "A default module"
ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.ModuleHealth = 100
ENT.Module = {}

function ENT:SetupDataTables()

    self:NetworkVar("Int", 0, "ModuleLevel")
    self:NetworkVar("String",0,"ModuleName")
    self:NetworkVar("Bool", 0, "ModuleActive")
    self:NetworkVar("Float", 0, "ModuleExpire")
    self:NetworkVar("Float", 1, "StartTime")

end
