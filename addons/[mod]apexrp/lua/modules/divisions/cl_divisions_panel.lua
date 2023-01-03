---------------------------------------------------------------------------
	-- Division PANEL.
---------------------------------------------------------------------------

local PANEL = {};

---------------------------------------------------------------------------
	-- Panel functions.
---------------------------------------------------------------------------

function PANEL:Init()
	if ( IsValid( divisions.PANEL ) ) then 
		divisions.PANEL:Remove();
		self:Remove();

		return;
	end 

	local ply = LocalPlayer();

	divisions.PANEL = self;

	self:SetSize( ScrW() * .5, ScrH() * .5 );
	self:Center();
	self:MakePopup();
	self:SetTitle( "Divisions Menu" );
	self:ShowCloseButton( false );

	self.closeButton = self:Add( "DButton" );
	self.closeButton:SetSize( 20, 20 );
	self.closeButton:SetPos( self:GetWide() - 23, 3 );
	self.closeButton:SetText( "X" );
	self.closeButton:SetTextColor( Color( 255, 255, 255 ) );

	function self.closeButton:Paint( w, h )
		surface.SetDrawColor( 32, 32, 32 );
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
		surface.SetDrawColor( 32, 32, 32 );
		surface.DrawOutlinedRect( 0, 0, w, h );
	end 

	function scroll.btnDown:Paint( w, h )
		surface.SetDrawColor( 32, 32, 32 );
		surface.DrawOutlinedRect( 0, 0, w, h );
	end 

	function scroll.btnGrip:Paint( w, h )
		surface.SetDrawColor( 32, 32, 32 );
		surface.DrawOutlinedRect( 0, 0, w, h );
	end

	self.rankMenu = self:Add( "DScrollPanel" );
	self.rankMenu:SetPos( ScrW() * .12 + 10, 55 );
	self.rankMenu:SetSize( ScrW() * .12, ScrH() * .2 );

	scroll = self.rankMenu:GetVBar();

	function scroll.btnUp:Paint( w, h )
		surface.SetDrawColor( 32, 32, 32 );
		surface.DrawOutlinedRect( 0, 0, w, h );
	end 

	function scroll.btnDown:Paint( w, h )
		surface.SetDrawColor( 32, 32, 32 );
		surface.DrawOutlinedRect( 0, 0, w, h );
	end 

	function scroll.btnGrip:Paint( w, h )
		surface.SetDrawColor( 32, 32, 32 );
		surface.DrawOutlinedRect( 0, 0, w, h );
	end

	for id, div in pairs( divisions.Data ) do 
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
				col = Color( 32, 32, 32 );
			end 

			surface.SetDrawColor( col );
			surface.DrawOutlinedRect( 0, 0, w, h );
		end 

		self.div.DoClick = function( _self )
			self.rankMenu:Clear();
			self.rankXP:SetText( "" );
			self.divDesc:SetText( "" );
			self.rankDesc:SetText( "" );
				
			if ( self.selectedDiv ) then 
				self.selectedDiv:SetDisabled( false );
			end 

			self.selectedDiv = _self;
			self.selectedDiv:SetDisabled( true );
			self.selectedDiv.name = div.name;
			self.selectedDiv.id = id;

			if ( self.selectedRank ) then 
				self.selectedRank:SetDisabled( false );
				self.selectedRank = nil;
			end 

			if ( div.xp > ply:getXP() ) then 
				self.divXP:SetTextColor( Color( 153, 0, 0 ) );
				self.divXP:SetText( "  You do not have enough XP for this division." );
			else 
				self.divXP:SetTextColor( Color( 0, 153, 0 ) );
				self.divXP:SetText( "  You have enough XP for this division." );
			end 

			self.divDesc:InsertColorChange( 255, 255, 255, 255 );
			self.divDesc:AppendText( "Required XP: \n " .. ( div.xp or -1 ) .. "\n" );
			self.divDesc:InsertColorChange( 255, 255, 255, 255 );
			self.divDesc:AppendText( "\nDivision name:\n " .. ( div.name or "Unknown" ) .. "\n" );
			self.divDesc:AppendText( "Division description:\n " .. ( div.desc or "Unknown" ) );

			if (div.model) then 
				self.modelPnl:SetModel(div.model);
				local headPos = self.modelPnl.Entity:GetBonePosition( self.modelPnl.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) or 0 );
				self.modelPnl:SetLookAt( headPos );
				self.modelPnl:SetCamPos( headPos - Vector( -60, 0, 0 ) ); 
                
                if (div.skin) then 
                    self.modelPnl.Entity:SetSkin(div.skin);
                end 
			end 
			
			ply:EmitSound( "buttons/combine_button1.wav" );

			if not ( div.ranks ) then 
				local loadout = div.loadout or {};

				self.rankDesc:AppendText( "Rank loadout:\n" );

				for _, wep in pairs( loadout ) do 
					self.rankDesc:AppendText( " +" .. wep .. "\n" );
				end

				local sc = div.sc or 0;

				self.rankDesc:AppendText( "\nYou will gain " );
				self.rankDesc:InsertColorChange( 0, 153, 0, 255 );
				if ( sc == 0 ) then 
					self.rankDesc:InsertColorChange( 153, 0, 0, 255 );
				end 
				self.rankDesc:AppendText( sc );
				self.rankDesc:InsertColorChange( 255, 255, 255, 255 );
				self.rankDesc:AppendText( " sterilized credit." );

				return; 
			end 

			for _id, rank in ipairs( div.ranks ) do 
				if (rank.custom_check) and not (rank.custom_check(ply)) then continue; end 
			
				self.rank = self.rankMenu:Add( "DButton" );
				self.rank:Dock( TOP );
				self.rank:SetTall( 48 );
				self.rank:SetText( rank.name );
				self.rank:SetTextColor( Color( 255, 255, 255 ) );
				self.rank:DockMargin( 2, 2, 2, 2 );

				self.rank.DoClick = function( _self )
					if ( self.selectedRank ) then 
						self.selectedRank:SetDisabled( false );
					end 

					self.rankDesc:SetText( "" );

					local loadout = {};

					for _, wep in pairs( div.loadout or {} ) do 
						table.insert( loadout, wep );
					end 

					local sc = (div.sc or 0) + (rank.additional_sc or 0);

					for k, v in ipairs( div.ranks ) do 
						if ( _id < k ) then break; end 

						for _, wep in pairs( v.additional_loadout 	or {} ) do 
							table.insert( loadout, wep );
						end 
					end 
					
					if (rank.model) then 
						self.modelPnl:SetModel(rank.model);
						local headPos = self.modelPnl.Entity:GetBonePosition( self.modelPnl.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) or 0 );
						self.modelPnl:SetLookAt( headPos );
						self.modelPnl:SetCamPos( headPos - Vector( -60, 0, 0 ) ); 
                        
                        if (rank.skin) then 
                            self.modelPnl.Entity:SetSkin(rank.skin);
						end
                    else 
                        self.modelPnl:SetModel(div.model);
						local headPos = self.modelPnl.Entity:GetBonePosition( self.modelPnl.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) or 0 );
						self.modelPnl:SetLookAt( headPos );
						self.modelPnl:SetCamPos( headPos - Vector( -60, 0, 0 ) ); 
                    end 
					
					self.rankDesc:InsertColorChange( 255, 255, 255, 255 );
					self.rankDesc:AppendText( "Required division XP: \n " .. ( rank.xp or -1 ) .. "\n" );
					self.rankDesc:InsertColorChange( 255, 255, 255, 255 );
					self.rankDesc:AppendText( "\nRank name:\n " .. ( rank.name or "Unknown" ) .. "\n" );
					self.rankDesc:AppendText( "Rank loadout:\n" );
					
					for id, wep in pairs( loadout ) do 
						self.rankDesc:AppendText( " +" .. wep .. "\n" );
					end 

					self.rankDesc:AppendText( "\nYou will gain " );
					
					self.rankDesc:InsertColorChange( 0, 153, 0, 255 );
					if ( sc == 0 ) then 
						self.rankDesc:InsertColorChange( 153, 0, 0, 255 );
					end 
					self.rankDesc:AppendText( sc );
					self.rankDesc:InsertColorChange( 255, 255, 255, 255 );
					self.rankDesc:AppendText( " sterilized credit." );

					if ( rank.xp > ply:GetNWInt( div.name .. ":xp" ) ) then 
						self.rankXP:SetTextColor( Color( 153, 0, 0 ) );
						self.rankXP:SetText( "  You do not have enough div XP for this rank." );
					else 
						self.rankXP:SetTextColor( Color( 0, 153, 0 ) );
						self.rankXP:SetText( "  You have enough div XP for this rank." );
					end

					ply:EmitSound( "buttons/combine_button1.wav" );

					self.selectedRank = _self;
					self.selectedRank:SetDisabled( true );
					self.selectedRank.id = _id;
				end 

				function self.rank:Paint( w, h )
					surface.SetDrawColor( 32, 32, 32, 150 );
					surface.DrawRect( 0, 0, w, h );

					local col; 

					if ( self:GetDisabled() ) then 
						col = Color( 35, 35, 142 );
					else 
						col = Color( 32, 32, 32 );
					end

					surface.SetDrawColor( col );
					surface.DrawOutlinedRect( 0, 0, w, h );
				end 
			end 
		end 
	end 

	self.divLabel = self:Add( "DLabel" );
	self.divLabel:SetPos( 5, 30 );
	self.divLabel:SetSize( ScrW() * .12, 25 );
	self.divLabel:SetTextColor( Color( 255, 255, 255 ) );
	self.divLabel:SetText( "  Divisions" );

	function self.divLabel:Paint( w, h )
		surface.SetDrawColor( 32, 32, 32 );
		surface.DrawRect( 0, 0, w, h );
	end 

	self.rankLabel = self:Add( "DLabel" );
	self.rankLabel:SetPos( ScrW() * .12 + 10, 30 );
	self.rankLabel:SetSize( ScrW() * .12, 25 );
	self.rankLabel:SetTextColor( Color( 255, 255, 255 ) );
	self.rankLabel:SetText( "  Ranks" );

	function self.rankLabel:Paint( w, h )
		surface.SetDrawColor( 32, 32, 32 );
		surface.DrawRect( 0, 0, w, h );
	end

	self.divDescLabel = self:Add( "DLabel" );
	self.divDescLabel:SetPos( 5, ScrH() * .2 + 60 );
	self.divDescLabel:SetSize( ScrW() * .12, 25 );
	self.divDescLabel:SetTextColor( Color( 255, 255, 255 ) );
	self.divDescLabel:SetText( "  Division description" );

	function self.divDescLabel:Paint( w, h )
		surface.SetDrawColor( 32, 32, 32 );
		surface.DrawRect( 0, 0, w, h );
	end  

	self.divDesc = self:Add( "RichText" );
	self.divDesc:SetPos( 5, 85 + ScrH() * .2 );
	self.divDesc:SetSize( ScrW() * .12, self:GetTall() - ( 110 + ScrH() * .2 ) - 5 );

	function self.divDesc:Paint( w, h )
		surface.SetDrawColor( 32, 32, 32, 150 )
		surface.DrawRect( 0, 0, w, h );

		surface.SetDrawColor( 32, 32, 32 );
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
		surface.SetDrawColor( 32, 32, 32 );
		surface.DrawRect( 0, 0, w, h );
	end  

	self.rankDesc = self:Add( "RichText" );
	self.rankDesc:SetPos( ScrW() * .12 + 10, 85 + ScrH() * .2 );
	self.rankDesc:SetSize( ScrW() * .12, self:GetTall() - ( 110 + ScrH() * .2 ) - 5 );

	function self.rankDesc:Paint( w, h )
		surface.SetDrawColor( 32, 32, 32, 150 )
		surface.DrawRect( 0, 0, w, h );

		surface.SetDrawColor( 32, 32, 32 );
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
		surface.SetDrawColor( 32, 32, 32 );
		surface.DrawRect( 0, 0, w, h );
	end  

	self.divXP = self:Add( "DLabel" );
	self.divXP:SetPos( 5, self:GetTall() - 30 );
	self.divXP:SetSize( ScrW() * .12, 25 );
	self.divXP:SetTextColor( Color( 255, 255, 255 ) );
	self.divXP:SetText( "" );

	function self.divXP:Paint( w, h )
		surface.SetDrawColor( 32, 32, 32 );
		surface.DrawRect( 0, 0, w, h );
	end  

	self.rankXP = self:Add( "DLabel" );
	self.rankXP:SetPos( ScrW() * .12 + 10, self:GetTall() - 30 );
	self.rankXP:SetSize( ScrW() * .12, 25 );
	self.rankXP:SetTextColor( Color( 255, 255, 255 ) );
	self.rankXP:SetText( "" );

	function self.rankXP:Paint( w, h )
		surface.SetDrawColor( 32, 32, 32 );
		surface.DrawRect( 0, 0, w, h );
	end 

	self.modelBck = self:Add( "DPanel" );
	self.modelBck:SetPos( ScrW() * .24 + 15, 54 );
	self.modelBck:SetSize( self:GetWide() - ( 20 + ScrW() * .24 ), self:GetTall() - 114 );

	function self.modelBck:Paint( w, h )
		surface.SetDrawColor( 32, 32, 32 );
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
		if not ( self.selectedDiv ) then 
			ply:EmitSound( "buttons/combine_button3.wav" );

			return; 
		end 

		local hasRanks = false;

		if ( divisions.Data[ self.selectedDiv.id ].ranks ) then 
			hasRanks = true; 
		end 

		if not ( self.selectedRank ) and ( hasRanks ) then 
			ply:EmitSound( "buttons/combine_button3.wav" );

			return; 
		end 

		local div = self.selectedDiv.id;
		local divName = self.selectedDiv.name; 
		local rank;

		if ( hasRanks ) then 
			rank = self.selectedRank.id;

			if ( ply:getDivisionRank() == rank ) and ( ply:getDivision() == div ) then 
				ply:EmitSound( "buttons/combine_button3.wav" );

				return;
			end 

			if ( divisions.Data[ div ].xp > ply:getXP() ) or ( divisions.Data[ div ].ranks[ rank ].xp > ply:GetNWInt( divName .. ":xp", 0 ) ) then 
				ply:EmitSound( "buttons/combine_button3.wav" );

				return; 
			end 
			
			if ( divisions.Data[div].ranks[rank].slots) then
				local amount = 0;
				
				for _, cp in ipairs(player.GetAll()) do 
					if (cp:getDivisionRank() == rank) and (cp:getDivision() == div) and (cp != ply) then 
						amount = amount + 1
					
						if (amount == divisions.Data[div].ranks[rank].slots) then 
							ply:EmitSound( "buttons/combine_button3.wav" );
							return;
						end 
					end 
				end 
				if (amount == divisions.Data[div].ranks[rank].slots) then 
					ply:EmitSound( "buttons/combine_button3.wav" );
					return;
				end
			end 
		else 
			if ( ply:getDivision() == div ) then 
				ply:EmitSound( "buttons/combine_button3.wav" );

				return;
			end 

			if ( divisions.Data[ div ].xp > ply:getXP() ) then 
				ply:EmitSound( "buttons/combine_button3.wav" );

				return
			end 
			
			if (divisions.Data[div].slots) then 
				local amount = 0;
				
				for _, cp in ipairs(player.GetAll()) do 
					if (cp:getDivision() == div) and (cp != ply) then 
						amount = amount + 1;
						
						if (amount == divisions.Data[div].slots) then 
							ply:EmitSound( "buttons/combine_button3.wav" );
							return;
						end 
					end 
				end
				
				if (amount == divisions.Data[div].slots) then 
					ply:EmitSound( "buttons/combine_button3.wav" );
					return;
				end 
			end 
		end  

		net.Start( "divisionSelect" );
			net.WriteInt( div, 8 );
			if ( hasRanks ) then 
				net.WriteInt( rank, 8 );
			end 
		net.SendToServer();

		ply:EmitSound( "items/ammo_pickup.wav" );

		self:Remove();
	end 

	function self.getDiv:Paint( w, h )
		surface.SetDrawColor( 32, 32, 32 );
		surface.DrawRect( 0, 0, w, h );
	end 

	timer.Create( "divLabelUpdate", .2, 0, function()
		if not ( IsValid( self ) ) then timer.Remove( "divLabelUpdate" ); end 

		self.divLabel:SetText( "  Divisions - Your XP: " .. ply:getXP() );

		if ( self.selectedDiv ) then 
			self.rankLabel:SetText( "  Ranks - Your XP with this division: " .. ply:GetNWInt( self.selectedDiv.name .. ":xp" ) );
		else 
			self.rankLabel:SetText( "  Ranks" );
		end 
	end )
end 

function PANEL:Paint( w, h )
	surface.SetDrawColor( 32, 32, 32 );
	surface.DrawRect( 0, 0, w, 25 );

	surface.SetDrawColor( 32, 32, 32, 150 );
	surface.DrawRect( 0, 26, w, h );

	surface.SetDrawColor( 32, 32, 32 );
	surface.DrawOutlinedRect( 0, 0, w, h );
	surface.DrawOutlinedRect( 0, 0, w, 26 );
end 

function PANEL:OnRemove()
	timer.Remove( "divLabelUpdate" );

	if ( divisions.PANEL ) then divisions.PANEL = nil; end 
end 

---------------------------------------------------------------------------
	-- Registering the panel.
---------------------------------------------------------------------------

vgui.Register( "divisionsMenu", PANEL, "DFrame" );

---------------------------------------------------------------------------
	-- Console commands.
---------------------------------------------------------------------------
	
local function open()
	vgui.Create( "divisionsMenu" );
end 

concommand.Add( "divisions_open", open );