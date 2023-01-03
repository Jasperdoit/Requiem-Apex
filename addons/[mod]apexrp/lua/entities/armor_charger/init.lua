AddCSLuaFile("cl_init.lua") -- This means the client will download these files
AddCSLuaFile("shared.lua")
include('shared.lua') -- At this point the contents of shared.lua are ran on the server only.

--This function is run when the entity is created so it's a good place to setup our entity.
function ENT:Initialize()
    self:SetModel("models/props_combine/suit_charger001.mdl") -- Sets the model of the NPC.
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
end

function ENT:OnTakeDamage()
    return false
end

function ENT:Use(name, ply, caller)
    if (divisions) and (ply:getDivision() > 0) then 
        
        ply:SetArmor(ply:GetMaxArmor());
        ply:notify("You armor has been restocked.");
    end 
    
    --[[if Activator:Team() == TEAM_OVERWATCH then
        if Activator:GetModel() == "models/combine_super_soldier.mdl" then
            Activator:SetArmor(150)
            Activator:notify("Your armor has been restocked because you are an Overwatch unit.")
        elseif Activator:GetModel() == "models/dpfilms/metropolice/rtb_police.mdl" then
            Activator:SetArmor(150)
            Activator:notify("Your armor has been restocked because you are an Overwatch unit.")
        elseif Activator:GetModel() == "models/Combine_Soldier.mdl" then
            Activator:SetArmor(100)
            Activator:notify("Your armor has been restocked because you are an Overwatch unit.")
        elseif Activator:GetModel() == "models/combine_heavy.mdl" then
            Activator:SetArmor(150)
            Activator:notify("Your armor has been restocked because you are an Overwatch unit.")
        else
            Activator:SetArmor(100)
            Activator:notify("Your armor has been restocked because you are an Overwatch unit.")
        end
    end

    if Activator:Team() == TEAM_CP and CPMenuPlyTable[Activator:SteamID64()] then
        if CPMenuPlyTable[Activator:SteamID64()]["Division"] == 1 then
            Activator:SetArmor(55)
        else
            Activator:SetArmor(40)
        end

        Activator:notify("Your armor has been restocked because you are an Civil Protection unit.")
    end

    if Activator:Team() == TEAM_CONSCRIPT then
        Activator:SetArmor(30)
        Activator:notify("Your armor has been restocked because you are a Conscript unit.")
    end

    if Activator:Team() == TEAM_CREMATOR then
        Activator:SetArmor(300)
        Activator:notify("Your armor has been restocked because you are a Cremator.")
    end
    ]]
end