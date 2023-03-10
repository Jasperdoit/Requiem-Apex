AddCSLuaFile()

SWEP.Base = "ls_base_melee"

SWEP.PrintName = "Stun Baton"
SWEP.Category = "Full-Life"

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Author = "Inspired by Vin"
SWEP.Instructions = "Left click to swing, alt and rightclick to change mode"
SWEP.Purpose = "Mode 1 = no voltage, Mode 2 = low voltage and stunning after several hits, Mode 3 = High voltage and blinding effect"

SWEP.HoldType = "melee"

SWEP.WorldModel = Model("models/weapons/w_stunbaton.mdl")
SWEP.ViewModel = Model("models/weapons/c_stunstick.mdl")
SWEP.ViewModelFOV = 52

SWEP.Slot = 4
SWEP.SlotPos = 1

SWEP.LowerAngles = Angle(15, -10, -20)

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = Sound("weapons/stunstick/stunstick_swing1.wav")
SWEP.Primary.ImpactSound = Sound("weapons/stunstick/stunstick_impact2.wav")
SWEP.Primary.ImpactEffect = "StunstickImpact"
SWEP.Primary.HitDelay = 0
SWEP.Primary.FlashTime = 1
SWEP.Primary.Recoil = 1.2 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 12 -- not used in this swep
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = .8
SWEP.Primary.Range = 100

sound.Add({
	name = "lsStunstickBuzz",
	channel = CHAN_AUTO,
	volume = 0.34,
	level = 45,
	sound = "ambient/machines/combine_shield_touch_loop1.wav"
})

function SWEP:ExtraDataTables()
	self:NetworkVar("Int", 5, "Mode")
end

function SWEP:ExtraHolster()
	self.Owner:StopSound("lsStunstickBuzz")

	self:SetMode(1)
end

function SWEP:OnRemove()
	if IsValid(self.Owner) then
		self.Owner:StopSound("lsStunstickBuzz")
	end
end

function SWEP:Initialize()
	self:SetMode(1)
	if self:GetOwner():IsValid() then
		self:GetOwner():StopSound("lsStunstickBuzz")
	end
end

function SWEP:PrePrimaryAttack()
	local mode = self:GetMode()

	if mode == 1 then
		self.Primary.Damage = 3
		self.Primary.ImpactEffect = nil
		self.Primary.FlashTime = 0.2
		self.Primary.Sound = Sound("WeaponFrag.Roll")
		self.Primary.ImpactSound = Sound("physics/plastic/plastic_barrel_impact_bullet1.wav")
	else
		if mode == 2 then
			self.Primary.Damage = 6
			self.Primary.FlashTime = 0.8
		else
			self.Primary.Damage = 10
			self.Primary.FlashTime = 1.1
		end

		self.Primary.ImpactEffect = "StunstickImpact"
		self.Primary.Sound = Sound("weapons/stunstick/stunstick_swing1.wav")
		self.Primary.ImpactSound = Sound("weapons/stunstick/stunstick_impact2.wav")
	end
end

function SWEP:Reload()
	if self.Owner:IsValid() and self:GetMode() != 1 then
		self.Owner:StopSound("lsStunstickBuzz")
		if SERVER then
			self:SetMode(1)
			if self.Owner:Team() == TEAM_CP then
				self.Owner:forceSequence("deactivatebaton")
				self.Owner:EmitSound("weapons/stunstick/spark"..math.random(1, 2)..".wav", 100, math.random(90, 110))
			end
		end
	end
end


function SWEP:SecondaryAttack()
	if self.Owner:KeyDown(IN_WALK) then
		local oldMode = self:GetMode()
		local newMode = oldMode + 1

		if newMode > 3 then
			newMode = 1
			self.Owner:StopSound("lsStunstickBuzz")
		end

		if SERVER then
			self:SetMode(newMode)

			local seq = "deactivatebaton"

			if newMode > 1 then
				self.Owner:EmitSound("weapons/stunstick/spark3.wav", 100, math.random(90, 110))
				seq = "activatebaton"
			else
				self.Owner:EmitSound("weapons/stunstick/spark"..math.random(1, 2)..".wav", 100, math.random(90, 110))
			end

			if newMode == 3 then
				self.Owner:EmitSound("lsStunstickBuzz")
			end

			if self.Owner:Team() == TEAM_CP then
				self.Owner:forceSequence("activatebaton")
			end
		end

		return self:SetNextSecondaryFire(CurTime() + 1)
	end

	if not self.Owner:IsOnGround() then return end

	self.Owner:LagCompensation(true)

	local trace = {}
	trace.start = self.Owner:GetShootPos()
	trace.endpos = trace.start + self.Owner:GetAimVector() * 72
	trace.filter = self.Owner
	trace.mins = Vector(-7, -7, -30)
	trace.maxs = Vector(8, 8, 10)

	local tr = util.TraceHull(trace)
	local ent = tr.Entity
	self.Owner:LagCompensation(false)

	if SERVER and ent and IsValid(ent) then
		if ent:IsPlayer() then
			self.Owner:EmitSound("weapons/crossbow/hitbod"..math.random(1, 2)..".wav")
			local direction = self.Owner:GetAimVector() * 330
			direction.z = 0
			local trace = self.Owner:GetEyeTrace()
			local pushvec = tr.Normal * -100000
			local pushpos = tr.HitPos
			ent:SetVelocity(self.Owner:GetAimVector() * 330)
			local model = string.lower(self.Owner:GetModel())

			if self.Owner:Team() == TEAM_CP then
				self.Owner:forceSequence("pushplayer")
			end

			self:SetNextSecondaryFire(CurTime() + 2)
		end
	end
end



local STUNSTICK_GLOW_MATERIAL = Material("effects/stunstick")
local STUNSTICK_GLOW_MATERIAL2 = Material("effects/blueflare1")
local STUNSTICK_GLOW_MATERIAL_NOZ = Material("sprites/light_glow02_add_noz")

local color_glow = Color(128, 128, 128)

function SWEP:DrawWorldModel()
	self:DrawModel()

	local mode = self:GetMode()

	if not mode or mode < 2 then
		return
	end

	local size

	if mode == 2 then
		size = math.Rand(4.0, 6.0)
	else
		size = math.Rand(6.5, 7.5)
	end

	local glow = math.Rand(0.6, 0.8) * 255
	local color = Color(glow, glow, glow)
	local attachment = self:GetAttachment(1)

	if (attachment) then
		local position = attachment.Pos

		render.SetMaterial(STUNSTICK_GLOW_MATERIAL2)
		render.DrawSprite(position, size * 2, size * 2, color)

		render.SetMaterial(STUNSTICK_GLOW_MATERIAL)
		render.DrawSprite(position, size, size + 3, color_glow)
	end
end

local NUM_BEAM_ATTACHEMENTS = 9
local BEAM_ATTACH_CORE_NAME	= "sparkrear"

function SWEP:PostDrawViewModel()
	local mode = self:GetMode()

	if not mode or mode < 2 then
		return
	end

	local vm = LocalPlayer():GetViewModel()

	if not IsValid(vm) then
		return
	end

	cam.Start3D(EyePos(), EyeAngles())
		local size

		if mode == 2 then
			size = math.Rand(3.0, 4.0)
		else
			size = math.Rand(5.5, 6.5)
		end

		local color = Color(255, 255, 255, 50 + math.sin(RealTime() * 2)*20)

		STUNSTICK_GLOW_MATERIAL_NOZ:SetFloat("$alpha", color.a / 255)

		render.SetMaterial(STUNSTICK_GLOW_MATERIAL_NOZ)

		local attachment = vm:GetAttachment(vm:LookupAttachment(BEAM_ATTACH_CORE_NAME))

		if (attachment) then
			render.DrawSprite(attachment.Pos, size * 10, size * 15, color)
		end

		for i = 1, NUM_BEAM_ATTACHEMENTS do
			local attachment = vm:GetAttachment(vm:LookupAttachment("spark"..i.."a"))

			size = math.Rand(2.5, 5.0)

			if (attachment and attachment.Pos) then
				render.DrawSprite(attachment.Pos, size, size, color)
			end

			local attachment = vm:GetAttachment(vm:LookupAttachment("spark"..i.."b"))

			size = math.Rand(2.5, 5.0)

			if (attachment and attachment.Pos) then
				render.DrawSprite(attachment.Pos, size, size, color)
			end
		end
	cam.End3D()
end