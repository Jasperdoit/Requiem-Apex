AddCSLuaFile("cl_init.lua") -- This means the client will download these files
AddCSLuaFile("shared.lua")
include('shared.lua') -- At this point the contents of shared.lua are ran on the server only.

util.AddNetworkString("openCitOpts");

--This function is run when the entity is created so it's a good place to setup our entity.
function ENT:Initialize()
    self:SetModel("models/Humans/Group01/male_03.mdl") -- Sets the model of the NPC.
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

function ENT:Use( ply )
	net.Start( "openCitOpts" );
	net.Send( ply );
end 

function ENT:OnTakeDamage()
    -- This NPC won't take damage from anything.
    return false
end

--[[
APEX CODE SO GOOD
]]

local function getOpts(num, team, max)
	local totalOpt = 0

	for k, v in pairs(player.GetAll()) do
		if v:Team() == team and v:GetNWInt("citopt") and v:GetNWInt("citopt") == num then
			totalOpt = totalOpt + 1
		end
	end

	if max <= totalOpt then
		return true
	else
		return false
	end
end

local function hasXP(ply, amount)
	if ply:getXP() >= amount then
		return true
	else
		return false
	end
end

local function setOpt(ply, num)
	ply:notify("You have changed what type of citizen you are to " .. CitOpt[num] .. ".")
	ply:SetNWInt("citopt", num)
	ply:SetNWInt("LastCOSet", CurTime())

	if string.match(ply:GetModel(), "group01/male") then
		medicModel = string.Replace(ply:GetModel(), "humans/group01/male", "player/jackathan/beta/medic")
	elseif string.match(ply:GetModel(), "beta/ma") then
		medicModel = string.Replace(ply:GetModel(), "player/jackathan/beta/male", "player/jackathan/beta/medic")
	elseif string.match(ply:GetModel(), "bmscientistcits/p_male") then
		cookModel = string.Replace(ply:GetModel(), "bmscientistcits", "player/jackathan/beta/medic")
	else
		medicModel = "models/player/jackathan/beta/medic_09.mdl"
	end

	if string.match(ply:GetModel(), "group01/male") then
		cookModel = string.Replace(ply:GetModel(), "humans/group01", "player/jackathan/beta")
	elseif string.match(ply:GetModel(), "medic") then
		cookModel = string.Replace(ply:GetModel(), "player/jackathan/beta/medic", "player/jackathan/beta/male")
	elseif string.match(ply:GetModel(), "bmscientistcits/p_male") then
		cookModel = string.Replace(ply:GetModel(), "bmscientistcits", "player/jackathan/beta")
	else
		cookModel = "models/player/jackathan/beta/male_09.mdl"
	end

	if string.match(ply:GetModel(), "group01") then
		scientistModel = string.Replace(ply:GetModel(), "humans/group01", "bmscientistcits")
	elseif string.match(ply:GetModel(), "medic") then
		scientistModel = string.Replace(ply:GetModel(), "player/jackathan/beta/medic", "bmscientistcits/male")
	elseif string.match(ply:GetModel(), "beta/ma") then
		scientistModel = string.Replace(ply:GetModel(), "player/jackathan/beta", "bmscientistcits")
	else
		scientistModel = "models/bmscientistcits/male_09.mdl"
	end

	if num == 2 then
		ply:SetBodygroup(1, 11)
		ply:SetBodygroup(2, 2)
		ply:SetBodygroup(9, 1)
	end

	if num == 4 then
		ply:SetBodygroup(1, 13)
		ply:SetBodygroup(2, 4)
		ply:SetBodygroup(9, 1)
	end

	if num == 5 then
		ply:SetBodygroup(1, 1)
		ply:SetBodygroup(2, 1)
		ply:SetBodygroup(9, 1)
	end

	if num == 6 then
		ply:SetBodygroup(1, 22)
		ply:SetBodygroup(2, 16)
		ply:SetBodygroup(9, 1)
	end
end

concommand.Add("rp_fcitopt", function(ply, command, args)
    if (ply.nexthl2moduletime or 0) > CurTime() then return end
	ply.nexthl2moduletime = CurTime() + 1
    if not (ply:IsSuperAdmin()) then return end
    for _, ply in ipairs(player.GetAll()) do 
		if (ply:Name() == args[1]) then 
			print(ply, args[2])
			setOpt(ply, tonumber(args[2]))
			break 
		end
	end 
end)

concommand.Add("rp_citopt", function(ply, command, args)
    if (ply.nexthl2moduletime or 0) > CurTime() then return end
	ply.nexthl2moduletime = CurTime() + 1

    if not ply:IsAdmin() then
        if ply:GetNWInt("LastCOSet") and 120 - (CurTime() - ply:GetNWInt("LastCOSet")) >= 0 then
            ply:notify("You have to wait " .. math.ceil(120 - (CurTime() - ply:GetNWInt("LastCOSet"))) .. " sec before changing.")

            return false
        end
    end

    local num = args[1]
	
    if tonumber(num) then
        local num = tonumber(num)

        if ply:GetNWInt("citopt") and ply:GetNWInt("citopt") == num then
            ply:notify("You are already a " .. CitOpt[num] .. ".")

            return false
        end

        -- 1 = Loyalist, 2 = Cook, 3 = Black Market, 4 = Medic
        if num == 1 and ply:Team() == TEAM_CITIZEN then
            setOpt(ply, num)
        elseif num == 2 and hasXP(ply, 10) and ply:Team() == TEAM_CWU then
            if getOpts(num, TEAM_CWU, 4) then
                ply:notify("The max limit for " .. CitOpt[num] .. " is already reached.")

                return
            end

            setOpt(ply, num)
        elseif num == 3 and hasXP(ply, 80) and ply:Team() == TEAM_CITIZEN then
            if getOpts(num, TEAM_CITIZEN, 6) then
                ply:notify("The max limit for " .. CitOpt[num] .. " is already reached.")

                return
            end

            setOpt(ply, num)
        elseif num == 4 and hasXP(ply, 35) and ply:Team() == TEAM_CWU then
            if getOpts(num, TEAM_CWU, 3) then
                ply:notify("The max limit for " .. CitOpt[num] .. " is already reached.")

                return
            end

            setOpt(ply, num)
        elseif num == 6 and hasXP(ply, 100) and ply:Team() == TEAM_CWU then
            -- if not table.HasValue({"admin", "superadmin", "moderator", "vip", "developer"}, ply:GetNWString("usergroup")) then
            if getOpts(num, TEAM_CWU, 5) then
                ply:notify("The max limit for " .. CitOpt[num] .. " is already reached.")

                return
            end

            -- return
            -- ply:notify("You can only become a scientist if you donate via the panel.")
            -- end
            setOpt(ply, num)
        elseif num == 5 and ply:Team() == TEAM_CWU then
            setOpt(ply, num)
        end
    end
end, nil, nil, 0, FCVAR_UNREGISTERED);

hook.Add("PlayerSpawn", "gay citizen options", function(ply)
	timer.Simple(.2, function()
		if not (IsValid(ply)) then return; end
		
		if ply:Team() == TEAM_CITIZEN then 
			setOpt(ply, 1);
		elseif ply:Team() == TEAM_CWU then 
			setOpt(ply, 5);
		end 
	end );
end );