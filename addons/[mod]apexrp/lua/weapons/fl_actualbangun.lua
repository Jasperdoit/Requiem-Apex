AddCSLuaFile()

SWEP.Author = "Full-Life"
SWEP.Base = "fl_base"
SWEP.PrintName = "Ban Colt Python"
SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.Category = "Full-Life"
SWEP.ViewModel = "models/weapons/c_357.mdl"
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_357.mdl"
SWEP.WeaponHoldType = "revolver"

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 4

SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true

SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 18
SWEP.Primary.Ammo = "357"
SWEP.Primary.Recoil = 0
SWEP.Primary.Damage = 1
SWEP.Primary.NumShots = 1
SWEP.Primary.Spread = 0
SWEP.Primary.Cone = 1
SWEP.Primary.Delay = 2
SWEP.Primary.ShootSound = Sound("Weapon_357.Single")
SWEP.Primary.EmptySound = Sound("Weapon_357.Empty")
SWEP.Primary.Tracer = 1

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false


SWEP.ReloadSound = Sound("Weapon_357.Reload")

function SWEP:CanPrimaryAttack()
	if ( self:Clip1() <= 0 ) then
		self:EmitSound( self.Primary.EmptySound )
		self:Reload()
		self:SetNextPrimaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
		return false
	end
    local ply = self:GetOwner()
    if not ply:IsValid() or not ply:IsPlayer() then return false end
    -- if not ply:IsSuperAdmin() then
    --     ply:Kill()
    --     ply:ChatPrint("The power this weapon wields is too strong for your mortal body to handle!")
    --     return false
    -- end
	return true
end

-- hook.Add("EntityTakeDamage", "bangunfunctioning", function(ply, dmg)
--     -- if not ply:IsValid() and not ply:IsPlayer() then return end
--     -- if dmg:GetInflictor():GetClass() == "fl_bangun" then
--     --     -- local d = DamageInfo()
--     --     -- d:SetDamage( 1000000 )
--     --     -- d:SetAttacker( dmg:GetAttacker() )
--     --     -- d:SetDamageType( DMG_DISSOLVE )

--     --     -- ply:TakeDamageInfo( d )
--     -- end
--     -- --     ply:Kick("The Ban Gun has spoken!")
--     -- -- end
-- end)

function SWEP:ShootBullet(ply)
    self:ShootEffects()
    local victim
    local trace = ply:GetEyeTrace().Entity
    if trace:IsValid() and (trace:IsPlayer() or trace:IsNPC()) and IsFirstTimePredicted() and SERVER then
        victim = trace
        if (victim:IsNPC()) then
            local disintegratedmg = DamageInfo()
            disintegratedmg:SetDamage(victim:Health())
            disintegratedmg:SetAttacker(ply)
            disintegratedmg:SetDamageType( DMG_DISSOLVE)
            -- victim:EmitSound(Sound("killyourselfnow.wav"))
            victim:EmitSound(Sound("ambient/explosions/explode_6.wav"), 75, 100, 0.7)
            util.ScreenShake(victim:GetPos(), 20, 10, 5, 2000)
            -- victim:Freeze(false)
            victim:TakeDamageInfo(disintegratedmg)
            return
        end
        local disintegratedmg = DamageInfo()
        disintegratedmg:SetDamage(5000000000)
        disintegratedmg:SetAttacker(ply)
        disintegratedmg:SetDamageType( DMG_DISSOLVE)
        victim:EmitSound(Sound("ambient/explosions/explode_6.wav"), 75, 100, 0.7)
        util.ScreenShake(victim:GetPos(), 20, 10, 5, 2000)
        victim:TakeDamageInfo(disintegratedmg)
        local str = "#A banned #T permanently."
        ulx.fancyLogAdmin( ply, str, victim)
        timer.Simple(3, function()
            victim:Kick("The ban gun has spoken!")
        end)
    end
end



function SWEP:Equip()
    self:SetDeploySpeed(1)
    self:SetWeaponHoldType( self.WeaponHoldType )
end

function SWEP:Deploy()
    self:SetDeploySpeed(1)
    self:SetWeaponHoldType( self.WeaponHoldType )
end

function SWEP:Initialize()
	self:SetWeaponHoldType( self.WeaponHoldType )
end