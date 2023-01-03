ENT.Base = "base_ai" -- This entity is based on "base_ai"
ENT.Type = "ai" -- What type of entity is it, in this case, it's an AI.
ENT.PrintName		= "Minister NPC"
ENT.Author			= "/"
ENT.Contact			= "/"
ENT.Purpose			= "/"
ENT.Instructions	= "/"
ENT.Category 		= "Universal Union"

ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.AutomaticFrameAdvance = true -- This entity will animate itself.

function ENT:SetAutomaticFrameAdvance( bUsingAnim ) 

    self.AutomaticFrameAdvance = bUsingAnim
    
end

/*
    RANKS 
*/

MinisterRanks = {}

MinisterRanks[1] = 

{

    NAME = "Minister of Defense",
    MODEL = "models/taggart/gallahan.mdl",
    XP = 1000,                                                     
    DESC = "The minister of defense is tasked with keeping the city safe from anti-citizens and hostile entities"
   


}

MinisterRanks[2] = 

{

    NAME = "Minister of Research",
    MODEL = "models/taggart/gallahan.mdl",
    XP = 1200,
    DESC = "The minister of research is tasked with producing powerful weaponary and powerful boosts which will further boost the Combine's abilities"

}

MinisterRanks[3] = 

{

    NAME = "Minister of Propaganda",
    MODEL = "models/taggart/gallahan.mdl",
    XP = 1350,
    DESC = "The minister of propaganda is tasked with making sure that civillians stay on the side of the combine and do not side with  anti-citizens. This may involve going into public with a sentinel to greet the civillians or making a heavily censored broadcast which only speaks good about the combine."

}

MinisterRanks[4] = 

{

    NAME = "Minister of Finance and Economy",
    MODEL = "models/taggart/gallahan.mdl",
    XP = 3500,
    DESC = "The minister of economy is tasked with keeping the economy in check and taxing civillians so that they cannot reach a point of power with their tokens. They may riot if taxes are set too high"

}

MinisterRanks[5] = 

{

    NAME = "Chancellor",
    MODEL = "models/taggart/gallahan.mdl",
    XP = 1500,
    DESC = "The chancellor is tasked with controlling all of the ministers and making sure that they do not violate their duties or do anything against the SeC and OWC's will."

}
