AddCSLuaFile()

SWEP.Author = "Full-Life"
SWEP.Base = "fl_base"
SWEP.PrintName = "M4A1 Assault Rifle"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Category = "Full-Life"
SWEP.ViewModel = "models/apexwep/weapons/v_smg4.mdl"
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.WorldModel = "models/apexwep/weapons/w_smg4.mdl"
SWEP.HoldType = "ar2"

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.Slot = 3
SWEP.SlotPos = 6

SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true

SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 90
SWEP.Primary.Ammo = "ar2"
SWEP.Primary.Tracer = 1
SWEP.Primary.Recoil = .7
SWEP.Primary.Damage = 12
SWEP.Primary.NumShots = 1
SWEP.Primary.Spread = .18
SWEP.Primary.Cone = 1
SWEP.Primary.Delay = 0.14
SWEP.Primary.ShootSound = Sound("Weapon_M4A1.Single")
SWEP.Primary.EmptySound = Sound("Default.ClipEmpty_Rifle")
SWEP.Primary.Automatic = true


SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false


SWEP.ReloadSound = Sound("Weapon_SMG1.Reload")
SWEP.ReloadAnimation = ACT_VM_RELOAD

function SWEP:CanPrimaryAttack()
	if ( self:Clip1() <= 0 ) then
		self:EmitSound( self.Primary.EmptySound )
        self:ADS(self:GetOwner(), false)
		self:Reload()
		self:SetNextPrimaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
		return false
	end
	return true
end

function SWEP:Reload()
	if ( self:Clip1() < self.Primary.ClipSize && self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 ) then
		self:DefaultReload( self.ReloadAnimation )
        self:EmitSound(self.ReloadSound)
	end
end

function SWEP:Deploy()
    self:SetDeploySpeed(1)
end

function SWEP:Initialize()
	self:SetWeaponHoldType( "ar2" )
end

function SWEP:ADS(ply, isaiming)
    if SERVER then
        if ply:IsValid() and isaiming then
            self.IsTryingtoAim = true
            ply:SetFOV(75, 0.3)
            timer.Simple(0.3, function()
                self.IsTryingtoAim = false
            end)
        elseif ply:IsValid() and not isaiming then
            self.IsTryingtoAim = true
            ply:SetFOV(0, 0.3)
            timer.Simple(0.3, function()
                self.IsTryingtoAim = false
            end)
        end
    end
end

function SWEP:Think()
    if self:GetOwner():KeyPressed(IN_RELOAD) and IsFirstTimePredicted() then
            self:ADS(self:GetOwner(), false)
    elseif self:GetOwner():KeyPressed(IN_ATTACK2) and IsFirstTimePredicted() then
        if SERVER then
            self:ADS(self:GetOwner(), true)
        end
    elseif self:GetOwner():KeyReleased( IN_ATTACK2 ) and IsFirstTimePredicted() then
        if SERVER then
            self:ADS(self:GetOwner(), false)
        end
    end
end

function SWEP:Holster()
    self:GetOwner():SetFOV(0, 0.2)
    return true
end