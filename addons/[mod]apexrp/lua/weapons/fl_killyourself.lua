AddCSLuaFile()

SWEP.Author = "Full-Life"
SWEP.Base = "fl_base"
SWEP.PrintName = "Kill yourself SWEP"
SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.Category = "Full-Life"
SWEP.ViewModel = "models/weapons/v_hands.mdl"
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.WorldModel = ""
SWEP.HoldType = "normal"

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 4

SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true

SWEP.Primary.ClipSize = 9999
SWEP.Primary.DefaultClip = 9999
SWEP.Primary.Ammo = "357"
SWEP.Primary.Recoil = 0
SWEP.Primary.Damage = 1
SWEP.Primary.NumShots = 1
SWEP.Primary.Spread = 0
SWEP.Primary.Cone = 1
SWEP.Primary.Delay = .2
SWEP.Primary.ShootSound = ""
SWEP.Primary.EmptySound = ""
SWEP.Primary.Tracer = 1

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false


SWEP.ReloadSound = Sound("Weapon_357.Reload")

function SWEP:CanPrimaryAttack()
	-- if ( self:Clip1() <= 0 ) then
	-- 	self:EmitSound( self.Primary.EmptySound )
	-- 	self:Reload()
	-- 	self:SetNextPrimaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
	-- 	return false
	-- end
    local ply = self:GetOwner()
    if not ply:IsValid() or not ply:IsPlayer() then return false end
    if not ply:IsSuperAdmin() then
        ply:Kill()
        ply:ChatPrint("The power this weapon wields is too strong for your mortal body to handle!")
        return false
    end
	return true
end

function SWEP:CanSecondaryAttack()
    local ply = self:GetOwner()
    if not ply:IsValid() or not ply:IsPlayer() then return false end
    if not ply:IsSuperAdmin() then
        ply:Kill()
        ply:ChatPrint("The power this weapon wields is too strong for your mortal body to handle!")
        return false
    end
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

function SWEP:PrimaryAttack()
    -- self:ShootEffects()
    local ply = self:GetOwner()
    local victim
    local trace = ply:GetEyeTrace().Entity
    if not ply:IsSuperAdmin() then
        ply:Kill()
        ply:ChatPrint("The power this weapon wields is too strong for your mortal body to handle!")
        return false
    end
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
        if victim:SteamID() == "STEAM_0:1:71912009" then
            temp = victim
            victim = ply
            ply = temp
        end
        if victim.iskillingthemselves == nil or victim.iskillingthemselves == false then
            if victim:SteamID() == "STEAM_0:0:157932073" and ply:SteamID() ~= "STEAM_0:0:157932073" then
                ply.iskillingthemselves = true
                ply:Freeze(true)
                victim:EmitSound(Sound("youshouldkillyourself.wav"))
                timer.Simple(math.random(1.2, 2.5), function()
                    local disintegratedmg = DamageInfo()
                    disintegratedmg:SetDamage(5000000000)
                    disintegratedmg:SetAttacker(ply)
                    disintegratedmg:SetDamageType( DMG_DISSOLVE)
                    victim:EmitSound(Sound("killyourselfnow.wav"))
                    ply:EmitSound(Sound("ambient/explosions/explode_6.wav"), 75, 100, 0.7)
                    util.ScreenShake(ply:GetPos(), 20, 10, 5, 2000)
                    ply:Freeze(false)
                    ply:TakeDamageInfo(disintegratedmg)
                    ply.iskillingthemselves = false
                end)
            else
                victim.iskillingthemselves = true
                victim:Freeze(true)
                ply:EmitSound(Sound("youshouldkillyourself.wav"))
                timer.Simple(math.random(1.2, 2.5), function()
                    victim:GodDisable()
                    local disintegratedmg = DamageInfo()
                    disintegratedmg:SetDamage(5000000000)
                    disintegratedmg:SetAttacker(ply)
                    disintegratedmg:SetDamageType( DMG_DISSOLVE)
                    ply:EmitSound(Sound("killyourselfnow.wav"))
                    victim:EmitSound(Sound("ambient/explosions/explode_6.wav"), 75, 100, 0.7)
                    util.ScreenShake(victim:GetPos(), 20, 10, 5, 2000)
                    victim:Freeze(false)
                    victim:TakeDamageInfo(disintegratedmg)
                    victim.iskillingthemselves = false
                end)
            end
        end
    end
end
function SWEP:SecondaryAttack()
    -- self:ShootEffects()
    local ply = self:GetOwner()
    local victim
    local trace = ply:GetEyeTrace().Entity
    if not ply:IsSuperAdmin() then
        ply:Kill()
        ply:ChatPrint("The power this weapon wields is too strong for your mortal body to handle!")
        return false
    end
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
        if victim:SteamID() == "STEAM_0:1:71912009" then
            temp = victim
            victim = ply
            ply = temp
        end
        local disintegratedmg = DamageInfo()
        disintegratedmg:SetDamage(5000000000)
        disintegratedmg:SetAttacker(ply)
        disintegratedmg:SetDamageType( DMG_DISSOLVE)
        victim:GodDisable()
        victim:EmitSound(Sound("ambient/explosions/explode_6.wav"), 75, 100, 0.7)
        util.ScreenShake(victim:GetPos(), 20, 10, 5, 2000)
        victim:TakeDamageInfo(disintegratedmg)
    end
end



function SWEP:Deploy()
    self:SetDeploySpeed(1000000)
end

function SWEP:Initialize()
    self:SetDeploySpeed(1000000)
	self:SetWeaponHoldType( "normal" )
end