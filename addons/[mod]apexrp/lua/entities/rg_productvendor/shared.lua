ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName		= "Product Vendor"
ENT.Author			= "Spectrum/Jasperdoit"
ENT.Contact			= "The forums or something"
ENT.Spawnable       = true
ENT.Category        = "Universal Union"

Product_vendor = Product_vendor or {} //Makes the table of tables
Product_vendor.Theme = { //Adds a table for constants used by the vendor
    ["Background"] = Color(0, 0, 0, 200),
    ["Text"] = Color(255, 255, 255),
    ["PurchaseButton"] = Color(210, 0, 0, 50),
}
