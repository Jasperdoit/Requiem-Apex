if (SERVER) then
	resource.AddSingleFile( "resource/fonts/RobotoMono.ttf" );
	resource.AddSingleFile( "resource/fonts/VCRMono.ttf" );
   	resource.AddFile( "wpmarker.vmt");
end
loadGamemode = {}

local basefol = "modules/"

function loadGamemode:gay(modulenm)
    local full_folder = basefol
    if modulenm and modulenm ~= "" then
        full_folder = full_folder .. modulenm
    end

    local files, folders = file.Find(full_folder .. "*", "LUA")

    -- Recursive file search
    for _, ifolder in ipairs(folders) do
        self:gay(modulenm .. ifolder .. "/")
    end

    for _, shfile in ipairs(file.Find(full_folder .. "sh_*.lua", "LUA")) do
        --GM.Debug("oading sh module " .. full_folder ..shfile)
        if SERVER then AddCSLuaFile(full_folder .. shfile) end
        include(full_folder .. shfile)
    end

    if SERVER then
        for _, svfile in ipairs(file.Find(full_folder .. "sv_*.lua", "LUA")) do
            --GM.Debug("Loading sv module " .. svfile)
            include(full_folder .. svfile)
        end
    end

    for _, clfile in ipairs(file.Find(full_folder .. "cl_*.lua", "LUA")) do
        --GM.Debug("Loading cl module " .. clfile)
        if SERVER then AddCSLuaFile(full_folder .. clfile) end
        if CLIENT then include(full_folder .. clfile) end
    end
end

timer.Simple(1, function()
	loadGamemode:gay("");
end );