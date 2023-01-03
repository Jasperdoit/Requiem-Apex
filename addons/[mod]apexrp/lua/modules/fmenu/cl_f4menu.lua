---------------------------------------------------------------------------
	-- Global f4 table.
---------------------------------------------------------------------------

f4Menu = f4Menu or {
	MATERIAL_CACHE = {};
}

---------------------------------------------------------------------------
	-- Defining some variables.
---------------------------------------------------------------------------

local leftArrow = Material( "f4menu/misc/l_arrow.png" );
local rightArrow = Material( "f4menu/misc/r_arrow.png" );

---------------------------------------------------------------------------
	-- Creating the panel.
---------------------------------------------------------------------------

local PANEL = {};

function PANEL:Init() 
	if ( IsValid( f4Menu.GUI ) ) or not ( LocalPlayer():Alive() ) then 
		f4Menu.GUI:Remove();
		self:Remove();

		return;
	end 

	f4Menu.GUI = self; 

	local ply = LocalPlayer();
	ply:EmitSound( "ambient/atmosphere/corridor.wav", 40 );
	
	self:cacheMaterials();
	self:MakePopup( true );
	self:SetKeyboardInputEnabled( false );
	self:SetSize( ScrW(), ScrH() );
	self:SetDraggable( false );
	self:SetTitle( "" );
	self:ShowCloseButton( false );
	self.jobKey = ply:Team();

	self.leftPanel = self:Add( "DPanel" );
	self.leftPanel:SetPos( 0, 0 );
	self.leftPanel:SetSize( ( ScrW() / 2 ) - 1, ScrH() );

	function self.leftPanel:Paint( w, h )
		surface.SetDrawColor( 0, 0, 0, 150 );
		surface.DrawRect( 0, 0, w, h );
	end

	self.rightPanel = self:Add( "DPanel" );
	self.rightPanel:SetPos( ( ScrW() / 2 ) + 1, 0 )
	self.rightPanel:SetSize( ( ScrW() / 2 ) - 1, ScrH() );

	function self.rightPanel:Paint( w, h )
		surface.SetDrawColor( 0, 0, 0, 200 );
		surface.DrawRect( 0, 0, w, h );

		if ( self:GetParent().logoMaterial ) and ( self:GetParent().nameLabel ) then 
			local x, y = self:GetParent().nameLabel:GetPos();

			surface.SetMaterial( self:GetParent().logoMaterial );
			surface.SetDrawColor( 255, 255, 255 );
			surface.DrawTexturedRect( ( self:GetWide() / 2 ) - ( self:GetTall() * .1  ), y + self:GetParent().nameLabel:GetTall() + 10, self:GetTall() * .2, self:GetTall() * .2 );
		end 
	end

	self.modelPanel = self:Add( "DModelPanel" );
	self.modelPanel:SetPos( 0, 0 );
	self.modelPanel:SetSize( self.leftPanel:GetWide(), self.leftPanel:GetTall() );

	function self.modelPanel:SetModel(model, skin, bodygroups)
		if (IsValid(self.Entity)) then
			self.Entity:Remove()
			self.Entity = nil
		end
	
		if (!ClientsideModel) then
			return
		end

		local entity = ClientsideModel(model, RENDERGROUP_OPAQUE)
	
		if (!IsValid(entity)) then
			return
		end
	
		entity:SetNoDraw(true)
		entity:SetIK(false)
	
		if (skin) then
			entity:SetSkin(skin)
		end
	
		if (isstring(bodygroups)) then
			entity:SetBodyGroups(bodygroups)
		end
	
		local sequence = entity:LookupSequence("idle_unarmed")
	
		if (sequence <= 0) then
			sequence = entity:SelectWeightedSequence(ACT_IDLE)
		end
	
		if (sequence > 0) then
			entity:ResetSequence(sequence)
		else
			local found = false
	
			for _, v in ipairs(entity:GetSequenceList()) do
				if ((v:lower():find("idle") or v:lower():find("fly")) and v != "idlenoise") then
					entity:ResetSequence(v)
					found = true
	
					break
				end
			end
	
			if (!found) then
				entity:ResetSequence(4)
			end
		end
	
		self.Entity = entity
	end

	function self.modelPanel:LayoutEntity()
		local scrW, scrH = ScrW(), ScrH();
		local xRatio = gui.MouseX() / scrW;
		local yRatio = gui.MouseY() / scrH;
		local x, y = self:LocalToScreen( self:GetWide() / 2 );
		local xRatio2 = x / scrW;
		local entity = self.Entity;

		entity:SetPoseParameter( "head_pitch", yRatio * 90 - 30 );
		entity:SetPoseParameter( "head_yaw", ( xRatio - xRatio2 ) *90 - 5 );
		entity:SetIK( false );

		if ( self.copyLocalSequence ) then
			entity:SetSequence( ply:GetSequence() );
		 	entity:SetPoseParameter( "move_yaw", 360 * LocalPlayer():GetPoseParameter( "move_yaw" ) - 180 );
		end

		self:RunAnimation();
	end 

	self.leftBMdl = self.modelPanel:Add( "DButton" );
	self.leftBMdl:SetPos( 25, ( self.leftPanel:GetTall() / 2 ) - 64 );
	self.leftBMdl:SetSize( 128, 128 );
	self.leftBMdl:SetText( "" ); 
	
	self.leftBMdl.DoClick = function( _self )
		if not ( self.modelKey ) then return; end 

		self.modelKey = self.modelKey - 1;
		self:update();
	end 

	function self.leftBMdl:Paint( w, h )
		surface.SetMaterial( leftArrow );
		surface.SetDrawColor( 255, 255, 255 );
		surface.DrawTexturedRect( 0, 0, w, h );
	end 

	self.rightBMdl = self.modelPanel:Add( "DButton" );
	self.rightBMdl:SetPos( self.leftPanel:GetWide() - 153, ( self.leftPanel:GetTall() / 2 ) - 64 );
	self.rightBMdl:SetSize( 128, 128 );
	self.rightBMdl:SetText( "" ); 

	self.rightBMdl.DoClick = function( _self )
		if not ( self.modelKey ) then return; end 

		self.modelKey = self.modelKey + 1;
		self:update();
	end 
	
	function self.rightBMdl:Paint( w, h )
		surface.SetMaterial( rightArrow );
		surface.SetDrawColor( 255, 255, 255 );
		surface.DrawTexturedRect( 0, 0, w, h );
	end 

	self.nameLabel = self.rightPanel:Add( "DLabel" );
	self.nameLabel:SetTextColor( Color( 255, 255, 255 ) );
	self.nameLabel:SetVisible( false );

	function self.nameLabel:Paint( w, h )
		surface.SetDrawColor( 0, 0, 0 );
		surface.DrawRect( 0, h - 2, w, 2 );
	end 

	self.leftBJob = self.rightPanel:Add( "DButton" );
	self.leftBJob:SetText( "" );

	self.leftBJob.DoClick = function()
		if not ( self.jobKey ) then return; end 

		self.jobKey = self.jobKey - 1;

		local model;
		
		if ( #RPExtraTeams[ self.jobKey ].model > 1 ) then 
			model = DarkRP.getPreferredJobModel( self.jobKey );
		end 

		if ( model ) then	
			for key, mdl in pairs( RPExtraTeams[ self.jobKey ].model ) do			
				if ( model:lower() == mdl:lower() ) then 
					self.modelKey = key;

					break;
				end 
			end 
		else 
			self.modelKey = 1;
		end 

		self:update();
	end 

	function self.leftBJob:Paint( w, h )
		surface.SetMaterial( leftArrow );
		surface.SetDrawColor( 255, 255, 255 );
		surface.DrawTexturedRect( 0, 0, w, h );
	end 

	self.rightBJob = self.rightPanel:Add( "DButton" );
	self.rightBJob:SetText( "" );

	self.rightBJob.DoClick = function()
		if not ( self.jobKey ) then return; end 

		self.jobKey = self.jobKey + 1;
		
		local model;

		if ( #RPExtraTeams[ self.jobKey ].model > 1 ) then 
			model = DarkRP.getPreferredJobModel( self.jobKey );
		end 

		if ( model ) then	
			for key, mdl in pairs( RPExtraTeams[ self.jobKey ].model ) do			
				if ( model:lower() == mdl:lower() ) then 
					self.modelKey = key;

					break;
				end 
			end 
		else 
			self.modelKey = 1;
		end 

		self:update();
	end 

	function self.rightBJob:Paint( w, h )
		surface.SetMaterial( rightArrow );
		surface.SetDrawColor( 255, 255, 255 );
		surface.DrawTexturedRect( 0, 0, w, h );
	end 

	self.desc = self.rightPanel:Add( "RichText" );
	self.desc:SetVerticalScrollbarEnabled( false );
	
	function self.desc:PerformLayout()
		self:SetFontInternal( "RobotoMono24" );
		self:SetFGColor(Color(255, 255, 255))
	end

	self.confirm = self.rightPanel:Add( "DButton" );
	self.confirm:SetFont( "RobotoMono48" );
	self.confirm:SetText( "" );
	self.confirm:SetTextColor( Color( 255, 255, 255 ) );
	self.confirm:SetSize( self.rightPanel:GetWide() * .4, self.rightPanel:GetTall() * .12 );
	self.confirm:SetPos( ( self.rightPanel:GetWide() / 2 ) - self.rightPanel:GetWide() * .2, ScrH() - ( ( ScrH() * .08 ) + self.rightPanel:GetTall() * .12 ) );

	self.confirm.DoClick = function( _self )
		RunConsoleCommand( "darkrp", RPExtraTeams[ self.jobKey ].command );
		self:Remove();
	end 

	function self.confirm:Paint( w, h )
		local col; 

		if ( self:GetDisabled() ) then 
			col = Color( 124, 15, 13, 150 );
		else 
			col = Color( 41, 91, 38, 150 );
		end 
			
		surface.SetDrawColor( col );
		surface.DrawRect( 0, 0, w, h );

		surface.SetDrawColor( 0, 0, 0 );
		surface.DrawOutlinedRect( 0, 0, w, h );
	end 
end

function PANEL:OnRemove()
	local ply = LocalPlayer();

	ply:StopSound( "ambient/atmosphere/corridor.wav" );
end 

function PANEL:update()
	local ply = LocalPlayer();
	local jobKey;

	if ( self.jobKey ) and RPExtraTeams[ self.jobKey ] then
		jobKey = self.jobKey;
	else 
		jobKey = ply:Team();
	end 

	if ( #RPExtraTeams == jobKey ) then
		self.rightBJob:SetVisible( false );
	elseif ( jobKey == 1 ) and ( #RPExtraTeams > 1 ) then 
		self.leftBJob:SetVisible( false );
	elseif ( #RPExtraTeams == 1 ) then  
		self.leftBMdl:SetVisible( false );
		self.rightBMdl:SetVisible( false ); 
	else 
		if not ( self.rightBJob:IsVisible() ) then 
			self.rightBJob:SetVisible( true );
		end 

		if not ( self.leftBJob:IsVisible() ) then 
			self.leftBJob:SetVisible( true );
		end 
	end 

	local jobTable = RPExtraTeams[ jobKey ];
	local jobName = team.GetName( jobKey ) or "Unknown";
	local jobFont = self.nameFont;

	self.nameLabel:SetFont( jobFont );
	self.nameLabel:SetText( jobName );
	surface.SetFont( jobFont );
	local w, h  = surface.GetTextSize( jobName );
	self.nameLabel:SetPos( ( self.rightPanel:GetWide() / 2 ) - ( w / 2 ), ScrH() * .08 );
	self.nameLabel:SetSize( w, h + 4 );
	self.nameLabel:SetVisible( true );

	local x, y = self.nameLabel:GetPos()
	w, h = self.nameLabel:GetSize();

	self.leftBJob:SetSize( h, h );
	self.leftBJob:SetPos( x - h, y );

	self.rightBJob:SetSize( h, h );
	self.rightBJob:SetPos( x + w, y);

	self.desc:SetPos( self.rightPanel:GetWide() / 2 - self.rightPanel:GetWide() * .4, y + self.nameLabel:GetTall() + 20 + ScrH() * .2 );
	self.desc:SetSize( self.rightPanel:GetWide() * .8, ScrH() - ( y + self.nameLabel:GetTall() + 30 + ScrH() * .2  + ( ( ScrH() * .08 ) + self.rightPanel:GetTall() * .12 ) ) );
	self.desc:SetText( "" );
	self.desc:InsertColorChange( 255, 255, 255, 255 );
	self.desc:AppendText( jobTable.description );

	if ( jobTable.xp ) then 
		self.desc:AppendText( "\n\nREQUIRED XP: " );
		if ( ply:getXP() >= jobTable.xp ) then 
			self.desc:InsertColorChange( 0, 153, 0, 255 );
		else 
			self.desc:InsertColorChange( 153, 0, 0, 255 );
		end
		self.desc:AppendText( jobTable.xp );
	end 

	if ( jobTable.description:len() > 350 ) and ( ScrH() < 850 ) then 
		self.desc:SetVerticalScrollbarEnabled( true );	
	else 
		self.desc:SetVerticalScrollbarEnabled( false );
	end 

	if ( self.jobKey == ply:Team() ) or ( jobTable.xp and ply:getXP() < jobTable.xp )  then 
		self.confirm:SetText( "UNAVAILABLE" );
		self.confirm:SetEnabled( false );
	else 
		self.confirm:SetText( "SELECT" );
		self.confirm:SetEnabled( true );
	end 

	self.backgroundMaterial = f4Menu.MATERIAL_CACHE[ jobKey ][ 1 ];
	self.logoMaterial = f4Menu.MATERIAL_CACHE[ jobKey ][ 2 ];

	if not ( self.modelKey ) then 
		local model = DarkRP.getPreferredJobModel( jobKey );

		if ( model ) then 
			for key, mdl in pairs( jobTable.model ) do
				if ( mdl:lower() == model:lower() ) then 
					self.modelKey = key;

					break;
				end 	
			end 
		end 

		if not ( self.modelKey ) then 
			self.modelKey = 1;
		end 

		self.modelPanel:SetModel( "models/breen.mdl" );
		self.modelPanel:SetFOV( 50 );
		self.modelPanel:SetLookAt( self.modelPanel.Entity:GetBonePosition( self.modelPanel.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) ) - Vector( 0, 0, 12 ) );
		self.modelPanel:SetCamPos( self.modelPanel.Entity:GetBonePosition( self.modelPanel.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) ) - Vector (-42, 0, 8 ) );
		self.modelPanel:SetModel(  jobTable.model[ self.modelKey ] );

		for bodygroupi, bodygroupv in pairs(jobTable.bodygroup or {}) do
            self.modelPanel.Entity:SetBodygroup(bodygroupi, bodygroupv)
        end
		
		
		if ( #jobTable.model == 1 ) then 
			self.leftBMdl:SetVisible( false );
			self.rightBMdl:SetVisible( false );
		elseif ( #jobTable.model > 1 ) then 
			if ( self.modelKey == 1 ) then 
				self.leftBMdl:SetVisible( false );
				self.rightBMdl:SetVisible( true );
			elseif ( self.modelKey == #jobTable.model ) then
				self.leftBMdl:SetVisible( true );
				self.rightBMdl:SetVisible( false );
			end 
		end 

		DarkRP.setPreferredJobModel( self.jobKey, jobTable.model[ self.modelKey ] );

		return;
	end 

	if ( #jobTable.model == 1 ) then 
		self.leftBMdl:SetVisible( false );
		self.rightBMdl:SetVisible( false );
	elseif ( #jobTable.model > 1 ) then 
		if ( self.modelKey == 1 ) then 
			self.leftBMdl:SetVisible( false );
			self.rightBMdl:SetVisible( true );
		elseif ( self.modelKey == #jobTable.model ) then
			self.leftBMdl:SetVisible( true );
			self.rightBMdl:SetVisible( false ); 
		else 
			if not ( self.rightBMdl:IsVisible() ) then 
				self.rightBMdl:SetVisible( true );
			end 
	
			if not ( self.leftBMdl:IsVisible() ) then 
				self.leftBMdl:SetVisible( true );
			end 
		end 
	end 

	ply:EmitSound( "buttons/button19.wav" );

	print( self.modelKey );

	self.modelPanel:SetModel( jobTable.model[ self.modelKey ] );
	for bodygroupi, bodygroupv in pairs(jobTable.bodygroup or {}) do
		self.modelPanel.Entity:SetBodygroup(bodygroupi, bodygroupv)
	end
	DarkRP.setPreferredJobModel( self.jobKey, jobTable.model[ self.modelKey ] );
end 

function PANEL:cacheMaterials()
	for id, data in pairs( RPExtraTeams ) do 
		if ( f4Menu.MATERIAL_CACHE[ id ] ) then continue; end 

		MsgC( Color( 153, 0, 0 ), "Materials not cached for job " .. ( team.GetName( id ) or "UNKNOWN"  ) .. ", caching now...\n" );

		f4Menu.MATERIAL_CACHE[ id ] = {
			Material( data.menu_materials.background ) or nil, 
			Material( data.menu_materials.logo ) or nil,
		};
	end 
end 

function PANEL:Think()
	if ( input.IsKeyDown( KEY_ESCAPE ) ) or ( input.IsKeyDown( KEY_F1 ) ) then
		self:Remove();
	end  

	if ( self.scrw ~= ScrW() ) then
		self.scrw = ScrW();
		
		if ( ScrW() >= 1920 ) then
			self.nameFont = "RobotoMono64";
		elseif ( ScrW() < 1920 ) and ( ScrW() >= 1200 ) then   
			self.nameFont = "RobotoMono48";
		else 
			self.nameFont = "RobotoMono32";
		end 
		
		self:update();
	end 
end 

function PANEL:Paint( w, h )
	if ( self.backgroundMaterial ) then 
		surface.SetMaterial( self.backgroundMaterial );
		surface.SetDrawColor( 255, 255, 255 );
		surface.DrawTexturedRect( 0, 0, w, h );
	end 

	self:drawBlur( 3, 6 );

	surface.SetDrawColor( 0, 0, 0 );
	surface.DrawRect( ( ScrW() / 2 ) - 1, 0, 2, ScrH() );
end 

vgui.Register( "f4Menu",  PANEL, "DFrame" );

---------------------------------------------------------------------------
	-- Opening the panel.
---------------------------------------------------------------------------

local function open() 
    if (LocalPlayer():getDarkRPVar("afk")) then return; end
    
	vgui.Create( "f4Menu" );
end 

concommand.Add( "rg_f4menu", open, nil, FCVAR_UNREGISTERED );