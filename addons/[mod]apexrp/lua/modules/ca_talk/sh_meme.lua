if (SERVER) then 
	local function MayorBroadcast(ply, args)
		if args == "" then
			ply:notify(DarkRP.getPhrase("invalid_x", "argument", ""))

			return ""
		end

		local pos = ply:GetPos()
		local stationtbl

		if GAMEMODE.Config.BroadcastTbl then
			stationtbl = GAMEMODE.Config.BroadcastTbl
		else
			stationtbl = {}
		end

		local inRange = false

		for k, v in pairs(stationtbl) do
			if pos:DistToSqr(v) <= 100 * 100 then
				inRange = true
			end
		end

		local station = GAMEMODE.Config.Broadcast

		if not GetGlobalBool("broadcastEnabled", true) then
			ply:notify("The broadcast stations have been disabled by the propaganda minister")

			return ""
		end

		if pos:DistToSqr(station) > 100 * 100 and inRange == false then
			ply:notify("You have to infront of the broadcast station.")

			return ""
		end
		
		local text = args;
		
		if not text or text == "" then
			ply:notify(DarkRP.getPhrase("invalid_x", "argument", ""))

			return
		end

		for k, v in pairs(player.GetAll()) do
			local col = Color(150, 20, 20, 255)
			DarkRP.talkToPerson(v, col, "[Broadcast] " .. ply:Nick(), Color(170, 0, 0, 255), text, ply)
		end
		
		return ""
	end

	DarkRP.defineChatCommand("broadcast", MayorBroadcast, 1.5);
	DarkRP.declareChatCommand{
		command = "broadcast",
		description = "Mayor broadcast.",
		delay = 1.5
	};

	--Broadcast voice code!
	concommand.Add("br_alltalk", function(ply, cmd, args, argStr)
		local num = tonumber(args[1])
		if not num then return end

		if num == 0 then
			ply.NoListen = true
			ply:notify("Disabled broadcast microphone (FOR CLIENT)")
		else
			ply.NoListen = false
			ply:notify("Enabled broadcast microphone (FOR CLIENT)")
		end
	end)

	concommand.Add("br_svalltalk", function(ply, cmd, args, argStr)
		local num = tonumber(args[1])
		if not num and not ply:IsAdmin() then return end

		if num == 0 then
			SetGlobalInt("br_svalltalk", 0)
			ply:notify("Disabled broadcast microphone")
		else
			SetGlobalInt("br_svalltalk", 1)
			ply:notify("Enabled broadcast microphone")
		end
	end)

	local function brAllTalk(listener, talker)
		local pos = talker:GetPos()
		local stationtbl

		if GAMEMODE.Config.BroadcastTbl then
			stationtbl = GAMEMODE.Config.BroadcastTbl
		else
			stationtbl = {}
		end

		local inRange = false

		for k, v in pairs(stationtbl) do
			if v:DistToSqr(talker:GetPos()) < 100 * 100 then
				inRange = true
			end
		end

		local station = GAMEMODE.Config.Broadcast

		if (inRange == true or pos:DistToSqr(station) < 100 * 100) and talker:GetMoveType() ~= MOVETYPE_NOCLIP and not listener.NoListen and GetGlobalInt("br_svalltalk", 1) == 1 then
			if GetGlobalBool("broadcastEnabled", true) then return true, false end
		end
	end

	hook.Add("PlayerCanHearPlayersVoice", "brAllTalk", brAllTalk)
else 
	DarkRP.declareChatCommand{
		command = "broadcast",
		description = "Mayor broadcast.",
		delay = 1.5
	};
end 