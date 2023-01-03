surface.CreateFont( "nutChat", {
	font = "Roboto Mono ExtraLight", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 22,
	weight = 500,
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

-- Markup panel below

local panelMeta = FindMetaTable( "Panel" );
local blur = Material( "pp/blurscreen" );

function panelMeta:drawBlur( a, d )
	local x, y = self:LocalToScreen( 0, 0 );

	surface.SetDrawColor( 255, 255, 255 );
	surface.SetMaterial( blur );

	for i = 1, d do
		blur:SetFloat( "$blur", (i / d ) * ( a ) );
		blur:Recompute();
		render.UpdateScreenEffectTexture();
		surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() );
	end
end 

local PANEL = {}
	function PANEL:Init()
		self:SetDrawBackground(false)
	end

	function PANEL:setMarkup(text, onDrawText)
		local object = nut.markup.parse(text, self:GetWide())
		object.onDrawText = onDrawText

		self:SetTall(object:getHeight())
		self.Paint = function(this, w, h)
			object:draw(0, 0)
		end
	end
vgui.Register("nutChatBoxMarkup", PANEL, "DPanel")

-- Chatbox below

PANEL = {}
	local gradient = Material("vgui/gradient-d")
	local gradient2 = Material("vgui/gradient-u")

	local COLOR_FADED = Color(200, 200, 200, 100)
	local COLOR_ACTIVE = color_white
	local COLOR_WRONG = Color(255, 100, 80)

	function PANEL:Init()
		local border = 10
		local scrW, scrH = ScrW(), ScrH()
		local w, h = scrW * 0.45, scrH * 0.25

		self:SetSize(w, h)
		self:SetPos(border, scrH - h - border - 175)

		self.active = false

		self.scroll = self:Add("DScrollPanel")
		self.scroll:SetPos(4, 4)
		self.scroll:SetSize(w - 8, h - 54)
		self.scroll:GetVBar():SetWide(0)

		self.lastY = 0

		self.list = {}

		chat.GetChatBoxPos = function()
			return self:LocalToScreen(0, 0)
		end

		chat.GetChatBoxSize = function()
			return self:GetSize()
		end
	end

	function PANEL:Paint(w, h)
		if (self.active) then
			self:drawBlur( 3, 6 );

			surface.SetDrawColor(250, 250, 250, 2)
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(32, 32, 32)
			surface.DrawOutlinedRect(0, 0, w, h)
		end
	end

	local TEXT_COLOR = Color(255, 255, 255, 200)

	function PANEL:setActive(state, isteamchat)
		self.active = state

		if (state) then
			self.entry = self:Add("EditablePanel")
			self.entry:SetPos(self.x + 4, self.y + self:GetTall() - 32)
			self.entry:SetWide(self:GetWide() - 8)
			self.entry.Paint = function(this, w, h)
			end
			self.entry.OnRemove = function()
				hook.Run("FinishChat")
			end
			self.entry:SetTall(28)

			nutChat.history = nutChat.history or {}

			self.text = self.entry:Add("DTextEntry")
			self.text:Dock(FILL)
			self.text.History = nutChat.history
			self.text:SetHistoryEnabled(true)
			self.text:DockMargin(3, 3, 3, 3)
			self.text:SetFont("nutChat")
			self.text.OnEnter = function(this)
				local text = this:GetText()

				this:Remove()

				self.active = false
				self.entry:Remove()

				if (text:find("%S")) then
					if ( #text > nutChat.charLimit or 200 ) then 
						text = text:sub( 1, nutChat.charLimit or 200 );
					end 

					if (!(nutChat.lastLine or ""):find(text, 1, true)) then
						nutChat.history[#nutChat.history + 1] = text
						nutChat.lastLine = text
					end

					net.Start( "nutChatSendMsg" );
						net.WriteString( text );
						net.WriteBool(isteamchat)
					net.SendToServer();
				end
			end
			self.text:SetAllowNonAsciiCharacters(true)
			self.text.Paint = function(this, w, h)
				surface.SetDrawColor(0, 0, 0, 100)
				surface.DrawRect(0, 0, w, h) 

				surface.SetDrawColor(32, 32, 32) --0, 0, 0, 200 
				surface.DrawOutlinedRect(0, 0, w, h)

				this:DrawTextEntryText(TEXT_COLOR, Color( 32, 32, 32 ), TEXT_COLOR)
			end
			self.text.OnTextChanged = function(this)
				local text = this:GetText()

				hook.Run("ChatTextChanged", text)
			end

			self.entry:MakePopup()
			self.text:RequestFocus()

			hook.Run("StartChat")
		end
	end

	local function OnDrawText(text, font, x, y, color, alignX, alignY, alpha)
		alpha = alpha or 255

		surface.SetTextPos(x+1, y+1)
		surface.SetTextColor(0, 0, 0, alpha)
		surface.SetFont(font)
		surface.DrawText(text)

		surface.SetTextPos(x, y)
		surface.SetTextColor(color.r, color.g, color.b, alpha)
		surface.SetFont(font)
		surface.DrawText(text)
		--draw.SimpleTextOutlined(text, font, x, y, ColorAlpha(color, alpha), 0, alignY, 1, ColorAlpha(color_black, alpha * 0.6))
	end

	function PANEL:addText(...)
		local text = "<font=nutChat>"

		if (LocalPlayer().msgFont ) then
			text = "<font="..(LocalPlayer().msgFont or "nutChat")..">"
			
			LocalPlayer().msgFont = nil;
		end
		
		for k, v in pairs({...}) do
			if (type(v) == "IMaterial") then
				local ttx = v:GetName()
				text = text.."<img="..ttx..","..v:Width().."x"..v:Height()..">"
			elseif (type(v) == "table" and v.r and v.g and v.b) then
				text = text.."<color="..v.r..","..v.g..","..v.b..">"
			elseif (type(v) == "Player") then
				local color = team.GetColor(v:Team())

				text = text.."<color="..color.r..","..color.g..","..color.b..">"..v:Name():gsub("<", "&lt;"):gsub(">", "&gt;")
			else
				text = text..tostring(v):gsub("<", "&lt;"):gsub(">", "&gt;")
				text = text:gsub("%b**", function(value)
					local inner = value:sub(2, -2)

					if (inner:find("%S")) then
						return "<font=RobotoMonoChat>"..value:sub(2, -2).."</font>"
					end
				end)
			end
		end

		text = text.."</font>"

		local panel = self.scroll:Add("nutChatBoxMarkup")
		panel:SetWide(self:GetWide() - 8)
		panel:setMarkup(text, OnDrawText)
		panel.start = CurTime() + 15
		panel.finish = panel.start + 20
		panel.Think = function(this)
			if (self.active) then
				this:SetAlpha(255)
			else
				this:SetAlpha((1 - math.TimeFraction(this.start, this.finish, CurTime())) * 255)
			end
		end

		panel:SetPos(0, self.lastY)
		self.lastY = self.lastY + panel:GetTall()
		
    	self.scroll:ScrollToChild(panel)

		return panel:IsVisible()
	end

	function PANEL:Think()
		if (gui.IsGameUIVisible() and self.active) then
			self.active = false

			if (IsValid(self.entry)) then
				self.entry:Remove()
			end
		end
	end
vgui.Register("nutChatBox", PANEL, "DPanel")