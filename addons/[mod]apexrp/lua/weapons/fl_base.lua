AddCSLuaFile()

SWEP.Author = "Full-Life"
SWEP.Base = "weapon_base"
SWEP.PrintName = "pistol base"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.Category = "Full-Life"
SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
-- SWEP.HoldType = "smg"

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 3

SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true

SWEP.Primary.ClipSize = 18
SWEP.Primary.DefaultClip = 36
SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.Tracer = 1
SWEP.Primary.Recoil = 1
SWEP.Primary.Damage = 9
SWEP.Primary.NumShots = 1
SWEP.Primary.Spread = .35
SWEP.Primary.Cone = 1
SWEP.Primary.Delay = 0.15
SWEP.Primary.ShootSound = Sound("Weapon_Pistol.Single")
SWEP.Primary.EmptySound = Sound("Weapon_Pistol.Empty")

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false


SWEP.ReloadSound = Sound("Weapon_Pistol.Reload")
SWEP.ReloadAnimation = ACT_VM_RELOAD

function SWEP:CanPrimaryAttack()
	if ( self:Clip1() <= 0 ) then
		-- self:EmitSound( self.Primary.EmptySound )
        self:EmitSound(self.Primary.EmptySound, 75, 100, 1, 137)
		self:Reload()
		self:SetNextPrimaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
		return false
	end
	return true
end

function SWEP:PrimaryAttack()
    if not self:CanPrimaryAttack() then
        return
    end

    local ply = self:GetOwner()

    ply:LagCompensation(true)
    self:ShootBullet(ply)
    self:EmitSound(self.Primary.ShootSound, 100)
    self:TakePrimaryAmmo(1)
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    self:SimRecoil(ply)

    ply:LagCompensation(false)
end

function SWEP:ShootBullet(ply)
    local bullet = {}
        bullet.Num = self.Primary.NumShots
        bullet.Src = ply:GetShootPos()
        bullet.Dir = (ply:EyeAngles():Forward())
        local bulletspread = self.Primary.Spread * 0.5
        if not ply:IsOnGround() then
            bullet.Spread = Vector(bulletspread * 0.5, bulletspread * 0.5, 0)
        elseif ply:Crouching() then
            bullet.Spread = Vector(bulletspread * 0.1, bulletspread * 0.1, 0)
        elseif ply:IsSprinting() then
            bullet.Spread = Vector(bulletspread * 0.35, bulletspread * 0.35, 0)
        elseif ply:GetVelocity():Length2DSqr() > 50 then
            bullet.Spread = Vector(bulletspread * 0.25, bulletspread * 0.25, 0)
        else
            bullet.Spread = Vector(bulletspread * 0.15, bulletspread * 0.15, 0)
        end

        bullet.Damage = self.Primary.Damage
        bullet.Force = 1
        bullet.AmmoType = self.Primary.Ammo
        bullet.Tracer = self.Primary.Tracer

    self:GetOwner():FireBullets(bullet)
    self:ShootEffects()
end

function SWEP:SimRecoil(ply)
    
    local downwardsRecoil = self.Primary.Recoil
    local sidewaysRecoil = math.random(-self.Primary.Recoil * 0.8, self.Primary.Recoil * 0.8)
        if not ply:OnGround() then
            ply:ViewPunch(Angle(-downwardsRecoil, sidewaysRecoil, 0))
            if IsFirstTimePredicted() and (game.SinglePlayer() or CLIENT) then
                ply:SetEyeAngles(ply:EyeAngles() - Angle(downwardsRecoil, sidewaysRecoil, 0))
            end
        elseif ply:Crouching() then
            ply:ViewPunch(Angle(-downwardsRecoil * 0.15, sidewaysRecoil * 0.15, 0))
            if IsFirstTimePredicted() and (game.SinglePlayer() or CLIENT) then
                ply:SetEyeAngles(ply:EyeAngles() - Angle(downwardsRecoil * 0.5, sidewaysRecoil * 0.5, 0))
            end
        else
            ply:ViewPunch(Angle(-downwardsRecoil * 0.25, sidewaysRecoil * 0.25, 0))
            if IsFirstTimePredicted() and (game.SinglePlayer() or CLIENT) then
                ply:SetEyeAngles(ply:EyeAngles() - Angle(downwardsRecoil * 0.75, sidewaysRecoil * 0.75, 0))
            end
        end
end

function SWEP:Reload()
	if ( self:Clip1() < self.Primary.ClipSize && self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 ) then
		self:DefaultReload( self.ReloadAnimation )
        -- self:EmitSound(self.ReloadSound)
        self:EmitSound(self.ReloadSound, 75, 100, 1, CHAN_AUTO)
	end
end

function SWEP:Equip()
    self:SetDeploySpeed(1)
    -- self:SetWeaponHoldType( self.WeaponHoldType )
end

function SWEP:Deploy()
    self:SetDeploySpeed(1)
    -- self:SetWeaponHoldType( self.WeaponHoldType )
end

function SWEP:Initialize()
	-- self:SetWeaponHoldType( "smg" )
end

function SWEP:CanSecondaryAttack()
    return false
end
