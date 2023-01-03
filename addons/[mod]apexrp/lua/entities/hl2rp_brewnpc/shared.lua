ENT.Base = "base_ai" -- This entity is based on "base_ai"
ENT.Type = "ai" -- What type of entity is it, in this case, it's an AI.
ENT.AutomaticFrameAdvance = true -- This entity will animate itself.
 
function ENT:SetAutomaticFrameAdvance( bUsingAnim ) -- This is called by the game to tell the entity if it should animate itself.
	self.AutomaticFrameAdvance = bUsingAnim
end

ENT.PrintName		= "Brewing NPC"
ENT.Author			= "DesignFlaw for Reverie-Games"
ENT.Contact			= "N/A"
ENT.Purpose			= "Sell your booze"
ENT.Instructions	= "Press E"
ENT.Category 		= "Universal Union"

ENT.Spawnable = true
ENT.AdminOnly = true