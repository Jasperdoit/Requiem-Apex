scanner = {};

scanner.name = "Player Scanners Util"
scanner.author = "Chessnut"
scanner.desc = "Adds functions that allow players to control scanners."

DarkRP.declareChatCommand{
    command = "scanner",
    description = "Become a scanner as a grid",
    delay = 1.5
};

if (CLIENT) then
	scanner.PICTURE_WIDTH = 580
	scanner.PICTURE_HEIGHT = 420
else 
	local function makeScanner( ply, args )
		if (divisions and ply:getDivision() == DIVISION_GRID) or (ply:Team() == TEAM_DISPATCH) then 
			if ply.nutScn then
				local div = ply:getDivision();
                local rank = ply:getDivisionRank();
               	local sc = ply:getSC();
                
				ply.nutScn:ejectPilot()
                
                timer.Simple( .2, function()
                	divisions:setDivision(ply, div, rank);
                    divisions:setSC(ply, sc);
                end );
                
				return
			end
			scanner:createScanner(ply);
		else 
			ply:notify("Invalid team.");
		end 

		return "";
	end

	DarkRP.defineChatCommand( "scanner", makeScanner, 1.5 );

end 
