----------------------------------------
-- NetMessage Declaration
----------------------------------------

----------------------------------------
-- Functions
----------------------------------------
function citizenship:set(...)
    local arg = {...}
    if arg == {} then return end
    local wantedlist = {}
    for k, ply in pairs(arg) do
        if not self:validTarget(ply) then continue end

        if ply:GetNWBool("citizenshipRevoked", false) then
            ply:SetNWBool("citizenshipRevoked", false)
        else
            ply:SetNWBool("citizenshipRevoked", true )
            table.insert(wantedlist, ply:Name())
        end
    end
    if table.IsEmpty(wantedlist) then return end
    self:notifyPlayers(wantedlist)
end

function citizenship:setMalignant(...)
    local arg = {...}
    if arg == {} then return end
    local wantedlist = {}
    for k, ply in pairs(arg) do
        if not self:validTarget(ply) then continue end

        if ply:GetNWBool("citizenshipRevoked", false) then
            continue
        else
            ply:SetNWBool("citizenshipRevoked", true )
            table.insert(wantedlist, ply:Name())
        end
    end
    if table.IsEmpty(wantedlist) then return end
    self:notifyPlayers(wantedlist)
end

function citizenship:silentSet(...)
    -- local arg = {...}
    local wantedlist = {}
    for k, ply in pairs(arg) do
        if not self:validTarget(ply) then continue end

        if ply:GetNWBool("citizenshipRevoked", false) then
            ply:SetNWBool("citizenshipRevoked", false)
        else
            ply:SetNWBool("citizenshipRevoked", true )
            table.insert(wantedlist, ply:Name())
        end
    end
end

function citizenship:getAll(caller)
    local textmode = false
    if caller and caller:IsValid() then
        textmode = true
    end

    if textmode then
        caller:ChatPrint("The following players are malignant: ")
    else
        print("The following players are malignant: ")
    end

    for k, ply in pairs(player.GetHumans()) do
        if ply:GetNWBool("citizenshipRevoked", false) then
            if textmode then
                caller:ChatPrint(ply:Name())
            else
                print(ply:Name())
            end
        end
    end
    if table.IsEmpty(wantedlist) then return end
    self:notifyPlayers(wantedlist)
end

concommand.Add("rg_getallcitizenship", function(ply)
    if not ply:IsValid() then
        citizenship:getAll()
    end
    if (ply.nextcitizenshiptime or 0) > CurTime() then return end
    ply.nextcitizenshiptime = CurTime() + 1
    if ply:IsValid() and not ply:IsAdmin() then return end
    citizenship:getAll(ply)

end)

function citizenship:validTarget(ply)
    return ply:IsValid() and ply:IsPlayer() and (ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU) and ply:Alive()
end

function citizenship:resetPlayers()
    for _, ply in pairs(player.GetHumans()) do
        ply:SetNWBool("citizenshipRevoked", false)
    end
end

function citizenship:notifyPlayers(wantedplayers)
    if not wantedplayers or wantedlist == {} then return end
    wantedplayerstring = ""
    for _, wantedplayer in pairs(wantedplayers) do
        wantedplayerstring = wantedplayerstring .. wantedplayer .. ", "
    end
    wantedplayerstring = string.Left(wantedplayerstring, #wantedplayerstring - 2)
    for _, ply in pairs(player.GetHumans()) do
        ply:SendLua("LocalPlayer():EmitSound('npc/overwatch/cityvoice/f_citizenshiprevoked_6_spkr.wav', 55, 100, .6)")
        -- ply:sendMsg(Color(255,0,0), "IGNORE THE FOLLOWING DISPATCH:")
        ply:sendMsg(Color(0,0,255), "Dispatch", Color(255,255,255), ": Attention: " .. wantedplayerstring .. ". Your Citizenship has been ", Color(255, 0, 0), "REVOKED", Color(255,255,255), ". Status: ", Color(255,0,0), "MALIGNANT", Color(255,255,255), ".")
    end
end

----------------------------------------
-- ConCommands
----------------------------------------

concommand.Add("rg_setcitizenship", function(ply, cmd, args)
    if (ply.nextcitizenshiptime or 0) > CurTime() then return end
    ply.nextcitizenshiptime = CurTime() + 1
    if ply:IsValid() and not ply:IsAdmin() then return end
    if not args then return end
    local playerlist = {}
    for _, target in pairs(player.GetHumans()) do
        if table.HasValue(args, target:Name()) then
            table.insert(playerlist, target)
        end
    end
    citizenship:set(unpack(playerlist))
end)

concommand.Add("rg_setmalignant", function(ply, cmd, args)
    if (ply.nextcitizenshiptime or 0) > CurTime() then return end
    ply.nextcitizenshiptime = CurTime() + 1
    if ply:IsValid() and not ply:IsAdmin() then return end
    if not args then return end
    local playerlist = {}
    for _, target in pairs(player.GetHumans()) do
        if table.HasValue(args, target:Name()) then
            table.insert(playerlist, target)
        end
    end
    citizenship:setMalignant(unpack(playerlist))
end)

concommand.Add("rg_setsilentcitizenship", function(ply, cmd, args)
    if (ply.nextcitizenshiptime or 0) > CurTime() then return end
    ply.nextcitizenshiptime = CurTime() + 1
    if ply:IsValid() and not ply:IsAdmin() then return end
    if not args then return end
    local playerlist = {}
    for _, target in pairs(player.GetHumans()) do
        if table.HasValue(args, target:Name()) then
            table.insert(playerlist, target)
        end
    end
    citizenship:setSilent(unpack(playerlist))
end)

concommand.Add("rg_resetallcitizenship", function(ply, cmd, args)
    if (ply.nextcitizenshiptime or 0) > CurTime() then return end
    ply.nextcitizenshiptime = CurTime() + 1
    if ply:IsValid() and not ply:IsAdmin() then return end
    citizenship:resetPlayers()
end)

----------------------------------------
-- Hooks
----------------------------------------

hook.Add("PlayerSpawn", "[citizenship] : Reset Status", function(ply)
    ply:SetNWBool("citizenshipRevoked", false)
end)