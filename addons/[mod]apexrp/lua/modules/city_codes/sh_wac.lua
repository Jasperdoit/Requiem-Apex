if SERVER then
    AddCSLuaFile("menu/cl_wac.lua")
    AddCSLuaFile("menu/cl_menu.lua")
end

FcodeJWsongs = {
    Sound("music/hl1_song10.mp3"),
    Sound("music/hl1_song15.mp3"),
    Sound("music/hl2_song12_long.mp3"),
    Sound("music/hl2_song14.mp3"),
    Sound("music/hl2_song16.mp3"),
    Sound("music/hl2_song20_submix0.mp3"),
    Sound("music/hl2_song20_submix4.mp3"),
    Sound("music/hl2_song29.mp3"),
    Sound("music/hl2_song4.mp3"),
    Sound("music/vlvx_song11.mp3"),
    Sound("music/vlvx_song21.mp3"),
    Sound("music/vlvx_song4.mp3"),
    Sound("music/vlvx_song22.mp3"),
    Sound("music/vlvx_song23.mp3"),
    Sound("music/vlvx_song24.mp3"),
    Sound("music/vlvx_song25.mp3"),
    Sound("music/vlvx_song27.mp3"),
    Sound("music/vlvx_song9.mp3")
}

hook.Add("Initialize", "someInitidk", function()
    if CLIENT then
        include("menu/cl_wac.lua")
        include("menu/cl_menu.lua")
    end
end)

sound.Add({
    name = "fcode_erad_alarm",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 80,
    pitch = 75,
    sound = "ambient/alarms/combine_bank_alarm_loop1.wav",
})

wmCodes = wmCodes or {}

CODE_LIST = {
    {
        name = "GREEN",
        color = Color(0,255,0),
        icon = Material("icon16/shield.png"),
        desc = "For when everything is functioning normally",
        timer=180,
        admin = true
    },
    {
        name = "GREEN",
        color = Color(0,255,0),
        icon = Material("icon16/user.png"),
        desc = "For when everything is functioning normally",
    },
    {
        name = "YELLOW",
        color = Color(255,211,25),
        icon = Material("icon16/user_green.png"),
        desc = "For when there is a low amount of rebel activity",
       -- onHooks = {
           -- ["RenderScreenspaceEffects"] = function(code) 
              --  DrawColorModify({
             --      	["$pp_colour_addr"] = 0,
                 --   ["$pp_colour_addg"] = 0,
                --    ["$pp_colour_addb"] = 0,
               --     ["$pp_colour_brightness"] = -0.02,
                --    ["$pp_colour_contrast"] = 0.99,
               --     ["$pp_colour_colour"] = 0.9,
                --    ["$pp_colour_mulr"] = 0,
               --     ["$pp_colour_mulg"] = 0,
               --     ["$pp_colour_mulb"] = 0,
               -- })
            --end
        -- },
    },
    {
        name = "ORANGE",
        color = Color(180,64,16),
        icon = Material("icon16/user_orange.png"),
        desc = "For when there is a low amount of rebel activity",
       -- onHooks = {
           -- ["RenderScreenspaceEffects"] = function(code) 
             --   DrawColorModify({
               --     ["$pp_colour_addr"] = 0,
               --     ["$pp_colour_addg"] = 0,
               --     ["$pp_colour_addb"] = 0,
               --     ["$pp_colour_brightness"] = -0.02,
               --     ["$pp_colour_contrast"] = 0.96,
               --     ["$pp_colour_colour"] = 0.7,
               --     ["$pp_colour_mulr"] = 0,
               --     ["$pp_colour_mulg"] = 0,
                --    ["$pp_colour_mulb"] = 0,
              --  })
           -- end
        -- },
    },
    {
        name = "RED",
        color = Color(153,0,0),
        icon = Material("icon16/user_red.png"),
        desc = "For when there is a large amount of rebel activity",
        onHooks = {
           ["RenderScreenspaceEffects"] = function(code) 
               DrawColorModify({
                   ["$pp_colour_addr"] = 0,
                   ["$pp_colour_addg"] = 0,
                   ["$pp_colour_addb"] = 0,
                   ["$pp_colour_brightness"] = -0.02,
                   ["$pp_colour_contrast"] = 0.93,
                   ["$pp_colour_colour"] = 0.7,
                   ["$pp_colour_mulr"] = 0,
                   ["$pp_colour_mulg"] = 0,
                   ["$pp_colour_mulb"] = 0,
               })
           end
        },
    },
    {
        name = "BLACK",
        color = Color(0,0,0),
        icon = Material("icon16/cancel.png"),
        desc = "For when there is a large amount of rebel activity",
       onHooks = {
           ["RenderScreenspaceEffects"] = function(code) 
               DrawColorModify({
                   ["$pp_colour_addr"] = 0,
                   ["$pp_colour_addg"] = 0,
                   ["$pp_colour_addb"] = 0,
                   ["$pp_colour_brightness"] = -0.02,
                   ["$pp_colour_contrast"] = 0.91,
                   ["$pp_colour_colour"] = 0.65,
                   ["$pp_colour_mulr"] = 0,
                   ["$pp_colour_mulg"] = 0,
                   ["$pp_colour_mulb"] = 0,
               })
           end
        },
    },
    {
        name = "JUDGEMENT WAIVER",
        color = Color(255,0,0),
        icon = Material("icon16/exclamation.png"),
        desc = "For when a high level risk has been identified and confirmed",
        timer=68,
        onHooks = {
           ["RenderScreenspaceEffects"] = function(code) 
               DrawColorModify({
                   ["$pp_colour_addr"] = 0,
                   ["$pp_colour_addg"] = 0,
                   ["$pp_colour_addb"] = 0,
                   ["$pp_colour_brightness"] = -0.02,
                   ["$pp_colour_contrast"] = 0.91,
                   ["$pp_colour_colour"] = 0.5,
                   ["$pp_colour_mulr"] = 0,
                   ["$pp_colour_mulg"] = 0,
                   ["$pp_colour_mulb"] = 0,
               })
           end
        },
        onActivated = function(code)
            local JWSong = table.Random(FcodeJWsongs)
            if CLIENT then
                LocalPlayer():EmitSound("npc/overwatch/cityvoice/f_protectionresponse_5_spkr.wav", 75, 100, .5)
                timer.Create("JWTimer" .. LocalPlayer():SteamID(), 8, 1, function()
                    LocalPlayer():EmitSound("rg_citadel_alert_loop2.wav", 75, 100, .5)
                    util.ScreenShake(Vector(0,0,0), 5, 30, 4, 0)
                    timer.Create("JWTimer2" .. LocalPlayer():SteamID(), 60, 1, function()
                        LocalPlayer():EmitSound(JWSong, 55, 100, .3)
                    end)
                end)
            elseif SERVER then
                timer.Create("GlobalJWTimer1", 8, 1, function()
                     for _, person in pairs(player.GetHumans()) do
                         person:sendMsg(Color(255, 0, 0), "JUDGEMENT WAIVER ", Color(255,255,255), "has been activated. ", Color(0, 0, 0), "OTA", Color(255,255,255) , " can now leave the nexus; ", Color(0, 0, 255), "CPs", Color(255,255,255)," and ", Color(0, 0, 0), "OTA", Color(255,255,255)," can both now enter the 404 zone")
                         person:sendMsg(Color(255, 255, 255), "Residents outside must make their way indoors. If they're found outside after the grace period has ended, they'll be", Color(255, 0, 0), " amputated on sight!")
                     end
                    timer.Create("GlobalJWTimer2", 60, 1, function()
                        chat.AddText(Color(255, 255, 255), "The grace period has ended. Citizens found outside will be ", Color(255, 0, 0), "AMPUTATED.")
                         for _, person in pairs(player.GetHumans()) do
                             person:sendMsg(Color(255, 255, 255), "The grace period has ended. Citizens found outside will be ", Color(255, 0, 0), "AMPUTATED.")
                         end
                    end)
                end)
                timer.Create("GlobalJWTimer3", 360, 1, function()
                    for _, admin in pairs(player.GetHumans()) do
                        admin:sendMsg(Color(255, 255, 255), "Time's up! You should end JW, NOW!")
                    end
                end)
                SetGlobalBool("OTAOneLife", true)
                for _, ply in pairs(player.GetHumans()) do
                    if ply:Team() == TEAM_OVERWATCH then continue end
                    ply.otalifes = 1
                end
                SetGlobalInt("tax", 100)
            end
        end,
        onDisabled = function(code, nextcode)
            if CLIENT then
                timer.Remove("JWTimer" .. LocalPlayer():SteamID())
                timer.Remove("JWTimer1" .. LocalPlayer():SteamID())
                LocalPlayer():StopSound("npc/overwatch/cityvoice/f_protectionresponse_5_spkr.wav", 75, 100, .5)
                for _, soundpath in pairs(FcodeJWsongs) do
                    LocalPlayer():StopSound(soundpath)
                end
                if nextcode != 9 then
                    LocalPlayer():StopSound("rg_citadel_alert_loop2.wav")
                    timer.Simple(1, function()
                        LocalPlayer():EmitSound("doors/door_metal_large_chamber_close1.wav")
                    end)
                end
            elseif SERVER then
                SetGlobalInt("tax", 10)
                timer.Remove("GlobalJWTimer1")
                timer.Remove("GlobalJWTimer2")
                timer.Remove("GlobalJWTimer3")
                SetGlobalBool("OTAOneLife", false)
                 if nextcode != 9 then
                     for _, person in pairs(player.GetHumans()) do
                         person:sendMsg(Color(255, 0, 0), "JUDGEMENT WAIVER ", Color(255,255,255), "has been deactivated. ", Color(0, 0, 0), "OTA", Color(255,255,255), " must ", Color(0, 0, 0), "RIPCORD ", Color(255,255,255), "immediately")
                     end
                 end
            end
        end,
        hideZones = true,
        showTax = false,
    },
    {
        name = "BREACH",
        color = Color(255,80,0),
        icon = Material("icon16/shield.png"),
        desc = "For when a hostile force is breaching into the nexus",
        admin = true,
        showTax = false,
    },
    {
        name = "AUTONOMOUS JUDGEMENT",
        color = Color(0,0,255),
        icon = Material("icon16/shield.png"),
        desc = "For when the amputation of every civillian is necessary",
        admin = true,
        hideZones = true,
        showTax = false,
        onHooks = {
           ["RenderScreenspaceEffects"] = function(code)
               DrawColorModify({
                   ["$pp_colour_addr"] = 0,
                   ["$pp_colour_addg"] = 0,
                   ["$pp_colour_addb"] = 0,
                   ["$pp_colour_brightness"] = -0.02,
                   ["$pp_colour_contrast"] = 0.91,
                   ["$pp_colour_colour"] = 0.5,
                   ["$pp_colour_mulr"] = 0,
                   ["$pp_colour_mulg"] = 0,
                   ["$pp_colour_mulb"] = 0,
               })
           end
        },
        onActivated = function(code)
            if CLIENT then
                LocalPlayer():EmitSound("npc/overwatch/cityvoice/f_protectionresponse_4_spkr.wav", 55, 100, .5)
                timer.Create("AJTimer" .. LocalPlayer():SteamID(), 6, 1, function()
                    local song = table.Random(FcodeJWsongs)
                    LocalPlayer():EmitSound(song, 55, 100, .5)
                end)
            elseif SERVER then
                timer.Create("GlobalAJTimer", 6, 1, function()
                     for _, person in pairs(player.GetHumans()) do
                         person:sendMsg(Color(255, 0, 0), "AUTONOMOUS JUDGEMENT ", Color(255,255,255), "has been activated. All residents are to be ", Color(255, 0, 0), "AMPUTATED on sight", Color(255, 255, 255), "! All metabases are known to the Combine!")
                     end
                end)
                SetGlobalInt("tax", 100)
            end
        end,
        onDisabled = function(code)
            if CLIENT then
                timer.Remove("AJTimer" .. LocalPlayer():SteamID())
                LocalPlayer():StopSound("npc/overwatch/cityvoice/f_protectionresponse_4_spkr.wav")
                timer.Simple(1, function()
                    LocalPlayer():EmitSound("doors/door_metal_large_chamber_close1.wav")
                end)
                for _, soundpath in pairs(FcodeJWsongs) do
                    LocalPlayer():StopSound(soundpath)
                end
            elseif SERVER then
                 for _, person in pairs(player.GetHumans()) do
                     person:sendMsg(Color(255, 0, 0), "AUTONOMOUS JUDGEMENT ", Color(255,255,255), "has been deactivated. ", Color(0, 0, 0), "OTA", Color(255,255,255), " must ", Color(0, 0, 0), "RIPCORD ", Color(255,255,255), "immediately")
                 end
                SetGlobalInt("tax", 10)
            end
        end,
    },
    {
        name = "EVACUATION",
        color = Color(255,255,255),
        icon = Material("icon16/shield.png"),
        desc = "When the nexus reaches a state where evacuation is necessary",
        admin = true,
        showTax = false,
    },

    {
        name = "Hell",
        color = Color(255,0,0),
        icon = Material("icon16/user_red.png"),
        desc = "HELL",
        admin = true,
        hide = true,
    },
    {
        name = "Gay",
        color = Color(255,255,255),
        icon = Material("icon16/rainbow.png"),
        desc = "Gay",
        admin = true,
        hide = true,
        onHooks = {
            ["Think"] = function(code)
                if CLIENT then
                    code.color = HSVToColor(CurTime() * 30 % 360, 1, 1);
                end
            end
        }
    },

    {
        name = "ERADICATION",
        color = Color(0,0,0),
        icon = Material("icon16/world_delete.png"),
        desc = "Eradication",
        admin = true,
        hide = true,
        timer = 60,
        onActivated = function(code) -- When activated.
            if CLIENT then
                LocalPlayer():EmitSound("fcode_erad_alarm")
                chat.AddText(Color(255,255,255), "The city will be ",Color(0,0,0),"ERADICATED", Color(255,255,255), " in 60 seconds")
            end
        end,
        onTimerEnd = function() -- When the timer runs out.
            if CLIENT then
                LocalPlayer():StopSound("fcode_erad_alarm")
                LocalPlayer():EmitSound("ambient/explosions/citadel_end_explosion1.wav")
                chat.AddText(Color(255,255,255), "Powerful warheads fly from the sky and smash into the city, eradicating all forms of life within a 500 km radius")
            else
                for k, v in pairs(player.GetAll()) do
                    v:ScreenFade(SCREENFADE.IN, color_white, 2, 4)
                    v:KillSilent()
                end
            end
        end,
       onHooks = {
         --   ["RenderScreenspaceEffects"] = function(code) 
              --  DrawColorModify({
              --      ["$pp_colour_addr"] = 0,
                 --   ["$pp_colour_addg"] = 0,
                 --   ["$pp_colour_addb"] = 0,
                  --  ["$pp_colour_brightness"] = -0.06,
                  --  ["$pp_colour_contrast"] = 0.9,
                  --  ["$pp_colour_colour"] = 0.5,
                  --  ["$pp_colour_mulr"] = 0,
                  --  ["$pp_colour_mulg"] = 0,
                  --  ["$pp_colour_mulb"] = 0,
               -- })
           -- end,
            ["Tick"] = function(code)
                if SERVER then return end
                if GetGlobalInt("codetime", 0) + code.timer < CurTime() + 30 then
                    util.ScreenShake(Vector(0,0,0), 5, 40, 5, 0)
                    surface.PlaySound("ambient/outro/3rdamb.wav")
                    hook.Remove("Tick", "cityCodeHook")
                end
            end,
        },
        onDisabled = function(code)
            if CLIENT then
                LocalPlayer():StopSound("fcode_erad_alarm")
                local timer = code.timer or 0
                if timer + GetGlobalInt("codetime", 0) > CurTime() then
                    chat.AddText(Color(255,255,255), "The ",Color(0,0,0),"ERADICATION", Color(255,255,255), " of the city has been prevented")
                end
            end
        end,
        showTax = false,
        hideZones = true,
    },
    {
        name = "Tea in Sea",
        color = Color(66,206,244),
        icon = Material("icon16/cup.png"),
        desc = "NukeGoBoom's a nugget",
        admin = true,
        hide = true,
    },
    {
        name = "Judgement Waiver",
        color = Color(255,0,0),
        icon = Material("icon16/exclamation.png"),
        desc = "For when a high level risk has been identified and confirmed",
        admin = true,
        hide = true,
        showTax = false,
        hideZones = true,
    },
    {
        name = "BOMBS, you want it?",
        color = Color(255,128,10),
        icon = Material("icon16/bomb.png"),
        desc = "For when a high level risk has been identified and confirmed",
        admin = true,
        hide = true,
        showTax = true,
        hideZones = false,
    },
}


function wmCodes.addCode(settings)
    return table.insert(CODE_LIST, settings)
end

CODE_ZONES = {}

function wmCodes.addZoneCode(id, settings)
    settings.id = table.Count(CODE_ZONES)
    CODE_ZONES[id] = settings
    return settings
end

wmCodes.addZoneCode("func", {
    name = "STABLE",
    color = Color(0,255,0),
    icon = Material("icon16/user.png"),
    desc = "Sector is functional and nothing is wrong"
})

wmCodes.addZoneCode("threat", {
    name = "UNSTABLE",
    color = Color(255,255,0),
    icon = Material("icon16/bomb.png"),
    desc = "Hostile activity in this sector",
})

wmCodes.addZoneCode("hThreat", {
    name = "ENDANGERED",
    color = Color(255,180,0),
    icon = Material("icon16/error.png"),
    desc = "Heavy hostile activity in this sector",
})

wmCodes.addZoneCode("overtaken", {
    name = "FRACTURED",
    color = Color(255, 80, 0),
    icon = Material("icon16/cancel.png"),
    desc = "Hostile entities have taken over this sector "
})

wmCodes.addZoneCode("quarantine", {
    name = "QUARANTINED",
    color = Color(0, 150, 180),
    icon = Material("icon16/shape_square.png"),
    desc = "Sector enters quarantine. Civilians cannot enter or exit",
})

wmCodes.addZoneCode("lockdown", {
    name = "LOCKDOWN",
    color = Color(150, 0, 0),
    icon = Material("icon16/stop.png"),
    desc = "Sector enters lockdown. Same as quarantine, but roaming within the sector is restricted",
})

wmCodes.addZoneCode("ota", {
    name = "OVERWATCH DEPLOYED",
    admin = true,
    color = Color(50, 50, 50),
    icon = Material("icon16/shield.png"),
    desc = "OTA can enter this sector and swiftly deal with any issues",
    font = "code_zone",
    boxRender = function(static, posX, posY, sizeX, sizeY)
        static.RedColor = math.Approach(static.RedColor or 0, static.Desired or 180, 0.5)

        if static.RedColor == 180 then
            static.Desired = 0
        elseif static.RedColor == 0 then
            static.Desired = 180
        end

        draw.RoundedBox(0, posX, posY, sizeX, sizeY, Color(0, 0, 0, 150))
        surface.SetDrawColor(Color(static.RedColor, 0, 0, static.RedColor))
        surface.DrawOutlinedRect(posX, posY, sizeX, sizeY)

        return 0
    end,
    textRender = function(static, txt, col, x, y, font)
        draw.DrawText(txt, font, x, y, col, TEXT_ALIGN_LEFT)
    end,
})

wmCodes.addZoneCode("restricted", {
    name = "RESTRICTED",
    admin = true,
    color = Color(180, 180, 180, 50),
    icon = Material("icon16/shield.png"),
    desc = "This zone is restricted. Any civillian, whether it be outside or inside, this zone can be amputated",
    font = "code_zone",
    boxRender = function(static, posX, posY, sizeX, sizeY)
        static.RedColor = math.Approach(static.RedColor or 0, static.Desired or 180, 0.5)

        if static.RedColor == 180 then
            static.Desired = 0
        elseif static.RedColor == 0 then
            static.Desired = 180
        end

        draw.RoundedBox(0, posX, posY, sizeX, sizeY, Color(0, 0, 0, 150))
        surface.SetDrawColor(Color(static.RedColor, 0, 0, static.RedColor))
        surface.DrawOutlinedRect(posX, posY, sizeX, sizeY)

        return 0
    end,
    whitelist = true,
})

wmCodes.addZoneCode("briefing", {
    name = "BRIEFING",
    admin = true,
    color = Color(180, 180, 255),
    icon = Material("icon16/cog.png"),
    desc = "Summon all the CPs to this sector for briefing",
    whitelist = true, -- If it is in the blacklist, it is always whitelisted.
})

wmCodes.addZoneCode("gay", {
    name = "Surrounded with homosexuals",
    admin = true,
    hide = true,
    color = Color(0, 0, 0),
    icon = Material("icon16/cog.png"),
    desc = "oof",
    textRender = function(static, txt, col, x, y, font)
        static.code.color = HSVToColor(CurTime() * 30 % 360, 1, 1);
        draw.DrawText(txt, font, x, y, col, TEXT_ALIGN_LEFT)
    end,
})

wmCodes.addZoneCode("nugget", {
    name = "R.I.A. are nuggets",
    admin = true,
    hide = true,
    color = Color(66,206,244),
    icon = Material("icon16/cup_error.png"),
    desc = "nuggets",
})

WHITELISTED_TEAMS = { -- This is not needed as everyone can view the code. Only use it if you want a job to be able to change the code
    [21]=false -- Put [TEAM_CITIZEN]=true or something similar in this area to decide who can change the code. Put [TEAM_CITIZEN]=false to decide who can only view the code 
}

REST_CODE = {
	[5]=true,
	[6]=true,
	[7]=true,
    [8]=true,
    [9]=true,
    [10]=true
    
}

CITY_ZONES = {
    ["1"] = {
        name = "Nexus",
        code = "func",
        admin = true,
        isWhitelist = true,
        blacklisted = {
            ["func"] = true,
            ["overtaken"] = true,
            ["lockdown"] = true,
            ["briefing"] = true,
        }
    },
    ["2"] = {
        name = "Plaza",
        code = "func",
        admin = true,
        isWhitelist = true,
        blacklisted = {
            ["func"] = true,
            ["overtaken"] = true,
            ["ota"] = true,
        },
    },
    ["3"] = {
        name = "Sector 1",
        code = "func",
    },
    ["4"] = {
        name = "Sector 2",
        code = "func",
    },
    ["5"] = {
        name = "Sector 3",
        code = "func",
    },
    ["6"] = {
        name = "404 Zone",
        code = "restricted",
        admin = true,
        isWhitelist = true,
        blacklisted = {
            ["restricted"] = true,
            ["ota"] = true,
        },
    },
    ["7"] = {
        name = "Outlands",
        code = "restricted",
        admin = true,
        isWhitelist = true,
        blacklisted = {
            ["restricted"] = true,
            ["ota"] = true,
        },
    }
}

local function RefreshBlacklistedCodes()
    for k, v in pairs(CITY_ZONES) do
        v.blacklisted = v.blacklisted or {}

        v.code = GetGlobalString("code_"..k, v.code or "func")
        SetGlobalString("code_"..k, v.code)
    end
end

function wmCodes.addZone(settings)
    settings.code = settings.code or "func"
    CITY_ZONES[tostring( table.Count(CITY_ZONES) )] = settings
    if SERVER then
        RefreshBlacklistedCodes()
    end
end

if SERVER then
    RefreshBlacklistedCodes()
end