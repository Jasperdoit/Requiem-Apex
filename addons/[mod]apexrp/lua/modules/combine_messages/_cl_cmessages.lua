return

---------------------------------------------------------------------------
	-- Font.
---------------------------------------------------------------------------
print("loaded combine messages!");

surface.CreateFont( "VCR18", {
	font = "VCR OSD Mono", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 18,
	weight = 100,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} );

---------------------------------------------------------------------------
	-- Global table.
---------------------------------------------------------------------------

combineMessages = combineMessages or {
    randMsgs = {}
};

---------------------------------------------------------------------------
	-- Adding random messages.
---------------------------------------------------------------------------

combineMessages.randMsgs = {
    [ 1 ] = function()
        combineMessages:add( Color( 255, 255, 255 ), "Monitoring vital signs" )
    
        timer.Simple( 3, function()
            if ( LocalPlayer():Health() >= 90 ) then 
                combineMessages:add( Color( 0, 255, 0 ), "Vital signs green" );
            elseif ( LocalPlayer():Health() < 90 ) and ( LocalPlayer():Health() >= 50 ) then 
                combineMessages:add( Color( 255, 255, 0 ), "Vital signs yellow" );
            else 
                combineMessages:add( Color( 255, 0, 0 ), "Vital signs red" );
            end  
        end );
    end,
    [ 2 ] = function()
        local x, y, z = math.Round( LocalPlayer():GetPos().x ), math.Round( LocalPlayer():GetPos().y ), math.Round( LocalPlayer():GetPos().z );

        combineMessages:add( Color( 255, 255, 255 ), "Re-adjusting city grid location to " .. x .. ", " .. y .. ", " .. z );
    end,
    [ 3 ] = function()
        combineMessages:add( Color( 255, 255, 255), "Updating citizen registry" );
    end,
    [ 4 ] = function()
        combineMessages:add( Color( 255, 255, 255), "Uploading status to bio-signal registry" );
    end, 
    [ 5 ] = function()
		if math.random(1, 6) == 6 then 
			combineMessages:add( Color( 255, 0, 0), "Memory module is full, deleting cached messages" );

			timer.Simple( 4, function()
				combineMessages.GUI:Clear();
				combineMessages:add( Color( 0, 255, 0), "Successfully cleared memory module" );
				
			end );
		end 
    end, 
    [ 6 ] = function()
        combineMessages:add( Color( 255, 255, 255), "Re-adjusting vocoder settings" );
    end,
    [ 7 ] = function()
        combineMessages:add( Color( 255, 255, 255 ), "Detecting " .. #player.GetAll() .. " life count" );
    end, 
    [ 8 ] = function()
        combineMessages:add( Color( 255, 255, 255 ), "Updating anti-citizen registry" );
    end, 
    [ 9 ] = function()
        combineMessages:add( Color( 255, 255, 255 ), "Running diagnostics" );
    end, 
    [ 10 ] = function()
        combineMessages:add( Color( 255, 255, 255 ), "Modulating temperature levels" );
    end, 
    [ 11 ] = function()
        combineMessages:add( Color( 255, 255, 255 ), "Synchronizing local PT data" );
    end, 
    [ 12 ] = function()
        combineMessages:add( Color( 255, 255, 0 ), "Pinging network connection…" );

        timer.Simple( 2, function()
            local ping = LocalPlayer():Ping();

            if ( ping <= 70 ) then 
                combineMessages:add( Color( 0, 255, 0 ), "Pinging successfull, connection stable" );
            elseif( ping > 70 ) and ( ping <= 180 ) then 
                combineMessages:add( Color( 255, 255, 0 ), "Pinging successfull, connection average" );
            else
                combineMessages:add( Color( 255, 0, 0 ), "Pinging successfull, connection unstable" );
            end 
        end );
    end, 
}

---------------------------------------------------------------------------
	-- Functions.
---------------------------------------------------------------------------

function combineMessages:add( col, msg )
    if not ( IsValid( self.GUI ) ) then 
        return;
    end 

    if not ( col ) or not ( msg ) then 
        return;
    end 

    local color = col;
    local text = msg; 

    self.GUI:add( color, text );
end  

---------------------------------------------------------------------------
	-- Callbacks.
---------------------------------------------------------------------------

net.Receive( "combineMessagesCreate", function()    
    vgui.Create( "combineMessages" );
end );

net.Receive( "combineMessagesAdd", function()
    local text = net.ReadString();
    local color = net.ReadColor();

    combineMessages:add( color, text );
end );

---------------------------------------------------------------------------
	-- Creating the panel.
---------------------------------------------------------------------------

local PANEL = {};

function PANEL:Init()
    if ( IsValid( combineMessages.GUI ) ) then
        combineMessages.GUI:Remove();
		self:Remove();
		
		return;
    end 

    combineMessages.GUI = self;

    self.msgs = {};
    self.randomMessage = CurTime() + math.random( 10, 20 );
    self:SetPos( 0, 41 );
    self:SetSize( ScrW(), 160 );
   -- self:SetPos( ScrW() - ScrW() * .4 - 2, 41 );
   -- self:SetSize( ScrW() * .4, 160 );
    self:GetVBar():SetWide( 0 );
    
end 

function PANEL:add( color, msg )
    local id = table.insert( self.msgs, self:Add( "DLabel") );
    self.msgs[ id ]:SetSize( self:GetWide(), 16 );
    self.msgs[ id ]:Dock( TOP );
	self.msgs[ id ]:DockMargin(0, 0, 0, 1);
    self.msgs[ id ]:SetFont( "VCR18" );
	self.msgs[ id ]:SetTextColor(Color(0, 0, 0));
    self.msgs[ id ].text = "";
	self.msgs[ id ]:SetContentAlignment( 6 );
    self.msgs[ id ].time = 0;
    self.msgs[ id ].index = 0;
	self.msgs[ id ].color = color;
	self.msgs[ id ].color.a = 200;

    -- LocalPlayer():EmitSound( "buttons/blip1.wav" );
	
    self.msgs[ id ].Think = function( _self )
        if ( _self.time < CurTime() ) and ( #msg ~= _self.index ) then 
            _self.time = CurTime() + 0.05;

            _self.index = _self.index + 1;
            _self.text = _self.text .. msg[ _self.index ]:upper();
            
            if ( #msg == _self.index ) then 
                _self:SetText( _self.text .. " ::>" );
                _self.Think = function() end return; end 

            _self:SetText( _self.text );
        end  
    end 

	surface.SetFont("VCR18");
    self.msgs[ id ].Paint = function( _self, w, h )
        surface.SetDrawColor(255, 255, 255, 0);
        surface.DrawRect(0, 0, w, h);
		
        local w1 = surface.GetTextSize(_self:GetText());
        
		surface.SetDrawColor(_self.color);
		surface.DrawRect(w - w1, 0, w, h);
		
		surface.SetDrawColor( 32, 32, 32 );
		surface.DrawOutlinedRect( w - w1, 0, w + 5, h, 1);
	end 
   
    self:InvalidateChildren( true )
    self:ScrollToChild( self.msgs[ #self.msgs ] );
end 


function PANEL:Think()
    if not ( LocalPlayer():isCombine() ) then 
        combineMessages.GUI:Remove();    
    
        self:Remove();
    end 

    if ( self.randomMessage < CurTime() ) then 
        self.randomMessage = CurTime() + math.random( 60, 120 );

        combineMessages.randMsgs[ math.random( 1, #combineMessages.randMsgs) ]();
    end 
end 

vgui.Register( "combineMessages", PANEL, "DScrollPanel" );

local function reload(ply)
    if not (ply:isCombine()) then return; end 
    
    combineMessages.GUI:Remove();
    vgui.Create( "combineMessages" );
    
    print("reloaded combine messages!");
end

concommand.Add("rg_reloadmsg", reload);