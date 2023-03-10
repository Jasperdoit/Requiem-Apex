TOOL.Category           = "Falco Prop Protection"
TOOL.Name               = "Share props"
TOOL.Command            = nil
TOOL.ConfigName         = ""

function TOOL:RightClick(trace)
    local ent = trace.Entity
    if not IsValid(ent) or CLIENT then return true end

    local ply = self:GetOwner()

    if ent:CPPIGetOwner() ~= ply then
        FPP.Notify(ply, "You do not have the right to share this entity.", false)
        return
    end

    ent.SharePhysgun1 = nil
    ent.ShareGravgun1 = nil
    ent.SharePlayerUse1 = nil
    ent.ShareEntityDamage1 = nil
    ent.ShareToolgun1 = nil

    ent.AllowedPlayers = nil

    FPP.recalculateCanTouch(player.GetAll(), {ent})
    return true
end

function TOOL:LeftClick(trace)
    local ent = trace.Entity
    if not IsValid(ent) or CLIENT then return true end

    local ply = self:GetOwner()

    if ent:CPPIGetOwner() ~= ply then
        FPP.Notify(ply, "You do not have the right to share this entity.", false)
        return
    end

    local Physgun = ent.SharePhysgun1 or false
    local GravGun = ent.ShareGravgun1 or false
    local PlayerUse = ent.SharePlayerUse1 or false
    local Damage = ent.ShareEntityDamage1 or false
    local Toolgun = ent.ShareToolgun1 or false

    -- This big usermessage will be too big if you select 63 players, since that will not happen I can't be arsed to solve it
    umsg.Start("FPP_ShareSettings", ply)
        umsg.Entity(ent)
        umsg.Bool(Physgun)
        umsg.Bool(GravGun)
        umsg.Bool(PlayerUse)
        umsg.Bool(Damage)
        umsg.Bool(Toolgun)
        if ent.AllowedPlayers then
            umsg.Long(#ent.AllowedPlayers)
            for _, v in ipairs(ent.AllowedPlayers) do
                umsg.Entity(v)
            end
        end
    umsg.End()
    return true
end

if CLIENT then
    language.Add("Tool.shareprops.name", "Share tool")
    language.Add("Tool.shareprops.desc", "Change sharing settings per prop")
    language.Add("Tool.shareprops.0", "Left click: shares a prop. Right click unshares a prop")
end
