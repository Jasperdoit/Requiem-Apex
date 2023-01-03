local p =  Material("halfliferp/factions/admin.png") 
local grad = surface.GetTextureID("gui/gradient");
local blur = Material("pp/blurscreen")



                surface.CreateFont( "shocktrooper", {
            font = "magdaclean-regular", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
            --extended = false,
            size = 100,
            weight = 550,
            extended = true
        } )

                                surface.CreateFont( "shocktrooper2", {
            font = "magdaclean-regular", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
            --extended = false,
            size = 20,
            weight = 550,
            extended = true
        } )






function CodeOpenMenu()
    local frame = vgui.Create("DFrame")
    frame:SetPos(ScrW()/2-560/2, ScrH()/2-260/2)
    frame:SetSize(1000, 600)
    frame:ShowCloseButton(true)
    frame:SetTitle("IM DEVELOPING")
    frame.Paint = function(self, width, height)
        surface.SetDrawColor(20, 20, 20, 255)
        surface.DrawRect(0, 0, width, height)
        surface.SetDrawColor(50, 50, 50, 255)
        surface.DrawRect(5, 5, width-10, height-10)
    end    




    frame:MakePopup()
    frame:SetKeyboardInputEnabled(false)

    local codes = vgui.Create("DListView", frame)
    codes:SetPos(7, 20)
    codes:SetSize(278, 203)
    codes:SetMultiSelect(false)

    function codes:Paint(w, h)
       -- draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100))
       -- draw.RoundedBox(0, 1, 1, w-2, h-2, Color(150, 150, 150))

        surface.SetDrawColor(255,0,0,255)
        surface.SetTexture(grad)
        surface.DrawTexturedRect( 0, 0, w, h )


        --draw.RoundedBox(0, 1, 1, w-2, h-2, Color(0,0,0,220))
    end




	    

    codes:AddColumn("ID"):SetWidth(20)
    codes:AddColumn("Name"):SetWidth(100)
    codes:AddColumn("Description"):SetWidth(140)






    local function Quicksort(isWhitelist, blacklist, city)
        blacklist = blacklist or {}
        codes:Clear()

        local sortThrough

        if city then
            sortThrough = CODE_LIST
        else
            sortThrough = CODE_ZONES
        end
        for k, v in pairs(sortThrough) do
            if k == -1 then continue end
            if (v.admin && !LocalPlayer():IsAdmin()) || v.hide then continue end

            if blacklist[k] then
                if !v.whitelist && !isWhitelist then
                    continue
                end
            elseif v.whitelist || isWhitelist then
                continue
            end

            local line = codes:AddLine(v.id or k, v.name, v.desc)
            line.codeID = k

            local col = v.color


            function line:Paint(w, h)
                if self:IsSelected() then
                    draw.RoundedBox(0, 0, 0, w, h, Color(math.max(col.r-100, 0), math.max(col.g-100, 0), math.max(col.b-100, 0)))
                else
                    self.HoveredColor = self.HoveredColor or 0

                    if self:IsHovered() then
                        self.HoveredColor = Lerp(RealFrameTime()*5, self.HoveredColor, 50)
                    else
                        self.HoveredColor = Lerp(RealFrameTime()*5, self.HoveredColor, 0)
                    end
                    draw.RoundedBox(0, 0, 0, w, h, Color(
                        math.max(col.r+self.HoveredColor-20, 50),
                        math.max(col.g+self.HoveredColor-20, 50), 
                        math.max(col.b+self.HoveredColor-20, 50)
                        ))
                end
            end

        end

        codes:SortByColumn(1)
    end

    Quicksort(false, {}, true)
    
    local zones = vgui.Create("DListView", frame)
    zones:SetSize(266, 203)
    local offset = codes:GetPos() + codes:GetSize() + 2
    zones:SetPos(offset, 20)
    zones:SetMultiSelect(false)

    function zones:Paint(w, h)
        --draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100))
        draw.RoundedBox(0, 1, 1, w-2, h-2, Color(150, 150, 150))
    end

    zones:AddColumn("ID"):SetWidth(10)
    zones:AddColumn("Name"):SetWidth(100)

    zones:AddLine("[CITY]", "City")
    zones:SelectFirstItem()

    for k, v in SortedPairs(CITY_ZONES) do
        if (v.admin && !LocalPlayer():IsAdmin()) || v.hide then continue end
        local line = zones:AddLine(k, v.name)

        function line:Paint(w, h)
            local col = CODE_ZONES[GetGlobalString("code_"..k, "func")].color

            if self:IsSelected() then
                draw.RoundedBox(0, 0, 0, w, h, Color(math.max(col.r-100, 0), math.max(col.g-100, 0), math.max(col.b-100, 0)))
            else
                self.HoveredColor = self.HoveredColor or 0

                if self:IsHovered() then
                    self.HoveredColor = Lerp(RealFrameTime()*5, self.HoveredColor, 50)
                else
                    self.HoveredColor = Lerp(RealFrameTime()*5, self.HoveredColor, 0)
                end
                draw.RoundedBox(0, 0, 0, w, h, Color(
                    math.max(col.r+self.HoveredColor-20, 50),
                    math.max(col.g+self.HoveredColor-20, 50), 
                    math.max(col.b+self.HoveredColor-20, 50)
                    ))
            end
        end
    end

    local activate = vgui.Create("DButton", frame)
    activate:SetPos(7, 226)
    activate:SetSize(546, 27)
    activate:SetText(zones:GetLine(1):GetColumnText(2))
    activate:SetTextColor(Color(0,0,0))
    activate:SetFont("DermaLarge")

    function zones:OnRowSelected(index, row)
        activate:SetText(row:GetColumnText(2))
        if row:GetColumnText(1) != "[CITY]" then
            Quicksort(CITY_ZONES[row:GetColumnText(1)].isWhitelist, CITY_ZONES[row:GetColumnText(1)].blacklisted)
        else
            Quicksort(false, {}, true)
        end
    end
    
    function activate:Paint(w, h)
        self.HoveredColor = self.HoveredColor or 0

        if self:IsHovered() then
            self.HoveredColor = Lerp(RealFrameTime()*5, self.HoveredColor, 50)
        else
            self.HoveredColor = Lerp(RealFrameTime()*5, self.HoveredColor, 0)
        end

        local selected = codes:GetSelectedLine()
        local col = Color(180, 180, 180)
        if selected  then
            local code = tonumber( codes:GetLine(selected).codeID ) or codes:GetLine(selected).codeID
            local tempCol = !zones:GetLine(1):IsSelected() and CODE_ZONES[code].color or CODE_LIST[code].color
            col = Color(math.max(tempCol.r-20, 50), math.max(tempCol.g-20, 50), math.max(tempCol.b-20, 50))
        end

        draw.RoundedBox(0, 0, 0, w, h, Color(
            math.min(col.r+self.HoveredColor, 255), 
            math.min(col.g+self.HoveredColor, 255), 
            math.min(col.b+self.HoveredColor, 255)
            ))
    end

    function activate:DoClick()
        local codeSelected = codes:GetSelectedLine()
        local zoneSelected = zones:GetSelectedLine()

        if !codeSelected || !zoneSelected then return end

        codeSelected = codes:GetLine(codeSelected).codeID
        zoneSelected = zones:GetLine(zoneSelected):GetColumnText(1)

        if zoneSelected != "[CITY]" then 
            LocalPlayer():ConCommand("fcode_zone "..zoneSelected.." "..codeSelected)
        else
            LocalPlayer():ConCommand("fcode "..codeSelected)
        end
        frame:Remove()
    end

end

concommand.Add("fcode_menu", function(ply)
    if WHITELISTED_TEAMS[ply:Team()] || ply:IsAdmin() || ply:Team() == TEAM_DISPATCH || (ply:Team() == TEAM_ADMINISTRATOR && string.find(ply:getDarkRPVar("job"), "Defense")) || (divisions && ply:getDivision() == DIVISION_SECTORIAL) then
        CodeOpenMenu()
    end
end)