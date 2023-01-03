-- Intro

local intro = {}
local PANEL = {}

function PANEL:Init()
    if (IsValid(intro.gui)) then 
        intro.gui:Remove();
        self:Remove();
        
        return;
    end 
    
    local ply = LocalPlayer();
   	intro.gui = self;
    self:SetSize(ScrW(), ScrH());
    self:Center();
    self:SetVisible(false);
    ply:ScreenFade(SCREENFADE.IN, Color(255, 255, 255), 1, 1);
    
    timer.Simple(1, function()
        if (IsValid(self)) then self:Vigger(); end
    end );
end 

function PANEL:Vigger()
    self:SetVisible(true);
end 

function PANEL:Paint(w, h)
    if (self.transmition) then 
        
    else 
        surface.SetDrawColor(255, 255, 255, 0);
        surface.DrawRect(0, 0, w, h);
	end 
end 

vgui.Register("chinWorksIntro", PANEL, "DPanel");

local function open()
    vgui.Create("chinWorksIntro");
end 

concommand.Add("rg_intro", open);


















































-- Ancient apex panels 

function GAMEMODE:RulesTab()
	local RulesTab = vgui.Create("DPanelList")
	RulesTab:EnableVerticalScrollbar( true )
	function RulesTab:Update()
		self:Clear(true)
	end
	local html = vgui.Create( "HTML", RulesTab )
	html:Dock( FILL )
	html:OpenURL( "https://requiem.zone/forums/threads/22" )


	RulesTab:Update()
	return RulesTab
end

function GAMEMODE:InformationTab()
	local InformationTab = vgui.Create("DPanelList")

	InformationTab:EnableVerticalScrollbar( true )
	function InformationTab:Update()
		self:Clear(true)
	end

	local heading = vgui.Create("DLabel", InformationTab)
	heading:SetText("Welcome to  requiem.zone HL2RP Server")
	heading:SetFont("Trebuchet24")
	heading:SizeToContents()


	local text = vgui.Create("DLabel", InformationTab)
	text:SetText("\n\nWe are a Semi-Serious Half-Life 2 RP server based on the gamemode made by Apex-Roleplay. You can find our rules on the next tab.")
	text:SizeToContents()

	local heading2 = vgui.Create("DLabel", InformationTab)
	heading2:SetText("\n\n\nChat Commands")
	heading2:SetFont("Trebuchet24")
	heading2:SizeToContents()

	local text = vgui.Create("DLabel", InformationTab)
	text:SetText("\n\n\n\n\n\n\n\n// - Type in OOC Chat\n@ (message) - Call a staff member\n/w - Whisper\n/y - Yell \n/me - Perform an RP action \n/roll - Perform a roll from 1-100. \n/apply - Show your ID to a player.\n/job - Set a customised job role.\n/name - Change your in-game roleplay name.\n/scanner - Deploy a scanner as GRID unit.\n/request - Calls the CCA.\n/11-99 places a distress signal at your feet as a CP\n/reward Will reward a citizen as CP. \n/vortcall Will call all vorts. \n/photocache Will show all scanner images. \n/debeak will debeak a headcrab, making them harmless. \n/requestrogue request rogue as a CP Unit that is below 25.\n/kickdoor kicks door if you are too lazy to pull out the door ram.\n/release releases the player from prison custody (Only Jury and Rebel)")
	text:SizeToContents()

	local heading2 = vgui.Create("DLabel", InformationTab) 
	heading2:SetText("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nXP System")
	heading2:SetFont("Trebuchet24")
	heading2:SizeToContents()


	local text3 = vgui.Create("DLabel", InformationTab)
	text3:SetText("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nXP is used to unlock jobs, the more you play, the more jobs you can play, XP is earned by playing on the server, you gain 5 XP every 10 minutes. \n https://docs.google.com/document/d/1BOptMF3Tz2rnuhCLfURihN7a4oYDmiUTsVE8TXXokRE/edit?usp=sharing")
	text3:SizeToContents()

	InformationTab:Update()
	return InformationTab
end

function GAMEMODE:EntitiesTab()
	local EntitiesPanel = vgui.Create("DPanelList")
	EntitiesPanel:EnableVerticalScrollbar( true )
		function EntitiesPanel:Update()
			self:Clear(true)
			local AmmCat = vgui.Create("DCollapsibleCategory")
			AmmCat:SetLabel("Ammo")
				local AmmPanel = vgui.Create("DPanelList")
				AmmPanel:SetSize(470, 100)
				AmmPanel:SetAutoSize(true)
				AmmPanel:SetSpacing(1)
				AmmPanel:EnableHorizontal(true)
				AmmPanel:EnableVerticalScrollbar(true)
					local function AddAmmoIcon(Model, description, command)
						local icon = vgui.Create("SpawnIcon")
						icon:InvalidateLayout( true )
						icon:SetModel(Model)
						icon:SetSize(64, 64)
						icon:SetToolTip(description)
						icon.DoClick = function() RunConsoleCommand("DarkRP", "buyammo", command) end
						AmmPanel:AddItem(icon)
					end

					local ammnum = 0
					for k,v in pairs(GAMEMODE.AmmoTypes) do
						if not v.customCheck or v.customCheck(LocalPlayer()) then
							AddAmmoIcon(v.model, DarkRP.getPhrase("buy_a", v.name, GAMEMODE.Config.currency .. v.price), v.ammoType);
							ammnum = ammnum + 1
						end
					end

			if ammnum ~= 0 then
				AmmCat:SetContents(AmmPanel)
				--AmmCat:SetSkin(GAMEMODE.Config.DarkRPSkin)
				self:AddItem(AmmCat)
			else
				AmmPanel:Remove()
				AmmCat:Remove()
			end

			local WepCat = vgui.Create("DCollapsibleCategory")
			WepCat:SetLabel("Weapons / Utilities")
				local WepPanel = vgui.Create("DPanelList")
				WepPanel:SetSize(470, 100)
				WepPanel:SetAutoSize(true)
				WepPanel:SetSpacing(1)
				WepPanel:EnableHorizontal(true)
				WepPanel:EnableVerticalScrollbar(true)
					local function AddIcon(Model, description, command)
						local icon = vgui.Create("SpawnIcon")
						icon:InvalidateLayout( true )
						icon:SetModel(Model)
						icon:SetSize(64, 64)
						icon:SetToolTip(description)
						icon.DoClick = function() LocalPlayer():ConCommand("darkrp "..command) end
						WepPanel:AddItem(icon)
					end

					local wepnum = 0
					for k,v in pairs(CustomShipments) do
						if not GAMEMODE:CustomObjFitsMap(v) then continue end
						if (v.seperate and (not GAMEMODE.Config.restrictbuypistol or
							(GAMEMODE.Config.restrictbuypistol and (not v.allowed[1] or table.HasValue(v.allowed, LocalPlayer():Team())))))
							and (not v.customCheck or v.customCheck and v.customCheck(LocalPlayer())) then
							AddIcon(v.model, DarkRP.getPhrase("buy_a", "a "..v.name, GAMEMODE.Config.currency..(v.pricesep or "")), "/buy "..v.name)
							wepnum = wepnum + 1
						end
					end

				if wepnum ~= 0 then
					WepCat:SetContents(WepPanel)
					--WepCat:SetSkin(GAMEMODE.Config.DarkRPSkin)
					self:AddItem(WepCat)
				else
					WepPanel:Remove()
					WepCat:Remove()
				end

			local ShipCat = vgui.Create("DCollapsibleCategory")
			ShipCat:SetLabel("Shipments")
				local ShipPanel = vgui.Create("DPanelList")
				ShipPanel:SetSize(470, 200)
				ShipPanel:SetAutoSize(true)
				ShipPanel:SetSpacing(1)
				ShipPanel:EnableHorizontal(true)
				ShipPanel:EnableVerticalScrollbar(true)
					local function AddShipIcon(Model, description, command)
						local icon = vgui.Create("SpawnIcon")
						icon:InvalidateLayout( true )
						icon:SetModel(Model)
						icon:SetSize(64, 64)
						icon:SetToolTip(description)
						icon.DoClick = function() LocalPlayer():ConCommand("darkrp "..command) end
						ShipPanel:AddItem(icon)
					end

					local shipnum = 0
					for k,v in pairs(CustomShipments) do
						if not GAMEMODE:CustomObjFitsMap(v) then continue end
						if not v.noship and table.HasValue(v.allowed, LocalPlayer():Team())
							and (not v.customCheck or (v.customCheck and v.customCheck(LocalPlayer()))) then
							AddShipIcon(v.model, DarkRP.getPhrase("buy_a", "a "..v.name .." shipment", GAMEMODE.Config.currency .. tostring(v.price)), "/buyshipment "..v.name)
							shipnum = shipnum + 1
						end
					end
				if shipnum ~= 0 then
					ShipCat:SetContents(ShipPanel)
					--ShipCat:SetSkin(GAMEMODE.Config.DarkRPSkin)
					self:AddItem(ShipCat)
				else
					ShipPanel:Remove()
					ShipCat:Remove()
				end

			local EntCat = vgui.Create("DCollapsibleCategory")
			EntCat:SetLabel("Entities")
				local EntPanel = vgui.Create("DPanelList")
				EntPanel:SetSize(470, 200)
				EntPanel:SetAutoSize(true)
				EntPanel:SetSpacing(1)
				EntPanel:EnableHorizontal(true)
				EntPanel:EnableVerticalScrollbar(true)
					local function AddEntIcon(Model, description, command)
						local icon = vgui.Create("SpawnIcon")
						icon:InvalidateLayout( true )
						icon:SetModel(Model)
						icon:SetSize(64, 64)
						icon:SetToolTip(description)
						icon.DoClick = function() LocalPlayer():ConCommand("darkrp "..command) end
						EntPanel:AddItem(icon)
						
					end
					local entnum = 0
					for k,v in pairs(DarkRPEntities) do
						if not v.allowed or (type(v.allowed) == "table" and table.HasValue(v.allowed, LocalPlayer():Team()))
							and (not v.customCheck or (v.customCheck and v.customCheck(LocalPlayer()))) then
							local cmdname = string.gsub(v.ent, " ", "_")

							AddEntIcon(v.model, "Buy a " .. v.name .." " .. GAMEMODE.Config.currency .. v.price, v.cmd)
							entnum = entnum + 1
						end
					end

					local function CanBuyFood(ply)
						return ply:Team() == TEAM_VORTIGAUNT and ply:GetModel()=="models/vortigaunt.mdl"
					end

					if FoodItems and CanBuyFood(LocalPlayer()) then
						for k,v in pairs(FoodItems) do
							--if v.team == LocalPlayer():Team() then
								AddEntIcon(v.model, DarkRP.getPhrase("buy_a", "a "..k, "T"..v.price..""), "buyfood "..v.name)
								entnum = entnum + 1
							--end
						end
					end
				if entnum ~= 0 then
					EntCat:SetContents(EntPanel)
					--EntCat:SetSkin(GAMEMODE.Config.DarkRPSkin)
					self:AddItem(EntCat)
				else
					EntPanel:Remove()
					EntCat:Remove()
				end


			if #CustomVehicles <= 0 then return end
			local VehicleCat = vgui.Create("DCollapsibleCategory")
			VehicleCat:SetLabel("Vehicles")
				local VehiclePanel = vgui.Create("DPanelList")
				VehiclePanel:SetSize(470, 200)
				VehiclePanel:SetAutoSize(true)
				VehiclePanel:SetSpacing(1)
				VehiclePanel:EnableHorizontal(true)
				VehiclePanel:EnableVerticalScrollbar(true)
				local function AddVehicleIcon(Model, skin, description, command)
					local icon = vgui.Create("SpawnIcon")
					icon:InvalidateLayout( true )
					icon:SetModel(Model)
					--icon:SetSkin(skin)
					icon:SetSize(64, 64)
					icon:SetToolTip(description)
					icon.DoClick = function() LocalPlayer():ConCommand("darkrp "..command) end
					VehiclePanel:AddItem(icon)
				end

				local founds = 0
				for k,v in pairs(CustomVehicles) do
					if (not v.allowed or table.HasValue(v.allowed, LocalPlayer():Team())) and (not v.customCheck or v.customCheck(LocalPlayer())) then
						local Skin = (DarkRP.getAvailableVehicles()[v.name] and DarkRP.getAvailableVehicles()[v.name].KeyValues and DarkRP.getAvailableVehicles()[v.name].KeyValues.Skin) or "0"
						AddVehicleIcon(v.model or "models/buggy.mdl", Skin, "Buy a "..v.name.." for "..GAMEMODE.Config.currency..v.price, "/buyvehicle "..v.name)
						founds = founds + 1
					end
				end
			if founds ~= 0 then
				VehicleCat:SetContents(VehiclePanel)
				--VehicleCat:SetSkin(GAMEMODE.Config.DarkRPSkin)
				self:AddItem(VehicleCat)
			else
				VehiclePanel:Remove()
				VehicleCat:Remove()
			end
		end
	--EntitiesPanel:SetSkin(GAMEMODE.Config.DarkRPSkin)
	EntitiesPanel:Update()
	return EntitiesPanel
end

hook.Add("InitPostEntity", "[Base] : StartXPTimer", function()
	net.Start("StartXPTimer")
	net.SendToServer()
end)