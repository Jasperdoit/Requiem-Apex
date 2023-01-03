util.AddNetworkString("DrunkVomit")
local meta = FindMetaTable("Player")

function meta:addDrunkLevel(num)
    if self:GetNWInt("DrunkLevel") then
        self:SetNWInt("DrunkLevel", self:getDrunkLevel() + num)
    else
        self:GetNWInt("DrunkLevel", num)
    end
end

function meta:setDrunkLevel(num)
    self:SetNWInt("DrunkLevel", num)
end

function meta:getDrunkLevel()
    return self:GetNWInt("DrunkLevel")
end

function meta:setLastVomit()
    self:SetNWInt("LastVomit", CurTime())
end

function meta:getLastVomit()
    if not self:GetNWInt("LastVomit") then return 0 end

    return CurTime() - self:GetNWInt("LastVomit")
end

function meta:vomit()
    net.Start("DrunkVomit")
    net.Send(self)
    local edata = EffectData()
    edata:SetOrigin(self:EyePos())
    edata:SetEntity(self)
    util.Effect("vomit", edata, true, true)
end

function meta:hasMaxBarrels()
    local numb = 0

    for k, v in pairs(ents.FindByClass("hl2rp_beerbrewer")) do
        if self:SteamID() == v.SID then
            numb = numb + 1
        end
        --PrintTable(v:GetTable())
    end

    if numb > 3 then return true end

    return false
end
function meta:hasMaxCraftingtables()
    local numb = 0

    for k, v in pairs(ents.FindByClass("rg_weaponcraftingtable")) do
        if self:SteamID() == v.SID then
            numb = numb + 1
        end
        --PrintTable(v:GetTable())
    end

    if numb > 1 then return true end

    return false
end

hook.Add("OnPlayerChangedTeam", "RemoveResearchondeath", function(ply)
    if not ply:IsValid() then return end

    for k, v in pairs(ents.FindByClass("hl2rp_researchlab")) do
        if ply:SteamID() == v.SID then
            v:Remove()
        end
    end
end)
hook.Add("OnPlayerChangedTeam", "Removecraftingondeath", function(ply)
    if not ply:IsValid() then return end

    for k, v in pairs(ents.FindByClass("rg_weaponcraftingtable")) do
        if ply:SteamID() == v.SID then
            v:Remove()
        end
    end
end)
hook.Add("OnPlayerChangedTeam", "Removeproductvendorondeath", function(ply)
    if not ply:IsValid() then return end

    for k, v in pairs(ents.FindByClass("rg_productvendor")) do
        if ply:SteamID() == v.SID then
            v:Remove()
        end
    end
end)
hook.Add("OnPlayerChangedTeam", "RemoveBarrelOnDeath", function(ply)
    if not ply:IsValid() then return end

    for k, v in pairs(ents.FindByClass("hl2rp_beerbrewer")) do
        if ply:SteamID() == v.SID then
            v:Remove()
        end
    end
end)

function meta:hasResearchMachines()
    local numb = 0

    for k, v in pairs(ents.FindByClass("hl2rp_researchlab")) do
        if self:SteamID() == v.SID then
            numb = numb + 1
        end
        --PrintTable(v:GetTable())
    end

    if numb > 1 then return true end

    return false
end

function meta:hasProductVendors()
    local numb = 0

    for k, v in pairs(ents.FindByClass("rg_productvendor")) do
	print(v.SID)
        if self:SteamID() == v.SID then
            numb = numb + 1
        end
        --PrintTable(v:GetTable())
    end

    if numb >= 1 then return true end

    return false
end

timer.Create("DrunkThink", 4, 0, function()
    for k, ply in pairs(player.GetAll()) do
        if ply:getDrunkLevel() and ply:getDrunkLevel() > 0 then
            --print(ply:getDrunkLevel()-0.1)-- Debug Only print
            ply:setDrunkLevel(ply:getDrunkLevel() - 0.1)
        end

        if ply:getDrunkLevel() and ply:getDrunkLevel() > 28 then
            if ply:getLastVomit() == 0 then
                ply:setLastVomit()
            end

            if ply:getLastVomit() > 30 then
                ply:vomit()
                ply:setLastVomit()
            end
        end

        if ply:getDrunkLevel() and ply:getDrunkLevel() > 52 then
            ply:vomit();
        end
    end
end)

hook.Add("OnPlayerChangedTeam", "RemoveDrunkOnChange", function(ply)
    ply:setDrunkLevel(0)
end)

hook.Add("PlayerDeath", "RemoveDrunkOnDeath", function(ply)
    ply:setDrunkLevel(0)
end)

concommand.Add("rp_vomit", function(ply)
    if (ply.nextdrunkconcommandtime or 0) > CurTime() then return end
	ply.nextdrunkconcommandtime = CurTime() + .2
    if not ply:IsSuperAdmin() and not ply:IsUserGroup("servermanager") then return end
    if ply.isvomitting == true then return end
    ply:vomit()
    ply.isvomitting = true

    timer.Simple(5, function()
        ply.isvomitting = nil
    end)
end)

concommand.Add("rp_mega_vomit", function(ply)
    if (ply.nextdrunkconcommandtime or 0) > CurTime() then return end
	ply.nextdrunkconcommandtime = CurTime() + .2
    if not ply:IsSuperAdmin() and not ply:IsUserGroup("servermanager") then return end
    if not ply:IsSuperAdmin() and not ply:IsUserGroup("servermanager") then return end
    if ply.isvomitting == true then return end
    ply.isvomitting = true
    ply:vomit()
    ply:vomit()
    ply:vomit()
    ply:vomit()
    ply:vomit()
    ply:vomit()
    ply:vomit()
    ply:vomit()
    ply:vomit()
    ply:vomit()
    ply:vomit()
    ply:vomit()
    ply:vomit()
    ply:vomit()
    ply:vomit()

    timer.Simple(40, function()
        ply.isvomitting = nil
    end)
end)

-- ply:ChatPrint("Your body couldn't take the amount of vomit you lost doing this. You collapse!")
-- ply:Kill()
concommand.Add("rp_getdrunk", function(ply)
    if (ply.nextdrunkconcommandtime or 0) > CurTime() then return end
	ply.nextdrunkconcommandtime = CurTime() + .2
    if not ply:IsSuperAdmin() then return end
    ply:addDrunkLevel(10)
end)

concommand.Add("rp_getsober", function(ply)
    if (ply.nextdrunkconcommandtime or 0) > CurTime() then return end
	ply.nextdrunkconcommandtime = CurTime() + .2
    if not ply:IsSuperAdmin() then return end
    ply:setDrunkLevel(0)
end)