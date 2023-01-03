surface.CreateFont("Roboto16", {
    font = "Roboto",
    extended = false,
    size = 16,
    weight = 500,
})

surface.CreateFont("Roboto24", {
    font = "Roboto",
    extended = false,
    size = 24,
    weight = 500,
})

surface.CreateFont("Roboto36", {
    font = "Roboto",
    extended = false,
    size = 36,
    weight = 500,
})


local function FindDivision(ply)
    -- Return "INVALID" if the player is not a valid, alive player entity.
    if not (ply:IsValid() and ply:IsPlayer() and ply:Alive()) then
        return "INVALID"
    end

    -- Search for the player's division in the RogueMenu.Divisions table.
    for _, division in pairs(RogueMenu.Divisions) do
        if string.find(string.lower(ply:Name()), "-" .. division .. "-") then
            return division
        end
    end

    -- Return "NONE" if the player has no division.
    return "NONE"
end

local function FindRank(ply)
    -- Return "INVALID" if the player is not a valid, alive player entity.
    if not (ply:IsValid() and ply:IsPlayer() and ply:Alive()) then
        return "INVALID"
    end

    -- Split the player's name by the "-" character.
    local name_table = string.Explode("-", ply:Name())

    -- Return the third element in the name table if it exists, otherwise return "INVALID".
    return name_table[3] or "INVALID"
end

function RogueMenu.Open()
    local scrw = ScrW()
    local scrh = ScrH()
    local scrwCenter, scrhCenter = scrw / 2, scrh / 2
    RogueMenu.MenuFrame = vgui.Create("DFrame")
    RogueMenu.MenuFrame:SetSize(1000, 600)
    RogueMenu.MenuFrame:Center()
    RogueMenu.MenuFrame:SetTitle("")
    RogueMenu.MenuFrame:MakePopup()
    RogueMenu.MenuFrame.Paint = function(me,w,h)
        draw.RoundedBox(5, 0, 0, w, h, RogueMenu.Theme["backgroundcolor"])
    end
    RogueMenu.MenuFrame.Think = function(self)
        if (!LocalPlayer():Alive()) then self:Remove() end
    end

    --Profile Button panel

    RogueMenu.ProfilePanel = vgui.Create("DPanel", RogueMenu.MenuFrame)
    RogueMenu.ProfilePanel:SetPos(300,50)
    RogueMenu.ProfilePanel:SetSize(650,200)
    RogueMenu.ProfilePanel.Paint = function(me,w,h)
        draw.RoundedBox(0, 0, 0, w, h, RogueMenu.Theme["profilepanel"])
    end

    --Empty Profile Picture panel

    RogueMenu.ProfilePicPanel = vgui.Create("DPanel", RogueMenu.MenuFrame)
    RogueMenu.ProfilePicPanel:SetPos(50,50)
    RogueMenu.ProfilePicPanel:SetSize(200,200)
    RogueMenu.ProfilePicPanel.Paint = function(me,w,h)
        draw.RoundedBox(0, 0, 0, w, h, RogueMenu.Theme["black"])
    end

    --Show the profile of the CP
    RogueMenu.ProfilePic = RogueMenu.ProfilePic || false
    local function ShowProfile(ply)
        --Profile picture
        if RogueMenu.ProfilePic then RogueMenu.ProfilePic:Remove() end

        local ProfilePic = vgui.Create("DModelPanel", RogueMenu.ProfilePicPanel)
        ProfilePic:SetModel(ply:GetModel())
        ProfilePic:SetModel(ply:GetModel(), ply:GetSkin())
        for i = 1, table.Count(ply:GetBodyGroups()) do
            ProfilePic.Entity:SetBodygroup(i, ply:GetBodygroup(i))
        end
        ProfilePic:Dock(FILL)
        function ProfilePic:LayoutEntity(ent)
            if ply:Team() == TEAM_CP then
                ent:SetSequence(7)
            elseif ply:Team() == TEAM_CWU then
                ent:SetSequence(2)
            end
            ProfilePic:RunAnimation()
            ProfilePic:SetAnimSpeed( 1 )
            return
        end
        RogueMenu.ProfilePic = ProfilePic
        local eyepos = ProfilePic.Entity:GetBonePosition(ProfilePic.Entity:LookupBone("ValveBiped.Bip01_Head1"))
        eyepos:Add(Vector(0, 0, -2))
        ProfilePic:SetLookAt(eyepos)
        ProfilePic:SetCamPos(eyepos-Vector(-24, 0, 0))
        RogueMenu.ProfilePanel.Paint = function(me,w,h)
            draw.RoundedBox(0, 0, 0, w, h, RogueMenu.Theme["profilepanel"])
            local isrogue = ply:GetNWBool("IsRogue", false)
            if ply:Team() == TEAM_CP then
                draw.SimpleText("NAME: " .. string.upper(ply:Name()), "Roboto24", 10, 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                local divisionname = FindDivision(ply)
                local rank = FindRank(ply)
                draw.SimpleText("DIVISION: " .. string.upper(divisionname), "Roboto24", 10, 60, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                draw.SimpleText("RANK: " .. string.upper(rank), "Roboto24", 10, 100, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                draw.SimpleText("IS ROGUE: ", "Roboto24", 10, 140, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                if isrogue then
                    draw.SimpleText(string.upper(tostring(isrogue)), "Roboto24", 105, 140, RogueMenu.Theme["cproguecolor"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                else
                    draw.SimpleText(string.upper(tostring(isrogue)), "Roboto24", 105, 140, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end
            elseif ply:Team() == TEAM_CWU then
                draw.SimpleText("NAME: " .. string.upper(ply:Name()), "Roboto24", 10, 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                draw.SimpleText("IS ROGUE: ", "Roboto24", 10, 60, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                if isrogue then
                    draw.SimpleText(string.upper(tostring(isrogue)), "Roboto24", 105, 60, RogueMenu.Theme["cproguecolor"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                else
                    draw.SimpleText(string.upper(tostring(isrogue)), "Roboto24", 105, 60, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end
            end
        end

        -- Buttons
        if RogueMenu.RogueButton then RogueMenu.RogueButton:Remove() end
        if RogueMenu.RogueDenyButton then RogueMenu.RogueDenyButton:Remove() end
        if RogueMenu.CancelRogueButton then RogueMenu.CancelRogueButton:Remove() end
        if not ply:GetNWBool("IsRogue", false) then
            RogueMenu.RogueButton = vgui.Create("DButton", RogueMenu.ProfilePanel)
            RogueMenu.RogueButton:SetPos(250, 50)
            RogueMenu.RogueButton:SetSize(150, 35)
            RogueMenu.RogueButton:SetText("")
            RogueMenu.RogueButton.Paint = function(me,w,h)
                draw.RoundedBox(0, 0, 0, w, h, RogueMenu.Theme["cpactivecolor"])
                draw.SimpleText("Mark Rogue", "Roboto16", w / 2, h / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
            RogueMenu.RogueButton.DoClick = function()
                net.Start("MarkRogue")
                net.WriteEntity(ply)
                net.SendToServer()
                if RogueMenu.Scrollbar then
                    RogueMenu.Scrollbar:Remove()
                    RogueMenu.CreateScrollbar()
                end
            end
            RogueMenu.RogueDenyButton = vgui.Create("DButton", RogueMenu.ProfilePanel)
            RogueMenu.RogueDenyButton:SetPos(450, 50)
            RogueMenu.RogueDenyButton:SetSize(150, 35)
            RogueMenu.RogueDenyButton:SetText("")
            RogueMenu.RogueDenyButton.Paint = function(me,w,h)
                draw.RoundedBox(0, 0, 0, w, h, Color(255,0,0))
                draw.SimpleText("Deny Rogue", "Roboto16", w / 2, h / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
            RogueMenu.RogueDenyButton.DoClick = function()
                net.Start("DenyRogue")
                net.WriteEntity(ply)
                net.SendToServer()
                if RogueMenu.Scrollbar then
                    RogueMenu.Scrollbar:Remove()
                    RogueMenu.CreateScrollbar()
                end
            end
        end
        if ply:GetNWBool("IsRogue", false) then
            RogueMenu.CancelRogueButton = vgui.Create("DButton", RogueMenu.ProfilePanel)
            RogueMenu.CancelRogueButton:SetPos(450, 100)
            RogueMenu.CancelRogueButton:SetSize(150, 35)
            RogueMenu.CancelRogueButton:SetText("")
            RogueMenu.CancelRogueButton.Paint = function(me,w,h)
                draw.RoundedBox(0, 0, 0, w, h, Color(255,114,0))
                draw.SimpleText("Cancel Rogue", "Roboto16", w / 2, h / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
            RogueMenu.CancelRogueButton.DoClick = function()
                net.Start("CancelRogue")
                net.WriteEntity(ply)
                net.SendToServer()
                if RogueMenu.Scrollbar then
                    RogueMenu.Scrollbar:Remove()
                    RogueMenu.CreateScrollbar()
                end
            end
        end
    end

    --Scrollbar with players
    RogueMenu.CreateScrollbar = function()
        RogueMenu.Scrollbar = vgui.Create("DScrollPanel", RogueMenu.MenuFrame)
        RogueMenu.Scrollbar:Dock(FILL)
        RogueMenu.Scrollbar:DockMargin(50, 250, 50, 0)
        RogueMenu.Scrollbar.Paint = function(me,w,h)
            draw.RoundedBox(0, 0, 0, w, h, RogueMenu.Theme["scrollpanelcolor"])
        end

        --Customizes the scrollbar

        local sbar = RogueMenu.Scrollbar:GetVBar()
        function sbar:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
        end
        function sbar.btnUp:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100))
        end
        function sbar.btnDown:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100))
        end
        function sbar.btnGrip:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(200, 200, 200))
        end

        local yspace = RogueMenu.Scrollbar:GetTall() * 0.2
        local xspace = RogueMenu.Scrollbar:GetWide() * 0.2
        -- for k, combine in pairs(player.GetHumans()) do

        -- Put CPs into the scrollbaritems

        for _, cp in pairs(player.GetHumans()) do
            if (cp:Team() == TEAM_CP or cp:Team() == TEAM_CWU) and (cp:GetNWBool("SentRogueRequest", false) or cp:GetNWBool("IsRogue", false)) then
                local personitem = vgui.Create("DPanel", RogueMenu.Scrollbar)
                personitem:DockMargin(0,0,0,yspace)
                personitem:Dock(TOP)
                personitem:SetTall(RogueMenu.Scrollbar:GetTall() * 2.2)
                personitem.Paint = function(me,w,h)
                    if cp:Team() == TEAM_CP then
                        if cp:GetNWBool("IsRogue", false) then
                            draw.RoundedBox(0, 0, 0, w, h, RogueMenu.Theme["cproguecolor"])
                        else
                            draw.RoundedBox(0, 0, 0, w, h, RogueMenu.Theme["cpactivecolor"])
                        end
                    elseif cp:Team() == TEAM_CWU then
                        if cp:GetNWBool("IsRogue", false) then
                            draw.RoundedBox(0, 0, 0, w, h, RogueMenu.Theme["cproguecolor"])
                        else
                            draw.RoundedBox(0, 0, 0, w, h, Color(123, 147, 163, 255))
                        end
                    end
                    draw.SimpleText(cp:Name(), "Roboto36", personitem:GetWide() / 2, personitem:GetTall() / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
                local selectbutton = vgui.Create("DButton", personitem)
                selectbutton:Dock(FILL)
                selectbutton:SetText("")
                selectbutton.Paint = function(me,w,h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,0))
                end
                selectbutton.DoClick = function()
                    ShowProfile(cp)
                end
            end
        end
    end
    RogueMenu.CreateScrollbar()

    -- RogueMenu.MenuFrame
end

net.Receive("OpenRogueMenu", function()
    RogueMenu.Open()
end)