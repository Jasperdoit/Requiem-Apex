AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent. 
include('shared.lua')
 

function ENT:Initialize()
 
	self:SetModel( "models/bioshockinfinite/jin_bottle.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType(SOLID_VPHYSICS)   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:SetUseType( SIMPLE_USE )
	--self:SetMaterial( "sprops/trans/misc/ls_m1" )
        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use(ply)    
    -- local destroyValue = 850
    -- if ply:Team() == TEAM_OVERWATCH then
    --     for k, v in pairs(player.GetAll()) do
    --         if v:Team() == TEAM_OVERWATCH then
    --             if v == ply then
    --                 v:notify("You've been rewarded with "..destroyValue.." tokens for destroying contraband.")
    --                 v:AddMoney(destroyValue)
    --             else
    --                 local smallV = math.Round(75)
    --                 v:notify("You've been rewarded with "..smallV.." for a destroyed contraband.")
    --                 v:AddMoney(smallV)
    --             end
    --         end
    --     end
    --     self:Remove()
    --     return
    -- end
    
	ply:addDrunkLevel(15)
	timer.Simple(90, function() if IsValid(ply) then ply:addDrunkLevel(-15) end end)
	self:Remove();

end