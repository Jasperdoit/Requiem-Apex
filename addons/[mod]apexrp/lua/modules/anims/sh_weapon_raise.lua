---------------------------------------------------------------------------
	-- Methods.
---------------------------------------------------------------------------

local playerMeta = FindMetaTable("Player")

ALWAYS_RAISED = {}
ALWAYS_RAISED["weapon_physcannon"] = true
ALWAYS_RAISED["weapon_physgun"] = true
ALWAYS_RAISED["gmod_tool"] = true
ALWAYS_RAISED["keys"] = true
ALWAYS_RAISED["pocket"] = true
ALWAYS_RAISED["pocket"] = true
ALWAYS_RAISED["weaponchecker"] = true
ALWAYS_RAISED["thc_adminstick"] = true
ALWAYS_RAISED["weapon_frag"] = false
ALWAYS_RAISED["gmod_flashbang"] = true
ALWAYS_RAISED["breachingcharge"] = true
ALWAYS_RAISED["weaponchecker"] = true
ALWAYS_RAISED["swep_vortigaunt_beam"] = true
ALWAYS_RAISED["weapon_hl2bottle"] = true
ALWAYS_RAISED["arccw_go_nade_frag"] = true
ALWAYS_RAISED["arccw_go_nade_flash"] = true
ALWAYS_RAISED["arccw_go_nade_smoke"] = true
ALWAYS_RAISED["arccw_go_nade_molotov"] = true
ALWAYS_RAISED["weapon_breachingcharge"] = true
ALWAYS_RAISED["weapon_healthvial"] = true
ALWAYS_RAISED["weapon_disposal_medkit"] = true
ALWAYS_RAISED["weapon_medkit"] = true
ALWAYS_RAISED["gws_pick"] = true
ALWAYS_RAISED["dradio"] = true
ALWAYS_RAISED["fl_killyourself"] = true
ALWAYS_RAISED["weapon_handcuffed"] = true
ALWAYS_RAISED["weapon_cuff_elastic"] = true
ALWAYS_RAISED["weapon_cuff_police"] = true
ALWAYS_RAISED["weapon_disposal_medkit"] = true
ALWAYS_RAISED["weapon_healthvial"] = true
ALWAYS_RAISED["weapon_suitcharge"] = true

function playerMeta:isWepRaised()
	local weapon = self.GetActiveWeapon(self)
	local override = hook.Run("ShouldWeaponBeRaised", self, weapon)

	-- Allow the hook to check first.
	if (override != nil) then
		return override
	end

	-- Some weapons may have their own properties.
	if (IsValid(weapon)) then
		-- If their weapon is always raised, return true.
		if (weapon.IsAlwaysRaised or ALWAYS_RAISED[weapon.GetClass(weapon)]) then
			return true
		-- Return false if always lowered.
		elseif (weapon.IsAlwaysLowered or weapon.NeverRaised) then
			return false
		end
	end

	-- Let the config decide before actual results.
	if (GAMEMODE.Config.weaponsAlwaysRaised) then
		return true
	end

	return self:GetNWBool( "raised", false );
end

if (SERVER) then
	-- Sets whether or not the weapon is raised.
	function playerMeta:setWepRaised(state)
		-- Sets the networked variable for being raised.
		self:SetNWBool("raised", state)

		-- Delays any weapon shooting.
		local weapon = self:GetActiveWeapon()

		if (IsValid(weapon)) then
			weapon:SetNextPrimaryFire(CurTime() + 1)
			weapon:SetNextSecondaryFire(CurTime() + 1)
		end
	end

	-- Inverts whether or not the weapon is raised.
	function playerMeta:toggleWepRaised()
		self:setWepRaised(!self:isWepRaised())

		local weapon = self:GetActiveWeapon()

		if (IsValid(weapon)) then
			if (self:isWepRaised() and weapon.OnRaised) then
					weapon:OnRaised()
			elseif (!self:isWepRaised() and weapon.OnLowered) then
				weapon:OnLowered()
			end
		end
	end
end 


---------------------------------------------------------------------------
	-- Hooks.
---------------------------------------------------------------------------

if ( SERVER ) then 
	hook.Add( "KeyPress", "hl2rp: wep raise toggle", function( ply, key )
		if ( key == IN_RELOAD ) then 
			timer.Create("toggleRaise" .. ply:SteamID(), .5, 1, function()
				if ( IsValid(ply ) ) then
					ply:toggleWepRaised()
				end
			end );
		end 
	end );

	hook.Add( "KeyRelease", "hl2rp: wep raise toggle", function( ply, key )
		if ( key == IN_RELOAD ) then
			timer.Remove("toggleRaise" .. ply:SteamID() );
		end
	end );
	
	hook.Add( "PlayerSwitchWeapon", "hl2rp: wep raise toggle", function( client, oldWeapon, newWeapon )
		client:setWepRaised(false)
	end );
else 
	local NUT_CVAR_LOWER2 = CreateClientConVar("nut_usealtlower", "0", true)
	local LOWERED_ANGLES = Angle(30, -30, -25)

	hook.Add( "CalcViewModelView", "hl2rp: weapon raise", function(weapon, viewModel, oldEyePos, oldEyeAngles, eyePos, eyeAngles)
		if (!IsValid(weapon)) then
			return
		end

		local vm_origin, vm_angles = eyePos, eyeAngles

		--Intervention of Nutscript Holster/Raise Angle/Positions. 
		do 
			local client = LocalPlayer()
			local value = 0

			if (!client:isWepRaised()) then
				value = 100
			end

			local fraction = (client.nutRaisedFrac or 0) / 100
			local rotation = weapon.LowerAngles or LOWERED_ANGLES
				
			if (NUT_CVAR_LOWER2:GetBool() and weapon.LowerAngles2) then
				rotation = weapon.LowerAngles2
			end
				
			vm_angles:RotateAroundAxis(vm_angles:Up(), rotation.p * fraction)
			vm_angles:RotateAroundAxis(vm_angles:Forward(), rotation.y * fraction)
			vm_angles:RotateAroundAxis(vm_angles:Right(), rotation.r * fraction)

			client.nutRaisedFrac = Lerp(FrameTime() * 2, client.nutRaisedFrac or 0, value)
		end

		--The original code of the hook.
		do
			local func = weapon.GetViewModelPosition
			if (func) then
				local pos, ang = func( weapon, eyePos*1, eyeAngles*1 )
				vm_origin = pos or vm_origin
				vm_angles = ang or vm_angles
			end

			func = weapon.CalcViewModelView
			if (func) then
				local pos, ang = func( weapon, viewModel, oldEyePos*1, oldEyeAngles*1, eyePos*1, eyeAngles*1 )
				vm_origin = pos or vm_origin
				vm_angles = ang or vm_angles
			end
		end

		return vm_origin, vm_angles
	end );
end 

local KEY_BLACKLIST = IN_ATTACK + IN_ATTACK2

hook.Add( "StartCommand", "hl2rp: wep raised", function(client, command)
	local weapon = client:GetActiveWeapon()

	if (!client:isWepRaised()) then
		if (IsValid(weapon) and weapon.FireWhenLowered) then
			return
		end

		command:RemoveKey(KEY_BLACKLIST)
	end
end );