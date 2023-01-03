sewersweep = sewersweep or {
    active = GetGlobalBool("sewersweepActive", false),
    ota = GetGlobalBool("sewersweepActive", false),
}

function sewersweep:getActive()
    return GetGlobalBool("sewersweepActive", false)
end

function sewersweep:getOTA()
    return ota
end

function sewersweep:getActiveOTA()
    return GetGlobalBool("sewersweepActive", false) and ota
end

if SERVER then
    function sewersweep:setActive()
        local color_white = Color(255, 255, 255)
        local color_red = Color(255, 0, 0)
        local color_blue = Color(0, 0, 255)
        local color_cyan = Color(67, 255, 255)
        local color_orange = Color(255, 191, 0)
        if GetGlobalBool("sewersweepActive", false) then
            SetGlobalBool("sewersweepActive", false)
            for _, ply in pairs(player.GetAll()) do
                if not ply:isCombine() then continue end
                ply:sendMsg(team.GetColor(TEAM_DISPATCH), "Dispatch", color_white, ": Attention, ", color_cyan, "Sewer Sweep ", color_white, "is now ", color_red, "no longer in effect", color_white, "! All units must vacate the ", color_orange, "404 zone ", color_red, "immediately", color_white, "!")
            end
        else
            SetGlobalBool("sewersweepActive", true)
            for _, ply in pairs(player.GetAll()) do
                if not ply:isCombine() then continue end
                ply:sendMsg(team.GetColor(TEAM_DISPATCH), "Dispatch", color_white, ": Attention, ", color_cyan, "Sewer Sweep ", color_white, "is now ", color_blue, "in effect", color_white, ". All " , team.GetColor(TEAM_CP), "Civil Protection units ", color_white, "are allowed to enter the ", color_red, "404 zone ", color_white, "to sweep for ", color_orange, "malignants", color_white, "!")
                ply:sendMsg(color_white, "It is recommended to stick in ", color_blue, "protection teams ", color_white, "of atleast 3 units to yeild the most effective sweep!")
            end
        end
    end

    function sewersweep:setOTA()
        if sewersweep.ota then
            sewersweep.ota = false
        else
            sewersweep.ota = true
        end
    end

    concommand.Add("rg_getactivesweep", function(ply)
        if not ply:IsAdmin() then return end;
        ply:ChatPrint(tostring(sewersweep:getActive()))
    end)

    concommand.Add("rg_setactivesweep", function(ply)
        if not ply:IsAdmin() then return end;
        sewersweep:setActive()
    end)
end

if CLIENT then
    hook.Add("HUDPaint", "Sewersweeptext", function()
        if GetGlobalBool("sewersweepActive", false) == true and LocalPlayer():isCombine() then
                draw.SimpleText("SEWER SWEEP", "DermaLargestuff", ScrW() / 2, 100, Color( 255, 255, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText("All CP's are allowed to enter the 404 zone!", "Dermanormalstuff", ScrW() / 2, 25, Color( 255, 255, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end)
end