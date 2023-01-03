---------------------------------------------------------------------------
	-- Division PANEL.
---------------------------------------------------------------------------

local PANEL = {};

---------------------------------------------------------------------------
	-- Panel functions.
---------------------------------------------------------------------------

function PANEL:Init()
	if ( IsValid( resistance.PANEL ) ) then 
		resistance.PANEL:Remove();
		self:Remove();

		return;
	end 

	local ply = LocalPlayer();

	resistance.PANEL = self;

	self:SetSize( ScrW() * .5, ScrH() * .5 );
	self:Center();
	self:MakePopup();
	self:SetTitle( "Resistance Menu" );
	self:ShowCloseButton( false );

	self.closeButton = self:Add( "DButton" );
	self.closeButton:SetSize( 20, 20 );
	self.closeButton:SetPos( self:GetWide() - 23, 3 );
	self.closeButton:SetText( "X" );
	self.closeButton:SetTextColor( Color( 255, 255, 255 ) );

	function self.closeButton:Paint( w, h )
		surface.SetDrawColor( 0, 154, 0 );
		surface.DrawOutlinedRect( 0, 0, w, h );
	end 

	function self.closeButton:DoClick()
		self:GetParent():Remove();
	end  

	self.divMenu = self:Add( "DScrollPanel" );
	self.divMenu:SetPos( 5, 55 ); 
	self.divMenu:SetSize( ScrW() * .12, ScrH() * .2 );

	local scroll = self.divMenu:GetVBar();

	function scroll.btnUp:Paint( w, h )
		surface.SetDrawColor( 0, 154, 0 );
		surface.DrawOutlinedRect( 0, 0, w, h );
	end 

	function scroll.btnDown:Paint( w, h )
		surface.SetDrawColor( 0, 154, 0 );
		surface.DrawOutlinedRect( 0, 0, w, h );
	end 

	function scroll.btnGrip:Paint( w, h )
		surface.SetDrawColor( 0, 154, 0 );
		surface.DrawOutlinedRect( 0, 0, w, h );
	end

	self.rankMenu = self:Add( "DScrollPanel" );
	self.rankMenu:SetPos( ScrW() * .12 + 10, 55 );
	self.rankMenu:SetSize( ScrW() * .12, ScrH() * .2 );

	scroll = self.rankMenu:GetVBar();

	function scroll.btnUp:Paint( w, h )
		surface.SetDrawColor( 0, 154, 0 );
		surface.DrawOutlinedRect( 0, 0, w, h );
	end 

	function scroll.btnDown:Paint( w, h )
		surface.SetDrawColor( 0, 154, 0 );
		surface.DrawOutlinedRect( 0, 0, w, h );
	end 

	function scroll.btnGrip:Paint( w, h )
		surface.SetDrawColor( 0, 154, 0 );
		surface.DrawOutlinedRect( 0, 0, w, h );
	end

	for id, div in pairs( resistance.Data or {} ) do 
		if not ( div.access[ ply:Team() ] ) then continue; end 
		if (div.custom_check) and not (div.custom_check(ply)) then continue; end 

		self.div = self.divMenu:Add( "DButton" );
		self.div:Dock( TOP );
		self.div:SetTall( 48 );
		self.div:SetText( div.name );
		self.div:SetTextColor( Color( 255, 255, 255 ) );
		self.div:DockMargin( 2, 2, 2, 2 );

		function self.div:Paint( w, h )
			surface.SetDrawColor( 32, 32, 32, 150 );
			surface.DrawRect( 0, 0, w, h );

			local col; 

			if ( self:GetDisabled() ) then 
				col = Color( 35, 35, 142 );
			else 
				col = Color( 0, 154, 0 );
			end 

			surface.SetDrawColor( col );
			surface.DrawOutlinedRect( 0, 0, w, h );
		end 

		self.div.DoClick = function( _self )
		end 
	end 

	self.divLabel = self:Add( "DLabel" );
	self.divLabel:SetPos( 5, 30 );
	self.divLabel:SetSize( ScrW() * .12, 25 );
	self.divLabel:SetTextColor( Color( 255, 255, 255 ) );
	self.divLabel:SetText( "  Divisions" );

	function self.divLabel:Paint( w, h )
		surface.SetDrawColor( 0, 154, 0 );
		surface.DrawRect( 0, 0, w, h );
	end 

	self.rankLabel = self:Add( "DLabel" );
	self.rankLabel:SetPos( ScrW() * .12 + 10, 30 );
	self.rankLabel:SetSize( ScrW() * .12, 25 );
	self.rankLabel:SetTextColor( Color( 255, 255, 255 ) );
	self.rankLabel:SetText( "  Ranks" );

	function self.rankLabel:Paint( w, h )
		surface.SetDrawColor( 0, 154, 0 );
		surface.DrawRect( 0, 0, w, h );
	end

	self.divDescLabel = self:Add( "DLabel" );
	self.divDescLabel:SetPos( 5, ScrH() * .2 + 60 );
	self.divDescLabel:SetSize( ScrW() * .12, 25 );
	self.divDescLabel:SetTextColor( Color( 255, 255, 255 ) );
	self.divDescLabel:SetText( "  Division description" );

	function self.divDescLabel:Paint( w, h )
		surface.SetDrawColor( 0, 154, 0 );
		surface.DrawRect( 0, 0, w, h );
	end  

	self.divDesc = self:Add( "RichText" );
	self.divDesc:SetPos( 5, 85 + ScrH() * .2 );
	self.divDesc:SetSize( ScrW() * .12, self:GetTall() - ( 110 + ScrH() * .2 ) - 5 );

	function self.divDesc:Paint( w, h )
		surface.SetDrawColor( 32, 32, 32, 150 )
		surface.DrawRect( 0, 0, w, h );

		surface.SetDrawColor( 0, 154, 0 );
		surface.DrawOutlinedRect( 0, 0, w, h );
	end 

	function self.divDesc:PerformLayout()
		self:SetFontInternal( "BudgetLabel" );
		self:SetFGColor(Color(255, 255, 255))
	end

	self.rankDescLabel = self:Add( "DLabel" );
	self.rankDescLabel:SetPos( ScrW() * .12 + 10, ScrH() * .2 + 60 );
	self.rankDescLabel:SetSize( ScrW() * .12, 25 );
	self.rankDescLabel:SetTextColor( Color( 255, 255, 255 ) );
	self.rankDescLabel:SetText( "  Rank description" );

	function self.rankDescLabel:Paint( w, h )
		surface.SetDrawColor( 0, 154, 0 );
		surface.DrawRect( 0, 0, w, h );
	end  

	self.rankDesc = self:Add( "RichText" );
	self.rankDesc:SetPos( ScrW() * .12 + 10, 85 + ScrH() * .2 );
	self.rankDesc:SetSize( ScrW() * .12, self:GetTall() - ( 110 + ScrH() * .2 ) - 5 );

	function self.rankDesc:Paint( w, h )
		surface.SetDrawColor( 32, 32, 32, 150 )
		surface.DrawRect( 0, 0, w, h );

		surface.SetDrawColor( 0, 154, 0 );
		surface.DrawOutlinedRect( 0, 0, w, h );
	end 

	function self.rankDesc:PerformLayout()
		self:SetFontInternal( "BudgetLabel" );
		self:SetFGColor(Color(255, 255, 255))
	end

	self.modelLabel = self:Add( "DLabel" );
	self.modelLabel:SetPos( ScrW() * .24 + 15, 30 );
	self.modelLabel:SetSize( self:GetWide() - ( 20 + ScrW() * .24 ), 25 );
	self.modelLabel:SetTextColor( Color( 255, 255, 255 ) );
	self.modelLabel:SetText( "  Issued uniform" );

	function self.modelLabel:Paint( w, h )
		surface.SetDrawColor( 0, 154, 0 );
		surface.DrawRect( 0, 0, w, h );
	end  

	self.divXP = self:Add( "DLabel" );
	self.divXP:SetPos( 5, self:GetTall() - 30 );
	self.divXP:SetSize( ScrW() * .12, 25 );
	self.divXP:SetTextColor( Color( 255, 255, 255 ) );
	self.divXP:SetText( "" );

	function self.divXP:Paint( w, h )
		surface.SetDrawColor( 0, 154, 0 );
		surface.DrawRect( 0, 0, w, h );
	end  

	self.rankXP = self:Add( "DLabel" );
	self.rankXP:SetPos( ScrW() * .12 + 10, self:GetTall() - 30 );
	self.rankXP:SetSize( ScrW() * .12, 25 );
	self.rankXP:SetTextColor( Color( 255, 255, 255 ) );
	self.rankXP:SetText( "" );

	function self.rankXP:Paint( w, h )
		surface.SetDrawColor( 0, 154, 0 );
		surface.DrawRect( 0, 0, w, h );
	end 

	self.modelBck = self:Add( "DPanel" );
	self.modelBck:SetPos( ScrW() * .24 + 15, 54 );
	self.modelBck:SetSize( self:GetWide() - ( 20 + ScrW() * .24 ), self:GetTall() - 114 );

	function self.modelBck:Paint( w, h )
		surface.SetDrawColor( 0, 154, 0 );
		surface.DrawOutlinedRect( 0, 0, w, h );
	end 

	self.modelPnl = self.modelBck:Add( "DModelPanel" );
	self.modelPnl:SetPos( 1, 2 );
	self.modelPnl:SetSize( self.modelBck:GetWide() - 2, self.modelBck:GetTall() - 3 );
	self.modelPnl:SetFOV( 32 );

	function self.modelPnl:LayoutEntity()
	end 

	self.getDiv = self:Add( "DButton" );
	self.getDiv:SetPos( ScrW() * .24 + 15, self:GetTall() - 55 );
	self.getDiv:SetSize( self:GetWide() - ( 20 + ScrW() * .24 ), 50 );
	self.getDiv:SetTextColor( Color( 255, 255, 255 ) );
	self.getDiv:SetText( "Apply changes" );
	self.getDiv:SetFont( "RobotoMono32" );

	self.getDiv.DoClick = function( _self )
		ply:EmitSound( "items/ammo_pickup.wav" );

		self:Remove();
	end 

	function self.getDiv:Paint( w, h )
		surface.SetDrawColor( 0, 154, 0 );
		surface.DrawRect( 0, 0, w, h );
	end 
end 

function PANEL:Paint( w, h )
	surface.SetDrawColor( 0, 154, 0 );
	surface.DrawRect( 0, 0, w, 25 );

	surface.SetDrawColor( 32, 32, 32, 150 );
	surface.DrawRect( 0, 26, w, h );

	surface.SetDrawColor( 0, 154, 0 );
	surface.DrawOutlinedRect( 0, 0, w, h );
	surface.DrawOutlinedRect( 0, 0, w, 26 );
end 

function PANEL:OnRemove()
	if ( resistance.PANEL ) then resistance.PANEL = nil; end 
end 

---------------------------------------------------------------------------
	-- Registering the panel.
---------------------------------------------------------------------------

vgui.Register( "resistanceMenu", PANEL, "DFrame" );

---------------------------------------------------------------------------
	-- Console commands.
---------------------------------------------------------------------------
print("test");	
local function open()
	vgui.Create( "resistanceMenu" );
end 

concommand.Add( "rg_resistance", open );