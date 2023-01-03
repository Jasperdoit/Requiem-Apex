AddCSLuaFile()

SWEP.Author = "Full-Life"
SWEP.Base = "fl_base"
SWEP.PrintName = "MP5K"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Category = "Full-Life"
SWEP.ViewModel = "models/weapons/hl2/c_smg1.mdl"
--SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/apexwep/w_mp5.mdl"
SWEP.HoldType = "smg"

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.Slot = 2
SWEP.SlotPos = 3

SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true

SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 90
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Tracer = 1
SWEP.Primary.Recoil = .65
SWEP.Primary.Damage = 9
SWEP.Primary.NumShots = 1
SWEP.Primary.Spread = .26
SWEP.Primary.Cone = 1
SWEP.Primary.Delay = 0.09
SWEP.Primary.ShootSound = Sound("weapons/mysterious/mp5_shoot.ogg")
SWEP.Primary.EmptySound = Sound("Weapon_Pistol.Empty")
SWEP.Primary.Automatic = true


SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false




SWEP.ReloadSound = Sound("weapons/smg1/mp5k_reload2.wav")
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
	self:SetWeaponHoldType( "smg" )
end

function SWEP:ADS(ply, isaiming)
    if SERVER then
        if ply:IsValid() and isaiming then
            self.IsTryingtoAim = true
            ply:SetFOV(80, 0.3)
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