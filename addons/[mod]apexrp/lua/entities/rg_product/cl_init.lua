include("shared.lua")

surface.CreateFont("Calibri72", {
	font = "Calibri",
	size = 72,
	extended = false,
})

function ENT:Draw()
	self:DrawModel()
	if self:GetIngredientName() then
		local pos = self:GetPos()
		local f, r, u = self:GetForward(), self:GetRight(), self:GetUp()
		local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Forward(), 90)
		-- ang.y = LocalPlayer():EyeAngles().y -90
		cam.Start3D2D(pos - ang:Right() * 20, ang, .10)
			draw.SimpleText(self:GetIngredientName(), "Calibri72", 0, 0, Color( 255, 255, 255, 255 ), 1, 1)
		cam.End3D2D()
		ang:RotateAroundAxis(ang:Right(), 180)
		cam.Start3D2D(pos - ang:Right() * 20, ang, .10)
			draw.SimpleText(self:GetIngredientName(), "Calibri72", 0, 0, Color( 255, 255, 255, 255 ), 1, 1)
		cam.End3D2D()
	end
end
