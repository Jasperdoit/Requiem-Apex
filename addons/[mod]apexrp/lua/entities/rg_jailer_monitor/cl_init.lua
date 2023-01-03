include('shared.lua') -- At this point the contents of shared.lua are ran on the client only.
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

local color_grey = Color(63,63,63,240)
local color_darkgrey = Color(20,20,20,200)

net.Receive("rg_jailmonitor_open", function()
	if frame then return end

	local frame = vgui.Create("DFrame")
    frame:SetSize(250, 200)
    frame:Center()
    frame:SetTitle("")
    frame:MakePopup()
    frame.Paint = function(me,w,h)
        draw.RoundedBox(5, 0, 0, w, h, color_darkgrey)
        draw.RoundedBox(0, 10, h / 2 , 230, 80, color_grey)
    end
    frame.Think = function(self)
        if (!LocalPlayer():Alive()) then self:Remove() end
    end
	local namelabel = vgui.Create("DLabel", frame)
	namelabel:SetPos(15, 105)
	namelabel:SetText("")
	local teamlabel = vgui.Create("DLabel", frame)
	teamlabel:SetPos(15, 120)
	teamlabel:SetText("")
	local jailtimelabel = vgui.Create("DLabel", frame)
	jailtimelabel:SetPos(15, 135)
	jailtimelabel:SetText("")
	local jailreasonlabel = vgui.Create("DLabel", frame)
	jailreasonlabel:SetPos(15, 150)
	jailreasonlabel:SetText("")

	local function UpdatePanel(ply)
		if ply and ply:IsValid() and ply:IsPlayer() and ply:GetNWInt("JailTimeRemaining", 0) ~= 0 then
			namelabel:SetText("RESIDENT NAME: " .. ply:Name())
			namelabel:SizeToContents()
			teamlabel:SetText("ROLE: " .. team.GetName(ply:Team()))
			teamlabel:SizeToContents()
			jailtimelabel:SetText("SENTENCE TIME: " .. math.Round(math.Round(ply:GetNWInt("JailTimeRemaining", 0) - CurTime()) / 60) .. " CYCLE(S)")
			jailtimelabel:SizeToContents()
			jailreasonlabel:SetText("REASON: " .. ply:GetNWString("arrestreason", "NONE GIVEN"))
			jailreasonlabel:SizeToContents()
		else
			namelabel:SetText("RESIDENT NAME: INVALID")
			namelabel:SizeToContents()
			teamlabel:SetText("ROLE: INVALID")
			teamlabel:SizeToContents()
			jailtimelabel:SetText("SENTENCE TIME: INVALID")
			jailtimelabel:SizeToContents()
			jailreasonlabel:SetText("REASON: INVALID")
			jailreasonlabel:SizeToContents()
		end
	end
	UpdatePanel()
	local selectionbox = vgui.Create("DComboBox", frame)
	selectionbox:SetPos(frame:GetWide() / 2 - 75, 50)
	selectionbox:SetSize(150, 30)
	selectionbox:SetValue("SELECT A PRISONER")
	for _, ply in pairs(player.GetAll()) do
		if ply:GetNWInt("JailTimeRemaining", 0) ~= 0 then
			selectionbox:AddChoice(ply:Name())
		end
	end
	selectionbox.OnSelect = function(self, index, value)
		for _, ply in pairs(player.GetAll()) do
			if ply:IsValid() and ply:Name() == value and ply:GetNWInt("JailTimeRemaining", 0) ~= 0 then
				UpdatePanel(ply)
			end
		end
	end

end)