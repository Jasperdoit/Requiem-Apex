AddCSLuaFile( "cl_init.lua" ) -- This means the client will download these files
AddCSLuaFile( "shared.lua" )

include('shared.lua') -- At this point the contents of shared.lua are ran on the server only.

util.AddNetworkString("rg_jailer_openmenu")
util.AddNetworkString("rg_jailer_jail")

function ENT:Initialize( ) --This function is run when the entity is created so it's a good place to setup our entity.
	
	self:SetModel( "models/props_combine/breenconsole.mdl" ) -- Sets the model of the NPC.
	self:PhysicsInit( SOLID_VPHYSICS ) 
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(false)
	end
end

function ENT:OnTakeDamage()
	return false
end

function ENT:Use(ply)
	if ply:IsValid() and ply:IsPlayer() and ply:Alive() and ply:isCombine() and ply:getDivision() > 0 then
		net.Start("rg_jailer_openmenu")
		net.Send(ply)
	else
		ply:notify("You must be a CP or OTA to use this terminal!")
	end
end

local meta = FindMetaTable("Entity")

function meta:IsCloseToJailer()
	if not self:IsPlayer() or not self:IsValid() then return end
	for _, jailer in pairs(ents.FindInSphere(self:GetPos(), 300)) do
		if jailer:GetClass() == "rg_jailer" then
			return true, jailer
		end
	end
	return false, nil
end

net.Receive("rg_jailer_jail", function(len, ply)
	local jailtime = net.ReadInt(32)
	local reason = net.ReadString()
	local isinjailerrange, jailer = ply:IsCloseToJailer()
	if isinjailerrange and jailer:IsValid() then
		if jailtime > 10 or jailtime <= 0 then
			ply:notify("You cannot arrest this person! Invalid arrest time! (Must be >0 and <= 10)")
			return
		end
		if (ply:Team() ~= TEAM_CP and ply:Team() ~= TEAM_OVERWATCH and ply:Team() ~= TEAM_CONSCRIPT) or ply:getDivision() == 0 then ply:notify("You cannot jail someone!") return end
		for _, target in pairs(ents.FindInSphere(jailer:GetPos(), 200)) do
			if not target:IsValid() or not target:IsPlayer() then continue end
			if target:IsValid() and target:IsPlayer() and target:GetActiveWeapon():GetClass() == "weapon_handcuffed" then
				if target:GetNWBool("IsSpy", false) then
					ply:notify("This person has been released because he is an informant!")
					for index, bodygroup in pairs(target:GetBodyGroups()) do
						target:SetBodygroup(index, 0)
					end
					target:SetNWBool("IsRebelScum", false)
					target:SetPos(GAMEMODE.Config.JailExit)
					target:StripWeapon("weapon_handcuffed")
					return
				end
				if target:Team() ~= TEAM_CITIZEN and target:Team() ~= TEAM_CWU and target:Team() ~= TEAM_VORT then
					continue
				end
				if rg_arrest_system.PlayerJailTime[target:SteamID64()] and rg_arrest_system.PlayerJailTime[target:SteamID64()] > 0 then
					ply:notify("You cannot arrest a person that has already been arrested!")
					return
				end
				ply:notify("You have arrest " .. target:Name() .. " for " .. jailtime .. " cycles!")
				target:ArrestPlayer(jailtime, reason)
				if ply:GetNWBool("citizenshipRevoked", false) then
					ply:notify("You have been given 5 SC for arresting a malignant!")
					divisions:addSC(ply, 5)
					ply:SetNWBool("citizenshipRevoked", false)
				elseif target:Team() == TEAM_CITIZEN and ply:GetNWBool("IsRebelScum", false) then
					ply:notify("You have been given 5 SC for arresting a rebel!")
					divisions:addSC(ply, 5)
					return
				else
					ply:notify("You have been given 1 SC for arresting a resident!")
					divisions:addSC(ply, 1)
					return
				end
			end
		end
		ply:notify("There is no valid target in range of the terminal to arrest!")
	else
		ply:notify("You are not close enough to a Arrest Terminal to do this!")
	end
end)