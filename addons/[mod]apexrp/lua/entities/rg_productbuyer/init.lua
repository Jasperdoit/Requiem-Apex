AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include("shared.lua")


function ENT:Initialize()
    self:SetModel("models/hl2rp/male_08.mdl") -- Sets the model of the NPC.
    self:SetBodygroup(1, 4)
    self:SetHullType(HULL_HUMAN) -- Sets the hull type, used for movement calculations amongst other things.
    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:SetSolid(SOLID_BBOX) -- This entity uses a solid bounding box for collisions.
    self:CapabilitiesAdd(CAP_ANIMATEDFACE, CAP_TURN_HEAD) -- Adds what the NPC is allowed to do ( It cannot move in this case ).
    self:SetUseType(SIMPLE_USE) -- Makes the ENT.Use hook only get called once at every use.
    self:DropToFloor()
    self:SetPersistent(false)
    self:SetMaxYawSpeed(90) --Sets the angle by which an NPC can rotate at once.
end

function ENT:AllowPlayerPickup(ply, ent)
	if not ply:IsAdmin() or ply:IsSuperAdmin() then return true
		else return false
	end
end

function ENT:AcceptInput( Name, Activator, Caller )
    if (Caller:Team() ~= TEAM_CITIZEN and Caller:Team() ~= TEAM_VORT) or Caller:GetNWBool("IsRebelscum", false) or not Caller:IsPlayer() then
        Caller:notify("You are not the right job to give this to me!")
        return
    end
    local productfound = false
    local hassaidnice = false
    for _, product in pairs(ents.FindInSphere(self:GetPos(), 120)) do

        if product:IsValid() and product:GetClass() == "rg_product" and not product.IsPocketed then
            if product.TableData and product.Classname and product.Amount then
                productfound = true
                local rewardmoney = math.Round(product.TableData.sellprice * (12 / math.Clamp(GetGlobalInt(product.Classname), 1, 50))) * product.Amount
                if math.Clamp(GetGlobalInt(product.Classname), 1, 50) >  30 then
                    rewardmoney = 5
                end
                Caller:AddMoney(rewardmoney)
                local cptable = {}
                local cpcount = 0
                for _, cp in pairs(ents.FindInSphere(self:GetPos(), 260)) do
                    if cp:IsValid() and cp:IsPlayer() and (cp:Team() == TEAM_CP or cp:Team() == TEAM_CONSCRIPT) and CurTime() < cp:GetNWInt("RGStockCPHelpTime", 0) then
                        table.insert(cptable, cp)
                        local cpcount = cpcount + 1
                    end 
                end
                if cpcount > 0 then
                    for _, twat in pairs(cptable) do
                        twat:AddMoney(math.Round(rewardmoney * 0.4 / cpcount))
                        twat:notify("You have been given T".. math.Round(rewardmoney * 0.4 / cpcount) .. " for helping with the delivery of ".. product.Classname .. "!")
                    end
                end
                SetGlobalInt(product.Classname, GetGlobalInt(product.Classname) + product.Amount)
                Caller:notify("Nice! I have added " .. product.Amount .. " " .. product.Classname .. " to the stock! Here is T" .. rewardmoney .. "!")
                product:Remove()
                if not hassaidnice then
                    self:EmitSound("vo/npc/male01/nice.wav")
                    hassaidnice = true
                end
            end
        end
    end
    if not productfound then
        Caller:notify("You must bring me a shipment from the factory if you want a pile o' dosh!")
    end
end
