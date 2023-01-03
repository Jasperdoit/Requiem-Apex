ENT.Base = "base_ai" -- This entity is based on "base_ai"
ENT.Type = "anim" -- What type of entity is it, in this case, it's an AI.
ENT.PrintName		= "Jail Monitor"
ENT.Author			= "Jasperdoit"
ENT.Contact			= "N/A"
ENT.Purpose			= "Watch the scum's sentences!"
ENT.Instructions	= "Press E"
ENT.Category 		= "Universal Union"

ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.AutomaticFrameAdvance = true -- This entity will animate itself.

function ENT:Initialize( )

end

-- Since this file is ran by both the client and the server, both will share this information.