include('shared.lua') -- At this point the contents of shared.lua are ran on the client only.

surface.CreateFont("Robotogaming", {
	font = roboto,
	size = 16,
	extended = false
})
surface.CreateFont("Robotogaming2", {
	font = roboto,
	size = 14,
	extended = false
})

function ENT:Draw()
	self:DrawModel()
	if LocalPlayer():GetEyeTrace().Entity == self and EyePos():Distance( self:GetPos() ) < 512 then	
		hook.Add("PreDrawHalos", "Halo", function()
			if LocalPlayer():Team() == TEAM_CP or LocalPlayer():Team() == TEAM_OVERWATCH then
				halo.Add({ self }, Color(0, 0, 255), 0, 0, 0)
			end
		end)
	end
end

local color_blue = Color(0,63,200,80)
local color_grey = Color(63,63,63,170)
local color_darkgrey = Color(20,20,20,150)
local color_white = Color(255,255,255,255)

net.Receive("rg_jailer_openmenu", function()
	if frame then return end
	local scrw = ScrW()
    local scrh = ScrH()
	local frame = vgui.Create("DFrame")
    frame:SetSize(150, 150)
    frame:Center()
    frame:SetTitle("")
    frame:MakePopup()
    frame.Paint = function(me,w,h)
        draw.RoundedBox(5, 0, 0, w, h, color_darkgrey)
		draw.SimpleText("CYCLE AMOUNT:", "Robotogaming", 75, 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    frame.Think = function(self)
        if (!LocalPlayer():Alive()) then self:Remove() end
    end

	-- local label = vgui.Create("DLabel", frame)
	-- label:SetPos(50, 50)
	-- label:SetText("Cycle Amount:")

	local slider = vgui.Create("DNumSlider", frame)
	slider:SetPos(-50, 50)
	slider:SetSize(200, 50)
	slider:SetText("")
	slider:SetMin(0)
	slider:SetMax(10)
	slider:SetDecimals(0)
	local button = vgui.Create("DButton", frame)
	local textentry = vgui.Create("DTextEntry", frame)
	textentry:SetPos(25, 90)
	textentry:SetSize(100, 20)
	textentry:SetPlaceholderText("INPUT REASON")
	button:SetPos(50, 120)
	button:SetSize(50, 25)
	button:SetText("")
	button.Paint = function(me,w,h)
		draw.RoundedBox(0, 0, 0, w, h, color_grey)
		draw.SimpleText("ARREST", "Robotogaming2", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	button.DoClick = function()
	if slider:GetValue() > 10 or slider:GetValue() <= 0 then return end
		print("Sending net...")
		net.Start("rg_jailer_jail")
		net.WriteInt(slider:GetValue(), 32)
		net.WriteString(textentry:GetValue())
		net.SendToServer()
	end
end)