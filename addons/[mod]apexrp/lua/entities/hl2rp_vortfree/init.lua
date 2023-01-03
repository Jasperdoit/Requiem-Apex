AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	self:SetModel("models/props_c17/tools_wrench01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()

	if phys:IsValid() then

		phys:Wake()
	end
end


function ENT:Use( activator, ply)
	if ply:IsPlayer() then
		if ply:Team() == TEAM_VORTIGAUNT and ply.isfreed == nil then
			self:Remove()
			ply:SetModel("models/vortigaunt.mdl")
			ply:Give("swep_vortigaunt_beam")
			ply:notify("You have been freed from your chains!")
			ply.isfreed = true
			ply:SetNWBool("IsRebelScum", true)
		elseif (ply:Team() == TEAM_CP) and (ply:GetNWBool("IsRogue")) and not (ply.isfreed) then 
        	hook.GetTable()["DoPlayerDeath"]["[module] passive death sounds"](ply);
            
            self:Remove()
            ply:SetModel("models/dpfilms/metropolice/resistance_police.mdl");
            ply:notify("You have removed your biosignal!");
            ply:SetNWBool("noBiosignal", true);
            ply.isfreed = true;
            
            local pos = ply:GetPos();
            local strings = {
                name = ply:Name(),
                steamid = ply:SteamID()
            };

            net.Start("deathmarker");
                net.WriteVector(pos)
                net.WriteString(util.TableToJSON(strings));
            net.Broadcast(); 
        else
			ply:PickupObject(self)
		end
	end
end

hook.Add("PlayerSpawn", "Resetisfreed", function(ply)
ply.isfreed = nil
   if (ply:GetNWBool("noBiosignal")) then ply:SetNWBool("noBiosignal", false); end
end)
