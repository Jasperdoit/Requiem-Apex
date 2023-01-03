local deathcause;
local spawntime;
local block;

local grad = surface.GetTextureID("gui/gradient");
local blur = Material( "pp/blurscreen" );

local function drawDead()
	if not LocalPlayer():Alive() and spawntime then
		if not spawntime then spawntime = 30; end
		
		local scrW, scrH = ScrW(), ScrH();
		local width = ScrW() * 2;
		local height = ScrH() * 2;
		local add = 2
		local minimum = 160
		local Alpha = math.Clamp((Alpha or 255) + add, minimum, 255)
		local colour = Color( 16, 78, 139, Alpha)
		local PosX, PosY = 0, ScrH() * 0.30 

		surface.SetDrawColor( 255,0,0 )
		surface.DrawRect( PosX, PosY-2,  ScrW(), 2 )   

		surface.SetDrawColor( 0, 0, 0, 200 )
		surface.SetTexture(grad)
		surface.DrawRect( PosX, PosY, ScrW(), 150 )  

		surface.SetDrawColor( 255,0,0 )
		surface.DrawRect( PosX, PosY+150-2, ScrW(), 2 )  

		surface.SetDrawColor( 0, 0, 0, 200 )
		surface.DrawRect(0, 0, width, height )  

		draw.DrawText("YOU ARE DEAD!", "RobotoMono48", ScrW() / 2, ScrH() / 3, Color(255,255,255),TEXT_ALIGN_CENTER)
		--draw.DrawText("Please do not return to this area next 5 minutes, NLR applies.", "DermaDefault", ScrW() / 2, ScrH() / 3 + 35, Color(255,255,255),TEXT_ALIGN_CENTER)

		if spawntime == 0 then
			draw.DrawText("Press your spacebar or LMB or RMB to respawn!", "RobotoMono28", ScrW() / 2, ScrH() / 3 + 55, Color(255,255,255),TEXT_ALIGN_CENTER)
		else
			draw.DrawText("You are able to respawn in "..spawntime.." seconds", "RobotoMono28", ScrW() / 2, ScrH() / 3 + 55, Color(255,255,255),TEXT_ALIGN_CENTER)
		end
	end 
end 

hook.Add("HUDPaint", "hl2rp: draw dead", drawDead);

local function gay()
	spawntime = net.ReadInt(8);
    
    timer.Create("deathCountdown", 1, spawntime, function()
		spawntime = spawntime - 1  
	end );
end 	

net.Receive("deathTimer", gay);