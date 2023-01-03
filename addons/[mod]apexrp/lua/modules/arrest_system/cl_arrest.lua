surface.CreateFont("CalibriJail", {
    font = "Calibri",
    size = 40,
    extended = false
});

net.Receive("GiveClientJailTime", function()
    local jailtime = net.ReadInt(32)
    if not jailtime then return end
    hook.Add("HUDPaint", "Drawjailtime", function()
        if jailtime == 0 or CurTime() > jailtime then
            hook.Remove("HUDPaint", "DrawJailtime")
            return
        end
        surface.SetFont("CalibriJail")
        surface.SetTextColor(255, 255, 255)
        surface.SetTextPos(ScrW() - 450, ScrH() - 50)
        surface.DrawText("Your remaining arresttime is: " .. math.Round(jailtime - CurTime()))
    end)
end);

DarkRP.declareChatCommand{
    command = "release",
    description = "Releases the player you are looking at.",
    delay = 1.5
};