AddCSLuaFile("shared.lua")
include('shared.lua') -- At this point the contents of shared.lua are ran on the server only.

local AlcoholNPC_pos = {
    -- City 17 B210 (DO NOT DELETE WHEN UNUSED, COMMENT IT INSTEAD) --     {Vector(-3651.968750, -2800.431885, 144.031250); Angle(1.056000, -1.745974, 0.000000), 1},      -- [Sector 2] Wall section --     {Vector(2256.031250, -4608.216309, 144.031250); Angle(0.197994, -1.151868, 0.000000), 1.1},      -- [Sector 4] Near factory building --     {Vector(2688.031250, -378.713867, -401.968750), Angle(0.131972, -0.557847, 0.000000), 0.95},   -- [404 Zone] Below Sector 4 --     {Vector(727.623047, 6508.974121, -401.968750), Angle(1.451972, -90.713669, 0.000000), 0.9},   -- [404 Zone] Sewers --     {Vector(-1650.285645, 3716.009521, 144.031250), Angle(2.573972, 89.040329, 0.000000), 1.2},   -- [Sector 3] Near Vent --     {Vector(-1650.285645, 3716.009521, 144.031250), Angle(2.573972, 89.040329, 0.000000), 1.2},   -- [Sector 3] Near Vent
    -- Industrial 17 Apex
    -- {Vector(3326.049072, 2671.968750, 64.031250), Angle(0.660069, -90.102310, 0.000000), 0.9}, -- [404 Zone] Below Sector 2
    -- {Vector(2896.716064, -16.031250, -103.968750), Angle(1.320070, -92.376640, 0.000000), 0.85}, -- [404 Zone] Near Base
    -- {Vector(6379.773926, 2370.789795, 288.031250), Angle(2.574092, 90.875351, 0.000000), 1.1}, -- [Slums] Near BBal court
    -- {Vector(3088.031250, 1327.005127, 200.031250), Angle(0.924092, -0.042693, 0.000000), 1.35}, -- [Sector 2] Near Theater
    -- {Vector(4218.007813, 7952.031250, 384.031250), Angle(-1.121963, 88.919342, 0.000000), 0.8}, -- [404 Zone] Beach
    -- {Vector(2650.243164, 2122.587402, 1136.031250), Angle(2.904052, 104.363335, 0.000000), 1}, -- [Sector 2] Above train
    -- C34
    {Vector(-1086.249146, -16.031250, -439.968750), Angle(1.683061, -88.558449, 0.000000), 1}, -- [404 Zone] Below Sector 2
    {Vector(3674.203369, -56.031250, -455.968750), Angle(3.465053, -91.264557, 0.000000), 1}, -- [404 Zone] Below Sector 2
    {Vector(-9269.008789, -8420.376953, -764.968750), Angle(-0.155977, -179.674026, 0.000000), .8}, -- [404 Zone] Below Sector 2
    {Vector(142.557648, -9209.369141, -477.601624), Angle(1.634820, -152.860443, 0.000000), .8}, -- [404 Zone] Below Sector 2

    
}

-- local AlcoholNPC_names = {"[Sector 2] Wall section", "[Sector 4] Near factory building", "[404 Zone] Below Sector 4", "[404 Zone] Sewers", "[Sector 3] Near Vent"} City 17 B210
local AlcoholNPC_names = {"[404 Zone] Spawn 1", "[404 Zone] Spawn 2", "[Outlands] Spawn 1", "[Outlands] Spawn 2"}

--This function is run when the entity is created so it's a good place to setup our entity.
function ENT:Initialize()
    local mdl_n = math.random(1, 6)
    self:SetModel("models/Humans/Group02/Male_0" .. mdl_n .. ".mdl") -- Sets the model of the NPC.
    self:SetHullType(HULL_HUMAN) -- Sets the hull type, used for movement calculations amongst other things.
    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:SetSolid(SOLID_BBOX) -- This entity uses a solid bounding box for collisions.
    self:CapabilitiesAdd(CAP_ANIMATEDFACE, CAP_TURN_HEAD) -- Adds what the NPC is allowed to do ( It cannot move in this case ).
    self:SetUseType(SIMPLE_USE) -- Makes the ENT.Use hook only get called once at every use.
    self:DropToFloor()
    self:SetPersistent(false)
    self:SetMaxYawSpeed(90) --Sets the angle by which an NPC can rotate at once.
    self:SetPlaybackRate(1.0)
    self:SetMaxYawSpeed(90)
    self.SellMood = math.random(9, 14)
    self:SetMaxYawSpeed(90) --Sets the angle by which an NPC can rotate at once.
    self.priceMult = 0.8
    self.amountsold = 0

    timer.Create("replace_booze_npc", 600, 0, function()
        if IsValid(self) then
            if not mapconfigs or not mapconfigs[game.GetMap()] or not mapconfigs[game.GetMap()].BrewingNPCPositions then return print("WARNING: NO MAPCONFIG PRESENT FOR THE BREWINGNPC!!!") end
            local matC = math.random(1, #mapconfigs[game.GetMap()].BrewingNPCPositions)
            local newPosD = mapconfigs[game.GetMap()].BrewingNPCPositions[matC]
            self:SetPos(newPosD[1])
            self:SetAngles(newPosD[2])
            self.SellMood = math.random(9, 14)
            self:DropToFloor()
            self.SellMult = newPosD[3]
            self.amountsold = 0

            for k, v in pairs(player.GetAll()) do
                if v:IsAdmin() then
                    v:ChatPrint(">> Trade NPC moved to " .. newPosD[4] .. "!")
                else
                    v:ChatPrint(">> Trade NPC moved!")
                end
            end

            print(" >> >> >> >> Trade NPC moved to " .. newPosD[4] .. "!")
        end
    end)
end

function ENT:OnTakeDamage()
    return false
end

function ENT:AcceptInput(Name, Activator, Caller)
    if Caller:Team() == TEAM_OVERWATCH or Caller:Team() == TEAM_CP or Caller:Team() == TEAM_CONSCRIPT then
        if Caller.CanInteract_npc then
            if CurTime() < Caller.CanInteract_npc then return end
        end

        self:EmitSound("vo/npc/male01/combine0" .. math.random(1, 2) .. ".wav")
        Caller.CanInteract_npc = CurTime() + 10
        Caller:notify("Combine!")

        return
    end

    local foundBooze = {}
    if not (IsValid(Caller)) or not (Caller:GetPos():DistToSqr(self:GetPos()) <= 250 * 250) then return end
    --if Caller.CanInteract_npc then
    --if CurTime() < Caller.CanInteract_npc then 
    --Caller:notify( "If you keep coming back like this, they'll find us!")
    --return 
    --end
    --end
    local SeekingEntity = "hl2rp_alcohol" -- EDIT THESE IF YOU WANT TO CHANGE HOW THIS GUY WORKS
    local SeekingEntity2 = "hl2rp_gin" -- EDIT THESE IF YOU WANT TO CHANGE HOW THIS GUY WORKS
    local SeekingEntity3 = "scrap"
    local SeekingRange = 175
    foundBooze[SeekingEntity] = 0
    foundBooze[SeekingEntity2] = 0
    foundBooze[SeekingEntity3] = 0
    local tooMuch = false
    local maxAlc = 15
    local maxGin = 6
    local maxScrap = 100

    for _, nearbyEnt in pairs(ents.FindInSphere(self:GetPos(), SeekingRange)) do
        local clsn = nearbyEnt:GetClass()
        local price_multiplier = 1
        if clsn == "player" and nearbyEnt:Alive() then
            if nearbyEnt:GetTable().Pocket and nearbyEnt:GetTable().Pocket ~= {} then
                for pockID, pockEnt in pairs(nearbyEnt:GetTable().Pocket) do
                    if not pockEnt:IsValid() then continue end

                    -- if not tooMuch then
                    if pockEnt:GetClass() == "hl2rp_alcohol" or pockEnt:GetClass() == "hl2rp_gin" then
                        local reward_booze = math.Round(24 * self.SellMood * price_multiplier)
                        if pockEnt:GetClass() == "hl2rp_gin" then
                            reward_booze = math.Round(math.Clamp(29 * self.SellMood * price_multiplier - (250 * self.amountsold), 700, 5000))
                        end
                        nearbyEnt[pockID] = nil
                        pockEnt:Remove()
                        Caller:addMoney(reward_booze)
                        Caller:notify("Alright, deal! Here's your " .. reward_booze .. " tokens. Now move on.")
                        self.amountsold = self.amountsold + 1
                    end
                    -- end
                end
            end
        end

        if clsn == "hl2rp_alcohol" or clsn == "hl2rp_gin" then
            if not nearbyEnt.IsPocketed and not nearbyEnt.IsPocketed == true then
                local reward_booze = math.Round(24 * self.SellMood * price_multiplier)
                if nearbyEnt:GetClass() == "hl2rp_gin" then
                    reward_booze = math.Round(math.Clamp(reward_booze * 12 - (800 * self.amountsold), 1500, 5000))
                end
                Caller:addMoney(reward_booze)
                Caller:notify("Alright, deal! Here's your " .. reward_booze .. " tokens. Now move on.")
                nearbyEnt:Remove()
                self.amountsold = self.amountsold + 1
            end
        end
    end
end