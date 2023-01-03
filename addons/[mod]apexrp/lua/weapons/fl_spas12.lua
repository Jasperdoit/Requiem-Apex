AddCSLuaFile()

SWEP.Author = "Full-Life"
SWEP.Base = "fl_base"
SWEP.PrintName = "SPAS-12"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Category = "Full-Life"
SWEP.ViewModel = "models/weapons/apexwep/c_shotgun.mdl"
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.ShowWorldModel = false
SWEP.WElements = {
	["element_name"] = { type = "Model", model = "models/weapons/apexwep/c_shotgun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-5, 8.199, -7.901), angle = Angle(-7.778, 0, 180), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
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
SWEP.Primary.Damage = 9
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
        -- self:SetNextPrimaryFire( CurTime() + 1 ) // Couldown on next fire to prevent user from being able to finish the anim
        -- timer.Simple(.5, function() // Cooldown on attack key to not instantly abort reload.
            if ply:KeyDown( IN_ATTACK ) and self:Clip1() >= 1 then
                self:FinishReload()
                return
            end
        -- end)

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

    self:EmitSound(self.Primary.ShootSound)
    self:TakePrimaryAmmo(1)
    self:SetNextPrimaryFire(CurTime() + (self.Primary.Delay *3))

    timer.Simple(self.Primary.Delay, function()
    if not self:IsValid() then return end
    self:PumpShotgun()
    end)
    
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

function SWEP:PumpShotgun()
    self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
    self:EmitSound(self.Primary.PumpSound, 75, 100, 1, CHAN_ITEM)
    self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
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
	self:SetWeaponHoldType( "shotgun" )
    self.IsTryingtoAim = false
end

function SWEP:Holster()
    self:GetOwner():SetFOV(0, 0.2)
    return true
end

/********************************************************
	SWEP Construction Kit base code
		Created by Clavus
	Available for public use, thread at:
	   facepunch.com/threads/1032378
	   
	   
	DESCRIPTION:
		This script is meant for experienced scripters 
		that KNOW WHAT THEY ARE DOING. Don't come to me 
		with basic Lua questions.
		
		Just copy into your SWEP or SWEP base of choice
		and merge with your own code.
		
		The SWEP.VElements, SWEP.WElements and
		SWEP.ViewModelBoneMods tables are all optional
		and only have to be visible to the client.
********************************************************/
function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	// other initialize code goes here
	if CLIENT then
	
		// Create a new table for every weapon instance
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )
		self:CreateModels(self.VElements) // create viewmodels
		self:CreateModels(self.WElements) // create worldmodels
		
		// init view model bone build function
		if IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
				
				// Init viewmodel visibility
				if (self.ShowViewModel == nil or self.ShowViewModel) then
					vm:SetColor(Color(255,255,255,255))
				else
					// we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
					vm:SetColor(Color(255,255,255,1))
					// ^ stopped working in GMod 13 because you have to do Entity:SetRenderMode(1) for translucency to kick in
					// however for some reason the view model resets to render mode 0 every frame so we just apply a debug material to prevent it from drawing
					vm:SetMaterial("Debug/hsv")			
				end
			end
		end
		
	end
end
function SWEP:Holster()
	
	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	
	return true
end
function SWEP:OnRemove()
	self:Holster()
end
if CLIENT then
	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		
		local vm = self.Owner:GetViewModel()
		if !IsValid(vm) then return end
		
		if (!self.VElements) then return end
		
		self:UpdateBonePositions(vm)
		if (!self.vRenderOrder) then
			
			// we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}
			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end
			
		end
		for k, name in ipairs( self.vRenderOrder ) do
		
			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
			if (v.hide) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (!v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (!pos) then continue end
			
			if (v.type == "Model" and IsValid(model)) then
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				model:SetAngles(ang)
				//model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()
			end
			
		end
		
	end
	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end
		
		if (!self.WElements) then return end
		
		if (!self.wRenderOrder) then
			self.wRenderOrder = {}
			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end
		end
		
		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else
			// when the weapon is dropped
			bone_ent = self
		end
		
		for k, name in pairs( self.wRenderOrder ) do
		
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			if (v.hide) then continue end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and IsValid(model)) then
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				model:SetAngles(ang)
				//model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()
			end
			
		end
		
	end
	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end
			
			// Technically, if there exists an element with the same name as a bone
			// you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)
			if (!bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r // Fixes mirrored models
			end
		
		end
		
		return pos, ang
	end
	function SWEP:CreateModels( tab )
		if (!tab) then return end
		// Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				// make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end
	
	local allbones
	local hasGarryFixedBoneScalingYet = false

	function SWEP:UpdateBonePositions(vm)
		
		if self.ViewModelBoneMods then
			
			if (!vm:GetBoneCount()) then return end
			
			// !! WORKAROUND !! //
			// We need to check all model names :/
			local loopthrough = self.ViewModelBoneMods
			if (!hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then 
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = { 
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end
				
				loopthrough = allbones
			end
			// !! ----------- !! //
			
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end
				
				// !! WORKAROUND !! //
				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				
				s = s * ms
				// !! ----------- !! //
				
				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end
		   
	end
	 
	function SWEP:ResetBonePositions(vm)
		
		if (!vm:GetBoneCount()) then return end
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
		
	end

	/**************************
		Global utility code
	**************************/

	// Fully copies the table, meaning all tables inside this table are copied too and so on (normal table.Copy copies only their reference).
	// Does not copy entities of course, only copies their reference.
	// WARNING: do not use on tables that contain themselves somewhere down the line or you'll get an infinite loop
	function table.FullCopy( tab )
		if (!tab) then return nil end
		
		local res = {}
		for k, v in pairs( tab ) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v) // recursion ho!
			elseif (type(v) == "Vector") then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == "Angle") then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end
		
		return res
		
	end
	
end
