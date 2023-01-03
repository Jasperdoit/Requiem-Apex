include("shared.lua")
surface.CreateFont("Arial28", {
	font = "Arial",
	size = 28,
	extended = false
})
surface.CreateFont("Helvetica22", {
	font = "Helvetica",
	size = 22,
	extended = false,
	-- outline = true,
	shadow = false,
})
surface.CreateFont("Helvetica20", {
	font = "Helvetica",
	size = 20,
	extended = false,
	-- outline = true,
	shadow = false,
})
surface.CreateFont("Helvetica30", {
	font = "Helvetica",
	size = 30,
	extended = false,
	-- outline = true,
})
surface.CreateFont("Helvetica14", {
	font = "Helvetica",
	size = 14,
	extended = false,
	-- outline = true,
})
surface.CreateFont("Helvetica22", {
	font = "Helvetica",
	size = 18,
	extended = false,
	-- outline = true,
})

function ENT:Draw()
	self:DrawModel()
	if LocalPlayer():GetEyeTrace().Entity == self and EyePos():Distance( self:GetPos() ) < 512 then	
		hook.Add("PreDrawHalos", "Halo", function()
				halo.Add({ self }, Color(187, 127, 0), 0, 0, 0)
		end)
	end
end

local color_background = Color(25, 25, 25, 165)
local color_item_background = Color(10, 10, 10, 220)
local color_text = Color(200, 200, 200)
local color_green = Color(0, 170, 0)
local color_red = Color(170, 0, 0)
local color_blue = Color(0, 0, 170)

net.Receive("weaponcraftingtable_open", function()
	local craftingtable = net.ReadEntity() or nil
	if craftingtable == nil then
		LocalPlayer():ChatPrint("You are not close to a table!")
	end
	weaponcraftingtablestuff = weaponcraftingtablestuff or {}
	local ScrW, ScrH = ScrW(), ScrH()
	local menuframe = vgui.Create("DFrame")
	menuframe:SetSize(ScrW * 900 / 1920, ScrH * 500 / 1080)
	menuframe:Center()
	menuframe:SetTitle("")
	menuframe:MakePopup()
	menuframe.Paint = function(me,w,h)
        surface.SetDrawColor(color_background)
        surface.DrawRect(0,0,w,h)
        draw.SimpleText("Weapon Craftingtable", "Helvetica20", w / 2, h * 0.02, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
	local function updataselectedweapon(weaponinfo, weaponindex)

		if craftingtable:GetWeaponClass() ~= "" and craftingtable:GetWeaponTime() ~= 0 then
			if weaponcraftingtablestuff.modelbackgroundpanel then weaponcraftingtablestuff.modelbackgroundpanel:Remove() end
			local panelwidth, panelheight = menuframe:GetWide(), menuframe:GetTall()
			weaponcraftingtablestuff.modelbackgroundpanel = vgui.Create("DPanel", menuframe)
			weaponcraftingtablestuff.modelbackgroundpanel:SetPos(panelwidth * 700 / 1920, panelheight * 100 / 1080)
			weaponcraftingtablestuff.modelbackgroundpanel:SetSize(panelwidth * 240 / 1920, panelheight * 240 / 1080)
			weaponcraftingtablestuff.modelbackgroundpanel.Paint = function(me, w, h)
				surface.SetDrawColor(color_item_background)
				surface.DrawRect(0, 0, w, h)
			end

			if weaponcraftingtablestuff.modelpanel then weaponcraftingtablestuff.modelpanel:Remove() end
			weaponcraftingtablestuff.modelpanel = vgui.Create("DModelPanel", menuframe)
			weaponcraftingtablestuff.modelpanel:SetPos(panelwidth * 700 / 1920, panelheight * 100 / 1080)
			weaponcraftingtablestuff.modelpanel:SetSize(panelwidth * 240 / 1920, panelheight * 240 / 1080)
			weaponcraftingtablestuff.modelpanel:SetModel(craftingtable:GetWeaponsModel())
			weaponcraftingtablestuff.modelpanel:SetFOV(25)
			weaponcraftingtablestuff.modelpanel:SetLookAt(weaponcraftingtablestuff.modelpanel.Entity:GetPos())

			if weaponcraftingtablestuff.weaponoptionspanel then weaponcraftingtablestuff.weaponoptionspanel:Remove() end
			weaponcraftingtablestuff.weaponoptionspanel = vgui.Create("DPanel", menuframe)
			weaponcraftingtablestuff.weaponoptionspanel:SetPos(panelwidth * 1000 / 1920, panelheight * 500 / 1080)
			weaponcraftingtablestuff.weaponoptionspanel:SetSize(panelwidth * 900 / 1920, panelheight * 350 / 1080)
			weaponcraftingtablestuff.weaponoptionspanel.Paint = function(me, w, h)
				surface.SetDrawColor(color_item_background)
				surface.DrawRect(0, 0, w, h)
			end
			panelwidth, panelheight = weaponcraftingtablestuff.weaponoptionspanel:GetWide(), weaponcraftingtablestuff.weaponoptionspanel:GetTall()
			if weaponcraftingtablestuff.craftbutton then weaponcraftingtablestuff.craftbutton:Remove() end
			if weaponcraftingtablestuff.cancelbutton then weaponcraftingtablestuff.cancelbutton:Remove() end
			weaponcraftingtablestuff.cancelbutton = vgui.Create("DButton", weaponcraftingtablestuff.weaponoptionspanel)
			weaponcraftingtablestuff.cancelbutton:SetPos(panelwidth * 50 / 1920, panelheight * 600 / 1080)
			weaponcraftingtablestuff.cancelbutton:SetSize(panelwidth * 500 / 1920, panelheight * 350 / 1080)
			weaponcraftingtablestuff.cancelbutton:SetText("")
			weaponcraftingtablestuff.cancelbutton.Paint = function(me, w, h)
				surface.SetDrawColor(color_red)
				surface.DrawRect(0, 0, w, h)
				draw.SimpleText("Cancel", "Helvetica22", w / 2, h / 2, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			weaponcraftingtablestuff.cancelbutton.DoClick = function()
				net.Start("weaponcraftingtable_cancelcraft")
				net.WriteEntity(craftingtable)
				net.SendToServer()
				timer.Simple(1, function()
					if menuframe:IsValid() then
						updataselectedweapon(WeaponCraftingTableItems[1], 1)
					end
				end)
			end
			if weaponcraftingtablestuff.progressbar then weaponcraftingtablestuff.progressbar:Remove() end
			weaponcraftingtablestuff.progressbar = vgui.Create("DProgress", weaponcraftingtablestuff.weaponoptionspanel)
			weaponcraftingtablestuff.progressbar:SetPos(25, 20)
			weaponcraftingtablestuff.progressbar:SetSize(200, 30)
			weaponcraftingtablestuff.progressbar.Think = function()
				weaponcraftingtablestuff.progressbar:SetFraction(craftingtable:GetProgress() / craftingtable:GetWeaponTime())
			end
		else
			if weaponcraftingtablestuff.modelbackgroundpanel then weaponcraftingtablestuff.modelbackgroundpanel:Remove() end
			local panelwidth, panelheight = menuframe:GetWide(), menuframe:GetTall()
			weaponcraftingtablestuff.modelbackgroundpanel = vgui.Create("DPanel", menuframe)
			weaponcraftingtablestuff.modelbackgroundpanel:SetPos(panelwidth * 700 / 1920, panelheight * 100 / 1080)
			weaponcraftingtablestuff.modelbackgroundpanel:SetSize(panelwidth * 240 / 1920, panelheight * 240 / 1080)
			weaponcraftingtablestuff.modelbackgroundpanel.Paint = function(me, w, h)
				surface.SetDrawColor(color_item_background)
				surface.DrawRect(0, 0, w, h)
			end
			if weaponcraftingtablestuff.modelpanel then weaponcraftingtablestuff.modelpanel:Remove() end
			weaponcraftingtablestuff.modelpanel = vgui.Create("DModelPanel", menuframe)
			weaponcraftingtablestuff.modelpanel:SetPos(panelwidth * 700 / 1920, panelheight * 100 / 1080)
			weaponcraftingtablestuff.modelpanel:SetSize(panelwidth * 240 / 1920, panelheight * 240 / 1080)
			weaponcraftingtablestuff.modelpanel:SetModel(weaponinfo.model)
			weaponcraftingtablestuff.modelpanel:SetFOV(25)
			weaponcraftingtablestuff.modelpanel:SetLookAt(weaponcraftingtablestuff.modelpanel.Entity:GetPos())

			if weaponcraftingtablestuff.weaponinfopanel then weaponcraftingtablestuff.weaponinfopanel:Remove() end
			weaponcraftingtablestuff.weaponinfopanel = vgui.Create("DPanel", menuframe)
			weaponcraftingtablestuff.weaponinfopanel:SetPos(panelwidth * 1000 / 1920, panelheight * 100 / 1080)
			weaponcraftingtablestuff.weaponinfopanel:SetSize(panelwidth * 900 / 1920,panelheight * 350 / 1080)
			weaponcraftingtablestuff.weaponinfopanel.Paint = function(me, w, h)
				surface.SetDrawColor(color_item_background)
				surface.DrawRect(0, 0, w, h)
			end

			if weaponcraftingtablestuff.descriptionlabel then weaponcraftingtablestuff.descriptionlabel:Remove() end
			weaponcraftingtablestuff.descriptionlabel = vgui.Create("DLabel", weaponcraftingtablestuff.weaponinfopanel)
			weaponcraftingtablestuff.descriptionlabel:SetPos(10, 10)
			weaponcraftingtablestuff.descriptionlabel:SetFont("Helvetica22")
			weaponcraftingtablestuff.descriptionlabel:SetText("Description: " .. weaponinfo.description .. "\n Tier: " .. weaponinfo.tier .. "\n Time Required: " .. math.Round(weaponinfo.time / craftingtable:GetTableTier()) .. "s")
			weaponcraftingtablestuff.descriptionlabel:SizeToContents()

			if weaponcraftingtablestuff.weaponoptionspanel then weaponcraftingtablestuff.weaponoptionspanel:Remove() end
			weaponcraftingtablestuff.weaponoptionspanel = vgui.Create("DPanel", menuframe)
			weaponcraftingtablestuff.weaponoptionspanel:SetPos(panelwidth * 1000 / 1920, panelheight * 500 / 1080)
			weaponcraftingtablestuff.weaponoptionspanel:SetSize(panelwidth * 900 / 1920, panelheight * 350 / 1080)
			weaponcraftingtablestuff.weaponoptionspanel.Paint = function(me, w, h)
				surface.SetDrawColor(color_item_background)
				surface.DrawRect(0, 0, w, h)
			end
			panelwidth, panelheight = weaponcraftingtablestuff.weaponoptionspanel:GetWide(), weaponcraftingtablestuff.weaponoptionspanel:GetTall()
			if weaponcraftingtablestuff.craftbutton then weaponcraftingtablestuff.craftbutton:Remove() end
			if weaponinfo.tier <= craftingtable:GetTableTier() then
				weaponcraftingtablestuff.craftbutton = vgui.Create("DButton", weaponcraftingtablestuff.weaponoptionspanel)
				weaponcraftingtablestuff.craftbutton:SetPos(panelwidth * 50 / 1920, panelheight * 600 / 1080)
				weaponcraftingtablestuff.craftbutton:SetSize(panelwidth * 500 / 1920, panelheight * 350 / 1080)
				weaponcraftingtablestuff.craftbutton:SetText("")
				weaponcraftingtablestuff.craftbutton.Paint = function(me, w, h)
					surface.SetDrawColor(color_green)
					surface.DrawRect(0, 0, w, h)
					draw.SimpleText("Craft", "Helvetica22", w / 2, h / 2, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
				weaponcraftingtablestuff.craftbutton.DoClick = function()
					if craftingtable:GetTableTier() < weaponinfo.tier then
						ply:ChatPrint("You can't make this weapon as it is a higher table than the table is!")
					return
					end
					net.Start("weaponcraftingtable_craft")
					net.WriteInt(weaponindex, 32)
					net.WriteEntity(craftingtable)
					net.SendToServer()
					timer.Simple(1, function()
						if menuframe:IsValid() then
							updataselectedweapon(WeaponCraftingTableItems[1], 1)
						end
					end)
				end
			end
			if craftingtable:GetTableTier() < WeaponCraftingTable.maxtier then
				if weaponcraftingtablestuff.upgradebutton then weaponcraftingtablestuff.upgradebutton:Remove() end
				weaponcraftingtablestuff.upgradebutton = vgui.Create("DButton", weaponcraftingtablestuff.weaponoptionspanel)
				weaponcraftingtablestuff.upgradebutton:SetPos(panelwidth * 1300 / 1920, panelheight * 600 / 1080)
				weaponcraftingtablestuff.upgradebutton:SetSize(panelwidth * 500 / 1920, panelheight * 350 / 1080)
				weaponcraftingtablestuff.upgradebutton:SetText("")
				weaponcraftingtablestuff.upgradebutton.Paint = function(me, w, h)
					surface.SetDrawColor(color_blue)
					surface.DrawRect(0, 0, w, h)
					draw.SimpleText("Upgrade", "Helvetica22", w / 2, h / 2, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
				weaponcraftingtablestuff.upgradebutton.DoClick = function()
					if craftingtable:GetTableTier() >= WeaponCraftingTable.maxtier then
						ply:ChatPrint("You can't upgrade to this tier!")
					return
					end
					net.Start("weaponcraftingtable_upgrade")
					net.WriteEntity(craftingtable)
					net.SendToServer()
					timer.Simple(1, function()
						if menuframe:IsValid() then
							updataselectedweapon(WeaponCraftingTableItems[1], 1)
						end
					end)
				end
			end
			if weaponcraftingtablestuff.tierlabel then weaponcraftingtablestuff.tierlabel:Remove() end
			weaponcraftingtablestuff.tierlabel = vgui.Create("DLabel", weaponcraftingtablestuff.weaponoptionspanel)
			weaponcraftingtablestuff.tierlabel:SetPos(panelwidth * 650 / 1920, panelheight * 700 / 1080)
			weaponcraftingtablestuff.tierlabel:SetFont("Helvetica22")
			weaponcraftingtablestuff.tierlabel:SetText("Table Tier: " .. craftingtable:GetTableTier())
			weaponcraftingtablestuff.tierlabel:SizeToContents()
		end
	end
	menuframe.Think = function()
		if craftingtable:GetDoneCrafting() then
			updataselectedweapon(WeaponCraftingTableItems[1], 1)
			craftingtable:SetDoneCrafting(false)
		end
	end
	updataselectedweapon(WeaponCraftingTableItems[1], 1)
	local framewidth, frameheight = menuframe:GetWide(), menuframe:GetTall()
	local scrollbar = vgui.Create("DScrollPanel", menuframe)
	scrollbar:SetPos(framewidth * 20 / 1920, frameheight * 100 / 1080)
	scrollbar:SetSize(framewidth * 600 / 1920, frameheight * 900 / 1080)
	for k, itemData in pairs(WeaponCraftingTableItems) do
		local itempanel = vgui.Create("DPanel", scrollbar)
		local FrameH, FrameW = itempanel:GetTall(), itempanel:GetWide()
		-- local y = FrameH * 0.02
		-- itempanel:DockMargin(0, 0, 0, .02)
		itempanel:Dock(TOP)
		itempanel:SetTall(FrameH * 3)
		itempanel.Paint = function(me, w, h)
			surface.SetDrawColor(color_item_background)
			surface.DrawRect(0,0,w,h)
			draw.SimpleText(itemData.weaponname, "Helvetica22", w * .1 , h * .25 , color_text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText("Time: "  .. math.Round(itemData.time / craftingtable:GetTableTier()) .. " seconds", "Helvetica22", w * .1 , h * .55 , color_text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText("Tier: " .. itemData.tier, "Helvetica22", w * .1 , h * .85 , color_text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
		local blue = Color(0,0,210, 50)
		local purchasebutton = vgui.Create("DButton", itempanel)
		purchasebutton:Dock(RIGHT)
		purchasebutton:SetWide(FrameW * 1)
		purchasebutton:DockMargin(0, 5, 5, 5)
		purchasebutton:SetText("")
		purchasebutton.Paint = function(me, w, h)
			surface.SetDrawColor(blue)
			surface.DrawRect(0, 0, w, h)
			draw.SimpleText("Select", "Helvetica22", w / 2 -25, h / 2, color_text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		purchasebutton.DoClick = function()
			updataselectedweapon(itemData, k)
		end
    end
end)