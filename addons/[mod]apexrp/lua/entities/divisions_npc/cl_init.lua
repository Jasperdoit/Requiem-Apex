include('shared.lua') -- At this point the contents of shared.lua are ran on the client only.
-- error("cry about it")
function ENT:Draw()
    self:DrawModel()

    if LocalPlayer():GetEyeTrace().Entity == self and EyePos():Distance(self:GetPos()) < 512 then
        hook.Add("PreDrawHalos", "Halo", function()
            if LocalPlayer():isCombine() then
                halo.Add({self}, Color(0, 0, 255), 0, 0, 0)
            end
        end)
    end
end