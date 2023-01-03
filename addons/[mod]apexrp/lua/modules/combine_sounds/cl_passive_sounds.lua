-- Chat beeps for radio.

local function textChanged( text )
	local ply = LocalPlayer();

	if ( ply:isCombine() ) then 
		if not ( ply.alreadyBeeped ) then 
			ply.alreadyBeeped = true; 
			
			net.Start( "combineChatBeep" );
			net.SendToServer();
		end 
	end 
end 

hook.Add( "ChatTextChanged", "hl2rp: chat text changed", textChanged );

local function onCloseChat()
	local ply = LocalPlayer();

	if ( ply.alreadyBeeped ) then 
		ply.alreadyBeeped = nil;

		net.Start( "combineChatBeep" );
		net.SendToServer(); 
	end 
end 

hook.Add( "FinishChat", "hl2rp: on closing chat", onCloseChat );

local function onOpenVC(ply)
	if ply != LocalPlayer() or (ply:Team() ~= TEAM_CP and ply:Team() ~= TEAM_OVERWATCH) then return end
	if ((ply.stopSpam1 or 0) >= CurTime()) then 
		if not (ply.stopSpam1) then 
			ply.stopSpam1 = CurTime() + 0.5;
		end 
		
		return; 
	end 

	ply.stopSpam1 = CurTime() + 0.5;
    
	net.Start("combineChatBeep");
    net.SendToServer()
end 

hook.Add("PlayerStartVoice", "hl2rp: on starting voice", onOpenVC);

local function onCloseVC(ply)
	if ply != LocalPlayer() or ply:Team() ~= TEAM_CP and ply:Team() ~= TEAM_OVERWATCH then return end
    if ((ply.stopSpam2 or 0) >= CurTime()) then 
		if not (ply.stopSpam2) then 
			ply.stopSpam2 = CurTime() + 0.5;
		end 
		
		return; 
	end 
	
	ply.stopSpam2 = CurTime() + 0.5;
	
	net.Start("combineChatBeep")
	net.SendToServer()
end 

hook.Add("PlayerEndVoice", "hl2rp: on closing voice", onCloseVC);