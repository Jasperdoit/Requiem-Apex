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

function ENT:Draw()
    self:DrawModel()
    local Ang = self:GetAngles()
    Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), 270)
    cam.Start3D2D(self:GetPos() + (self:GetUp() * 15) + (self:GetForward() * 21), Ang, 0.20)
		draw.SimpleText("Product Vendor", "VendorFont48", 0, 40, Color(255, 255, 255, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(25, 25, 25))
	cam.End3D2D()
    if LocalPlayer():GetEyeTrace().Entity == self and EyePos():Distance( self:GetPos() ) < 512 then	
		hook.Add("PreDrawHalos", "Halo", function()
				halo.Add({ self }, Color(0, 172, 12), 3, 3, 0)
		end)
	end
end

net.Receive("Product_openmenu", function()
    local scrw, scrh = ScrW(), ScrH()
    Product_vendor.menu = vgui.Create("DFrame")
    Product_vendor.menu:SetSize(scrw * .25, scrh * .7)
    Product_vendor.menu:Center()
    Product_vendor.menu:SetTitle("")
    Product_vendor.menu:MakePopup()
    Product_vendor.menu.Paint = function(me,w,h)
        surface.SetDrawColor(Product_vendor.Theme["Background"])
        surface.DrawRect(0,0,w,h)
        draw.SimpleText("Product Vendor", "VendorFont28", w / 2, h * 0.02, Product_vendor.Theme["Text"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    local panel = vgui.Create( "DPanel", Product_vendor.menu )
    panel.Paint = function( self, w, h )
        draw.RoundedBox( 4, 0, 0, w, h, Product_vendor.Theme["Background"])
    end
    panel:Dock(FILL)
    
    local Scrollbar = vgui.Create( "DScrollPanel", panel )
    Scrollbar:Dock( FILL )

    local FrameH = Product_vendor.menu:GetTall()
    local FrameW = Product_vendor.menu:GetWide()
    local y = Product_vendor.menu:GetTall() * 0.02

    for k, itemData in pairs(StockSystem.ShipmentList) do
            local itempanel = vgui.Create("DPanel", Scrollbar)
            itempanel:DockMargin(0, 0, 0, y)
            itempanel:Dock(TOP)
            itempanel:SetTall(FrameH * .1)
            itempanel.Paint = function(me, w, h)
            local itemcost = math.Round(itemData.sellprice * math.Clamp(20 / GetGlobalInt(k), 1, 50))
            itemcost = math.Round(itemcost + itemcost * (GetGlobalInt("tax", 0) / 100))
                surface.SetDrawColor(Product_vendor.Theme["Background"])
                surface.DrawRect(0,0,w,h)
                draw.SimpleText(itemData.displayname    , "VendorFont24", w * .1 , h * .3 , Product_vendor.Theme["Text"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                draw.SimpleText("Price: " .. itemcost .. "T", "VendorFont18", w * .1 , h * .6 , Product_vendor.Theme["Text"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                draw.SimpleText("Stock: " .. GetGlobalInt(k), "VendorFont18", w * .1 , h * .85 , Product_vendor.Theme["Text"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
    	    local blue = Color(0,0,210, 50)
            local purchasebutton = vgui.Create("DButton", itempanel)
            purchasebutton:Dock(RIGHT)
            purchasebutton:SetWide(FrameW * 0.25)
            purchasebutton:DockMargin(0, 5, 5, 5)
            purchasebutton:SetText("")
            purchasebutton.Paint = function(me, w, h)
                surface.SetDrawColor(blue)
                surface.DrawRect(0, 0, w, h)
                draw.SimpleText("Fetch", "VendorFont18", w / 2 -10, h / 2, Product_vendor.Theme["Text"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end

            purchasebutton.DoClick = function()
                net.Start("Product_Purchase")
                net.WriteString(k)
                net.SendToServer()
            end
    end
end)