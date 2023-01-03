AddCSLuaFile("cl_init.lua") -- This means the client will download these files
AddCSLuaFile("shared.lua")
include('shared.lua') -- At this point the contents of shared.lua are ran on the server only.

--This function is run when the entity is created so it's a good place to setup our entity.
function ENT:Initialize()
    self:SetModel("models/odessa.mdl") -- Sets the model of the NPC.
    self:SetHullType(HULL_HUMAN) -- Sets the hull type, used for movement calculations amongst other things.
    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:SetSolid(SOLID_BBOX) -- This entity uses a solid bounding box for collisions.
    self:CapabilitiesAdd(CAP_ANIMATEDFACE, CAP_TURN_HEAD) -- Adds what the NPC is allowed to do ( It cannot move in this case ).
    self:SetUseType(SIMPLE_USE) -- Makes the ENT.Use hook only get called once at every use.
    self:DropToFloor()
    self:SetPersistent(false)
    self:SetMaxYawSpeed(90) --Sets the angle by which an NPC can rotate at once.
end

function ENT:OnTakeDamage()
    -- This NPC won't take damage from anything.
    return false
end

function ENT:AcceptInput(Name, Activator, Caller)
    if Name == "Use" and Caller:IsPlayer() then
        if not Caller:HasWeapon("weaponchecker") then
            if not string.match(Caller:Nick(), "CITIZEN") then
                Caller:SetPData("cname", Caller:Nick())
            end
        end

        if Caller:Team() == TEAM_CITIZEN then
            umsg.Start("ShotRebelMenu", Caller) -- Prepare the usermessage to that same player to open the menu on his side.
            umsg.End() -- We don't need any content in the usermessage so we're sending it empty now.
            --self:EmitSound("vo/coast/odessa/nlo_cub_hello.wav")
        else
            Caller:notify("You are not part of the Lambda Resistance.")
        end
    end
end

function giveWeapons(ply, weapons)
    for i, weapon in ipairs(weapons) do
        ply:Give(weapon)
    end
end

concommand.Add("rp_rebeldivision", function(ply, cmd, args)
    local SteamID = ply:SteamID64()

    if RebelMenuPlyTable == nil then
        RebelMenuPlyTable = {}
        --	print("CP Table Created")
    end

    if RebelMenuPlyTable[SteamID] == nil then
        RebelMenuPlyTable[SteamID] = {}
        --	print("PLY Table Created")
    end

    if not ply:IsAdmin() then
        if ply:GetNWInt("LastRebelSet") and 120 - (CurTime() - ply:GetNWInt("LastRebelSet")) >= 0 then
            ply:notify("You must wait " .. math.ceil(120 - (CurTime() - ply:GetNWInt("LastRebelSet"))) .. " second('s) before changing rank or division.")

            return false
        end
    end

    for id, ent in pairs(ents.FindInSphere(ply:GetPos(), 64)) do
        if (ent:GetClass() == "rebel_npc") and args[1] and args[2] then
            local RankID = tonumber(args[1])
            local DivisionID = tonumber(args[2])

            if RebelRanks[RankID] and RebelDivision[DivisionID] and ply:Team() == TEAM_CITIZEN then

                local RankInfo = RebelRanks[RankID]
                local DivisionInfo = RebelDivision[DivisionID]
                local PlayerXP = ply:getXP();
                print(PlayerXP)
                local jobdelay = 120

                if GetConVar("rg_gamenight"):GetInt() == 0 then
                    if not (ply:IsAdmin() or (RankInfo.xp <= PlayerXP)) then
                        ply:notify("You do not have enough XP to be this rank.")
                        return false
                    end

                    if not (ply:IsAdmin() or (DivisionInfo.xp <= PlayerXP)) then
                        ply:notify("You do not have enough XP to join this division.")
                        return false
                    end
                end

                baseWeapons = {"weapon_physcannon", "gmod_tool", "weapon_physgun", "keys", "pocket"}

                --					print(tostring(ply:Team()))
                if DivisionID == 6 or DivisionID == 7 then
                    --CHeck if a leader already exists
                    for _, rebel in pairs(player.GetAll()) do
                        local SteamIDList = rebel:SteamID64()

                        if rebel:Team() == TEAM_CITIZEN and RebelMenuPlyTable[SteamIDList] and RebelMenuPlyTable[SteamIDList]["Division"] and RebelMenuPlyTable[SteamIDList]["Division"] == RebelDivision[DivisionID].id then
                            ply:notify("Somebody already has that rank.")
                            return false
                        end
                    end
                end
                if RebelMenuPlyTable[SteamID] and RebelMenuPlyTable[SteamID]["Division"] and RebelMenuPlyTable[SteamID]["Rank"] and RebelMenuPlyTable[SteamID]["Division"] == RebelDivision[DivisionID].id and RebelMenuPlyTable[SteamID]["Rank"] == RebelRanks[RankID].id then
                    ply:notify("You are already a part of that division and rank.")

                    return false
                end

                if (RankID == 5) then
                    for k, v in pairs(player.GetAll()) do
                        local SteamID = v:SteamID64()

                        if RebelMenuPlyTable[SteamID] and RebelMenuPlyTable[SteamID]["Division"] and RebelMenuPlyTable[SteamID]["Rank"] and RebelMenuPlyTable[SteamID]["Division"] == RebelDivision[DivisionID].id and RebelMenuPlyTable[SteamID]["Rank"] == RebelRanks[RankID].id and v:Team() == TEAM_CITIZEN then
                            ply:notify("There is already a Brigadier for this Divison.")

                            return false
                        end
                    end
                else
                    local CurrDiv = 0
                    local maxDiv = DivisionInfo.max

                    for k, v in pairs(player.GetAll()) do
                        local SteamID = v:SteamID64()

                        if RebelMenuPlyTable[SteamID] and RebelMenuPlyTable[SteamID]["Division"] and RebelMenuPlyTable[SteamID]["Division"] == RebelDivision[DivisionID].id and v:Team() == TEAM_CITIZEN then
                            CurrDiv = CurrDiv + 1
                        end
                    end

                    if CurrDiv >= maxDiv then
                        ply:notify("This Division is full!.")

                        return false
                    end
                end

                local TotalDivision = 0
                ply:StripWeapons()
                giveWeapons(ply, baseWeapons)
                if DivisionID == 6 or DivisionID == 7 then
                    ply:updateJob("Lambda Resistance (" .. DivisionInfo.name .. ")")
                else
                    ply:SetArmor(30)
                    ply:updateJob("Lambda Resistance (" .. DivisionInfo.name .. "-" .. RankInfo.name .. ")")
                end
                -- Bodygroup code
                
                if DivisionInfo.bodygroups then
                    for bodyindex, _ in pairs(ply:GetBodyGroups()) do
                        ply:SetBodygroup(bodyindex, 0)
                    end
                    for k, bodygroup in pairs(DivisionInfo.bodygroups) do
                        if istable(bodygroup) then
                            ply:SetBodygroup(k,table.Random(bodygroup))
                        else
                            ply:SetBodygroup(k, bodygroup)
                        end
                    end
                end
                --local id = math.random(1002, 9900)
                --local name = "CP:C17-" .. DivisionInfo.name .. "-" .. RankInfo.name .. "-" .. id
                RebelMenuPlyTable[SteamID]["Division"] = RebelDivision[DivisionID].id
                ply:SetNWInt("Division", RebelDivision[DivisionID].id)
                RebelMenuPlyTable[SteamID]["Rank"] = RebelRanks[RankID].id
                ply:SetNWInt("Rank", RebelRanks[RankID].id)
                --DB.StoreRPName(ply, name)
                --ply:SetRPName(name, false)
                --Weapons
                ply:notify("You are now a " .. DivisionInfo.name .. " " .. RankInfo.name)
	            ply:SetNWBool("IsRebelscum", true)


                for i = 1, RankID do
                    if (DivisionInfo.weapons[i]) then
                        giveWeapons(ply, DivisionInfo.weapons[i])
                        --print("Valid Weapons found")
                    end
                end

                local CurTime = CurTime()
                ply:SetNWInt("LastRebelSet", CurTime)
                ply:SetNWBool("HasRebelRankSelected", true)
                --print("Success!")
            end
        end
    end
end)

hook.Add("PlayerSpawn", "ResetRebelRankSelected", function(ply)
	ply:SetNWBool("HasRebelRankSelected", false)
    if RebelMenuPlyTable and RebelMenuPlyTable[ply:SteamID64()] then
        RebelMenuPlyTable[ply:SteamID64()]["Division"] = -1
        RebelMenuPlyTable[ply:SteamID64()]["Rank"] = -1
    end
    if ply:Team() == TEAM_CITIZEN then
        ply:updateJob("Citizen")
    end
end)
