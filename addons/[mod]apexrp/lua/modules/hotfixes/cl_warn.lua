surface.CreateFont("PANIC", {
    font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
    extended = false,
    size = 150,
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
})

local mat = Material("entities/npc_breen.png") -- Calling Material() every frame is quite expensive
local mat2 = Material("entities/npc_gman.png") -- Calling Material() every frame is quite expensive

function RCountDown()
    timer.Create("RESTARTCOUNTDOWN", 60, 1, function()
        for v, k in pairs(player.GetAll()) do
            k:ChatPrint("pranked")
        end
    end)

    surface.PlaySound("ambient/alarms/alarm_citizen_loop1.wav")

    hook.Add("HUDPaint", "RESTARTCOUNTER", function()
        local tleft = timer.TimeLeft("RESTARTCOUNTDOWN")
        if not timer.Exists("RESTARTCOUNTDOWN") then return hook.Remove("HUDPaint", "RESTARTCOUNTER") end -- elseif tleft < 120 then -- surface.SetDrawColor(255,0,0,90) -- surface.DrawRect(0,0,ScrW(),ScrH())
        draw.DrawText("The server is restarting soon, please panic!", DermaDefault, ScrW() / 2, ScrH() / 10, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)
        draw.DrawText(string.FormattedTime(tleft, "%02i:%02i:%02i"), "PANIC", ScrW() / 2, ScrH() / 8, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)
    end)
end