AddCSLuaFile()

SWEP.Author = "Full-Life"
SWEP.Base = "fl_base"
SWEP.PrintName = "O.I.C.W"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Category = "Full-Life"
SWEP.ViewModel = "models/weapons/tfa_misc/c_oicw.mdl"
SWEP.ViewModelFOV = 54
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/tfa_misc/w_oicw.mdl"
SWEP.HoldType = "ar2"

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.Slot = 2
SWEP.SlotPos = 4

SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true

SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 60
SWEP.Primary.Ammo = "AR2"
SWEP.Primary.Recoil = .4
SWEP.Recoil	= .5 -- Overrides Primary.Recoil above, so use this
SWEP.RecoilZoom	= 0.0 -- Recoil when aiming
SWEP.Primary.Damage = 12
SWEP.Primary.NumShots = 1
SWEP.Primary.Spread = .3
SWEP.Spread = .06 -- Overrides Primary.Spread
SWEP.ZoomSpread = 0.00
SWEP.Primary.Cone = 1
SWEP.Primary.Delay = 0.09
SWEP.Delay = 0.09 -- Again, overrides Primary.Delay
--SWEP.ZoomDelay = 0.3 -- Firespeed when aiming
SWEP.Primary.ShootSound = Sound("weapons/tfa_misc/oicw/smg1_fire1.wav")
SWEP.Primary.EmptySound = Sound("Weapon_AR2.Empty")
SWEP.Primary.Tracer = 1
--SWEP.Primary.TracerName = "AR2Tracer"
SWEP.Primary.Automatic = true
SWEP.Automatic = true -- There's probably a so much better way of doing this, but idc
SWEP.ZoomAutomatic = false -- :D
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
CSMuzzleFlashes = true
SWEP.ReloadSound = Sound("weapons/tfa_misc/oicw/oicw_reload.wav")
SWEP.ColorModify = {
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0.3,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = 1,
	[ "$pp_colour_mulr" ] = 0,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
}


function SWEP:Deploy()
    self:SetDeploySpeed(1)
end

function SWEP:Initialize()
	self:SetWeaponHoldType( "ar2" )
end

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

function SWEP:ADS(ply, isaiming)
    if SERVER then
        if ply:IsValid() and isaiming then
            self.IsTryingtoAim = true
			self.Primary.Recoil = self.RecoilZoom
			--self.Primary.Delay = self.ZoomDelay
            self.Primary.Spread = self.ZoomSpread
            self.Primary.Automatic = self.ZoomAutomatic
			ply:EmitSound("hl1/fvox/fuzz.wav")
			ply:CrosshairDisable()
            ply:SetFOV(40, 0.3)
            timer.Simple(0.3, function()
                self.IsTryingtoAim = false
            end)
        elseif ply:IsValid() and not isaiming then
            self.IsTryingtoAim = true
			self.Primary.Recoil = self.Recoil
			self.Primary.Delay = self.Delay
            self.Primary.Spread = self.Spread
            self.Primary.Automatic = self.Automatic
			ply:CrosshairEnable()
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
		bullet.TracerName = self.Primary.TracerName

    self.Owner:FireBullets(bullet)
    self:ShootEffects()
end

function SWEP:DrawHUD()

	if self.Owner:KeyDown(IN_ATTACK2) then
	local x,y = ScrW(),ScrH()
    local w,h = x/2,y/2
    
    surface.SetDrawColor(Color(255, 0, 0))
    surface.DrawRect(w - 1, h - 3, 3, 7)
    surface.DrawRect(w - 3, h - 1, 7, 3)

    surface.SetDrawColor(Color(0, 255, 8, 255))
    surface.DrawLine(w, h - 15, w, h + 15)
    surface.DrawLine(w - 15, h, w + 15, h)

    local time = 10    
    local scale = 20 * 0.02 -- self.Cone
    local gap = 1 * scale
    local length = gap + 30 * scale

    surface.SetDrawColor(0,0,255,255)
		surface.SetDrawColor(255, 255, 255, 255)
		DrawMaterialOverlay("effects/combine_binocoverlay", 1) -- Better than using a console command to set it
		DrawColorModify(self.ColorModify)
		--self.Owner:ConCommand("pp_mat_overlay effects/combine_binocoverlay");
		--self.Owner:ConCommand("pp_colormod 1");
		--self.Owner:ConCommand("pp_colormod_addg 9");
--	else
	--	self.Owner:ConCommand("pp_mat_overlay \"\"");
		--self.Owner:ConCommand("pp_colormod 0 \"\"");
		--self.Owner:ConCommand("pp_colormod_addg \"\"");
	end 
end

function SWEP:Holster()
    self:GetOwner():SetFOV(0, 0.2)
    return true
end

hook.Add("ScalePlayerDamage", "AR2ArmorScale", function(ply, hitgroup, dmg)
    if not dmg:GetAttacker():IsPlayer() then return end
    local attacker = dmg:GetAttacker()
    if attacker:GetActiveWeapon():GetClass() != "fl_oicw" then return end
    dmg:SetDamage(dmg:GetDamage() + math.Round(ply:Armor() * (1/7)))
end)