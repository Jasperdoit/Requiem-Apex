AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("SpecATMOpen")
util.AddNetworkString("SpecATMDepositMoney")
util.AddNetworkString("SpecATMWithdrawMoney")

function ENT:Initialize()
	self:SetModel("models/props_combine/combine_intwallunit.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()

	if phys:IsValid() then

		phys:Wake()
	end
end

function ENT:Use(activator)
	if activator:IsValid() and activator:IsPlayer() then
		net.Start("SpecATMOpen")
		net.WriteEntity(self)
		net.WriteInt(activator:GetPData("bankmoney2", 0), 32)
		net.Send(activator)
	end
end


-- Storing the banked money can be done in multiple ways. We can do it via PDATA or the DATA folder of the server. Both of them have their Pros and Cons. https://wiki.facepunch.com/gmod/File_Based_Storage
-- The current problem with https://wiki.facepunch.com/gmod/Player:SetPData is that it relies on UniqueID instead of STEAMID. UniqueID has a chance to be shared between two different people, which can cause issues.
-- For this example, to spice it up, we are using the latter.
-- An important thing is, is to handle the bankedmoney ONLY on the server. We do input fields on the client, since that is required but we handle those inputs ONLY on the SERVER and even then we use proper caution to make sure that the input is correct.
-- NEVER EVER TRUST THE CLIENT, if you can code lua, so can they and they can have the tools to take apart your precious net-messages and bend them in such a way to make them suck your eggballs dry.
-- TLDR: handle important data only on the server.

-- If the server runs this file for the first time, we want to make sure it exists. We do this by checking if it exists and if it does not, we make the file with "{}" being the content. 

net.Receive("SpecATMDepositMoney", function(len, ply)
    -- Initial boolean check to see if we are actually dealing with a valid player calling this (Imagine console or NPCs calling this for god knows why)`
    if not ply:IsValid() or not ply:IsPlayer() then return end
    -- Read the contents of the net message. THEY MUST BE IN THE SAME ORDER AS THEY ARE SENT!
    local ATM = net.ReadEntity()
    local DepositAmount = math.Round(net.ReadInt(32))
    -- Bail if we get invalid data from the net message. Remember: We are dealing with info from a client who may sent any information he wants if he's got the right tools
    if not (ATM:IsValid() and ATM:GetClass() == "atm_machine") or not (DepositAmount and isnumber(DepositAmount)) then return end
    if DepositAmount <= 0 then return end
    -- Distance check to check if the player is close enough to an ATM
    if ATM:GetPos():DistToSqr(ply:GetPos()) > 250*250 then return end
    -- Money check to see if the player has enough money
    if ply.DarkRPVars.money < DepositAmount then ply:notify("You do not have enough money to store T" .. DepositAmount .. "!") return end


    -- Finally, we subtract the money from the player. We substract before adding to avoid creating an accidental exploit.
    ply:AddMoney(-DepositAmount)

    -- Assign the table (converted from JSON) to the variable ATMAccounts for easy accessing.
    ply:SetPData("bankmoney2", ply:GetPData("bankmoney2", 0) + DepositAmount)
    net.Start("SpecATMOpen")
    net.WriteEntity(ATM)
    net.WriteInt(ply:GetPData("bankmoney2", 0), 32)
    net.Send(ply)
end)

net.Receive("SpecATMWithdrawMoney", function(len, ply)
    -- Ditto as above, but with a few inversions
    if not ply:IsValid() or not ply:IsPlayer() then return end

    local ATM = net.ReadEntity()
    local WithdrawAmount = math.Round(net.ReadInt(32))

    if not (ATM:IsValid() and ATM:GetClass() == "atm_machine") or not (WithdrawAmount and isnumber(WithdrawAmount)) then return end
	local bankmoney = tonumber(ply:GetPData("bankmoney2", 0))
    if ATM:GetPos():DistToSqr(ply:GetPos()) > 250*250 then return end
    if WithdrawAmount <= 0 then return end
    if bankmoney < WithdrawAmount then ply:notify("You do not have enough money to store T" .. WithdrawAmount .. "!") return end

    ply:SetPData("bankmoney2", bankmoney - WithdrawAmount)
    ply:AddMoney(WithdrawAmount)
    net.Start("SpecATMOpen")
    net.WriteEntity(ATM)
    net.WriteInt(bankmoney - WithdrawAmount, 32)
    net.Send(ply)
end)

