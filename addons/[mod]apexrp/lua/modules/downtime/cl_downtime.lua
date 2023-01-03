surface.CreateFont("DermaLargestuff", {
	font = "DermaLarge",
	size = 48,
	extended = false 	
})
surface.CreateFont("Dermanormalstuff", {
	font = "DermaLarge",
	size = 18,
	extended = false 	
})

hook.Add("HUDPaint", "Downtimetext", function()
	if GetGlobalBool("DownTime", false) == true then
		draw.SimpleText("DOWNTIME MODE", "DermaLargestuff", ScrW() - 175, 25, Color( 255, 255, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(15 - player.GetCount() .. " more required until normal play resumes", "Dermanormalstuff", ScrW() - 175, 50, Color( 255, 255, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	end
end)