util.AddNetworkString("defunct")
util.AddNetworkString("AddDefunctionHalo")
util.AddNetworkString("RemoveDefunctionHalo")
util.AddNetworkString("RemoveAllDefunctionHalos")
util.AddNetworkString("RewardCP")
util.AddNetworkString("SendDefunctionMessage")

CombineCommandMenu.ReceiveNextRewardRationTime = CombineCommandMenu.ReceiveNextRewardRationTime or {}
CombineCommandMenu.GiveNextRewardRationTime = CombineCommandMenu.GiveNextRewardRationTime or {}
CombineCommandMenu.DefunctionTime = CombineCommandMenu.DefunctionTime or {}
OWMenuPlyTable = OWMenuPlyTable or {}
CPMenuPlyTable = CPMenuPlyTable or {}
local function IsValidPlayerAlive(p)
    return p:IsValid() and p:IsPlayer() and p:Alive()
end

net.Receive("RewardCP", function(len, ply)
    if not ply:IsValid() or not ply:IsPlayer() or not ply:Alive() then return end;
    local target = net.ReadEntity();

    -- If either the player or the target are not combine, flag as bad request.
    if not ply:isCombine() or not target:isCombine() then
        return
    end

    if ply == target then
    ply:notify("You cannot reward yourself, dummy!")
        return
    end

    if ply:Team() != TEAM_DISPATCH then
        if divisions.Data[ply:getDivision()].ranks then
            if not divisions.Data[ply:getDivision()].ranks[ply:getDivisionRank()].leader or ply:getDivision() != target:getDivision() then
                ply:notify("You are not allowed to reward " .. target:Name() .. "!")
                return
            end
        else
            if not (ply:getDivision() == DIVISION_SECTORIAL or ply:getDivision() == DIVISION_OCMD or ply:getDivision() == DIVISION_COMMANDER) then
                if ply:getDivision() == DIVISION_OCMD and ply:Team() != target:Team() then
                    ply:notify("You are not allowed to reward " .. target:Name() .. "!")
                    return
                end
                ply:notify("You are not allowed to reward " .. target:Name() .. "!")
                return
            end
        end
    end
    if ply:getDivision() == DIVISION_COMMANDER and target:getDivision() and target:getDivision() == DIVISION_SECTORIAL then
        ply:notify("You cannot reward the sectorial!")
        return
    end
    if not ply:IsAdmin() then
        if CombineCommandMenu.GiveNextRewardRationTime[ply:SteamID64()] and CombineCommandMenu.GiveNextRewardRationTime[ply:SteamID64()] > CurTime() then
            ply:notify("You may not reward players for another " .. math.Round(CombineCommandMenu.GiveNextRewardRationTime[ply:SteamID64()] - CurTime()) .. " seconds!")
            return
        end
        if CombineCommandMenu.ReceiveNextRewardRationTime[target:SteamID64()] and CombineCommandMenu.ReceiveNextRewardRationTime[target:SteamID64()] > CurTime() then
            ply:notify("You may not reward " .. target:Name() .. " for another " .. math.Round(CombineCommandMenu.ReceiveNextRewardRationTime[target:SteamID64()] - CurTime()) .. " seconds!")
            return
        end
    end
    if target:GetNWBool("HasRewardRation", false) then
        ply:notify(target:Name() .. " still has a pending reward ration! He must collect that ration first before he may be rewarded another!")
        return
    end

    target:SetNWBool("HasRewardRation", true)
    divisions:addSC(target, 5)
    target:notify("You have been rewarded a ration and 5 SC!")
    ply:notify("You have rewarded " .. target:Name() .. " a ration!")
    CombineCommandMenu.ReceiveNextRewardRationTime[target:SteamID64()] = CurTime() + 1800
    CombineCommandMenu.GiveNextRewardRationTime[ply:SteamID64()] = CurTime() + 900
end)

net.Receive("defunct", function(len, ply)
    if not ply:IsValid() or not ply:IsPlayer() or not ply:Alive() then return end;
    local target = net.ReadEntity()
    
    if not ply:isCombine() or not target:isCombine() then
        return
    end

    if ply == target then
    ply:notify("You cannot defunct yourself, dummy!")
        return
    end

    if ply:Team() != TEAM_DISPATCH then
        if divisions.Data[ply:getDivision()].ranks then
            if not divisions.Data[ply:getDivision()].ranks[ply:getDivisionRank()].leader or ply:getDivision() != target:getDivision() then
                ply:notify("You are not allowed to defunct " .. target:Name() .. "!")
                return
            end
        else
            if not (ply:getDivision() == DIVISION_SECTORIAL or ply:getDivision() == DIVISION_OCMD or ply:getDivision() == DIVISION_COMMANDER) then
                if ply:getDivision() == DIVISION_OCMD and ply:Team() != target:Team() then
                    ply:notify("You are not allowed to reward " .. target:Name() .. "!")
                    return
                end
                ply:notify("You are not allowed to defunct " .. target:Name() .. "!")
                return
            end
        end
    end

    if ply:getDivision() == DIVISION_COMMANDER and target:getDivision() and target:getDivision() == DIVISION_SECTORIAL then
        ply:notify("You cannot defunct the sectorial!")
        return
    end

    if ply:getDivision() == DIVISION_COMMANDER and target:getDivision() and target:Team() == TEAM_OVERWATCH then
        ply:notify("You cannot defunct an OTA unit!")
        return
    end

    if target:GetNWBool("HasbeenDefunct", false) then
        target:SetNWBool("HasbeenDefunct", false)
        ply:notify("You have removed the defunction order on " .. target:Name() .. "!")
        target:notify("You are no longer defunct!")
        for _, cps in pairs(player.GetHumans()) do
            if IsValidPlayerAlive(cps) and (cps:Team() == TEAM_CP or cps:Team() == TEAM_OVERWATCH or cps:Team() == TEAM_CONSCRIPT or cps:Team() == TEAM_DISPATCH or cps:Team() == TEAM_ADMINISTRATOR) then
                cps:sendMsg(Color(20, 20, 150, 255), "Dispatch", Color(255,255,255,255), ": ATTENTION UNITS, ", team.GetColor(target:Team()), target:Name(), Color(255,255,255,255), " has ", Color(255,0,0,255), "NO LONGER", Color(255,255,255,255), " been marked as ", Color(255,114,0,255), "DEFUNCT! ", Color(255,255,255,255), "Cease the engagement of ", team.GetColor(target:Team()), target:Name(), Color(255,255,255,255), "!")        -- chat.AddText()
                net.Start("SendDefunctionMessage")
                net.WriteEntity(target)
                net.WriteBool(false)
                net.Send(cps)
                net.Start("RemoveDefunctionHalo")
                net.WriteEntity(target)
                net.Send(cps)
            end
        end
        return
    else
        if CombineCommandMenu.DefunctionTime[ply:SteamID()] and CombineCommandMenu.DefunctionTime[ply:SteamID()] > CurTime() and not ply:IsAdmin() then
            ply:notify("You cannot mark units defunct for another " .. math.Round(CombineCommandMenu.DefunctionTime[ply:SteamID()] - CurTime()) .. " seconds!")
            return
        end
        target:SetNWBool("HasbeenDefunct", true)
        CombineCommandMenu.DefunctionTime[ply:SteamID()] = CurTime() + 120
        ply:notify("You have added a defunction order onto " .. target:Name() .. "!")
        target:notify("Warning: You have been marked as defunct!")
        if target:Team() == TEAM_OVERWATCH then
            local droppedweapon = target:GetActiveWeapon()
            local d = DamageInfo()
                d:SetDamage(10000)
                d:SetAttacker(ply)
                d:SetDamageType(DMG_DISSOLVE)
            target:TakeDamageInfo(d)
            target:notify("Your killswitch has been activated due to a defunction.")
            target:SetNWBool("HasbeenDefunct", false)
            return
        end
        for _, cps in pairs(player.GetHumans()) do
            if IsValidPlayerAlive(cps) and (cps:Team() == TEAM_CP or cps:Team() == TEAM_OVERWATCH or cps:Team() == TEAM_CONSCRIPT or cps:Team() == TEAM_DISPATCH or cps:Team() == TEAM_ADMINSTRATOR) then
                cps:sendMsg(Color(20, 20, 150, 255), "Dispatch", Color(255,255,255,255), ": ATTENTION UNITS, ", team.GetColor(target:Team()), target:Name(), Color(255,255,255,255), " has been marked as ", Color(255,114,0,255), "DEFUNCT! ", Color(255,255,255,255), "Amputation or detainment of this unit is ", Color(255,114,0,255), "DISCRETIONARY.")
                net.Start("SendDefunctionMessage")
                net.WriteEntity(target)
                net.WriteBool(true)
                net.Send(cps)
                net.Start("AddDefunctionHalo")
                net.WriteEntity(target)
                net.Send(cps)
            end
        end
        return
    end
end)

hook.Add("PlayerSpawn", "ResetDefunction", function(ply)
    ply:SetNWBool("HasbeenDefunct", false)
    if ply:Team() == TEAM_CP or ply:Team() == TEAM_OVERWATCH or ply:Team() == TEAM_CONSCRIPT or ply:Team() == TEAM_DISPATCH or ply:Team() == TEAM_ADMINISTRATOR then
        for _, defunctunit in pairs(player.GetHumans()) do
            if defunctunit:GetNWBool("HasbeenDefunct", false) then
                net.Start("AddDefunctionHalo")
                net.WriteEntity(defunctunit)
                net.Send(ply)
            end
        end
    end
end)

hook.Add("PlayerDeath", "Removethefuckinghalo", function(victim)
    for _, cps in pairs(player.GetHumans()) do
        if IsValidPlayerAlive(cps) and (cps:Team() == TEAM_CP or cps:Team() == TEAM_OVERWATCH or cps:Team() == TEAM_CONSCRIPT or cps:Team() == TEAM_DISPATCH or cps:Team() == TEAM_ADMINISTRATOR) then
            net.Start("RemoveDefunctionHalo")
            net.WriteEntity(victim)
            net.Send(cps)
        end
    end
    net.Start("RemoveAllDefunctionHalos")
    net.Send(victim)
end)

hook.Add("PlayerSilentDeath", "Removethefuckinghalo", function(victim)
    for _, cps in pairs(player.GetHumans()) do
        if IsValidPlayerAlive(cps) and (cps:Team() == TEAM_CP or cps:Team() == TEAM_OVERWATCH or cps:Team() == TEAM_CONSCRIPT or cps:Team() == TEAM_DISPATCH or cps:Team() == TEAM_ADMINISTRATOR) then
            net.Start("RemoveDefunctionHalo")
            net.WriteEntity(victim)
            net.Send(cps)
        end
    end
    net.Start("RemoveAllDefunctionHalos")
    net.Send(victim)
end)

local defunctusergroups = {
    ["admin"] = true,
    ["superadmin"] = true,
    ["senioradmin"] = true,
    ["securitystaff"] = true
}

concommand.Add("rg_defunct", function(ply, cmd, args)
if (ply:IsValid() and not defunctusergroups[ply:GetUserGroup()]) then ply:notify("You must be a admin+ to use this command!") return end
if not args[1] then return end
    for _, target in pairs(player.GetAll()) do
        if (target:Team() == TEAM_CP or target:Team() == TEAM_OVERWATCH or target:Team() == TEAM_ADMINISTRATOR or target:Team() == TEAM_CONSCRIPT) and target:Name() == args[1] then
            if target:GetNWBool("HasbeenDefunct", false) then
                target:SetNWBool("HasbeenDefunct", false)
                ply:notify("You have removed the defunction order on " .. target:Name() .. "!")
                target:notify("You are no longer defunct!")
                for _, cps in pairs(player.GetHumans()) do
                    if IsValidPlayerAlive(cps) and (cps:Team() == TEAM_CP or cps:Team() == TEAM_OVERWATCH or cps:Team() == TEAM_CONSCRIPT or cps:Team() == TEAM_DISPATCH or cps:Team() == TEAM_ADMINISTRATOR) then
                        cps:sendMsg(Color(20, 20, 150, 255), "Dispatch", Color(255,255,255,255), ": ATTENTION UNITS, ", team.GetColor(target:Team()), target:Name(), Color(255,255,255,255), " has ", Color(255,0,0,255), "NO LONGER", Color(255,255,255,255), " been marked as ", Color(255,114,0,255), "DEFUNCT! ", Color(255,255,255,255), "Cease the engagement of ", team.GetColor(target:Team()), target:Name(), Color(255,255,255,255), "!")        -- chat.AddText()
                        net.Start("SendDefunctionMessage")
                        net.WriteEntity(target)
                        net.WriteBool(false)
                        net.Send(cps)
                        net.Start("RemoveDefunctionHalo")
                        net.WriteEntity(target)
                        net.Send(cps)
                    end
                end
            return
            else
                target:SetNWBool("HasbeenDefunct", true)
                ply:notify("You have added a defunction order onto " .. target:Name() .. "!")
                target:notify("Warning: You have been marked as defunct!")
                if target:Team() == TEAM_OVERWATCH then
                    local d = DamageInfo()
                        d:SetDamage(10000)
                        d:SetAttacker(ply)
                        d:SetDamageType(DMG_DISSOLVE)
                    target:TakeDamageInfo(d)
                    target:notify("Your killswitch has been activated due to a defunction.")
                    target:SetNWBool("HasbeenDefunct", false)
                    return
                end
                for _, cps in pairs(player.GetHumans()) do
                    if IsValidPlayerAlive(cps) and (cps:Team() == TEAM_CP or cps:Team() == TEAM_OVERWATCH or cps:Team() == TEAM_CONSCRIPT or cps:Team() == TEAM_DISPATCH or cps:Team() == TEAM_ADMINISTRATOR) then
                        cps:sendMsg(Color(20, 20, 150, 255), "Dispatch", Color(255,255,255,255), ": ATTENTION UNITS, ", team.GetColor(target:Team()), target:Name(), Color(255,255,255,255), " has been marked as ", Color(255,114,0,255), "DEFUNCT! ", Color(255,255,255,255), "Amputation or detainment of this unit is ", Color(255,114,0,255), "DISCRETIONARY.")
                        net.Start("SendDefunctionMessage")
                        net.WriteEntity(target)
                        net.WriteBool(true)
                        net.Send(cps)
                        net.Start("AddDefunctionHalo")
                        net.WriteEntity(target)
                        net.Send(cps)
                    end
                end
            return
            end
        end
    end
    ply:notify("No valid player found. Did you spell the name right and is he even a combine unit?")
end)