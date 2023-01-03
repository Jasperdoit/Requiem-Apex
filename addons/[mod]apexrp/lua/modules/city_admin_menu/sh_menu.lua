TYPE_MODULE = 0
TYPE_WEAPON = 1
TYPE_ENTITY = 2
TYPE_ITEM = 3

wmResearch = {}

function AddResearchProject(key, table)
    if !table.CustomCost then
        table.CustomCost = function(cost, level)
            return level * cost
        end
    end

    if !table.CustomRequired then
        table.CustomRequired = function(required, level)
            return level * required
        end
    end

    if !table.CustomDuration then
        table.CustomDuration = function(duration, level)
            return duration
        end
    end

    table.Color = table.Color or Color(0,0,0,255)

    wmResearch[key] = table
end

function resString(int)
    if int == TYPE_MODULE then
        return "Module"
    elseif int == TYPE_WEAPON then
        return "Weapon"
    elseif int == TYPE_ENTITY then
        return "Entity"
    elseif int == TYPE_ITEM then
        return "Item"
    end
    return "Invalid"
end

AddResearchProject("hp", {
    Name = "Damage reduction",
    Desc = "Damage to the CCA is reduced from all sources. 2% * Module Level",
    Type = TYPE_MODULE,
    HookType = "EntityTakeDamage",
    HookData = function(self, ply, dmg)
        if ply:IsPlayer() && ply:IsCP() then
            dmg:ScaleDamage(1-(0.02*self.Data.Level))
        end
    end,
    CustomDuration = function(duration, level)
        return duration + (100*level)
    end,
    Level = 1,
    Levels = 5,
    Time = 900,
    Required = 1000,
    Cost = 800
})

AddResearchProject("dmg", {
    Name = "Damage increase",
    Desc = "Damage done by the CCA is increased. 5% * Module Level",
    Type = TYPE_MODULE,
    HookType = "EntityTakeDamage",
    HookData = function(self, ply, dmg)
        local attacker = dmg:GetAttacker()
        if attacker:IsPlayer() && attacker:IsCP() then
            dmg:ScaleDamage(1+(0.05*self.Data.Level))
        end
    end,
    CustomDuration = function(duration, level)
        return duration + (200*level)
    end,
    Level = 1,
    Levels = 3,
    Time = 1200,
    Required = 2000,
    Cost = 1000,
    Color = Color(255,0,0,255)
})

AddResearchProject("melee", {
    Name = "Melee reduction",
    Desc = "Damage to the CCA through melee type weapons reduced. 10% * Module Level",
    Type = TYPE_MODULE,
    HookType = "EntityTakeDamage",
    HookData = function(self, ply, dmg)
        if ply:IsPlayer() && ply:IsCP() && (dmg:IsDamageType(DMG_SLASH) || dmg:IsDamageType(DMG_CLUB)) then
            dmg:ScaleDamage(1-(0.1*self.Data.Level))
        end
    end,
    CustomDuration = function(duration, level)
        return duration + (100*level)
    end,
    Level = 1,
    Levels = 3,
    Time = 600,
    Required = 1500,
    Cost = 500
})

if SERVER then
    util.AddNetworkString("AddBroadcast")
    util.AddNetworkString("RemoveBroadcast")
    util.AddNetworkString("RequestRefresh")
    util.AddNetworkString("BroadcastEnabled")
    util.AddNetworkString("TaxChange")
    util.AddNetworkString("SelectResearch")
    util.AddNetworkString("MarkDefunct")
    util.AddNetworkString("ToggleAccess")

    net.Receive("ToggleAccess", function(len, ply)
        local target = net.ReadEntity()
        local restrict = net.ReadBool()
        if ply:Team() != TEAM_DISPATCH && (ply:Team() != TEAM_ADMINISTRATOR || !string.find(ply:getDarkRPVar("job"), "Chancellor") || ply:GetNWBool("restricted", false)) then return end
        if target:Team() != TEAM_ADMINISTRATOR then ply:notify("This player isn't part of the city administration board!") return end
        if ply == target then ply:notify("You can't target yourself!") return end
        target:SetNWBool("restricted", restrict)
        target:notify("Your access to the minister menu has been restricted by "..ply:Name())
    end)

    hook.Add("PlayerSpawn", "unRestrictMenu", function(ply)
        -- if ply:GetNWBool("restricted", false) then
            ply:SetNWBool("restricted", false)
        -- end
    end)

    net.Receive("BroadcastEnabled", function(len, ply)
        if ply:Team() != TEAM_DISPATCH && (ply:Team() != TEAM_ADMINISTRATOR || !string.find(ply:getDarkRPVar("job"), "Propaganda") || ply:GetNWBool("restricted", false)) then return end
        local bool = net.ReadBool()
        SetGlobalBool("broadcastEnabled", bool)
        if bool then
            ply:notify("Enabled broadcast stations")
        else
            ply:notify("Disabled broadcast stations")
        end
    end)

    net.Receive("TaxChange", function(len, ply)
        -- if (ply:Team() != TEAM_ADMINISTRATOR || !string.find(ply:getDarkRPVar("job"), "Chancellor") || !ply:GetNWBool("restricted", false)) then
        --     -- SetGlobalInt("tax", 10)
        --     ply:notify("No fuck off")
        --     return
        -- end
        if ply:Team() != TEAM_DISPATCH && (ply:Team() != TEAM_ADMINISTRATOR || !string.find(ply:getDarkRPVar("job"), "Economy") || ply:GetNWBool("restricted", false)) then return end
        local tax = net.ReadInt(8)
        tax = math.Clamp(tax, 0, 60)
        SetGlobalInt("tax", tax)
        hook.Call("TaxesChanged", nil, tax)
    end)

    net.Receive("SelectResearch", function(len, ply)
        if ply:Team() != TEAM_DISPATCH && (ply:Team() != TEAM_ADMINISTRATOR || !string.find(ply:getDarkRPVar("job"), "Research") || ply:GetNWBool("restricted", false)) then return end
        local newres = net.ReadString()
        local level = net.ReadInt(8)
        if tostring(newres..level) == GetGlobalString("keyres", "none") || !wmResearch[newres] then return end
        local research = wmResearch[newres]

        local cost = research.CustomCost(research.Cost, level)
        local required = research.CustomRequired(research.Required, level)

        if GetGlobalInt("UUMoney", 0) - cost < 0 then ply:notify("The UU can't afford to begin researching this") return end
        SetGlobalInt("UUMoney", GetGlobalInt("UUMoney",0) - cost)
        SetGlobalInt(GetGlobalInt("keyres","none"), GetGlobalInt("Progress",0))
        SetGlobalString("keyres", tostring(newres..level))
        SetGlobalInt("Level", level)
        SetGlobalInt("Progress", GetGlobalInt(newres..level, 0))
        SetGlobalInt("Required", required)
        ply:notify(wmResearch[newres].Name.." (Lv. "..level..") has been selected for research.")
    end)

    concommand.Add("rg_appointresearch", function(ply, cmd, args)
    if (ply.nextresearchtime || 0) > CurTime() then return end
    ply.nextresearchtime = CurTime() + 2
    if not ply:IsSuperAdmin() then return end
    local newres = args[1]
    local level = tonumber(args[2])
    if tostring(newres..level) == GetGlobalString("keyres", "none") || !wmResearch[newres] then return end
    local research = wmResearch[newres]

    local cost = research.CustomCost(research.Cost, level)
    local required = research.CustomRequired(research.Required, level)

    SetGlobalInt(GetGlobalInt("keyres","none"), GetGlobalInt("Progress",0))
    SetGlobalString("keyres", tostring(newres..level))
    SetGlobalInt("Level", level)
    SetGlobalInt("Progress", GetGlobalInt(newres..level, 0))
    SetGlobalInt("Required", required)
    ply:notify(wmResearch[newres].Name.." (Lv. "..level..") has been selected for research.")
    end)

    net.Receive("RequestRefresh", function(len, ply)
        if ply:Team() != TEAM_DISPATCH && (ply:Team() != TEAM_ADMINISTRATOR || !string.find(ply:getDarkRPVar("job"), "Propaganda") || ply:GetNWBool("restricted", false)) then return end
        net.Start("RequestRefresh")
        if GAMEMODE.Config.BroadcastTbl then
            net.WriteTable(GAMEMODE.Config.BroadcastTbl)
        else
            net.WriteTable({})
        end
        net.Send(ply)
    end)

    net.Receive("AddBroadcast", function(len, ply)
        if ply:Team() != TEAM_DISPATCH && (ply:Team() != TEAM_ADMINISTRATOR || !string.find(ply:getDarkRPVar("job"), "Propaganda") || ply:GetNWBool("restricted", false)) then return end
        if !GAMEMODE.Config.BroadcastTbl then GAMEMODE.Config.BroadcastTbl = {} end
        ply:notify("Created a new broadcast station at "..tostring(ply:GetPos()))
        table.insert(GAMEMODE.Config.BroadcastTbl, ply:GetPos())
    end)

    net.Receive("RemoveBroadcast", function(len, ply)
        if ply:Team() != TEAM_DISPATCH && (ply:Team() != TEAM_ADMINISTRATOR || !string.find(ply:getDarkRPVar("job"), "Propaganda") || ply:GetNWBool("restricted", false)) then return end
        if !GAMEMODE.Config.BroadcastTbl then return end
        ply:notify("Removed broadcasting location")
        local integer = net.ReadInt(8)
        local var = table.remove(GAMEMODE.Config.BroadcastTbl, integer)
    end)

else

end