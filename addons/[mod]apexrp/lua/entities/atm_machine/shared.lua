ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "ATM"
ENT.Spawnable = true
ENT.Category = "Universal Union"

ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminOnly = true

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end