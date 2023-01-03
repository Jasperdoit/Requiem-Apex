AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_lab/reciever01b.mdl")
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType( SIMPLE_USE )

    if !self.Data then
        print("Stored data wasn't valid! Removing "..self:GetClass())
        self:Remove()
    end

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetModuleLevel(self.Data.Level)
    self:SetModuleName(self.Data.Name)
    self:SetModuleActive(false)
    self:SetStartTime(CurTime())
    self:SetModuleExpire(self.Data.Time)
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then phys:Wake() end
end

timer.Create("moduleCheckIfExpired", 1, 0, function()
    for k, v in pairs(ents.FindByClass("ent_module")) do
        if (v:GetStartTime()+v:GetModuleExpire()) - CurTime() <= 0 then
            v:Remove()
        end
    end
end)

function ENT:OnTakeDamage(dmg)
    self.Entity:TakePhysicsDamage(dmg)
    if self.ModuleHealth <= 0 then return end

    self.ModuleHealth = self.ModuleHealth - dmg:GetDamage()
    if self.ModuleHealth <= 0 then
        if dmg:GetAttacker() && dmg:GetAttacker():IsPlayer() then
            local ply = dmg:GetAttacker()
            local effectdata = EffectData()
            effectdata:SetOrigin(self.Entity:GetPos())
            util.Effect("ManhackSparks", effectdata)
            self.Entity:EmitSound("weapons/physcannon/energy_disintegrate4.wav")
            ply:AddMoney(250)
            ply:notify("You have been awarded 250 tokens for destroying a module")
        end
        self.Entity:Remove()
    end
end

function ENT:Use(activator, caller)
    if !self:GetModuleActive() then
        if self.Data.HookType && self.Data.HookData then
            hook.Add(self.Data.HookType, self, self.Data.HookData)
        end
        self:SetModuleActive(true)
        self:SetStartTime(CurTime())
    else
        caller:PickupObject(self)
    end
end
