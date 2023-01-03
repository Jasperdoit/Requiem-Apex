include("shared.lua")

surface.CreateFont("Calibri72", {
	font = "Calibri",
	size = 120,
	extended = false,
})
surface.CreateFont("Calibri73", {
	font = "Calibri",
	size = 180,
	extended = false,
})

local color_black = Color(0,0,0)
local color_white = Color( 255, 255, 255 )
local color_red = Color( 255, 0, 0 )
local color_blue = Color( 0, 0, 255 )
function ENT:Draw()
	self:DrawModel()
	local pos = self:GetPos()
	local f, r, u = self:GetForward(), self:GetRight(), self:GetUp()
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Forward(), 0)
	-- ang.y = LocalPlayer():EyeAngles().y -90
	cam.Start3D2D(pos + ang:Up()*2 + ang:Forward()*-71 + ang:Right()*-95 , ang, 1)
		draw.RoundedBox(0, 0, 0, 142, 190, color_black)
	cam.End3D2D()
	ang:RotateAroundAxis(ang:Up(), 180)
	local offset = -650
	cam.Start3D2D(pos + ang:Up()*2, ang, 0.11)
		draw.SimpleText("Stock list", "Calibri73", 0, -800, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
	for classname, ent in pairs(StockSystem.ShipmentList) do
		cam.Start3D2D(pos + ang:Up()*2, ang, 0.11)
			draw.SimpleText(ent.displayname .. ": ", "Calibri72", -600, offset, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			if GetGlobalInt(classname, 20) < 10 then
				draw.SimpleText(GetGlobalInt(classname, 20), "Calibri72", 300, offset, color_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			elseif GetGlobalInt(classname, 20) > 30 then
				draw.SimpleText(GetGlobalInt(classname, 20), "Calibri72", 300, offset, color_blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw.SimpleText(GetGlobalInt(classname, 20), "Calibri72", 300, offset, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		cam.End3D2D()
		offset = offset + 110
	end
end
