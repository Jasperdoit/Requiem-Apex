include("shared.lua")

function ENT:Draw()
    self:DrawModel()
    local offset = Vector(57.5,-22.5,20)
    local ang = self:LocalToWorldAngles(Angle(0,90,90))
    local pos = self:LocalToWorld(offset)
    local key = GetGlobalString("keyres","none")
    local level = GetGlobalInt("Level", 1)
    key = string.gsub(key, tostring(level), "")
    local research
    if wmResearch[key] then
        research = wmResearch[key].Name.." (Lv. "..GetGlobalInt("Level",1)..")"
    else
        research = "None"
    end
    local progress = GetGlobalInt("Progress",0)
    local required = GetGlobalInt("Required",1)
    cam.Start3D2D(pos, ang, 0.08)
        surface.SetDrawColor(Color(255,255,255,255))
        surface.DrawRect(0,0,512,512)
        surface.SetDrawColor(Color(150,150,150,255))
        surface.DrawRect(6,6,500,500)
        draw.RoundedBox(2, 52, 22, 408, 50, Color(50,50,50,255))
        draw.RoundedBox(2, 53, 23, 406*math.Clamp(progress/required, 0, 1), 48, Color(0,150,255,255))
        draw.DrawText("Research progress", "DermaLarge", 256, 31, Color(0,50,180), TEXT_ALIGN_CENTER)
        draw.RoundedBox(10, 52, 105, 408, 358, Color(0,0,0,255))
        draw.RoundedBox(10, 54, 107, 404, 354, Color(0,150,0))
        surface.SetFont("DermaLarge")
        local x, y = surface.GetTextSize("Researching\n"..research)
        draw.RoundedBox(10, 60, 111, 392, y+10, Color(25,25,25,255))
        draw.DrawText("<< :: Researching :: >>\n"..research, "DermaLarge", 256, 111, Color(255,150,0), TEXT_ALIGN_CENTER)
        draw.DrawText(math.floor(math.Clamp(progress, 0, required)).."/"..required, "DermaLarge", 256, 72, Color(0,50,180,255), TEXT_ALIGN_CENTER)
        draw.DrawText("Level "..(self:GetFactoryLevel("level") or 1).." Laboratory", "DermaLarge", 256, 420, Color(150,0,0), TEXT_ALIGN_CENTER)
    cam.End3D2D()
end
