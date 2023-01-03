include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

surface.CreateFont("DebugFixed10", {
    font = DebugFixed,
    size = 16,
    extended = false,
    bold = false
})
surface.CreateFont("DebugFixed12", {
    font = DebugFixed,
    size = 14,
    extended = false,
    bold = false
})
surface.CreateFont("DebugFixed20", {
    font = DebugFixed,
    size = 20,
    extended = false,
    bold = false
})
surface.CreateFont("DebugFixedruhroh", {
    font = DebugFixed,
    size = 10,
    extended = false,
    bold = false
})

local color_darkgrey = Color(20, 20, 20, 200)
local color_yelloworange = Color(255, 216, 0)
local color_lightblue = Color(60, 157, 255, 150)
local color_green = Color(0, 200, 0, 150)
local color_button = Color(60, 60, 60)
local color_text = Color(255, 255, 255)

net.Receive("SpecATMOpen", function()
    local ATM = net.ReadEntity()
    local bankamount = net.ReadInt(32)
    ATMUI = ATMUI or {}
    if ATMUI.menu then ATMUI.menu:Remove() end
    ATMUI.menu = vgui.Create("DFrame")
    width, height = ATMUI.menu:GetWide(), ATMUI.menu:GetTall()
    ATMUI.menu:SetSize(150, 225)
    ATMUI.menu:Center()
    ATMUI.menu:SetTitle("ATM")
    ATMUI.menu:MakePopup()
    ATMUI.menu.Paint = function(me,w,h)
        draw.RoundedBox(0, 0, 0, w, h, color_darkgrey)
        draw.RoundedBox(0, 0, 0, w, 25, color_lightblue)
        draw.DrawText("--ACCOUNT DETAILS--", "DebugFixed12", w / 2, 35, color_yelloworange, TEXT_ALIGN_CENTER)
        -- draw.DrawText(LocalPlayer():Name(), "DebugFixedruhroh", w / 2, 50, color_lightblue, TEXT_ALIGN_CENTER)
        draw.DrawText("Balance: " .. bankamount, "DebugFixed20", w / 2, 50, color_green, TEXT_ALIGN_CENTER)
    end
    ATMUI.Inputbox = vgui.Create("DTextEntry", ATMUI.menu)
    ATMUI.Inputbox:SetPos(25, 112)
    ATMUI.Inputbox:SetSize(100, 25)
    ATMUI.Inputbox:SetNumeric(true)
    ATMUI.Inputbox:SetPlaceholderText("Enter Amount Here")

    ATMUI.DepositButton = vgui.Create("DButton", ATMUI.menu)
    ATMUI.DepositButton:SetPos(37, 150)
    ATMUI.DepositButton:SetSize(75, 25)
    ATMUI.DepositButton:SetText("")
    ATMUI.DepositButton.Paint = function(me,w,h)
        draw.RoundedBox(0, 0, 0, w, h, color_button)
        draw.SimpleText("Deposit", "DebugFixed10", w / 2, h / 2, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    ATMUI.DepositButton.DoClick = function()
		if not ATMUI.Inputbox:GetInt() then return end
        net.Start("SpecATMDepositMoney")
			net.WriteEntity(ATM)
			net.WriteInt(ATMUI.Inputbox:GetInt(), 32)
        net.SendToServer()
    end

    ATMUI.WithdrawButton = vgui.Create("DButton", ATMUI.menu)
    ATMUI.WithdrawButton:SetPos(37, 180)
    ATMUI.WithdrawButton:SetSize(75, 25)
    ATMUI.WithdrawButton:SetText("")
    ATMUI.WithdrawButton.Paint = function(me,w,h)
        draw.RoundedBox(0, 0, 0, w, h, color_button)
        draw.SimpleText("Withdraw", "DebugFixed10", w / 2, h / 2, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
	ATMUI.WithdrawButton.DoClick = function()
		if not ATMUI.Inputbox:GetInt() then return end
        net.Start("SpecATMWithdrawMoney")
			net.WriteEntity(ATM)
			net.WriteInt(ATMUI.Inputbox:GetInt(), 32)
        net.SendToServer()
    end
end)