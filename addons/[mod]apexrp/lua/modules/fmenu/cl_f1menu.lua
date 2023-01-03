---------------------------------------------------------------------------
	-- Global f1 menu.
---------------------------------------------------------------------------

f1Menu = f1Menu or {};

---------------------------------------------------------------------------
	-- Creating the panel.
---------------------------------------------------------------------------

local PANEL = {};

function PANEL:Init()
	self.data = {}
	
	if ( ScrW() > 1600 ) then 
		self.font = "RobotoMono32";
	else 
		self.font = "RobotoMono24";
	end 

	surface.SetFont( self.font );
	local w, h = surface.GetTextSize( "Test" );
	self:SetTall( h * 2 );
end 

function PANEL:addPiece( title, text, func )
	local data = {
		title = title or "Unknown",
		text = text or "Unknown",
		func = func or nil 
	};
	
	table.insert( self.data, data ); 
end 

function PANEL:load()
	local rowCount = #self.data or 0;
	local gap = 0;

	if ( rowCount > 1 ) then 
		gap = 2; 
	end 

	local rowWidth = math.Round(self:GetWide() / rowCount)  - ( gap * rowCount - 1 );
	local x = 0;

	for _, data in pairs( self.data ) do 
		local y = 0;
	
		if ( _ == 1 ) then 
			gap = 0; 
		else 
			gap = 2;
		end 
		
		self.title = self:Add( "DLabel" );
		self.title:SetPos( x + gap, y )
		self.title:SetSize( rowWidth, self:GetTall() / 2 );
		self.title:SetText( data.title );
		self.title:SetFont( self.font );
		self.title:SetContentAlignment( 5 );
		self.title:SetColor( Color( 255, 255, 255 ) );
		
		function self.title:Paint( w, h )
			surface.SetDrawColor( 32, 32, 32 );
			surface.DrawRect( 0, 0, w, h );
		end 
			
		y = y + self.title:GetTall();
	
		local element = "DLabel";
	
		if (data.func) then 
			element = "DButton";
		end 	
		
		self.text = self:Add( element );
		self.text:SetPos( x + gap, y );
		self.text:SetSize( rowWidth, self:GetTall() / 2 );		
		self.text:SetText( data.text );
		self.text:SetFont( self.font );
		self.text:SetContentAlignment( 5 );
		self.text:SetColor( Color( 0, 0, 0 ) );

		function self.text:Paint( w, h )
			surface.SetDrawColor( 255, 255, 255, 150 );
			surface.DrawRect( 0, 0, w, h );

			if ( gap == 0 ) then 
				surface.SetDrawColor( 32, 32, 32, 255 );
				surface.DrawOutlinedRect( 0, 0, w - 5, h );
			else 
				surface.SetDrawColor( 32, 32, 32, 255 );
				surface.DrawOutlinedRect( 0, 0, w, h );
			end 
		end 
		
		if (data.func) then 
			self.text.DoClick = function(_self)
				local self = self:GetParent():GetParent():GetParent();
				
				if (IsValid(self.misc)) then 
					if (self.misc.meme == data.title) then
						self.misc:Remove()
						self.misc = nil
						_self:SetText(data.text)
					end 
							
					return 
				end 
				
				_self:SetText("Close");
				self.misc = self:Add("DPanel");
				self.misc:SetPos(100, 100)
				self.misc:SetSize( ScrW() * .6 - 200, ScrH() - 200);
				self.misc.meme = data.title;
				function self.misc:Paint(w, h)
					surface.SetDrawColor(32, 32, 32, 150)
					surface.DrawRect(0, 0, w, h)
				end 
				
				self.misc.panel = self.misc:Add(data.func())
				self.misc.panel:SetPos(5, 5)
				self.misc.panel:SetSize(self.misc:GetWide() - 10, self.misc:GetTall() - 10)
			end 
		end 
		
		x = x + self.title:GetWide();
	end 
end 

function PANEL:Paint( w, h )
	surface.SetDrawColor( 0, 0, 0, 0 );
	surface.DrawRect( 0, 0, w, h );
end 

vgui.Register( "f1InfoPanel", PANEL, "DPanel" );

PANEL = {};

function PANEL:Init()
    if ( IsValid( f1Menu.GUI ) ) or not ( LocalPlayer():Alive() ) then 
		f1Menu.GUI:Remove();
		
		return;
	end 

	local ply = LocalPlayer();
    f1Menu.GUI = self; 
    
	self:MakePopup( true );
	self:SetKeyboardInputEnabled( false );
	self:SetSize( ScrW(), ScrH() );
	self:setCharacterOverview(true);

	self.scrollPanel = self:Add( "DScrollPanel" );
	self.scrollPanel:SetPos( ScrW() * .6, 100 );
	self.scrollPanel:SetSize( ScrW() - ScrW() * .6 - 100, ScrH() - 200 );	
	
	self.name = self.scrollPanel:Add( "f1InfoPanel" );
	self.name:SetWide( self.scrollPanel:GetWide() );
	self.name:Dock( TOP );
	self.name:DockMargin( 2, 3, 2, 0 );
	self.name:addPiece( "Roleplay name", ply:Name() );
	self.name:load();

	self.job = self.scrollPanel:Add( "f1InfoPanel" );
	self.job:SetWide( self.scrollPanel:GetWide() );
	self.job:Dock( TOP );
	self.job:DockMargin( 2, 2, 2, 0 ); 
	self.job:addPiece( "Player faction", ply:getDarkRPVar( "job" ) );
	self.job:load();
	
	if ((ply:Team() == TEAM_CITIZEN) or (ply:Team() == TEAM_CWU)) and (CitOpt)then 
		self.citopts = self.scrollPanel:Add("f1InfoPanel")
		self.citopts:SetWide(self.scrollPanel:GetWide());
		self.citopts:Dock(TOP);
		self.citopts:DockMargin(2,2,2,0);
		self.citopts:addPiece("Citizen option", CitOpt[ply:GetNWInt("citopt") or 1]);
		self.citopts:load();
	end 

	if ( divisions ) and ( ply:getDivision() > 0 ) then 
		local divData = ply:getDivisionData();
		local divName = divData.name;

		self.division = self.scrollPanel:Add( "f1InfoPanel" );
		self.division:SetWide( self.scrollPanel:GetWide() );
		self.division:Dock( TOP );
		self.division:DockMargin( 2, 2, 2, 0 ); 
		self.division:addPiece( "Your division", divName );
		if ( ply:getDivisionRank() > 0 ) then 
			local rankData = ply:getDivisionRankData();
			local rankName = rankData.name;

			self.division:addPiece( "Your rank", rankName );
		end 
		self.division:load();
	end 
	
	if (divisions) and (ply:getDivision() > 0) then 
		self.sc = self.scrollPanel:Add("f1InfoPanel");
		self.sc:SetWide( self.scrollPanel:GetWide() );
		self.sc:Dock( TOP );
		self.sc:DockMargin( 2, 2, 2, 0 );  
		self.sc:addPiece( "Your sterilized credits", ply:getSC() .. "SC" );
		self.sc:load();
	end
	
	self.xp = self.scrollPanel:Add( "f1InfoPanel" );
	self.xp:SetWide( self.scrollPanel:GetWide() );
	self.xp:Dock( TOP );
	self.xp:DockMargin( 2, 2, 2, 0 );  
	self.xp:addPiece( "Your XP points", ply:getXP() );
	
	if (divisions) and ( ply:getDivision() > 0 ) then 
		local divData = ply:getDivisionData();
		local divName = divData.name;
		local divXP = ply:getDivisionXP();

		self.xp:addPiece( "Your " .. divName .. " XP points", divXP )
	end
	
	self.xp:load();
	
    self.tax = self.scrollPanel:Add( "f1InfoPanel" );
	self.tax:SetWide( self.scrollPanel:GetWide() );
	self.tax:Dock( TOP );
	self.tax:DockMargin( 2, 2, 2, 0 );  
	self.tax:addPiece( "Taxation rate", GetGlobalInt("tax") .. "%" );
	self.tax:load();
    
	self.salary = self.scrollPanel:Add( "f1InfoPanel" );
	self.salary:SetWide( self.scrollPanel:GetWide() );
	self.salary:Dock( TOP );
	self.salary:DockMargin( 2, 2, 2, 0 );  
	self.salary:addPiece( "Balance", ply:getDarkRPVar( "money" ) .. "T" );
	self.salary:addPiece( "Salary", ply:getDarkRPVar( "salary" ) .. "T" );
	self.salary:load();
	
	self.information = self.scrollPanel:Add( "f1InfoPanel" );
	self.information:SetWide( self.scrollPanel:GetWide() );
	self.information:Dock( TOP );
	self.information:DockMargin( 2, 2 + self.xp:GetTall(), 2, 0 );  
	self.information:addPiece("Information", "Open", GAMEMODE.InformationTab);
	self.information:addPiece("Rules", "Open", GAMEMODE.RulesTab);
	self.information:load();
	
	self.marketplace = self.scrollPanel:Add("f1InfoPanel");
	self.marketplace:SetWide(self.scrollPanel:GetWide())
	self.marketplace:Dock(TOP);
	self.marketplace:DockMargin(2, 2, 2, 0);
	self.marketplace:addPiece("Marketplace", "Open", GAMEMODE.EntitiesTab);
	self.marketplace:load(); 
	
	hook.Run("f1Menu", self.scrollPanel);
end 

function PANEL:Paint( w, h )
	surface.SetDrawColor( 0, 0, 0, 0 );
	surface.DrawRect( 0, 0, w, h );
end 

function PANEL:OnRemove()
	self:setCharacterOverview( false );
end 

vgui.Register( "f1Menu",  PANEL, "DPanel" );

---------------------------------------------------------------------------
	-- Opening the panel.
---------------------------------------------------------------------------

local function open() 
    if (LocalPlayer():getDarkRPVar("afk")) then return; end
    
	vgui.Create( "f1Menu" );
end 

concommand.Add( "rg_f1menu", open, nil, FCVAR_UNREGISTERED );