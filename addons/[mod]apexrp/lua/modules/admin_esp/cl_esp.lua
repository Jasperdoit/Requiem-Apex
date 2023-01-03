local showesp = false

hook.Add("HUDPaint", "APEX-ADMIN-ESP", function()
    local client = LocalPlayer()
    -- Do not show the ESP for non-admins. If this gets scripthooked and used, tough!
    if (not client:IsAdmin() or client:GetMoveType() ~= MOVETYPE_NOCLIP or not showesp) then return end
    -- Local counters to keep track of rebels and rioters (deprecated)
    local rebelcount = 0
    local rioters = 0

    for k, v in ipairs(ents.GetAll()) do
        if (v:IsPlayer()) then
            -- superadmins can hide themselves on the server, we don't want them to show up for admins.
            if v:GetNWBool("IsHidden") then continue end
            -- NWBool for rebel. If this is true, the player is a rebel. We set the client variable for later use. rebel and riotcount are used later on.
            if v:GetNWBool("IsRebelscum", false) and v:Alive() then
                v.IsRebel = true
                rebelcount = rebelcount + 1
            else
                v.IsRebel = nil
            end
            if v:GetNWBool("riot", false) then
                rioters = rioters + 1
            end
            -- If the entity is the client itself, dont bother.
            if v == client then continue end
            local position = v:LocalToWorld(v:OBBCenter()):ToScreen()
            local x, y = position.x, position.y

            draw.TextShadow({
                text = v:Name(),
                font = "RobotoMono18",
                pos = {x, y},
                color = ColorAlpha(team.GetColor(v:Team()), 255),
                xalign = TEXT_ALIGN_CENTER,
                yalign = TEXT_ALIGN_CENTER
            }, 1, 255)

            draw.TextShadow({
                text = v:SteamName(),
                font = "RobotoMono18",
                pos = {x, y + 15},
                color = ColorAlpha(team.GetColor(v:Team()), 255),
                xalign = TEXT_ALIGN_CENTER,
                yalign = TEXT_ALIGN_CENTER
            }, 1, 255)

            draw.DrawText("Health: " .. v:Health(), "RobotoMono18", x, y + 20, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)

            if v:Armor() > 0 then
                draw.DrawText("Armour: " .. v:Armor(), "RobotoMono18", x, y + 35, Color(0, 0, 255, 255), TEXT_ALIGN_CENTER)
            end
            -- I fogor what this was for
            if v:GetNWBool("Tagged", false) then
                draw.DrawText("SPECIAL", "RobotoMono18", x, y + 50, Color(255, 255, 0, 255), TEXT_ALIGN_CENTER)
            end
            -- Was for authed rogues.
            if v:GetNWBool("IsRogue", false) then
                draw.DrawText("ROGUE", "RobotoMono18", x, y + 50, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)
            end
            -- Rebel mains B)
            if v.IsRebel then
                draw.DrawText("REBEL", "RobotoMono18", x, y + 50, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)
            end
            -- Black market dealers.
            if v:GetNWInt("citopt") and v:GetNWInt("citopt") == 3 and v:Team() == TEAM_CITIZEN then
                draw.DrawText("BMD", "RobotoMono18", x, y + 65, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)
            end
            -- UU Spy (NYI)
            if v:GetNWBool("IsSpy", false) and LocalPlayer():IsSuperAdmin() then
                draw.DrawText("UU Spy", "RobotoMono18", x, y + 80, Color(255, 0, 255, 255), TEXT_ALIGN_CENTER)
            end
        else
            -- All entities in the "Universal Union" entity category get printed too.
            if (v.Category == "Universal Union") then
                local position = v:LocalToWorld(v:OBBCenter()):ToScreen()
                local x, y = position.x, position.y
                draw.DrawText(v.PrintName, "RobotoMono18", x, y, Color(150, 150, 150, 255))
            end
        end
    end
    -- UI for statistics
    surface.SetDrawColor(32, 32, 32, 130)
    surface.DrawRect(0, 220, 280, 100)
    draw.DrawText("Current Admin: " .. client:SteamName(), "RobotoMono18", 10, 10, Color(255, 65, 98, 200))
    draw.DrawText("Players connected: " .. #player.GetAll() .. "/" .. game.MaxPlayers(), "RobotoMono18", 10, 230, Color(255, 127, 80, 255))
    draw.DrawText("Entity count: " .. #ents.GetAll(), "RobotoMono18", 10, 250, Color(255, 127, 80, 255))
    draw.DrawText("Total combine: " .. #team.GetPlayers(TEAM_CP) + #team.GetPlayers(TEAM_OVERWATCH), "RobotoMono18", 10, 270, Color(255, 127, 80, 255))
    draw.DrawText("Total citizens: " .. #team.GetPlayers(TEAM_CITIZEN) .. " (" .. rebelcount .. " are rebels)", "RobotoMono18", 10, 290, Color(255, 127, 80, 255))
end)

concommand.Add("rg_showesp", function(p)
    -- Spam protection
    if (p.nextesptime or 0) > CurTime() then return end
    p.nextesptime = CurTime() + .2
    -- Admin check
    if not p:IsAdmin() then return end
    -- Toggle Switch
    if showesp then
        showesp = nil
        chat.AddText("ADMIN ESP OFF")
    else
        showesp = true
        chat.AddText("ADMIN ESP ON")
    end
end)