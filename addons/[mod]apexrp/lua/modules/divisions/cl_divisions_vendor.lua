---------------------------------------------------------------------------
	-- Division PANEL.
---------------------------------------------------------------------------

local PANEL = {};

---------------------------------------------------------------------------
	-- Panel functions.
---------------------------------------------------------------------------

function PANEL:Init()
	if ( IsValid( divisions.VENDOR ) ) then 
		divisions.VENDOR:Remove();
		self:Remove();

		return;
	end 

    local ply = LocalPlayer();
    divisions.VENDOR = self;
	self.font = "RobotoMono48";
	self.sc = ply:getSC();
	self.cost = 0;
	
	if (ScrW() <= 1280) then 
		self.font = "RobotoMono32";
	end 
	
	self:SetSize( ScrW() * .5, ScrH() * .5 );
	self:Center();
	self:MakePopup();
	self:SetTitle( "Divisions Vendor" );
	self:ShowCloseButton( false );
	self.weps = {};

    self.closeButton = self:Add( "DButton" );
	self.closeButton:SetSize( 20, 20 );
	self.closeButton:SetPos( self:GetWide() - 23, 3 );
	self.closeButton:SetText( "X" );
    self.closeButton:SetTextColor( Color( 255, 255, 255 ) );
    
    function self.closeButton:DoClick()
		self:GetParent():Remove();
	end 

	function self.closeButton:Paint( w, h )
		surface.SetDrawColor( 32, 32, 32 );
		surface.DrawOutlinedRect( 0, 0, w, h );
    end 

    if not ( ply:getDivision() > 0 ) then 
        self.blocked = self:Add( "DPanel" );
        self.blocked:SetPos( 0, 25 );
        self.blocked:SetSize( self:GetWide(), self:GetTall() - 25 );

        function self.blocked:Paint( w, h )
            surface.SetDrawColor( 32, 32, 32, 240 );
            surface.DrawRect( 0, 0, w, h );

            draw.SimpleText( "ACCESS DENIED!", "BudgetLabel", w / 2, h / 2 - 10, Color( 153, 0, 0 ), TEXT_ALIGN_CENTER );
        end 

        return;
    end 
    
	self.itemPanel = self:Add("DPanel");
	self.itemPanel:SetPos(5, 30);
	self.itemPanel:SetSize(self:GetWide() * .7, self:GetTall() - 35);
	function self.itemPanel:Paint( w, h )
        surface.SetDrawColor( 32, 32, 32 );
        surface.DrawOutlinedRect( 0, 0, w, h );
    end 
	
	self.itemPanel.label1 = self.itemPanel:Add("DLabel")
	self.itemPanel.label1:SetPos(0, 0);
    self.itemPanel.label1:SetSize( self.itemPanel:GetWide(), 64 );
    self.itemPanel.label1:SetTextColor( Color( 255, 255, 255 ) );
    self.itemPanel.label1:SetFont( self.font );
    self.itemPanel.label1:SetContentAlignment( 5 );
    self.itemPanel.label1:SetText( "Issued Weapons" );
	
	function self.itemPanel.label1:Paint( w, h )
        surface.SetDrawColor( 32, 32, 32 );
        surface.DrawRect( 0, 0, w, h );
    end 
	
	self.itemPanel.cPanel = self.itemPanel:Add("DPanel");
	self.itemPanel.cPanel:SetPos(0, self.itemPanel:GetTall() - 70);
	self.itemPanel.cPanel:SetSize( self.itemPanel:GetWide(), 70);
	
	function self.itemPanel.cPanel:Paint(w, h)
		surface.SetDrawColor( 32, 32, 32);
		surface.DrawRect( 0, 0, w, h);
	end 
	
	self.itemPanel.cPanel.confirm = self.itemPanel.cPanel:Add("DButton");
	self.itemPanel.cPanel.confirm:SetPos(self.itemPanel.cPanel:GetWide() - 96, 0);
	self.itemPanel.cPanel.confirm:SetSize(96, self.itemPanel.cPanel:GetTall());
	self.itemPanel.cPanel.confirm:SetText("CNV");
	self.itemPanel.cPanel.confirm:SetFont(self.font);
	self.itemPanel.cPanel.confirm:SetTextColor(Color( 255, 255, 255));
	self.itemPanel.cPanel.confirm.DoClick = function(_self)
		if not (self.itemPanel.cPanel.input:GetInt()) then 
			ply:EmitSound("buttons/combine_button3.wav");
			return;
		end 
		
		local tokens = math.abs(self.itemPanel.cPanel.input:GetInt());
		local conversion = math.floor(tokens / divisions.rate);
		
		if (tokens > ply:getDarkRPVar("money", 0)) or (conversion == 0) then 
			ply:EmitSound("buttons/combine_button3.wav");
			return;
		end 
		
		net.Start("scConvert");
			net.WriteInt(tokens, 16);
		net.SendToServer();
		
		ply:EmitSound("buttons/combine_button1.wav");
		_self:SetDisabled(true);
		self.itemPanel.cPanel.input:SetEditable(false);
		self.itemPanel.cPanel.input:SetValue("");
		
		self.itemPanel.cPanel.text:SetText("");
		self.receiptPanel.confirm:SetDisabled(true);
		self.itemPanel.cPanel.text:InsertColorChange(0, 153, 0, 255);
		self.itemPanel.cPanel.text:AppendText("Processing conversion...");
		
		timer.Simple(2, function()
			if not (IsValid(self)) then return; end 
			
			self.itemPanel.cPanel.text:SetText("");
			self.itemPanel.cPanel.text:InsertColorChange(0, 153, 0, 255);
			self.itemPanel.cPanel.text:AppendText("Conversion successful!");
			
			_self:SetDisabled(false);
			self.receiptPanel.confirm:SetDisabled(false);
			
			timer.Simple( 0.5, function() 
				if not (IsValid(self)) then return; end 
				self.itemPanel.cPanel.input:SetEditable(true);
				self:updateText();
				self.sc = ply:getSC();
			end );
		end )
	end 
	
	function self.itemPanel.cPanel.confirm:Paint(w, h)
		surface.SetDrawColor(32, 32 ,32 );
		surface.DrawRect(0, 0, w, h);
	end 
	
	self.itemPanel.cPanel.input = self.itemPanel.cPanel:Add("DTextEntry");
	self.itemPanel.cPanel.input:SetPos(self.itemPanel.cPanel:GetWide() - self.itemPanel.cPanel:GetWide() * 0.2 - self.itemPanel.cPanel.confirm:GetWide(), 0);
	self.itemPanel.cPanel.input:SetSize(self.itemPanel.cPanel:GetWide() * 0.2, self.itemPanel.cPanel:GetTall());
	self.itemPanel.cPanel.input:SetNumeric(true);
	self.itemPanel.cPanel.input:SetFont(self.font);
	self.itemPanel.cPanel.input:SetUpdateOnType(true);
	self.itemPanel.cPanel.input.OnValueChange = function(_self, value)
		self:updateText();
	end 
	
	self.itemPanel.cPanel.text = self.itemPanel.cPanel:Add("RichText");
	self.itemPanel.cPanel.text:SetPos(0, 0);	
	self.itemPanel.cPanel.text:SetSize(self.itemPanel:GetWide() - self.itemPanel.cPanel.input:GetWide() - self.itemPanel.cPanel.confirm:GetWide(), self.itemPanel.cPanel:GetTall());
	
	function self:updateText() 
		self.itemPanel.cPanel. text:SetText("");
		self.itemPanel.cPanel.text:InsertColorChange(255, 255, 255, 255);
		self.itemPanel.cPanel.text:AppendText("The current conversion rate is: ");
		self.itemPanel.cPanel.text:InsertColorChange(0, 153, 0, 255);
		self.itemPanel.cPanel.text:AppendText((divisions.rate or -1) .. "T per SC.\n");
		self.itemPanel.cPanel.text:InsertColorChange(255, 255, 255, 255);
		self.itemPanel.cPanel.text:AppendText("Currently on yourself you have: ");
		self.itemPanel.cPanel.text:InsertColorChange(0, 153, 0, 255);
		self.itemPanel.cPanel.text:AppendText(ply:getDarkRPVar( "money", 0) .. "T, " .. ply:getSC() .. "SC\n");
		self.itemPanel.cPanel.text:InsertColorChange(255, 255, 255, 255);
		self.itemPanel.cPanel.text:AppendText("With your current wallet, you can get: ");
		self.itemPanel.cPanel.text:InsertColorChange(0, 153, 0, 255);
		self.itemPanel.cPanel.text:AppendText(math.floor(ply:getDarkRPVar("money", 0) / divisions.rate) .. "SC\n");
		
		if (self.itemPanel.cPanel.input:GetInt()) then 
			if (self.itemPanel.cPanel.input:GetInt() > ply:getDarkRPVar("money", 0)) then 
				self.itemPanel.cPanel.text:InsertColorChange(153, 0, 0, 255);
				self.itemPanel.cPanel.text:AppendText("You entered more tokens than you have on you!");
			else 
				local conversion = math.floor(math.abs(self.itemPanel.cPanel.input:GetInt()) / divisions.rate);
				
				if (conversion == 0) then 
					self.itemPanel.cPanel.text:InsertColorChange(153, 0, 0, 255)
					self.itemPanel.cPanel.text:AppendText("You will gain nothing from this conversion!");
				else 
					self.itemPanel.cPanel.text:InsertColorChange(0, 153, 0, 255);
					self.itemPanel.cPanel.text:AppendText("Converting will get you: " .. conversion .. "SC");
				end 
			end 
		else 
			self.itemPanel.cPanel.text:InsertColorChange(153, 0, 0, 255);
			self.itemPanel.cPanel.text:AppendText("Impossible to do a conversion!");
		end 
	end 
	
	self:updateText();
	
	function self.itemPanel.cPanel.text:PerformLayout()
		self:SetFontInternal( "BudgetLabel" );
		self:SetFGColor(Color(255, 255, 255))
	end
	
	
    self.itemPanel.list = self.itemPanel:Add( "DScrollPanel" );
    self.itemPanel.list:SetPos( 0, self.itemPanel.label1:GetTall() + 5 );
    self.itemPanel.list:SetSize( self.itemPanel:GetWide(), self.itemPanel:GetTall() - self.itemPanel.cPanel:GetTall() - self.itemPanel.label1:GetTall() - 10 );
    self.itemPanel.list:GetVBar():SetWide( 0 );
	
	for _, wep in ipairs(divisions.Vendor) do 
		self.itemPanel.list.pnl = self.itemPanel.list:Add( "DPanel" );
		self.itemPanel.list.pnl:Dock( TOP );
		self.itemPanel.list.pnl:SetTall( 64 );
		self.itemPanel.list.pnl:DockMargin( 5, 0, 5, 5 );
		function self.itemPanel.list.pnl:Paint(w, h)
			surface.SetDrawColor(32, 32, 32);
			surface.DrawOutlinedRect(0, 0, w, h);
			surface.DrawOutlinedRect(2, 2, 62, 60);
		end 
		
		self.itemPanel.list.pnl.mdl = self.itemPanel.list.pnl:Add( "SpawnIcon" );
		self.itemPanel.list.pnl.mdl:SetPos( 3, 3 ); -- 0, 0
		self.itemPanel.list.pnl.mdl:SetSize( 59, 59 );
		self.itemPanel.list.pnl.mdl:SetModel( wep.model or "models/weapons/w_pist_fiveseven.mdl");
		self.itemPanel.list.pnl.mdl:SetDisabled( true );
		self.itemPanel.list.pnl.mdl.PaintOver = function() end
		self.itemPanel.list.pnl.mdl.PerformLayout = function() end 
		
		self.itemPanel.list.pnl.name = self.itemPanel.list.pnl:Add("DLabel");
		self.itemPanel.list.pnl.name:SetPos(65, 2);
		self.itemPanel.list.pnl.name:SetSize(self.itemPanel.list:GetWide() - 77, 32);
		self.itemPanel.list.pnl.name:SetFont("RobotoMono24");
		self.itemPanel.list.pnl.name:SetTextColor(Color( 255, 255, 255));
		self.itemPanel.list.pnl.name:SetText(" " .. (wep.name or "Some retard didn't define the name"));
		function self.itemPanel.list.pnl.name:Paint(w, h)
			surface.SetDrawColor(32, 32, 32);
			surface.DrawRect(0, 0, w, h);
		end 
		self.itemPanel.list.pnl.cost = self.itemPanel.list.pnl:Add("DLabel");
		self.itemPanel.list.pnl.cost:SetPos(65,34);
		self.itemPanel.list.pnl.cost:SetSize(self.itemPanel.list:GetWide() - 177, 28);
		self.itemPanel.list.pnl.cost:SetFont("RobotoMono24");
		self.itemPanel.list.pnl.cost:SetTextColor(Color(255, 255, 255));
		self.itemPanel.list.pnl.cost:SetText(" Cost: " .. (wep.cost or tonumber(-1)) .. "SC");
		
		function self.itemPanel.list.pnl.cost:Paint(w, h)
			surface.SetDrawColor(32, 32, 32);
			surface.DrawOutlinedRect(0, 0, w - 1, h);
		end
		
		self.itemPanel.list.pnl.select = self.itemPanel.list.pnl:Add("DButton");
		self.itemPanel.list.pnl.select:SetPos(self.itemPanel.list:GetWide() - 112, 34);
		self.itemPanel.list.pnl.select:SetSize(100, 28);
		self.itemPanel.list.pnl.select:SetText(">>");
		
		self.itemPanel.list.pnl.select:SetFont("RobotoMono24");
		
		local col;
		if (self.sc < self.cost + wep.cost) or ((type(wep.class) == "string") and ply:HasWeapon(wep.class)) then 
			col = Color(153, 0, 0);
		else 
			col = Color(0, 153, 0);
		end 
		self.itemPanel.list.pnl.select:SetTextColor(col);
		
		self.itemPanel.list.pnl.select.Think = function(_self)	
			local col;
			if ((self.sc < self.cost + wep.cost) or ((type(wep.class) == "string") and ply:HasWeapon(wep.class))) and not (_self.selected) then 
				col = Color(153, 0, 0);
			else 
				if (_self.selected) then 
					col = Color(255, 140, 0);
				else 
					col = Color(0, 153, 0);
				end 
			end 
			_self:SetTextColor(col);
		end 
		
		self.itemPanel.list.pnl.select.DoClick = function(_self)
			if ((self.sc < self.cost + wep.cost) or ((type(wep.class) == "string") and ply:HasWeapon(wep.class))) and not (_self.selected) then 
				ply:EmitSound("buttons/combine_button3.wav");
				return; 
			end 

			if (_self.selected) then 
				self.cost = self.cost - wep.cost;
				self.weps[wep.class] = nil;
				self:updateReceipt();
				
				_self.selected = false;
				_self:SetText(">>");
				
				ply:EmitSound("buttons/combine_button1.wav");
								
				return; 
			end  
			
			self.cost = self.cost + wep.cost;
			self.weps[wep.class] = {wep.name, wep.cost};
			self:updateReceipt();
			_self.selected = true;
			_self:SetText("<<");
			
			ply:EmitSound("buttons/combine_button1.wav");
		end 
		
		function self.itemPanel.list.pnl.select:Paint(w, h)
			surface.SetDrawColor(32, 32, 32);
			surface.DrawOutlinedRect(0, 0, w, h);
		end 	
	end 
	
    self.receiptPanel = self:Add( "DPanel" );
    self.receiptPanel:SetPos( self:GetWide() * .7 + 10, 30 );
    self.receiptPanel:SetSize( self:GetWide() - ( self:GetWide() * .7 ) - 15, self:GetTall() - 35 );

    function self.receiptPanel:Paint( w, h )
        surface.SetDrawColor( 32, 32, 32 );
        surface.DrawOutlinedRect( 0, 0, w, h );
    end
	
	self.receiptPanel.label1 = self.receiptPanel:Add( "DLabel" );
	self.receiptPanel.label1:SetPos(0, 0);
    self.receiptPanel.label1:SetSize( self.receiptPanel:GetWide(), 64 );
    self.receiptPanel.label1:SetTextColor( Color( 255, 255, 255 ) );
    self.receiptPanel.label1:SetFont( self.font );
    self.receiptPanel.label1:SetContentAlignment( 5 );
    self.receiptPanel.label1:SetText( "Receipt" );
	
	function self.receiptPanel.label1:Paint( w, h )
        surface.SetDrawColor( 32, 32, 32 );
        surface.DrawRect( 0, 0, w, h );
    end 
	
	self.receiptPanel.confirm = self.receiptPanel:Add("DButton");
	self.receiptPanel.confirm:SetPos(0, self.receiptPanel:GetTall() - 70);
	self.receiptPanel.confirm:SetSize(self.receiptPanel:GetWide(), 70);
	self.receiptPanel.confirm:SetText("PURCHASE");
	self.receiptPanel.confirm:SetFont(self.font);
	self.receiptPanel.confirm:SetTextColor(Color( 255, 255, 255));
	
	self.receiptPanel.confirm.DoClick = function(_self)
		if (table.IsEmpty(self.weps)) then 
			ply:EmitSound("buttons/combine_button3.wav");
			return;
		end 
		
		local tbl = {}
		
		for id, data in pairs(divisions.Vendor) do 
			if (self.weps[data.class]) then 
				table.insert(tbl, id);
			end 
		end 
	
		net.Start("scBuy");
			net.WriteTable(tbl);
		net.SendToServer();
	
		ply:EmitSound("items/ammo_pickup.wav");
		self:Remove();
	end 
	
	function self.receiptPanel.confirm:Paint(w, h)
		surface.SetDrawColor( 32, 32, 32 );
        surface.DrawRect( 0, 0, w, h );
	end 
	
	self.receiptPanel.receipt = self.receiptPanel:Add("RichText");
	self.receiptPanel.receipt:SetPos(0, self.receiptPanel.label1:GetTall());
	self.receiptPanel.receipt:SetSize(self.receiptPanel:GetWide(), self.receiptPanel:GetTall() - self.receiptPanel.confirm:GetTall() - self.receiptPanel.label1:GetTall());
	self.receiptPanel.receipt:SetText("You haven't selected anything!");
	
	function self:updateReceipt()
		self.receiptPanel.receipt:SetText("");
		self.receiptPanel.receipt:AppendText("You have selected: \n");
		local empty = true;
		
		for wep, data in pairs(self.weps) do 
			empty = false;
			self.receiptPanel.receipt:AppendText(" +" .. data[1]);
			self.receiptPanel.receipt:InsertColorChange(153, 0, 0, 255);
			self.receiptPanel.receipt:AppendText(" (" .. data[2] .. "SC)\n");
			self.receiptPanel.receipt:InsertColorChange(255, 255, 255, 255);
		end 
		
		if (empty) then 
			self.receiptPanel.receipt:SetText("You haven't selected anything!");
		else 
			--self.receiptPanel.receipt:InsertColorChange(255, 255, 255, 255);
			self.receiptPanel.receipt:AppendText("\n----------------------\n Your balance: ");
			self.receiptPanel.receipt:InsertColorChange(0, 153, 0, 255);
			self.receiptPanel.receipt:AppendText(ply:getSC() .. "SC\n");
			self.receiptPanel.receipt:InsertColorChange(255, 255, 255, 255);
			self.receiptPanel.receipt:AppendText(" Total cost: ");
			self.receiptPanel.receipt:InsertColorChange(153, 0, 0, 255);
			self.receiptPanel.receipt:AppendText(self.cost .. "SC\n");
			self.receiptPanel.receipt:InsertColorChange(255, 255, 255, 255);
			self.receiptPanel.receipt:AppendText("----------------------\n Change: ");
			self.receiptPanel.receipt:InsertColorChange(0, 153, 0, 255);
			self.receiptPanel.receipt:AppendText(ply:getSC() - self.cost .. "SC\n");
			self.receiptPanel.receipt:InsertColorChange(255, 255, 255, 255);
			self.receiptPanel.receipt:AppendText("----------------------");
		end 
	end 
	
	function self.receiptPanel.receipt:PerformLayout()
		self:SetFontInternal( "BudgetLabel" );
		self:SetFGColor(Color(255, 255, 255))
	end
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

vgui.Register( "divisionsVendor", PANEL, "DFrame" );

---------------------------------------------------------------------------
	-- Console commands.
---------------------------------------------------------------------------
	
local function open()
	vgui.Create( "divisionsVendor" );
end 

concommand.Add( "divisions_open_vendor", open );