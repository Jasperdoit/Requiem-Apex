-- local TextColor = Color(GetConVar("Healthforeground1"):GetFloat(), GetConVar("Healthforeground2"):GetFloat(), GetConVar("Healthforeground3"):GetFloat(), GetConVar("Healthforeground4"):GetFloat())

local TextColor = Color(180, 20, 0)

local function AFKHUDPaint()
    if not LocalPlayer():getDarkRPVar("AFK") then return end
    -- draw.DrawNonParsedSimpleText(DarkRP.getPhrase("afk_mode"), "DarkRPHUD2", ScrW() / 2, (ScrH() / 2) - 100, TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("You have been placed into AFK Mode.", "DermaDefault", ScrW() / 2, (ScrH() / 2) - 100, TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    -- draw.DrawNonParsedSimpleText(DarkRP.getPhrase("salary_frozen"), "DarkRPHUD2", ScrW() / 2, (ScrH() / 2) - 60, TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("Your Salery has been frozen and so has your XP.", "DermaDefault", ScrW() / 2, (ScrH() / 2) - 60, TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    
    draw.SimpleText("Type /afk to get out of this mode.", "DermaDefault", ScrW() / 2, (ScrH() / 2) - 20, TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

hook.Add("HUDPaint", "AFK_HUD", AFKHUDPaint)
