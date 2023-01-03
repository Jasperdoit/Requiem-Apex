scoreboard = {};

if (CLIENT) then 
	local blur = Material("pp/blurscreen");

	function scoreboard:drawBlur(panel, amount, passes)
		amount = amount or 5

		surface.SetMaterial(blur)
		surface.SetDrawColor(255, 255, 255)

		local x, y = panel:LocalToScreen(0, 0)

		for i = -(passes or 0.2), 1, 0.2 do
			-- Do things to the blur material to make it blurry.
			blur:SetFloat("$blur", i * amount)
			blur:Recompute()

			-- Draw the blur material over the screen.
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
		end
	end 

	local function hideScoreboard()
		if (IsValid(scoreboard.gui)) then
			scoreboard.gui:SetVisible(false)
			
			if (IsValid(scoreboard.gui.layout)) and (IsValid(scoreboard.gui.layout.actions)) then 
				scoreboard.gui.layout.actions:Remove();
			end 
			
			CloseDermaMenus()
		end

		gui.EnableScreenClicker(false)
		return true
	end 
	
	hook.Add("ScoreboardHide", "hl2rp: scoreboard", hideScoreboard);
	
	local function showScoreboard()
		if (IsValid(scoreboard.gui)) then
			scoreboard.gui:SetVisible(true)
		else
			vgui.Create("nutScoreboard")
		end

		gui.EnableScreenClicker(true)
		return true
	end 	
	
	hook.Add("ScoreboardShow", "hl2rp: scoreboard", showScoreboard);
end 