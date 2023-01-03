AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
util.AddNetworkString("plockerFunc")
util.AddNetworkString("rbuttonFunc")
util.AddNetworkString("cbuttonFunc")
util.AddNetworkString("mbuttonFunc")
util.AddNetworkString("healthbutton")
util.AddNetworkString("platebutton")
util.AddNetworkString("modelthing")

function ENT:Initialize()
    self:SetModel("models/props_wasteland/controlroom_storagecloset001a.mdl")
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    local phys = self:GetPhysicsObject()

    if (phys:IsValid()) then
        phys:Wake()
    end
end

function ENT:Use(a, c)
    if (c:IsPlayer()) and (c:Team() == TEAM_CITIZEN) then
        net.Start("plockerFunc", false)
        net.Send(c)
    else
        c:notify("This is a totally legit UU approved locker")
    end
end

hook.Add("PlayerSpawn", "plocka", function(ply)
    ply.pIsMedic = false
    ply.pIsRebel = false
    ply:SetNWBool("IsRebelscum", false)
end)

net.Receive("rbuttonFunc", function(len, ply)
	if ply:GetNWInt("NextSuitTime", 0) > CurTime() then
		ply:notify("You are not allowed to suit up for another " .. math.Round(ply:GetNWInt("NextSuitTime", 0) - CurTime()) .. " seconds!")
		return
	end
	ply:SetNWInt("NextSuitTime", CurTime() + 120)
	ply:SetArmor(25)
    local proModel = ply:GetModel()
    ply:SetBodygroup(1, 33)
    ply:SetBodygroup(2, 12)
    ply:SetBodygroup(3, 1)
    ply:SetBodygroup(4, 2)
    ply.pIsRebel = true
    ply.pIsMedic = false
    ply:SetNWBool("IsRebelscum", true)
    ply:notify("You are now wearing Rebel clothes.")
end)

net.Receive("cbuttonFunc", function(len, ply)
	ply:SetArmor(0)
    local roModel = ply:GetModel()

    if ply.pIsRebel == true then
        -- ply:SetArmor(0)
        ply:SetBodygroup(1, 0)
        ply:SetBodygroup(2, 0)
        ply:SetBodygroup(3, 0)
        ply:SetBodygroup(4, 0)
        ply:SetBodygroup(5, 0)
        ply:SetBodygroup(6, 0)
        ply:SetBodygroup(7, 0)
        ply:SetBodygroup(8, 0)
        ply:SetBodygroup(9, 0)
        ply:SetBodygroup(10, 0)
        ply:SetBodygroup(11, 0)
        ply:SetBodygroup(12, 0)
    end

    if ply.pIsMedic == true then
        -- ply:SetArmor(0)
        ply:SetBodygroup(1, 0)
        ply:SetBodygroup(2, 0)
        ply:SetBodygroup(3, 0)
        ply:SetBodygroup(4, 0)
        ply:SetBodygroup(5, 0)
        ply:SetBodygroup(6, 0)
        ply:SetBodygroup(7, 0)
        ply:SetBodygroup(8, 0)
        ply:SetBodygroup(9, 0)
        ply:SetBodygroup(10, 0)
        ply:SetBodygroup(11, 0)
        ply:SetBodygroup(12, 0)
    end

    ply:SetNWBool("IsRebelscum", false)
    ply:notify("You are now wearing Citizen clothes.")
end)

net.Receive("mbuttonFunc", function(len, ply)
	if ply:GetNWInt("NextSuitTime", 0) > CurTime() then
		ply:notify("You are not allowed to suit up for another " .. math.Round(ply:GetNWInt("NextSuitTime", 0) - CurTime()) .. " seconds!")
		return
	end
	ply:SetNWInt("NextSuitTime", CurTime() + 120)
	ply:SetArmor(25)
    pmoModel = ply:GetModel()
    -- ply:SetModel(string.Replace(pmoModel, "group01", "group03m"))
    -- if(!ply.armorCooldown or ply.armorCooldown < CurTime()) then ply:SetArmor(25) ply.armorCooldown = CurTime() + 300 end
    ply.pIsRebel = false
    ply.pIsMedic = true
    ply:SetBodygroup(1, 26)
    ply:SetBodygroup(2, 12)
    ply:SetBodygroup(3, 1)
    ply:SetBodygroup(4, 2)
    ply:SetBodygroup(5, 0)
    ply:SetBodygroup(6, 0)
    ply:SetBodygroup(7, 0)
    ply:SetBodygroup(8, 0)
    ply:SetBodygroup(9, 0)
    ply:SetBodygroup(10, 0)
    ply:SetBodygroup(11, 0)
    ply:SetBodygroup(12, 0)
    ply:SetNWBool("IsRebelscum", true)
    ply:notify("You are now wearing Rebel Medic clothes.")
end)

net.Receive("platebutton", function(len, ply)
    if ply.DarkRPVars.money <= 249 then
        ply:notify("You don't have enough money.")

        return
    end

    if ply.pIsMedic == true or ply.pIsRebel == true then
        if ply:Armor() >= 50 then
            ply:notify("You can't carry any more armor!")

            return
        end

        ply:AddMoney(-250)
        ply:SetArmor(50)
        ply:notify("You bought a armor plate.")
    end
end)

net.Receive("healthbutton", function(len, ply)
    if ply.DarkRPVars.money <= 999 then
        ply:notify("You don't have enough money.")
    end

    if ply.pIsMedic == true or ply.pIsRebel == true then
        ply:AddMoney(-1000)
        ply:SetHealth(100)
        ply:notify("Your HP has been reset to 100.")
    end
end)

hook.Add("PlayerDeath", "dhookp", function(victim, inflictor, attacker)
    net.Start("modelthing", false)
    net.Send(victim)
end)