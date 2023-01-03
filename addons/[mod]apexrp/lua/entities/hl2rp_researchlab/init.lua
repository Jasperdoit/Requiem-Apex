AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_wasteland/laundry_washer003.mdl")
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetFactoryLevel(1)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
    if (phys:IsValid()) then
		phys:Wake()
	end

end

hook.Add("EntityTakeDamage", "factoryNoPropKill", function(targ, dmg)
    if IsValid(dmg:GetInflictor()) and dmg:GetInflictor():GetClass() == "hl2rp_researchlab" then
        dmg:SetDamage(0)
    end
end)

function ENT:OnTakeDamage(dmg)
    self.Entity:TakePhysicsDamage(dmg)
    if self.FactoryHealth <= 0 then return end

    self.FactoryHealth = self.FactoryHealth - dmg:GetDamage()
    if self.FactoryHealth <= 0 then
        if dmg:GetAttacker() && dmg:GetAttacker():IsPlayer() then
            local ply = dmg:GetAttacker()
            local effectdata = EffectData()
            effectdata:SetOrigin(self.Entity:GetPos())
            util.Effect("ManhackSparks", effectdata)
            self.Entity:EmitSound("weapons/physcannon/energy_disintegrate4.wav")
            if dmg:GetAttacker():Team() == TEAM_CITIZEN then
                ply:AddMoney(250)
                ply:notify("You have been awarded 250 tokens for destroying a laboratory")
            else
                ply:notify("You have been destroyed the lab")
            end
        end
        self.Entity:Remove()
    end
end

function ENT:Use(activator, caller)
    if caller:GetNWInt("citopt") != 6 || caller:Team() != TEAM_CWU then return end
    caller:PickupObject(self)
end

timer.Create("ResearchAdd", 2, 0, function()
    local str = GetGlobalString("keyres","none")
    local level = GetGlobalInt("Level", 1)
    str = string.gsub(str, tostring(level), "")
    if !wmResearch[str] then return end
    local progress = GetGlobalInt("Progress",0)
    for k, v in pairs(ents.FindByClass("hl2rp_researchlab")) do
        local level = v:GetFactoryLevel()
        progress = progress+(3*math.pow(2, level))
        SetGlobalInt("Progress", progress)
        SetGlobalInt(GetGlobalString("keyres","none"), progress)
    end
    if progress >= GetGlobalInt("Required",0) then
        local research = wmResearch[str]
        research.Level = level
        local duration = research.CustomDuration(research.Time, level)
        local eject = table.Random(ents.FindByClass("hl2rp_researchlab"))
        
        if research.Type == TYPE_MODULE then
            local module = ents.Create("ent_module")
            module:SetPos(eject:GetPos()+eject:GetUp()*10)
            module.Data = table.Copy(research)
            module.Data.Time = duration
            module:Spawn()
        elseif research.Type == TYPE_WEAPON then
            local entity = ents.Create("worlditem")
            entity:SetPos(eject:GetPos()+eject:GetUp()*10)
            local data = wmGetItem(entity.Data.WeaponClass)
            if !util.IsValidModel(data.Mdl) then
                entity:SetModel("models/props_c17/SuitCase001a.mdl")
            else
                entity:SetModel(data.Mdl)
            end
            entity:Spawn()
            entity.Data = data
        elseif research.Type == TYPE_ENTITY then
            local entity = ents.Create(research.EntityClass)
            entity:SetPos(eject:GetPos()+eject:GetUp()*10)
            entity:Spawn()
            entity.Data = table.Copy(research)
        elseif research.Type == TYPE_ITEM then
            local entity = ents.Create("worlditem")
            entity:SetPos(eject:GetPos()+eject:GetUp()*10)
            entity.Data = table.Copy(research.ItemData)
            if !util.IsValidModel(entity.Data.Mdl) then
                entity:SetModel("models/props_c17/SuitCase001a.mdl")
            else
                entity:SetModel(entity.Data.Mdl)
            end
            entity:Spawn()
        end
        SetGlobalInt(GetGlobalInt("keyres","none"), 0)
        SetGlobalString("keyres","none")
        local researchlabsum = 0
        for _, researchlab in pairs(ents.FindByClass("hl2rp_researchlab")) do
            for _,ply in pairs(player.GetAll()) do
                if ply:SteamID() == researchlab.SID then
                    local reward = 250 * (level / 5) * researchlab:GetFactoryLevel()
                    researchlabsum = researchlabsum + (250 * researchlab:GetFactoryLevel())
                    ply:AddMoney(reward)
                    ply:notify("You have been rewarded " .. reward .. " for owning a research machine!")
                end
            end
        end
        for _, ply in pairs(player.GetAll()) do
            if (ply:Team() == TEAM_ADMINISTRATOR || string.find(ply:getDarkRPVar("job"), "Research") || ply:GetNWBool("restricted", false)) then
                    researchlabsum = math.Round(researchlabsum * 0.60)
                    ply:AddMoney(researchlabsum)
                    ply:notify("You have been rewarded: " .. researchlabsum .. "T for aiding in completing UU research!")
                end
        end
    end
end)

local function UpgradeFactory(ply, args)
	local ent = ply:GetEyeTrace().Entity
	if ent:GetClass() != "hl2rp_researchlab" || ent:GetPos():DistToSqr(ply:GetPos()) >= 100000 then ply:notify("You must be near the factory and looking at it!") return "" end

	local level = ent:GetFactoryLevel()
    ent.UpgCost = ent.UpgCost + ent.UpgIncrAmount
    
	if level < ent.MaxLevel && ent.UpgCost != -1 && !ply:CanAfford(ent.UpgCost) then ply:notify("You don't have enough to upgrade this factory! ("..tostring(ent.UpgCost)..")") return "" end
	if ent.UpgCost == -1 || level >= ent.MaxLevel then ply:notify("This factory is already at maximum level") return "" end
	ply:AddMoney(-ent.UpgCost)
	ent:SetFactoryLevel(level+1)
    ply:notify("You have upgraded this research machine to Level " .. ent:GetFactoryLevel() .. " for " .. ent.UpgCost)
	return ""
end

DarkRP.defineChatCommand("upgrade", UpgradeFactory, 1.5);