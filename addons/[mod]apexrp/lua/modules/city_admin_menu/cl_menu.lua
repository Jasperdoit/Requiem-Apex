local broadcastStations = {}

net.Receive("RequestRefresh", function()
	broadcastStations = net.ReadTable()
end)

local function CAMenu()
	local frame = vgui.Create("DFrame")
	frame:SetSize(500,500)
	local x, y = frame:GetSize()
	frame:SetPos(ScrW()/2-x/2, (ScrH()/2)-y/2)
	frame:MakePopup()
	frame.Paint = function(self, w, h)
		surface.SetDrawColor(Color(150,150,150,255))
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(Color(50,50,50,255))
		surface.DrawRect(2,2,w-4,h-4)
	end
	frame:SetTitle("Minister Menu")
	
	local sheet = vgui.Create("DPropertySheet", frame)
	sheet:Dock( FILL )
	
	local propaganda = vgui.Create("DPanel",sheet)
	sheet:AddSheet("Propaganda Control", propaganda, "icon16/comments.png")
	propaganda.Paint = function(self, w, h)
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(Color(180,0,0,255))
		surface.DrawRect(2,2,w-4,h-4)
	end
	
	local button = vgui.Create("DButton", propaganda)
	button:SetSize(455,50)
	button:SetPos(10,10)
	button:SetText("Enable broadcasting station")
	button:SetTextColor(Color(255,255,255))
	button.gamma = 100
	button.Paint = function(self, w, h)
		if self:IsHovered() then
			button.gamma = math.Approach(button.gamma, 50, 1)
		else
			button.gamma = math.Approach(button.gamma, 100, 1)
		end
		surface.SetDrawColor(Color(button.gamma,button.gamma,button.gamma))
		surface.DrawRect(0,0,w,h)
	end
	function button:DoClick()
		net.Start("BroadcastEnabled")
		net.WriteBool(true)
		net.SendToServer()
	end

	local button = vgui.Create("DButton", propaganda)
	button:SetSize(455,50)
	button:SetPos(10,70)
	button:SetText("Disable broadcasting station")
	button:SetTextColor(Color(255,255,255))
	button.gamma = 100
	button.Paint = function(self, w, h)
		if self:IsHovered() then
			button.gamma = math.Approach(button.gamma, 50, 1)
		else
			button.gamma = math.Approach(button.gamma, 100, 1)
		end
		surface.SetDrawColor(Color(button.gamma,button.gamma,button.gamma))
		surface.DrawRect(0,0,w,h)
	end
	function button:DoClick()
		net.Start("BroadcastEnabled")
		net.WriteBool(false)
		net.SendToServer()
	end

	local broadcast = vgui.Create("DListView", propaganda)
	broadcast:SetPos(10,130)
	broadcast:SetSize(455,290)
	broadcast:AddColumn("Broadcast ID")
	broadcast:AddColumn("Position")
	broadcast:SetMultiSelect(false)
	broadcast.mainLine = broadcast:AddLine("Right click me to add a broadcasting location", "N/A")
	for k, v in pairs(broadcastStations) do
		broadcast:AddLine(k, tostring(v))
	end
	function broadcast:OnRowRightClick(lineID, line)
		local menu = DermaMenu()
		menu:AddOption("Create broadcast location", function()
			net.Start("AddBroadcast")
			net.SendToServer()
			local index = table.insert(broadcastStations, LocalPlayer():GetPos())
			broadcast:AddLine(index, tostring(LocalPlayer():GetPos()))
		end):SetIcon("icon16/cog_add.png")
		if line != broadcast.mainLine then
			menu:AddOption("Remove broadcast location", function()
				net.Start("RemoveBroadcast")
				net.WriteInt(tonumber(line:GetColumnText(1)),8)
				net.SendToServer()
				table.remove(broadcastStations, tonumber(line:GetColumnText(1)))
				broadcast:Clear()
				broadcast.mainLine = broadcast:AddLine("Right click me to add a broadcasting location", "N/A")
				for k, v in pairs(broadcastStations) do
					broadcast:AddLine(k, tostring(v))
				end
			end):SetIcon("icon16/cog_delete.png")
		end
		menu:AddOption("Refresh broadcasting locations", function()
			net.Start("RequestRefresh")
			net.SendToServer()
			broadcast:Clear()
			broadcast.mainLine = broadcast:AddLine("Right click me to add a broadcasting location", "N/A")
			for k, v in pairs(broadcastStations) do
				broadcast:AddLine(k, tostring(v))
			end
		end):SetIcon("icon16/cog_error.png")
		menu:Open()
	end

	if LocalPlayer():Team() != TEAM_DISPATCH && (LocalPlayer():Team() != TEAM_ADMINISTRATOR || !string.find(LocalPlayer():getDarkRPVar("job"),"Propaganda") || LocalPlayer():GetNWBool("restricted", false)) then
		local cover = vgui.Create("DPanel", propaganda)
		cover:SetSize(500,500)
		cover.Paint = function(self, w, h)
			surface.SetDrawColor(Color(0,0,0,150))
			surface.DrawRect(0,0,w,h)
			draw.DrawText("You don't have access to this section", "DermaLarge", 240,200,Color(255,255,255,255), TEXT_ALIGN_CENTER)
		end
	end

	local economic = vgui.Create("DPanel",sheet)
	sheet:AddSheet("Economics Control", economic, "icon16/money.png")
	economic.Paint = function(self, w, h)
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(Color(180,0,0,255))
		surface.DrawRect(2,2,w-4,h-4)
	end
	
	local tax = GetGlobalInt("tax",0)

	local taxAmount = vgui.Create("DProgress", economic)
	taxAmount:SetPos(10, 10)
	taxAmount:SetSize(455, 50)
	taxAmount.Paint = function(self, w, h)
		draw.RoundedBox(5, 0, 0, w, h, Color(0, 0, 0, 255))
		draw.RoundedBox(5, 2, 2, (w-4)*self:GetFraction(), h-4, Color(255,255,0,255))
		draw.DrawText("$ Percentage of salaries taxed $","DermaLarge", 227.5, 10, Color(0,150,0,255), TEXT_ALIGN_CENTER)
	end
	taxAmount:SetFraction(math.Clamp(tax/100, 0, 1))

	local panel = vgui.Create("DPanel", economic)
	panel:SetPos(10,70)
	panel:SetSize(455, 100)
	panel.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(200,200,200,255))
		draw.DrawText(tostring(tax).."%", "DermaLarge", 227.5, 30, Color(255-(tax/100),255*(tax/100),0,255), TEXT_ALIGN_CENTER)
	end

	local decrease = vgui.Create("DButton", panel)
	decrease:SetPos(5,5)
	decrease:SetSize(90,90)
	decrease.gamma = 100
	decrease:SetText("Set to 0%")
	decrease:SetTextColor(Color(255,255,255,255))
	decrease.Paint = function(self, w, h)
		if self:IsHovered() then
			decrease.gamma = math.Approach(decrease.gamma, 50, 1)
		else
			decrease.gamma = math.Approach(decrease.gamma, 100, 1)
		end
		surface.SetDrawColor(Color(decrease.gamma,decrease.gamma,decrease.gamma))
		surface.DrawRect(0,0,w,h)
	end
	function decrease:DoClick()
		net.Start("TaxChange")
		net.WriteInt(0,8)
		net.SendToServer()
		taxAmount:SetFraction(0)
		tax = 0
	end

	local decreaseby5 = vgui.Create("DButton", panel)
	decreaseby5:SetPos(105,5)
	decreaseby5:SetSize(90,90)
	decreaseby5.gamma = 100
	decreaseby5:SetText("Decrease by 5%")
	decreaseby5:SetTextColor(Color(255,255,255,255))
	decreaseby5.Paint = function(self, w, h)
		if self:IsHovered() then
			decreaseby5.gamma = math.Approach(decreaseby5.gamma, 50, 1)
		else
			decreaseby5.gamma = math.Approach(decreaseby5.gamma, 100, 1)
		end
		surface.SetDrawColor(Color(decreaseby5.gamma,decreaseby5.gamma,decreaseby5.gamma))
		surface.DrawRect(0,0,w,h)
	end
	function decreaseby5:DoClick()
		net.Start("TaxChange")
		net.WriteInt(math.Clamp(tax - 5, 0, 100),8)
		net.SendToServer()
		tax = math.Clamp(tax - 5, 0, 100)
		taxAmount:SetFraction(math.Clamp(tax/100, 0, 1))
	end

	local increaseby5 = vgui.Create("DButton", panel)
	increaseby5:SetPos(265,5)
	increaseby5:SetSize(90,90)
	increaseby5.gamma = 100
	increaseby5:SetText("Increase by 5%")
	increaseby5:SetTextColor(Color(255,255,255,255))
	increaseby5.Paint = function(self, w, h)
		if self:IsHovered() then
			increaseby5.gamma = math.Approach(increaseby5.gamma, 50, 1)
		else
			increaseby5.gamma = math.Approach(increaseby5.gamma, 100, 1)
		end
		surface.SetDrawColor(Color(increaseby5.gamma,increaseby5.gamma,increaseby5.gamma))
		surface.DrawRect(0,0,w,h)
	end
	function increaseby5:DoClick()
		net.Start("TaxChange")
		net.WriteInt(math.Clamp(tax + 5, 0, 100),8)
		net.SendToServer()
		tax = math.Clamp(tax + 5, 0, 100)
		taxAmount:SetFraction(math.Clamp(tax/100, 0, 1))
	end
	
	local increase = vgui.Create("DButton", panel)
	increase:SetPos(360,5)
	increase:SetSize(90,90)
	increase.gamma = 100
	increase:SetText("Set to 100%")
	increase:SetTextColor(Color(255,255,255,255))
	increase.Paint = function(self, w, h)
		if self:IsHovered() then
			increase.gamma = math.Approach(increase.gamma, 50, 1)
		else
			increase.gamma = math.Approach(increase.gamma, 100, 1)
		end
		surface.SetDrawColor(Color(increase.gamma,increase.gamma,increase.gamma))
		surface.DrawRect(0,0,w,h)
	end
	function increase:DoClick()
		net.Start("TaxChange")
		net.WriteInt(100,8)
		net.SendToServer()
		taxAmount:SetFraction(1)
		tax = 100
	end

	local money = vgui.Create("DPanel", economic)
	money:SetPos(10,180)
	money:SetSize(455,240)
	money.Paint = function(self, w, h)
		draw.RoundedBox(2, 0, 0, w, h, Color(0,150,255,255))
		draw.DrawText(player.GetCount().." civillians and CPs being taxed", "DermaLarge", 227.5, 10, Color(150,0,0,255), TEXT_ALIGN_CENTER)
		draw.DrawText(GetGlobalInt("taxLimit", 60).."% - Tax limit before riots break out", "DermaLarge", 227.5, 105, Color(0,0,0,255), TEXT_ALIGN_CENTER)
		draw.DrawText(GetGlobalInt("UUMoney",0).." tokens that the UU holds", "DermaLarge", 227.5, 200, Color(0,50,0,255), TEXT_ALIGN_CENTER)
		surface.SetDrawColor(Color(255,0,0,255))
		surface.DrawLine(227.5, 40, 227.5, 100)
		surface.DrawLine(227.5, 145, 227.5, 195)
	end



	if LocalPlayer():Team() != TEAM_DISPATCH && (LocalPlayer():Team() != TEAM_ADMINISTRATOR || !string.find(LocalPlayer():getDarkRPVar("job"),"Economy") || LocalPlayer():GetNWBool("restricted", false)) then
		local cover = vgui.Create("DPanel", economic)
		cover:SetSize(500,500)
		cover.Paint = function(self, w, h)
			surface.SetDrawColor(Color(0,0,0,150))
			surface.DrawRect(0,0,w,h)
			draw.DrawText("You don't have access to this section", "DermaLarge", 240,200,Color(255,255,255,255), TEXT_ALIGN_CENTER)
		end
	end

	local research = vgui.Create("DPanel", sheet)
	sheet:AddSheet("Research Control", research, "icon16/chart_line.png")
	research.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(180, 0, 0, 255))
	end

	local detailPanel = vgui.Create("DPanel", research)
	detailPanel:SetPos(10,10)
	detailPanel:SetSize(285,410)
	detailPanel.Paint = function(self, w, h)
		draw.RoundedBox(2, 0, 0, w, h, Color(100, 100, 100, 255))
		draw.RoundedBox(2, 2, 2, w-4, h-4, Color(50, 50, 50, 255))
	end
	
	local information = vgui.Create("DPanel", detailPanel)
	information:SetSize(245, 270)
	information:SetPos(20, 20)
	information.Paint = function(self, w, h)
		draw.RoundedBox(2, 0, 0, w, h, Color(100,100,100,255))
		draw.RoundedBox(2, 2, 2, w-4, h-4, Color(150,150,150,255))
	end
	detailPanel:Hide()

	local richtext = vgui.Create("RichText", information)
	richtext:SetSize(225, 220)
	richtext:SetPos(10,40)
	function richtext:PerformLayout()
		richtext:SetFontInternal("Trebuchet18")
		richtext:SetBGColor(Color(0,0,0,150))
	end	
	
	local name = vgui.Create("DPanel", information)
	name:SetSize(225, 15)
	name:SetPos(10, 10)

	local researchList = vgui.Create("DScrollPanel", research)
	researchList:SetPos(305, 10)
	researchList:SetSize(150, 410)
	researchList.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(100,100,100,255))
		draw.RoundedBox(0, 2, 2, w-4, h-4, Color(50,50,50,255))
	end
	local selected
	for k, v in pairs(wmResearch) do
		for level=1, v.Levels do
			local button = vgui.Create("DButton", researchList)
			button:Dock( TOP )
			button:SetSize(140, 40)
			button.gamma = 200
			button.Data = table.Copy(v)
			button.Data.Level = level
			button.Data.Cost = button.Data.CustomCost(v.Cost, level)
			button.Data.Required = button.Data.CustomRequired(v.Required, level)
			button.Data.Time = button.Data.CustomDuration(v.Time, level)
			button.Key = k
			button:SetText(v.Name.." (Lv. "..button.Data.Level..")")
			button:SetTextColor(v.Color)
			button.Paint = function(self, w, h)
				if self:IsHovered() || (selected && selected == self) then
					button.gamma = math.Approach(button.gamma, 150, 1)
				else
					button.gamma = math.Approach(button.gamma, 200, 1)
				end
				draw.RoundedBox(0, 2, 2, w-4, h-4,Color(button.gamma,button.gamma,button.gamma,255))

			end

			function button:DoClick()
				detailPanel:Show()
				selected = button
				richtext:SetText("Type: "..resString(selected.Data.Type).."\n\nDescription: "..selected.Data.Desc.."\n\nCost: "..selected.Data.Cost.."\n\nDuration: "..selected.Data.Time.." seconds\n\nResearch required: "..selected.Data.Required)
			end
		end
	end

	name.Paint = function(self, w, h)
		draw.RoundedBox(2, 0, 0, w, h, Color(0,0,150,255))
		if !selected then return end
		draw.DrawText(selected.Data.Name, "Trebuchet18", w/2, h/2-10, Color(255,255,255), TEXT_ALIGN_CENTER)		
	end

	local button = vgui.Create("DButton", detailPanel)
	button:SetPos(62.5, 339)
	button:SetSize(160,50)
	button:SetColor(Color(0,0,255,255))
	button:SetText("Set as research project")
	button.gamma = 150
	button.Paint = function(self, w, h)
		if self:IsHovered() || (selected && selected == self) then
			button.gamma = math.Approach(button.gamma, 200, 1)
		else
			button.gamma = math.Approach(button.gamma, 150, 1)
		end
		draw.RoundedBox(0, 0, 0, w, h,Color(0,100,button.gamma-50,255))
		draw.RoundedBox(0, 2, 2, w-4, h-4,Color(0,150,button.gamma,255))
	end
	function button:DoClick()
		if !selected then return end
		net.Start("SelectResearch")
		net.WriteString(selected.Key)
		net.WriteInt(selected.Data.Level,8)
		net.SendToServer()
	end

	local progress = vgui.Create("DPanel", detailPanel)
	progress:SetSize(245, 30)
	progress:SetPos(20, 300)
	progress.Paint = function(self, w, h)
		draw.RoundedBox(2, 0, 0, w, h, Color(0,20,20,255))
		local progress = 0
		local required = 1
		if selected then
			progress = GetGlobalInt(selected.Key..selected.Data.Level, 0)
			required = selected.Data.Required
		end
		draw.RoundedBox(2, 2, 2, (w-4)*math.Clamp(progress/required, 0, 1), h-4, Color(0,150,255,255))
		surface.SetFont("DermaDefault")
		local x, y = surface.GetTextSize("Research progress")
		draw.DrawText("Research progress", "DermaDefault", w/2, h/2-7, Color(0,50,180), TEXT_ALIGN_CENTER)
	end

	if LocalPlayer():Team() != TEAM_DISPATCH && (LocalPlayer():Team() != TEAM_ADMINISTRATOR || !string.find(LocalPlayer():getDarkRPVar("job"),"Research") || LocalPlayer():GetNWBool("restricted", false)) then
		local cover = vgui.Create("DPanel", research)
		cover:SetSize(500,500)
		cover.Paint = function(self, w, h)
			surface.SetDrawColor(Color(0,0,0,150))
			surface.DrawRect(0,0,w,h)
			draw.DrawText("You don't have access to this section", "DermaLarge", 240,200,Color(255,255,255,255), TEXT_ALIGN_CENTER)
		end
	end

	local main = vgui.Create("DPanel", sheet)
	sheet:AddSheet("Minister Control", main, "icon16/user_suit.png")
	main.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(180, 0, 0, 255))
	end

	local button = vgui.Create("DButton", main)
	button:SetPos(10,380)
	button:SetSize(455/2,40)
	button:SetTextColor(Color(0,0,255,255))
	button:SetText("Reset taxes")
	button.gamma = 150
	button.Paint = function(self, w, h)
		if self:IsHovered() || (selected && selected == self) then
			button.gamma = math.Approach(button.gamma, 200, 1)
		else
			button.gamma = math.Approach(button.gamma, 150, 1)
		end
		draw.RoundedBox(0, 0, 0, w, h,Color(0,100,button.gamma-50,255))
		draw.RoundedBox(0, 2, 2, w-4, h-4,Color(0,150,button.gamma,255))
	end
	function button:DoClick()
		net.Start("TaxChange")
		net.SendToServer()
	end

	local control = vgui.Create("DListView", main)
	control:SetPos(10,10)
	control:SetSize(455,360)
	control:AddColumn("Name")
	control:AddColumn("Rank")
	control:AddColumn("ID")
	control:AddColumn("Restricted Access")
	for k, v in pairs(team.GetPlayers(TEAM_ADMINISTRATOR)) do
		if v != LocalPlayer() then
			control:AddLine(v:Name(), v:getDarkRPVar("job"), v:UserID(), tostring(v:GetNWBool("restricted", false)))
		end
	end
	function control:OnRowRightClick(lineID, line)
		local menu = DermaMenu()
		local sub, icon = menu:AddSubMenu("Access")
		icon:SetIcon("icon16/key.png")
		sub:AddOption("Give access", function()
			local ply = Player(tonumber(line:GetColumnText(3)))
			if IsValid(ply) then
				net.Start("ToggleAccess")
				net.WriteEntity(ply)
				net.WriteBool(false)
				net.SendToServer()
			end
			control:Clear()
			for k, v in pairs(team.GetPlayers(TEAM_ADMINISTRATOR)) do
				if v != LocalPlayer() && v != ply then
					control:AddLine(v:Name(), v:getDarkRPVar("job"), v:UserID(), tostring(v:GetNWBool("restricted", false)))
				elseif v == ply then
					control:AddLine(v:Name(), v:getDarkRPVar("job"), v:UserID(), "false")
				end
			end
		end):SetIcon("icon16/key_add.png")

		sub:AddOption("Remove access", function()
			local ply = Player(tonumber(line:GetColumnText(3)))
			if IsValid(ply) then
				net.Start("ToggleAccess")
				net.WriteEntity(ply)
				net.WriteBool(true)
				net.SendToServer()
			end
			control:Clear()
			for k, v in pairs(team.GetPlayers(TEAM_ADMINISTRATOR)) do
				if v != LocalPlayer() && v != ply then
					control:AddLine(v:Name(), v:getDarkRPVar("job"), v:UserID(), tostring(v:GetNWBool("restricted", false)))
				elseif v == ply then
					control:AddLine(v:Name(), v:getDarkRPVar("job"), v:UserID(), "true")
				end
			end
		end):SetIcon("icon16/key_delete.png")

		--[[menu:AddOption("Mark Defunct", function()
			local ply = player.GetByID(tostring(line:GetColumnText(3)))
			if IsValid(ply) then
				net.Start("MarkDefunct")
				net.WriteEntity(ply)
				net.SendToServer()
			end
		end):SetIcon("icon16/user_delete.png")]]
		menu:Open()
	end

	if LocalPlayer():Team() != TEAM_DISPATCH && (LocalPlayer():Team() != TEAM_ADMINISTRATOR || !string.find(LocalPlayer():getDarkRPVar("job"),"Chancellor") || LocalPlayer():GetNWBool("restricted", false)) then
		local cover = vgui.Create("DPanel", main)
		cover:SetSize(500,500)
		cover.Paint = function(self, w, h)
			surface.SetDrawColor(Color(0,0,0,150))
			surface.DrawRect(0,0,w,h)
			draw.DrawText("You don't have access to this section", "DermaLarge", 240,200,Color(255,255,255,255), TEXT_ALIGN_CENTER)
		end
	end

end

hook.Add("PlayerButtonDown", "CAMenuOpen", function(ply, button)
	if IsFirstTimePredicted() && button == KEY_I && ply:Team() == TEAM_ADMINISTRATOR && string.find(LocalPlayer():getDarkRPVar("job"), "Defense") && !ply:GetNWBool("restricted", false) then
		ply:ConCommand("fcode_menu")
	elseif IsFirstTimePredicted() && button == KEY_I && (ply:Team() == TEAM_ADMINISTRATOR) then
		CAMenu()
	end
end)