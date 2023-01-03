-- Making noclipped admins invisible.

local function adminNoclip(ply, state)
    if (ply:IsAdmin()) then
        if (state) then 
            ply:SetNoDraw(true);
            ply:GodEnable();
		else
            ply:SetNoDraw(false);
            ply:GodDisable();
		end 
        
        return true;
    end
end

hook.Add("PlayerNoClip", "[base] noclip draw", adminNoclip)

-- Making it so combine doors can be opened with E
local function combineDoors(ply, door)
    if (IsFirstTimePredicted()) and (ply:isCombine() or ply:Team() == TEAM_ADMINISTRATOR) and (door:GetClass() == "func_door") then
        door:Fire("open")
    end
end

hook.Add("PlayerUse", "[base] door activation", combineDoors)

-- Remove bad hooks
timer.Simple(1, function()
    hook.Remove("PlayerUse", "InstrumentChairModelHook");
	hook.Remove("canDropWeapon", "PrometheusWeaponscanDropWeapon");
end)

-- Starting the XP timer.
hook.Add("PlayerInitialSpawn", "FullLoadSetup", function(ply)
    hook.Add("SetupMove", ply, function(self, ply, _, cmd)
        if self == ply and not cmd:IsForced() then
            hook.Run("PlayerFullLoad", self)
            hook.Remove("SetupMove", self)
        end
    end)
end)

util.AddNetworkString("StartXPTimer")

net.Receive("StartXPTimer", function(len, ply)
    ply:startXPTimer()
end)

-- Making XP module actually work
local function canChangeJobs(ply, newJob, force)
    if (RPExtraTeams[newJob] and RPExtraTeams[newJob].xp) and (RPExtraTeams[newJob].xp > ply:getXP()) and not (force) then return false, "You do not have enough XP to become this job." end

    if not force and GetConVar("rg_joblimit"):GetInt() == 1 then
        local jobcount = #team.GetPlayers(newJob)

        local OTAFCODE = {
            [7] = true,
            [8] = true,
            [13] = true,
            [15] = true,
        }

        if newJob == TEAM_CP then
            if jobcount > math.Round(player.GetCount() * (2 / 5)) + 1 then return false, "The maximum amount of CP's has been reached! (" .. jobcount > math.Round(player.GetCount() * (2 / 5)) + 1 .. ")" end
        elseif newJob == TEAM_OVERWATCH then
            if not OTAFCODE[GetGlobalInt("code", 0)] and #team.GetPlayers(newJob) >= 4 then return false, "The maximum amount of OTA has been reached! (4)" end
            if GetGlobalInt("code", "0") == 7 and ((ply.OTAOneLife or 1) <= 0) then return false, "You don't have anymore lifes left for this JW!" end
            ply.OTAOneLife = 0
        elseif newJob == TEAM_CONSCRIPT then
            if jobcount > math.Round(#team.GetPlayers(TEAM_CP) * (2 / 5) + 1) then return false, "The maximum amount of Conscripts has been reached! (" .. math.Round(#team.GetPlayers(TEAM_CP) * (2 / 5) + 1) .. ")" end
        end
    end
end

hook.Add("playerCanChangeTeam", "hl2rp: can change jobs", canChangeJobs)

-- Hijack chat
local function hijackChat(ply, text, team)
    if (ply:isCombine() or ply:Team() == TEAM_ADMINISTRATOR) and (team) then return "/r " .. text end

    if (ply:isCombine()) then
        local thing = string.Explode(" ", text)[1]

        if ((thing[1] == "/") and (#thing > 1) and (DarkRP.getChatCommand(thing:sub(2)) or FAdmin.Commands.List[thing:sub(2)])) or ((text:sub(1, 3) == ".//") and (#text > 3)) then
            if (text:sub(1, 3) == ".//") then           
                return "/looc " .. text:sub(4);
           	end
        else
            if (ply:Team() == TEAM_CP) or (ply:Team() == TEAM_OVERWATCH) then
                text = hook.Run("CPTalk", ply, text) or text

                return "<:: " .. text .. " ::>"
            elseif (ply:Team() == TEAM_CONSCRIPT) then
                text = hook.Run("CONSTalk", ply, text) or text

                return text
            end
        end
    else        
        if (text:sub(1, 3) == ".//") then return "/looc " .. text:sub(4); end
    end

    --return text
end

hook.Add("PlayerSay", "hl2rp: player  say", hijackChat)

-- Mute death sound 
local function muteDeathSound(ply)
    return true
end

hook.Add("PlayerDeathSound", "hl2rp: death sound", muteDeathSound)

-- Speed debuf for citizens and removing pocket on job change 
local function playerSpawn(ply)
    ply.darkRPPocket = {}
    net.Start("DarkRP_Pocket")
    net.WriteTable(ply:getPocketItems())
    net.Send(ply)

    timer.Simple(2, function()
        if not (IsValid(ply)) then return end

        if (ply:isCombine()) then
            ply:SetWalkSpeed(100)
            ply:SetSlowWalkSpeed(70)
            ply:SetRunSpeed(200)
        else
            ply:SetWalkSpeed(90)
            ply:SetSlowWalkSpeed(70)
            ply:SetRunSpeed(180)
        end

        ply:CrosshairDisable()
    end)

    for bodygroupi, _ in pairs(ply:GetBodyGroups()) do
        ply:SetBodygroup(bodygroupi, 0)
    end
end

hook.Add("PlayerSpawn", "hl2rp: player spawn", playerSpawn)

-- Anti BHOP

-- Drop all weapons, money, and shit
local dropblacklist = {
    ["weapon_breachingcharge"] = true,
    ["swep_vortigaunt_beam"] = true,
    ["arrest_stick"] = true,
    ["door_ram"] = true,
    ["gmod_camera"] = true,
    ["gmod_tool"] = true,
    ["keys"] = true,
    ["lockpick"] = false,
    ["med_kit"] = false,
    ["pocket"] = true,
    ["stunstick"] = true,
    ["unarrest_stick"] = true,
    ["weapon_keypadchecker"] = true,
    ["weapon_physcannon"] = true,
    ["weapon_physgun"] = true,
    ["weaponchecker"] = true,
}

local function dropShit(ply)
    local amount = ply:getDarkRPVar("money", 0)

    if amount and (amount > 0) then
        local money = ents.Create("spawned_money")
        money:Setamount(amount)
        money:SetPos(ply:GetPos())
        money.nodupe = true
        money:Spawn()
        ply:addMoney(-amount)
    end

    local weapons = ply:GetWeapons()

    if not (ply:isCombine()) then
        for _, wep in pairs(weapons) do
            if (GAMEMODE.Config.DisallowDrop[wep:GetClass()]) or wep:GetClass() == "swep_vortigaunt_beam" then continue end
            if (ply:GetActiveWeapon():GetClass() == wep:GetClass()) then continue end
            local _wep = ents.Create("spawned_weapon")
            _wep:SetModel(wep:GetModel())
            _wep:SetWeaponClass(wep:GetClass())
            _wep.nodupe = true
            _wep:SetPos(ply:GetPos())
            _wep:Spawn()
        end
    else
        local wep = ply:GetActiveWeapon()
        if IsValid(wep) and dropblacklist[wep:GetClass()] then return end

        if IsValid(wep) and not (GAMEMODE.Config.DisallowDrop[wep:GetClass()]) then
            local _wep = ents.Create("spawned_weapon")
            _wep:SetModel(wep:GetModel())
            _wep:SetWeaponClass(wep:GetClass())
            _wep.nodupe = true
            _wep:SetPos(ply:GetPos())
            _wep:Spawn()
        end
    end
end

hook.Add("DoPlayerDeath", "hl2rp: handle player death", dropShit)

-- Change back to citizen when die
local function changeToCitizen(ply)
    if (ply:Team() ~= TEAM_CITIZEN) then
        ply:changeTeam(TEAM_CITIZEN, true, true)
    end
end

hook.Add("PlayerDeath", "hl2rp: change to citizen", changeToCitizen)

-- Disable pocket drop 
local function canPocket(ply, item)
    if (ply:isCombine() and not ply:GetNWBool("IsRogue")) and (IsValid(item)) and (item:GetClass() == "spawned_weapon") then return false end
end

hook.Add("canPocket", "hl2rp: disable pocket", canPocket)

-- Disable spraying
local function disableSpray()
    return true
end

hook.Add("PlayerSpray", "hl2rp: player spray", disableSpray)

-- Can drop weapons
local function canDropWeapon(ply, weapon)
   	if (ply:isCombine() and not ply:GetNWBool("IsRogue")) then return false; end
       print(weapon)
    if dropblacklist[weapon:GetClass()] then return false; end
return true
end

hook.Add("canDropWeapon", "hl2rp: disable weapon drop", canDropWeapon)

-- Disable weapon pickup for combine 
local function disablePickup(ply, wep, realwep)
    if ((ply:isCombine()) and not (ply:GetNWBool("IsRogue"))) and (ply:Team() ~= TEAM_CONSCRIPT) then
        if (ply:getDivision() > 0) then
            divisions:addSC(ply, 3)
            ply:addMoney(100)
            ply:notify("You have been awarded 100T and 3SC for confiscating a weapon.")
        end

        wep:Remove()

        return true
    end

    if ply:KeyDown(IN_DUCK) then
        -- ply:ChatPrint("Yes!")
        ply:PickupObject(wep)

        return true
    end

    return false
end

hook.Add("PlayerPickupDarkRPWeapon", "hl2rp: disable pickup", disablePickup)

-- Hunger regen
timer.Create("HungerRegenTimer", 15, 0, function()
    for _, ply in pairs(player.GetHumans()) do
        if ply:IsValid() and ply:IsPlayer() and ply:getDarkRPVar("Energy") >= 85 and ply:Health() < ply:GetMaxHealth() and ply:Alive() then
            ply:SetHealth(ply:Health() + 1)
        end
    end
end)

hook.Add("SetupMove", "Modifycrouchspeed", function(ply)
    ply:SetCrouchedWalkSpeed(.5)
end)

-- Fuck widgets 
local function disableWidgets()
    MsgN("Disabling widgets...")

    function widgets.PlayerTick()
    end

    hook.Remove("PlayerTick", "TickWidgets")
    MsgN("Widgets disabled!")
end

hook.Add("PreGamemodeLoaded", "widgets_disabler_cpu", disableWidgets)

-- Fuck ragdolls
local function canSpawnRagdoll(ply)
    if (not ply:IsAdmin()) then return false end
end

hook.Add("PlayerSpawnRagdoll", "fuck ragdolls", canSpawnRagdoll)

-- suicide denied 
local function canSuicide(ply)
    return ply:IsSuperAdmin()
end

hook.Add("CanPlayerSuicide", "suicide denied", canSuicide)

-- AFK Fix 
local function whenAFK(ply, state)
    if not (state) then
        ply:updateJob(RPExtraTeams[ply:Team()].name)

        return
    end

    ply:changeTeam(TEAM_CITIZEN, true, true)
    ply:updateJob(RPExtraTeams[ply:Team()].name .. " (AFK)")

    if (divisions) and (ply:getDivision() > 0) then
        divisions:resetDivision(ply)
    end
end

hook.Add("playerSetAFK", "when afk fart", whenAFK)
-- Shoot lock
local SHOOT_DISTANCE = 180

local canBustDoor = {
    ["fl_spas12"] = true,
    ["fl_spas12_semiauto"] = true,
}

local function shootLock(entity, dmgInfo)
    if (entity:GetClass() == "prop_door_rotating" and (entity.nutNextBreach or 0) < CurTime()) then
        local handle = entity:LookupBone("handle")

        if (handle and canBustDoor[dmgInfo:GetAttacker():GetActiveWeapon():GetClass()]) then
            local client = dmgInfo:GetAttacker()
            local position = dmgInfo:GetDamagePosition()
            if (client:GetEyeTrace().Entity ~= entity or client:GetPos():DistToSqr(position) > SHOOT_DISTANCE ^ 2) then return end

            if (IsValid(client)) then
                if (hook.Run("CanPlayerBustLock", client, entity) == false) then return end
                local weapon = client:GetActiveWeapon()

                if (IsValid(weapon) and weapon:GetClass() == "weapon_shotgun") then
                    entity:EmitSound("physics/wood/wood_crate_break" .. math.random(1, 5) .. ".wav", 150)
                    entity:blastDoor(client:GetAimVector() * 380)
                    local effect = EffectData()
                    effect:SetStart(position)
                    effect:SetOrigin(position)
                    effect:SetScale(10)
                    util.Effect("GlassImpact", effect, true, true)

                    return
                end
            end

            if (IsValid(client) and position:DistToSqr(entity:GetBonePosition(handle)) <= 144) then
                if (hook.Run("CanPlayerBustLock", client, entity) == false) then return end
                local effect = EffectData()
                effect:SetStart(position)
                effect:SetOrigin(position)
                effect:SetScale(2)
                util.Effect("GlassImpact", effect)
                local name = client:UniqueID() .. CurTime()
                client:SetName(name)
                entity.nutOldSpeed = entity.nutOldSpeed or entity:GetKeyValues().speed or 100
                entity:Fire("setspeed", entity.nutOldSpeed * 3.5)
                entity:Fire("unlock")
                entity:Fire("openawayfrom", name)
                entity:EmitSound("physics/wood/wood_plank_break" .. math.random(1, 4) .. ".wav", 100, 120)
                entity.nutNextBreach = CurTime() + 30
                entity:SetNoDraw(true)
                entity:SetCollisionGroup(COLLISION_GROUP_WORLD)
                entity:CollisionRulesChanged()
                -- if !entity.ent then
                entity.ent = ents.Create("prop_physics")
                entity.ent:SetModel(entity:GetModel())

                if entity:GetSkin() then
                    entity.ent:SetSkin(entity:GetSkin())
                end

                local angle = client:EyeAngles()
                local direction = angle:Forward()
                direction.z = 0
                entity.ent:SetPos(entity:GetPos() + direction * 10)
                entity.ent:SetAngles(entity:GetAngles())

                entity.ent:Spawn()
                entity.ent:GetPhysicsObject():SetVelocityInstantaneous(direction * 600)

                timer.Simple(30, function()
                    if not entity:IsValid() then return end
                    entity:SetCollisionGroup(COLLISION_GROUP_NONE)
                    entity:CollisionRulesChanged()
                    entity:Fire("unlock", "", 0)
                    entity:SetNoDraw(false)
                    if not IsValid(entity.ent) then return end
                    entity.ent:Remove()
                end)

                timer.Simple(0.5, function()
                    if (IsValid(entity)) then
                        entity:Fire("setspeed", entity.nutOldSpeed)
                    end
                end)
            end
        end
    end
end

hook.Add("EntityTakeDamage", "hl2rp: shoot lock", shootLock)

-- Hunger shit
local function preventHunger(ply, amount)
    if (ply:Team() == TEAM_OVERWATCH) or (ply:Team() == TEAM_DISPATCH) or (IsValid(ply.nutScn) or not GetConVar("rg_hunger"):GetInt()) then return true end
end

hook.Add("hungerUpdate", "hl2rp: hunger shit", preventHunger)

-- Hard limit radio bc fuck FPP
local function canSpawnRadio(ent)
    timer.Simple(0.1, function()
		if IsValid(ent) and ent:GetClass() != "sent_streamradio" then return end
        local ply = ent:CPPIGetOwner()
		if IsValid(ply) and not (ply:IsUserGroup("vip")) and not (ply:IsAdmin()) then
			ent:Remove()

			return
		end

		for _, radio in pairs(ents.FindByClass("sent_streamradio")) do
			if radio:CPPIGetOwner() and radio:CPPIGetOwner() == ply and radio != ent then
				ent:Remove()
				return
			end
		end
    end)
end

hook.Add("OnEntityCreated", "hl2rp: block radio for non vips", canSpawnRadio)

local function e2Limit(ent)
    timer.Simple(0.1, function()
		if IsValid(ent) and ent:GetClass() != "gmod_wire_expression2" then return end
        if not ent:CPPIGetOwner() or not ent:CPPIGetOwner():IsValid() or not ent:CPPIGetOwner():IsPlayer()  then return end
        local owner = ent:CPPIGetOwner()
        if owner:ReachedEntityLimit("gmod_wire_expression2", 2) then owner:notify("You have reached the E2 limit! (2)") ent:Remove() return end
    end)
end

hook.Add("OnEntityCreated", "hl2rp: set limit on e2", e2Limit)

timer.Create("fixThisShitPLZ", 1, 0, function()
    if (GetConVar("sv_allowcslua") and GetConVar("sv_allowcslua"):GetInt() == 1) then 
   		MsgC("Ran BNP fix on sv_allowcslua, sv_minrate and sv_maxrate\n");
        RunConsoleCommand("sv_allowcslua", 0);
        RunConsoleCommand("sv_minrate", 30000);
        RunConsoleCommand("sv_maxrate", 130000);
        timer.Remove("fixThisShitPLZ");
    end 
end );

local function fuckViggers(ply, property)
	if (property == "ignite") and not (ply:IsAdmin()) then return false; end
end 

hook.Add("CanProperty", "hl2rp: fuck vigger", fuckViggers);

-- Fix Hands
local function fixHands(ply, ent)
 	local simplemodel = player_manager.TranslateToPlayerModelName(ply:GetModel())
   	local info = player_manager.TranslatePlayerHands(simplemodel)
   	if info then
          ent:SetModel(info.model)
          ent:SetSkin(info.skin)
          ent:SetBodyGroups(info.body)
    end    
end 

hook.Add("PlayerSetHandsModel", "hl2rp: fix hands", fixHands);

hook.Add("onDarkRPWeaponDropped", "hl2rp: stop weapon stacking", function(_, ent)
    function ent:StartTouch() end
end)

-- Fix Vehicle for vips

local function spawnChair(ply, model, name, table)
    if (table.Category == "Chairs" and (ply:GetUserGroup() == "vip" or ply:IsAdmin())) then 
		print("gaygay");
        return true;
	end 
end 

hook.Add("PlayerSpawnVehicle", "hl2rp: allow chairs for vips", spawnChair)

hook.Add("PhysgunPickup", "Nocollide physgunned ents", function(ply, ent)
    if ent:IsValid() and ent:GetCollisionGroup() == COLLISION_GROUP_NONE then
        ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
    end
end)

hook.Add("PhysgunPickup", "Nocollide physgunned ents", function(ply, ent)
    -- if ent:IsValid() and ent:GetCollisionGroup() == COLLISION_GROUP_NONE then
    --     ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
    -- end
end)
hook.Remove("PhysgunPickup", "Nocollide physgunned ents")
hook.Add("PhysgunDrop", "collide nonphysgunned ents", function(ply, ent)
    if ent:IsValid() and ent:GetCollisionGroup() == COLLISION_GROUP_WORLD then
        ent:SetCollisionGroup(COLLISION_GROUP_NONE)
    end
end)