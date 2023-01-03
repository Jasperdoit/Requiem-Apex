include('shared.lua') -- At this point the contents of shared.lua are ran on the client only.

function ENT:Draw()
    self:DrawModel()  
	
    if LocalPlayer():GetEyeTrace().Entity == self and EyePos():Distance( self:GetPos() ) < 512 then       
        hook.Add("PreDrawHalos", "Halo", function()            
            if LocalPlayer():Team() == TEAM_ADMINISTRATOR then               
                halo.Add({ self }, Color(0, 0, 255), 0, 0, 0)           
			end
        end)
    end
end

-- Actual PANEL

local PANEL = {};
local ministerMenu;

function PANEL:Init()
	if ( IsValid( ministerMenu ) ) then 
		ministerMenu:Remove();
		self:Remove();

		return;
	end 

	local ply = LocalPlayer();
	
	ministerMenu = self;

	self:SetSize( ScrW() * .5, ScrH() * .5 );
	self:Center();
	self:MakePopup();
	self:SetTitle( "Minister Menu" );
	self:ShowCloseButton( false );


	self.divMenu = self:Add( "DScrollPanel" );
	self.divMenu:SetPos( 5, 55 ); 
	self.divMenu:SetSize( ScrW() * .12, ScrH() * .2 );

	local scroll = self.divMenu:GetVBar();

	function scroll.btnUp:Paint( w, h )
		surface.SetDrawColor(64, 0, 0);
		surface.DrawOutlinedRect( 0, 0, w, h );
	end 

	function scroll.btnDown:Paint( w, h )
		surface.SetDrawColor(64, 0, 0);
		surface.DrawOutlinedRect( 0, 0, w, h );
	end 

	function scroll.btnGrip:Paint( w, h )
		surface.SetDrawColor(64, 0, 0);
		surface.DrawOutlinedRect( 0, 0, w, h );
	end

	for id, div in pairs( MinisterRanks ) do  
		if (ply:Team() ~= TEAM_ADMINISTRATOR) then  continue; end 
	
		self.div = self.divMenu:Add( "DButton" );
		self.div:Dock( TOP );
		self.div:SetTall( 48 );
		self.div:SetText( div.NAME );
		self.div:SetTextColor( Color( 255, 255, 255 ) );
		self.div:DockMargin( 2, 2, 2, 2 );

		function self.div:Paint( w, h )
			surface.SetDrawColor( 32, 32, 32, 150 );
			surface.DrawRect( 0, 0, w, h );

			local col; 

			if ( self:GetDisabled() ) then 
				col = Color( 35, 35, 142 );
			else 
				col = Color(64, 0, 0);
			end 

			surface.SetDrawColor( col );
			surface.DrawOutlinedRect( 0, 0, w, h );
		end 

		self.div.DoClick = function( _self )
			if ( self.selectedDiv ) then 
				self.selectedDiv:SetDisabled( false );
			end 

			self.selectedDiv = _self;
			self.selectedDiv:SetDisabled( true );
			self.selectedDiv.name = div.NAME;
			self.selectedDiv.id = id;
			self.selectedDiv.xp = div.XP;
			
			self.divDesc:SetText("");
			self.divDesc:InsertColorChange( 255, 255, 255, 255 );
			self.divDesc:AppendText( "Required XP: \n " .. ( div.XP or -1 ) .. "\n" );
			self.divDesc:InsertColorChange( 255, 255, 255, 255 );
			self.divDesc:AppendText( "\nRank name:\n " .. ( div.NAME or "Unknown" ) .. "\n" );
			self.divDesc:AppendText("Description: \n " .. (div.DESC or "Unknown"));
			
			if ( div.XP > ply:getXP() ) then 
				self.divXP:SetTextColor( Color( 153, 0, 0 ) );
				self.divXP:SetText( "  You do not have enough XP for this position." );
			else 
				self.divXP:SetTextColor( Color( 0, 153, 0 ) );
				self.divXP:SetText( "  You have enough XP for this position." );
			end 
			
			self.divLabel:SetText( "  Minister Menu - Your XP: " .. ply:getXP() );
			self.modelPnl:SetModel(div.MODEL);
			local headPos = self.modelPnl.Entity:GetBonePosition( self.modelPnl.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) or 0 );
			self.modelPnl:SetLookAt( headPos );
			self.modelPnl:SetCamPos( headPos - Vector( -60, 0, 0 ) );
		end 
	end 

	self.divLabel = self:Add( "DLabel" );
	self.divLabel:SetPos( 5, 30 );
	self.divLabel:SetSize( ScrW() * .12, 25 );
	self.divLabel:SetTextColor( Color( 255, 255, 255 ) );
	self.divLabel:SetText( "  Divisions" );

	function self.divLabel:Paint( w, h )
		surface.SetDrawColor(64, 0, 0);
		surface.DrawRect( 0, 0, w, h );
	end 

	self.divDescLabel = self:Add( "DLabel" );
	self.divDescLabel:SetPos( 5, ScrH() * .2 + 60 );
	self.divDescLabel:SetSize( ScrW() * .12, 25 );
	self.divDescLabel:SetTextColor( Color( 255, 255, 255 ) );
	self.divDescLabel:SetText( "  Position description" );

	function self.divDescLabel:Paint( w, h )
		surface.SetDrawColor(64, 0, 0);
		surface.DrawRect( 0, 0, w, h );
	end  

	self.divDesc = self:Add( "RichText" );
	self.divDesc:SetPos( 5, 85 + ScrH() * .2 );
	self.divDesc:SetSize( ScrW() * .12, self:GetTall() - ( 110 + ScrH() * .2 ) - 5 );

	function self.divDesc:Paint( w, h )
		surface.SetDrawColor( 32, 32, 32, 150 )
		surface.DrawRect( 0, 0, w, h );

		surface.SetDrawColor(64, 0, 0);
		surface.DrawOutlinedRect( 0, 0, w, h );
	end 

	function self.divDesc:PerformLayout()
		self:SetFontInternal( "BudgetLabel" );
		self:SetFGColor(Color(255, 255, 255))
	end

	self.modelLabel = self:Add( "DLabel" );
	self.modelLabel:SetPos( self.divDesc:GetWide() + 10, 30 );
	self.modelLabel:SetSize( self:GetWide() - ( 20 + ScrW() * .24 ), 25 );
	self.modelLabel:SetTextColor( Color( 255, 255, 255 ) );
	self.modelLabel:SetText( "  Issued uniform" );

	function self.modelLabel:Paint( w, h )
		surface.SetDrawColor(64, 0, 0);
		surface.DrawRect( 0, 0, w, h );
	end  

	self.divXP = self:Add( "DLabel" );
	self.divXP:SetPos( 5, self:GetTall() - 30 );
	self.divXP:SetSize( ScrW() * .12, 25 );
	self.divXP:SetTextColor( Color( 255, 255, 255 ) );
	self.divXP:SetText( "" );

	function self.divXP:Paint( w, h )
		surface.SetDrawColor(64, 0, 0);
		surface.DrawRect( 0, 0, w, h );
	end  

	self.modelBck = self:Add( "DPanel" );
	self.modelBck:SetPos(self.divDesc:GetWide() + 10, 54);
	self.modelBck:SetSize( self:GetWide() - ( 20 + ScrW() * .24 ), self:GetTall() - 114 );

	function self.modelBck:Paint( w, h )
		surface.SetDrawColor(64, 0, 0);
		surface.DrawOutlinedRect( 0, 0, w, h );
	end 

	self.modelPnl = self.modelBck:Add( "DModelPanel" );
	self.modelPnl:SetPos( 1, 2 );
	self.modelPnl:SetSize( self.modelBck:GetWide() - 2, self.modelBck:GetTall() - 3 );
	self.modelPnl:SetFOV( 32 );

	function self.modelPnl:LayoutEntity()
	end 
	
	self:SetWide(self.modelBck:GetPos() + self.modelBck:GetWide() + 5);
	self:Center();
	
	self.closeButton = self:Add( "DButton" );
	self.closeButton:SetSize( 20, 20 );
	self.closeButton:SetPos( self:GetWide() - 23, 3 );
	self.closeButton:SetText( "X" );
	self.closeButton:SetTextColor( Color( 255, 255, 255 ) );
	
	function self.closeButton:Paint( w, h )
		surface.SetDrawColor(64, 0, 0);
		surface.DrawOutlinedRect( 0, 0, w, h );
	end 

	function self.closeButton:DoClick()
		self:GetParent():Remove();
	end


	self.getDiv = self:Add( "DButton" );
	self.getDiv:SetPos( self.divDesc:GetWide() + 10, self:GetTall() - 55 );
	self.getDiv:SetSize( self:GetWide() - (self.divDesc:GetWide() + 15 ), 50 );
	self.getDiv:SetTextColor( Color( 255, 255, 255 ) );
	self.getDiv:SetText( "Apply changes" );
	self.getDiv:SetFont( "RobotoMono32" );

	self.getDiv.DoClick = function( _self )
		if not ( self.selectedDiv ) then 
			ply:EmitSound( "buttons/combine_button3.wav" );

			return; 
		end 
		
		if (self.selectedDiv.xp > ply:getXP()) then 
			ply:EmitSound( "buttons/combine_button3.wav" );

			return; 
		end 
		
		print(self.selectedDiv.id);
		
		net.Start("BecomeMinister");
			net.WriteInt(self.selectedDiv.id, 8);
		net.SendToServer();
		
		ply:EmitSound( "items/ammo_pickup.wav" );

		self:Remove();
	end 

	function self.getDiv:Paint( w, h )
		surface.SetDrawColor(64, 0, 0);
		surface.DrawRect( 0, 0, w, h );
	end 
end 

function PANEL:Paint( w, h )
	surface.SetDrawColor(64, 0, 0);
	surface.DrawRect( 0, 0, w, 25 );

	surface.SetDrawColor( 32, 32, 32, 150 );
	surface.DrawRect( 0, 26, w, h );

	surface.SetDrawColor(64, 0, 0);
	surface.DrawOutlinedRect( 0, 0, w, h );
	surface.DrawOutlinedRect( 0, 0, w, 26 );
end 

function PANEL:OnRemove()
	if ( ministerMenu ) then ministerMenu = nil; end 
end 

---------------------------------------------------------------------------
	-- Registering the panel.
---------------------------------------------------------------------------

vgui.Register( "ministerMenu", PANEL, "DFrame" );

---------------------------------------------------------------------------
	-- Open the panel.
---------------------------------------------------------------------------

local function open()
	vgui.Create( "ministerMenu" );
end 
concommand.Add( "minister_open", open );