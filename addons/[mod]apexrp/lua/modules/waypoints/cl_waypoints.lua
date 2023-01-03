--local wptexture = surface.GetTextureID("waypointmarker/wpmarker")
local wptexture = surface.GetTextureID("models/effects/portalrift_sheet");
local Mat = Material("icon16/cancel.png")

DarkRP.declareChatCommand{
    command = "clearwaypoint",
    description = "Clears Waypoint",
    delay = 1.5
};
DarkRP.declareChatCommand{
    command = "clearwp",
    description = "Clear Waypoint",
    delay = 1.5
};
DarkRP.declareChatCommand{
    command = "waypoint",
    description = "Add a waypoint",
    delay = 1.5
};
DarkRP.declareChatCommand{
    command = "request",
    description = "Request help from UU people",
    delay = 1.5
};
DarkRP.declareChatCommand{
    command = "distress",
    description = "Request backup!",
    delay = 1.5
};
DarkRP.declareChatCommand{
    command = "11-99",
    description = "Request backup!",
    delay = 1.5
};
DarkRP.declareChatCommand{
    command = "needhelp",
    description = "Request backup!",
    delay = 1.5
};

net.Receive("waypointmarker", function()
    if LocalPlayer():IsCP() and not LocalPlayer():GetNWBool("noBiosignal") then
        local WaypointPos = net.ReadVector() + Vector(0, 0, 50)
        local StringTable = util.JSONToTable(net.ReadString())
        local WaypointPosScreen = WaypointPos:ToScreen()
        local time = 60
        local charlimit = 60
        local DistanceFromPly = tostring(math.Round(WaypointPos:Distance(LocalPlayer():GetPos()) / 28, 1), 1) .. " M"

        timer.Create(StringTable.steamid .. "UpdateWPPos", 0.01, time * 100, function()
            WaypointPosScreen = WaypointPos:ToScreen()
            -- DistanceFromPly = tostring(math.Round(WaypointPos:Distance(LocalPlayer():GetPos()) / 28, 1), 1) .. " M"
        end)
        timer.Create(StringTable.steamid .. "UpdateWPPos2", 1, time, function()
            DistanceFromPly = tostring(math.Round(WaypointPos:Distance(LocalPlayer():GetPos()) / 28, 1), 1) .. " M"
        end)

        function MakeWaypoint()
            draw.TexturedQuad({
                texture = wptexture,
                color = Color(255, 255, 255, 175),
                x = WaypointPosScreen.x - 16,
                y = WaypointPosScreen.y,
                w = 32,
                h = 32
            })

            draw.SimpleText("<:: " .. StringTable.name .. " ::>", "BudgetLabel", WaypointPosScreen.x, WaypointPosScreen.y + 30, Color(255, 255, 255, 175), TEXT_ALIGN_CENTER)
            draw.SimpleText("<:: DISTANCE: " .. DistanceFromPly .. " ::>", "BudgetLabel", WaypointPosScreen.x, WaypointPosScreen.y + 40, Color(255, 255, 255, 175), TEXT_ALIGN_CENTER)

            if StringTable.msg and StringTable.msg ~= "" then
                if #StringTable.msg > charlimit then
                    StringTable.msg = StringTable.msg:sub(1, charlimit) .. "..."
                end

                draw.SimpleText("<:: " .. StringTable.msg .. " ::>", "BudgetLabel", WaypointPosScreen.x, WaypointPosScreen.y + 50, Color(255, 255, 255, 175), TEXT_ALIGN_CENTER)
            end
        end

        hook.Add("HUDPaint", StringTable.steamid .. "WP", MakeWaypoint)

        timer.Simple(time, function()
            hook.Remove("HUDPaint", StringTable.steamid .. "WP")
            timer.Destroy(StringTable.steamid .. "UpdateWPPos")
            timer.Destroy(StringTable.steamid .. "UpdateWPPos2")
        end)
    end
end)

net.Receive("distressmarker", function()
    if LocalPlayer():IsCP() and not LocalPlayer():GetNWBool("noBiosignal") then
        local WaypointPos = net.ReadVector() + Vector(0, 0, 50)
        local StringTable = util.JSONToTable(net.ReadString())
        local WaypointPosScreen = WaypointPos:ToScreen()
        local time = 60
        local charlimit = 60
        local DistanceFromPly = tostring(math.Round(WaypointPos:Distance(LocalPlayer():GetPos()) / 28, 1), 1) .. " M"

        timer.Create(StringTable.steamid .. "UpdateWPPos", 0.01, time * 100, function()
            WaypointPosScreen = WaypointPos:ToScreen()
            -- DistanceFromPly = tostring(math.Round(WaypointPos:Distance(LocalPlayer():GetPos()) / 28, 1), 1) .. " M"
        end)
        timer.Create(StringTable.steamid .. "UpdateWPPos2", 1, time, function()
            DistanceFromPly = tostring(math.Round(WaypointPos:Distance(LocalPlayer():GetPos()) / 28, 1), 1) .. " M"
        end)

        surface.PlaySound("buttons/button17.wav")

        timer.Simple(0.1, function()
            surface.PlaySound("buttons/button17.wav")

            timer.Simple(0.1, function()
                surface.PlaySound("buttons/button17.wav")

                timer.Simple(0.1, function()
                    surface.PlaySound("buttons/button17.wav")

                    timer.Simple(0.1, function()
                        surface.PlaySound("buttons/button17.wav")
                    end)
                end)
            end)
        end)

        function MakeWaypoint()
            draw.TexturedQuad({
                texture = wptexture,
                color = Color(255, 255, 255, 175),
                x = WaypointPosScreen.x - 16,
                y = WaypointPosScreen.y,
                w = 32,
                h = 32
            })

            draw.SimpleText("<:: " .. "DISTRESS SIGNAL (11-99)" .. " ::>", "VCR18", WaypointPosScreen.x, WaypointPosScreen.y + 30, Color(0, 123, 255, 175), TEXT_ALIGN_CENTER)
            draw.SimpleText("<:: " .. StringTable.name .. " ::>", "VCR18", WaypointPosScreen.x, WaypointPosScreen.y + 45, Color(0, 123, 255, 175), TEXT_ALIGN_CENTER)
            draw.SimpleText("<:: DISTANCE: " .. DistanceFromPly .. " ::>", "VCR18", WaypointPosScreen.x, WaypointPosScreen.y + 60, Color(0, 123, 255, 175), TEXT_ALIGN_CENTER)

            if StringTable.msg and StringTable.msg ~= "" then
                if #StringTable.msg > charlimit then
                    StringTable.msg = StringTable.msg:sub(1, charlimit) .. "..."
                end

                draw.SimpleText("<:: " .. StringTable.msg .. " ::>", "BudgetLabel", WaypointPosScreen.x, WaypointPosScreen.y + 60, Color(0, 123, 255, 175), TEXT_ALIGN_CENTER)
            end
        end

        hook.Add("HUDPaint", StringTable.steamid .. "WP", MakeWaypoint)

        timer.Simple(time, function()
            hook.Remove("HUDPaint", StringTable.steamid .. "WP")
            timer.Destroy(StringTable.steamid .. "UpdateWPPos")
            timer.Destroy(StringTable.steamid .. "UpdateWPPos2")
        end)
    end
end)

net.Receive("deathmarker", function()
    if (LocalPlayer():IsCP() and not LocalPlayer():GetNWBool("noBiosignal")) or (LocalPlayer():Team() == TEAM_ADMINISTRATOR) then
        local WaypointPos = net.ReadVector() + Vector(0, 0, 50)
        local StringTable = util.JSONToTable(net.ReadString())
		
		if (LocalPlayer():Name() == StringTable.name) then return; end 
		
        local time = 60
        local charlimit = 24
        local WaypointPosScreen = WaypointPos:ToScreen()
        local DistanceFromPly = tostring(math.Round(WaypointPos:Distance(LocalPlayer():GetPos()) / 28, 1), 1) .. " M"

        timer.Create(StringTable.steamid .. "UpdateWPPos", 0.01, time * 100, function()
            WaypointPosScreen = WaypointPos:ToScreen()
            -- DistanceFromPly = tostring(math.Round(WaypointPos:Distance(LocalPlayer():GetPos()) / 28, 1), 1) .. " M"
        end)
        timer.Create(StringTable.steamid .. "UpdateWPPos2", 1, time, function()
            DistanceFromPly = tostring(math.Round(WaypointPos:Distance(LocalPlayer():GetPos()) / 28, 1), 1) .. " M"
        end)

        function MakeWaypoint()
            draw.TexturedQuad({
                texture = wptexture,
                color = Color(255, 0, 0, 175),
                x = WaypointPosScreen.x - 16,
                y = WaypointPosScreen.y,
                w = 32,
                h = 32
            })

            draw.SimpleText("<:: " .. StringTable.name .. " ::>", "BudgetLabel", WaypointPosScreen.x, WaypointPosScreen.y + 30, Color(255, 0, 0, 175), TEXT_ALIGN_CENTER)
            draw.SimpleText("<:: DISTANCE: " .. DistanceFromPly .. " ::>", "BudgetLabel", WaypointPosScreen.x, WaypointPosScreen.y + 40, Color(255, 0, 0, 175), TEXT_ALIGN_CENTER)
            draw.SimpleText("<:: Biosignal Loss ::>", "BudgetLabel", WaypointPosScreen.x, WaypointPosScreen.y + 50, Color(255, 0, 0, 175), TEXT_ALIGN_CENTER)
        end

        hook.Add("HUDPaint", StringTable.steamid .. "BSL", MakeWaypoint)

        timer.Simple(time, function()
            hook.Remove("HUDPaint", StringTable.steamid .. "BSL")
            timer.Destroy(StringTable.steamid .. "UpdateWPPos")
            timer.Destroy(StringTable.steamid .. "UpdateWPPos2")
        end)
    end
end)

net.Receive("requestmarker", function()
    if LocalPlayer():IsCP() and not LocalPlayer():GetNWBool("noBiosignal") then
        chat.AddText(Color(100, 100, 255), "INCOMING REQUEST.")
        surface.PlaySound("npc/overwatch/radiovoice/on3.wav")
        local WaypointPos = net.ReadVector() + Vector(0, 0, 50)
        local StringTable = util.JSONToTable(net.ReadString())
        local time = 60
        local charlimit = 24
        local WaypointPosScreen = WaypointPos:ToScreen()
        local DistanceFromPly = tostring(math.Round(WaypointPos:Distance(LocalPlayer():GetPos()) / 28, 1), 1) .. " M"

        timer.Create(StringTable.steamid .. "UpdateWPPos", 0.01, time * 100, function()
            WaypointPosScreen = WaypointPos:ToScreen()
            -- DistanceFromPly = tostring(math.Round(WaypointPos:Distance(LocalPlayer():GetPos()) / 28, 1), 1) .. " M"
        end)
        timer.Create(StringTable.steamid .. "UpdateWPPos2", 1, time, function()
            DistanceFromPly = tostring(math.Round(WaypointPos:Distance(LocalPlayer():GetPos()) / 28, 1), 1) .. " M"
        end)

        function MakeWaypoint()
            draw.TexturedQuad({
                texture = wptexture,
                color = Color(255, 102, 0, 175),
                x = WaypointPosScreen.x - 16,
                y = WaypointPosScreen.y,
                w = 32,
                h = 32
            })

            draw.SimpleText("<:: Recent Request Signal ::>", "BudgetLabel", WaypointPosScreen.x, WaypointPosScreen.y + 30, Color(255, 102, 0, 175), TEXT_ALIGN_CENTER)
            draw.SimpleText("<:: DISTANCE: " .. DistanceFromPly .. " ::>", "BudgetLabel", WaypointPosScreen.x, WaypointPosScreen.y + 40, Color(255, 102, 0, 175), TEXT_ALIGN_CENTER)
        end

        hook.Add("HUDPaint", StringTable.steamid .. "WP", MakeWaypoint)

        timer.Simple(time, function()
            hook.Remove("HUDPaint", StringTable.steamid .. "WP")
            timer.Destroy(StringTable.steamid .. "UpdateWPPos")
            timer.Destroy(StringTable.steamid .. "UpdateWPPos2")
        end)
    end
end)

net.Receive("clearmarkers", function()
	for _, ply in pairs(player.GetHumans()) do
		hook.Remove("HUDPaint", ply:SteamID() .. "WP")
		hook.Remove("HUDPaint", ply:SteamID() .. "BSL")
		timer.Remove(ply:SteamID() .. "UpdateWPPos")
		timer.Remove(ply:SteamID() .. "UpdateWPPos2")
	end
end)