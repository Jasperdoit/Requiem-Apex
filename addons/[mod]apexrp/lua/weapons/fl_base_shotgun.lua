AddCSLuaFile()

SWEP.Author = "Full-Life"
SWEP.Base = "fl_base"
SWEP.PrintName = "shotgun base"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.Category = "Full-Life"
SWEP.ViewModel = "models/weapons/c_shotgun.mdl"
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.HoldType = "shotgun"

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.Slot = 3
SWEP.SlotPos = 1

SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true

SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 12
SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.Recoil = 7
SWEP.Primary.Damage = 8
SWEP.Primary.NumShots = 12
SWEP.Primary.Spread = 1
SWEP.Primary.Cone = .1
SWEP.Primary.Delay = .4
SWEP.Primary.Automatic = true
SWEP.Primary.Tracer = 1
SWEP.Primary.PumpSound = Sound("weapons/shotgun/shotgun_cock.wav")
SWEP.Primary.ShootSound = Sound("Weapon_Shotgun.Single")
SWEP.Primary.EmptySound = Sound("Weapon_Shotgun.Empty")

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false

SWEP.ReloadSound = Sound("Weapon_Shotgun.Reload")

function SWEP:SetupDataTables()
   self:DTVar( "Bool", 0, "reloading" ) //Sets up a datatable variable to keep track of reloading
end


function SWEP:Think() // Performed every tick to check on reload
    ply = self:GetOwner()
	if self.dt.reloading and IsFirstTimePredicted() then // If the weapon is reloading en the R key is not being spammed
        self:SetNextPrimaryFire( CurTime() + 1 ) // Couldown on next fire to prevent user from being able to finish the anim
        timer.Simple(.5, function() // Cooldown on attack key to not instantly abort reload.
            if ply:KeyDown( IN_ATTACK ) then
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

function SWEP:PrimaryAttack()
    if not self:CanPrimaryAttack() then
        return
    end

    local ply = self:GetOwner()

    ply:LagCompensation(true)

    self:ShootBullet(ply)

    self:EmitSound(self.Primary.ShootSound)
    self:TakePrimaryAmmo(1)
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    timer.Simple(self.Primary.Delay, function()
    self:PumpShotgun()
    end)
    
    self:SimRecoil(ply)

    ply:LagCompensation(false)
end

function SWEP:PumpShotgun()
    self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
    self:EmitSound(self.Primary.PumpSound, 75, 100, 1, 0)
    self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
end

function SWEP:Deploy()
   self.dt.reloading = false
   self.reloadtimer = 0
   self:SetDeploySpeed(1)
   return self.BaseClass.Deploy( self )
end