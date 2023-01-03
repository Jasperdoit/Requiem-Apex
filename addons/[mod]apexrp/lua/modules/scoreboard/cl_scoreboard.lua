local PANEL = {}
	local paintFunctions = {}
	paintFunctions[0] = function(this, w, h)
		surface.SetDrawColor(0, 0, 0, 50)
		surface.DrawRect(0, 0, w, h)
	end
	paintFunctions[1] = function(this, w, h)
	end

	function PANEL:Init()
		if (IsValid(scoreboard.gui)) then
			scoreboard.gui:Remove()
		end

		scoreboard.gui = self

		self:SetSize(ScrW() * 0.325, ScrH() * 0.825);
		self:Center()

		self.title = self:Add("DLabel")
		self.title:SetText("λ requiem.zone")
		self.title:SetFont("RobotoMono32")
		self.title:SetContentAlignment(5)
		self.title:SetTextColor(color_white)
		self.title:SetExpensiveShadow(1, color_black)
		self.title:Dock(TOP)
		self.title:SizeToContentsY()
		self.title:SetTall(self.title:GetTall() + 16)
		self.title.Paint = function(this, w, h)
			surface.SetDrawColor(0, 0, 0, 150)
			surface.DrawRect(0, 0, w, h)
		end

		self.scroll = self:Add("DScrollPanel")
		self.scroll:Dock(FILL)
		self.scroll:DockMargin(1, 0, 1, 0)
		self.scroll.VBar:SetWide(0)

		self.layout = self.scroll:Add("DListLayout")
		self.layout:Dock(TOP)

		self.teams = {}
		self.slots = {}
		self.i = {}

		for k, v in ipairs(RPExtraTeams) do
			local color = team.GetColor(k)
			local r, g, b = color.r, color.g, color.b
			 
			local list = self.layout:Add("DListLayout");
			list:Dock(TOP)
			list:SetTall(28)
			list.Think = function(this)
				for k2, v2 in ipairs(team.GetPlayers(k)) do
					if (not IsValid(v2.nutScoreSlot) or v2.nutScoreSlot:GetParent() ~= this) then
						if (IsValid(v2.nutPlayerSlot)) then
							v2.nutPlayerSlot:SetParent(this)
						else
							self:addPlayer(v2, this)
						end
					end
				end
			end

			local header = list:Add("DLabel")
			header:Dock(TOP)
			header:SetText(v.name);
			header:SetTextInset(3, 0)
			header:SetFont("RobotoMono18")
			header:SetTextColor(color_white)
			header:SetExpensiveShadow(1, color_black)
			header:SetTall(28)
			header.Paint = function(this, w, h)
				surface.SetDrawColor(r, g, b, 155)
				surface.DrawRect(0, 0, w, h)
			end

			self.teams[k] = list
		end
	end
	
	
	function PANEL:Think()
		if ((self.nextUpdate or 0) < CurTime()) then
			local visible, amount
			
			if (self.teams) and (IsValid(self.layout)) then 
				for faction, v in ipairs(self.teams) do
					visible, amount = v:IsVisible(), team.NumPlayers(faction)

					if (visible and amount == 0) then
						v:SetVisible(false)
						self.layout:InvalidateLayout()
					elseif (not visible and amount > 0) then
						v:SetVisible(true)
					end

					if (amount ~= 0) then
						v:SetVisible(hook.Run("ShowFactionInScoreboard", faction) ~= false or LocalPlayer():IsAdmin())
					end
				end

				for _, v in pairs(self.slots) do
					if (IsValid(v)) then
						v:update()
					end
				end
			end 

			self.nextUpdate = CurTime() + 1
		end
	end

	function PANEL:addPlayer(client, parent)
		if (not IsValid(parent)) then
			return
		end

		local slot = parent:Add("DPanel")
		slot:Dock(TOP)
		slot:SetTall(64)
		slot:DockMargin(0, 0, 0, 1)

		client.nutScoreSlot = slot

		slot.model = slot:Add("nutSpawnIcon")
		slot.model:SetModel(client:GetModel(), client:GetSkin())
		slot.model:SetSize(64, 64)
		slot.model.DoClick = function(_self)
			if (parent:GetParent().actions) then 
				parent:GetParent().actions:Remove();
			end 
			
			parent:GetParent().actions = vgui.Create("DScrollPanel");
			local x, y = input.GetCursorPos();
			parent:GetParent().actions:SetPos(x, y);
			parent:GetParent().actions:SetSize(ScrW() * .2, ScrH() * .4);
			
			local ActionButton = vgui.Create("FAdminActionButton");
			ActionButton:SetImage("icon16/exclamation");
			ActionButton:SetText("Copy RP Name");
			ActionButton:SetBorderColor(Color(153, 0, 0));
			parent:GetParent().actions:AddItem(ActionButton);
			ActionButton:Dock(TOP);
			ActionButton:DockMargin(2, 2, 2, 0);
			function ActionButton:DoClick()
				if (IsValid(client)) then
					SetClipboardText(client:Name());
				end
			end 
			
			local ActionButton = vgui.Create("FAdminActionButton");
			ActionButton:SetImage("icon16/exclamation");
			ActionButton:SetText("Copy Steam Name");
			ActionButton:SetBorderColor(Color(153, 0, 0));
			parent:GetParent().actions:AddItem(ActionButton);
			ActionButton:Dock(TOP);
			ActionButton:DockMargin(2, 2, 2, 0);
			function ActionButton:DoClick()
				if (IsValid(client)) then
					SetClipboardText(client:SteamName());
				end
			end 
			
			local ActionButton = vgui.Create("FAdminActionButton");
			ActionButton:SetImage("icon16/exclamation");
			ActionButton:SetText("Show Steam Profile");
			ActionButton:SetBorderColor(Color(153, 0, 0));
			parent:GetParent().actions:AddItem(ActionButton);
			ActionButton:Dock(TOP);
			ActionButton:DockMargin(2, 2, 2, 0);
			function ActionButton:DoClick()
				if (IsValid(client)) then
					client:ShowProfile();
				end
			end 
			
			for _, v in ipairs(FAdmin.ScoreBoard.Player.ActionButtons) do
				if v.Visible == true or (isfunction(v.Visible) and v.Visible(client) == true) then
					local ActionButton = vgui.Create("FAdminActionButton")
					local imageType = TypeID(v.Image)
					if imageType == TYPE_STRING then
						ActionButton:SetImage(v.Image or "icon16/exclamation")
					elseif imageType == TYPE_TABLE then
						ActionButton:SetImage(v.Image[1])
						if v.Image[2] then ActionButton:SetImage2(v.Image[2]) end
					elseif imageType == TYPE_FUNCTION then
						local img1, img2 = v.Image(LocalPlayer())
						ActionButton:SetImage(img1)
						if img2 then ActionButton:SetImage2(img2) end
					else
						ActionButton:SetImage("icon16/exclamation")
					end
					local name = v.Name
					if isfunction(name) then name = name(client) end
					ActionButton:SetText(DarkRP.deLocalise(name))
					ActionButton:SetBorderColor(v.color)

					function ActionButton:DoClick()
						if not IsValid(client) then return end
						return v.Action(client, self)
					end
					parent:GetParent().actions:AddItem(ActionButton)
					if v.OnButtonCreated then
						v.OnButtonCreated(client, ActionButton)
					end
					ActionButton:Dock(TOP);
					ActionButton:DockMargin(2, 2, 2, 0);
				end
			end
		end
		slot.model:SetTooltip(client:SteamName())

		timer.Simple(0, function()
			if (not IsValid(slot)) then
				return
			end

			local entity = slot.model.Entity

			if (IsValid(entity)) and (client:GetNWBool("citizenshipRevoked") or client:Team() ~= TEAM_CITIZEN or client == LocalPlayer()) then
				for k, v in ipairs(client:GetBodyGroups()) do
					entity:SetBodygroup(v.id, client:GetBodygroup(v.id))
				end

				for k, v in ipairs(client:GetMaterials()) do
					entity:SetSubMaterial(k - 1, client:GetSubMaterial(k - 1))
				end
			end
            
            if (client:Team() == TEAM_CITIZEN) and (client != LocalPlayer()) and not (client:GetNWBool("citizenshipRevoked")) then 
                slot.model:setHidden(true);
            end 
		end)

		slot.name = slot:Add("DLabel")
		slot.name:Dock(TOP)
		slot.name:DockMargin(65, 0, 48, 0)
		slot.name:SetTall(18)
		slot.name:SetFont("RobotoMono18");
		slot.name:SetTextColor(color_white)
		slot.name:SetExpensiveShadow(1, color_black)

		slot.ping = slot:Add("DLabel")
		slot.ping:SetPos(self:GetWide() - 48, 0)
		slot.ping:SetSize(48, 64)
		slot.ping:SetText("0")
		slot.ping.Think = function(this)
			if (IsValid(client)) then
				this:SetText(client:Ping())
			end
		end
		slot.ping:SetFont("RobotoMono18")
		slot.ping:SetContentAlignment(6)
		slot.ping:SetTextColor(color_white)
		slot.ping:SetTextInset(16, 0)
		slot.ping:SetExpensiveShadow(1, color_black)

		slot.desc = slot:Add("DLabel")
		slot.desc:Dock(FILL)
		slot.desc:DockMargin(65, 0, 48, 0)
		slot.desc:SetWrap(true)
		slot.desc:SetContentAlignment(7)
		slot.desc:SetTextColor(color_white)
		slot.desc:SetExpensiveShadow(1, Color(0, 0, 0, 100))
		slot.desc:SetFont("RobotoMono18Italic")

		local oldTeam = client:Team()

		function slot:update()
			if (not IsValid(client) or oldTeam ~= client:Team()) then
				self:Remove()

				local i = 0

				for k, v in ipairs(parent:GetChildren()) do
					if (IsValid(v.model) and v ~= self) then
						i = i + 1
						v.Paint = paintFunctions[i % 2]
					end
				end
           
				return
			end

			local overrideName = hook.Run("ShouldAllowScoreboardOverride", client, "name") and hook.Run("GetDisplayedName", client)
			local name = overrideName or client:Name()
			name = name:gsub("#", "\226\128\139#")
			
			if (LocalPlayer():IsAdmin()) then 
				name = name .. " (" .. client:SteamName() .. ")";
			end 
			
			local model = client:GetModel()
			local skin = client:GetSkin()
			local desc = hook.Run("ShouldAllowScoreboardOverride", client, "desc") and (hook.Run("GetDisplayedDescription", client) or "") or "This person is a " ..  client:GetUserGroup() .. ".\nThey have " .. client:getXP() .. " XP.";
			desc = desc:gsub("#", "\226\128\139#")

			--self.model:setHidden(overrideName)

			if (self.lastName ~= name) then
				self.name:SetText(name)
				self.lastName = name
			end

			local entity = self.model.Entity

			if (self.lastDesc ~= desc) then
				self.desc:SetText(desc)
				self.lastDesc = desc
			end

			if (not IsValid(entity)) then
				return
			end

			if (self.lastModel ~= model or self.lastSkin ~= skin) then
				self.model:SetModel(client:GetModel(), client:GetSkin())
				self.model:SetTooltip(client:SteamName())

				self.lastModel = model
				self.lastSkin = skin
			end

			timer.Simple(0, function()
				if (not IsValid(entity) or not IsValid(client)) then
					return
				end
				
                if (IsValid(entity)) and (client:GetNWBool("citizenshipRevoked") or client:Team() ~= TEAM_CITIZEN or client == LocalPlayer()) then                 
                    for k, v in ipairs(client:GetBodyGroups()) do
                        entity:SetBodygroup(v.id, client:GetBodygroup(v.id))
                    end
				end
                
               if (client:Team() == TEAM_CITIZEN) and (client != LocalPlayer()) then 
                    if (client:GetNWBool("citizenshipRevoked", false)) then 
                        self.model:setHidden(false)
					else 
                    	self.model:setHidden(true);
					end
               end   
                
              	 
			end)
        end

		self.slots[#self.slots + 1] = slot

		parent:SetVisible(true)
		parent:SizeToChildren(false, true)
		parent:InvalidateLayout(true)

		local i = 0

		for k, v in ipairs(parent:GetChildren()) do
			if (IsValid(v.model)) then
				i = i + 1
				v.Paint = paintFunctions[i % 2]
			end
		end

		slot:update()

		return slot
	end

	function PANEL:OnRemove()
    	if (IsValid(self.actions)) then 
			self.actions:Remove();
       	end 
		CloseDermaMenus()
	end

	function PANEL:Paint(w, h)
		scoreboard:drawBlur(self, 10);

		surface.SetDrawColor(30, 30, 30, 100)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(0, 0, 0, 150)
		surface.DrawOutlinedRect(0, 0, w, h)
	end
vgui.Register("nutScoreboard", PANEL, "EditablePanel")

concommand.Add("rg_reloadsb", function()
	if (IsValid(scoreboard.gui)) then
        print("Reloaded the scoreboard!");
		scoreboard.gui:Remove()
	end
end)

if (IsValid(LocalPlayer())) then 
	LocalPlayer():ConCommand("rg_reloadsb");
end 