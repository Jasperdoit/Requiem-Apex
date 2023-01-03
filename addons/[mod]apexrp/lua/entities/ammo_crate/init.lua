AddCSLuaFile( "cl_init.lua" ) -- This means the client will download these files
AddCSLuaFile( "shared.lua" )

include('shared.lua') -- At this point the contents of shared.lua are ran on the server only.


function ENT:Initialize( ) --This function is run when the entity is created so it's a good place to setup our entity.
	
	self:SetModel( "models/Items/ammocrate_ar2.mdl" ) -- Sets the model of the NPC.
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

local function hasflashbang(ply)
	if not ply:IsValid() then return false end
	if not ply:isCombine() then return false end
	if ply:getDivision() == 0 then return false end
	for _, weapon in pairs(ply.issuedLoadout or {}) do
		if weapon == "gmod_flashbang" then
			return true
		end
	end

	return false
end

local function hasgrenade(ply)
	if not ply:IsValid() then return false end
	if not ply:isCombine() then return false end
	if ply:getDivision() == 0 then return false end
	for _, weapon in pairs(ply.issuedLoadout or {}) do
		if weapon == "weapon_frag" then
			return true
		end
	end

	return false
end

function ENT:AcceptInput( Name, Activator, Caller )	

weaponAmmo = {}
weaponAmmo["Pistol"] = 94
weaponAmmo["357"] = 50
weaponAmmo["SMG1"] = 500
weaponAmmo["slam"] = 3
weaponAmmo["tfa_ammo_357"] = 50
weaponAmmo["tfa_ammo_ar2"] = 300
weaponAmmo["tfa_ammo_buckshot"] = 80
weaponAmmo["tfa_ammo_pistol"] = 94
weaponAmmo["tfa_ammo_smg"] = 420
weaponAmmo["SniperPenetratedRound"] = 30
weaponAmmo["tfa_ammo_winchester"] = 50
weaponAmmo["Grenade"] = 1
if Activator:HasWeapon("grub_combine_sniper") then
	weaponAmmo["AR2"] = 50
elseif Activator:HasWeapon("weapon_bp_flamethrower") then
    weaponAmmo["bp_flame"] = 500
elseif Activator:HasWeapon("fas2_cweaponry_pmg") then
    weaponAmmo["AR2"] = 600
elseif Activator:HasWeapon("fas2_cweaponry_psr") then
    weaponAmmo["AR2"] = 30  
elseif Activator:HasWeapon("fas2_cweaponry_ar3") then
    weaponAmmo["AR2"] = 300
elseif Activator:HasWeapon("tfa_misc_oicw") then
    weaponAmmo["AR2"] = 300
elseif Activator:HasWeapon("fas2_cweaponry_psmg") then
    weaponAmmo["SMG1"] = 500          
else	
	weaponAmmo["AR2"] = 300
end
weaponAmmo["Buckshot"] = 52
weaponAmmo["XBowBolt"] = 45

	if Name == "Use" and Caller:IsPlayer() then
	local Wpn = ""
	local Count = 0
    	for k , v in ipairs(Caller:GetWeapons()) do
			local AmmoName = game.GetAmmoName(v:GetPrimaryAmmoType())
			--print(AmmoName)
			if weaponAmmo[AmmoName] and Caller:GetAmmoCount(AmmoName) and Caller:GetAmmoCount(AmmoName) < weaponAmmo[AmmoName] then

				local giveAmmo =  weaponAmmo[AmmoName] - Caller:GetAmmoCount(AmmoName)
					local AmmoName = weaponAmmo[AmmoName]
					Caller:GiveAmmo( giveAmmo, v:GetPrimaryAmmoType(), true )
			end
    	end
		if Caller:GetAmmoCount("ammo_breachingcharge") < 4 and Caller:HasWeapon("weapon_breachingcharge") then
			Caller:GiveAmmo(3,"ammo_breachingcharge")
			local ammocount = Caller:GetAmmoCount("ammo_breachingcharge")
			Caller:SetAmmo(math.Clamp(ammocount,0,12),"ammo_breachingcharge")
		end
		if hasflashbang(Caller) and not Caller:HasWeapon("gmod_flashbang") then
			Caller:Give("gmod_flashbang")
		end
		if hasgrenade(Caller) and not Caller:HasWeapon("weapon_frag") then
			Caller:Give("weapon_frag")
		end
    	Caller:ChatPrint("Your ammo has been restocked.")
	end
	
end