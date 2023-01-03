include("shared.lua")

function ENT:Draw()
    self:DrawModel()
    local offset = Vector(-6.5,-8.2,3.5)
    local ang = self:LocalToWorldAngles(Angle(0,90,0))
    local pos = self:LocalToWorld(offset)
    local research = GetGlobalString("Research", "Nothing")
    local name = 
    cam.Start3D2D(pos, ang, 0.03)
        surface.SetDrawColor(Color(255,255,255,255))
        surface.DrawRect(0,0,548,400)
        surface.SetDrawColor(Color(150,150,150,255))
        surface.DrawRect(6,6,536,388)
        draw.RoundedBox(10, 52, 105, 444, 258, Color(0,0,0,255))
        draw.RoundedBox(10, 54, 107, 440, 254, Color(0,150,0))
        surface.SetFont("DermaLarge")
        local x, y = surface.GetTextSize("Researching\n"..research)
        draw.RoundedBox(10, 60, 12, 428, y+10, Color(25,25,25,255))
        local act = self:GetModuleActive()
        if act then 
            draw.DrawText("<< :: ACTIVE :: >>", "DermaLarge", 274, 31, Color(0,255,0), TEXT_ALIGN_CENTER)
        else
            draw.DrawText("<< :: INACTIVE :: >>", "DermaLarge", 274, 31, Color(255,0,0), TEXT_ALIGN_CENTER)
        end
        local text = math.Clamp(math.Round((self:GetStartTime()+self:GetModuleExpire())-CurTime(),0), 0, self:GetModuleExpire()).." left before expirement"
        if !self:GetModuleActive() then
            text = "Boost currently not active"
        end
        draw.DrawText(self:GetModuleName().."\n"..text, "DermaLarge", 274, 111, Color(255,0,0), TEXT_ALIGN_CENTER)
        draw.DrawText("Level "..self:GetModuleLevel().." Module", "DermaLarge", 274, 320, Color(150,0,0), TEXT_ALIGN_CENTER)
    cam.End3D2D()
end
