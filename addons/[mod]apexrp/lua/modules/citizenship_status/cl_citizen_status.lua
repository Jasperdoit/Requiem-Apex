surface.CreateFont("malignant2", {
    font = "BudgetLabel",
    size = 40,
    extended = false,
})

hook.Add("PostDrawOpaqueRenderables", "[citizenship] : draw malignant 3d2d", function()
    if not LocalPlayer():isCombine() then return end

    for _, ply in pairs(player.GetHumans()) do
        if ply == LocalPlayer() then continue end
        if not ply:GetNWBool("citizenshipRevoked", false) then continue end
        if ply:GetPos():DistToSqr(LocalPlayer():GetPos()) > 300 * 300 then continue end
        if ply:GetMoveType() == MOVETYPE_NOCLIP then continue end
        local pos = ply:GetPos() + Vector(0, 0, 74)
        local ang = ply:GetAngles()
        ang:RotateAroundAxis(ang:Forward(), 90)
        ang.y = LocalPlayer():EyeAngles().y - 90
        cam.Start3D2D(pos, ang, .11)
        draw.SimpleText("MALIGNANT", "malignant2", 0, 0, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        cam.End3D2D()
    end
end)

hook.Add("f1Menu", "[citizenship] : draw malignant list", function(parent)
    if not LocalPlayer():isCombine() or LocalPlayer():GetNWBool("HasbeenDefunct") then return end
    local font

    if (ScrW() > 1600) then
        font = "RobotoMono32"
    else
        font = "RobotoMono24"
    end

    surface.SetFont(font)
    local w, h = surface.GetTextSize("BOL List")
    local wantedlist = parent:Add("DPanel")
    wantedlist:SetWide(parent:GetWide())
    wantedlist:Dock(TOP)
    wantedlist:DockMargin(2, h * 2, 2, 0)
    wantedlist:SetHeight(ScrH() * .3)

    function wantedlist:Paint(w, h)
        surface.SetDrawColor(255, 255, 255, 150)
        surface.DrawRect(0, 0, w, h)
    end

    wantedlist.label = wantedlist:Add("DLabel")
    wantedlist.label:SetPos(x, y)
    wantedlist.label:SetSize(wantedlist:GetWide(), h)
    wantedlist.label:SetText("BOL List")
    wantedlist.label:SetFont(font)
    wantedlist.label:SetContentAlignment(5)
    wantedlist.label:SetColor(Color(255, 255, 255))

    function wantedlist.label:Paint(w, h)
        surface.SetDrawColor(32, 32, 32)
        surface.DrawRect(0, 0, w, h)
    end

    wantedlist.scroll = wantedlist:Add("DScrollPanel")
    wantedlist.scroll:SetSize(wantedlist:GetWide(), wantedlist:GetTall() - wantedlist.label:GetTall())
    wantedlist.scroll:SetPos(0, wantedlist.label:GetTall())
    local sbar = wantedlist.scroll:GetVBar()

    function sbar:Paint(w, h)
    end

    function sbar.btnUp:Paint(w, h)
    end

    function sbar.btnDown:Paint(w, h)
    end

    function sbar.btnGrip:Paint(w, h)
    end

    local defunctlist = parent:Add("DPanel")
    defunctlist:SetWide(parent:GetWide())
    defunctlist:Dock(TOP)
    defunctlist:DockMargin(2, 5, 2, 0)
    defunctlist:SetHeight(ScrH() * .3)

    function defunctlist:Paint(w, h)
        surface.SetDrawColor(255, 255, 255, 150)
        surface.DrawRect(0, 0, w, h)
    end

    defunctlist.label = defunctlist:Add("DLabel")
    defunctlist.label:SetPos(x, y)
    defunctlist.label:SetSize(defunctlist:GetWide(), h)
    defunctlist.label:SetText("Defunct List")
    defunctlist.label:SetFont(font)
    defunctlist.label:SetContentAlignment(5)
    defunctlist.label:SetColor(Color(255, 255, 255))

    function defunctlist.label:Paint(w, h)
        surface.SetDrawColor(32, 32, 32)
        surface.DrawRect(0, 0, w, h)
    end

    defunctlist.scroll = defunctlist:Add("DScrollPanel")
    defunctlist.scroll:SetSize(defunctlist:GetWide(), defunctlist:GetTall() - defunctlist.label:GetTall())
    defunctlist.scroll:SetPos(0, defunctlist.label:GetTall())
    local sbar = defunctlist.scroll:GetVBar()

    function sbar:Paint(w, h)
    end

    function sbar.btnUp:Paint(w, h)
    end

    function sbar.btnDown:Paint(w, h)
    end

    function sbar.btnGrip:Paint(w, h)
    end

    for _, target in ipairs(player.GetAll()) do
        local item
        if not target:Alive() then continue end
        if target:GetNWBool("citizenshipRevoked") then
            item = wantedlist.scroll:Add("DLabel")
        elseif target:GetNWBool("HasbeenDefunct") then
            item = defunctlist.scroll:Add("DLabel")
        else
            continue
        end

        item:SetWide(wantedlist.scroll:GetWide())
        item:Dock(TOP)
        item:DockMargin(2, 2, 2, 0)
        item:SetTall(h)
        item:SetFont(font)
        item:SetTextColor(Color(0, 0, 0))
        item:SetContentAlignment(5)
        item:SetText(target:Name())
    end
end)