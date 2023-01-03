AddCSLuaFile()

SWEP.Author = "Full-Life"
SWEP.Base = "fl_base"
SWEP.PrintName = "Suicide IED"
SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.Category = "Full-Life"
SWEP.ViewModel = "models/weapons/cstrike/c_c4.mdl"
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_c4.mdl"
SWEP.WeaponHoldType = "slam"

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 4

SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
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
SWEP.isblowingup = false


SWEP.ReloadSound = Sound("Weapon_357.Reload")

-- function SWEP:CanPrimaryAttack()

-- end

function SWEP:PrimaryAttack()
    if self.isblowingup then return end
    self:EmitSound("buttons/button3.wav")
    timer.Simple(.5, function()
        self:EmitSound("buttons/button3.wav")
    end)
    timer.Simple(1, function()
        self:EmitSound("buttons/button3.wav")
    end)
    timer.Simple(1.25, function()
        self:EmitSound("buttons/button3.wav")
    end)
    timer.Simple(1.5, function()
        self:EmitSound("buttons/button3.wav")
    end)
    timer.Simple(1.75, function()
        self:EmitSound("buttons/button3.wav")
    end)
    timer.Simple(2, function()
        self:EmitSound("buttons/button3.wav")
    end)
    timer.Simple(2.3, function()
        self:EmitSound("buttons/button3.wav")
    end)
    timer.Simple(2.5, function()
        self:EmitSound("buttons/button3.wav")
    end)
    timer.Simple(2.7, function()
        self:EmitSound("buttons/button3.wav")
    end)
    timer.Simple(2.8, function()
        self:EmitSound("buttons/button3.wav")
    end)
    timer.Simple(3, function()
        local effectdata = EffectData()
        effectdata:SetOrigin(self:GetPos())
        util.Effect("Explosion",effectdata)
        self:EmitSound("weapons/explode5.wav")
        util.BlastDamage(self, self:GetOwner(), self:GetOwner():GetPos(), 250, 300)
        -- self:GetOwner():TakeDamage(10000, self, self)
        if SERVER then
            self:Remove()
        end
    end)
    self.isblowingup = false
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
    -- self:ShootEffects()
    -- local victim
    -- local trace = ply:GetEyeTrace().Entity
    -- if trace:IsValid() and (trace:IsPlayer() or trace:IsNPC()) and IsFirstTimePredicted() and SERVER then
    --     victim = trace
    --     if (victim:IsNPC()) then
    --         local disintegratedmg = DamageInfo()
    --         disintegratedmg:SetDamage(victim:Health())
    --         disintegratedmg:SetAttacker(ply)
    --         disintegratedmg:SetDamageType( DMG_DISSOLVE)
    --         -- victim:EmitSound(Sound("killyourselfnow.wav"))
    --         victim:EmitSound(Sound("ambient/explosions/explode_6.wav"), 75, 100, 0.7)
    --         util.ScreenShake(victim:GetPos(), 20, 10, 5, 2000)
    --         -- victim:Freeze(false)
    --         victim:TakeDamageInfo(disintegratedmg)
    --         return
    --     end
    --     local disintegratedmg = DamageInfo()
    --     disintegratedmg:SetDamage(5000000000)
    --     disintegratedmg:SetAttacker(ply)
    --     disintegratedmg:SetDamageType( DMG_DISSOLVE)
    --     victim:EmitSound(Sound("ambient/explosions/explode_6.wav"), 75, 100, 0.7)
    --     util.ScreenShake(victim:GetPos(), 20, 10, 5, 2000)
    --     victim:TakeDamageInfo(disintegratedmg)
    --     local str = "#A banned #T permanently."
    --     ulx.fancyLogAdmin( ply, str, victim)
    --     timer.Simple(3, function()
    --         victim:Kick("The ban gun has spoken!")
    --     end)
    -- end
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
    self.isblowingup = false

	self:SetWeaponHoldType( self.WeaponHoldType )
end