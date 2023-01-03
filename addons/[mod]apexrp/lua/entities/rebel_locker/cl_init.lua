include("shared.lua")

function ENT:Draw()
    self:DrawModel()

    if LocalPlayer():GetEyeTrace().Entity == self and EyePos():Distance(self:GetPos()) < 512 then
        hook.Add("PreDrawHalos", "Halo", function()
            if LocalPlayer():Team() == TEAM_CITIZEN then
                halo.Add({self}, Color(0, 0, 255), 0, 0, 0)
            end
        end)
    end
end


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
local rebelMenu;

function PANEL:Init()
	if ( IsValid( rebelMenu ) ) then 
		rebelMenu:Remove();
		self:Remove();

		return;
	end 

	local ply = LocalPlayer();
	
	rebelMenu = self;

	self:SetSize( ScrW() * .5, ScrH() * .5 );
	self:Center();
	self:MakePopup();
	self:SetTitle( "Rebel Locker" );
	self:ShowCloseButton( false );


	self.divMenu = self:Add( "DScrollPanel" );
	self.divMenu:SetPos( 5, 55 ); 
	self.divMenu:SetSize( ScrW() * .12, ScrH() * .2 );

	local scroll = self.divMenu:GetVBar();

	function scroll.btnUp:Paint( w, h )
		surface.SetDrawColor(0, 64, 0);
		surface.DrawOutlinedRect( 0, 0, w, h );
	end 

	function scroll.btnDown:Paint( w, h )
		surface.SetDrawColor(0, 64, 0);
		surface.DrawOutlinedRect( 0, 0, w, h );
	end 

	function scroll.btnGrip:Paint( w, h )
		surface.SetDrawColor(0, 64, 0);
		surface.DrawOutlinedRect( 0, 0, w, h );
	end

	for id, div in pairs( vests ) do  
		if (ply:Team() ~= TEAM_CITIZEN) then  continue; end 
	
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
				col = Color(0, 64, 0);
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
			
			self.divDesc:SetText("");
			self.divDesc:InsertColorChange( 255, 255, 255, 255 );
			self.divDesc:AppendText( "Price:\n " .. ( div.price or "FREE OF CHARGE" ) .. "\n" );
			self.divDesc:InsertColorChange( 255, 255, 255, 255 );
			self.divDesc:AppendText( "\nVest name:\n " .. ( div.name or "Unknown" ) .. "\n" );
			self.divDesc:AppendText("Description: \n " .. (div.desc or "Unknown"));
			
			if (div.price) and not ( ply:canAfford(div.price) ) then 
				self.divXP:SetTextColor( Color( 153, 0, 0 ) );
				self.divXP:SetText( "  You do not have enough tokens for this vest." );
			else 
				self.divXP:SetTextColor( Color( 0, 153, 0 ) );
				self.divXP:SetText( "  You have enough tokens for this vest/" );
			end 
			
			self.divLabel:SetText( "  Rebel Locker - Your money: " .. ply:getXP() );
          
            self.modelPnl:SetModel("models/hl2rp/male_03.mdl");
            self.modelPnl.Entity:SetBodygroup(11, div.bodygroup);
            local headPos = self.modelPnl.Entity:GetBonePosition( self.modelPnl.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) or 0 );
            self.modelPnl:SetLookAt( headPos );
            self.modelPnl:SetCamPos( headPos - Vector( -60, 0, 0 ) );
		end 
	end 

	self.divLabel = self:Add( "DLabel" );
	self.divLabel:SetPos( 5, 30 );
	self.divLabel:SetSize( ScrW() * .12, 25 );
	self.divLabel:SetTextColor( Color( 255, 255, 255 ) );
	self.divLabel:SetText( "  Vest Tiers" );

	function self.divLabel:Paint( w, h )
		surface.SetDrawColor(0, 64, 0);
		surface.DrawRect( 0, 0, w, h );
	end 

	self.divDescLabel = self:Add( "DLabel" );
	self.divDescLabel:SetPos( 5, ScrH() * .2 + 60 );
	self.divDescLabel:SetSize( ScrW() * .12, 25 );
	self.divDescLabel:SetTextColor( Color( 255, 255, 255 ) );
	self.divDescLabel:SetText( "  Vest information" );

	function self.divDescLabel:Paint( w, h )
		surface.SetDrawColor(0, 64, 0);
		surface.DrawRect( 0, 0, w, h );
	end  

	self.divDesc = self:Add( "RichText" );
	self.divDesc:SetPos( 5, 85 + ScrH() * .2 );
	self.divDesc:SetSize( ScrW() * .12, self:GetTall() - ( 110 + ScrH() * .2 ) - 5 );

	function self.divDesc:Paint( w, h )
		surface.SetDrawColor( 32, 32, 32, 150 )
		surface.DrawRect( 0, 0, w, h );

		surface.SetDrawColor(0, 64, 0);
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
	self.modelLabel:SetText( "  Vest preview - NO TOUCHING!" );

	function self.modelLabel:Paint( w, h )
		surface.SetDrawColor(0, 64, 0);
		surface.DrawRect( 0, 0, w, h );
	end  

	self.divXP = self:Add( "DLabel" );
	self.divXP:SetPos( 5, self:GetTall() - 30 );
	self.divXP:SetSize( ScrW() * .12, 25 );
	self.divXP:SetTextColor( Color( 255, 255, 255 ) );
	self.divXP:SetText( "" );

	function self.divXP:Paint( w, h )
		surface.SetDrawColor(0, 64, 0);
		surface.DrawRect( 0, 0, w, h );
	end  

	self.modelBck = self:Add( "DPanel" );
	self.modelBck:SetPos(self.divDesc:GetWide() + 10, 54);
	self.modelBck:SetSize( self:GetWide() - ( 20 + ScrW() * .24 ), self:GetTall() - 114 );

	function self.modelBck:Paint( w, h )
		surface.SetDrawColor(0, 64, 0);
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
		surface.SetDrawColor(0, 64, 0);
		surface.DrawOutlinedRect( 0, 0, w, h );
	end 

	function self.closeButton:DoClick()
		self:GetParent():Remove();
	end


	self.getDiv = self:Add( "DButton" );
	self.getDiv:SetPos( self.divDesc:GetWide() + 10, self:GetTall() - 55 );
	self.getDiv:SetSize( self:GetWide() - (self.divDesc:GetWide() + 15 ), 50 );
	self.getDiv:SetTextColor( Color( 255, 255, 255 ) );
	self.getDiv:SetText( "Buy vest" );
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
		surface.SetDrawColor(0, 64, 0);
		surface.DrawRect( 0, 0, w, h );
	end 
end 

function PANEL:Paint( w, h )
	surface.SetDrawColor(0, 64, 0);
	surface.DrawRect( 0, 0, w, 25 );

	surface.SetDrawColor( 32, 32, 32, 150 );
	surface.DrawRect( 0, 26, w, h );

	surface.SetDrawColor(0, 64, 0);
	surface.DrawOutlinedRect( 0, 0, w, h );
	surface.DrawOutlinedRect( 0, 0, w, 26 );
end 

function PANEL:OnRemove()
	if ( rebelMenu ) then rebelMenu = nil; end 
end 

---------------------------------------------------------------------------
	-- Registering the panel.
---------------------------------------------------------------------------

vgui.Register( "rebelLocker", PANEL, "DFrame" );

---------------------------------------------------------------------------
	-- Open the panel.
---------------------------------------------------------------------------

local function open()
	vgui.Create( "rebelLocker" );
end 
concommand.Add( "rg_locker", open );



















local ply = LocalPlayer()
local pIsRebel = false
local pIsMedic = false
local boughtHealthp = false
local boughtPlate = false


net.Receive("plockerFunc", function()
    local ply = LocalPlayer();
    local pFrame = vgui.Create("DFrame") -- Creates the derma panel
    pFrame:SetVisible(true)
    pFrame:SetSize(960, 540)
    pFrame:Center()
    pFrame:MakePopup()
    pFrame:SetTitle("pLocker")
    pFrame:SetPaintBorderEnabled(false)
    pFrame:ShowCloseButton(false)

    --[[pFrame.Paint = function() -- Paint function

            surface.SetDrawColor( 50, 50, 50, 255 ) -- Set our rect color below us; we do this so you can see items added to this panel
            surface.DrawRect( 0, 0, pFrame:GetWide(), pFrame:GetTall() )

        end--]]
    -- 'function Frame:Paint( w, h )' works too
    pFrame.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
        draw.RoundedBox(0, 0, 0, w, 25, Color(73, 147, 197, 150)) -- Draw a red box instead of the fram
    end

    pcitizenModel = vgui.Create("DModelPanel", pFrame) -- Creates the citizen model
    pcitizenModel:SetPos(-50, -70)
    pcitizenModel:SetSize(400, 470)

    if pIsRebel == true then
        pcitizenModel:SetModel(string.Replace(ply:GetModel(), "group03", "group01"))
    end

    if pIsMedic == true then
        pcitizenModel:SetModel(string.Replace(ply:GetModel(), "group03m", "group01"))
    end

    if pIsMedic == false and pIsRebel == false then
        pcitizenModel:SetModel(string.Replace(ply:GetModel(), "group01", "group01"))
    end

    local rebelModel = vgui.Create("DModelPanel", pFrame) -- Creates the rebel model
    rebelModel:SetPos(285, -70)
    rebelModel:SetSize(400, 470)

    if pIsMedic == true then
        rebelModel:SetModel(string.Replace(ply:GetModel(), "group03m", "group03"))
        rebelModel.Entity:SetBodygroup(1, 33)
        rebelModel.Entity:SetBodygroup(2, 12)
        rebelModel.Entity:SetBodygroup(3, 1)
        rebelModel.Entity:SetBodygroup(4, 2)
    end

    if pIsRebel == true then
        rebelModel:SetModel(string.Replace(ply:GetModel(), "group03", "group03"))
        rebelModel.Entity:SetBodygroup(1, 33)
        rebelModel.Entity:SetBodygroup(2, 12)
        rebelModel.Entity:SetBodygroup(3, 1)
        rebelModel.Entity:SetBodygroup(4, 2)
    end

    if pIsRebel == false and pIsMedic == false then
        rebelModel:SetModel(string.Replace(ply:GetModel(), "group01", "group03"))
        rebelModel.Entity:SetBodygroup(1, 33)
        rebelModel.Entity:SetBodygroup(2, 12)
        rebelModel.Entity:SetBodygroup(3, 1)
        rebelModel.Entity:SetBodygroup(4, 2)
    end

    local medicModel = vgui.Create("DModelPanel", pFrame) -- Creates the rebel medic model
    medicModel:SetPos(600, -70)
    medicModel:SetSize(400, 470)

    if pIsRebel == true then
        medicModel:SetModel(string.Replace(ply:GetModel(), "group03", "group03m"))
        medicModel.Entity:SetBodygroup(1, 26)
        medicModel.Entity:SetBodygroup(2, 12)
        medicModel.Entity:SetBodygroup(3, 1)
        medicModel.Entity:SetBodygroup(4, 2)
    end

    if pIsMedic == true then
        medicModel:SetModel(string.Replace(ply:GetModel(), "group03m", "group03m"))
        medicModel.Entity:SetBodygroup(1, 26)
        medicModel.Entity:SetBodygroup(2, 12)
        medicModel.Entity:SetBodygroup(3, 1)
        medicModel.Entity:SetBodygroup(4, 2)
    end

    if pIsMedic == false and pIsRebel == false then
        medicModel:SetModel(string.Replace(ply:GetModel(), "group01", "group03m"))
        medicModel.Entity:SetBodygroup(1, 26)
        medicModel.Entity:SetBodygroup(2, 12)
        medicModel.Entity:SetBodygroup(3, 1)
        medicModel.Entity:SetBodygroup(4, 2)
    end

    local rebelButton = vgui.Create("DButton", pFrame) -- Creates the rebel button
    rebelButton:SetPos(410, 350)
    rebelButton:SetSize(150, 25)
    rebelButton:SetFont("Trebuchet24")
    rebelButton:SetText("Become a Rebel")
    rebelButton:SetColor(Color(255, 255, 255))

    rebelButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 100)) -- Draw a blue button
    end

    -- if pIsRebel == true then
    --     rebelButton:SetEnabled(false)
    -- end

    rebelButton.DoClick = function()
        -- if pIsMedic == true then
        --     pFrame:Close()
        --     ply:ChatPrint("You are already have Rebel Clothes!")

        --     return
        -- end

        pFrame:Close()
        net.Start("rbuttonFunc", false)
        net.SendToServer()
        pIsRebel = true
        pIsMedic = false
    end

    local citizenButton = vgui.Create("DButton", pFrame) -- Creates the citizen button
    citizenButton:SetPos(75, 350)
    citizenButton:SetSize(150, 25)
    citizenButton:SetFont("Trebuchet24")
    citizenButton:SetText("Become a Citizen")
    citizenButton:SetColor(Color(255, 255, 255))

    citizenButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 100)) -- Draw a blue button
    end

    -- if pIsRebel == false and pIsMedic == false then
    --     citizenButton:SetEnabled(false)
    -- end

    citizenButton.DoClick = function()
        pFrame:Close()
        net.Start("cbuttonFunc", false)
        net.SendToServer()
        pIsRebel = false
        pIsMedic = false
        boughtHealthp = false
        boughtPlate = false
    end

    local medicButton = vgui.Create("DButton", pFrame) -- Creates the citizen button
    medicButton:SetPos(725, 350)
    medicButton:SetSize(150, 25)
    medicButton:SetFont("Trebuchet24")
    medicButton:SetText("Become a Medic")
    medicButton:SetColor(Color(255, 255, 255))

    medicButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 100)) -- Draw a blue button
    end

    -- if pIsMedic == true then
    --     medicButton:SetEnabled(false)
    -- end

    medicButton.DoClick = function()
        --[[ if ply.wmSkl.Medical <= 2 and pIsRebel == false then
                
                pFrame:Close()
                ply:ChatPrint("You aren't worthy of wearing this uniform (come back when your medical skill is 3.")

            return end--]]
        -- if pIsRebel == true then
        --     pFrame:Close()
        --     ply:ChatPrint("You are already have Rebel Clothes!")

        --     return
        -- end

        pFrame:Close()
        net.Start("mbuttonFunc", false)
        net.SendToServer()
        pIsMedic = true
        pIsRebel = false
    end

    local plateButton = vgui.Create("DButton", pFrame)
    plateButton:SetSize(330, 75)
    plateButton:SetFont("Trebuchet24")
    plateButton:SetPos(45, 409)
    plateButton:SetColor(Color(255, 255, 255))
    plateButton:SetText("Buy additional armor plating - 250")

    plateButton.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(41, 128, 185, 100)) -- Draw a blue button
    end

    plateButton.DoClick = function()
        if ply:Armor() >= 50 then
            pFrame:Close()
            ply:ChatPrint("Your vest can't hold more kevlar plates.")

            return
        end

        if not LocalPlayer():GetNWBool("IsRebelScum") then
            pFrame:Close()
            ply:ChatPrint("You must wear Rebel Clothes to use this.")

            return
        end

        -- if boughtPlate == true then 
        --     pFrame:Close()
        --     ply:ChatPrint("Out of stock. Come back next time.")
        -- return end 
        if ply.DarkRPVars.money <= 249 then
            pFrame:Close()
            ply:ChatPrint("You do not have enough money to buy this.")

            return
        end

        -- if boughtPlate == false and ply.DarkRPVars.money >= 150 then 
        if ply.DarkRPVars.money >= 250 then
            pFrame:Close()
            net.Start("platebutton", false)
            net.SendToServer()
            boughtPlate = true
        end
    end

    local healthButton = vgui.Create("DButton", pFrame)
    healthButton:SetSize(330, 75)
    healthButton:SetPos(595, 409)
    healthButton:SetFont("Trebuchet24")
    healthButton:SetColor(Color(255, 255, 255))
    healthButton:SetText("Buy medical supplies - 1000T")

    healthButton.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(41, 128, 185, 100)) -- Draw a blue button
    end

    healthButton.DoClick = function()
        -- if pIsRebel == false and pIsMedic == false then
        --     pFrame:Close()
        --     ply:ChatPrint("You must wear Rebel Clothes to use this.")

        --     return
        -- end

        -- if boughtHealthp == true then 
        --     pFrame:Close()
        --     ply:ChatPrint("Out of stock. Come back next time.")
        -- return end 
        if ply:Health() >= 90 then
            pFrame:Close()
            ply:ChatPrint("Come back when you are actually injured. (<= 90HP.)")

            return
        end

        if ply.DarkRPVars.money <= 999 then
            pFrame:Close()
            ply:ChatPrint("You do not have enough money to buy this.")

            return
        end

        if boughtHealthp == false and ply.DarkRPVars.money >= 200 then
            pFrame:Close()
            net.Start("healthbutton", false)
            net.SendToServer()
            -- boughtHealthp = true
        end
    end

    local closeButton = vgui.Create("DButton", pFrame)
    closeButton:SetSize(20, 20)
    closeButton:SetPos(937, 3)
    closeButton:SetText("X")
    closeButton:SetFont("Trebuchet24")
    closeButton:SetColor(Color(255, 0, 0))

    closeButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 100)) -- Draw a blue button
    end

    closeButton.DoClick = function()
        pFrame:Close()
    end
end)

--[[if pIsMedic == true then
            
        medicModel:SetColor(Color(0,255,0))
        rebelModel:SetColor(Color(255, 255, 255))
        citizenModel:SetColor(Color(255, 0, 0))

    end  

    if pIsRebel == true then
            
        medicModel:SetColor(Color(255,0,0))
        rebelModel:SetColor(Color(0, 255, 0))
        citizenModel:SetColor(Color(255, 255, 255))

    end

    if pIsRebel == false and pIsMedic == false then
        
        medicModel:SetColor(Color(255,255,255))
        rebelModel:SetColor(Color(255, 255, 255))
        citizenModel:SetColor(Color(0, 255, 0))

    end --]]
net.Receive("modelthing", function()
    pIsRebel = false
    pIsMedic = false
    boughtHealthp = false
    boughtPlate = false
end)