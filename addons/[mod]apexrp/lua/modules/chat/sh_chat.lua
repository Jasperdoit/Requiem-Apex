nutChat = nutChat or {
	name = "Chatbox",
	author = "Chessnut",
	desc = "Adds a chatbox that replaces the default one.",
	charLimit = 512,
};

if (CLIENT) then
	NUT_CVAR_CHATFILTER = CreateClientConVar("nut_chatfilter", "", true, false)

	function nutChat:createChat()
		if (IsValid(self.panel)) then
			return
		end

		self.panel = vgui.Create("nutChatBox")
	end

	hook.Add( "InitPostEntity", "[module] nutChat", function()
		nutChat:createChat();
	end );

	hook.Add( "PlayerBindPress", "[module] nutChat", function( client, bind, pressed )
		bind = bind:lower()

		if (bind:find("messagemode") and pressed) then
			if (!nutChat.panel.active) then
				nutChat.panel:setActive(true, bind:find("messagemode2"))
			end
			return true
		end
	end );

	hook.Add( "HUDShouldDraw", "[module] nutChat", function( element )
		if (element == "CHudChat") then
			return false
		end
	end );

	chat.nutAddText = chat.nutAddText or chat.AddText

	local nutChat = nutChat;

	function chat.AddText(...)
		local show = true

		if (IsValid(nutChat.panel)) then
			show = nutChat.panel:addText(...)
		end

		if (show) then
			chat.nutAddText(...)
			chat.PlaySound()
		end
	end

	hook.Add( "ChatText", "[module] nutChat", function(index, name, text, messageType)
		if (messageType == "none" and IsValid(nutChat.panel)) then
			nutChat.panel:addText(text)
			chat.PlaySound()
		end
	end );

	concommand.Add("fixchatplz", function()
		if (IsValid(nutChat.panel)) then
			nutChat.panel:Remove()
			nutChat:createChat()
		end
	end)
	
	net.Receive( "sendMessageCustom", function( len, ply )
		local size = net.ReadUInt(16)
		local tbl = net.ReadData(size);
		tbl = util.Decompress(tbl);
		tbl = util.JSONToTable(tbl);

		for k, v in pairs( tbl ) do 
			if ( type( v ) == "table" ) and ( v.font ) then 
				LocalPlayer().msgFont = v.font;
				tbl[k] = nil;

				break;
			end 
		end 

		chat.AddText( unpack( tbl ) );
	end );
else 
	util.AddNetworkString( "nutChatSendMsg" );
	util.AddNetworkString( "sendMessageCustom" );

	net.Receive( "nutChatSendMsg", function(len, client)
		if (client.nextapexchattime or 0) > CurTime() then return end
		client.nextapexchattime = CurTime() + 1
		
		local text = net.ReadString();
		local isteam = net.ReadBool()

		if ( #text > nutChat.charLimit or 200 ) then 
			text = text:sub( 1, nutChat.charLimit or 200 );
		end 

		if ( (client.nutNextChat or 0 ) < CurTime() and text:find("%S")) then
			hook.Run("PlayerSay", client, text, isteam )
				
			client.nutNextChat = CurTime() + math.max(#text / 250, 0.4)
		end
	end );
	
end 

local playerMeta = FindMetaTable("Player")
 
function playerMeta:sendMsg( ... )
	local tbl = { ... };

	if ( SERVER ) then 
		local compressed = util.TableToJSON(tbl);
		compressed = util.Compress(compressed);
	
		net.Start( "sendMessageCustom" );
			net.WriteUInt( #compressed, 16 );
			net.WriteData( compressed ); 
		net.Send( self );
	else 
		for k, v in pairs( tbl ) do 
			if ( type( v ) == "table" ) and ( v.font ) then 
				LocalPlayer().msgFont = v.font;
				tbl[k] = nil;

				break;
			end 
		end 

		chat.AddText( unpack( tbl ) );
	end
end 