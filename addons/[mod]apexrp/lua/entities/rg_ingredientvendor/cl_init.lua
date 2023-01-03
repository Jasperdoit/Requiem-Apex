include("shared.lua")




surface.CreateFont( "VendorFont28", {
    font = "Calibri",
    extended = false,
    size = 28,
    weight = 500,
})

surface.CreateFont( "VendorFont18", {
    font = "Calibri",
    extended = false,
    size = 18,
    weight = 500,
})

surface.CreateFont( "VendorFont24", {
    font = "Calibri",
    extended = false,
    size = 24,
    weight = 500,
})

surface.CreateFont( "VendorFont48", {
    font = "Arial",
    extended = false,
    size = 48,
    weight = 500,
})

local categories = {}
categories[0] = "Packaging"
categories[1] = "Main Item"
categories[2] = "Additional Item"

function ENT:Draw()
    self:DrawModel()
    local Ang = self:GetAngles()
    Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), 270)
    cam.Start3D2D(self:GetPos() + (self:GetUp() * 15) + (self:GetForward() * 21), Ang, 0.20)
		draw.SimpleText("Ingredient Vendor", "VendorFont48", 0, 40, Color(255, 255, 255, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(25, 25, 25))
	cam.End3D2D()
    if LocalPlayer():GetEyeTrace().Entity == self and EyePos():Distance( self:GetPos() ) < 512 then	
		hook.Add("PreDrawHalos", "Halo", function()
				halo.Add({ self }, Color(0, 172, 12), 3, 3, 0)
		end)
	end
end

net.Receive("Ingredient_openmenu", function()
    local scrw, scrh = ScrW(), ScrH()
    Ingredient_vendor.menu = vgui.Create("DFrame")
    Ingredient_vendor.menu:SetSize(scrw * .25, scrh * .7)
    Ingredient_vendor.menu:Center()
    Ingredient_vendor.menu:SetTitle("")
    Ingredient_vendor.menu:MakePopup()
    Ingredient_vendor.menu.Paint = function(me,w,h)
        surface.SetDrawColor(Ingredient_vendor.Theme["Background"])
        surface.DrawRect(0,0,w,h)
        draw.SimpleText("Ingredient Vendor", "VendorFont28", w / 2, h * 0.02, Ingredient_vendor.Theme["Text"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    local sheet = vgui.Create( "DPropertySheet", Ingredient_vendor.menu )
    sheet:Dock( FILL )
    for cat, v in pairs(categories) do
        local panel = vgui.Create( "DPanel", sheet )
        panel.Paint = function( self, w, h )
            draw.RoundedBox( 4, 0, 0, w, h, Ingredient_vendor.Theme["Background"])
        end
        sheet:AddSheet(v, panel)
        local Scrollbar = vgui.Create( "DScrollPanel", panel )
        Scrollbar:Dock( FILL )

        local FrameH = Ingredient_vendor.menu:GetTall()
        local FrameW = Ingredient_vendor.menu:GetWide()
        local y = Ingredient_vendor.menu:GetTall() * 0.02

        for k, itemData in pairs(StockSystem.IngredientList) do
            if cat == itemData.id then
                local itempanel = vgui.Create("DPanel", Scrollbar)
                itempanel:DockMargin(0, 0, 0, y)
                itempanel:Dock(TOP)
                itempanel:SetTall(FrameH * .07)
                itempanel.Paint = function(me, w, h)
                    surface.SetDrawColor(Ingredient_vendor.Theme["Background"])
                    surface.DrawRect(0,0,w,h)
                    draw.SimpleText(itemData.displayname, "VendorFont24", w * .1 , h * .5 , Ingredient_vendor.Theme["Text"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    -- draw.SimpleText("Price: " .. itemData.price .. "T", "VendorFont18", w * .1 , h * .6 , Ingredient_vendor.Theme["Text"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end

                local purchasebutton = vgui.Create("DButton", itempanel)
                purchasebutton:Dock(RIGHT)
                purchasebutton:SetWide(FrameW * 0.25)
                purchasebutton:DockMargin(0, 5, 5, 5)
                purchasebutton:SetText("")
                purchasebutton.Paint = function(me, w, h)
                    surface.SetDrawColor(Ingredient_vendor.Theme["PurchaseButton"])
                    surface.DrawRect(0, 0, w, h)
                    draw.SimpleText("Fetch", "VendorFont18", w / 2 -10, h / 2, Ingredient_vendor.Theme["Text"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end

                purchasebutton.DoClick = function()
                    net.Start("Ingredient_Purchase")
                    net.WriteString(k)
                    net.SendToServer()
                end
            end
        end
    end
end)