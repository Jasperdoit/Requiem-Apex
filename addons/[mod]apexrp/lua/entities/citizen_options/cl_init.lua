include('shared.lua') -- At this point the contents of shared.lua are ran on the client only.
-- error("cry about it")
function ENT:Draw()
    self:DrawModel()

    if LocalPlayer():GetEyeTrace().Entity == self and EyePos():Distance(self:GetPos()) < 512 then
        hook.Add("PreDrawHalos", "Halo", function()
            if LocalPlayer():Team() == TEAM_CITIZEN or LocalPlayer():Team() == TEAM_CWU then
                halo.Add({self}, Color(0, 0, 255), 0, 0, 0)
            end
        end)
    end
end

---------------------------------------------------------------------------
	-- Callbacks (ABSOLUTE ABOMINATION - WARNING: HARDCODED!)	
---------------------------------------------------------------------------

local function open()
	local ply = LocalPlayer();
	local main = vgui.Create( "DPanel" );
	main:SetSize( ScrW() * .4, ScrH() * .4 );
	main:Center();
	main:MakePopup();

	main.OnKeyCodePressed = function( self, keyCode )
		if ( keyCode == KEY_E ) then 
			self:Remove();
		end 
	end 

	main.Paint = function( self, w, h )
		surface.SetDrawColor( 0, 0, 0 )
		surface.DrawOutlinedRect( 0, 0, w, h );

		surface.SetDrawColor( 32, 32, 32, 200);
		surface.DrawRect( 1, 1, w - 2, h - 2 );
	end 

	local jobList = main:Add( "DScrollPanel" );
	jobList:Dock( LEFT );
	jobList:DockMargin( 5, 5, 0, 5 );
	jobList:SetWide( main:GetWide() - 10 );

	jobList.Paint = function( self, w, h )
		surface.SetDrawColor( 255, 255, 255, 150 )
		surface.DrawOutlinedRect( 0, 0, w, h);

		surface.SetDrawColor( 32, 32, 32, 0 );
		surface.DrawRect( 1, 1, w - 2, h - 2 );
	end 

	local scroll = jobList:GetVBar();

	scroll.btnUp.Paint = function( self, w, h )
		surface.SetDrawColor( 0, 50, 0 );
		surface.DrawOutlinedRect( 0, 0, w, h );

		surface.SetDrawColor( 32, 32, 32, 0 );
		surface.DrawRect( 1, 1, w - 2, h - 2 );
	end 

	scroll.btnDown.Paint = function( self, w, h )
		surface.SetDrawColor( 0, 50, 0 );
		surface.DrawOutlinedRect( 0, 0, w, h );

		surface.SetDrawColor( 32, 32, 32, 0 );
		surface.DrawRect( 1, 1, w - 2, h - 2 );
	end 

	scroll.btnGrip.Paint = function( self, w, h )
		surface.SetDrawColor( 0, 50, 0 );
		surface.DrawOutlinedRect( 0, 0, w, h );

		surface.SetDrawColor( 32, 32, 32, 0 );
		surface.DrawRect( 1, 1, w - 2, h - 2 );
	end

	local label1 = jobList:Add( "DLabel" );
	label1:Dock( TOP );
	label1:DockMargin( 2, 2, 2, 0 );
	label1:SetTall( 28 );
	label1:SetText( "Available citizen options" );
	label1:SetFont( "RobotoMono32" );
	label1:SetTextColor( Color( 255, 255, 255 ) );
	label1:SetContentAlignment( 5 );

	-- cancer

	if (ply:Team() == TEAM_CITIZEN) then 
		local opt1 = jobList:Add("DButton")
		opt1:Dock( TOP );
		opt1:DockMargin( 5, 5, 5, 0 );
		opt1:SetTall( 48 );
		opt1:SetText( "Go Normal Citizen - 0 XP Requirement");
		opt1:SetTextColor( Color( 255, 255, 255 ) );

		opt1.Paint = function( self, w, h )
			local col = Color( 255, 255, 255, 150 );
				
			surface.SetDrawColor( col )
			surface.DrawOutlinedRect( 0, 0, w, h );
			surface.SetDrawColor( 32, 32, 32, 0 );
			surface.DrawRect( 1, 1, w - 2, h - 2 );
		end 

		opt1.DoClick = function( self )
			ply:ConCommand("rp_citopt " .. 1);
		end 
		
		local opt2 = jobList:Add("DButton")
		opt2:Dock( TOP );
		opt2:DockMargin( 5, 5, 5, 0 );
		opt2:SetTall( 48 );
		opt2:SetText("Go BMD - 150 XP Requirement");
		opt2:SetTextColor( Color( 255, 255, 255 ) );

		opt2.Paint = function( self, w, h )
			local col = Color( 255, 255, 255, 150 );
				
			surface.SetDrawColor( col )
			surface.DrawOutlinedRect( 0, 0, w, h );
			surface.SetDrawColor( 32, 32, 32, 0 );
			surface.DrawRect( 1, 1, w - 2, h - 2 );
		end 

		opt2.DoClick = function( self )
			ply:ConCommand("rp_citopt " .. 3);
		end
	end
	
	if (ply:Team() == TEAM_CWU) then 
		local opt1 = jobList:Add("DButton")
		opt1:Dock( TOP );
		opt1:DockMargin( 5, 5, 5, 0 );
		opt1:SetTall( 48 );
		opt1:SetText("Go Standard Worker - 0 XP Requirement");
		opt1:SetTextColor( Color( 255, 255, 255 ) );

		opt1.Paint = function( self, w, h )
			local col = Color( 255, 255, 255, 150 );
				
			surface.SetDrawColor( col )
			surface.DrawOutlinedRect( 0, 0, w, h );
			surface.SetDrawColor( 32, 32, 32, 0 );
			surface.DrawRect( 1, 1, w - 2, h - 2 );
		end 

		opt1.DoClick = function( self )
			ply:ConCommand("rp_citopt " .. 5);
		end 
		
		local opt2 = jobList:Add("DButton")
		opt2:Dock( TOP );
		opt2:DockMargin( 5, 5, 5, 0 );
		opt2:SetTall( 48 );
		opt2:SetText("Go Cook - 10 XP Requirement");
		opt2:SetTextColor( Color( 255, 255, 255 ) );

		opt2.Paint = function( self, w, h )
			local col = Color( 255, 255, 255, 150 );
				
			surface.SetDrawColor( col )
			surface.DrawOutlinedRect( 0, 0, w, h );
			surface.SetDrawColor( 32, 32, 32, 0 );
			surface.DrawRect( 1, 1, w - 2, h - 2 );
		end 

		opt2.DoClick = function( self )
			ply:ConCommand("rp_citopt " .. 2);
		end
		
		local opt3 = jobList:Add("DButton")
		opt3:Dock( TOP );
		opt3:DockMargin( 5, 5, 5, 0 );
		opt3:SetTall( 48 );
		opt3:SetText("Go Medic - 35 XP Requirement");
		opt3:SetTextColor( Color( 255, 255, 255 ) );

		opt3.Paint = function( self, w, h )
			local col = Color( 255, 255, 255, 150 );
				
			surface.SetDrawColor( col )
			surface.DrawOutlinedRect( 0, 0, w, h );
			surface.SetDrawColor( 32, 32, 32, 0 );
			surface.DrawRect( 1, 1, w - 2, h - 2 );
		end 

		opt3.DoClick = function( self )
			ply:ConCommand("rp_citopt " .. 4);
		end
		
		local opt4 = jobList:Add("DButton")
		opt4:Dock( TOP );
		opt4:DockMargin( 5, 5, 5, 0 );
		opt4:SetTall( 48 );
		opt4:SetText("Go Scientist - 100 XP Requirement");
		opt4:SetTextColor( Color( 255, 255, 255 ) );

		opt4.Paint = function( self, w, h )
			local col = Color( 255, 255, 255, 150 );
				
			surface.SetDrawColor( col )
			surface.DrawOutlinedRect( 0, 0, w, h );
			surface.SetDrawColor( 32, 32, 32, 0 );
			surface.DrawRect( 1, 1, w - 2, h - 2 );
		end 

		opt4.DoClick = function( self )
			ply:ConCommand("rp_citopt " .. 6);
		end
	end 
end


net.Receive( "openCitOpts", open );