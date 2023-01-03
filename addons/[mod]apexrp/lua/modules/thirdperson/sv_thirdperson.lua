local function thirdperson(ply, args)
	ply:ConCommand("rg_thirdperson 1");	
		
	return ""
end 

DarkRP.defineChatCommand("thirdperson", thirdperson, 1.5);
DarkRP.declareChatCommand{
	command = "thirdperson",
    description = "Enables thirdperson",
    delay = 1.5
};

local function firstperson(ply, args)
	ply:ConCommand("rg_thirdperson 0");	
		
	return ""
end 

DarkRP.defineChatCommand("firstperson", firstperson, 1.5);
DarkRP.declareChatCommand{
	command = "firstperson",
    description = "Disables thirdperson",
    delay = 1.5
};