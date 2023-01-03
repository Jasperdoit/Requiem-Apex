AddCSLuaFile("cl_init.lua") -- This means the client will download these files
AddCSLuaFile("shared.lua")
include('shared.lua') -- At this point the contents of shared.lua are ran on the server 
--This function is run when the entity is created so it's a good place to setup our entity.

function ENT:Initialize()
    self:SetModel("models/dpfilms/metropolice/police_bt.mdl") -- Sets the model of the NPC.
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

function ENT:Use( ply )
    if not (ply:isCombine()) then return; end
    
	ply:ConCommand("divisions_open");
end 

function ENT:OnTakeDamage()
    -- This NPC won't take damage from anything.
    return false
end