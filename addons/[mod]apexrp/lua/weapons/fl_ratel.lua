AddCSLuaFile()

SWEP.Author = "Full-Life"
SWEP.Base = "fl_base"
SWEP.PrintName = "RATEL Shotgun"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Category = "Full-Life"
SWEP.ViewModel = "models/tnb/weapons/c_alyx_shotgun.mdl"
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.WorldModel = "models/tnb/weapons/w_alyx_shotgun.mdl"
SWEP.HoldType = "revolver"

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.Slot = 3
SWEP.SlotPos = 1

SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true

SWEP.Primary.ClipSize = 4
SWEP.Primary.DefaultClip = 10
SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.Recoil = 12
SWEP.Primary.Damage = 10
SWEP.Primary.NumShots = 6
SWEP.Primary.Spread = 0.4
SWEP.Primary.Cone = 1
SWEP.Primary.Delay = .2
--SWEP.Primary.ReloadDelay = .2
SWEP.Primary.Automatic = true
SWEP.Primary.Tracer = 1
-- SWEP.Primary.TracerName = "AR2Tracer"
SWEP.Primary.ShootSound = Sound("weapons/hla_shotty/weapon_shotgunblast.wav")
SWEP.Primary.EmptySound = Sound("Weapon_Shotgun.Empty")
SWEP.Primary.StartSound = Sound("weapons/hla_shotty/wep_shotgun_reload_open.wav")
SWEP.Primary.FinishSound = Sound("weapons/hla_shotty/wep_shotgun_reload_close.wav") 
SWEP.ReloadSound = Sound("weapons/hla_shotty/wep_shotgun_reload_insert_shells.wav")

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.MuzzleFlashEnabled = true

function SWEP:SetupDataTables()
   self:DTVar( "Bool", 0, "reloading" ) //Sets up a datatable variable to keep track of reloading
end


function SWEP:Think() // Performed every tick to check on reload
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
    ply = self:GetOwner()
	if self.dt.reloading and IsFirstTimePredicted() then // If the weapon is reloading en the R key is not being spammed
        self:SetNextPrimaryFire( CurTime() + 1.5 ) // Couldown on next fire to prevent user from being able to finish the anim
        timer.Simple(.005, function() // Cooldown on attack key to not instantly abort reload.
            if ply:KeyDown( IN_ATTACK ) and self:Clip1() >= 1 then
                self:FinishReload()
                return
            end
			end)

        if self.reloadtimer <= CurTime() then // If its time for another reload
            if ply:GetAmmoCount( self.Primary.Ammo ) <= 0 then // If you've got no more ammo,
                self:FinishReload() // Stop reloading
            elseif self:Clip1() < self.Primary.ClipSize then // If there is still space in the weapon
                self:LoadShell() // Perform a shell load
            else //In every other case
                self:FinishReload() // Stop reloading
            end
        return
      end
   end
end

function SWEP:StartReload()
    if self.dt.reloading then //Abort if already reloading
        return false
    end

    if not IsFirstTimePredicted() then return false end // Fix for if R key is being held down.

    self:SetNextPrimaryFire( CurTime() + self.Primary.Delay ) // Sets delay on fire to prevent you from being able to fire whilst reloading.

    local ply = self.Owner

    if not ply or ply:GetAmmoCount( self.Primary.Ammo ) <= 0 then // If you've got no more ammo then abort.
        return false 
    end

    local wep = self

    if wep:Clip1() >= self.Primary.ClipSize then // If the clip is full then abort.
        return false
    end

    wep:SendWeaponAnim( ACT_SHOTGUN_RELOAD_START ) // Plays the animation
	self:EmitSound(self.Primary.StartSound)
    ply:SetAnimation( PLAYER_RELOAD )

    self.reloadtimer =  CurTime() + wep:SequenceDuration() // Sets the timer for when the next shell should be loaded.
    self.dt.reloading = true // Starts the think sequence
    return true
end

function SWEP:LoadShell()
    local ply = self.Owner

    self:SetNextPrimaryFire( CurTime() + self.Primary.Delay ) // Sets delay on fire to prevent you from being able to fire whilst reloading.

    if not ply or ply:GetAmmoCount( self.Primary.Ammo ) <= 0 then return end // If we got no more ammo then abort.

    if self:Clip1() >= self.Primary.ClipSize then return end // If the clip is full then abort.

    ply:RemoveAmmo( 1, self.Primary.Ammo, false ) // Take one ammo from reserve.
    self:SetClip1( self:Clip1() + 1 ) // Put the ammo into the gun.

    self:SendWeaponAnim( ACT_VM_RELOAD ) // Play reload animation and play sound.
    self:EmitSound(self.ReloadSound)
    self.reloadtimer = CurTime() + self:SequenceDuration() // Sets the timer for when the next shell should be loaded.
end

function SWEP:FinishReload()
    self.dt.reloading = false // Sets variable as false to stop an infinite loop
    self:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH ) // Plays finish animation
	self:EmitSound(self.Primary.FinishSound)
    self.reloadtimer = CurTime() + self:SequenceDuration() // Sets the timer for when the next shell should be loaded.
end


function SWEP:Reload()
    if self.dt.reloading then // If already reloading then abort
    return end

    if not IsFirstTimePredicted() then // Fix for if R key is being held down.
    return end

    if self:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 then // If we got space in the clip and do have ammo in reserve then start the reloading process.
        if self:StartReload() then
            return
        end
   end
end

function SWEP:CanPrimaryAttack()
	if ( self:Clip1() <= 0 ) then
		self:EmitSound( self.Primary.EmptySound )
        self:ADS(self:GetOwner(), false)
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

    self:EmitSound(self.Primary.ShootSound)
    self:TakePrimaryAmmo(1)
    self:SetNextPrimaryFire(CurTime() + (self.Primary.Delay *3))
    
    self:SimRecoil(ply)

    ply:LagCompensation(false)
end

function SWEP:ShootBullet(ply)
    local bullet = {}
        bullet.Num = self.Primary.NumShots
        bullet.Src = ply:GetShootPos()
        bullet.Dir = (ply:EyeAngles():Forward())
        local bulletspread = self.Primary.Spread * 0.4
        bullet.Spread = Vector(bulletspread * 0.4, bulletspread * 0.4, 0)

        bullet.Damage = self.Primary.Damage
        bullet.Force = 1
        bullet.AmmoType = self.Primary.Ammo
        bullet.Tracer = self.Primary.Tracer

    self.Owner:FireBullets(bullet)
    self:ShootEffects()
end

function SWEP:ADS(ply, isaiming)
    if SERVER then
        if ply:IsValid() and isaiming then
            self.IsTryingtoAim = true
            ply:SetFOV(70, 0.3)
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

function SWEP:Deploy()
   self.dt.reloading = false
   self.reloadtimer = 0
   self:SetDeploySpeed(1)
   return self.BaseClass.Deploy( self )
end


function SWEP:Initialize()
	self:SetWeaponHoldType( "revolver" )
    self.IsTryingtoAim = false
end

function SWEP:Holster()
    self:GetOwner():SetFOV(0, 0.2)
    return true
end