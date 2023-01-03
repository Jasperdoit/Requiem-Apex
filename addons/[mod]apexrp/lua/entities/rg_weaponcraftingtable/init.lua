AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
util.AddNetworkString("weaponcraftingtable_open")
util.AddNetworkString("weaponcraftingtable_craft")
util.AddNetworkString("weaponcraftingtable_cancelcraft")
util.AddNetworkString("weaponcraftingtable_upgrade")

function ENT:Initialize()
    self:SetModel("models/props_wasteland/controlroom_desk001a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetWeaponClass("")
    self:SetWeaponsModel("")
    self:SetWeaponTime(0)
    self:SetTableTier(1)
    self:SetProgress(0)
    self:SetWeaponItemIndex(0)
	self.removaltime = 5
    self.reward = 2
    -- self.SharePhysgun1 = true
    -- self.ShareGravgun1 = true
    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
    end
end

local breaksounds = {
    "physics/metal/metal_sheet_impact_hard2.wav",
    "physics/metal/metal_sheet_impact_hard6.wav",
    "physics/metal/metal_sheet_impact_hard7.wav",
    "physics/metal/metal_sheet_impact_hard8.wav",
    "physics/metal/metal_sheet_impact_soft2.wav",
    "physics/metal/metal_solid_impact_bullet1.wav",
    "physics/metal/metal_solid_impact_bullet2.wav",
    "physics/metal/metal_solid_impact_bullet3.wav",
    "physics/metal/metal_solid_impact_hard1.wav",
    "physics/metal/metal_solid_impact_hard4.wav",
    "physics/metal/metal_solid_impact_hard5.wav"
}

function ENT:Use(activator, ply)
	if !ply:IsValid() then return end
    if ply:Team() == TEAM_CITIZEN then
        net.Start("weaponcraftingtable_open")
        net.WriteEntity(self)
        net.Send(ply)
	elseif ply:isCombine() then
		if self.isRemoving then 
			ply:notify("This table is already being confiscated!")
			return
		end
		local doneCounting = 0
		if doneCounting == 0 then ply:notify("You are destroying a craftingtable.") end
		timer.Create("tableremovaltimer-" .. self:EntIndex(), 1, self.removaltime, function()
			self.isRemoving = true
			doneCounting = doneCounting + 1
			local sound = table.Random(breaksounds)
			self:EmitSound(sound)
			if !ply:KeyDown(IN_USE) then
				timer.Remove("tableremovaltimer-" .. self:EntIndex())
				self.isRemoving = false
				return 
			end
			if doneCounting >= self.removaltime then
				timer.Remove("tableremovaltimer-" .. self:EntIndex())
				self.isRemoving = false
				self:confiscate(ply)
			end
		end)
    else
        ply:notify("You must be a citizen to use this table!")
    end
end

function ENT:confiscate(ply)
	local reward = self.reward * self:GetTableTier()
	ply:notify("You have successfully destroyed the craftingtable and have been rewarded " .. reward .. "SC!")
	divisions:addSC(ply, reward)
	self:Remove()
end

net.Receive("weaponcraftingtable_craft", function(len, ply)
    if (ply.nextcraftingtime or 0) > CurTime() then return end
    ply.nextcraftingtime = CurTime() + 1
    if not ply:IsValid() or not ply:IsPlayer() then return end
    local classid = net.ReadInt(32)

    if not WeaponCraftingTableItems[classid] then
        ply:ChatPrint("This item does not exist, dummy!")

        return
    end

    local weaponinfo = WeaponCraftingTableItems[classid]
    local craftingtable = net.ReadEntity() or nil

    if craftingtable == nil then
        ply:notify("There is no crafting table close to you!")

        return
    end

    if craftingtable:GetClass() ~= "rg_weaponcraftingtable" then return end

    if craftingtable:GetWeaponClass() ~= "" or craftingtable:GetWeaponTime() ~= 0 then
        ply:notify("You can't craft an item whilst one is being crafted!")

        return
    end

    if craftingtable:GetTableTier() < weaponinfo.tier then
        ply:notify("You can't make this weapon as this weapon is a higher tier than the table is.")

        return
    end

    -- if craftingtable:GetTableTier() > 5 then
    -- 	craftingtable:SetTableTier(5)
    -- end
    craftingtable.Crafter = ply
    craftingtable:Craft(weaponinfo, classid)
end)

net.Receive("weaponcraftingtable_upgrade", function(len, ply)
    if (ply.nextcraftingtime or 0) > CurTime() then return end
    ply.nextcraftingtime = CurTime() + 1
    if not ply:IsValid() or not ply:IsPlayer() then return end
    local craftingtable = net.ReadEntity() or nil

    if craftingtable == nil then
        ply:notify("There is no crafting table close to you!")

        return
    end

    if craftingtable:GetClass() ~= "rg_weaponcraftingtable" then return end

    if craftingtable:GetTableTier() > WeaponCraftingTable.maxtier then
        ply:notify("You can't upgrade this table as it has reached it's max tier!")

        return
    end

    if ply.DarkRPVars.money < 265 * craftingtable:GetTableTier() then
        ply:notify("You do not have enough money to upgrade this! (T" .. 265 * craftingtable:GetTableTier() .. ")")

        return
    end

    craftingtable:SetTableTier(craftingtable:GetTableTier() + 1)
    ply:AddMoney(-265 * (craftingtable:GetTableTier() - 1))
end)

net.Receive("weaponcraftingtable_cancelcraft", function(len, ply)
    if (ply.nextcraftingtime or 0) > CurTime() then return end
    ply.nextcraftingtime = CurTime() + 1
    if not ply:IsValid() or not ply:IsPlayer() then return end
    local craftingtable = net.ReadEntity() or nil

    if craftingtable == nil then
        ply:notify("There is no crafting table close to you!")

        return
    end

    if craftingtable:GetClass() ~= "rg_weaponcraftingtable" then return end

    if craftingtable:GetWeaponClass() == "" or craftingtable:GetWeaponTime() == 0 then
        ply:notify("You can't cancel an item that is not being crafted!")

        return
    end

    craftingtable:CancelCraft()
end)

function ENT:CancelCraft()
    self:SetWeaponClass("")
    self:SetWeaponTime(0)
    self:SetWeaponsModel("")
    self:SetProgress(0)
    self:SetWeaponItemIndex(0)
end

function ENT:Craft(itemData, index)
    self:SetWeaponClass(itemData.classname)
    self:SetWeaponTime(itemData.time)
    self:SetWeaponsModel(itemData.model)
    self:SetProgress(0)
    self:SetWeaponItemIndex(index)
end

function ENT:Think()
    if self:GetWeaponClass() ~= "" and self:GetWeaponTime() ~= 0 then
        if self:GetProgress() >= self:GetWeaponTime() then
            local iteminfo = WeaponCraftingTableItems[self:GetWeaponItemIndex()]

            if iteminfo.isammo then
                local ammo = ents.Create("spawned_ammo")
                ammo:SetModel(iteminfo.model)
                ammo.ShareGravgun = true
                ammo:SetPos(self:GetPos() + Vector(0, 0, 25))
                ammo.nodupe = true
                ammo.ammoType = iteminfo.classname
                ammo.amountGiven = iteminfo.ammoamount

                ammo:Spawn()

                if self.Crafter and self.Crafter:IsValid() and self.Crafter:IsPlayer() then
                    self.Crafter:notify("Your " .. iteminfo.weaponname .. " is done crafting!")
                end

                self:SetWeaponClass("")
                self:SetWeaponTime(0)
                self:SetWeaponsModel("")
                self:SetDoneCrafting(true)
                self:SetWeaponItemIndex(0)
            else
                local weapon = ents.Create("spawned_weapon")
                weapon.ShareGravgun = true
                weapon:SetPos(self:GetPos() + Vector(0, 0, 25))
                weapon:SetWeaponClass(self:GetWeaponClass())
                weapon.nodupe = true
                weapon:SetModel(self:GetWeaponsModel())
                if self:GetWeaponClass() == "weapon_healthvial" then
                    weapon.clip1 = 2
                    function weapon:GivePlayerAmmo(ply, weapon, playerHadWeapon)
                        local primaryAmmoType = weapon:GetPrimaryAmmoType()
                        local secondaryAmmoType = weapon:GetSecondaryAmmoType()
                        local clip1 = self.clip1

                        if playerHadWeapon then
                            if clip1 and clip1 ~= -1 and weapon:Clip1() ~= -1 then
                                weapon:SetClip1(weapon:Clip1() + clip1)
                                clip1 = 0
                            end
                        end

                        if primaryAmmoType > 0 then
                            local primAmmo = ply:GetAmmoCount(primaryAmmoType)
                            primAmmo = primAmmo + (self.ammoadd or 0) + (clip1 or 0) -- Gets rid of any ammo given during weapon pickup
                            ply:SetAmmo(primAmmo, primaryAmmoType)
                        end

                        if secondaryAmmoType > 0 then
                            local secAmmo = ply:GetAmmoCount(secondaryAmmoType) + (clip2 or 0)
                            ply:SetAmmo(secAmmo, secondaryAmmoType)
                        end
                    end
                end
                weapon:Spawn()
                if self.Crafter and self.Crafter:IsValid() and self.Crafter:IsPlayer() then
                    self.Crafter:notify("Your " .. iteminfo.weaponname .. " is done crafting!")
                end

                self:SetWeaponClass("")
                self:SetWeaponTime(0)
                self:SetWeaponsModel("")
                self:SetDoneCrafting(true)
                self:SetWeaponItemIndex(0)
            end
        end
    end

    self:SetProgress(self:GetProgress() + (1 * self:GetTableTier()))
    self:NextThink(CurTime() + 1)

    return true
end

concommand.Add("rg_maxtable", function(ply)
    if (ply.nextcraftingtier or 0) > CurTime() then return end
    ply.nextcraftingtier = CurTime() + 2
    if not ply:IsSuperAdmin() then return end
    local craftingtable = ply:GetEyeTrace().Entity
    if not craftingtable or craftingtable:GetClass() ~= "rg_weaponcraftingtable" then return end
    craftingtable:SetTableTier(10)
end)