local time = (CODE_LIST[GetGlobalInt("code", 1)].timer or 0) + GetGlobalInt("codetime", 0)
local code = GetGlobalInt("code", 1)

local flash = 0
local offset = 0
local Desired = 130

local delayBetween = 1.5

print(GetGlobalInt("code"))

for k, v in pairs(CODE_LIST) do
    if v.onHooks then
        for k, v in pairs(v.onHooks) do
            hook.Remove(k, "cityCodeHook")
        end
    end
end

local convar = CreateClientConVar("cl_code_offset", "40", true, false, "Sets the height offset for the code")
local tax = CreateClientConVar("cl_code_tax", "1", true, false, "Sets whether the tax should be appended onto the code")
local size = CreateClientConVar("cl_code_size", "10", true, false, "Sets the font size of the code")
local showfcode = CreateClientConVar("cl_code_show", "1", true, false, "Sets the font size of the code", 0, 1)

local function ResizeFonts(size)
    size = math.max(4, math.min(size, 16))

    surface.CreateFont("code_city", {
        font = "VCR OSD Mono", 
        size = ScreenScale(size),
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
    })

    surface.CreateFont("code_zone", {
        font = "VCR OSD Mono", 
        size = ScreenScale(size-4),
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
    })
end

ResizeFonts(size:GetInt())

cvars.AddChangeCallback("cl_code_size", function(convar, oldValue, newValue)

    local val = tonumber(newValue) or 0
    ResizeFonts(val)

end)


hook.Add("Tick", "fcode", function()
    
    if !IsValid(LocalPlayer()) then return end
    if code != GetGlobalInt("code", 1) then 
        LocalPlayer().transTime = LocalPlayer().transTime or 0

        if LocalPlayer().transTime < CurTime() then
            LocalPlayer().transTime = CurTime() + delayBetween
        end

        LocalPlayer().transition = true
        LocalPlayer().code = GetGlobalInt("code", 1)
        LocalPlayer().time = GetGlobalInt("codetime", 0)
	end

    LocalPlayer().codeBefore = LocalPlayer().codeBefore or GetGlobalInt("code", 1)

    

    if LocalPlayer().codeBefore != GetGlobalInt("code", 1) && CODE_LIST[LocalPlayer().codeBefore] then
        if isfunction(CODE_LIST[GetGlobalInt("code", 1)].onActivated) then
            local err, arg = pcall(CODE_LIST[GetGlobalInt("code", 1)].onActivated)
            if (!err) then
                print(arg)
            end
        end

        if isfunction(CODE_LIST[LocalPlayer().codeBefore].onDisabled) then
            local err, arg = pcall(CODE_LIST[LocalPlayer().codeBefore].onDisabled, LocalPlayer().codeBefore)
            if (!err) then
                print(arg)
            end
        end

        if CODE_LIST[LocalPlayer().codeBefore].onHooks then
            for k, v in pairs(CODE_LIST[LocalPlayer().codeBefore].onHooks) do
                hook.Remove(k, "cityCodeHook")
            end
        end

        if CODE_LIST[GetGlobalInt("code", 1)].onHooks then
            local code = CODE_LIST[GetGlobalInt("code", 1)]
            for k, v in pairs(CODE_LIST[GetGlobalInt("code", 1)].onHooks) do
                hook.Add(k, "cityCodeHook", function(...)
                    v(code, ...)
                end)
            end
        end

        if CODE_LIST[GetGlobalInt("code", 1)].timer && isfunction(CODE_LIST[GetGlobalInt("code", 1)].onTimerEnd) then
            timer.Create("CityCodeThing", (CODE_LIST[GetGlobalInt("code", 1)].timer + GetGlobalInt("codetime", 0))-CurTime(), 1, CODE_LIST[GetGlobalInt("code", 1)].onTimerEnd)
        else
            timer.Remove("CityCodeThing")
        end
    end

    LocalPlayer().codeBefore = GetGlobalInt("code", 1)
	
end)

local function CodeHUD()
    if not CODE_LIST[GetGlobalInt("code", 1)] then return end
    --if type(WHITELISTED_TEAMS[LocalPlayer():Team()]) != "boolean" then return end
    local shouldshowfcode = GetConVar("cl_code_show"):GetInt() or 1
    if shouldshowfcode == 0 then return end
    time = (CODE_LIST[GetGlobalInt("code", 1)].timer or 0) + GetGlobalInt("codetime", 0)

    local cd = CODE_LIST[code]
    local ply = LocalPlayer()
    local name
    --local tax = (cd.showTax != false && tax:GetBool()) && " (Salary taxed at "..GetGlobalInt("tax",0).."%)" || ""
    if not time || time-CurTime() != math.abs(time-CurTime()) then
        name = "Socio-code: " .. cd.name
		--name = "Socio-code: "..cd.name..tax
    else
        name = "Socio-code: " .. cd.name .. " (" ..string.FormattedTime(time-CurTime(), "%02i:%02i").. ")"
       -- name = "Socio-code: "..cd.name.." ("..string.FormattedTime(time-CurTime(), "%02i:%02i")..")"..tax
    end
    surface.SetFont("code_city")

    if LocalPlayer().transition then
        offset = Lerp(RealFrameTime()*3, offset, -70-surface.GetTextSize(name))
        
        LocalPlayer().transTime = LocalPlayer().transTime or CurTime() + delayBetween
        
        if LocalPlayer().transTime < CurTime() then
            LocalPlayer().offset = offset
            LocalPlayer().transition = false
            code = LocalPlayer().code
            if CODE_LIST[LocalPlayer().code] && CODE_LIST[LocalPlayer().code].timer then
                if not tonumber(LocalPlayer().time) then LocalPlayer().time = CurTime() end
                time = CODE_LIST[LocalPlayer().code].timer + LocalPlayer().time
            else
                time = false
            end
        end
    else
        offset = Lerp(RealFrameTime()*3.5, offset, 0)
    end

    local sizeX, sizeY = surface.GetTextSize(name)

    draw.RoundedBox(0, 0+offset, convar:GetInt(), 38+sizeX, sizeY, Color(0, 0, 0, 150))

    --surface.SetDrawColor(Color(255,255,255,255))
   -- surface.SetMaterial(cd.icon)
    --surface.DrawTexturedRect(8+offset, convar:GetInt()+sizeY/2-8, 16, 16)

    surface.SetDrawColor(Color(0, 0, 0, 150))
    draw.NoTexture()
    surface.DrawPoly({
        { x = 38+offset+surface.GetTextSize(name), y = convar:GetInt()+sizeY },
        { x = 38+offset+surface.GetTextSize(name), y = convar:GetInt() },
        { x = 70+offset+surface.GetTextSize(name), y = convar:GetInt()+sizeY },
    })

    flash = 0 -- Deprecated

    local col = Color(math.Clamp(cd.color.r+flash, 0, 255), math.Clamp(cd.color.g+flash, 0, 255), math.Clamp(cd.color.b+flash, 0, 255))

    draw.DrawText(name, "code_city", 5 + offset, convar:GetInt(), col, TEXT_ALIGN_LEFT)
    local sizeReturn = 0
    local first = true

    for k, v in SortedPairs(CITY_ZONES) do
        if LocalPlayer():Team() ~= TEAM_CP and LocalPlayer():Team() ~= TEAM_OVERWATCH and LocalPlayer():Team() ~= TEAM_DISPATCH and LocalPlayer():Team() ~= TEAM_ADMINISTRATOR and LocalPlayer():Team() ~= TEAM_CONSCRIPT and not LocalPlayer():IsAdmin() then continue end
        if cd.hideZones then continue end
        local cd = CODE_ZONES[GetGlobalString("code_"..k, "func")]
        local name = v.name.." Status: "..cd.name
       
        surface.SetFont(cd.font or "code_zone")

        local x, y = surface.GetTextSize(name)

        local positionOnScreen = convar:GetInt() + sizeY + sizeReturn

        cd.static = cd.static or {}
        cd.static[k] = cd.static[k] or {}

        cd.static[k].code = cd

        if !isfunction(cd.boxRender) then
            draw.RoundedBox(0, offset, positionOnScreen, 10 + x, y, Color(0, 0, 0, 150))
        else
            local noErr, err = pcall(cd.boxRender, cd.static[k], offset, positionOnScreen, 38+x, y)

            if !noErr then
                print(err)
            end

            if isnumber(err) then
                sizeReturn = sizeReturn + err
                positionOnScreen = positionOnScreen + err
            end
        end

        --surface.SetDrawColor(Color(255,255,255,255))
       -- surface.SetMaterial(cd.icon)
       -- surface.DrawTexturedRect(8+offset, positionOnScreen+y/2-6, 12, 12)

        local col = Color(math.Clamp(cd.color.r+flash, 0, 255), math.Clamp(cd.color.g+flash, 0, 255), math.Clamp(cd.color.b+flash, 0, 255))

        
        if !isfunction(cd.textRender) then
            draw.DrawText(name, cd.font or "code_zone", 5+offset, positionOnScreen, col, TEXT_ALIGN_LEFT)
        else
            local noErr, err = pcall(cd.textRender, cd.static[k], name, col, 5+offset, positionOnScreen, cd.font or "code_zone")

            if !noErr then
                print(err)
            end
        end
        
        sizeReturn = sizeReturn + y
    end
end

hook.Add("HUDPaint", "codeDisplay", CodeHUD)