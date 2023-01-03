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
    if not ply:IsValid() or not ply:IsPlayer() or not ply:Alive() or ply:getDivision() == 0 then return "UNASSIGNED" end
    return ply:getDivisionData().name
end

local function FindRank(ply)
    if not ply:IsValid() or not ply:IsPlayer() or not ply:Alive() or not ply:getDivisionData().ranks then return "NONE" end
    return ply:getDivisionRankData().name
end

local function FindStatus(ply)
    if not ply:IsValid() or not ply:IsPlayer() then return "INVALID", Color(200,0,0) end
    if not ply:Alive() then return "KIA", Color(255,0,0) end
    if ply:GetNWBool("HasbeenDefunct", false) then return "MARKED DEFUNCT", Color(255,114,0) end
    if ply:getDivision() == 0 then return "OUT OF SERVICE", Color(255, 255, 255) end
    return "IN SERVICE", Color(32,140,255)
end

function CombineCommandMenu.Open()
    local scrw = ScrW()
    local scrh = ScrH()
    local scrwCenter, scrhCenter = scrw / 2, scrh / 2
    CombineCommandMenu.MenuFrame = vgui.Create("DFrame")
    CombineCommandMenu.MenuFrame:SetSize(1000, 600)
    CombineCommandMenu.MenuFrame:Center()
    CombineCommandMenu.MenuFrame:SetTitle("")
    CombineCommandMenu.MenuFrame:MakePopup()
    CombineCommandMenu.MenuFrame.Paint = function(me,w,h)
        draw.RoundedBox(5, 0, 0, w, h, CombineCommandMenu.Theme["backgroundcolor"])
    end
    CombineCommandMenu.MenuFrame.Think = function(self)
        if (!LocalPlayer():Alive()) then self:Remove() end
    end

    --Profile Button panel

    CombineCommandMenu.ProfilePanel =   vgui.Create("DPanel", CombineCommandMenu.MenuFrame)
    CombineCommandMenu.ProfilePanel:SetPos(300,50)
    CombineCommandMenu.ProfilePanel:SetSize(650,200)
    CombineCommandMenu.ProfilePanel.Paint = function(me,w,h)
        draw.RoundedBox(0, 0, 0, w, h, CombineCommandMenu.Theme["profilepanel"])
    end

    --Empty Profile Picture panel

    CombineCommandMenu.ProfilePicPanel = vgui.Create("DPanel", CombineCommandMenu.MenuFrame)
    CombineCommandMenu.ProfilePicPanel:SetPos(50,50)
    CombineCommandMenu.ProfilePicPanel:SetSize(200,200)
    CombineCommandMenu.ProfilePicPanel.Paint = function(me,w,h)
        draw.RoundedBox(0, 0, 0, w, h, CombineCommandMenu.Theme["black"])
    end

    --Show the profile of the CP
    CombineCommandMenu.ProfilePic = CombineCommandMenu.ProfilePic || false
    local function ShowProfile(ply)
        --Profile picture
        if CombineCommandMenu.ProfilePic then CombineCommandMenu.ProfilePic:Remove() end
        if CombineCommandMenu.RewardButton then CombineCommandMenu.RewardButton:Remove() end
        if CombineCommandMenu.RewardButton then CombineCommandMenu.RewardButton:Remove() end

        local ProfilePic = vgui.Create("DModelPanel", CombineCommandMenu.ProfilePicPanel)
        ProfilePic:SetModel(ply:GetModel())
        ProfilePic:SetModel(ply:GetModel(), ply:GetSkin())
        for i = 1, table.Count(ply:GetBodyGroups()) do
            ProfilePic.Entity:SetBodygroup(i, ply:GetBodygroup(i))
        end
        ProfilePic:Dock(FILL)
        ProfilePic:InvalidateLayout(true)
        
        
        function ProfilePic:LayoutEntity(ent)
        end
        CombineCommandMenu.ProfilePic = ProfilePic
        local eyepos = ProfilePic.Entity:GetBonePosition(ProfilePic.Entity:LookupBone("ValveBiped.Bip01_Head1"))
        eyepos:Add(Vector(0, 0, -2))
        ProfilePic:SetLookAt(eyepos)
        ProfilePic:SetCamPos(eyepos-Vector(-24, 0, 0))
        CombineCommandMenu.ProfilePanel.Paint = function(me,w,h)
            draw.RoundedBox(0, 0, 0, w, h, CombineCommandMenu.Theme["profilepanel"])
            draw.SimpleText("TAGLINE: " .. string.upper(ply:Name()), "Roboto24", 10, 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            local divisionname = FindDivision(ply)
            local rank = FindRank(ply)
            local status, color = FindStatus(ply)
            draw.SimpleText("DIVISION: " .. string.upper(divisionname), "Roboto24", 10, 60, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText("RANK: " .. string.upper(rank), "Roboto24", 10, 100, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText("STATUS: ", "Roboto24", 10, 140, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(status, "Roboto24", 95, 140, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        -- Buttons

        CombineCommandMenu.RewardButton = vgui.Create("DButton", CombineCommandMenu.ProfilePanel)
        CombineCommandMenu.RewardButton:SetPos(450, 50)
        CombineCommandMenu.RewardButton:SetSize(100, 35)
        CombineCommandMenu.RewardButton:SetText("")
        CombineCommandMenu.RewardButton.Paint = function(me,w,h)
            draw.RoundedBox(0, 0, 0, w, h, CombineCommandMenu.Theme["cpactivecolor"])
            draw.SimpleText("REWARD", "Roboto16", w / 2, h / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        CombineCommandMenu.RewardButton.DoClick = function()
            net.Start("RewardCP")
            net.WriteEntity(ply)
            net.SendToServer()
        end
        CombineCommandMenu.DefunctButton = vgui.Create("DButton", CombineCommandMenu.ProfilePanel)
        CombineCommandMenu.DefunctButton:SetPos(450, 100)
        CombineCommandMenu.DefunctButton:SetSize(100, 35)
        CombineCommandMenu.DefunctButton:SetText("")
        CombineCommandMenu.DefunctButton.Paint = function(me,w,h)
            draw.RoundedBox(0, 0, 0, w, h, CombineCommandMenu.Theme["cpdefunctbuttoncolor"])
            draw.SimpleText("DEFUNCT", "Roboto16", w / 2, h / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        CombineCommandMenu.DefunctButton.DoClick = function()
            net.Start("defunct")
            net.WriteEntity(ply)
            net.SendToServer()
        end
    end

    --Scrollbar with players

    CombineCommandMenu.Scrollbar = vgui.Create("DScrollPanel", CombineCommandMenu.MenuFrame)
    CombineCommandMenu.Scrollbar:Dock(FILL)
    CombineCommandMenu.Scrollbar:DockMargin(50, 250, 50, 0)
    CombineCommandMenu.Scrollbar.Paint = function(me,w,h)
        draw.RoundedBox(0, 0, 0, w, h, CombineCommandMenu.Theme["scrollpanelcolor"])
    end

    --Customizes the scrollbar

    local sbar = CombineCommandMenu.Scrollbar:GetVBar()
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

    local yspace = CombineCommandMenu.Scrollbar:GetTall() * 0.2
    local xspace = CombineCommandMenu.Scrollbar:GetWide() * 0.2
    -- for k, combine in pairs(player.GetHumans()) do

    -- Put CPs into the scrollbaritems

    for k, cp in pairs(player.GetHumans()) do
        if cp:Team() == TEAM_CP or cp:Team() == TEAM_OVERWATCH or cp:Team() == TEAM_CONSCRIPT then
            local personitem = vgui.Create("DPanel", CombineCommandMenu.Scrollbar)
            personitem:DockMargin(0,0,0,yspace)
            personitem:Dock(TOP)
            personitem:SetTall(CombineCommandMenu.Scrollbar:GetTall() * 2.2)
            personitem.Paint = function(me,w,h)
                draw.RoundedBox(0, 0, 0, w, h, team.GetColor(cp:Team()))
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

    -- CombineCommandMenu.MenuFrame
end

net.Receive("SendDefunctionMessage", function()
    local defunctunit = net.ReadEntity()
    local isdefunct = net.ReadBool()
    if not defunctunit:IsPlayer() or not defunctunit:Alive() then return end
    if not isbool(isdefunct) then return end
    if isdefunct then
        -- chat.AddText(Color(20, 20, 150, 255), "Dispatch", Color(255,255,255,255), ": ATTENTION UNITS, ", defunctunit, Color(255,255,255,255), " has been marked as ", Color(255,114,0,255), "DEFUNCT! ", Color(255,255,255,255), "Amputation or detainment of this unit is ", Color(255,114,0,255), "DISCRETIONARY.")
        hook.Add("PreDrawHalos", "AddDefunctionHalo" .. defunctunit:SteamID64(), function()
            halo.Add({defunctunit}, Color(255,114,0,255), 0, 0, 0)
        end)
    else
        hook.Remove("PreDrawHalos", "AddDefunctionHalo" .. defunctunit:SteamID64())
        -- chat.AddText(Color(20, 20, 150, 255), "Dispatch", Color(255,255,255,255), ": ATTENTION UNITS, ", defunctunit, Color(255,255,255,255), " has ", Color(255,0,0,255), "NO LONGER", Color(255,255,255,255), " been marked as ", Color(255,114,0,255), "DEFUNCT! ", Color(255,255,255,255), "Cease the engagement of ", defunctunit, Color(255,255,255,255), "!")        -- chat.AddText()
    end
end)


net.Receive("AddDefunctionHalo", function()
    local ply = net.ReadEntity()
    hook.Add("PreDrawHalos", "AddDefunctionHalo" .. ply:SteamID64(), function()
    halo.Add({ply}, Color(255,114,0,255), 2, 2, 0)
    end)
end)

net.Receive("RemoveDefunctionHalo", function()
    local ply = net.ReadEntity()
    hook.Remove("PreDrawHalos", "AddDefunctionHalo" .. ply:SteamID64())
end)

net.Receive("RemoveAllDefunctionHalos", function()
    for _, ply in pairs(player.GetHumans()) do
        hook.Remove("PreDrawHalos", "AddDefunctionHalo" .. ply:SteamID64())
    end
end)

hook.Add("PlayerButtonDown", "CPMenuOpen", function(ply, button)
	if IsFirstTimePredicted() && button == KEY_I && ply:isCombine() then
        if ply:Team() != TEAM_DISPATCH then
            -- print(divisions.Data[ply:getDivision()].ranks and not divisions.Data[ply:getDivision()].ranks[ply:getDivisionRank()].leader)
            if ply:getDivision() > 0 && divisions.Data[ply:getDivision()].ranks then
                if not divisions.Data[ply:getDivision()].ranks[ply:getDivisionRank()].leader then
                    return
                end
            elseif ply:getDivision() != DIVISION_SECTORIAL and ply:getDivision() != DIVISION_OCMD and ply:getDivision() != DIVISION_COMMANDER then
                return
            end
        end
        print("I got here!")
		CombineCommandMenu.Open()
    end
end)