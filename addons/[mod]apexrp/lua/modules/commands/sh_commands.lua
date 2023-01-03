-- Combine radio

DarkRP.declareChatCommand{
    command = "radio",
    description = "Send message to other combine players",
    delay = 1.5
};

DarkRP.declareChatCommand{
    command = "r",
    description = "Send message to other combine players",
    delay = 1.5
};

-- OOC
 
DarkRP.declareChatCommand{
    command = "ooc",
    description = "Out of character chat.",
    delay = 1.5
}

DarkRP.declareChatCommand{
    command = "a",
    description = "Out of character chat.",
    delay = 1.5
};

DarkRP.declareChatCommand{
    command = "/",
    description = "Out of character chat.",
    delay = 1.5
};

-- LOOC

DarkRP.declareChatCommand{
    command = "looc",
    description = "Local out of character chat.",
    delay = 1.5
};

-- Me 


DarkRP.declareChatCommand{
    command = "me",
    description = "Me.",
    delay = 1.5
};

-- Roll

DarkRP.declareChatCommand{
    command = "roll",
    description = "Rolls a random number from 1 to 100",
    delay = 1.5,
};

-- Yell

DarkRP.declareChatCommand{
    command = "yell",
    description = "Yell",
    delay = 1.5,
};

DarkRP.declareChatCommand{
    command = "y",
    description = "Yell",
    delay = 1.5,
};

-- It

DarkRP.declareChatCommand{
    command = "it",
    description = "Used to describe something",
    delay = 1.5,
};

-- Door kick

DarkRP.declareChatCommand{
    command = "doorkick",
    description = "Used to kick doors open",
    delay = 1.5,
};

DarkRP.declareChatCommand{
    command = "kickdoor",
    description = "Used to kick doors open",
    delay = 1.5,
};

-- Search

DarkRP.declareChatCommand{
    command = "search",
    description = "Used to search players as a CP",
    delay = 1.5,
};

-- Admin chat 

DarkRP.declareChatCommand{
    command = "adminchat",
    description = "Used by admins",
    delay = 1.5,
};

DarkRP.declareChatCommand{
    command = "ac",
    description = "Used by admins",
    delay = 1.5,
};

-- Vort call.

DarkRP.declareChatCommand{
	command = "vortcall",
	description = "Used by vortigaunts to call his kin",
	delay = 1.5,
};

-- Advert 

timer.Simple(1, function()
	DarkRP.chatCommands["advert"] = nil;

	DarkRP.declareChatCommand{
		command = "advert",
		description = "Advertise shit",
		delay = 1.5,
	};

	DarkRP.declareChatCommand{
		command = "announce",
		description = "Advertise shit",
		delay = 1.5,
	};
end );

-- Dispatch 

DarkRP.declareChatCommand{
	command = "dispatch",
	description = "Dispatch chat message",
	delay = 1.5,
};

DarkRP.declareChatCommand{
	command = "dradio",
	description = "Dispatch directives",
	delay = 1.5,
};

-- Apply 

DarkRP.declareChatCommand{
	command = "apply",
	description = "Show your id.",
	delay = 1.5,
};

-- Whisper

DarkRP.declareChatCommand{
	command = "w",
	description = "Whispers.",
	delay = 1.5,
};
DarkRP.declareChatCommand{
	command = "whisper",
	description = "Whispers.",
	delay = 1.5,
};